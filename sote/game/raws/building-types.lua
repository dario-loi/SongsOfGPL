local tabb = require "engine.table"

---@class BuildingType
---@field name string
---@field icon string
---@field description string
---@field r number
---@field g number
---@field b number
---@field production_method ProductionMethod
---@field construction_cost number
---@field upkeep number
---@field unlocked_by Technology
---@field required_biome table<number, Biome>
---@field required_resource table<number, Resource>
---@field unique boolean only one per province!
---@field government boolean only the government can build this building!
---@field tile_improvement boolean
---@field needed_infrastructure number
---@field ai_weight number how much the AI will prioritize building this building
---@field spotting number The amount of "spotting" a building provides. Spotting is used in warfare. Higher spotting makes it more difficult for foreign armies to sneak in.
---@field new fun(self:BuildingType, o:BuildingType):BuildingType
---@field get_tooltip fun(self:BuildingType):string

---@class BuildingType
BuildingType = {}
BuildingType.__index = BuildingType
---Creates a new building
---@param o BuildingType
---@return BuildingType
function BuildingType:new(o)
	print("BuildingType: " .. o.name)
	---@type BuildingType
	local r = {}

	r.name = "<building type>"
	r.icon = 'uncertainty.png'
	r.description = "<building type description>"
	r.r = 0
	r.g = 0
	r.b = 0
	r.construction_cost = 0
	r.upkeep = 0
	r.required_biome = {}
	r.required_resource = {}
	r.unique = false
	r.government = false
	r.tile_improvement = false
	r.needed_infrastructure = 0
	r.ai_weight = 1
	r.spotting = 0

	for k, v in pairs(o) do
		r[k] = v
	end
	setmetatable(r, BuildingType)
	if RAWS_MANAGER.building_types_by_name[r.name] ~= nil then
		local msg = "Failed to load a building types (" .. tostring(r.name) .. ")"
		print(msg)
		error(msg)
	end
	RAWS_MANAGER.building_types_by_name[r.name] = r
	return r
end

function BuildingType:get_tooltip()
	local s = self.description

	s = s .. "\n\nBase cost: " .. tostring(self.construction_cost) .. MONEY_SYMBOL
	s = s .. "\n\nUpkeep: " .. tostring(self.upkeep) .. MONEY_SYMBOL

	if self.production_method then
		if tabb.size(self.production_method.jobs) > 0 then
			s = s .. "\n\nJobs: "
			for job, count in pairs(self.production_method.jobs) do
				s = s .. job.name .. " (" .. tostring(count) .. "), "
			end
		end
		if tabb.size(self.production_method.inputs) > 0 then
			s = s .. "\n\nInputs: "
			for inp, count in pairs(self.production_method.inputs) do
				s = s .. inp.name .. " (" .. tostring(count) .. "), "
			end
		end
		if tabb.size(self.production_method.outputs) > 0 then
			s = s .. "\n\nOutputs: "
			for out, count in pairs(self.production_method.outputs) do
				s = s .. out.name .. " (" .. tostring(count) .. "), "
			end
		end
	end

	if self.needed_infrastructure > 0 then
		s = s .. "\n\nNeeded infrastructure: " .. tostring(self.needed_infrastructure)
	end

	if self.spotting > 0 then
		s = s .. "\n\nSpotting: " .. tostring(self.spotting)
	end

	return s
end

return BuildingType
