--A Lua tube script that checks if items are processable by the biofuel refinery and sends them to an appropriate channel.
-- Requires a delay line


--Side to send compatible items to
local sCompatible = "white"
-- Side to send incompatible items to
local sIncompatible = "blue"
--Side to send items awaiting response from the CraftDB
local sDelay = "green"
--Are food items accepted by biofuel refineries?
local foodAccepted = false
--CraftDB channel. Quereies are sent there.
local cDB = "cdb"

--WORKS BELOW - DO NOT CHANGE ANYTHING BELOW THIS LINE

local convertible_groups = {
	'flora', 'leaves', 'flower', 'sapling', 'tree', 'wood', 'stick', 'plant', 'seed',
	'leafdecay', 'leafdecay_drop', 'mushroom', 'vines'
}
local convertible_nodes = {
	'default:cactus', 'default:large_cactus_seedling',												-- default cactus
	'default:bush_stem', 'default:pine_bush_stem', 'default:acacia_bush_stem',						-- default bush stem
	'farming:cotton', 'farming:string', 'farming:wheat', 'farming:straw',							-- farming
	'farming:hemp_leaf', 'farming:hemp_block', 'farming:hemp_fibre', 'farming:hemp_rope', 			-- farming_redo hemp
	'farming:mint_leaf','farming:garlic', 'farming:peas', 'farming:pepper', 						-- farming_redo
	'farming:barley', 'farming:jackolantern', 'farming:rye', 'farming:oat', 'farming:rice', 
	'default:papyrus', 'default:dry_shrub', 'default:marram_grass_1', 'default:sand_with_kelp',		-- default
	'pooper:poop_turd', 'pooper:poop_pile',															-- pooper
	'cucina_vegana:flax', 'cucina_vegana:flax_roasted', 'cucina_vegana:sunflower',					-- cucina_vegana
	'cucina_vegana:soy', 'cucina_vegana:chives', 'cucina_vegana:corn', 'cucina_vegana:chili',
	'cucina_vegana:onion', 'cucina_vegana:banana', 'cucina_vegana:carrot', 'cucina_vegana:garlic',
	'cucina_vegana:potato', 'cucina_vegana:tomato', 'cucina_vegana:cucumber', 'cucina_vegana:strawberry',
	'cucina_vegana:vine_grape', 'cucina_vegana:coffee_beans_raw',
	'vines:vines', 'vines:vine', 'vines:rope', 'vines:rope_block',									-- Vines
	'trunks:moss_plain_0', 'trunks:moss_with_fungus_0', 'trunks:twig_1', 
	'bushes:BushLeaves1', 'bushes:BushLeaves2', 
	'dryplants:grass', 'dryplants:hay', 'dryplants:reed', 'dryplants:reedmace_sapling', 'dryplants:wetreed',
	'poisonivy:climbing', 'poisonivy:seedling', 'poisonivy:sproutling',
}

local convertible_food = {
	'farming:bread', 'farming:flour',																-- default food
	'farming:pineapple', 'farming:pineapple_ring', 'farming:potato',
	'farming:rice_flour', 'farming:blueberry_pie',
	'farming:bread_multigrain', 'farming:flour_multigrain', 'farming:baked_potato',					-- farming_redo
	'farming:beetroot_soup', 'farming:bread_slice', 'farming:chili_bowl', 'farming:chocolate_block',
	'farming:chocolate_dark', 'farming:cookie', 'farming:corn_cob', 'farming:cornstarch',
	'farming:muffin_blueberry', 'farming:pea_soup', 'farming:potato_salad', 'farming:pumpkin_bread',
	'farming:pumpkin_dough', 'farming:rhubarb_pie', 'farming:rice_bread', 'farming:toast',
	'farming:toast_sandwich', 'farming:garlic_braid', 'farming:onion_soup', 
	'farming:sugar', 'farming:turkish_delight', 'farming:garlic_bread', 'farming:donut',
	'farming:donut_chocolate', 'farming:donut_apple', 'farming:porridge', 'farming:jaffa_cake',
	'farming:apple_pie', 'farming:pasta', 'farming:spaghetti', 'farming:bibimbap', 'farming:flan',
	'farming:tofu', 'farming:gyoza', 'farming:mochi', 'farming:salad', 'farming:burger', 'farming:paella',
	'farming:caramel', 'farming:onigiri', 'farming:popcorn', 'farming:sugar_cube', 'farming:carrot_gold',
	'farming:tofu_cooked', 'farming:tomato_soup', 'farming:cheese_vegan', 'farming:chili_powder',
	'farming:potato_omelet', 'farming:mac_and_cheese', 'farming:gingerbread_man', 'farming:sunflower_bread',
	'farming:spanish_potatoes', 'farming:sunflower_seeds_toasted', 
	'wine:agave_syrup', 																			-- Wine
	'cucina_vegana:asparagus', 'cucina_vegana:asparagus_hollandaise', 								-- cucina_vegana
	'cucina_vegana:asparagus_hollandaise_cooked', 'cucina_vegana:asparagus_rice', 'cucina_vegana:asparagus_rice_cooked',
	'cucina_vegana:asparagus_soup_cooked', 'cucina_vegana:asparagus_soup', 'cucina_vegana:blueberry_jam',
	'cucina_vegana:blueberry_pot', 'cucina_vegana:blueberry_pot_cooked', 'cucina_vegana:blueberry_puree',
	'cucina_vegana:bowl_rice', 'cucina_vegana:bowl_rice_cooked', 'cucina_vegana:ciabatta_bread', 
	'cucina_vegana:ciabatta_dough', 'cucina_vegana:dandelion_honey', 'cucina_vegana:dandelion_suds',
	'cucina_vegana:dandelion_suds_cooking', 'cucina_vegana:edamame', 'cucina_vegana:edamame_cooked',
	'cucina_vegana:fish_parsley_rosemary', 'cucina_vegana:fish_parsley_rosemary_cooked', 'cucina_vegana:fryer',
	'cucina_vegana:fryer_raw', 'cucina_vegana:imitation_butter', 'cucina_vegana:imitation_cheese',
	'cucina_vegana:imitation_fish', 'cucina_vegana:imitation_meat', 'cucina_vegana:imitation_poultry',
	'cucina_vegana:kohlrabi', 'cucina_vegana:kohlrabi_roasted', 'cucina_vegana:kohlrabi_soup',
	'cucina_vegana:kohlrabi_soup_cooked', 'cucina_vegana:lettuce', 'cucina_vegana:molasses', 'cucina_vegana:parsley',
	'cucina_vegana:peanut', 'cucina_vegana:peanut_butter', 'cucina_vegana:pizza_dough', 'cucina_vegana:pizza_funghi',
	'cucina_vegana:pizza_funghi_raw', 'cucina_vegana:pizza_vegana', 'cucina_vegana:pizza_vegana_raw',
	'cucina_vegana:rice', 'cucina_vegana:rice_flour', 'cucina_vegana:rosemary', 'cucina_vegana:salad_bowl', 
	'cucina_vegana:salad_hollandaise', 'cucina_vegana:sauce_hollandaise', 'cucina_vegana:soy_milk',
	'cucina_vegana:soy_soup', 'cucina_vegana:soy_soup_cooked', 'cucina_vegana:sunflower_seeds_bread',
	'cucina_vegana:sunflower_seeds_dough', 'cucina_vegana:sunflower_seeds_flour', 'cucina_vegana:sunflower_seeds_roasted',
	'cucina_vegana:tofu', 'cucina_vegana:tofu_cooked', 'cucina_vegana:tofu_chives_rosemary',
	'cucina_vegana:tofu_chives_rosemary_cooked', 'cucina_vegana:vegan_sushi'
}

if event.type == "program" then
	--Set up the tube
	mem.cache = {}
	for _, row in pairs(convertible_nodes) do
		mem.cache[row] = sCompatible
	end
	if foodAccepted then
		for _, row in pairs(convertible_food) do
			mem.cache[row] = sCompatible
		end
	end
end
if event.type == "item" then
	--Got an item
	local item = event.item.name
	
	--Check the cache first
	local lookup = mem.cache[item]
	if lookup then return lookup end

	--Unknown, have to ask
	digiline_send(cDB, { command = "search_items", name = item, substring_match=false, want_groups=true})
	return sDelay
end
if event.type == "digiline" and event.channel == cDB then
	--Got response from the CraftDB
	for item, data in pairs(event.msg) do
		local accepted = false
		for group, v in pairs(data.groups) do
			for k2, group2 in pairs(convertible_groups) do
				if group == group2 then accepted = true end
			end
		end
		mem.cache[item] = accepted and sCompatible or sIncompatible
	end
end
