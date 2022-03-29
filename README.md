# Lua Class

![Tests](https://github.com/Felyp-Henrique/class/actions/workflows/tests.yml/badge.svg)
![Distribution](https://github.com/Felyp-Henrique/class/actions/workflows/distribution.yml/badge.svg)

The library **class.lua** is done to do support the **Object Oriented Programming** inspired in _Java_ and _Python_.

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

Coming soon

```lua
class = require('class').class

Point = class('Point', {
    statics = {
        BEGIN_X = 0,
        BEGIN_Y = 0
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
    Point.BEGIN_X,
    Point.BEGIN_y
)
```

## Alternatives

Some alternatives:

* [class.lua](https://github.com/jonstoler/class.lua)
* [moonscrit](https://moonscript.org/)
* [lua-class-lib](https://github.com/coin8086/lua-class-lib)
* [middleclass](https://github.com/kikito/middleclass)
* and others...
