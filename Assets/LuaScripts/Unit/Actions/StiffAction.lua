---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/4/17 21:29
---
local StiffAction = BaseClass("StiffAction", GUnitAction)

local function __init(self)
    self._action = UnitActionManager:GetInstance():GetAction(ActionType.hurt)
end

--播放动作
local function Start(self, unit, has, cb)
    self._isEnd = false
    self.endCallBack = cb
end

--动画播放结束的回调
local function PlayComplete(self)
    self._isEnd = true
    if (self.endCallBack) then
        self.endCallBack()
    end
end

StiffAction.__init = __init
StiffAction.Start = Start
StiffAction.PlayComplete = PlayComplete
return StiffAction