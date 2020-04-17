---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2020/4/10 14:33
---
local Character = BaseClass("Character", TransformObject)

local function InitDefaultAction(self)
    self.aStandBy = require("Unit.UnitAction").New()
end

local currentAction = nil
local nextAction = nil

--绑定监听
local function StartRender(self)
    self._uRender:AddDBEventListener(CS.DragonBones.EventObject.COMPLETE, Bind(self, self.PlayComplete))
    self._uRender:AddDBEventListener(CS.DragonBones.EventObject.FRAME_EVENT, Bind(self, self.DispatchEvent))
    self:StartUnitAction()
end

local function __init(self)
    --战斗id
    self.fighterId = nil
    --龙骨模型
    self.shape = nil

    --坐标
    self.pos = nil
    self.speed = nil
    self.layer = SceneLayer.Character

    --加载模型标志位
    self.initResourceOk = false
    self.inited = false

    --角色创建好了后,是否显示隐藏
    self.hide = false

    --  名字，血条， 特效，代理
    self.hudAgent = nil

    self.root = nil
    -- 加载后的资源
    self.pfb = nil
    -- 模型
    self.model = nil
    self.modelName = nil

    --模型朝向
    self.d = nil
    --模型动作
    self.a = nil



    -- 角色资源加载回调
    self.resourceCallBack = nil

    self.actionConttroller = nil

    InitDefaultAction(self)

    if self.Update ~= nil then
        self.__update_handle = BindCallback(self, self.Update)
        UpdateManager:GetInstance():AddUpdate(self.__update_handle)
    end

end

local function Initialize(self, fighterInfo, pos, dir, callback)
    self.shape = fighterInfo.shape
    self.pos = pos
    self.d = dir
    self.resourceCallBack = callback
    if self.inited then
        return
    end
    self.hudAgent = require "Logic.Character.HudAgent".New(self)
    -- 加载
    GameObjectPool:GetInstance():GetGameObjectAsync(self.shape, BindCallback(self, self.CharacterLoadedEnd))
    self.inited = true
end

local function CharacterLoadedEnd(self, pfb)
    if IsNull(pfb) then
        return
    end
    self.pfb = pfb
    pfb.transform.position = Vector3.zero
    pfb.transform:SetParent(self.transform, false);
    -- todo 临时注释
    self.model = require "Character.Model.Model".New(self)
    self.initResourceOK = true

    -- self.hide为false表示默认不隐藏
    -- todo 临时注释
    self:SetVisible(not self.hide)

    self:RefreshCharacterView()
    if self.resourceCallBack then
        self.resourceCallBack()
    end

    -- 获取龙骨
    self._uRender = self.pfb:GetComponent(typeof(CS.DragonBones.UnityArmatureComponent))
    StartRender(self)
end

local function DispatchEvent(self, type, eventObject)
    print("event" .. eventObject.name)
    if (currentAction) then
        currentAction:DispatchEvent(self, eventObject.name)
    end
end

local function PlayComplete(self, type, eventObject)
    local flag = false
    if (currentAction) then
        currentAction:PlayComplete(self)
        if (currentAction:IsEnd()) then
            flag = true
        end
    else
        flag = true
    end

    if flag then
        local next = nextAction
        nextAction = nil
        self:StartUnitAction(next)
    end
end


-- 开始执行单位动作
-- @return true     成功执行动作
--         false    未成功执行动作，将动作覆盖到下一个动作
local function StartUnitAction(self, action, stop, callback)
    action = action or self.aStandBy
    stop = stop or false
    if currentAction then
        if currentAction ~= action then
            if (currentAction:IsEnd()) then
                currentAction = action
                currentAction:Start(self, true, callback)
            elseif stop or currentAction:CanStop() then
                currentAction:Terminate(self)
                currentAction = nil
                currentAction = action
                currentAction:Start(self, true, callback)
            else
                --不可结束，覆盖下一个动作
                if (nextAction) then
                    nextAction = nil
                end
                nextAction = action
            end
        end
    else
        currentAction = action
        currentAction:Start(self, true, callback)
    end
    currentAction:PlayAction(self, 0, now);
end

-- 刷新所外形相关数据
local function RefreshCharacterView(self)
    if not self.model then
        return
    end

    if self.hudAgent then
        self:RefreshHudView()
    end

    self:UpdateLayer()

end

local function RefreshHudView(self)
end

local function UpdateLayer(self)
    if not (self.initResourceOK) then
        return
    end

    self.gameObject.layer = self:GetLayer()
    local components = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Transform))
    local length = components.Length - 1
    for i = 0, length do
        components[i].gameObject.layer = self.layer
    end
end

local function LateTick(self, delta)
    if not self.visible then
        return
    end

    if self.hudAgent then
        self.hudAgent:LateTick(delta)
    end
end

local function Update(self)
    local delta = Time.deltaTime
    if not self.visible then
        return
    end

    if self.hudAgent then
        self.hudAgent:LateTick(delta)
    end
end


-- 执行动作序列
-- @private 只允许UnitAction调用
local function DoAction(self, action)
    --lua 数组从1 开始 action= action+1
    self.a = action + 1
    local curaim = ActionAim[self.a] .. FaceDirection[self.d]
    self._uRender.armature.flipX = FaceScaleX[self.d]
    self._uRender.animation:Play(curaim)
end

local function ChangeFace(self, dir)
    self.d = dir
    local curaim = ActionAim[self.a] .. FaceDirection[self.d]
    self._uRender.armature.flipX = FaceScaleX[self.d]
    self._uRender.animation:Play(curaim)
end

local function __delete(self)
    if self.hudAgent then
        self.hudAgent:Delete()
    end
    if self.__update_handle ~= nil then
        UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
        self.__update_handle = nil
    end
    GameObjectPool:GetInstance():RecycleGameObject(self.shape, self.pfb)
end

----------------------- Set and Get 成员变量 Begin --------------------------------

-- 子类实现
local function GetType(self)
    return CHARACTER_TYPE.NONE;
end

local function IsVisible(self)
    return self.visible
end

local function SetVisible(self, visible)
    if not self.initResourceOK then
        return
    end

    self.visible = visible
    --self.gameObject:SetActive(visible)


    if self.hudAgent then
        self.hudAgent:SetVisible(self.visible)
    end

end

local function GetPrefabRes(self)
    return self.pfb
end

local function GetModel(self)
    return self.model
end

local function GetLayer(self)
    return self.layer
end

local function GetRealPos(self)
    local pos = self:GetLocalPosition()
    return { x = pos.x, y = pos.y }
end

local function FaceTo(self)
    return self.d
end

----------------------- Set and Get 成员变量 End   --------------------------------

----------------------------战斗相关显示 ---------------------------------
local function SetName(self, name, cameraLayer, hudType)
    if not self.hudAgent then
        return
    end
    self.hudAgent:SetName(name, cameraLayer, hudType)
end

-- 头顶泡泡，会根据character判断是场景聊天还是战斗喊话
local function Speak(self, message)
    if self.hudAgent then
        self.hudAgent:SetChat(message);
    end
end

Character.__init = __init
Character.Initialize = Initialize
Character.CharacterLoadedEnd = CharacterLoadedEnd
Character.RefreshCharacterView = RefreshCharacterView
Character.RefreshHudView = RefreshHudView
Character.StartUnitAction = StartUnitAction
Character.DispatchEvent = DispatchEvent
Character.PlayComplete = PlayComplete
Character.DoAction = DoAction
Character.ChangeFace = ChangeFace
Character.UpdateLayer = UpdateLayer
Character.LateTick = LateTick
Character.Speak = Speak
--测试方便使用
Character.Update = Update
Character.SetName = SetName
Character.__delete = __delete

Character.IsVisible = IsVisible
Character.GetType = GetType
Character.SetVisible = SetVisible
Character.GetPrefabRes = GetPrefabRes
Character.GetModel = GetModel
Character.GetLayer = GetLayer
Character.GetRealPos = GetRealPos
Character.FaceTo = FaceTo
return Character