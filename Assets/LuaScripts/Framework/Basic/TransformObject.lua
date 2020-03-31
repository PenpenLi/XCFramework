---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2020/3/28 22:42
---
local TransformObject = BaseClass("TransformObject")

local function __init(self, obj)
    self.gameObject = obj
    if self.gameObject == nil then
        self.gameObject = GameObject.New(self.class_type.__cname);
    end
    self.transform = self.gameObject.transform;
end

local function __delete(self)
    if self.gameObject ~= nil then
        CS.UnityEngine.GameObject.Destroy(self.gameObject);
        self.gameObject = nil;
        self.transform = nil;
    end
end

local function GetInstanceID(self)
    return self.gameObject:GetInstanceID();
end

local function SetWorldPosition(self, position)
    self.transform.position = position;
end

local function GetWorldPosition(self)
    return Vector3.New(self.transform.position.x, self.transform.position.y, self.transform.position.z);
end

local function SetLocalPosition(self, position)
    self.transform.localPosition = position;
end

local function GetLocalPosition(self)
    return Vector3.New(self.transform.localPosition.x, self.transform.localPosition.y, self.transform.localPosition.z);
end

local function SetWorldRotation(self, rotation)
    self.transform.rotation = rotation;
end

local function GetWorldRotation(self)
    return Quaternion.New(self.transform.rotation.x, self.transform.rotation.y, self.transform.rotation.z, self.transform.rotation.w);
end

local function SetLocalRotation(self, rotation)
    self.transform.localRotation = rotation;
end

local function GetLocalRotation(self)
    return Quaternion.New(self.transform.localRotation.x, self.transform.localRotation.y, self.transform.localRotation.z, self.transform.localRotation.w);
end

local function GetRight(self)
    return self.transform.right;
end

local function GetForward(self)
    return Vector3.New(self.transform.forward.x, self.transform.forward.y, self.transform.forward.z);
end

local function GetUp(self)
    return self.transform.up;
end

local function SetWorldEulerAngles(self, eulerAngles)
    self.transform.eulerAngles = eulerAngles;
end

local function GetWorldEulerAngles(self)
    return self.transform.eulerAngles;
end

local function SetLocalEulerAngles(self, eulerAngles)
    self.transform.localEulerAngles = eulerAngles;
end

local function GetLocalEulerAngles(self)
    return self.transform.localEulerAngles;
end

local function LookAtTarget(self, target)
    return self.transform:LookAt(target);
end
--vector3
local function SetScale(self, scale)
    if scale.x > 0.0 and scale.y > 0.0 and scale.z > 0.0 then
        self.transform.localScale = scale;
    end
end

local function GetLocalToWorldMatrix(self)
    return self.transform.localToWorldMatrix;
end

local function GetWorldToLocalMatrix(self)
    return self.transform.worldToLocalMatrix;
end

local function GetParent(self)
    return self.transform.parent;
end

local function SetParent(self, parent)
    self.transform.parent = parent;
    self:SetLocalPosition(Vector3.zero);
    self:SetLocalRotation(Quaternion.identity);
    self:SetScale(Vector3.one);
end

local function GetChildCount(self)
    return self.transform.childCount;
end

function AttachChild(self, child, position, rotation)
    if child == nil then
        return false;
    end
    child.parent = self.transform;
    child.localScale = Vector3.one;

    if position ~= nil then
        child.localPosition = position;
    else
        child.localPosition = Vector3.zero;
    end
    if rotation ~= nil then
        child.localRotation = rotation;
    else
        child.localRotation = Quaternion.identity;
    end
    return true;
end

local function DetachChild(self, child)
    if child ~= nil then
        child.parent = nil;
    end
end

local function TranslateTo(self, position, time)
    -- if time > 0 then
    -- end
    self:SetWorldPosition(position);
end

local function RotateTo(self, dir, up)
    -- if time > 0 then
    -- end
    self:SetWorldRotation(Quaternion.LookRotation(dir, up));
end

local function RotateToQua(self, rotation)
    self:SetWorldRotation(rotation);
end

local function SetActive(self, active)
    self.gameObject:SetActive(active);
end

local function GetActive(self)
    return self.gameObject.activeSelf;
end



--TODO
local function Tick(delta)

end

TransformObject.__init = __init
TransformObject.__delete = __delete
TransformObject.GetInstanceID = GetInstanceID
TransformObject.SetWorldPosition = SetWorldPosition
TransformObject.GetWorldPosition = GetWorldPosition
TransformObject.SetLocalPosition = SetLocalPosition
TransformObject.GetLocalPosition = GetLocalPosition
TransformObject.SetWorldRotation = SetWorldRotation
TransformObject.GetWorldRotation = GetWorldRotation
TransformObject.SetLocalRotation = SetLocalRotation
TransformObject.GetLocalRotation = GetLocalRotation
TransformObject.GetRight = GetRight
TransformObject.GetForward = GetForward
TransformObject.GetUp = GetUp
TransformObject.SetWorldEulerAngles = SetWorldEulerAngles
TransformObject.GetWorldEulerAngles = GetWorldEulerAngles
TransformObject.SetLocalEulerAngles = SetLocalEulerAngles
TransformObject.GetLocalEulerAngles = GetLocalEulerAngles
TransformObject.LookAtTarget = LookAtTarget
TransformObject.SetScale = SetScale
TransformObject.GetLocalToWorldMatrix = GetLocalToWorldMatrix
TransformObject.GetWorldToLocalMatrix = GetWorldToLocalMatrix
TransformObject.GetParent = GetParent
TransformObject.SetParent = SetParent
TransformObject.GetChildCount = GetChildCount
TransformObject.AttachChild = AttachChild
TransformObject.DetachChild = DetachChild
TransformObject.TranslateTo = TranslateTo
TransformObject.RotateTo = RotateTo
TransformObject.RotateToQua = RotateToQua
TransformObject.SetActive = SetActive
TransformObject.GetActive = GetActive
TransformObject.Tick = Tick


return TransformObject