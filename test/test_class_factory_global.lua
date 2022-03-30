_ENV = require('external.lunity')("test the global denition class with ClassFactory.global")

ClassFactory = require('class').ClassFactory
Object = require('class').Object

function test:before()
    _G['People'] = nil
end

function test:create_global_class()
    assertDoesNotError(ClassFactory.global, ClassFactory, 'People')

    _G['People'] = nil
    assertDoesNotError(ClassFactory.global, ClassFactory, 'People', nil)

    _G['People'] = nil
    assertDoesNotError(ClassFactory.global, ClassFactory, 'People', {})

    -- error when try define one class already defined
    assertErrors(ClassFactory.global, ClassFactory, 'People')
end

function test:test_check_type_and_if_inherited_object()
    ClassFactory:global('People')
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
    ClassFactory:global('People', {
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

function test:test_construct_class()
    ClassFactory:global('People', {
        constructor = function(self, name, year, sexy)
            self.name = name
            self.year = year
            self.sexy = sexy
        end
    })
    assertDoesNotError(People.new, People)
    assertDoesNotError(People.new, People, 'Max', 33, 'male')
    local people = People:new('Max', 33, 'male')
    assertEqual(people.name, 'Max')
    assertEqual(people.year, 33)
    assertEqual(people.sexy, 'male')
end

function test:test_instance_members_class()
    ClassFactory:global('People', {
        name = 'any default',
        year = 99,
        sexy = 'any default',
        getMessage = function(self, message)
            return string.format("%s: %s", self.name, tostring(message))
        end
    })
    local people = People:new()
    assertEqual(people.name, 'any default')
    assertEqual(people.year, 99)
    assertEqual(people.sexy, 'any default')
    assertNotNil(people.getMessage)
    assertDoesNotError(people.getMessage, people, '')
    assertEqual(people:getMessage('hello world'), 'any default: hello world')
end

function test:test_inherit_class()
    ClassFactory:global('People', {
        statics = {
            race = 'human'
        },
        name = '',
        year = 0,
        getMessage = function(self, message)
            return string.format("%s: %s", self.name, tostring(message))
        end
    })
    ClassFactory:global('Employee', {
        extends = {People},
        statics = {
            manager = 'manager',
            subordinate = 'subordinate'
        },
        wage = 0,
        getWageWithBonus = function(self, bonus)
            return self.wage + bonus
        end
    })
    assertDoesNotError(People.new, People)
    assertDoesNotError(Employee.new, Employee)
    local people = People:new()
    local employee = Employee:new()
    -- check statics members
    assertNotNil(People.race)
    assertNil(People.manager)
    assertNil(People.subordinate)
    assertNotNil(Employee.race)
    assertNotNil(Employee.manager)
    assertNotNil(Employee.subordinate)
    -- check type and instance
    assertEqual(People.getType(), 'People')
    assertEqual(Employee.getType(), 'Employee')
    assertNotNil(people.name)
    assertNotNil(people.year)
    assertNotNil(people.getMessage)
    assertNil(people.wage)
    assertNil(people.getWageWithBonus)
    assertNotNil(employee.name)
    assertNotNil(employee.year)
    assertNotNil(employee.getMessage)
    assertNotNil(employee.wage)
    assertNotNil(employee.getWageWithBonus)
    employee.wage = 200
    assertEqual(employee:getWageWithBonus(200) , 400)
    -- check inherit
    assertEqual(#Employee.getBases(), 2)
    assertEqual(#employee.getBases(), 2)
    assertEqual(Employee.getBases()[1].getType(), 'Object')
    assertEqual(Employee.getBases()[2].getType(), 'People')
    assertFalse(employee:equals(people))
    assertFalse(people:equals(employee))
end

if not test() then
    os.exit(1)
end