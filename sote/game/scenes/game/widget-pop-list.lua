local tabb = require "engine.table"
local ui = require "engine.ui"
local ut = require "game.ui-utils"

---@type TableState
local state = nil

local function init_state(base_unit)
    if state == nil then
        state = {
            header_height = base_unit,
            individual_height = base_unit,
            slider_level = 0,
            slider_width = base_unit,
            sorted_field = 1,
            sorting_order = true
        }
    else
        state.header_height = base_unit
        state.individual_height = base_unit
        state.slider_width = base_unit
    end
end

local function render_name(rect, k, v)
    ui.left_text(v.name, rect)
end

local function render_race(rect, k, v)
    ui.centered_text(v.race.name, rect)
end

local function pop_display_occupation(pop)
    local job = 'unemployed'
    if pop.job then
        job = pop.job.name
    elseif pop.age < pop.race.teen_age then
        job = 'child'
    elseif pop.drafted then
        job = 'warrior'
    end
    return job
end

local function pop_sex(pop)
    local f = 'm'
    if pop.female then f = 'f' end
    return f
end

return function(rect, base_unit, tile)
    return function()
        ---@type TableColumn[]
        local columns = {
            {
                header = '.',
                render_closure = function(rect, k, v)
                    ui.image(ASSETS.get_icon(v.race.icon), rect)
                end,
                width = base_unit * 1,
                value = function(k, v)
                    ---@type POP
                    v = v
                    return v.name
                end
            },
            {
                header = 'name',
                render_closure = render_name,
                width = base_unit * 6,
                value = function(k, v)
                    ---@type POP
                    v = v
                    return v.name
                end
            },
            {
                header = 'race',
                render_closure = render_race,
                width = base_unit * 6,
                value = function(k, v)
                    ---@type POP
                    v = v
                    return v.race.name
                end
            },
            {
                header = 'job',
                render_closure = function (rect, k, v)
                    ui.centered_text(pop_display_occupation(v), rect)
                end,
                width = base_unit * 8,
                value = function(k, v)
                    return pop_display_occupation(v)
                end
            },
            {
                header = 'age',
                render_closure = function (rect, k, v)
                    ui.right_text(tostring(v.age), rect)
                end,
                width = base_unit * 3,
                value = function(k, v)
                    return v.age
                end
            },
            {
                header = 'sex',
                render_closure = function (rect, k, v)
                    ui.centered_text(pop_sex(v), rect)
                end,
                width = base_unit * 1.5,
                value = function(k, v)
                    return pop_sex(v)
                end
            }
        }
        init_state(base_unit)
        local top = rect:subrect(0, 0, rect.width, base_unit, "left", 'up')
        local bottom = rect:subrect(0, base_unit, rect.width, rect.height - base_unit, "left", 'up')
        ui.centered_text("Population", top)
        ui.table(bottom, tile.province.all_pops, columns, state)
    end
end