---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/5/5 12:17
---
local cBuffFile = require "Config.Data.CBuffConfig"

local BuffDB = {}

local function GetCBuffConfigById(buffId)
    return cBuffFile[buffId]
end

BuffDB.GetCBuffConfigById = GetCBuffConfigById

return ConstClass("BuffDB", BuffDB)