--[[
-- added by ricashao @ 2020-04-05
-- UINewLogin控制层
--]]

local UINewLoginCtrl = BaseClass("UINewLoginCtrl", UIBaseCtrl)

local function OnConnect(self, sender, result, msg)
    if result < 0 then
        Logger.LogError("Connect err : " .. msg)
        return
    end
    return
    -- TODO
end

local function OnClose(self, sender, result, msg)
    if result < 0 then
        Logger.LogError("Close err : " .. msg)
        return
    end
end

local function ConnectServer(self)
    WsHallConnector:GetInstance():Connect("127.0.0.1", 10001, Bind(self, OnConnect), Bind(self, OnClose))
end

local function LoginServer(self, name, password)
    --todo 测试
    -- 合法性检验
    if string.len(name) > 20 or string.len(name) < 1 then
        -- TODO：错误弹窗
        CommMsgTip:GetInstance():Show("nononono")
        return
    end
    if string.len(password) > 20 or string.len(password) < 1 then
        -- TODO：错误弹窗
        Logger.LogError("password length err!")
        return
    end
    -- 检测是否有汉字
    for i = 1, string.len(name) do
        local curByte = string.byte(name, i)
        if curByte > 127 then
            -- TODO：错误弹窗
            Logger.LogError("name err : only ascii can be used!")
            return
        end
    end
    --if Config.Debug then
    --    SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
    --    return
    --end

    ClientData:GetInstance():SetAccountInfo(name, password)

    local msg = MsgIDMap.Login_C2S_Msg()
    msg.username = name
    msg.password = CS.Md5Helper.Md5(password)
    local service = WsHallConnector:GetInstance():GetService(ServiceName.LoginService)
    service:Login_C2S(msg)
end

local function OpenTreaty(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITreaty)
end

local function OpenRegist(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRegist)
end

local function EnterGame(self)
    SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
end

UINewLoginCtrl.LoginServer = LoginServer
UINewLoginCtrl.ConnectServer = ConnectServer
UINewLoginCtrl.OpenTreaty = OpenTreaty
UINewLoginCtrl.OpenRegist = OpenRegist
UINewLoginCtrl.EnterGame = EnterGame

return UINewLoginCtrl