local utils = require "game.raws.raws-utils"

local Decision = {}

---@class DecisionRealm
Decision.Realm = {}
Decision.Realm.__index = Decision.Realm

Decision.Character = {}
Decision.Character.__index = Decision.Character

---@alias DecisionTarget 'none' | 'character' | 'tile' | 'province' | 'realm' | 'building'



---@class DecisionRealm
---@field new fun(self:DecisionRealm, o:DecisionRealm):DecisionRealm
---@field primary_target DecisionTarget
---@field secondary_target DecisionTarget
---@field sorting number Controls how high or how low on the list of available decisions this decision is in the UI
---@field name string
---@field ui_name string
---@field tooltip fun(root:Realm, primary_target:any):string
---@field effect fun(root:Realm, primary_target:any, secondary_target:any) Called when the action is taken
---@field pretrigger fun(root:Realm):boolean A quick check before any other checks to cull potential decision takers
---@field clickable fun(root:Realm, primary_target:any):boolean Determines whether or not the decision is visible to the player. Unsuccessful naming. Comment is correct.
---@field available fun(root:Realm, primary_target:any, secondary_target:any):boolean Determines whether or not the decision can be taken ("clicked" by the player) Unsuccessful naming. Comment is correct.
---@field ai_will_do fun(root:Realm, primary_target:any, secondary_target:any):number Returns a probability that an AI will take the decision
---@field ai_targetting_attempts number Number of attempts an AI will take to find a secondary target
---@field ai_target fun(root:Realm):any,boolean Selects the primary target for the AI
---@field ai_secondary_target fun(root:Realm, primary_target:any):any,boolean Selects the secondary target for the AI
---@field base_probability number Base chance that the AI will consider this decision each month at all (before any other checks). Use this to cull decisions.
---@field get_secondary_targets fun(root:Realm, primary_target:any):table<number, any> Returns potential targets FOR THE PLAYER

---@class DecisionCharacter
---@field new fun(self:DecisionCharacter, o:DecisionCharacter):DecisionCharacter
---@field primary_target DecisionTarget
---@field secondary_target DecisionTarget
---@field sorting number Controls how high or how low on the list of available decisions this decision is in the UI
---@field name string
---@field ui_name string
---@field tooltip fun(root:Character, primary_target:any):string
---@field effect fun(root:Character, primary_target:any, secondary_target:any) Called when the action is taken
---@field pretrigger fun(root:Character):boolean A quick check before any other checks to cull potential decision takers
---@field clickable fun(root:Character, primary_target:any):boolean Determines whether or not the decision is visible to the player. Unsuccessful naming. Comment is correct.
---@field available fun(root:Character, primary_target:any, secondary_target:any):boolean Determines whether or not the decision can be taken ("clicked" by the player) Unsuccessful naming. Comment is correct.
---@field ai_will_do fun(root:Character, primary_target:any, secondary_target:any):number Returns a probability that an AI will take the decision
---@field ai_targetting_attempts number Number of attempts an AI will take to find a secondary target
---@field ai_target fun(root:Character):any,boolean Selects the primary target for the AI
---@field ai_secondary_target fun(root:Character, primary_target:any):any,boolean Selects the secondary target for the AI
---@field base_probability number Base chance that the AI will consider this decision each month at all (before any other checks). Use this to cull decisions.
---@field get_secondary_targets fun(root:Character, primary_target:any):table<number, any> Returns potential targets FOR THE PLAYER


local function init_decision(i)
	local o = {}
	o.name = "<decision>"
	o.ui_name = "decision"
	o.tooltip = utils.constant_string("This is a decision!")
	o.primary_target = 'none'
	o.secondary_target = 'none'
	o.sorting = 1
	o.base_probability = 1.0 / 12.0 -- Base probability of once a year
	o.ai_targetting_attempts = 1
	o.effect = function(root, primary_target, secondary_target)
		print("Decision taken!")
	end
	o.pretrigger = function(root)
		return true
	end
	o.clickable = function(root, primary)
		return true
	end
	o.available = function(root, primary, secondary)
		return true
	end
	o.ai_will_do = function(root, primary, secondary)
		return 1
	end
	o.ai_target = function(root)
		return nil, true
	end
	o.ai_secondary_target = function(root)
		return nil, true
	end
	o.get_secondary_targets = function(root, primary)
		return {}
	end
	for k, v in pairs(i) do
		o[k] = v
	end	
	return o
end



---@return DecisionRealm
function Decision.Realm:new(i)
	---@type DecisionRealm
	local o = init_decision(i)

	setmetatable(o, Decision.Realm)

	if RAWS_MANAGER.decisions_by_name[o.name] ~= nil then
		local msg = "Failed to load a decision (" .. tostring(o.name) .. ")"
		print(msg)
		error(msg)
	end

	RAWS_MANAGER.decisions_by_name[o.name] = o
	return o
end

---@return DecisionCharacter
function Decision.Character:new(i)
	---@type DecisionCharacter
	local o = init_decision(i)

	setmetatable(o, Decision.Character)

	if RAWS_MANAGER.decisions_characters_by_name[o.name] ~= nil then
		local msg = "Failed to load a decision (" .. tostring(o.name) .. ")"
		print(msg)
		error(msg)
	end

	RAWS_MANAGER.decisions_characters_by_name[o.name] = o
	return o
end


return Decision
