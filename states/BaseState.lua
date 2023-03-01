--[[
    BaseState Class

    Used as the base class for all of our states
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end