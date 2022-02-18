-- get good aim
-- ez
local IAPortable = Instance.new("ScreenGui")
local Cursor = Instance.new("ImageLabel")
local Hitmarker = Instance.new("ImageLabel")

IAPortable.Name = "IA Portable"
IAPortable.Parent = game:GetService('CoreGui')
IAPortable.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Cursor.Name = "Cursor"
Cursor.Parent = IAPortable
Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cursor.BackgroundTransparency = 1.000
Cursor.Size = UDim2.new(0, 256, 0, 256)
Cursor.Image = "rbxassetid://3355815697"
Cursor.ScaleType = Enum.ScaleType.Fit

Hitmarker.Name = "Hitmarker"
Hitmarker.AnchorPoint = Vector2.new(0.5, 0.5)
Hitmarker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hitmarker.BackgroundTransparency = 1.000
Hitmarker.BorderColor3 = Color3.fromRGB(27, 42, 53)
Hitmarker.Position = UDim2.new(0.5, 0, 0.5, 0)
Hitmarker.Size = UDim2.new(0, 45, 0, 45)
Hitmarker.Image = "rbxassetid://890801299"

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')

local Remotes = ReplicatedStorage:FindFirstChild('Remotes') or ReplicatedStorage
local ShootEvent = Remotes.ShootEvent
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function createSoundEffect(id, volume)
    coroutine.wrap(function()
        local sound = Instance.new("Sound")
        sound.SoundId = id
        sound.Volume = volume or 1
        SoundService:PlayLocalSound(sound)
        sound.Ended:Wait()
        sound:Destroy()
    end)()
end

local Bindable = Instance.new('BindableEvent')

Bindable.Event:Connect(function(bullets, gun)
    local ShotHit = false

    for _,bullet in pairs(bullets) do
        local Hit = bullet.Hit

        local Limb = Hit.Parent:FindFirstChildOfClass('Humanoid') ~= nil
        local Accessory = Hit.Parent.Parent:FindFirstChildOfClass('Humanoid') ~= nil

        if Limb then
            local Player = Players:GetPlayerFromCharacter(Hit.Parent)

            if Player.TeamColor ~= LocalPlayer.TeamColor then
                ShotHit = true
                break
            end
        elseif Accessory then
            local Player = Players:GetPlayerFromCharacter(Hit.Parent.Parent)
            
            if Player.TeamColor ~= LocalPlayer.TeamColor then
                ShotHit = true
                break
            end
        end
    end
    
    if ShotHit then
        createSoundEffect("rbxassetid://1347140027", 1)

        local Clone = Hitmarker:Clone()
        Clone.Position = UDim2.new(0,Mouse.X,0,Mouse.Y)
        Clone.Parent = IAPortable
        Clone.Rotation = math.random(0,90)

        game:GetService('Debris'):AddItem(Clone, 0.05)
    end
end)

local OldNameCall
OldNameCall = hookmetamethod(game, '__namecall', function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == 'FireServer' and self == ShootEvent then
        Bindable.Fire(Bindable, unpack(args))
    end

    return OldNameCall(self, ...)
end)

RunService.RenderStepped:Connect(function()
    UserInputService.MouseIconEnabled = false

    Cursor.Position = UDim2.new(0,Mouse.X,0,Mouse.Y)
    
    local Target = Mouse.Target
    local Limb = Target.Parent:FindFirstChildOfClass('Humanoid')
    local Accessory = Target.Parent.Parent:FindFirstChildOfClass('Humanoid')
    
    if Limb then
        local Player = Players:GetPlayerFromCharacter(Target.Parent)
        if Player.TeamColor == LocalPlayer.TeamColor then
            Cursor.ImageColor3 = Color3.fromRGB(0,255,0)
        else
            Cursor.ImageColor3 = Color3.fromRGB(255,0,0)
        end
    elseif Accessory then
        local Player = Players:GetPlayerFromCharacter(Target.Parent.Parent)
        if Player.TeamColor == LocalPlayer.TeamColor then
            Cursor.ImageColor3 = Color3.fromRGB(0,255,0)
        else
            Cursor.ImageColor3 = Color3.fromRGB(255,0,0)
        end
    else
        Cursor.ImageColor3 = Color3.fromRGB(255,255,255)
    end
end)
