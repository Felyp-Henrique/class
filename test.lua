class = require('class').class

_ENV = require('external.lunity')()

function test:before()
    _G['ObjectType'] = nil
    _G['ObjectTypeTwo'] = nil
end

function test:automatic_create_class_and_use_it()
    assertDoesNotError(class, 'ObjectType')
    local object = ObjectType:new()
    assertTrue(object.type == 'ObjectType')
end

function test:automatic_create_fields_and_use_it()
    assertDoesNotError(class, 'ObjectType', function(c)
        c:field('fieldOne', 'default value 1')
        c:field('fieldTwo', 'default value 2')
    end)
    local object = ObjectType:new()
    assertNotNil(object.fieldOne)
    assertNotNil(object.fieldTwo)
end

function test:automatic_create_static_and_use_it()
    assertDoesNotError(class, 'ObjectType', function(c)
        c:static('staticField', 'default value')
        c:static('staticMethod', function() return 'default return' end)
    end)
    -- check if static fields exists
    assertType(ObjectType.staticField, 'string')
    assertType(ObjectType.staticMethod, 'function')
    -- check if static fields is correct
    assertEqual(ObjectType.staticField, 'default value')
    assertEqual(ObjectType.staticMethod(), 'default return')
    -- check if instance not have static fields
    local object = ObjectType:new()
    assertNil(object.staticField)
    assertNil(object.staticMethod)
end

function test:automatic_create_method_and_use_it()
    assertDoesNotError(class, 'ObjectType', function(c)
        c:method('methodOne', function(self)
            return 'method one'
        end)

        c:method('methodTwo', function(self)
            return 'method two'
        end)
    end)
    local object = ObjectType:new()
    assertEqual(object:methodOne(), 'method one')
    assertEqual(object:methodTwo(), 'method two')
end

function test:automatic_do_inheritance_and_use_it()
    assertDoesNotError(class, 'ObjectType', function(c)
        c:field('fieldBase', 'field base')

        c:method('methodBase', function(self)
            return 'method base'
        end)
    end)
    assertDoesNotError(class, 'ObjectTypeTwo', function(c)
        c:extends(ObjectType)

        c:field('fieldNew', 'field new')

        c:method('methodNew', function(self)
            return 'method new'
        end)
    end)
    local object = ObjectType:new()
    local objectTwo = ObjectTypeTwo:new()
    -- check if all field/methods was inherited
    assertNotNil(objectTwo.fieldBase)
    assertNotNil(objectTwo.methodBase)
    assertNotNil(objectTwo.fieldNew)
    assertNotNil(objectTwo.methodNew)
    -- check if base class not have field/methods of children
    assertNil(object.fieldNew)
    assertNil(object.methodNew)
    -- check if value are different when change field data
    objectTwo.fieldBase = "change default value inherited"
    assertNotEqual(object.fieldBase, objectTwo.fieldBase)
end


function test:simple_do_error_when_undefined_type()
    assertErrors(class, function(c) end)
end

test()