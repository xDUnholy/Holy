
--------------Variables--------------

local repo = 'https://raw.githubusercontent.com/YassinMedany/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local EntityInfo = game:GetService("ReplicatedStorage").EntityInfo
local Collision = char:FindFirstChild("Collision")
local PxPromptService = game:GetService("ProximityPromptService")
local Entity = game.ReplicatedStorage.Entities
local screechModel = Entity:WaitForChild('Screech')
local timothyModel = Entity:WaitForChild('Spider')
local players = game:GetService("Players")
local rstorage = game:GetService("ReplicatedStorage")
local screechRemote = EntityInfo.Screech
local modules = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local moduleScripts = {
    MainGame = plr.PlayerGui.MainUI.Initiator.Main_Game
}
local gameData = rstorage.GameData
local LatestRoom = gameData.LatestRoom
local seekconn
local bodyColors = char['Body Colors']
local rsconnection
local RunService = game:GetService("RunService")
local speedbypassv = false
local connectvar
local entityTable = {
    ["RushMoving"] = {Name = "Rush", Notification = "Rush has spawned, hide!"},
    ["AmbushMoving"] = {Name = "Ambush", Notification = "Ambush has spawned, hide! He may rebound up to 6 times, keep this in mind."},
    ["JeffTheKiller"] = {Name = "Jeff The Killer", Notification = "Jeff The Killer has spawned, be aware!"},
    ["Eyes"] = {Name = "Eyes", Notification = "Eyes has spawned, Look away!"},
    ["A60"] = {Name = "A-60", Notification = "A-60 has spawned, hide!"},
    ["A120"] = {Name = "A-120", Notification = "A-120 has spawned, hide! He can return a few times."}
}
local beep = Instance.new('Sound');
beep.SoundId = 'rbxassetid://13681038983'

----------------------------------FUNCTIONS----------------------------------
function decipherCode()
    local hints = plr.PlayerGui:WaitForChild('PermUI'):WaitForChild('Hints')

    if game.ReplicatedStorage:WaitForChild('GameData'):WaitForChild('Floor').Value == 'Fools' then
        local paper = char:FindFirstChild('LibraryHintPaperHard') or plr.Backpack:FindFirstChild('LibraryHintPaperHard')
        local code = {[1]='_', [2]='_', [3]='_', [4]='_', [5]='_', [6]='_', [7]='_', [8]='_', [9]='_', [10]='_'}

        if paper.UI:FindFirstChild('Fake') then
            paper.UI:FindFirstChild('Fake'):Destroy()
        end

        if paper then
            for _, v in pairs(paper:WaitForChild('UI'):GetChildren()) do
                if v:IsA('ImageLabel') and v.Name ~= 'Image' then
                    for _, img in pairs(hints:GetChildren()) do
                        if img:IsA('ImageLabel') and img.Visible and v.ImageRectOffset == img.ImageRectOffset then
                            local num = img:FindFirstChild('TextLabel').Text

                            code[tonumber(v.Name)] = num
                        end
                    end
                end
            end
        end

        return code
    else
        local paper = char:FindFirstChild('LibraryHintPaper') or plr.Backpack:FindFirstChild('LibraryHintPaper')
        local code = {[1]='_', [2]='_', [3]='_', [4]='_', [5]='_'}

        if paper then
            for _, v in pairs(paper:WaitForChild('UI'):GetChildren()) do
                if v:IsA('ImageLabel') and v.Name ~= 'Image' then
                    for _, img in pairs(hints:GetChildren()) do
                        if img:IsA('ImageLabel') and img.Visible and v.ImageRectOffset == img.ImageRectOffset then
                            local num = img:FindFirstChild('TextLabel').Text

                            code[tonumber(v.Name)] = num
                        end
                    end
                end
            end
        end

        return code
    end
end


local tpconnect

tpconnect = function()
    if rstorage.GameData.Floor.Value == 'Fools' and Toggles.enableTP.Value then
        local valueofDrop = Options.playerDropTPBananas.Value
        local targetPlayer = game.Players:FindFirstChild(valueofDrop)
        
        if targetPlayer then
            for _, banana in pairs(workspace:GetChildren()) do
                if banana.Name == "BananaPeel" then
                    banana.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end




local function fireproxpro(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
    end
end

local function speedbypass()
    while Collision and speedbypassv do
        Collision.Massless = not Collision.Massless
        wait(0.24)
    end
end




local function vtouch(obj, cantouch)
    if typeof(obj) ~= 'Instance' or obj == nil or typeof(cantouch) ~= 'boolean' or cantouch == nil then     return;     end
    if obj:IsA('Part') or obj:IsA('MeshPart') or obj:IsA('TrussPart') or obj:IsA('WedgePart') or obj:IsA('BasePart') then
        obj.CanTouch = cantouch;
    end
    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA('BasePart') or v:IsA('Part') or v:IsA('TrussPart') or v:IsA('WedgePart') or v:IsA('MeshPart') then
            v.CanTouch = cantouch;
        end
    end
end




Library:Notify('Youre a developer or a tester! Hooray, youre so cool!')
--------------UI--------------
local Window = Library:CreateWindow({
    Title = 'Holy Hub (Developer/Tester version)| ' .. plr.DisplayName,
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.5
})





local Tabs = {
   
    Main = Window:AddTab('Main'),
    Cheats = Window:AddTab('Cheats'),
    Visuals = Window:AddTab('Visuals'),
    Player = Window:AddTab('Player'),
    Configs = Window:AddTab('Configs'),
}


local Automation = Tabs.Main:AddLeftGroupbox('Automation')





---------------------Main UI---------------------

Automation:AddToggle('revdeath', {
     Text = 'Revive on Death',
     Default = false,
     Tooltip = 'Either uses a revive or pops up the prompt to buy one on death.',
})
Automation:AddToggle('antiEntityToggle', {
    Text = 'Anti-Rush/Ambush',
    Default = false,
})
Automation:AddToggle('noewait', {
    Text = 'Instant Interact',
    Default = false,
    Tooltip = 'Skips wait-time for interacting.',
})
Automation:AddDivider()
Automation:AddToggle('autopl', {
    Text = 'Auto Padlock Code',
    Default = false,
    Tooltip = 'Auto enters the padlock code in 50 if you have all the books and are holding the paper.',
})




local misc = Tabs.Main:AddLeftGroupbox('Miscellaneous')
local reviveButton = misc:AddButton({
    Text = 'Revive',
    Func = function()
        EntityInfo:WaitForChild('Revive'):FireServer()
    end,  
    DoubleClick = false,
    Tooltip = 'Uses a revive or pops up the prompt to buy one.',

})
local restartButton = misc:AddButton({
    Text = 'Restart',
    Func = function()
        EntityInfo:WaitForChild('PlayAgain'):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Goes into a new game.',
})
local lobbyButton = misc:AddButton({
    Text = 'Lobby',
    Func = function()
        EntityInfo:WaitForChild('Lobby'):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the lobby',
})

local notifs = Tabs.Main:AddRightGroupbox('Notifying')
notifs:AddToggle('entitynotif', {
    Text = 'Entity Notifications',
    Default = false,
})
notifs:AddToggle('plcode', {
    Text = 'Padlock Code',
    Default = false,
})
notifs:AddToggle('plrleave', {
    Text = 'Player Leaving',
    Default = false,
})



local selfTabMain = Tabs.Main:AddRightGroupbox('Self')
selfTabMain:AddToggle('lightToggle', {
    Text = 'Light',
    Default = false,
})
selfTabMain:AddSlider('lightSlider', {
    Text = 'Light Brightness',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
})

---------------------Cheats UI---------------------

local motorRepBox = Tabs.Cheats:AddLeftGroupbox('Motor Replication')
motorRepBox:AddToggle('enablerep', {
    Text = 'Enable',
    Default = false,
})
motorRepBox:AddSlider('legroto', {
    Text = 'Leg Rotation',
    Default = 0,
    Min = -4,
    Max = 4,
    Rounding = 1,
    Compact = false,
})
motorRepBox:AddSlider('headroto', {
    Text = 'Head Pitch',
    Default = 0,
    Min = -720,
    Max = 720,
    Rounding = 1,
    Compact = false,
})
motorRepBox:AddSlider('bodyroto', {
    Text = 'Body Rotation',
    Default = 0,
    Min = -180,
    Max = 180,
    Rounding = 1,
    Compact = false,
})

motorRepBox:AddToggle('noeyes', {
    Text = 'No Eyes Damage',
    Default = false,
})
local setdefaultbut = motorRepBox:AddButton({
    Text = 'Set to Default',
    Func = function()
        Toggles.enablerep:SetValue(false)
        Toggles.noeyes:SetValue(false)
        Options.legroto:SetValue(0)
        Options.headroto:SetValue(0)
        Options.bodyroto:SetValue(0)
    end,
    DoubleClick = false
})

local removeBox = Tabs.Cheats:AddLeftGroupbox('Removal')
removeBox:AddToggle('offscreech', {
    Text = 'No Screech',
    Default = false,
})
removeBox:AddToggle('timothyscareoff', {
    Text = 'No Timothy Jumpscare',
    Default = false,
})
removeBox:AddToggle('a90disabled', {
    Text = 'No A90',
    Default = false,
})

removeBox:AddDivider()

local nocamshakebut = removeBox:AddButton({
    Text = 'No Camera Shake',
    Func = function()
        EntityInfo.CamShakeRelative:Destroy()
        EntityInfo.CamShake:Destroy()
    end,
    DoubleClick = false,
})

local disimprove = removeBox:AddButton({
    Text = 'Disimprove Client Anticheat',
    Func = function()
        local plr = game.Players.LocalPlayer
local MainGame = plr.PlayerGui.MainUI.Initiator.Main_Game
function nothing() end
require(MainGame).update = nothing
require(MainGame).updated = nothing
if game.ReplicatedStorage.ClientModules.EntityModules.Glitch then
    local gmggggggg = require(game.ReplicatedStorage.ClientModules.EntityModules.Glitch)
    gmggggggg.module_events = nil
    gmggggggg.stuff = nil
end
if game:GetService('Players').LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game:FindFirstChild('Updated') then
    game:GetService('Players').LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.Updated:Destroy()
end
if game:GetService('ReplicatedStorage').ClientModules:FindFirstChild('Module_Events') then
    game:GetService('ReplicatedStorage').ClientModules.Module_Events:Destroy()
end
end,

      DoubleClick = false,
})

removeBox:AddDivider()

removeBox:AddToggle('noroomslock', {
    Text = 'No A-000 Lock',
    Default = false,
})
removeBox:AddToggle('noseek', {
    Text = 'No Seek Trigger',
    Default = false,
})


local Troll = Tabs.Cheats:AddRightGroupbox('Trolling')
Troll:AddToggle('usetools', {
    Text = 'Spam Others Tools',
    Default = false,
}):AddKeyPicker('usetoolsKeybind', {
    Default = 'V',

    Mode = 'Hold',

    Text = 'Spam Others Tools',
    NoUI = false
})
Troll:AddToggle('seekcrux', {
    Text = 'Seek Crucifix Animation',
    Default = false,
})
Troll:AddDropdown('footstepsMode', {
    Values = { 'Default', 'Silent', 'Spam' },
    Default = 1,

    Text = 'Footsteps',
})

Troll:AddDropdown('playerDropTPBananas', {
    SpecialType = 'Player',
    Text = 'TP Bananas to:',
})
Troll:AddToggle('enableTP', {
    Text = 'TP Bananas',
    Default = false,
})

local self2 = Tabs.Cheats:AddRightGroupbox('Protection')
self2:AddToggle('snaredisable', {
    Text = 'Anti-Snare',
    Default = false,
})
self2:AddToggle('dupedisable', {
    Text = 'Anti-Dupe',
    Default = false,
})
self2:AddToggle('nobanana', {
    Text = 'Anti-Bananas',
    Default = false,
})
self2:AddToggle('nojeff', {
    Text = 'Anti-Jeff',
    Default = false,
})
self2:AddToggle('nohalt', {
    Text = 'Anti-Halt',
    Default = false,
})
self2:AddToggle('noobst', {
    Text = 'Anti-Seek Arms/Chandeliers',
    Default = false,
})
self2:AddDivider()
self2:AddToggle('reachToggle', {
    Text = 'Reach',
    Default = false,
})

self2:AddToggle('heartbeatremove',  {
    Text = 'No heartbeat minigame',
    Default = false,
})


---------------------Visuals UI---------------------

local esplol = Tabs.Visuals:AddLeftGroupbox('ESP')

esplol:AddToggle('desp', {
    Text = 'Door ESP',
    Default = false,
})

esplol:AddToggle('besp', {
    Text = 'Book ESP',
    Default = false,
})
esplol:AddToggle('besp2', {
    Text = 'Breaker ESP',
    Default = false,
})
esplol:AddToggle('kesp', {
    Text = 'Key ESP',
    Default = false,
})
esplol:AddToggle('pesp', {
    Text = 'Player ESP',
    Default = false,
})

esplol:AddToggle('Lesp', {
    Text = 'Lever ESP',
    Default = false,
})
esplol:AddToggle('iesp', {
    Text = 'Item ESP',
    Default = false,
})
esplol:AddToggle('eesp', {
    Text = 'Entity ESP',
    Default = false,
})
local espsets = Tabs.Visuals:AddLeftGroupbox('ESP Settings')
espsets:AddLabel('Door ESP Color'):AddColorPicker('despColor', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Door ESP Color',
})
espsets:AddLabel('Book ESP Color'):AddColorPicker('bespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Book ESP Color',
})
espsets:AddLabel('Breaker ESP Color'):AddColorPicker('besp2col', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Breaker ESP Color',
})
espsets:AddLabel('Key ESP Color'):AddColorPicker('kespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Key ESP Color',
})
espsets:AddLabel('Player ESP Color'):AddColorPicker('pespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Player ESP Color',
})
espsets:AddLabel('Lever ESP Color'):AddColorPicker('lespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Lever ESP Color',
})
espsets:AddLabel('Item ESP Color'):AddColorPicker('iespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Item ESP Color',
})
espsets:AddLabel('Entity ESP Color'):AddColorPicker('eespcol', {
    Default = Color3.fromRGB(178, 235, 242),
    Title = 'Entity ESP Color',
})
local viewGroup = Tabs.Visuals:AddRightGroupbox('View')
viewGroup:AddToggle('bchams', {
    Text = 'Body Chams',
    Default = false,
}):AddColorPicker('bchCol', {
      Default = Color3.fromRGB(178, 235, 242),
      Transparency = 0,
})
viewGroup:AddToggle('bodyisInvis', {
    Text = 'Invisible Body',
    Default = false,
})

viewGroup:AddDivider()

viewGroup:AddToggle('ambienceToggle', {
    Text = 'Ambience',
    Default = false,
}):AddColorPicker('ambiencecol', {
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
})
viewGroup:AddSlider('fovSlider', {
    Text = 'Field of View',
    Default = 70,
    Min = 50,
    Max = 120,
    Rounding = 0,
    Compact = false,
})
viewGroup:AddToggle('camhead', {
    Text = 'Camera relative to your head',
    Default = false,
})


local general = Tabs.Player:AddLeftGroupbox('General')





general:AddToggle('noacc', {
    Text = 'No Acceleration',
    Default = false,
})

general:AddToggle('nclip', {
    Text = 'Noclip',
    Default = false,
})

general:AddDivider()

general:AddSlider('finallysboost', {
    Text = 'Speed Boost',
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = false,
})


general:AddToggle('sbypass', {
    Text = 'Speed Bypass',
    Default = false,
})

---------------------Code---------------------


Toggles.revdeath:OnChanged(function()
    if Toggles.revdeath.Value  then
        local function Callback(answer)
            if answer == 'Yes' then
                EntityInfo:WaitForChild('Revive'):FireServer()
            end
        end
        
        local addconnect
        addconnect = char.Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
            local newHealth = char.Humanoid.Health
        
            if newHealth == 0 then
                local Bindable = Instance.new('BindableFunction')
                Bindable.OnInvoke = Callback
        
                game.StarterGui:SetCore('SendNotification', {
                    Title = 'Revive?';
                    Text = '(Will take from your revives or prompt to buy one)';
                    Duration = '5000';
                    Button1 = 'Yes';
                    Button2 = 'No';
                    Callback = Bindable
                })
            end
        
            task.spawn(function()
                repeat task.wait() until not Toggles.reviveOnDeathToggle.Value
                addconnect:Disconnect()
            end)
        end)
        end
    end)
    local connection
    local oldCollisionPosition
    Toggles.antiEntityToggle:OnChanged(function(antiValue)
        if antiValue then
            connection = workspace.ChildAdded:Connect(function(child)
                task.wait(0.125)
               if child.Name == 'RushMoving' then
                   if child.PrimaryPart.Position.Y > -10000 then
                       oldCollisionPosition = Collision.Position
                       Collision.Position = Collision.Position - Vector3.new(0, 13, 0)
                    repeat task.wait() until child.PrimaryPart.Position.Y < char.PrimaryPart.Position.Y and (child.PrimaryPart.Position - char.PrimaryPart.Position).Magnitude <= 12.5
                    Collision.Position = Collision.Position + Vector3.new(0, 13, 0)
                   elseif not antiValue then
                      if connection and connection.Connected then
                        connection:Disconnect()
                        connection = nil
                        Collision.Position = oldCollisionPosition
                      end
                   end
               end
            end)
        end
    end)


        local instantinteract = nil

        Toggles.noewait:OnChanged(function()
            if Toggles.noewait.Value  then
                if not instantinteract then
                    instantinteract = PxPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                        local oldHoldDuration = prompt.HoldDuration
                        prompt.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(prompt); end
                        wait(0.1)
                        prompt.HoldDuration = oldHoldDuration
                    end)
                end
            else
                if instantinteract then
                    instantinteract:Disconnect()
                    instantinteract = nil
                end
            end
        end)
        
        Toggles.autopl:OnChanged(function()
            Toggles.autopl:OnChanged(function()
                if Toggles.autopl.Value  then
                    local addconnect,backpackconnect
                    addconnect = char.ChildAdded:Connect(function(v)
                        if v:IsA('Tool') and v.Name == 'LibraryHintPaper' or v.Name == 'LibraryHintPaperHard' then
                            task.wait()
            
                            local code = table.concat(decipherCode())
            
                            if not code:find('_') then
                                EntityInfo.PL:FireServer(code)
                            end
                        end
                    end)
                    backpackconnect = plr.Backpack.ChildAdded:Connect(function(v)
                        if v:IsA('Tool') and v.Name == 'LibraryHintPaper' or v.Name == 'LibraryHintPaperHard' then
                            local code = table.concat(decipherCode())
                            repeat task.wait(0.05)
                                code = table.concat(decipherCode())
                            until not code:find('_')
                            EntityInfo.PL:FireServer(code)
                        end
                    end)
            
                    task.spawn(function()
                        repeat task.wait() until not Toggles.autopl.Value
                        addconnect:Disconnect()
                        backpackconnect:Disconnect()
                    end)
                end
            end)
            
        end)
        Toggles.plcode:OnChanged(function()
            if Toggles.plcode.Value then
                local addconnect
                addconnect = char.ChildAdded:Connect(function(v)
                    if v:IsA('Tool') and v.Name == 'LibraryHintPaper' or v.Name == 'LibraryHintPaperHard' then
                        task.wait()
        
                        local code = table.concat(decipherCode())
        
                        if not code:find('_') then
                            Library:Notify('The code is' .. code .. '.')
                            beep:Play()
                                end
                              end
                            end)
                        end
                    end)

                task.spawn(function()
                    repeat task.wait() until not Toggles.plcode.Value
                    addconnect:Disconnect()
                end)
        


        local connectvar

        Toggles.entitynotif:OnChanged(function()
            if Toggles.entitynotif.Value then
                if connectvar and connectvar.Connected then
                    connectvar:Disconnect()
                    connectvar = nil
                end
                    
                connectvar = workspace.ChildAdded:Connect(function(child)
                    if entityTable[child.Name] then
                        task.wait(0.125)
                                local entityName = entityTable[child.Name].Name
                                local notification = entityTable[child.Name].Notification
                                if child.PrimaryPart.Position.Y > -10000 then                       
                                if child.Name == "RushMoving" and gameData.Floor.Value == "Fools" and primaryPart.Name ~= "RushNew" then
                                    notification = primaryPart.Name .. " has spawned, hide!"
                                end
        
                                Library:Notify(notification)
                                beep:Play()
                                end
                            end
                        end)
                    elseif not Toggles.entitynotif.Value then
                        
                if connectvar and connectvar.Connected then
                    connectvar:Disconnect()
                    connectvar = nil
                    end
                end
            end)
        


        
        local connectadd

        Toggles.plrleave:OnChanged(function()
            if Toggles.plrleave.Value then
                game.Players.PlayerRemoving:Connect(function(player)
                    if player ~= plr then
                        Library:Notify(player.Name .. 'has left the game.')
                        beep:Play()
                        end
                    end)
                end
            end)
        

local HeadLight

Toggles.lightToggle:OnChanged(function()
    if Toggles.lightToggle.Value then
        HeadLight.Name = 'HeadLight'
        HeadLight.Brightness = Options.lightBrightness.Value
        HeadLight.Face = Enum.NormalId.Front
        HeadLight.Range = 100
        HeadLight.Parent = char.Head
        HeadLight.Enabled = Toggles.lightToggle.Value
    elseif not Toggles.lightToggle.Value  then
        if HeadLight then
            HeadLight.Enabled = Toggles.lightToggle.Value
        end
    end
end)

Options.lightSlider:OnChanged(function()
    if Toggles.lightToggle.Value  and HeadLight then
        HeadLight.Brightness = Options.lightSlider.Value
    end
end)


Toggles.enablerep:OnChanged(function()
    if Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(Options.legroto.Value, Options.headroto.Value, Options.bodyroto.Value)
    elseif not Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(0, 0, 0)
    end
end)

Options.legroto:OnChanged(function()
    if Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(Options.legroto.Value, Options.headroto.Value, Options.bodyroto.Value)
    elseif not Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(0, 0, 0)
    end
end)

Options.headroto:OnChanged(function()
    if Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(Options.legroto.Value, Options.headroto.Value, Options.bodyroto.Value)
    elseif not Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(0, 0, 0)
    end
end)

Options.bodyroto:OnChanged(function()
    if Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(Options.legroto.Value, Options.headroto.Value, Options.bodyroto.Value)
    elseif not Toggles.enablerep.Value  then
        EntityInfo.MotorReplication:FireServer(0, 0, 0)
    end
end)



local connection
local connected

Toggles.noeyes:OnChanged(function(valueEyes)
    if valueEyes then
        task.spawn(function()      
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == 'Eyes' then
                while v do
                    EntityInfo.MotorReplication:FireServer(options.legroto.Value, -65, Options.bodyroto.Value)
        connection =  workspace.ChildAdded:Connect(function(child)
                if child.Name == 'Eyes' then
                    while child do
                        EntityInfo.MotorReplication:FireServer(options.legroto.Value, -65, Options.bodyroto.Value)
                    end
                end
            end)
        connected = workspace.ChildRemoved:Connect(function(childEyes)
            if childEyes.Name == 'Eyes' then
                EntityInfo.MotorReplication:FireServer(options.legroto.Value, Options.headroto.Value, Options.bodyroto.Value)
            end
        end)
                end
            elseif not valueEyes then
                 if connection and connection.Connected then
                    connection:Disconnect()
                if connected and connected.Connected then
                    connected:Disconnect()
                end
                 end
            end

        end
    end)
end
end)


Toggles.offscreech:OnChanged(function()
    if Toggles.offscreech.Value  then
        screechModel.Parent = nil
        screechRemote.Parent = nil
    else
        screechModel.Parent = Entity
        screechRemote.Parent = EntityInfo
    end
end)

Toggles.timothyscareoff:OnChanged(function()
    if Toggles.timothyscareoff.Value == true then
        timothyModel.Parent = nil
    else
        timothyModel.Parent = Entity
   end
end)



Toggles.a90disabled:OnChanged(function()
    if Toggles.a90disabled.Value and moduleScripts.MainGame.RemoteListener.Modules:FindFirstChild('A90')  then
        moduleScripts.MainGame.RemoteListener.Modules['A90'].Name = 'Baller'
    else
        if moduleScripts.MainGame.RemoteListener.Modules:FindFirstChild('Baller') then
            moduleScripts.MainGame.RemoteListener.Modules['Baller'].Name = 'A90'
        end
    end
end)





Toggles.usetools:OnChanged(function()
    if Toggles.usetools.Value and Options.usetoolsKeybind:GetState() then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player:GetAttribute('Alive') and player.Character ~= nil and player ~= plr then
                for _, tool in ipairs(player.Backpack:GetChildren()) do
                    if tool:IsA('Tool') then
                        tool:FindFirstChildWhichIsA('RemoteEvent'):FireServer()
                    end
                   
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA('Tool') then
                        tool:FindFirstChildWhichIsA('RemoteEvent'):FireServer()
                        break
                    end
                end
              end
            end
        end
    else
        return
    end
end)




local animTrack1
local animTrack2

Toggles.seekcrux:OnChanged(function()
    if Toggles.seekcrux.Value then
        local humanoid = game.Players.LocalPlayer.Character.Humanoid

        local cruxstart = Instance.new("Animation")
        cruxstart.AnimationId = "rbxassetid://12309659361"

        local cruxloop = Instance.new("Animation")
        cruxloop.AnimationId = "rbxassetid://12309664766"

        animTrack1 = humanoid.Animator:LoadAnimation(cruxstart)
        animTrack2 = humanoid.Animator:LoadAnimation(cruxloop)

         animTrack1:Play()
        animTrack1.Stopped:Wait()
        animTrack2:Play()
    else
        if animTrack1 and animTrack1.IsPlaying then
            animTrack1:Stop()
        if animTrack2 and animTrack2.IsPlaying then
            animTrack2:Stop()
        end
        end
    end
end)


Options.footstepsMode:OnChanged(function()
    if Options.footstepsMode.Value == 'Default' then
        moduleScripts.MainGame.Footsteps.Enabled = true
    elseif Options.footstepsMode.Value == 'Silent' then
        moduleScripts.MainGame.Footsteps.Enabled = false
    elseif Options.footstepsMode.Value == 'Spam' then
        moduleScripts.MainGame.Footsteps.Enabled = true
    end
end)



Toggles.enableTP:OnChanged(function()
    if Toggles.enableTP.Value then
        Options.playerDropTPBananas:OnChanged(function()
                if tpconnect then
                    tpconnect()
                elseif not Toggles.enableTP.Value then
                    if tpconnect then
                        tpconnect:Disconnect()
                        tpconnect = nil
                    end
                end
            end)
        end    
    end)

    Toggles.snaredisable:OnChanged(function()
        if Toggles.snaredisable.Value then
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(v)
                local assets = v:WaitForChild('Assets')
    
                if assets then
                    for _, i in ipairs(assets:GetChildren()) do
                        if i.Name == 'Snare' then
                            task.spawn(function()
                                repeat task.wait(0.05)
                                    i:WaitForChild('Hitbox').CanTouch = false
                                until i:WaitForChild('Hitbox').CanTouch == false
                            end)
                        end
                    end
                end
                
            end)
    
            for _, v in ipairs(workspace.CurrentRooms:GetChildren()) do
                if v:FindFirstChild('Assets') then
                    for _, i in ipairs(v.Assets:GetChildren()) do
                        if i.Name == 'Snare' then
                            task.spawn(function()
                                repeat task.wait(0.05)
                                    i:WaitForChild('Hitbox').CanTouch = false
                                until i:WaitForChild('Hitbox').CanTouch == false
                            end)
                        end
                    end
                end
            end
    
            task.spawn(function()
                repeat task.wait() until not Toggles.snaredisable.Value
                addconnect:Disconnect()
    
                for _, v in ipairs(workspace.CurrentRooms:GetChildren()) do
                    if v:FindFirstChild('Assets') then
                        for _, i in ipairs(v.Assets:GetChildren()) do
                            if i.Name == 'Snare' then
                                task.spawn(function()
                                    repeat task.wait(0.05)
                                        i:WaitForChild('Hitbox').CanTouch = true
                                    until i:WaitForChild('Hitbox').CanTouch == true
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    local reelDupe

    Toggles.dupedisable:OnChanged(function()
        if Toggles.dupedisable.Value then
            if reelDupe and reelDupe.Connected then
                reelDupe:Disconnect(); end
            for _, lol in pairs(workspace.CurrentRooms[LatestRoom.Value]:GetDescendants()) do
                if lol.Parent.Name == "DoorFake" and lol.Name == "Hidden" then
                    vtouch(lol, false)
                local Lock = v.Parent:FindFirstChild("LockPart")
                 if Lock and Lock:FindFirstChild('UnlockPrompt') then
                    Lock:FindFirstChild('UnlockPrompt').Enabled = false

                end
            end
        end
    end
end)

               local bananaCon
                Toggles.nobanana:OnChanged(function()
                    if Toggles.nobanana.Value then
                        if gameData.Floor.Value == 'Fools' then
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name == "BananaPeel" then
                                vtouch(v, false)
                            end
                        end
                        bananaCon = workspace.ChildAdded:Connect(function(banana)
                         if banana.Name == "BananaPeel" then
                        vtouch(banana, false)
                         
                         end
                        end)
                    elseif not Toggles.nobanana.Value then
                        if bananaCon and bananaCon.Connected then
                            bananaCon:Disconnect()
                            for _, v in pairs(workspace:GetChildren()) do
                                if v.Name == "BananaPeel" then
                                    vtouch(v, true)
                        end
                    end
                end
            end
        end
    end)
                local Jeff

                Toggles.nojeff:OnChanged(function()
                    if Toggles.nojeff.Value then
                        if gameData.Floor.Value == 'Fools' then
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name == "JeffTheKiller" then
                                vtouch(v, false)
                            Jeff = workspace.ChildAdded:Connect(function(child)
                                if child.Name == "JeffTheKiller" then
                                    vtouch(child, false)
                                elseif not Toggles.nojeff.Value then
                                    for _, v in pairs(workspace:GetChildren()) do
                                        if v.Name == "JeffTheKiller" then
                                            vtouch(v, true)
                                            if Jeff and Jeff.Connected then
                                                Jeff:Disconnect()
                                            end
                                end
                              end
                            end
                        end)
                    end
                end
            end
        end
    end)



    



    
    Toggles.nohalt:OnChanged(function()
        if Toggles.nohalt.Value then
            rstorage.ClientModules.EntityModules.Shade.Name = 'NotShade'
        else
           if rstorage.ClientModules.EntityModules:FindFirstChild('NotShade') then
               rstorage.ClientModules.EntityModules:FindFirstChild('NotShade').Name = 'Shade'
           end
        end
    end)


    
    Toggles.noobst:OnChanged(function()
        if Toggles.noobst.Value then
            local addconnectidk
            addconnectidk = workspace.CurrentRooms.DescendantAdded:Connect(function(part)
                repeat task.wait() until part
        
                if not part:IsA('Model') then
                    return
                end
        
                if part.Name == 'ChandelierObstruction' or part.Name == 'Seek_Arm' then
                    vtouch(part, false)
                end
                    task.spawn(function()
                        
                for _, i in ipairs(workspace.CurrentRooms:GetChildren()) do
                    if i:IsA('Model') then
                        if i.Name == 'ChandelierObstruction' or i.Name == 'Seek_Arm' then
                            vtouch(i, false)
                        end
                    end
                end
            end)
        
                task.spawn(function()
                    repeat task.wait() until not Toggles.noobst.Value
                    addconnectidk:Disconnect()
                    if part and i then
                        vtouch(part, true)
                        vtouch(i, true)
                    end
                end)
            end)
        end
    end)
    


    local rooms
    local roomsconnection


    Toggles.noroomslock:OnChanged(function()
        if Toggles.noroomslock.Value then
            roomsconnection = LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
                for _, v in pairs(workspace.CurrentRooms[LatestRoom.Value]:FindFirstChild('Assets'):GetChildren()) do
                    if v.Name == "RoomsDoor_Entrance" then
                        v.EnterPrompt.Enabled = true
                    elseif not Toggles.noroomslock.Value then
                        if v then
                            v.EnterPrompt.Enabled = false
                            roomsconnection:Disconnect()
                        end
                    end
                end

        end)
    end
end)




    Toggles.noseek:OnChanged(function()
        if Toggles.noseek.Value then
                repeat task.wait() until workspace:FindFirstChild('SeekMoving') ~= nil
            for _, v in pairs(workspace.CurrentRooms[LatestRoom.Value]:GetDescendants()) do
                    if v.Name == "TriggerEventCollision" then
                        vtouch(v, false)
                    end
                end
            else
                if workspace:FindFirstChild('SeekMoving') then
                    for _, v in pairs(workspace.CurrentRooms[LatestRoom.Value]:GetDescendants()) do
                        if v.Name == "TriggerEventCollision" then
                            vtouch(v, true)
                end
            end
        end
    end
end)
local defActivation, defaultActive
 
Toggles.reachToggle:OnChanged(function(reachValue)
    if reachValue then
        for _, obj in pairs(workspace.CurrentRooms:GetDescendants()) do
            if obj:IsA('ProximityPrompt') then
                defActivation = obj.MaxActivationDistance
                obj.MaxActivationDistance = 12
            for _, objects in pairs(workspace.CurrentRooms:GetDescendants()) do
                if objects.Name == 'HidePrompt' then
                    defaultActive = objects.MaxActivationDistance
                    obj.MaxActivationDistance = 18
                end
            end
            end
            end
        elseif not reachValue then
            for _, obj in pairs(workspace.CurrentRooms:GetDescendants()) do
                if obj:IsA('ProximityPrompt') then
                    obj.MaxActivationDistance = defActivation
                for _, objects in pairs(workspace.CurrentRooms:GetDescendants()) do
                    if objects.Name == 'HidePrompt' then
                        obj.MaxActivationDistance = defaultActive
        end
    end
end
end
end
    end)
Toggles.heartbeatremove:OnChanged(function()
    game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.Heartbeat.Disabled = Toggles.heartbeatremove.Value
end)

         local bodyColorsProperties = {'HeadColor3', 'LeftArmColor3', 'LeftLegColor3', 'RightArmColor3', 'RightLegColor3', 'TorsoColor3'}


         Toggles.bchams:OnChanged(function()
             if Toggles.bchams.Value then
                 bodyColors.Parent = workspace
                 local bodyColorsClone = bodyColors:Clone()
                 bodyColorsClone.Name = 'bodyChams'
                 bodyColorsClone.Parent = char
         
                 for _, v in pairs(char:GetChildren()) do
                     if v.ClassName == 'MeshPart' or v.ClassName == 'Part' then
                         v.Material = Enum.Material.ForceField
                     end
                 end
         
                 for _, property in pairs(bodyColorsProperties) do
                     bodyColorsClone[property] = Options.bchCol.Value
                 end
         
                 Options.bchCol:OnChanged(function()
                     for _, property in pairs(bodyColorsProperties) do
                         bodyColorsClone[property] = Options.bchCol.Value
                     end
                 end)
         
                 task.spawn(function()
                     repeat task.wait() until not Toggles.bchams.Value
                     for _, v in pairs(char:GetChildren()) do
                         if v.ClassName == "MeshPart" or v.ClassName == "Part" then
                            bodyColorsClone.Parent = workspace
                            v.Material = Enum.Material.Plastic;
                             bodyColors.Parent = char;
                         end
                     end
                     
                 end)
             end
         end)

         Toggles.bodyisInvis:OnChanged(function()
            if Toggles.bodyisInvis.Value then
                for _, v in pairs(char:GetChildren()) do
                    if v.ClassName == "MeshPart" or v.ClassName == "Part" then
                        v.Transparency = 1
                    else
                    end
                end

            else
                for _, v in pairs(char:GetChildren()) do
                    if v.ClassName == "MeshPart" or v.ClassName == "Part" then
                        v.Transparency = 0
                    end
                end
            end
         end)
    

Toggles.ambienceToggle:OnChanged(function()
    if Toggles.ambienceToggle.Value then
        oldAmbient = game.Lighting.Ambient
        game.Lighting.Ambient = Options.ambiencecol.Value

        Options.ambiencecol:OnChanged(function()
            if Toggles.ambienceToggle.Value then
                game.Lighting.Ambient = Options.ambiencecol.Value
            end
        end)

        local ambienceConnection
        ambienceConnection = game.Lighting:GetPropertyChangedSignal('Ambient'):Connect(function()
            game.Lighting.Ambient = Options.ambiencecol.Value
        end)

    else
        if ambienceConnection and ambienceConnection.Connected then
            ambienceConnection:Disconnect()
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
        end
end)

local rsconnection
Toggles.camhead:OnChanged(function(valueof)
    if valueof then
        rsconnection = RunService.RenderStepped:Connect(function()
            local Camera = workspace.CurrentCamera
            local Head = char.Head
            Camera.CFrame = Head.CFrame
        end)
    else
        if rsconnection and rsconnection.Connected then
            rsconnection:Disconnect()
        end
    end
end)

   Options.fovSlider:OnChanged(function()
    rsconnection = RunService.RenderStepped:Connect(function()
           workspace.Camera.FieldOfView = Options.fovSlider.Value
   end)
end)
                        
    local oldPhys = char.HumanoidRootPart.CustomPhysicalProperties

    Toggles.noacc:OnChanged(function()
        if Toggles.noacc.Value then
            char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100,0,0,0,0)
        else
            char.HumanoidRootPart.CustomPhysicalProperties = oldPhys
        end
    end)
 
    local noclipconn

    Toggles.nclip:OnChanged(function()
        if Toggles.nclip.Value then
        noclipconn = RunService.RenderStepped:Connect(function()
           for i, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
            v.CanCollide = false
            elseif not Toggles.nclip.Value then
                 noclipconn:Disconnect()
                 for i, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
     end
  end)
end
end)

Options.finallysboost:OnChanged(function()
    char.Humanoid:SetAttribute("SpeedBoostBehind", Options.finallysboost.Value)
    char.Humanoid:GetAttributeChangedSignal("SpeedBoostBehind"):Connect(function()
        char.Humanoid:SetAttribute("SpeedBoostBehind", Options.finallysboost.Value)
    end)
end)


Toggles.sbypass:OnChanged(function(Values)
    if Values then
        speedbypassv = true
        Collision.Massless = false
        speedbypass()
        Collision.Massless = false
        wait(0.24)
    else
        speedbypassv = false
        Collision.Massless = false
        speedbypass()
        Collision.Massless = false
    end
end)
        
local connectlol
local addconn

Toggles.pesp:OnChanged(function()
    if Toggles.pesp.Value then
        for _, player in pairs(game:GetService('Players'):GetPlayers()) do
            if player.Character ~= nil and player ~= plr then
                local pespHigh = Instance.new('Highlight')
                pespHigh.Name = 'HolyHub'
                pespHigh.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                pespHigh.FillColor = Options.pespcol.Value
                pespHigh.OutlineColor = Options.pespcol.Value
                pespHigh.Parent = player.Character

                local bill = Instance.new('BillboardGui')
                bill.Name = "_HolyHub"
                bill.Active = Toggles.pesp.Value
                bill.AlwaysOnTop = true
                bill.ClipsDescendants = true
                bill.Size = UDim2.new(0, 150, 0, 50)
                bill.LightInfluence = 1
                bill.StudsOffset = Vector3.new(0, -1, 0)
                bill.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                bill.Parent  = player.Character.Head

                local text = Instance.new('TextLabel')
                text.Font = Enum.Font.Unknown
                text.Text = player.Name .. " [" .. (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude .. "]"
                text.TextColor3 = Options.pespcol.Value
                text.Name = "_Holy"
                text.TextScaled = true
                text.TextSize = 10
                text.TextStrokeTransparency = 0.5
                text.TextWrapped = true
                text.BackgroundColor3 = Color3.new(1, 1, 1)
                text.BackgroundTransparency = 1
                text.BorderColor3 = Options.pespcol.Value
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Parent = bill

                 addconn = game.Players.PlayerAdded:Connect(function(playerAdded)
                    connectlol = playerAdded.CharacterAdded:Connect(function(charadd)
                    local pespHighClone = pespHigh:Clone()
                    pespHighClone.Parent = charadd

                    local billclone = bill:Clone()
                    billclone.Parent = charadd.Head
                end)

                end)
            end
        end
    else
        if addconn and addconn.Connected then
        addconn:Disconnect()
        if connectlol and connectlol.Connected then
        connectlol:Disconnect()
        if pespHigh then
            pespHigh:Destroy()
        if pespHighClone then
            pespHighClone:Destroy()
        if bill then
            bill:Destroy()
        if billclone then
            billclone:Destroy()
        end
        end
        end
        end
    end
    end
    end
end)













Library:OnUnload(function()

    Library.Unloaded = true
end)


local MenuGroup = Tabs.Configs:AddLeftGroupbox('Menu')


MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Right Shift', NoUI = true, Text = 'Menu keybind' })



Library.ToggleKeybind = Options.MenuKeybind


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })


ThemeManager:SetFolder('Holy Hub')
SaveManager:SetFolder('HolyHub/DOORS')



SaveManager:BuildConfigSection(Tabs.Configs)


ThemeManager:ApplyToTab(Tabs.Configs)

SaveManager:LoadAutoloadConfig()
