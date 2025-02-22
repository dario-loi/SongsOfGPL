local tab = require "engine.table"
local ui = require "engine.ui"

-- Reloads the font used for rendering
local reload_font = require "game.ui-utils".reload_font

--- A table containing the passed arguments.
ARGS = {} -- note, hot loading won't overwrite ARGS because the declaration is empty
-- A table containing some basic asset references.
ASSETS = {}
-- A version string, kinda irrelevant now since multiplayer isn't a thing, lol
VERSION_STRING = "v0.3.0 (Midgard)"

--if WORLD == nil then
---@type World|nil
WORLD = nil
--end

---@type string
MONEY_SYMBOL = '§'

local bs = require "engine.bitser"
-- Extra classes
bs.registerClass('Queue', require "engine.queue")
-- Raws
bs.registerClass("Bedrock", require "game.raws.bedrocks")
bs.registerClass("BiogeographicRealm", require "game.raws.biogeographic-realms")
bs.registerClass("Biome", require "game.raws.biomes")
bs.registerClass("BuildingType", require "game.raws.building-types")
bs.registerClass("Job", require "game.raws.jobs")
bs.registerClass("ProductionMethod", require "game.raws.production-methods")
bs.registerClass("Race", require "game.raws.race")
bs.registerClass("Resource", require "game.raws.resources")
bs.registerClass("Technology", require "game.raws.technologies")
bs.registerClass("TradeGood", require "game.raws.trade-goods")
-- Entities
bs.registerClass("Building", require "game.entities.building".Building)
bs.registerClass("ClimateCell", require "game.entities.climate-cell".ClimateCell)
bs.registerClass("Culture", require "game.entities.culture".Culture)
bs.registerClass("CultureGroup", require "game.entities.culture".CultureGroup)
bs.registerClass("Language", require "game.entities.language".Language)
bs.registerClass("Plate", require "game.entities.plate".Plate)
bs.registerClass("POP", require "game.entities.pop".POP)
bs.registerClass("Province", require "game.entities.province".Province)
bs.registerClass("Realm", require "game.entities.realm".Realm)
bs.registerClass("RewardFlag", require "game.entities.realm".RewardFlag)
bs.registerClass("Religion", require "game.entities.religion".Religion)
bs.registerClass("Faith", require "game.entities.religion".Faith)
bs.registerClass("Tile", require "game.entities.tile".Tile)
bs.registerClass("World", require "game.entities.world".World)
bs.registerClass("Warband", require "game.entities.warband")
bs.registerClass('Army', require "game.entities.army")

--[[
local bs = require "engine.bitser"
local tile = require "game.entities.tile"
local ffi = require "ffi"
local ttt = ffi.new("Tile", 1000)
bs.dumpLoveFile("debug", ttt)
error("DONE!")
--]]

function love.load(args)
	love.math.setRandomSeed(1)

	tab.print(args)
	ARGS = tab.copy(args)
	-- Possible args:
	if tab.contains(ARGS, "--help") or
		tab.contains(ARGS, "--h") or
		tab.contains(ARGS, "-help") or
		tab.contains(ARGS, "-h") then

		print([[
Songs of the Eons, version ]] .. VERSION_STRING .. [[

Possible command line arguments:
-h/-help/--h/--help -- displays this message
--dev -- dev mode, uses the default world and ignores options, even if they exist
--windowed -- starts in windowed mode, regardless of settings
]])
		love.event.quit()
		return
	end

	-- Update the load path for "require"!
	local path = love.filesystem.getSourceBaseDirectory()
	package.path = package.path .. ";" .. tostring(path)

	-- A special global table that stores important assets.
	-- We create it here because we need to preload certain images and fonts for the UI
	ASSETS = {}
	reload_font()
	ASSETS.background = love.graphics.newImage("data/gfx/backgrounds/background.png")
	ASSETS.get_icon = function(ic)
		if ASSETS.icons[ic] == nil then
			error("Icon " .. tostring(ic) .. " isn't included with the game.")
		end
		return ASSETS.icons[ic]
	end

	-- TEST LOADING/SAVING
	-- print('test of bitser')
	-- local test_table = { abc= 123, x= 5}
	-- local test_table_2 = {abs = 456, y = 6}
	-- test_table.friend = test_table_2
	-- test_table_2.friend = test_table
	-- local friends_table = {test_table, test_table_2}

	-- require "engine.bitser".dumpLoveFile("test", friends_table)
	-- local result = require "engine.bitser".loadLoveFile("test")


	if tab.contains(args, "--dev") or not love.filesystem.getInfo("options.bin") then
		-- If the options file doesn't exists, or if we're in dev mode, create the options file!
		OPTIONS = require "game.options".init()
		require "game.options".save()
	else
		OPTIONS = require "game.options".load()
		require "game.options".verify()
	end

	if tab.contains(args, "--windowed") then
		love.window.setFullscreen(false)
	else
		if OPTIONS.fullscreen then
			love.window.setFullscreen(true)
		else
			love.window.setFullscreen(false)
		end
	end
	love.audio.setVolume(OPTIONS.volume)
	reload_font()

	require("game.scene-manager").init()
end

function love.update(dt)
	if tab.contains(ARGS, "--dev") then
		-- http://127.0.0.1:8000 <- to view lovebird
		require("engine.lovebird").update()
	end
	require("game.scene-manager").update(dt)
	require("game.music").update()
end

function love.draw()
	--print("oo")
	require("game.scene-manager").draw()
	ui.finalize_frame()
end

local input_counter = 0
function love.keypressed(key)
	local hot = require "engine.hot-load"
	if key == "f12" then
		local to_hotswap = require "__hot-load-targets"
		hot.limited_hotswap(to_hotswap)
	elseif key == "f9" then
		local ui_cache = ui.cache_input_state()
		local cached_game_state = GAME_STATE
		local hot_loadable_directories = {
			"engine",
			"data",
			"game",
		}
		local post_swap = {
			"__hot-load-targets",
			--"main",
		}
		hot.full_hotswap(hot_loadable_directories, post_swap);
		hot.full_hotswap(hot_loadable_directories, post_swap);
		(require "engine.ui").load_input_state_from_cache(ui_cache)
		GAME_STATE = cached_game_state
	elseif key == "f10" then
		-- This is used to check if the game responses to inputs...
		input_counter = input_counter + 1
		print("the game is responsive: " .. tostring(input_counter))
	elseif key == "f4" then
		love.window.setFullscreen(not love.window.getFullscreen())
		reload_font()
	end

	ui.on_keypressed(key)
end

function love.keyreleased(key)
	ui.on_keyreleased(key)
end

function love.mousepressed(x, y, button, istouch, presses)
	ui.on_mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	ui.on_mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	ui.on_mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	ui.on_wheelmoved(x, y)
end
