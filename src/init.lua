local argcheck = require 'argcheck'

local buffer = torch.class('buffer')

buffer.__init = argcheck{
  doc = [[
<a name="buffer">
# buffer(@ARGP)
Create a buffer with x number of elements.

@ARGT
]],
  {name='self', type='buffer'},
  {name='length', type='number',
   doc='The number of elements that the buffer should have'},
  call = function(self, length)
  assert(length > 0, 'The length shold be >= 1')

  self._position = 0
  self._no_elments = length
  self._data = {}
end}

buffer.__init = argcheck{
  doc = [[
You can provide a table with all the initial values as well
@ARGT
]],
  overload=buffer.__init,
  {name='self', type='buffer'},
  {name='tbl', type='table',
   doc='A table with the elements'},
  call = function(self, tbl)
  assert(#tbl > 0, 'The length shold be >= 1')

  self._position = #tbl
  self._no_elments = #tbl
  self._data = tbl
end}

buffer.add = argcheck{
  doc = [[
<a name="bufffer.add">
# add(@ARGP)
Add a value to the buffer (same as push)

@ARGT
]],
  {name='self', type='buffer'},
  {name='number', type='number', doc='The number to add to the buffer'},
  call=function(self, number)
  return self:push(number)
end}

buffer.push = argcheck{
  doc = [[
<a name="bufffer.push">
# push(@ARGP)
Push a value to the buffer

@ARGT
]],
  {name='self', type='buffer'},
  {name='number', type='number', doc='The number to push to the buffer'},
  call=function(self, number)
  self._position = self._position + 1
  if (self._position > self._no_elments) then
    self._position = 1
  end

  if (self._no_elments < #self._data and
      self._position < #self._data) then
    table.insert(self._data, self._position, number)
  else
    self._data[self._position] = number
  end

  return self
end}

buffer.pop = argcheck{
  doc = [[
<a name="bufffer.pop">
# pop(@ARGP)
Pop last inputted value from the buffer

@ARGT
  ]],
  {name='self', type='buffer'},
  call=function(self)
  if (self._position < 1) then
    return 0/0
  end

  local value = self._data[self._position]
  table.remove(self._data, self._position)
  self._position = self._position - 1
  if (self._position < 1) then
    self._position = #self._data
  end

  return value
end}

buffer.get_tensor = argcheck{
  doc = [[
<a name="bufffer.get_tensor">
# get_tensor(@ARGP)
Retrieves a tensor with the x-last elements

@ARGT
]],
    {name='self', type='buffer'},
    {name='no', type='number', opt=true,
     doc='The number of elements back to include in the calculation'},
    {name='skip_order', type='boolean', default=false,
     doc='If the order of the data is to be preserved, skip for performance'},
    call=function(self, no, skip_order)
  -- This could benefit from some speedup
  if (self._position < 1) then
    return torch.DoubleTensor();
  end

  local data4tensor = {}
  if (no) then
    if (no > #self._data) then
      no = #self._data
    end
  else
    no = #self._data
  end

  if (no == #self._data and skip_order) then
    data4tensor = self._data
  else
    local pos = self._position + 1
    for i=1,no do
      if (pos > #self._data) then
        pos = 1
      end
      data4tensor[#data4tensor + 1] = self._data[pos]
      pos = pos + 1
    end
  end

  return torch.DoubleTensor(data4tensor)
end}

buffer.mean = argcheck{
  doc = [[
<a name="bufffer.mean">
# mean(@ARGP)
Calculate the buffer mean

@ARGT
]],
  {name='self', type='buffer'},
  {name='no', type='number', opt=true,
   doc='The number of elements back to include in the calculation'},
  call=function(self, no)
  local dataTnsr = self:get_tensor{
    no = no,
    skip_order = true,
  }
  return dataTnsr:mean()
end}


buffer.std = argcheck{
  doc = [[
<a name="bufffer.std">
# std(@ARGP)
Calculate the buffer standard deviation

@ARGT
]],
  {name='self', type='buffer'},
  {name='no', type='number', opt=true,
   doc='The number of elements back to include in the calculation'},
  call=function(self, no)
  local dataTnsr = self:get_tensor{
    no = no,
    skip_order = true,
  }
  return dataTnsr:std()
end}

buffer.__tostring__ = argcheck{
  doc=[[
<a name="buffer.__tostring__">
# __tostring__(@ARGP)
Outputs a buffer to a string

@ARGT

_Return value_: string
]],
  {name="self", type="buffer"},
  call=function (self)
  local out = '['
  local data = self:get_tensor()
  for i=1,#self._data do
    if (i ~= 1) then
      out = out .. ', '
    end
    out = out .. data[i]
  end

  return out .. ']'
end}

return buffer
