--/*-*begin $area1*-*/
--这里填写类上方的require内容
--/*-*end $area1*-*/
--创建时间2019/10/18 18:20:46
CMessageTipTable = {}
CMessageTipTable.__index = CMessageTipTable
function CMessageTipTable:new()
    local self = {}
    setmetatable(self, CMessageTipTable)
    self.m_cache = {}

    return self
end


function CMessageTipTable:LoadBeanFromJsonFile(filename)
    if not filename then
        return false
    end
    local data =  Resources.Load(filename):ToString()
    local json = require 'rapidjson'
    local root = json.decode(data);
    self:BeanFromJson(root)
    return true;
end

function CMessageTipTable:BeanFromJson(datas)
    if not datas then return end
    for i,v in pairs(datas) do
        self:Decode(v)
    end
end
--/*-*begin $area2*-*/
--这里填写类里面的手写内容
function CMessageTipTable:GetRecorder(id)
    if not self.m_cache[id] then
        if dibug then dibug('CMessageTipTable GetRecorder for' .. id .. 'is Nil') end
        return nil
    end
    return self.m_cache[id]
end
--/*-*end $area2*-*/
function CMessageTipTable:Decode(data)
	 local cachetable = {}
	--code码
	cachetable.id = data[1];
	--类型
	cachetable.type = data[2];
	--描述
	cachetable.msg = data[3];
	--数值型效果id
	cachetable.closetime = data[4];

--/*-*begin $decode*-*/
--这里填写方法中的手写内容
--/*-*end $decode*-*/
	self.m_cache[cachetable.id] = cachetable
end
return CMessageTipTable