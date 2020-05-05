---
--- 战斗特效控制器
--- Created by ricashao.
--- DateTime: 2020/4/18 0:32
---
---AniOption{
---    x
---    y
---    parent 父容器
---    childIdx 有parent此值才有意义
---    loop 循环次数
---    handler 事件处理的回调函数
---}
---
local PosType = {
    HALO = 0,
    CENTER = 1,
    POS = 2,
    CASTER = 3,
    HURT = 4,
}

local AniController = BaseClass("AniController", Singleton)
local BattleEffect = require "Battle.Effect.BattleEffect"
--获取战斗龙骨特效动画
local function GetAniRender(uri, aniOption)
    local battleEffect = BattleEffect.New()
    battleEffect:Init(uri, aniOption)
    return battleEffect
end

local function PlayAniByType(self, posType, uri, target, aniOption)
    if posType == PosType.HALO then
        return self:PlayAniOnTargetHalo(uri, target, aniOption)
    elseif posType == PosType.HURT then
        return self:PlayAniOnTargetHurtPoint(uri, target, aniOption)
    elseif posType == PosType.CASTER then
        return self:PlayAniOnTargetHalo(uri, target, aniOption)
    end
end

local function PlayAniOnTargetHalo(self, uri, unit, aniOption)
    if (IsNull(unit)) then
        return
    end
    local ani = GetAniRender(uri, aniOption)
    unit:AddToHalo(ani.gameObject)
    return ani
end

local function PlayAniOnTargetHurtPoint(self, uri, unit, aniOption)
    if (IsNull(unit)) then
        return
    end
    local ani = GetAniRender(uri, aniOption)
    unit:AddToBodyBuff(ani)
    return ani
end

--[[
* 往目标实体的身上加特效
*
* @param {string} uri 动画地址
* @param {UnitEntity} entity 目标实体
--]]
local function PlayAniOnTargetBody(self, uri, unit)
    if IsNull(unit) then
        return
    end
    local ani = GetAniRender(uri)
    unit:AddToBodyBuff(ani)
    return ani
end

AniController.PlayAniOnTargetHalo = PlayAniOnTargetHalo
AniController.PlayAniOnTargetHurtPoint = PlayAniOnTargetHurtPoint
AniController.PlayAniOnTargetBody = PlayAniOnTargetBody
AniController.PlayAniByType = PlayAniByType
return AniController