class = require('class').class

_ENV = require('external.lunity')()

function test:before()
    _G['People'] = nil
    _G['Service'] = nil
end

function test:create_class_and_instantiate_it()
    local People = class('People')
    assertTrue(People.type == "People")
    local object = People:new()
    assertTrue(object.type == "People")
end

function test:define_static_values_and_read_it()
    local url = 'https://github.com/Felyp-Henrique'
    local Service = class('Service', function(c)
        c:static('url', url)
    end)
    assertTrue(Service.url == url)
end

function test:define_two_different_classes()
    local People = class('People', function(c)
        c:static('race', 'Human')

        c:field('name', 'Alexa')
        c:field('year', 18)
    end)
    local Service = class('Service', function(c)
        c:static('protocol', 'tcp')

        c:field('host', 'localhost')
        c:field('port', 8080)
    end)
    -- check if statics is valids
    assertTrue(People.race == 'Human' and People.protocol == nil)
    assertTrue(Service.protocol == 'tcp' and Service.race == nil)
    local people = People:new()
    local service = Service:new()
    -- check if fields is valids
    assertTrue(people.name == 'Alexa' and people.year == 18)
    assertTrue(service.host == "localhost" and service.port == 8080)
    -- check if fields is not valids
    assertTrue(people.host == nil and people.port == nil)
    assertTrue(service.name == nil and service.year == nil)
end

test()