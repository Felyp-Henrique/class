_ENV = require('external.lunity')("test the instance of Object generic type")

Object = require("class").Object

function test:test_statics_members_of_object()
    assertNotNil(Object.new)
    assertNotNil(Object.getType)
    assertNotNil(Object.getType())
    assertEqual(Object.getType(), "Object")
    assertNotNil(Object.getBases)
    assertNotNil(Object.getBases())
end

function test:test_create_instance_of_object()
    assertDoesNotError(Object.new, Object)
    local object = Object:new()
    assertNotNil(object.getType)
    assertNotNil(object.getBases)
    assertNotNil(object.clone)
    assertNotNil(object.equals)
    assertNotNil(object.toString)
    assertNil(object.__statics)
    assertNil(object.__fields)
    assertDoesNotError(object.clone, object)
    assertDoesNotError(object.equals, object, nil)
    assertDoesNotError(object.toString, object)
end

function test:test_clone_method_of_object()
    local object = Object:new()
    -- test if works
    assertDoesNotError(object.clone, object)
    -- test if consistents
    object.dynamicField = "Dynamic Field"
    local other = object:clone()
    assertNotNil(other.dynamicField)
    assertNotNil(other.getType)
    assertNotNil(other.getBases)
    assertNotNil(other.clone)
    assertNotNil(other.equals)
    assertNotNil(other.toString)
    -- test the differents changes
    object.dynamicField = "Different Data"
    assertNotEqual(object.dynamicField, other.dynamicField)
end

function test:test_equals_method_of_object()
    local first = Object:new()
    local second = Object:new()
    -- test nil, table and objects
    assertDoesNotError(first.equals, first, nil)
    assertDoesNotError(first.equals, first, first)
    assertDoesNotError(first.equals, first, Object:new())
    assertDoesNotError(second.equals, second, nil)
    assertDoesNotError(second.equals, second, second)
    assertDoesNotError(second.equals, second, Object:new())
    -- test if equals
    first.field = 'any value'
    second.field = 'any value'
    assertTrue(first:equals(second))
    assertTrue(second:equals(first))
    -- test if not equals
    second.field = 'ant other value'
    assertFalse(first:equals(second.field))
    assertFalse(first:equals(nil))
    assertFalse(first:equals({}))
    assertFalse(first:equals(Object:new()))
    assertFalse(second:equals(first.field))
    assertFalse(second:equals(nil))
    assertFalse(second:equals({}))
    assertFalse(second:equals(Object:new()))
end

function test:test_tostring_method_of_object()
    local object = Object:new()
    assertDoesNotError(object.toString, object)
    assertEqual(object:toString(), '<Object>')
end

if not test() then
    os.exit(1)
end