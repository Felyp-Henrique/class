_ENV = require('external.lunity')("test the denition simple class with class")

class = require('class').class

function test:test_definition_simple_class()
    local People = class('People', {
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
end

if not test() then
    os.exit(1)
end
