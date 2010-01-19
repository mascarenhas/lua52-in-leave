
local setmetatable = setmetatable
local print = print

print()
print("SIMPLE >>>>>>")
print()

local t = {}

in t do
  a = 2
  b = 3 + 5
  print("foo")
end

print(t.a, t.b)

print()
print("LEAVE >>>>>>")
print()

local t = {}

setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

in t do
  a = 5
  b = 2 + 5
  print("foo")
end

print(t.a, t.b)

print()
print("NESTED LEAVE >>>>>>")
print()

local t = {}

setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

in t do
  a = 5
  b = 2 + 5
  print("foo")
  in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
    print("bar")
  end
end

print(t.a, t.b)

print()
print("LEAVE ON RETURN >>>>>>")
print()

function foo()
  local t = {}
  setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    return "foo"
  end

  print("bar")
end

print(foo())

print()
print("NESTED LEAVE ON RETURN >>>>>>")
print()

function foo()
  local t = {}
  setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
      return "foo"
    end
  end

  print("bar")
end

print(foo())

print()
print("LEAVE ON BREAK >>>>>>")
print()

local t = {}

setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

for i = 1, 5 do
  in t do
    a = 5
    b = 2 + 5
    if i == 3 then break end
    print("foo", i)
  end
end

print(t.a, t.b)

print()
print("NESTED LEAVE ON BREAK >>>>>>")
print()

local t = {}

setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

for i = 1, 5 do
  in t do
    a = 5
    b = 2 + 5
    in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
      if i == 3 then break end
      print("bar")
    end
    print("foo", i)
  end
end

print(t.a, t.b)

print()
print("LEAVE ON ERROR >>>>>>")
print()

local error = error

function foo()
  local t = {}
  setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    error("foo")
  end

  print("bar")
end

print(pcall(foo))

print()
print("NESTED LEAVE ON ERROR >>>>>>")
print()

local error = error
local setmetatable = setmetatable
local print = print

function foo()
  local t = {}
  setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
      error("foo")
    end
  end

  print("bar")
end

print(pcall(foo))

print()
print("NESTED LEAVE ON ERROR WITH ERROR IN INNER >>>>>>")
print()

local error = error
local setmetatable = setmetatable
local print = print

function foo()
  local t = {}
  setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    in setmetatable({ c = t.a + t.b }, { __leave = function (t) print(2 + nil) end }) do
      error("foo")
    end
  end

  print("bar")
end

print(pcall(foo))

print()
print("NESTED LEAVE ON BREAK 2 >>>>>>")
print()

local t = {}

setmetatable(t, { __leave = function (t) print("Leaving...", t.a) end })

  in t do
    a = 5
    b = 2 + 5
    for i = 1, 5 do
      in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
	if i == 3 then break end
	print("bar")
      end
      print("foo", i)
    end
    print("baz")
  end

print(t.a, t.b)

print()
print("NESTED LEAVE WITH ERROR ON TOPLEVEL >>>>>>")
print()

local coro = coroutine.create(function ()
				local t = {}
				
				setmetatable(t, { __leave = function (t, err) print("Leaving...", t.a, err) end })
				
				in t do
				  a = 5
				  b = 2 + 5
				  print("foo")
				  in setmetatable({ c = t.a + t.b }, { __leave = function (t) print("Leaving inner...", t.c) end }) do
				    error("bar")
				  end
				end
				
				print(t.a, t.b)
			      end)

print(coroutine.resume(coro))
