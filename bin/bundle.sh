#!/bin/bash

luabundler bundle Ferret/Ferret.lua -p "./?.lua" -o ferret.lua
sed -i 's/return __bundle_require("__root")/ferret = __bundle_require("__root")/' ferret.lua