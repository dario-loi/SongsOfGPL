
---@class RawsManager
---@field biomes_by_name table<string, Biome>
---@field biomes_load_order table<number, Biome>
---@field bedrocks_by_name table<string, Bedrock>
---@field bedrocks_by_color table<number, Bedrock>
---@field biogeographic_realms_by_name table<string, BiogeographicRealm>
---@field biogeographic_realms_by_color table<number, BiogeographicRealm>
---@field races_by_name table<string, Race>
---@field building_types_by_name table<string, BuildingType>
---@field trade_goods_by_name table<string, TradeGood>
---@field jobs_by_name table<string, Job>
---@field technologies_by_name table<string, Technology>
---@field production_methods_by_name table<string, ProductionMethod>
---@field resources_by_name table<string, Resource>
---@field decisions_by_name table<string, DecisionRealm>
---@field decisions_characters_by_name table<string, DecisionCharacter>
---@field events_by_name table<string, Event>
---@field unit_types_by_name table<string, UnitType>
local raws_manager = {}


---comment
---@return RawsManager
function raws_manager:new()
	local w = {}

    w.building_types_by_name = {}
	w.biomes_by_name = {}
	w.biomes_load_order = {}
	w.bedrocks_by_name = {}
	w.bedrocks_by_color = {}
	w.biogeographic_realms_by_name = {}
	w.biogeographic_realms_by_color = {}
	w.races_by_name = {}
	w.trade_goods_by_name = {}
	w.jobs_by_name = {}
	w.technologies_by_name = {}
	w.production_methods_by_name = {}
	w.resources_by_name = {}
	w.decisions_by_name = {}
	w.decisions_characters_by_name = {}
	w.events_by_name = {}
	w.unit_types_by_name = {}

    return w
end

return raws_manager