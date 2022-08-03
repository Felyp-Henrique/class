_ENV = require('external.lunity')()

object = require('class').object
class = require('class').class
super = require('class').super

function test.object_new()
  local obj = object:new()
  assertNotNil(obj)
end

function test.object_to_string()
  local obj = object:new()
  assertNotNil(obj:to_string())
end

function test.object_clone()
  local obj = object:new { x = 200, y = 400 }
  local clone = obj:clone()
  assertEqual(clone.x, 200)
  assertEqual(clone.y, 400)
  assertEqual(clone.x, obj.x)
  assertEqual(clone.y, obj.y)
  assertNotEqual(clone, obj)
end

function test.object_equals()
  local obj1 = object:new { x = 10, y = 20 }
  local obj2 = object:new { x = 12, y = 20 }
  local obj3 = object:new { x = 10, y = 20 }
  assertEqual(obj1:equals(obj2), false)
  assertEqual(obj2:equals(obj1), false)
  assertEqual(obj2:equals(obj3), false)
  assertEqual(obj3:equals(obj2), false)
  assertEqual(obj1:equals(obj3), true)
end

function test.class()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    area = function (self)
      return self.x * self.y
    end
  }

  local point = Point:new(10, 20)

  assertEqual(point.x, 10)
  assertEqual(point.y, 20)
  assertEqual(point:area(), 200)

  local Zoom = class {
    extends = { Point },
    new = function (self, x, y, z)
      self.x = x or 0
      self.y = y or 0
      self.z = z or 1
    end,
    zoom = function (self)
      return self:area() * self.z
    end,
    to_string = function (self)
      return tostring(self:zoom())
    end
  }

  local zoom = Zoom:new(10, 20, 2)

  assertEqual(zoom.x, 10)
  assertEqual(zoom.y, 20)
  assertEqual(zoom:area(), 200)
  assertEqual(zoom:zoom(), 400)

  assertNotEqual(zoom, point)
  assertNotEqual(point, point:clone())
  assertNotEqual(zoom, zoom:clone())

  assertEqual(zoom:to_string(), '400')
end

function test.super()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    area = function (self)
      return self.x * self.y
    end
  }
  local Zoom = class {
    extends = { Point },
    new = function (self, x, y, z)
      super(self, Point).new(x, y)
      self.z = z or 1
    end,
    area = function (self)
      return super(self):area() * self.z
    end
  }
  local p = Zoom:new(10, 20, 2)
  assertEqual(p:area(), 400)
end

test()