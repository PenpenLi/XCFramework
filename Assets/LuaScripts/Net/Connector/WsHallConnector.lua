--[[
-- added by ricashao @ 2020-03-24
-- websocket网络连接器
--]]

local WsHallConnector = BaseClass("WsHallConnector", Singleton)
local SendMsgDefine = require "Net.Config.SendMsgDefine"
local NetUtil = require "Net.Util.NetUtil"

local ConnStatus = {
    Init = 0,
    Connecting = 1,
    WaitLogin = 2,
    Done = 3,
}

local function __init(self)
    self.hallSocket = nil
    self.globalSeq = 0
end

local function Startup(self)
    self.serviceMaps = {};
    local loginService = require("Net.Service.LoginService").New();
    self.serviceMaps["LoginService"] = loginService;
    loginService:OnRegister();
end

local function OnReceivePackage(self, receive_bytes)
    local receive_msg = NetUtil.DeserializeMessage(receive_bytes)
    Logger.Log(tostring(receive_msg))
end

local function Connect(self, host_ip, host_port, on_connect, on_close)
    if not self.hallSocket then
        self.hallSocket = CS.Networks.HjTcpNetwork()
        self.hallSocket.ReceivePkgHandle = Bind(self, OnReceivePackage)
    end
    self.hallSocket.OnConnect = on_connect
    self.hallSocket.OnClosed = on_close
    self.hallSocket:SetHostPort(host_ip, host_port)
    self.hallSocket:Connect()
    Logger.Log("Connect to " .. host_ip .. ", port : " .. host_port)
    return self.hallSocket
end

local function SendMessage(self, msg_id, msg_obj, show_mask, need_resend)
    show_mask = show_mask == nil and true or show_mask
    need_resend = need_resend == nil and true or need_resend

    local request_seq = 0
    local send_msg = SendMsgDefine.New(msg_id, msg_obj, request_seq)
    local msg_bytes = NetUtil.SerializeMessage(send_msg, self.globalSeq)
    Logger.Log(tostring(send_msg))
    self.hallSocket:SendMessage(msg_bytes)
    self.globalSeq = self.globalSeq + 1
end

local function Update(self)
    if self.hallSocket then
        self.hallSocket:UpdateNetwork()
    end
end

local function Disconnect(self)
    if self.hallSocket then
        self.hallSocket:Disconnect()
    end
end

local function Dispose(self)
    if self.hallSocket then
        self.hallSocket:Dispose()
    end
    self.hallSocket = nil
end

local function RegRecieveMSGRef(cmd, ref)

end

WsHallConnector.__init = __init
WsHallConnector.Connect = Connect
WsHallConnector.SendMessage = SendMessage
WsHallConnector.Update = Update
WsHallConnector.Disconnect = Disconnect
WsHallConnector.Dispose = Dispose
WsHallConnector.Startup = Startup

return WsHallConnector
