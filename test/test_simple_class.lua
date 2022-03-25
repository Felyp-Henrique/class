_ENV = require('external.lunity')(
    "test the simple class defition"
)

class = require("class").class

function test:define_class_and_instance()
    local People = class("People", {
        statics = {
            race = "human"
        },
        name = '',
        years = 0,
        say = function(self, message)
            return self.name .. ": " .. message
        end
    })
    -- check statics fields
    assertNotNil(People.getType)
    assertNotNil(People.getBases)
    assertNotNil(People.race)
    assertNotNil(People.getBases()[1]) -- type Object
    -- check statics fields values
    assertEqual(People.getType(), "People")
    assertEqual(People.race, "human")
    assertEqual(People.getBases()[1].getType(), 'Object')
    -- check fields not is statics
    assertNil(People.name)
    assertNil(People.years)
    assertNil(People.say)
    -- check instance fields
    local foo = People:new()
    assertNotNil(foo.name)
    assertNotNil(foo.years)
    assertNotNil(foo.say)
    -- check values
    assertEqual(foo.name, '')
    assertEqual(foo.years, 0)
    assertEqual(foo:say('hello'), foo.name .. ": " .. "hello")
end

test()