---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2020/3/28 9:31
---

local InputTouch = BaseClass("InputTouch", Singleton)
local Fighter = require("Touch.Finger")
local TouchScreen = require("Touch.TouchScreen")
local Application = CS.UnityEngine.Application
local mainCamera = CS.UnityEngine.Camera.main;
local finger = nil
local touchScreen = nil

local function __init(self)
    self.isMobilePlatform = Application.isMobilePlatform
    finger = Fighter.New(mainCamera)
    touchScreen = TouchScreen.New()
end

local function SetCamera(self, camera)
    mainCamera = camera;
    if finger then
        finger:SetCamera(camera);
    end
end

local function Tick(self, delta_time)

    if finger then
        finger:Tick();
        if (IsNull(finger.CurrentSelectedGameObject)) then
            touchScreen:Tick(deltaTime);
        end
    else
        touchScreen:Tick(deltaTime);
    end
end

local function SetTouchCamera(camera)
    if touchScreen then
        touchScreen:SetRayCamera(camera);
    end
end


local mouseUpState = false
local rayHit = nil

local function SetTouchButtonState(self, state)
    mouseUpState = state
end

local function OnTouchScreen(self, mousePosition)
    --UIManager:GetInstance():OnTouch(mousePosition, mosueUpState);
end

local function OnTouch(self, rayHits)

    ----主界面在拖动UI
    --if MainSceneViewSlipCtrl.InSceneViewDrag() then
    --    return
    --end

    if self:CheckObj(rayHits) then
        return
    end

    rayHit = self:GetRayHit(rayHits);
    if rayHit then
        --player = CharacterManager:GetInstance():GetHostCharacter();
        --if player then
        --    player:GetCharacterContext():Move(rayHit.point);
        --end
    end

    --if BattleManager.GetIsBattle() == false then
    --    UIHitEffectManager:GetInstance():PlayEffect(rayHit);
    --
    --    --防范性代码
    --    local mainScene = MainSceneViewCtrl:GetInstanceNotCreate();
    --    if mainScene and mainScene:IsSlipOut() then
    --        mainScene:SlipIn();
    --    end
    --end
end

local function GetRayHit(self, rayHits)
    if rayHits == nil then
        return ;
    end

    local bestPointIndex = 0;
    local bestPointY = rayHits[0].point.y;
    for i = 1, (rayHits.Length - 1) do
        if (rayHits[i].point.y) > bestPointY then
            bestPointY = rayHits[i].point.y;
            bestPointIndex = i;
        end
    end

    return rayHits[bestPointIndex];
end

local function CheckObj(self, rayHits)
    if not rayHits then
        return ;
    end

    local hit, character, objInstanceID, hitTransform

    for i = 0, (rayHits.Length - 1) do
        hit = rayHits[i]
        if hit and hit.transform then
            objInstanceID = hit.transform.gameObject:GetInstanceID();
            hitTransform = CharacterManager:GetInstance():CheckCharacter(objInstanceID);

            if hitTransform then
                character = hitTransform;
                if character:GetType() == CHARACTER_TYPE.NPC then
                    break ;
                end
            end
        end
    end

    local curScene = SceneManager:GetInstance():GetCurScene();
    if not curScene then
        return false;
    end

    if character then
        curScene:OnSelectedCharacter(character);
        return true;
    else
        curScene:OnSelectedCharacter(nil);
        return false;
    end

end

InputTouch.__init = __init
InputTouch.SetCamera = SetCamera
InputTouch.Tick = Tick
InputTouch.SetTouchButtonState = SetTouchButtonState
InputTouch.OnTouchScreen = OnTouchScreen
InputTouch.OnTouch = OnTouch

return InputTouch