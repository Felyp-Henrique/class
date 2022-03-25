_ENV = require('external.lunity')(
    "test the instance of Object generic type"
)

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
end

test()