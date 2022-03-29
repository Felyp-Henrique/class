_ENV = require('external.lunity')("test super")

class = require('class').class
super = require('class').super

function test:test_super_keyword_in_methods()
    local People = class('People', {
        constructor = function(self, name)
            self.name = name
        end,
        getMessage = function(self, message)
            return self.name .. ': ' .. message
        end
    })
    local Customer = class('Customer', {
        extends = {People},
        constructor = function(self, name, enterprise)
            self.name = name
            self.enterprise = enterprise
        end,
        getMessage = function(self, message)
            return self.enterprise .. "@" .. super(self).getMessage(message)
        end
    })
    local customer = Customer:new('josh', 'love2d')
    assertEqual(customer:getMessage('hello world'), 'love2d@josh: hello world')
end

function test:test_super_keyword_in_constructors()
    local People = class('People', {
        constructor = function(self, name)
            self.name = name
        end,
        getMessage = function(self, message)
            return self.name .. ': ' .. message
        end
    })
    local Customer = class('Customer', {
        extends = {People},
        constructor = function(self, name, enterprise)
            super(self).new(People, name)
            self.enterprise = enterprise
        end
    })
    local customer = Customer:new('josh', 'love2d')
    assertEqual(customer:getMessage('hello world'), 'josh: hello world')
end

if not test() then
    os.exit(1)
end
