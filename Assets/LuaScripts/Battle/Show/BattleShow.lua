---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/4/16 12:15
---
local BattleShow = BaseClass("BattleShow")
local function InitShow(self)
    self.isFinish = false
    self.isStart = false
    self.roundAI = nil
    self.roundData = nil
end

local function SetBattleShowData(self, data)
    if self.isFinish == false then
        self:Clear()
    end
    self.playIndex = 0
    self.roundAI = data.aiactions
    self.roundData = data.playitem
end

local function Clear(self)
    self.roundAI = nil
    self.roundData = nil
    self.isStart = false
    self.isFinish = false
end

local function StartBattleShow(self)
    self.isStart = true
    self:DealWithBattleRound()
end

local function DealWithBattleRound(self)
    local hasData = self:TryGetFirstShowData()
    if hasData == true then
        local curShowData = self:GetFirstShowData()
        BattleShowUnit:GetInstance():StartShowUnit(curShowData, BindCallback(self, self.BattleShowUnitEnd))
    else
        self.isFinish = true
        --facade.executeMediator(ModuleId.Battle, false, "setRoundEnd", true)
        BattleManager:GetInstance():GetBattle():GetBattleState():TriggerEvent(BattleStateEvent.BattleWaitEnd)
    end
end

-- 一个表现单元结束
local function BattleShowUnitEnd(self)
    local callTime = TimerManager:GetInstance():GetTimer(0.2, self.DealWithBattleRound, self, true, false)
    callTime:Start()
end

local function TryGetFirstShowData(self)
    local skillCount = table.length(self.roundData)
    if skillCount > 0 then
        return true
    end
    return false
end

local function GetFirstShowData(self)
    if (self.roundData) then
        local skillCount = table.length(self.roundData)
        if skillCount > 0 then
            return table.remove(self.roundData, 1)
        end
    end
    return nil
end

BattleShow.InitShow = InitShow
BattleShow.SetBattleShowData = SetBattleShowData
BattleShow.Clear = Clear
BattleShow.StartBattleShow = StartBattleShow
BattleShow.DealWithBattleRound = DealWithBattleRound
BattleShow.BattleShowUnitEnd = BattleShowUnitEnd
BattleShow.TryGetFirstShowData = TryGetFirstShowData
BattleShow.GetFirstShowData = GetFirstShowData
return BattleShow