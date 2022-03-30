_ENV = require('external.lunity')("test the global denition class with gclass")

gclass = require('class').gclass

function test:before()
    _G['People'] = nil
end

function test:test_global_definition_class()
    gclass('People', {
        statics = {
            race = 'human'
        },
        constructor = function(self, name, year)
            self.name = name
            self.year = year
        end,
        getMessage = function(self, message)
            return string.format("%s: %s", self.name, tostring(message))
        end
    })
    local people = People:new('Joshua', 48)
    assertEqual(People.race, 'human')
    assertDoesNotError(People.new, People)
    assertDoesNotError(People.new, People, nil, nil)
    assertDoesNotError(People.new, People, 'Joshua', 48)
    assertEqual(people.name, 'Joshua')
    assertEqual(people.year, 48)
    assertEqual(people:getMessage('hello world'), 'Joshua: hello world')

    -- error when try define one class already defined
    assertErrors(gclass, 'People')
end

if not test() then
    os.exit(1)
end