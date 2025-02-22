local ev = {}

---@param realm Realm
function ev.run(realm)
	for _, ev in pairs(RAWS_MANAGER.events_by_name) do
		if ev.automatic then
			if love.math.random() < ev.base_probability then
				if ev:trigger(realm.leader) then
					ev:on_trigger(realm.leader)
				end
			end
		end
	end
end

return ev
