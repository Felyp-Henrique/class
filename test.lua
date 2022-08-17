_ENV = require('external.lunity')()

function test:before()
  if __identifier then
    __identifier.__id = -1
  end
  require('class') -- reload object.__id
end


--
-- Identifier Tests
--

-- Test the identifier class has a metatable.
function test:test_identifier_has_metatable()
  assertNotNil(__identifier.__index)
  assertNotNil(getmetatable(__identifier))
end

-- The identifier object always init with id -1.
function test:identifier_init()
  assertEqual(__identifier.__id, -1)
end

-- The identifier object increment the id by 1 each time it is called the next_id.
function test:identifier_next_id_increment()
  local old = __identifier.__id
  local new = __identifier:next_id()
  assertNotEqual(new, old)
end

-- The identifier object method's next_id return the same id incremented by 1.
function test:identifier_next_id_incremented()
  local old = __identifier.__id
  local new = __identifier:next_id()
  assertEqual(old, __identifier.__id - 1)
  assertEqual(new, __identifier.__id)
end


--
-- Object Tests
--

-- The object class has a metatable.
function test:test_object_has_metatable()
  assertNotNil(object.__index)
  assertNotNil(getmetatable(object))
end

-- The object class has the __id field as 0.
function test:object_id_zero()
  assertEqual(object.__id, 0)
end

-- The object class has contains the basics methods and fields.
function test:object_basics_methods_and_fields()
  assertNotNil(object.new)
  assertNotNil(object.to_string)
  assertNotNil(object.clone)
  assertNotNil(object.equals)
  assertNotNil(object.instanceof)
  assertNotNil(object.__new)
  assertNotNil(object.__id)
  assertNotNil(object.__index)
end

-- The object class make new different instance when use new method.
function test:object_instance_new()
  local instance = object:new()
  assertNotNil(instance)
  assertNotEqual(instance, object)
  assertEqual(instance.__id, object.__id)
  assertNotNil(instance.new)
  assertNotNil(instance.to_string)
  assertNotNil(instance.clone)
  assertNotNil(instance.equals)
  assertNotNil(instance.instanceof)
  assertNotNil(instance.__new)
  assertNotNil(instance.__id)
  assertNotNil(instance.__index)
  assertNotNil(instance.__extends)
end

-- The object class make new different instance when use __new method.
function test:object_instance___new()
  local instance = object:__new()
  assertNotNil(instance)
  assertNotEqual(instance, object)
  assertEqual(instance.__id, object.__id)
  assertNotNil(instance.new)
  assertNotNil(instance.to_string)
  assertNotNil(instance.clone)
  assertNotNil(instance.equals)
  assertNotNil(instance.instanceof)
  assertNotNil(instance.__new)
  assertNotNil(instance.__id)
  assertNotNil(instance.__index)
  assertNotNil(instance.__extends)
end

-- The object class make new different instance when use new method with args.
function test:object_instance_new_with_args()
  local instance = object:new({ x = 345, y = 678 })
  assertNotNil(instance)
  assertNotEqual(instance, object)
  assertNotNil(instance.x)
  assertNotNil(instance.y)
  assertEqual(instance.x, 345)
  assertEqual(instance.y, 678)
end

-- The object class not share attrs between instances when instantiate two objects.
function test:object_two_different_instances()
  local instance1 = object:new({ x = 1 })
  local instance2 = object:new({ y = 1 })
  local has = false
  assertNotEqual(instance1, instance2)
  for field, _ in pairs(instance1) do
    if field == 'y' then
      has = true
    end
  end
  assertFalse(has)
  has = false
  for field, _ in pairs(instance2) do
    if field == 'x' then
      has = true
    end
  end
  assertFalse(has)
end

-- The object class clone a new object with same attrs values.
function test:object_clone()
  local instance = object:new { any = 'value' }
  local clone = instance:clone()
  assertNotEqual(instance, clone)
  assertEqual(instance.any, clone.any)
  assertEqual(instance.__id, clone.__id)
  assertEqual(instance.any, 'value')
  assertEqual(clone.any, 'value')
end

-- The object class instanceof works :D
function test:object_instanceof()
  local instance = object:new()
  assertTrue(instance:instanceof(object))
  assertFalse(instance:instanceof({}))
end

-- The objects needs be equals.
function test:object_is_equals()
  local instance1 = object:new({ x = 20, y = 30 })
  local instance2 = object:new({ x = 20, y = 30 })
  local instance3 = object:new({ x = 80, y = 340 })
  local instance4 = instance3:clone()
  assertTrue(instance1:equals(instance2))
  assertTrue(instance3:equals(instance4))
end

-- The objects needs not be equals.
function test:object_is_not_equals()
  local instance1 = object:new({ x = 20, y = 30 })
  local instance2 = object:new({ x = 80, y = 340 })
  local instance3 = instance2:clone()
  instance3.x = 20
  assertFalse(instance1:equals(instance2))
  assertFalse(instance1:equals(instance3))
end

-- The object to string needs be like lua's tostring method.
function test:object_to_string()
  local instance = object:new({ x = 20, y = 30 })
  local str = tostring(instance)
  assertEqual(str, instance:to_string())
end


--
-- Class Tests
--

-- The class can create a class empty.
function test:class_empty()
  local any = class()
  assertNotNil(any)
  assertNotNil(any.__id)
  assertNotNil(any.__index)
  assertNotNil(any.__extends)
  assertNotNil(any.__new)
  assertNotNil(any.new)
  assertNotNil(any.to_string)
  assertNotNil(any.clone)
  assertNotNil(any.equals)
  assertNotNil(any.instanceof)
  assertNotNil(any:new())
  assertEqual(any.__id, 0)
end

-- The class create a new metatable.
function test:class_create_metatable()
  local any = class()
  assertNotNil(any.__index)
  assertNotNil(getmetatable(any))
end

-- The class create different tables in the memory.
function test:class_create_diferrent_tables()
  local any = class()
  local another = class()
  assertNotEqual(any, another)
end

-- The class constructor needs to work.
function test:class_constructor_needs_to_work()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end
  }
  local p1 = Point:new(10, 20)
  assertNotNil(p1)
  assertNotNil(p1.x)
  assertNotNil(p1.y)
  assertEqual(p1.x, 10)
  assertEqual(p1.y, 20)
  local p2 = Point:new()
  assertNotNil(p2)
  assertNotNil(p2.x)
  assertNotNil(p2.y)
  assertEqual(p2.x, 0)
  assertEqual(p2.y, 0)
end

-- The class needs be inherited.
function test:class_is_inherited()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    distance = function (self, other)
      return math.sqrt((self.x - other.x)^2 + (self.y - other.y)^2)
    end,
  }
  local Square = class {
    extends = { Point },
    new = function (self, x, y, w, h)
      self.x = x or 0
      self.y = y or 0
      self.w = w or 0
      self.h = h or 0
    end,
  }
  local square = Square:new(10, 20, 30, 40)
  assertNotNil(square)
  assertNotNil(square.distance)
  assertEqual(square.x, 10)
  assertEqual(square.y, 20)
  assertEqual(square.w, 30)
  assertEqual(square.h, 40)
  assertEqual(square:distance(square:clone()), 0)
end

-- The class needs be inherited more than one class.
function test:class_is_inherited_more_than_one_class()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    distance = function (self, other)
      return math.sqrt((self.x - other.x)^2 + (self.y - other.y)^2)
    end,
  }
  local Graphic = class {
    draw = function (self)
      return 'drawing'
    end,
  }
  local Square = class {
    extends = { Point, Graphic, },
    new = function (self, x, y, w, h)
      self.x = x or 0
      self.y = y or 0
      self.w = w or 0
      self.h = h or 0
    end,
  }
  local square = Square:new(10, 20, 30, 40)
  local other = Square:new(20, 30, 40, 50)
  assertNotNil(square)
  assertNotNil(square.distance)
  assertNotNil(square.draw)
  assertEqual(square.x, 10)
  assertEqual(square.y, 20)
  assertEqual(square.w, 30)
  assertEqual(square.h, 40)
  assertEqual(square:distance(square:clone()), 0)
  assertEqual(square:draw(), 'drawing')
end

-- The object class clone a new object with same attrs values.
function test:class_object_instance_clone()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end
  }
  local instance = Point:new(770, 230)
  local clone = instance:clone()
  assertNotEqual(instance, clone)
  assertEqual(instance.x, clone.x)
  assertEqual(instance.y, clone.y)
  assertEqual(instance.__id, clone.__id)
  assertEqual(instance.x, 770)
  assertEqual(instance.y, 230)
  assertEqual(clone.x, 770)
  assertEqual(clone.y, 230)
end

-- The object class instanceof works :D
function test:class_object_instance_instanceof()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end
  }
  local Any = class()
  local Inherited = class({ extends = { Point }})
  local instance = Point:new(89, 58)
  local other = Inherited:new()
  assertTrue(instance:instanceof(object))
  assertTrue(instance:instanceof(Point))
  assertFalse(instance:instanceof(Any))
  assertFalse(instance:instanceof({}))
  assertTrue(other:instanceof(object))
  assertTrue(other:instanceof(Point))
  assertTrue(other:instanceof(Inherited))
  assertFalse(other:instanceof(Any))
  assertFalse(other:instanceof({}))
end

-- The objects needs be equals.
function test:class_object_instance_is_equals()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end
  }
  local instance1 = Point:new(770, 230)
  local instance2 = Point:new(770, 230)
  local instance3 = Point:new(680, 230)
  local instance4 = instance3:clone()
  assertTrue(instance1:equals(instance2))
  assertTrue(instance3:equals(instance4))
end

-- The objects needs not be equals.
function test:class_object_instance_is_not_equals()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end
  }
  local instance1 = Point:new(770, 230)
  local instance2 = Point:new(580, 230)
  local instance3 = instance2:clone()
  instance3.x = 20
  assertFalse(instance1:equals(instance2))
  assertFalse(instance1:equals(instance3))
end

-- The object to string needs be like lua's tostring method.
function test:class_object_instance_to_string()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    to_string = function (self)
      return '{ "x": ' .. self.x  .. ', "y": ' .. self.y .. ' }'
    end
  }
  local instance = Point:new(20, 20)
  local str = '{ "x": 20, "y": 20 }'
  assertEqual(str, instance:to_string())
end

-- Test the static fields and methods.
function test:class_statics()
  local Point = class {
    BEGIN_X = -99,
    BEGIN_Y = -99,
    distance = function (x1, y1, x2, y2)
      return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
    end,
  }
  local instance = Point:new()
  assertEqual(instance.BEGIN_X, -99)
  assertEqual(instance.BEGIN_Y, -99)
  assertEqual(Point.BEGIN_X, -99)
  assertEqual(Point.BEGIN_Y, -99)
  assertEqual(type(Point.distance(50, 35, 604, 990)), 'number')
  assertEqual(type(instance.distance(20, 430, 760, 670)), 'number')
end


--
-- Super Tests
--

-- The super needs call the parent's constructor.
function test:super_call_parent_constructor()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
  }
  local Square = class {
    extends = { Point, },
    new = function (self, x, y, w, h)
      super(self, Point).new(x, y)
      self.w = w or 0
      self.h = h or 0
    end,
  }
  local square = Square:new(10, 20, 30, 40)
  assertEqual(square.x, 10)
  assertEqual(square.y, 20)
  assertEqual(square.w, 30)
  assertEqual(square.h, 40)
end

-- The super needs call the parent's method.
function test:super_call_parent_method()
  local Point = class {
    new = function (self, x, y)
      self.x = x or 0
      self.y = y or 0
    end,
    distance = function (self, other)
      return math.sqrt((self.x - other.x)^2 + (self.y - other.y)^2)
    end,
  }
  local Square = class {
    extends = { Point, },
    new = function (self, x, y, w, h)
      super(self, Point).new(x, y)
      self.w = w or 0
      self.h = h or 0
    end,
    distance = function (self, other)
      return super(self).distance(other) * -1
    end,
  }
  local point = Point:new(10, 20)
  local square = Square:new(10, 20, 40, 50)
  assertEqual(square:distance(point), -point:distance(square))
end

-- stderr as 1 when error
if not test() then
  os.exit(1)
end