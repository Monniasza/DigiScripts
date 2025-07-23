--A script to take lava cans and freeze lava from them into obsidian
--Digiline channel for block breaker
local breaker = "breaker"
--Digiline channel for deployer
local deployer = "deployer"
--Digiline channel for filter-injector that takes lava cans
local taker = "takenew"
--Digiline channel for filter-injector that takes empty or semi-empty lava cans from the deployer
local puller = "inj"
--Side to which send unsupported items and empty lava cans
local rejectsSide = "green"
--Side to which send lava cans to the deployer
local cansSide = "white"

if event.type == "item" then
	--Item arrival
	if event.item.name ~= "technic:lava_can" then return rejectsSide end
	if event.item.wear == 0 then
		digiline_send("takenew", {})
		return rejectsSide end
	return cansSide
else
	--Periodic interrupt
 interrupt(5)
	digiline_send(deployer, 'activate')
 digiline_send(breaker, 'activate')
	digiline_send(puller, {})
end
