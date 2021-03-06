local Type
do
    local _type = {}
    _type.extend = function(self, class, ...)
        for _, base in ipairs({...}) do
            for static, default in pairs(base.__statics or {}) do
                class.__statics = class.__statics or {}
                class.__statics[static] = default
            end
            for field, default in pairs(base.__fields or {}) do
                class.__fields = class.__fields or {}
                class.__fields[field] = default
            end
        end
    end
    _type.static = function(self, class, signature, value)
        class.__statics = class.__statics or {}
        class.__statics[signature] = value
    end
    _type.field = function(self, class, signature, default)
        class.__fields = class.__fields or {};
        class.__fields[signature] = default;
    end
    _type.super = function(self, object)
        return setmetatable({}, {
            __index = function(_, index)
                local method = nil
                -- find constructors
                if index == 'constructor' then
                    local constructors = {}
                    for _, base in ipairs(object.getBases()) do
                        if base[index] ~= nil then
                            if method == nil then
                                method = base[index]
                            end
                            table.insert(constructors, base[index])
                        end
                    end
                    if #constructors > 1 then
                        error('Multiple inheritance conflict!')
                        return nil
                    end
                    return function(...)
                        return method(object, ...)
                    end
                end
                -- find method in superclass list
                for _, base in ipairs(object.getBases()) do
                    method = base.__fields[index]
                    if method and type(method) == 'function' then
                        return function(...)
                            return method(object, ...)
                        end
                    end
                end
                return nil
            end
        })
    end
    _type.toClass = function(self, class)
        class.__index = function(table_, index)
            local statics = rawget(table_, '__statics')
            if statics and statics[index] then
                return rawget(statics, index)
            end
            return nil
        end
        class.new = function(self, ...)
            local instance = {}
            instance.getType = self.__statics.getType
            instance.getBases = self.__statics.getBases
            for field, default in pairs(self.__fields or {}) do
                instance[field] = default
            end
            if class.constructor ~= nil then
                class.constructor(instance, ...)
            end
            return instance
        end
        class.__call = class.new
        return setmetatable(class, class)
    end
    Type = _type
end

local Object
do
    local _object = {}
    Type:static(_object, 'getType', function()
        return "Object"
    end)
    Type:static(_object, 'getBases', function()
        return {}
    end)
    Type:field(_object, 'clone', function(self)
        local object = {}
        for field, default in pairs(self) do
            object[field] = default
        end
        return object
    end)
    Type:field(_object, 'equals', function(self, other)
        if not other or not other.getType then
            return false
        end
        if other:getType() ~= self:getType() or #other ~= #self then
            return false
        end
        for field, self_value in pairs(self) do
            if type(self_value) ~= 'function' and other[field] ~= self_value then
                return false
            end
        end
        return true
    end)
    Type:field(_object, 'toString', function(self)
        return string.format("<%s>", self:getType())
    end)
    Object = Type:toClass(_object)
end

local ClassFactory
do
    local _factory = {}
    _factory.simple = function(self, signature, definition)
        definition = definition or {}
        local class = {}
        local bases = {Object, table.unpack(definition.extends or {})}
        local statics = definition.statics or {}
        Type:extend(class, table.unpack(bases))
        for field, value in pairs(definition) do
            if field == 'constructor' then
                statics.constructor = value
            elseif field ~= 'statics' then
                Type:field(class, field, value)
            end
        end
        statics.getType = function()
            return signature
        end
        statics.getBases = function()
            return bases
        end
        for static, value in pairs(statics) do
            Type:static(class, static, value)
        end
        return Type:toClass(class)
    end
    _factory.global = function(self, signature, definition)
        if _G[signature] ~= nil then
            error('Class already defined!')
        end
        _G[signature] = self:simple(signature, definition)
        return _G[signature]
    end
    ClassFactory = _factory
end

local function super(object)
    return Type:super(object)
end

local function class(signature, definition)
    return ClassFactory:simple(signature, definition)
end

local function gclass(signature, definition)
    return ClassFactory:global(signature, definition)
end

return {
    Type = Type,
    Object = Object,
    ClassFactory = ClassFactory,
    class = class,
    gclass = gclass,
    super = super
}
