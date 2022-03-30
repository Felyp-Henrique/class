# Lua Class

**This library doesn't have a stable version yet.**

![Tests](https://github.com/Felyp-Henrique/class/actions/workflows/tests.yml/badge.svg)
![Distribution](https://github.com/Felyp-Henrique/class/actions/workflows/distribution.yml/badge.svg)

The library **class.lua** is done to do support the **Object Oriented Programming** inspired in _Java_ and _Python_.

The purpose this library is help you to model your software and game better using the similar _OOP_ of _Java_ and _Python_. The features more dominant this library can remind you of _Python_.

## Some features

- [x] Class definition support
- [x] Inheritance support
- [x] **Override** and **super** support
- [x] Statics members support
- [x] Root class Object like _Java Object_ and _Python object_ type
- [x] Basics methods in Object like **clone**, **equals** and **toString**
- [x] Type validators and inheritance checking
- [ ] Private members like _Python_
- [ ] Abstracts classes support
- [ ] Interfaces support

## Documentation and Examples

The documentation is present in [Wiki](https://github.com/Felyp-Henrique/class/wiki) page this repository.

Bellow, one simple example:

```lua
class = require('class').class

Point = class('Point', {
    statics = {
        DEFAULT_X = 0,
        DEFAULT_Y = 0
    },
    constructor = function(self, x, y)
        self.x = x
        self.y = y
    end,
    getDistance = function(self, point)
        return math.sqrt((point.x - self.x) ^ 2 + (point.y - self.y) ^ 2)
    end
})

local point = Point:new(
    Point.DEFAULT_X,
    Point.DEFAULT_Y
)
```

## Alternatives

Some alternatives:

* [class.lua](https://github.com/jonstoler/class.lua)
* [moonscrit](https://moonscript.org/)
* [lua-class-lib](https://github.com/coin8086/lua-class-lib)
* [middleclass](https://github.com/kikito/middleclass)
* and others...
