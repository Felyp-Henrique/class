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
    _type.toClass = function(self, class, constructor)
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
            for field, default in pairs(self.__fields) do
                instance[field] = default
            end
            if constructor ~= nil then
                constructor(instance, ...)
            end
            return instance
        end
        return setmetatable(class, class)
    end
    Type = _type
end

local Object
do
    local _object = {}
    _object.__statics = {
        getType = function()
            return "Object"
        end,
        getBases = function()
            return {}
        end
    }
    _object.__fields = {
        clone = function(self)
            local object = {}
            for field, default in pairs(self) do
                object[field] = default
            end
            return object
        end,
        equals = function(self, other)
            if not other.getType then
                return false
            elseif other:getType() ~= self:getType() then
                return false
            end
            for self_field, self_value in pairs(self) do
                for other_field, other_value in pairs(other) do
                    if (self_field ~= 'getType' and other_field ~= 'getType') and (self_value ~= other_value) then
                        return false
                    end
                end
            end
            return true
        end,
        toString = function(self)
            local result = self:getType() .. " "
            for field, value in pairs(self) do
                result = result .. field .. ":" .. value .. " "
            end
            return result
        end
    }
    Object = Type:toClass(_object)
end

local ClassFactory
do
    local _factory = {}
    _factory.simple = function(self, signature, definition)
        local class = {}
        local bases = {Object, table.unpack(definition.extends or {})}
        local statics = definition.statics or {}
        local fields = definition.fields or {}
        statics.getType = function()
            return signature
        end
        statics.getBases = function()
            return bases
        end
        Type:extend(class, table.unpack(bases))
        for static, value in pairs(statics) do
            Type:static(class, static, value)
        end
        local constructor = nil
        for field, value in pairs(fields) do
            if field == 'constructor' then
                constructor = value
            end
            if field ~= 'statics' then
                Type:field(class, field, value)
            end
        end
        return Type:toClass(class, constructor)
    end
    ClassFactory = _factory
end

local function class(signature, definition)
    return ClassFactory:simple(signature, definition)
end

return {
    Type = Type,
    Object = Object
}
