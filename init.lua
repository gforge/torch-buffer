local paths = require 'paths'
local loader = require 'torch-dir-loader'
local buffer_dir = string.gsub(paths.thisfile(), "[^/]+$", "")

local loaded_files, docs, buffer = loader(buffer_dir .. "src/")

return buffer
