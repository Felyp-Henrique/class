_ENV = require('external.lunity')("test the denition class with ClassFactory.simple")

ClassFactory = require('class').ClassFactory
Object = require('class').Object

function test:create_simple_class()
    assertDoesNotError(ClassFactory.simple, ClassFactory, 'People')
    assertDoesNotError(ClassFactory.simple, ClassFactory, 'People', nil)
    assertDoesNotError(ClassFactory.simple, ClassFactory, 'People', {})
end

function test:test_check_type_and_if_inherited_object()
    local People = ClassFactory:simple('People')
    assertNotNil(People.__statics)
    assertNotNil(People.__fields)
    assertNotNil(People.__index)
    assertType(People.__index, 'function')
    
    assertNotNil(People.getType)
    assertNotNil(People.getType())
    assertEqual(People.getType(), 'People')

    assertNotNil(People.getBases)
    assertNotNil(People:getBases())
    assertEqual(#People:getBases(), 1)
    assertEqual(People:getBases()[1].getType(), Object:getType())
end

function test:test_statics_members_class()
    local People = ClassFactory:simple('People', {
        statics = {
            race = 'human',
            male = 'male',
            female = 'female'
        }
    })
    assertEqual(People.race, 'human')
    assertEqual(People.male, 'male')
    assertEqual(People.female, 'female')
    local object = People:new()
    assertNil(object.race)
    assertNil(object.male)
    assertNil(object.female)
end

test()
