local __class = {
    __index = function(table_, index)
        local statics = rawget(table_, '__statics')
        if statics and statics[index] then
            return rawget(statics, index)
        end
        return nil
    end,
    __define = function(self, name)
        assert(name, "Needs define name of Class")
        return setmetatable({
            type = name,
            new = self.new,
        }, self)
    end,
    new = function(self, obj)
        obj = obj or {}
        obj.type = self.type
        for field, value in pairs(self.__fields or {}) do
            if not obj[field] then
                obj[field] = value
            end
        end
        return obj
    end,
}

local __configuration = {
    type = '__configuration',
    new = function(self, class)
        self.__index = self
        return setmetatable({ __class = class }, self)
    end,
    extends = function(self, other)
        local fields = self.__class.__fields
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
        local error = "Static field '"..type_.."."..name.."' already defined!"
        assert(not statics[name], error)
        rawset(statics, name, value)
    end,
    field = function(self, name, default)
        if not self.__class.__fields then
            self.__class.__fields = {}
        end
        local type_ = self.__class.type
        local fields = self.__class.__fields
        local error = "Field or method '"..type_.."."..name.."' already defined!"
        assert(not fields[name], error)
        rawset(fields, name, default)
    end,
    method = function(self, name, callable)
        local type_ = self.__class.type
        local error = "Signature '"..type_.."."..name.."' is not a 'function' type!"
        assert(type(callable) == 'function', error)
        self:field(name, callable)
    end,
}

return {
    class = function(name, definition)
        assert(not _G[name], "Class '"..name.."' already defined!")
        local klass = __class:__define(name)
        local configuration = __configuration:new(klass)
        if definition then
            definition(configuration)
        end
        _G[name] = klass
        return klass
    end,
}