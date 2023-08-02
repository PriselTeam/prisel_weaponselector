Prisel = Prisel or {}

Prisel.WeaponSelector = Prisel.WeaponSelector or {}

local function Include(f) return include("prisel_weaponselector/"..f) end
local function AddLuaFile(f) return AddCSLuaFile("prisel_weaponselector/"..f) end
local function IncludeAdd(f) return Include(f), AddLuaFile(f) end

IncludeAdd("config.lua")

if SERVER then
    AddLuaFile("client/cl_functions.lua")
    AddLuaFile("client/cl_hooks.lua")
else
    Include("client/cl_functions.lua")
    Include("client/cl_hooks.lua")
end
