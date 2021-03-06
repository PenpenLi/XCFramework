---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2020/3/29 23:13
---
local AudioManager = BaseClass("AudioManager", Singleton)
local audio_type = typeof(CS.UnityEngine.AudioClip)

local curAudioFile = ""

local function __init(self)
    self:InitUICfg()
    self:InitBgmObj()
end

local function InitUICfg(self)

end

local function InitBgmObj(self)
    local go = CS.UnityEngine.GameObject.Find("BGM")
    CS.UnityEngine.Object.DontDestroyOnLoad(go)
    self.curBgAs = go:GetComponent(typeof(CS.UnityEngine.AudioSource))
end



-- 异步加载audioclip：回调方式
local function LoadAudioClipAsync(self, audio_path, callback, ...)

    ResourcesManager:GetInstance():LoadAsync(audio_path, audio_type, function(audio, ...)
        if callback then
            callback(not IsNull(audio) and audio or nil, ...)
        end
    end, ...)
end

-- 从异步加载audioclip：协程方式
local function CoLoadAudioAsync(self, audio_path, progress_callback)
    local audio = ResourcesManager:GetInstance():CoLoadAsync(audio_path, audio_type, progress_callback)
    return not IsNull(audio) and audio or nil
end

local function CoChangeBgm(self, audioFile)
    while (self.curBgAs.volume > 0)
    do
        self.curBgAs.volume = self.curBgAs.volume - 0.01
        coroutine.waitforframes(1)
    end
    self.curBgAs:Pause()
    self.curBgAs.clip = self:CoLoadAudioAsync(audioFile)
    self.curBgAs.volume = 0
    self.curBgAs:Play();

    while (self.curBgAs.volume < 1)
    do
        self.curBgAs.volume = self.curBgAs.volume + 0.01
        coroutine.waitforframes(1)
    end
end

local function PlayBg(self, newAudioFile)
    if newAudioFile == curAudioFile then
        return
    end

    if (curAudioFile == "") then
        self:LoadAudioClipAsync(newAudioFile, function(audioClip)
            self.curBgAs.clip = audioClip
            self.curBgAs:Play()
        end)
    else
        coroutine.start(CoChangeBgm, self, newAudioFile)
    end
    curAudioFile = newAudioFile

end

AudioManager.__init = __init
AudioManager.InitUICfg = InitUICfg
AudioManager.InitBgmObj = InitBgmObj
AudioManager.PlayBg = PlayBg
AudioManager.LoadAudioClipAsync = LoadAudioClipAsync
AudioManager.CoLoadAudioAsync = CoLoadAudioAsync
AudioManager.CoChangeBgm = CoChangeBgm

return AudioManager
