-- Bundled by luabundle {"version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
local ferret = require("Ferret/Library")

local Core = require("Ferret/Model"):extend()

function Core:new()
    self.running = false
    self.fps = 24
    self.lifecycle_manager = require("Ferret/LifecycleManager")(ferret)
    self.module_manager = require("Ferret/ModuleManager")(ferret)
    self.logger = require("Ferret/Logger")(ferret, 'Ferret', 'Core')
end

function Core:on_update()
    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.PreTick, ferret)
    end

    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.Tick, ferret)
    end

    if self.running then
        self.lifecycle_manager:handle_state(Lifecycle.PostTick, ferret)
    end
end

function Core:start()
    if self.running then
        return
    end

    self.lifecycle_manager:handle_state(Lifecycle.PreInitialize, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.Initialize, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.PostInitialize, ferret)
    self.running = true

    -- persist
    while self.running do
        yield('/wait 0.01')
    end
end

function Core:stop()
    self.running = false

    self.lifecycle_manager:handle_state(Lifecycle.PreTeardown, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.Teardown, ferret)
    self.lifecycle_manager:handle_state(Lifecycle.PostTeardown, ferret)
end

ferret.core = Core()

-- Helpers
function ferret:register_module(module)
    ferret.core.module_manager:register(module)
end

return ferret

end)
__bundle_register("Ferret/Logger", function(require, _LOADED, __bundle_register, __bundle_modules)
local Logger = require("Ferret/Model"):extend()

function Logger:new(ferret, ...)
    self.ferret = ferret
    self.names = { ... }
end

function Logger:log(level, message)
    local prefix = ''
    if #self.names > 0 then
        local parts = {}
        for _, name in ipairs(self.names) do
            table.insert(parts, '[' .. name .. ']')
        end
        prefix = table.concat(parts, ' ') .. ' '
    end

    prefix = prefix .. '[' .. level .. '] '

    if level == 'debug' and self.ferret.config.show_debug then
        Dalamud.LogDebug(prefix .. message)
    elseif level == 'info' then
        Dalamud.Log(prefix .. message)
    end

    if self.ferret.config.echo_log then
        yield('/e ' .. prefix .. message)
    end
end

function Logger:info(message)
    self:log('info', message)
end

function Logger:debug(message)
    self:log('debug', message)
end

return Logger

end)
__bundle_register("Ferret/Model", function(require, _LOADED, __bundle_register, __bundle_modules)
local Base = require("external/classic/classic")

local Model = Base:extend()

return Model

end)
__bundle_register("external/classic/classic", function(require, _LOADED, __bundle_register, __bundle_modules)
--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--


local Object = {}
Object.__index = Object


function Object:new()
end


function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


function Object:__tostring()
  return "Object"
end


function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end


return Object

end)
__bundle_register("Ferret/ModuleManager", function(require, _LOADED, __bundle_register, __bundle_modules)
local ModuleManager = require("Ferret/Model"):extend()

function ModuleManager:new(ferret)
    self.ferret = ferret
    self.modules = {}
end

function ModuleManager:register(module)
    if not module or type(module) ~= 'table' then
        error('Module must be a table.')
    end

    table.insert(self.modules, module)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreInitialize, function()
        module:pre_initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Initialize, function()
        module:initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostInitialize, function()
        module:post_initialize(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreTick, function()
        module:pre_tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Tick, function()
        module:tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostTick, function()
        module:post_tick(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PreTeardown, function()
        module:pre_teardown(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.Teardown, function()
        module:teardown(self.ferret)
    end)

    self.ferret.core.lifecycle_manager:subscribe(Lifecycle.PostTeardown, function()
        module:post_teardown(self.ferret)
    end)
end

return ModuleManager

end)
__bundle_register("Ferret/LifecycleManager", function(require, _LOADED, __bundle_register, __bundle_modules)
local LifecycleManager = require("Ferret/Model"):extend()

function LifecycleManager:new(ferret)
    self.listeners = {}
    self.logger = require("Ferret/Logger")(ferret, 'Ferret', 'LifecycleManager')

    for _, state in pairs(Lifecycle) do
        self.listeners[state] = {}
    end
end

function LifecycleManager:subscribe(state, callback)
    table.insert(self.listeners[state], callback)
end

function LifecycleManager:handle_state(state, ferret)
    for _, callback in ipairs(self.listeners[state]) do
        callback(ferret)
    end
end

return LifecycleManager

end)
__bundle_register("Ferret/Library", function(require, _LOADED, __bundle_register, __bundle_modules)
require("Ferret/Lifecycle")

local ferret = {}

ferret.config = require("Ferret/Config")

ferret.modules = {
    gathering = require("Ferret/Modules/Gathering/Module"),
}

return ferret

end)
__bundle_register("Ferret/Modules/Gathering/Module", function(require, _LOADED, __bundle_register, __bundle_modules)
local Module = require("Ferret/Module"):extend()

function Module:new()
    Module.super.new(self, 'Gathering')
end

function Module:tick(ferret)
    self.logger:info('Hello, world!')
end

return Module()

end)
__bundle_register("Ferret/Module", function(require, _LOADED, __bundle_register, __bundle_modules)
local Module = require("Ferret/Model"):extend()

function Module:new(name)
    self.name = name
end

function Module:pre_initialize(ferret)
    self.logger = require("Ferret/Logger")(ferret, 'Ferret', self.name)
end
function Module:initialize(ferret) end
function Module:post_initialize(ferret) end

function Module:pre_tick(ferret) end
function Module:tick(ferret) end
function Module:post_tick(ferret) end

function Module:pre_teardown(ferret) end
function Module:teardown(ferret) end
function Module:post_teardown(ferret) end

return Module

end)
__bundle_register("Ferret/Config", function(require, _LOADED, __bundle_register, __bundle_modules)
local Config = require("Ferret/Model"):extend()

function Config:new()
    self.show_debug = false
    self.echo_log = false
end

return Config

end)
__bundle_register("Ferret/Lifecycle", function(require, _LOADED, __bundle_register, __bundle_modules)
Lifecycle = {
    PreInitialize = 1,
    Initialize = 2,
    PostInitialize = 3,

    PreTick = 4,
    Tick = 5,
    PostTick = 6,

    PreTeardown = 7,
    Teardown = 8,
    PostTeardown = 9,
}

local labels = {}
for k, v in pairs(Lifecycle) do
    labels[v] = k
end

-- Attach a method to get the label
function Lifecycle.get_label(value)
    return labels[value] or ('Unknown(' .. tostring(value) .. ')')
end

end)
ferret = __bundle_require("__root")