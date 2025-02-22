local tabb = require "engine.table"
local co = {}

---@param province Province
---@param funds number
---@param excess number
---@return number
local function construction_in_province(province, funds, excess)
	local total_weight = 0
	for _, ty in pairs(province.buildable_buildings) do
		total_weight = total_weight + ty.ai_weight
	end

	if total_weight > 0 then
		local w = love.math.random() * total_weight
		local acc = 0
		---@type BuildingType
		local to_build = tabb.nth(province.buildable_buildings, 0) -- default to the first building
		for _, ty in pairs(province.buildable_buildings) do
			acc = acc + ty.ai_weight
			if acc > w then
				to_build = ty
				break
			end
		end

		-- Only build if there are unemployed pops...
		if to_build.production_method:total_jobs() <= province:get_unemployment() then
			local tile = nil
			if to_build.tile_improvement then
				local tt = tabb.size(province.tiles)
				tile = tabb.nth(province.tiles, love.math.random(tt))
			end
			if province.can_build(province, math.huge, to_build, tile) then
				-- If we don't have enough money, just adjust the likelihood (this will be easier on the AI and accurate on long term averages)
				if love.math.random() < funds / to_build.construction_cost then
					-- We can build! But only build if we have enough excess money to pay for the upkeep...
					if excess >= to_build.upkeep then
						--Only build if the efficiency isn't tiny (otherwise we could pull productive hunter gatherers from their jobs to unproductive farming jobs...)
						if to_build.production_method:get_efficiency(tile) > 0.65 then
							local Building = require "game.entities.building".Building
							Building:new(province, to_build, tile)
							funds = math.max(0, funds - to_build.construction_cost)
						end
					end
				end
			end
		end
	end
	return funds
end

---@param realm Realm
function co.run(realm)

	local excess = realm.monthly_education_investment + realm.treasury_real_delta -- Treat monthly education investments as an indicator of "free" income

	local funds = realm.treasury

	if excess > 0 then
		-- disabled for now, dunno if its worth making realm construction rare again
		if true or love.math.random() < 1.0 / 6.0 then
			for province in pairs(realm.provinces) do

				if WORLD:does_player_control_realm(realm) then
					-- Player realms shouldn't run their AI for building construction...
				else
					funds = construction_in_province(province, funds, excess)
				end
				-- Run construction using the AI for local wealth too!
				local prov = province.local_wealth
				province.local_wealth = construction_in_province(province, prov, 0) -- 0 "excess" so that pops dont bankrupt player controlled states with building upkeep...
			end
		end
	end

	realm.treasury = funds
end

return co
