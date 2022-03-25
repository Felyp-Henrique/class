_ENV = require('external.lunity')(
    "test the base creation class with Type"
)

Type = require("class").Type

function test:define_type_with_statics_fields()
    local Object = Type:define {
        signature = "Object",
        statics = {
            Field = "Static Field Definition"
        }
    }
    assertNotNil(Object.getType, "Type not defined corretly")
    assertNotNil(Object.getBases, "Type not defined corretly")
    assertNotNil(Object.new, "Type not defined corretly")
    assertNotNil(Object.__statics, "Type not defined corretly")
    assertNotNil(Object.__fields, "Type not defined corretly")
    assertNotNil(Object.Field, "Static Field not defined")
end

function test:define_type_with_instance_fields()
    local Object = Type:define {
        signature = "Object",
        attrs = {
            instance = 'Instance Field',
            method = function(self)
                return self.instance .. ": " .. "method"
            end
        }
    }
    assertEqual(Object.getType(), 'Object')
    assertDoesNotError(Object.new, Object)

    local object = Object:new()
    assertNotNil(object.instance, "Type not instantiated corretly")
    assertNotNil(object.method, "Type not instantiated corretly")
    assertEqual(object.instance, "Instance Field", "Type not instantiated corretly")
    assertEqual(object:method(), "Instance Field: method", "Type not instantiated corretly")
end

function test:define_type_with_inheritances()
    local Object = Type:define {
        signature = "Object",
        attrs = {
            instance = 'Instance Field',
            method = function(self)
                return self.instance .. ": " .. "method"
            end
        }
    }
    local ObjectTwo = Type:define {
        signature = "ObjectTwo",
        attrs = {
            newInstance = 'New Instance Field',
            newMethod = function(self)
                return self.instance .. ": " .. "new method"
            end
        },
        inheritances = { Object }
    }
    local object = Object:new()
    local objectTwo = ObjectTwo:new()
    -- check types
    assertNotEqual(Object.getType(), ObjectTwo.getType())
    -- check base definition
    assertNotNil(object.instance)
    assertNotNil(object.method)
    assertNil(object.newInstance)
    assertNil(object.newMethod)
    -- check child definition
    assertNotNil(objectTwo.instance)
    assertNotNil(objectTwo.method)
    assertNotNil(objectTwo.newInstance)
    assertNotNil(objectTwo.newMethod)
    -- check different values between objects
    assertEqual(object.instance, objectTwo.instance)
    objectTwo.instance = "New Different Vaule"
    assertNotEqual(object.instance, objectTwo.instance)
end

function test:define_type_with_construtor()
    local Object = Type:define {
        signature = "Object",
        constructor = function(self)
            self.any = "Any Instance Field"
        end
    }
    local object = Object:new()
    assertNotNil(object.any)
end

test()