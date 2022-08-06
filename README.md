# Lua Class

**This library there is not a stable version.**

![Distribution](https://github.com/Felyp-Henrique/class/actions/workflows/distribution.yml/badge.svg)

This library is a simple implementation for OOP in Lua. It's inspired by the Java and Python. It's works with classes, inheritance and polymorphism.

* [x] It's works with **constructors**.
* [x] It's works with instance **methods**.
* [x] It's works with **static methods and fields**.
* [x] It's has **multiple inheritance** support.
* [x] It's has **polymorphism** support.
* [x] It's has **super** keywords.

```lua
class = require("class")

Point = class {
  BEGIN_X = 0,
  BEGIN_Y = 0,
  
  new = function (self, x, y)
    self.x = x or Point.BEGIN_X
    self.y = y or Point.BEGIN_Y
  end,

  distance = function (self, other)
    return math.sqrt((self.x - other.x)^2 + (self.y - other.y)^2)
  end,

  create_with_x = function (x)
    return Point:new(x, Point.BEGIN_Y)
  end,
}

local p1 = Point:new(200, 450)
local p2 = Point.create_with_x(100)

print(p1:distance(p2)) -- 460.97722286464
```

## Alternatives

There are some alternatives:

* [moonscrit](https://moonscript.org/)
* [class.lua](https://github.com/jonstoler/class.lua)
* [lua-class-lib](https://github.com/coin8086/lua-class-lib)
* [middleclass](https://github.com/kikito/middleclass)
