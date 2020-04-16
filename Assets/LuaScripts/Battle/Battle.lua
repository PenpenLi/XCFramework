---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/4/16 11:24
---
local Battle = BaseClass("Battle")
local battleId = 0
--战斗类型
local battleType = 0
local mapid = 0
--战斗回合
local roundNum = 0
--战斗单位
local battlers = nil
--战斗状态机
local battleState = nil
local battleScene = nil
local battleShow = nil
local beforeOperateAI = nil
-- 地图信息
local mapInfo = nil

--- private start ---

local function Parse(data)
    battleId = data.battleconfigid
    battleType = data.battletype
    mapid = data.mapid
end

local function InitBattleState()
    battleState = require "Battle.BattleStateContext".New()
    battleState:InitState()
end

local function InitbattleShow()
    battleShow = require "Battle.Show.BattleShow".New()
    battleShow:InitShow()
end

local function InitBattleScene()
    self.battleScene = require("Battle.Scene.BattleScenePlane").New()
    self.battleScene:InitScene()
end

local function AddJoinBattlerList(data)
    for _, v in pairs(data) do
        local battler = require "Battler.Battler".New()
        battler:Parse(v)
        battler:CreateBattler()
        table.insert(battlers, battler)
        --facade.executeMediator(ModuleId.Battle, false, "refreshBattlerBuff", true, battler.getBattlerId())
    end
end

local function SetAIActionBeforeOpearte(self, aiAction)
    beforeOperateAI = aiAction
end

--- private end ---

local function __init(self)
    battlers = {}
end

--- 战斗开始
local function EnterBattle(self, data)
    Parse(data)
    InitBattleState()
    InitbattleShow()
    InitBattleScene()
end

local function AddBattlerData(self, data)
    AddJoinBattlerList(data.fighterlist)
end

local function AddRoundScript(self, data)
    battleShow:SetBattleShowData(data)
end

--- 回合开始, 处理回合前AI
local function RoundStart(self, data)
    roundNum = roundNum + 1
    if (data and data.aiactions) then
        SetAIActionBeforeOpearte(data.aiactions)
    end
end

local function FindBattlerByID(self, id)
    for _, v in pairs(battlers) do
        if (v:GetBattlerId() == id) then
            return v
        end
    end
    return nil
end

local function DealAIAction(self, aiAction)

end

local function PrintResult(self)
    for _, v in pairs(battlers) do
        Logger.Log("battle end " .. v:GetBattlerId() .. " hp: " .. v:GetAttrAgent():GetHp())
    end
end

local function __delete(self)
    battleScene:Delete()
    for _, v in pairs(battlers) do
        v:Delete()
    end
end

--- get set start ---
local function GetMapInfo(self)
    return mapInfo
end

local function GetBattleState(self)
    return battleState
end

local function GetBattleShow(self)
    return battleShow
end

local function GetAIActionBeforeOpearte(self)
    return beforeOperateAI
end
--- get set end ---

Battle.__init = __init
Battle.EnterBattle = EnterBattle
Battle.AddBattlerData = AddBattlerData
Battle.AddRoundScript = AddRoundScript
Battle.RoundStart = RoundStart
Battle.FindBattlerByID = FindBattlerByID
Battle.DealAIAction = DealAIAction
Battle.PrintResult = PrintResult

Battle.GetMapInfo = GetMapInfo
Battle.GetBattleState = GetBattleState
Battle.GetBattleShow = GetBattleShow
Battle.GetAIActionBeforeOpearte = GetAIActionBeforeOpearte

Battle.__delete = __delete
return Battle