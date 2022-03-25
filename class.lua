local Type
do
    local _type = {
        extend = function(self, class, ...)
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
        end,
        static = function(self, class, signature, value)
            class.__statics = class.__statics or {}
            class.__statics[signature] = value
        end,
        field = function(self, class, signature, default)
            class.__fields = class.__fields or {};
            class.__fields[signature] = default;
        end
    }
    Type = _type
end

local Object
do
    local _object = {
        __statics = {
            getType = function()
                return "Object"
            end,
            getBases = function()
                return {}
            end
        },
        __fields = {
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
        },
        __index = function(table_, index)
            local statics = rawget(table_, '__statics')
            if statics and statics[index] then
                return rawget(statics, index)
            end
            return nil
        end,
        new = function(self, ...)
            local instance = {}
            instance.getType = self.__statics.getType
            instance.getBases = self.__statics.getBases
            for field, default in pairs(self.__fields) do
                instance[field] = default
            end
            return instance
        end
    }
    Object = setmetatable(_object, _object)
end

local ClassFactory
do
    local _factory = {}
    ClassFactory = _factory
end

return {
    Type = Type,
    Object = Object
}
