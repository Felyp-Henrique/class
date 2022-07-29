local extends
do
  local _extends
  _extends = function(target, src)
    for field, value in pairs(src) do
      if field == 'extends' then
        for _, subclass in ipairs(value) do
          _extends(target, subclass)
        end
      elseif field == '__bases' then
        for _, base in ipairs(value) do
          table.insert(target.__bases, base)
        end
      elseif field ~= 'init' and field ~= '__index' then
        target[field] = value
      end
    end
  end
  extends = _extends
end

local object
do
  local _object
  _object = {}
  _object.__bases = {}
  _object.to_string = function(self)
    return tostring(self)
  end
  _object.clone = function(self)
    local other = {}
    other.__index = other
    for field, value in pairs(self) do
      if field ~= 'init' and field ~= '__index' then
        other[field] = value
      end
    end
    return setmetatable(other, other)
  end
  _object.equals = function(self, other)
    local is_equals = true
    -- first check if self is equals to other
    for field, value in pairs(self) do
      if type(value) ~= 'function' then
        if other[field] ~= value then
          is_equals = false
        end
      end
    end
    -- second check if other is equals to self
    for field, value in pairs(other) do
      if type(value) ~= 'function' then
        if other[field] ~= value then
          is_equals = false
        end
      end
    end
    return is_equals
  end
  _object.__index = _object
  object = setmetatable(_object, _object)
end

local class
do
  local _class
  _class = function(definition)
    local meta = definition or {}
    local class = {}
    class.__index = class
    -- all class inherit from object
    meta.extends = meta.extends or {}
    table.insert(meta.extends, object)
    class.__bases = meta.extends
    -- it's the constructor
    function class:__call(...)
      local args = {...}
      local object = setmetatable({}, self)
      object.__index = object
      for field, value in pairs(meta) do
        if field == "init" then
          value(object, table.unpack(args or {}))
        else
          object[field] = value
        end
      end
      return object
    end
    -- do inheritance
    for _, subclass in pairs(meta.extends or {}) do
      extends(class, subclass)
    end
    -- it's the rest of class
    for field, value in pairs(meta) do
      -- it's the inheritance action
      if field == 'extends' then
        for subfield, subvalue in pairs(value) do
          class[subfield] = subvalue
        end
      else
        class[field] = value
      end
    end
    return setmetatable(class, class)
  end
  class = _class
end

local super
do
  local _super
  _super = function(object)
    return setmetatable({}, {
      __index = function(_, field)
        for _, base in ipairs(object.__bases or {}) do
          -- can't call constructors
          if base[field] and field ~= 'init' then
            error("Can't call constructor in super, use 'class.init(self, ...)' instead")
            return nil
          end
          -- call method from base class
          if base[field] and type(base[field]) == 'function' then
            return function(...)
              return base[field](object, ...)
            end
          end
        end
        return nil
      end,
    })
  end
  super = _super
end

Pessoa = class {
  init = function(self, nome, idade)
    self.nome = nome or ""
    self.idade = idade or 0
  end
}

Funcionario = class {
  extends = { Pessoa },
  init = function(self, nome, idade, salary)
    Pessoa.init(self, nome, idade)
    self.salary = salary or 0
  end
}

local funcionario = Funcionario("Joao", 30, 900.0)

print(funcionario.nome, funcionario.idade, funcionario.salary)