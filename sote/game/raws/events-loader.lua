local tabb = require "engine.table"
local ll = {}

function ll.load()
	local Event = require "game.raws.events"

	-- For automatic events:
	-- 1. Roll against << base_probability >>
	-- 2. Check << trigger >>
	-- 3. Apply << on_trigger >>
	-- ...
	-- For events in the queue
	-- 1. Check if it applies to the player
	-- 2. If it doesn't, get the option with the highest ai score
	-- 3. Apply

	print("lack needs events")
	require "game.raws.events.lack-events" ()

	print("war events")
	require "game.raws.events.war-events" ()

	print("outlaw events")
	require "game.raws.events.outlaw-events" ()

	print("raid events")
	require "game.raws.events.raid-events" ()

	print("misc. events")
	require "game.raws.events.coup" ()

	print("interpersonal events")
	require "game.raws.events.interpersonal"()
end

return ll
