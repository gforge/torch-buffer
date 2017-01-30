package = "torch-buffer"
version = "scm-1"
source = {
    url = "https://github.com/gforge/torch-buffer/archive/master.tar.gz",
    dir = "torch-buffer-master"
}
description = {
    summary = "A simple buffer for torch",
    detailed = [[
       A simple numeric buffer that can calculate mean and standard deviation
    ]],
    homepage = "https://github.com/gforge/torch-buffer",
    license = "MIT/X11",
    maintainer = "Max Gordon"
}
dependencies = {
    "lua >= 5.1",
    "torch >= 7.0",
    "argcheck >= 2.0",
    "torch-dir-loader >= 0.5"
}
build = {
   type = "cmake",
   variables = {
      CMAKE_BUILD_TYPE="Release",
      LUA_PATH="$(LUADIR)"
   }
}
