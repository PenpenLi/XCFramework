---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2020/4/8 9:28
---
require "Battle.Scene.BattleSceneCommon"
local BattleScenePlane = BaseClass("BattleScenePlane")

local function __init(self)
    self.planeBackground = CS.UnityEngine.GameObject.Find("BattleBg") -- 3D平面 模拟背景
    self.centPos = nil         -- 中心坐标
    self.allBattlePos = {}
end

local function __delete(self)
    self.centPos = nil
    self.allBattlePos = {}
    self.planeBackground:SetActive(false)
    self.centPos = Vector3.zero
end

-- 计算显示区域的四个顶点
local function GetCorners(camera, distance)
    local halfFOV = (camera.fieldOfView * 0.5) * Mathf.Deg2Rad
    local aspect = camera.aspect

    local height = distance * Mathf.Tan(halfFOV)
    local width = height * aspect
    local tx = camera.transform
    local tempcorners = {}
    --UpperLeft
    local tmp = tx.position - (tx.right * width) + tx.up * height + tx.forward * distance
    tempcorners[1] = tmp
    --UpperRight
    tmp = tx.position + (tx.right * width) + tx.up * height + tx.forward * distance
    tempcorners[2] = tmp
    --LowerLeft
    tmp = tx.position - (tx.right * width) - tx.up * height + tx.forward * distance
    tempcorners[3] = tmp
    --LowerRight
    tmp = tx.position + (tx.right * width) - tx.up * height + tx.forward * distance
    tempcorners[4] = tmp
    return tempcorners
end


-- 属性计算 战斗场景自适应场景相机
local function CalPlaneTransform(self)
    -- 获取主摄像机
    --local camera = CameraManager:GetInstance().mainCamera:GetCamera()
    local camera = GameLayerManager:GetInstance().battleCamera
    -- 获取相机距离
    local distance = 10
    -- 获取相机显示区域的四个角
    local corners = GetCorners(camera, distance)

    -- position
    local position = (corners[1] + corners[2]) / 2
    local position1 = (corners[3] + corners[4]) / 2
    local finalPos = (position + position1) / 2
    self.planeBackground.transform.position = finalPos

    -- rotation
    local tempQua = camera.transform.rotation;
    local quaternion = Quaternion.New(tempQua.x, tempQua.y, tempQua.z, tempQua.w)
    --local euler = quaternion.eulerAngles
    --local finalVec = Vector3.New(euler.x, euler.y, euler.z)
    --quaternion = Quaternion.Euler(finalVec.x, finalVec.y, finalVec.z)
    self.planeBackground.transform.rotation = quaternion

    -- scale
    local halfFOV = (camera.fieldOfView * 0.5) * Mathf.Deg2Rad
    local aspect = camera.aspect
    local height = 10 * Mathf.Tan(halfFOV)
    local width = height * aspect
    self.planeBackground.transform.localScale = Vector3.New(width / 6.4, height / 3.6, 1.0)

end

--计算所有点位的坐标
local function CalAllBattlerPos(self)
    local centerPos = Vector3.New(self.centPos.x, self.centPos.y, self.centPos.z)
    for k, v in pairs(BattleSceneCommon.WarPosition) do
        local pos = centerPos + v
        self.allBattlePos[k] = pos
    end
end

local function GetBattlePos(self, index)
    return self.allBattlePos[index]
end

local function InitScene(self)
    --todo 设置背景
    self.planeBackground:SetActive(true)
    self.centPos = Vector3.zero
    -- 计算面板位置
    CalPlaneTransform(self)
    -- 计算战斗区域的位置点
    CalAllBattlerPos(self)
end

BattleScenePlane.__init = __init
BattleScenePlane.InitScene = InitScene
BattleScenePlane.__delete = __delete
BattleScenePlane.GetBattlePos = GetBattlePos

return BattleScenePlane
