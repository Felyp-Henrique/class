local Type = {
    statics = function(self, target, statics)
        target.__statics = target.__statics or {}
        for static, default in pairs(statics) do
            target.__statics[static] = default
        end
    end,
    fields = function(self, target, fields)
        target.__fields = target.__fields or {}
        for field, default in pairs(fields) do
            target.__fields[field] = default
        end
    end,
    extends = function(self, target, inheritances)
        for _, class in ipairs(inheritances) do
            for static, default in pairs(class.__statics or {}) do
                target.__statics = target.__statics or {}
                target.__statics[static] = default
            end
            for field, default in pairs(class.__fields or {}) do
                target.__fields = target.__fields or {}
                target.__fields[field] = default
            end
        end
    end,
    define = function(self, defintion)
        local class = {}
        local attrs = defintion.attrs or {}
        local inheritances = defintion.inheritances or {}
        local statics = defintion.statics or {}
        statics.getType = function()
            return defintion.signature
        end
        statics.getBases = function()
            return inheritances
        end
        self:extends(class, inheritances)
        self:statics(class, statics)
        self:fields(class, attrs)
        class.__index = function(table_, index)
            local statics = rawget(table_, '__statics')
            if statics and statics[index] then
                return rawget(statics, index)
            end
            return nil
        end
        class.new = function(self, target, obj)
            target = target or {}
            for field, default in pairs(self.__fields or {}) do
                if not target[field] or type(default) == 'function' then
                    target[field] = default
                end
            end
            target.getType = class.getType
            if defintion.constructor ~= nil then
                defintion.constructor(target, obj)
            end
            return setmetatable(target, self)
        end
        return setmetatable(class, class)
    end
}

local Object = Type:define{
    signature = "Object"
}

local ClassBuilder = Type:define{
    signature = 'ClassFactory',
    inheritances = {Object},
    attrs = {
        init = function(self, signature)
            self.class = Type:define{
                signature = signature
            }
        end,
        extends = function(self, ...)
            Type:extends(self.class, {...})
        end,
        static = function(self, signature, default)
            Type:statics(self.class, {
                signature = default
            })
        end,
        field = function(self, signature, default)
            Type:fields(self.class, {
                signature = default
            })
        end,
        method = function(self, signature, callback)
            self:field(signature, callback)
        end,
        build = function(self)
            return self.class
        end
    }
}

local ClassFactory = Type:define{
    signature = 'ClassFactory',
    inheritances = {Object},
    statics = {
        simple = function(signature, definition)
            definition = definition or {}
            local statics = definition.statics
            local inheritances = {Object}
            local attrs = {}
            for field, default in pairs(definition) do
                if field ~= 'statics' then
                    attrs[field] = default
                end
            end
            for _, class in ipairs(definition.inheritances or {}) do
                table.insert(inheritances, class)
            end
            return Type:define{
                signature = signature,
                inheritances = inheritances,
                statics = statics,
                attrs = attrs
            }
        end,
        builder = function(signature, defitionCallback)
            local builder = ClassBuilder:new{
                signature = signature
            }
            builder:init(signature)
            defitionCallback(builder)
            return builder:build()
        end
    }
}

local function class(...)
    local signature, definition = ...
    if type(definition) == 'function' then
        return ClassFactory.builder(signature, definition)
    end
    return ClassFactory.simple(signature, definition)
end

return {
    Type = Type,
    Object = Object,
    ClassFactory = ClassFactory,
    class = class
}
