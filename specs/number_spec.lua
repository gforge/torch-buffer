require 'lfs'
local _ = require 'moses'

-- Make sure that directory structure is always the same
if (string.match(lfs.currentdir(), "/specs$")) then
  lfs.chdir("..")
end

dofile('init.lua')

-- Go into specs so that the loading of CSV:s is the same as always
lfs.chdir("specs")

describe("Create basic numerical buffer", function()
  it("add/pop", function()
    local a = buffer(3)
    a:add(1)
    assert.are.same(a:mean(), 1)

    a:add(2)
    assert.are.same(a:mean(), (1 + 2)/2)

    a:add(3)
    assert.are.same(a:mean(), (1 + 2 + 3)/3)

    a:add(4)
    assert.are.same(a:mean(), (4 + 2 + 3)/3)

    local val = a:pop()
    assert.are.same(val, 4)
    assert.are.same(a:mean(), (2 + 3)/2)

    a:add(5)
    assert.are.same(a:mean(), (5 + 2 + 3)/3)
  end)

  it("creating with a table", function()
    local a = buffer({1,2,3})
    assert.are.same(a:mean(), 2)

    a:add(4)
    assert.are.same(a:mean(), (4 + 2 + 3)/3)
  end)


  it("std deviation", function()
    local vals = {1,2,3}
    local a = buffer(vals)
    assert.are.same(a:std(), torch.DoubleTensor(vals):std())
  end)

  it("string conversion", function()
    local a = buffer(3)
    assert.are.same(tostring(a), '[]')

    a:push(1)
    assert.are.same(tostring(a), '[1]')

    a:push(11)
    assert.are.same(tostring(a), '[1, 11]')

    a:push(111)
    assert.are.same(tostring(a), '[1, 11, 111]')

    a:push(1111)
    assert.are.same(tostring(a), '[11, 111, 1111]')
  end)
end)
