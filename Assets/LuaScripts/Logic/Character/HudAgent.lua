---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2020/4/10 15:39
---
local HudAgent = BaseClass("HudAgent")

local HUDTYPE_OFFSET = {
    TOP_NAME = Vector3.New(0, 1.72, 0); -- 头顶名字
    CHARACTER_BLOOD = Vector3.New(0, 1.2, 0); -- 血条

    PLAYER_CHAT = 10; -- 聊天气泡

    BATTLE_EFFECTS = 11; -- 战斗特效
    BATTLE_HP = 12; -- 战斗掉血
}

local PLAYER_NAME_COLOR_ID = 223;
local NPC_NAME_COLOR_ID = 221;

local function __init(self, character)
    self.character = character
    self.uiName = nil
    self.uiChat = nil

end

-- 设置名字
local function SetName(self, name, cameraLayer, hudType)
    if not self.character then
        return
    end

    if (not name) and (not cameraLayer) then
        return
    end

    if not hudType then
        return
    end

    local offset
    if hudType == HUD_TYPE.TOP_NAME then
        offset = HUDTYPE_OFFSET.TOP_NAME
    end

    if not offset then
        return
    end

    local nameColor
    --if self.character:GetType() == CHARACTER_TYPE.NPC then
    --    nameColor = self:GetColorValue(NPC_NAME_COLOR_ID)
    --else
    --    nameColor = self:GetColorValue(PLAYER_NAME_COLOR_ID)
    --end

    if self.uiName == nil then
        self.uiName = require "Logic.Character.UIName".New(self.character, cameraLayer, offset)
    end

    self.uiName:SetUIName(name, nameColor)
    self.uiName:SetVisible(true)
end

local function SetChat(self, message)
    if not message or not self.character then
        return
    end

    if self.uiChat == nil then
        self.uiChat = require "Logic.Character.UIChat".New(self.character)
    end
    self.uiChat:SetVisible(true)
    self.uiChat:ShowChat(message)
end

local function SetVisible(self, visible)

    if self.uiName then
        self.uiName:SetVisible(visible)
    end

    if self.uiChat then
        self.uiChat:SetVisible(visible)
    end
end

local function LateTick(self, delta)
    if self.uiName and (self.uiName:IsVisible()) then
        self.uiName:LateTick(delta)
    end

    if self.uiChat and (self.uiChat:IsVisible()) then
        self.uiChat:LateTick(delta)
    end
end

local function __delete(self)
    if self.uiName then
        self.uiName = nil
    end

    if self.uiChat then
        self.uiChat = nil
    end
end

HudAgent.__init = __init
HudAgent.SetName = SetName
HudAgent.SetChat = SetChat
HudAgent.SetVisible = SetVisible
HudAgent.LateTick = LateTick
HudAgent.__delete = __delete
return HudAgent;