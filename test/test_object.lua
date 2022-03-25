_ENV = require('external.lunity')(
    "test the base class Object"
)

Object = require("class").Object

function test:object_is_valid_type()
    assertNotNil(Object.getType)
    assertNotNil(Object.getBases)
    assertEqual(Object.getType(), 'Object')
end

test()