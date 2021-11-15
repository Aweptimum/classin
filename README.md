# Classin

A fork of rxi's tiny class module for Lua. Attempts to stay simple and provide decent
performance by avoiding unnecessary over-abstraction.

## Added features:
* `:implement()` no longer restricted to just functions, copies static fields as well
* [EmmyLua annotations](https://emmylua.github.io/annotation.html)
* Added optional class name arg to `:extend`

## Usage

The [module](classic.lua) should be dropped in to an existing project and
required by:

```lua
Object = require "classic"
```

The module returns the object base class which can be extended to create any
additional classes.


### Creating a new class
```lua
Point = Object:extend('Point') -- optional name

function Point:new(x, y)
  self.x = x or 0
  self.y = y or 0
end
```

### Creating a new object
```lua
local p = Point(10, 20)
```

### Extending an existing class
```lua
Rect = Point:extend()

function Rect:new(x, y, width, height)
  Rect.super.new(self, x, y)
  self.width = width or 0
  self.height = height or 0
end
```

### Checking an object's type
```lua
local p = Point(10, 20)
print(p:is(Object)) -- true
print(p:is(Point)) -- true
print(p:is(Rect)) -- false 
```

### Using static variables
```lua
Point = Object:extend()
Point.scale = 2

function Point:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Point:getScaled()
  return self.x * Point.scale, self.y * Point.scale
end
```

### Creating a metamethod
```lua
function Point:__tostring()
  return self.x .. ", " .. self.y
end
```

### Using mixins
```lua
PairPrinter = Object:extend()
PairPrinter.limit = 1

function PairPrinter:printPairs()
  local i = 0
  for k, v in pairs(self) do
    i = i + 1
    print(k, v)
    if i >= self.limit then return end
  end
end


Point = Object:extend()
Point:implement(PairPrinter)

function Point:new(x, y)
  self.x = x or 0
  self.y = y or 0
end


local p = Point()
p:printPairs() -- only prints one pair
```


## License

This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.

