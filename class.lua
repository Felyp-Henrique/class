local Class = {
    __index = function(table_, index)
        local statics = rawget(table_, '__statics')
        if statics and statics[index] then
            return rawget(statics, index)
        end
        return nil
    end,
    new = function(self, name)
        assert(name, "Needs define name of Class")
        return setmetatable({
            type = name,
            new = function(self, obj)
                obj = obj or {}
                obj.type = self.type
                for field, value in pairs(self.__fields or {}) do
                    if not obj[field] then
                        obj[field] = value
                    end
                end
                return obj
            end
        }, self)
    end
}

local Configuration = {
    type = '__configuration',
    new = function(self, class)
        self.__index = self
        return setmetatable({
            __class = class
        }, self)
    end,
    extends = function(self, other)
        if type(other) == 'string' then
            other = _G[other]
        end
        for field, value in pairs(other.__fields or {}) do
            self:field(field, value)
        end
    end,
    static = function(self, name, value)
        if not self.__class.__statics then
            self.__class.__statics = {}
        end
        local type_ = self.__class.type
        local statics = self.__class.__statics
        local error = "Static field '" .. type_ .. "." .. name .. "' already defined!"
        assert(not statics[name], error)
        rawset(statics, name, value)
    end,
    field = function(self, name, default)
        if not self.__class.__fields then
            self.__class.__fields = {}
        end
        local type_ = self.__class.type
        local fields = self.__class.__fields
        local error = "Field or method '" .. type_ .. "." .. name .. "' already defined!"
        assert(not fields[name], error)
        rawset(fields, name, default)
    end,
    method = function(self, name, callable)
        local type_ = self.__class.type
        local error = "Signature '" .. type_ .. "." .. name .. "' is not a 'function' type!"
        assert(type(callable) == 'function', error)
        self:field(name, callable)
    end
}

return {
    class = function(...)
        local signature, configure = ...
        local class = Class:new(signature)
        local configuration = Configuration:new(class)
        if type(signature) == 'function' then
            signature(configuration)
            assert(class.type, "Needs define type name!")
        elseif type(signature) == 'string' then
            if configure then
                configure(configuration)
            end
            assert(class.type, "Needs define type name!")
            _G[signature] = class
        end
        return class
    end
}
