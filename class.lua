--
-- class.lua
--
-- Copyright (c) 2022, Felyp Henrique
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the Apache license. See LICENSE for details.
--


--- identifier
--
-- It is a object used to identify the class when compare instance about objects
-- or equality.
--
local identifier
do
  local _identifier = {}
  _identifier.__index = _identifier
  _identifier.__id = -1
  _identifier.next_id = function (self)
    self.__id = self.__id + 1
    return self.__id
  end
  identifier = setmetatable(_identifier, _identifier)
end


--- object
--
-- It's a class object. This is the base class of all classes.
--
local object
do
  local _object = {}
  _object.__id = identifier:next_id()
  _object.__index = _object
  _object.to_string = function (self)
    return tostring(self)
  end
  _object.clone = function (self)
    local other = {}
    other.__index = other
    for field, value in pairs(self) do
      if field ~= "__index" then
        other[field] = value
      end
    end
    return setmetatable(other, self)
  end
  _object.equals = function (self, other)
    for field, value in pairs(self) do
      if field ~= "__index"
          and field ~= 'new'
          and field ~= '__new'
          and field ~= '__extends' then
        if other[field] ~= value then
          return false
        end
      end
    end
    for field, value in pairs(other) do
      if field ~= "__index"
          and field ~= 'new'
          and field ~= '__new'
          and field ~= '__extends' then
        if other[field] ~= value then
          return false
        end
      end
    end
    return true
  end
  _object.instanceof = function (self, other)
    if other.__id == object.__id then
      return true
    end
    for _, base in ipairs(self.__extends or {}) do
      if other.__id == base.__id and base.__id ~= object.__id then
        return true
      end
    end
    return false
  end
  _object.new = function (self, args)
    local instance = args or {}
    instance.__index = instance
    instance.__extends = { _object }
    return setmetatable(instance, self)
  end
  _object.__new = _object.new
  _object.__extends = { _object }
  object = setmetatable(_object, _object)
end

--- class
--
-- It's a function class, used to define a new class.
--
-- @param detail table (optional) 
--
local class
do
  local _class = function (detail)
    local class = {}
    -- class configuration
    detail = detail or {}
    detail.extends = {object, table.unpack(detail.extends or {})}
    detail.new = detail.new or function (self)
    end
    -- class inheritance
    for _, base in ipairs(detail.extends) do
      for field, value in pairs(base) do
        if field ~= "__index" and field ~= 'new' and field ~= '__id' then
          class[field] = value
        end
      end
    end
    -- class fields
    for field, value in pairs(detail) do
      if field ~= "extends" and field ~= "new" and field ~= '__index' then
        class[field] = value
      end
    end
    class.__new = detail.new
    -- class basics methods
    class.new = function (self, ...)
      local instance = {}
      instance.__index = instance
      -- copy methods from base classe
      for field, value in pairs(self) do
        if field ~= "__index" and field ~= 'new' then
          instance[field] = value
        end
      end
      -- run constructor
      if detail.new then
        detail.new(instance, ...)
      end
      return setmetatable(instance, self)
    end
    class.__id = identifier:next_id()
    class.__index = class
    class.__extends = detail.extends
    return setmetatable(class, class)
  end
  class = _class
end

--- super
--
-- It's a function used to call a method from a base class.
--
local super
do
  local _super = function (instance, superclass)
    return setmetatable({}, {
      __index = function (_, field)
        -- find constructor in instance
        if field == 'new' then
          if superclass == nil then
            error('superclass is nil in super(self, superclass)')
          end
          return function (...)
            return superclass.__new(instance, ...)
          end
        end
        -- check instance
        if instance == nil then
          error('instance is nil in super(self)')
        end
        -- find method in instance
        for _, base in ipairs(instance.__extends) do
          local method = rawget(base, field)
          if type(method) == 'function' then
            return function (...)
              return method(instance, ...)
            end
          end
        end
        return rawget(instance, field)
      end,
    })
  end
  super = _super
end

return {
  object = object,
  class = class,
  super = super,
  __identifier = identifier, -- expose to test
}