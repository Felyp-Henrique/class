_ENV = require('external.lunity')()

require 'class'

function test:before()
  __identifier.__id = -1
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

-- TODO

--
-- Super Tests
--

-- TODO

-- stderr as 1 when error
if not test() then
  os.exit(1)
end