seed = math.ceil(os.clock() ^ 5) * 100

print(seed)

math.randomseed(os.clock())

local function __id()
  local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  return string.random(10 - 1) .. charset:sub(math.random(1, #charset), 1)
end

local object
do
  local _object = {}
  _object.__id = __id()
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
      if field ~= "__index" then
        if other[field] ~= value then
          return false
        end
      end
    end
    for field, value in pairs(other) do
      if field ~= "__index" then
        if other[field] ~= value then
          return false
        end
      end
    end
    return true
  end
  _object.instanceof = function (self, other)
    local fields = {}
    for self_field, _ in pairs(self) do
      fields[self_field] = true
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
  object = setmetatable(_object, _object)
end

local class
do
  local _class = function (detail)
    local class = {}
    class.__id = __id()
    class.__index = class
    -- class configuration
    detail = detail or {}
    detail.extends = {object, table.unpack(detail.extends or {})}
    detail.new = detail.new or function (self)
    end
    -- class inheritance
    for _, base in ipairs(detail.extends) do
      for field, value in pairs(base) do
        if field ~= "__index" and field ~= 'new' then
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
      instance.__extends = detail.extends
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
    return setmetatable(class, class)
  end
  class = _class
end

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

Pessoa = class()
Funcionario = class()

print(Pessoa.__id)
print(Funcionario.__id)

return {
  object = object,
  class = class,
  super = super,
}