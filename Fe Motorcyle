--[[
    FE Motorcycle make by Scripty#2063
    hat needed : https://web.roblox.com/catalog/5063566353/Atomic-Prussian-Bike
    Keybind : F to killcame , Space to Use Nitro
]]--


--//Value\\
local Playr = game:GetService("Players")
local Run = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Playr.LocalPlayer
local HoldMove = false
local KillcamE = false
local nitro = false
local soundservice game:GetService("SoundService")

--//Sound Service\\
local Music = Instance.new("Sound")
Music.Parent = game:GetService("SoundService")
Music.SoundId = "" -- Put Any Id here if you want , remember to put rbxassetid:// before put ID
Music.Looped = true
Music:Play()
local Motor = Instance.new("Sound")
Motor.Name = "Effect"
Motor.Parent = game:GetService("SoundService")
Motor.SoundId = "rbxassetid://314637764"
Motor.Volume = 4
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.W then
        HoldMove = true

        while HoldMove == true do
            Motor:Play()
            wait(6.381)
            HoldMove = false
        end
    end
end)

local Nitro = Instance.new("Sound")
Nitro.Name = "Nitro"
Nitro.Parent = game:GetService("SoundService")
Nitro.SoundId = "rbxassetid://2522617446"
Nitro.Volume = 5
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Space then
        Nitro:play()
        game:GetService("SoundService"):WaitForChild("Nitro"):Destroy()
    end
end)    


local Killcam = Instance.new("Sound")
Killcam.Name = "Killcam"
Killcam.Volume = 4
Killcam.Parent = game:GetService("SoundService")
Killcam.SoundId = "rbxassetid://179497874"
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.F then
        KillcamE = true

        while KillcamE == true do
            wait()
            Killcam:Play()
            wait(10)
            KillcamE= false
        end
    end
end)

    --//Main\\
    LocalPlayer.Character.Humanoid.WalkSpeed=200
    LocalPlayer.Character.Humanoid.JumpPower=0.0001 
    Float_Height="0"
    AnimationId="129342287" 
    local a=Instance.new("Animation") 
    a.AnimationId="rbxassetid://"..AnimationId 
    local a=LocalPlayer.Character.Humanoid:LoadAnimation(a) 
    a:Play() a:AdjustSpeed(1) for a,a in pairs(LocalPlayer.Character:GetDescendants())do 
        if a.ClassName=="Part"then a.CustomPhysicalProperties=PhysicalProperties.new(0,0,0)

        end 
    end 
    local a=1 G=game _=wait p=G:GetService("Players").LocalPlayer.Character
p:FindFirstChild("Humanoid").HipHeight=Float_Height _(3.5) t=.4 

--//Fix\\
while true do 
    wait(0.1)
    if game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 then
        game:GetService("SoundService"):WaitForChild("Sound"):Destroy()
        game:GetService("SoundService"):WaitForChild("Effect"):Destroy()
        game:GetService("SoundService"):WaitForChild("Nitro"):Destroy()
        game:GetService("SoundService"):WaitForChild("killcam"):Destroy()
    end
end
