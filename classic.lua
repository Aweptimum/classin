-- The license for rxi's classic, found here: https://github.com/rxi/classic/blob/master/LICENSE
-- has been copied below to comply with its usage and distribution
--[[
Copyright (c) 2014, rxi


Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

---@class Object
---@field __name string
local Object = {}
Object.__index = Object

---Abstract constructor
function Object:new()
end

---Inheritance method
---@return Object cls child class
function Object:extend(name)
	local cls = {}
	for k, v in pairs(self) do
		if k:find("__") == 1 then
			cls[k] = v
		end
	end
	cls.__name = name or 'Object'
	cls.__index = cls
	cls.super = self
	setmetatable(cls, self)
	return cls
end

local function implement(self, cls)
	for k, v in pairs(cls) do
		if self[k] == nil then
			if type(v) ~= 'table' then
				self[k] = v
			else
				self[k] = {}
				implement(self[k], v)
			end
		end
	end
end

---Implement given interfaces (fields + functions)
---@vararg Object
---@return Object self
function Object:implement(...)
	for _, cls in pairs({...}) do
		implement(self, cls)
	end
	return self
end

---Checks that an object is an instance of given class
---@param T Object class to check against
---@return boolean
function Object:is(T)
	local mt = getmetatable(self)
	while mt do
		if mt == T then
			return true
		end
		mt = getmetatable(mt)
	end
	return false
end

function Object:__tostring()
	return self.__name
end

---Metamethod constructor
---@return Object new
function Object:__call(...)
	local obj = setmetatable({}, self)
	obj:new(...)
	return obj
end


return Object
