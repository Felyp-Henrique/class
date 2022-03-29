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
    local Employee = class('Employee', {
        extends = {People},
        constructor = function(self, name, enterprise)
            self.name = name
            self.enterprise = enterprise
        end,
        getMessage = function(self, message)
            return self.enterprise .. "@" .. super(self).getMessage(message)
        end
    })
    local customer = Employee:new('josh', 'love2d')
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
    local Employee = class('Employee', {
        extends = {People},
        constructor = function(self, name, enterprise)
            super(self).constructor(name)
            self.enterprise = enterprise
        end
    })
    local customer = Employee:new('josh', 'love2d')
    assertEqual(customer:getMessage('hello world'), 'josh: hello world')
end

function test:test_conflict_error_in_super_keyword_in_multiple_constructors()
    local Red = class('Red', {
        constructor = function(self, red)
            self.red = red
        end
    })
    local Green = class('Green', {
        constructor = function(self, green)
            self.green = green
        end
    })
    local Blue = class('Blue', {
        constructor = function(self, blue)
            self.blue = blue
        end
    })
    local RGB = class('RGB', {
        extends = {Red, Green, Blue},
        constructor = function(self)
            super(self).constructor(255)
        end
    })
    assertErrors(RGB.new, RGB)
end

function test:test_super_keyword_in_multiple_constructors_does_not_error()
    local Red = class('Red', {
        constructor = function(self, red)
            self.red = red
        end
    })
    local Green = class('Green', {
        constructor = function(self, green)
            self.green = green
        end
    })
    local Blue = class('Blue', {
        constructor = function(self, blue)
            self.blue = blue
        end
    })
    local RGB = class('RGB', {
        extends = {Red, Green, Blue},
        constructor = function(self, red, green, blue)
            Red.constructor(self, red)
            Green.constructor(self, green)
            Blue.constructor(self, blue)
        end
    })
    assertDoesNotError(RGB.new, RGB)
    local rgb = RGB:new(100, 255, 30)
    assertEqual(rgb.red, 100)
    assertEqual(rgb.green, 255)
    assertEqual(rgb.blue, 30)
end

if not test() then
    os.exit(1)
end
