_ENV = require('external.lunity')()

object = require('class').object
class = require('class').class
super = require('class').super

function test.object_new()
  local obj = object:new()
end

function test.object_to_string()
  local obj = object:new()
end

function test.object_clone()
  local obj = object:new { x = 200, y = 400 }
  local clone = obj:clone()
  assertEqual(clone.x, 200)
  assertEqual(clone.y, 400)
  assertEqual(clone.x, obj.x)
  assertEqual(clone.y, obj.y)
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

test()