local AsyObj = require "UI.AsynPrefabObject";
local Layer = Class("Layer", AsyObj);

local M = Layer;

function M:Ctor(camera, layerName, layerIndex, layer, distance)
	AsyObj.Ctor(self);
	self.camera = camera;
	self.layer  = layer;
	self.pfb    = nil;
	self.layerName     = layerName;
	self.layerIndex    = layerIndex;
	self.resolution    = nil;
	self.planeDistance = distance;
	self.isShow = true;

	--同步加载layer预制体
	-- self:LoadObject("UILayer","UI/Prefabs/Module", self.OnPrefabLoad, false)
	local pfb = SynLoader.Load("UI/Prefabs/Module/UILayer.ga")
	self:OnPrefabLoad(pfb)
end

--layer加载完成之后的初始化
function M:OnPrefabLoad(pfb)
	if not pfb then
		if error then error("Layer load UILayer resource error ---") end;
		return;
	end
	self.pfb = pfb;
	self.pfb.name = self.layerName;
	self.pfb.transform:SetParent(ioo.guiRoot.transform, false);
	local comp = self.pfb.transform:GetComponent("Canvas");	
	-- 这是canvas 相机
	comp.worldCamera   = self.camera;
	-- 这是canvas 渲染层级
	comp.sortingOrder  = self.layerIndex;
	-- 这是canvas 相机距离
	comp.planeDistance = self.planeDistance;
	self:UpdateSceneLayer(self.pfb);
	-- 调整自适应
	self:Adaptation(self.pfb);

end

function M:GetCamera()
	return self.camera;
end

function M:GetLayer()
	return self.layer;
end

function M:GetLayerName()
	return self.layerName;
end

function M:GetLayerIndex()
	return self.layerIndex;
end

function M:GetGameObject()
	return self.pfb;
end

--更新所有节点的layer属性
function M:UpdateSceneLayer(pfb)
	pfb.layer = self.layer;
	local components = pfb:GetComponentsInChildren(typeof(CS.UnityEngine.Transform));
	local length = components.Length - 1;
	for i=0, length do
		components[i].gameObject.layer = self.layer;
	end
end

--修改canvas自适应
function M:Adaptation(obj)
	local bizhi = 1.4;
	local  go = obj.transform:GetComponent(typeof(CanvasScaler)).referenceResolution;
	local rato = Screen.width/Screen.height;
	if rato > bizhi then
            go = Vector2.New(960, 640);
        else
			go = Vector2.New(1024, 768);
	end
	obj.transform:GetComponent(typeof(CanvasScaler)).referenceResolution = go;
	self.resolution = go;
end

-- 添加子节点
function M:AddGameObjectToLayer(go)
	if not go then
		return;
	end

	go.transform:SetParent(self.pfb.transform, false);
	self:UpdateSceneLayer(go);
end

-- 获取layer transform
function M:GetLayerTransform()
	if not (self.pfb) then
		if error then error("Layer GetLayerTransform layer GameObject is nil ") end;
		return;
	end
	return self.pfb.transform;
end

function M:GetResolution()
	return self.resolution;
end

function M:GetPlaneDistance()
	return self.planeDistance;
end

function M:ShowHide(show)
	if self.isShow == show then
		return
	end
	self.isShow = show
	if self.pfb then
		self.pfb:SetActive(show)
	end
end

return M;