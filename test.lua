-- Check game
if game.PlaceId == 10449761463 then
    local CurrentVersion = "TSB - Beta 0.1"
    
    -- GUI Library
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()

    -- Main GUI
    local Window = Library:Window({
        text = "TSB Script"
    })
    
    local TabSection = Window:TabSection({
        text = "Fighting"
    })
    
    local Tab = TabSection:Tab({
        text = "Legit",
        icon = "rbxassetid://7999345313",
    })

    
    local Section = Tab:Section({
        text = "Auto Block"
    })

    -- Variable to store the bubble
    local bubble
    local currentRange = 10 -- Default range
    local bubbleEnabled = false -- State to track if the bubble is enabled
    local playerLooking = false -- State for looking at the player

    Section:Slider({
        text = "Range",
        min = 10,
        max = 100,
        callback = function(number)
            currentRange = number
            if bubble and bubbleEnabled then
                bubble.Size = Vector3.new(currentRange * 2, currentRange * 2, currentRange * 2)
            end
        end
    })

    -- Function to create the bubble
    local function createBubble()
        if not bubble then
            bubble = Instance.new("Part")
            bubble.Shape = Enum.PartType.Ball
            bubble.Anchored = true
            bubble.CanCollide = false
            bubble.BrickColor = BrickColor.new("Bright red")
            bubble.Transparency = 0.5
            bubble.Size = Vector3.new(currentRange * 2, currentRange * 2, currentRange * 2)
            bubble.Parent = workspace
        end
    end

    -- Function to remove the bubble
    local function removeBubble()
        if bubble then
            bubble:Destroy()
            bubble = nil
        end
    end

    -- Ensure the bubble follows the player
    local RunService = game:GetService("RunService")
    RunService.RenderStepped:Connect(function()
        if bubbleEnabled and bubble then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                bubble.CFrame = humanoidRootPart.CFrame
            end
        end
    end)

    -- Function to make the player look at the nearest target
    local function lookAtTarget()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local closestTarget = nil
            local closestDistance = currentRange

            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRootPart = otherPlayer.Character.HumanoidRootPart
                    local distance = (humanoidRootPart.Position - targetRootPart.Position).Magnitude

                    if distance <= currentRange and distance < closestDistance then
                        closestTarget = targetRootPart
                        closestDistance = distance
                    end
                end
            end

            if closestTarget then
                local direction = (closestTarget.Position - humanoidRootPart.Position).Unit
                local lookAtCFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + Vector3.new(direction.X, 0, direction.Z))
                humanoidRootPart.CFrame = lookAtCFrame
            end
        end
    end

    -- Toggle for enabling/disabling the bubble
    Section:Toggle({
        text = "Toggle Radius",
        state = false,
        callback = function(boolean)
            bubbleEnabled = boolean
            if bubbleEnabled then
                createBubble()
                playerLooking = true
            else
                removeBubble()
                playerLooking = false
            end
        end
    })

    -- Continuously check if toggle is enabled and look at the target
    RunService.RenderStepped:Connect(function()
        if bubbleEnabled and playerLooking then
            lookAtTarget()
        end
    end)

-- Existing code for the Auto Combo section
local Section = Tab:Section({
    text = "Auto Combo"
})

-- Add the button inside the "Auto Combo" section
Section:Button({
    text = "Saitama Combo",
    callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Communicate = Character:WaitForChild("Communicate")

        -- Function to fire a given action
        local function fireAction(goal)
            local args = {
                [1] = {
                    ["Goal"] = goal
                }
            }
            Communicate:FireServer(unpack(args))
        end

        -- Function to equip and use a move from the player's inventory
        local function equipAndUseMove(moveName)
            -- Find the tool in the player's backpack
            local tool = Player.Backpack:FindFirstChild(moveName)
            if tool then
                tool.Parent = Character
                -- Assuming the tool is activated on Equip, you can add specific behavior if needed
                tool:Activate()
            else
                warn("Tool not found:", moveName)
            end
            return tool
        end

        -- The combo sequence
        local function comboScript()
            -- Step 1: LeftClick -> LeftClickRelease
            local args1 = {
                [1] = {
                    ["Goal"] = "LeftClick",
                    ["Mobile"] = true
                }
            }
            Communicate:FireServer(unpack(args1))
            wait(0.5) -- wait for 0.5 seconds (click duration)
            local args2 = {
                [1] = {
                    ["Goal"] = "LeftClickRelease"
                }
            }
            Communicate:FireServer(unpack(args2))

            -- Step 2: Equip and use "Consecutive Punches"
            local consecutivePunches = equipAndUseMove("Consecutive Punches")
            wait(1.5) -- wait for 1.5 seconds

            -- Step 3: Equip and use "Shove" then click again
            local shove = equipAndUseMove("Shove")
            wait(0.5) -- wait for 0.5 seconds before clicking
            local args3 = {
                [1] = {
                    ["Goal"] = "LeftClick",
                    ["Mobile"] = true
                }
            }
            Communicate:FireServer(unpack(args3))
            wait(0.5) -- wait for 0.5 seconds before releasing click
            local args4 = {
                [1] = {
                    ["Goal"] = "LeftClickRelease"
                }
            }
            Communicate:FireServer(unpack(args4))

            -- Step 4: Dash with W and Q keys
            local args = {
                [1] = {
                    ["Dash"] = Enum.KeyCode.W,
                    ["Key"] = Enum.KeyCode.Q,
                    ["Goal"] = "KeyPress"
                }
            }
            Communicate:FireServer(unpack(args))

            -- Step 5: Wait for 0.4 seconds
            wait(1.2)

            -- Step 6: Equip and use "Normal Punch"
            local normalPunch = equipAndUseMove("Normal Punch")

            -- Wait for combo to finish
            wait(1)

            -- Unequip all tools after the combo
            local characterTools = {}
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(characterTools, tool)
                end
            end

            -- Unequip tools
            for _, tool in pairs(characterTools) do
                tool.Parent = Player.Backpack
            end
        end

        -- Create the tool to trigger the combo
        local comboTool = Instance.new("Tool")
        comboTool.Name = "Combo"
        comboTool.RequiresHandle = false
        comboTool.Parent = Player.Backpack

        -- Connect the tool's activation to the combo script
        comboTool.Activated:Connect(function()
            comboScript()
        end)

        -- Simulate the tool activation (to trigger the combo right away)
        comboTool:Activate()
    end
})

-- Add a new button in the Auto Combo section
Section:Button({
    text = "Garou Combo",
    callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character
        local Communicate = Character:WaitForChild("Communicate")

        -- Function to fire a given action
        local function fireAction(goal)
            local args = {
                [1] = {
                    ["Goal"] = goal
                }
            }
            Communicate:FireServer(unpack(args))
        end

        -- Function to equip and use a move from the player's inventory
        local function equipAndUseMove(moveName)
            -- Find the tool in the player's backpack
            local tool = Player.Backpack:FindFirstChild(moveName)
            if tool then
                tool.Parent = Character
                -- Assuming the tool is activated on Equip, you can add specific behavior if needed
                tool:Activate()
            else
                warn("Tool not found:", moveName)
            end
        end

        -- The combo sequence
        local function comboScript()
            -- Step 1: Click 3 times (LeftClick -> LeftClickRelease)
            for i = 1, 3 do
                local args1 = {
                    [1] = {
                        ["Goal"] = "LeftClick"
                    }
                }
                Communicate:FireServer(unpack(args1))
                wait(0.5) -- wait for 0.5 seconds (click duration)
                local args2 = {
                    [1] = {
                        ["Goal"] = "LeftClickRelease"
                    }
                }
                Communicate:FireServer(unpack(args2))
            end

            -- Step 2: Equip and use "Lethal Whirlwind Stream"
            equipAndUseMove("Lethal Whirlwind Stream")
            wait(2.45) -- wait for 2.45 seconds before activating Flowing Water

            -- Step 3: Equip and use "Flowing Water"
            equipAndUseMove("Flowing Water")
            wait(2.5) -- wait for 2.5 seconds after Flowing Water

            -- Step 4: Dash with W and Q keys and use "Hunter's Grasp"
            local args = {
                [1] = {
                    ["Dash"] = Enum.KeyCode.W,
                    ["Key"] = Enum.KeyCode.Q,
                    ["Goal"] = "KeyPress"
                }
            }
            Communicate:FireServer(unpack(args))
            equipAndUseMove("Hunter's Grasp")
        end

        -- Create the tool to trigger the combo
        local comboTool = Instance.new("Tool")
        comboTool.Name = "Combo"
        comboTool.RequiresHandle = false
        comboTool.Parent = Player.Backpack

        -- Connect the tool's activation to the combo script
        comboTool.Activated:Connect(function()
            comboScript()
        end)
    end
})

local Tab = TabSection:Tab({
    text = "ESP",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "General ESP"
})

-- Services
local RunService = game:GetService("RunService");
local PlayersService = game:GetService("Players");

-- Variables
local Camera = workspace.CurrentCamera;
local LastPos;
local Lines = {};
local Quads = {};
local ESPEnabled = false; -- Toggle state
local ESPConnection;

-- Functions
local function HasCharacter(Player)
    return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart");
end;

local function DrawQuad(PosA, PosB, PosC, PosD)
    local PosAScreen, PosAVisible = Camera:WorldToViewportPoint(PosA);
    local PosBScreen, PosBVisible = Camera:WorldToViewportPoint(PosB);
    local PosCScreen, PosCVisible = Camera:WorldToViewportPoint(PosC);
    local PosDScreen, PosDVisible = Camera:WorldToViewportPoint(PosD);

    if (not PosAVisible and not PosBVisible and not PosCVisible and not PosDVisible) then return; end;

    local PosAVec = Vector2.new(PosAScreen.X, PosAScreen.Y);
    local PosBVec = Vector2.new(PosBScreen.X, PosBScreen.Y);
    local PosCVec = Vector2.new(PosCScreen.X, PosCScreen.Y);
    local PosDVec = Vector2.new(PosDScreen.X, PosDScreen.Y);

    local Quad = Drawing.new("Quad");
        Quad.Thickness = .5;
        Quad.Color = Color3.fromRGB(255, 255, 255);
        Quad.Transparency = .25;
        Quad.ZIndex = 1;
        Quad.Filled = true;
        Quad.Visible = true;

    Quad.PointA = PosAVec;
    Quad.PointB = PosBVec;
    Quad.PointC = PosCVec;
    Quad.PointD = PosDVec;

    table.insert(Quads, Quad);
end;

local function DrawLine(From, To)
    local FromScreen, FromVisible = Camera:WorldToViewportPoint(From);
    local ToScreen, ToVisible = Camera:WorldToViewportPoint(To);

    if (not FromVisible and not ToVisible) then return; end;

    local FromPos = Vector2.new(FromScreen.X, FromScreen.Y);
    local ToPos = Vector2.new(ToScreen.X, ToScreen.Y);

    local Line = Drawing.new("Line");
        Line.Thickness = 1;
        Line.From = FromPos;
        Line.To = ToPos;
        Line.Color = Color3.fromRGB(255, 255, 255);
        Line.Transparency = 1;
        Line.ZIndex = 1;
        Line.Visible = true;

    table.insert(Lines, Line);
end;

local function GetCorners(Part)
    local CF, Size, Corners = Part.CFrame, Part.Size / 2, {};
    for X = -1, 1, 2 do for Y = -1, 1, 2 do for Z = -1, 1, 2 do
        Corners[#Corners+1] = (CF * CFrame.new(Size * Vector3.new(X, Y, Z))).Position;
    end; end; end;
    return Corners;
end;

local function DrawEsp(Player)
    local HRP = Player.Character.HumanoidRootPart;

    -- Constructing the 3d box.
    local CubeVertices = GetCorners({CFrame = HRP.CFrame * CFrame.new(0, -0.5, 0), Size = Vector3.new(3, 5, 3)});

    -- Drawing the 3d box.
    DrawLine(CubeVertices[1], CubeVertices[2]);
    DrawLine(CubeVertices[2], CubeVertices[6]);
    DrawLine(CubeVertices[6], CubeVertices[5]);
    DrawLine(CubeVertices[5], CubeVertices[1]);

    DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[6], CubeVertices[5]);

    DrawLine(CubeVertices[1], CubeVertices[3]);
    DrawLine(CubeVertices[2], CubeVertices[4]);
    DrawLine(CubeVertices[6], CubeVertices[8]);
    DrawLine(CubeVertices[5], CubeVertices[7]);

    DrawQuad(CubeVertices[2], CubeVertices[4], CubeVertices[8], CubeVertices[6]);
    DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[4], CubeVertices[3]);
    DrawQuad(CubeVertices[1], CubeVertices[5], CubeVertices[7], CubeVertices[3]);
    DrawQuad(CubeVertices[5], CubeVertices[7], CubeVertices[8], CubeVertices[6]);

    DrawLine(CubeVertices[3], CubeVertices[4]);
    DrawLine(CubeVertices[4], CubeVertices[8]);
    DrawLine(CubeVertices[8], CubeVertices[7]);
    DrawLine(CubeVertices[7], CubeVertices[3]);

    DrawQuad(CubeVertices[3], CubeVertices[4], CubeVertices[8], CubeVertices[7]);
end;

local function BoxEsp()
    local Players = PlayersService:GetPlayers();

    for i = 1, #Lines do
        local Line = rawget(Lines, i);
        if (Line) then Line:Remove(); end;
    end;

    Lines = {};

    for i = 1, #Quads do
        local Quad = rawget(Quads, i);
        if (Quad) then Quad:Remove(); end;
    end;

    Quads = {};

    for i = 1, #Players do
        local Player = rawget(Players, i);
        if HasCharacter(Player) then
            DrawEsp(Player);
        end;
    end;
end;

-- Toggle
Section:Toggle({
    text = "Box ESP Toggle",
    state = ESPEnabled,
    callback = function(state)
        ESPEnabled = state;

        if ESPEnabled then
            ESPConnection = RunService.RenderStepped:Connect(BoxEsp);
        elseif ESPConnection then
            ESPConnection:Disconnect();
            ESPConnection = nil;

            -- Clear existing ESP visuals
            for _, Line in ipairs(Lines) do
                Line:Remove();
            end;
            Lines = {};

            for _, Quad in ipairs(Quads) do
                Quad:Remove();
            end;
            Quads = {};
        end;
    end;
});

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local toggleEnabled = false  -- Default state, beams are off
local beams = {}  -- Table to store the beams

-- Function to create a beam from the player's CFrame to another player's CFrame
local function createBeam(targetPlayer)
    local beam = Instance.new("Beam")
    beam.Parent = game.Workspace
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))  -- Green color for the beam
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Texture = ""  -- Optional: Add a texture to the beam if desired

    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = LocalPlayer.Character.HumanoidRootPart
    attachment0.Position = Vector3.new(0, 5, 0)  -- Adjust position if needed

    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = targetPlayer.Character.HumanoidRootPart
    attachment1.Position = Vector3.new(0, 5, 0)  -- Adjust position if needed

    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    return beam
end

-- Function to toggle the visibility of the beams
local function toggleBeams(state)
    toggleEnabled = state

    -- If toggle is enabled, create beams for each player
    if toggleEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                -- Create a beam to the other player
                local beam = createBeam(player)
                table.insert(beams, beam)  -- Store the beam in the table
            end
        end
    else
        -- If toggle is disabled, remove all beams
        for _, beam in pairs(beams) do
            beam:Destroy()
        end
        beams = {}  -- Clear the beams table
    end
end

-- Toggle Button
Section:Toggle({
    text = "Enable/Disable Beams",
    state = toggleEnabled,  -- Set the initial state to match the toggle
    callback = function(boolean)
        toggleBeams(boolean)  -- Toggle the beams based on the state
    end
})

local ESPEnabled = false

-- Function to create the 2D box and health bar for other players
local function createESP(player)
    -- Ensure the player character and humanoid are loaded
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return
    end

    local humanoid = player.Character.Humanoid
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return
    end

    -- Create 2D box and health bar elements
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = player.Name .. "_ESP"
    screenGui.Parent = game.Players.LocalPlayer:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", game.Players.LocalPlayer)

    local box = Instance.new("Frame")
    local healthBar = Instance.new("Frame")

    -- Set box properties
    box.Size = UDim2.new(0, 100, 0, 200) -- Adjust size to cover the body
    box.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red box
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.BorderSizePixel = 0
    box.Parent = screenGui

    -- Set health bar properties
    healthBar.Size = UDim2.new(0, 100, 0, 10) -- Width = full body, height = small bar
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green health bar
    healthBar.AnchorPoint = Vector2.new(0.5, 0.5)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = screenGui

    -- Function to update positions and health dynamically
    local function updateESP()
        if not humanoid or not humanoid.Parent then
            screenGui:Destroy()
            return
        end

        local camera = workspace.CurrentCamera
        local screenPos, onScreen = camera:WorldToScreenPoint(rootPart.Position)
        if onScreen then
            box.Visible = true
            healthBar.Visible = true

            box.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            healthBar.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y + 110)

            -- Update health bar width dynamically
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthBar.Size = UDim2.new(0, 100 * healthPercent, 0, 10)
        else
            box.Visible = false
            healthBar.Visible = false
        end
    end

    -- Update in a loop
    task.spawn(function()
        while ESPEnabled and humanoid.Parent do
            updateESP()
            task.wait(0.1)
        end
        screenGui:Destroy()
    end)
end

-- Toggle the ESP
Section:Toggle({
    text = "CS:GO ESP not workie",
    state = ESPEnabled, -- Default state
    callback = function(state)
        ESPEnabled = state
        print("ESP toggled:", ESPEnabled) -- Debugging line to check toggle state

        if ESPEnabled then
            -- Enable ESP for all other players
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    createESP(player)
                end
            end
        else
            -- Disable ESP by destroying all ESP GUI elements
            for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
                if gui.Name:match("_ESP") then
                    gui:Destroy()
                end
            end
        end
    end
})


local Section = Tab:Section({
    text = "Death Counter"
})

Section:Toggle({
    text = "Death Counter",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Roblox Lua Script: Check players' inventory for 'Death Counter' and apply effects
local Players = game:GetService("Players")

-- Function to make a player glow
local function makeGlow(character, color, duration)
    if not character then return end

    -- Remove existing highlights
    local existingHighlight = character:FindFirstChild("Highlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end

    -- Create a new highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = color
    highlight.FillTransparency = 0.5

    -- Remove the highlight after the duration
    if duration > 0 then
        task.delay(duration, function()
            if highlight.Parent then
                highlight:Destroy()
            end
        end)
    end
end

-- Track state of Death Counter for players
local playerStates = {}

-- Function to check a player's inventory
local function checkInventory(player)
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character

    if backpack then
        local deathCounter = backpack:FindFirstChild("Death Counter")

        if deathCounter then
            -- If Death Counter is found and not already detected, set state and glow red
            if not playerStates[player] or not playerStates[player].hasDeathCounter then
                playerStates[player] = { hasDeathCounter = true }
                -- Remove the item from the inventory
                deathCounter:Destroy()
                -- Make the player glow red indefinitely
                makeGlow(character, Color3.new(1, 0, 0), 0)
            end
        else
            -- If Death Counter was detected but is now gone, glow yellow
            if playerStates[player] and playerStates[player].hasDeathCounter then
                playerStates[player].hasDeathCounter = false
                -- Make the player glow yellow for 10 seconds
                makeGlow(character, Color3.new(1, 1, 0), 10)
            end
        end
    end
end

-- Monitor inventory changes for a player
local function monitorInventory(player)
    local backpack = player:FindFirstChild("Backpack")

    if backpack then
        backpack.ChildAdded:Connect(function()
            checkInventory(player)
        end)
        backpack.ChildRemoved:Connect(function()
            checkInventory(player)
        end)
    end
end

-- Connect to player joining
Players.PlayerAdded:Connect(function(player)
    -- Monitor inventory changes when the player spawns
    player.CharacterAdded:Connect(function()
        monitorInventory(player)
        checkInventory(player)
    end)

    -- Initial monitoring when the script runs
    monitorInventory(player)
    checkInventory(player)
end)

-- Initial setup for all players already in the game
for _, player in ipairs(Players:GetPlayers()) do
    monitorInventory(player)
    checkInventory(player)
end

    end
})

local Tab = TabSection:Tab({
    text = "Blatant",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Anti Hit(weird)"
})

Section:Button({
    text = "Button",
    callback = function()
        loadstring(game:HttpGet("https://pastefy.app/JYn4De0C/raw"))()
    end,
})

local Section = Tab:Section({
    text = "booty clap"
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local AnimationId = "rbxassetid://120789866363939"
local selectedPlayerName = nil
local following = false

-- Create an animation instance
local animation = Instance.new("Animation")
animation.AnimationId = AnimationId
local animator = Character:WaitForChild("Humanoid"):WaitForChild("Animator")
local animationTrack = animator:LoadAnimation(animation)

-- Function to stop movement and animation
local function stopFollowing()
    following = false
    animationTrack:Stop()
end

-- Function to follow the selected player
local function followPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    -- Play the animation
    animationTrack:Play()
    following = true

    -- Follow loop
    while following and selectedPlayerName == targetPlayer.Name do
        -- Position closer behind the player
        local behindPosition = targetRoot.CFrame * CFrame.new(0, 0, 3) -- Closer distance
        local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { -- Faster speed
            CFrame = behindPosition
        })
        tween:Play()
        tween.Completed:Wait()

        -- Move forward and back smoothly
        local forwardPosition = targetRoot.CFrame * CFrame.new(0, 0, 2) -- Closer forward movement
        local backPosition = targetRoot.CFrame * CFrame.new(0, 0, 4) -- Closer backward movement

        -- Forward movement
        tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { -- Faster
            CFrame = forwardPosition
        })
        tween:Play()
        tween.Completed:Wait()

        -- Backward movement
        tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { -- Faster
            CFrame = backPosition
        })
        tween:Play()
        tween.Completed:Wait()

        wait(0.05) -- Shorter delay for smoother following
    end

    -- Stop the animation when done
    animationTrack:Stop()
end

-- Create the dropdown with player options and "None"
local playerNames = {"None"} -- Start with "None" option
for _, player in ipairs(Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

Section:Dropdown({
    text = "Select Player",
    list = playerNames,
    default = "None",
    callback = function(selectedPlayer)
        selectedPlayerName = selectedPlayer
        if selectedPlayer == "None" then
            stopFollowing()
        else
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            stopFollowing() -- Stop any current movement before starting a new one
            followPlayer(targetPlayer)
        end
    end
})


local Section = Tab:Section({
    text = "Anti death"
})

local originalPosition

Section:Dropdown({
    text = "Anti Death",
    list = {"True", "False"},  -- The options for the dropdown
    default = "False",  -- Default value
    callback = function(selectedOption)
        local player = game.Players.LocalPlayer

        -- Function to teleport the player
        local function teleportToPosition(position, anchor)
            local character = player.Character
            if character then
                -- Make sure the character is fully loaded
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                local humanoid = character:WaitForChild("Humanoid")

                -- Update position and set anchoring
                humanoidRootPart.CFrame = CFrame.new(position)
                humanoidRootPart.Anchored = anchor  -- Set the anchoring based on the argument

                -- Ensure the rest of the body follows the teleportation (Humanoid)
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CFrame = humanoidRootPart.CFrame  -- Sync other parts with HumanoidRootPart
                    end
                end

                -- Ensure the character's hitbox is properly positioned and not underground
                if humanoid and humanoidRootPart then
                    humanoidRootPart.Anchored = true
                    humanoidRootPart.CFrame = CFrame.new(position)  -- Position the HumanoidRootPart correctly
                    humanoid:MoveTo(humanoidRootPart.Position)  -- Ensure the humanoid's position is updated
                    humanoidRootPart.Anchored = false
                end
            end
        end

        -- Function to get the player's character and humanoid
        local function getCharacter()
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            return character, humanoid
        end

        -- Handle teleportation logic based on the selected option
        if selectedOption == "True" then
            while true do
                -- Check if player is alive, and get character and humanoid
                local character, humanoid = getCharacter()

                -- Check if the player's health is below 20%
                if humanoid.Health < 20 then
                    -- Save the current position if health is under 20%
                    if not originalPosition then
                        originalPosition = character.PrimaryPart.Position
                    end

                    -- Teleport to the specified coordinates and anchor the character
                    teleportToPosition(Vector3.new(-10.58532428741455, 808.4442749023438, -378.9240417480469), true)
                elseif humanoid.Health > 80 and originalPosition then
                    -- Teleport back to the saved position, un-anchor the character
                    teleportToPosition(originalPosition, false)
                    originalPosition = nil -- Reset the saved position
                end

                -- Wait for a short time before checking again
                wait(0.5)
            end
        elseif selectedOption == "False" then
            -- If "False" is selected, stop teleportation and reset position
            originalPosition = nil
        end
    end
})


local Section = Tab:Section({
    text = "Insta Kill Garou"
})


-- Function to equip and use a move from the player's inventory
local function equipAndUseMove(moveName)
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(moveName)
    if tool then
        tool.Parent = game.Players.LocalPlayer.Character
        -- Assuming the tool is activated on Equip, you can add specific behavior if needed
        tool:Activate()
    else
        warn("Tool not found:", moveName)
    end
    return tool
end

-- Function to unequip the tool from the player's character
local function unequipMove()
    local tool = game.Players.LocalPlayer.Character:FindFirstChild("Flowing Water")
    if tool then
        tool.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Tool 'Flowing Water' not found to unequip.")
    end
end

-- Function to update the players list for the dropdown
local function updatePlayersList()
    local playersList = {}
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        table.insert(playersList, otherPlayer.Name)  -- Add player names to the dropdown list
    end
    return playersList
end

-- Initial dropdown setup with updated player list
local playersList = updatePlayersList()

Section:Dropdown({
    text = "Select Target Player",  -- Display name of the dropdown
    list = playersList,             -- List of players for the dropdown
    default = playersList[1],       -- Default selected player
    callback = function(selectedPlayerName)
        -- When a player is selected from the dropdown
        local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
        
        if targetPlayer then
            -- Target player found, perform actions
            local targetRootPart = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRootPart then
                -- Save the current player's position
                local currentPlayer = game.Players.LocalPlayer.Character
                local initialPosition = currentPlayer.HumanoidRootPart.Position

                -- Repeatedly teleport behind the target and perform actions
                local duration = 1.5  -- Initial teleport duration in seconds
                local startTime = tick()

                -- Initial teleportation while using the move
                while tick() - startTime < duration do
                    -- Calculate position closer behind the target player (using a smaller multiplier for closer distance)
                    local targetPosition = targetRootPart.Position
                    local behindTargetPosition = targetPosition - (targetRootPart.CFrame.LookVector * 3)  -- Adjust to a closer distance, e.g., *3 instead of *5
                    currentPlayer:SetPrimaryPartCFrame(CFrame.new(behindTargetPosition))

                    -- Make the player look at the target while behind them
                    currentPlayer.HumanoidRootPart.CFrame = CFrame.new(currentPlayer.HumanoidRootPart.Position, targetRootPart.Position)

                    -- Equip and use "Flowing Water"
                    equipAndUseMove("Flowing Water")

                    wait(0.1)  -- Small wait to make the action continuous
                end

                -- Teleport up 2000 studs and 10000 studs forward after completing the move
                local newPosition = currentPlayer.HumanoidRootPart.Position + Vector3.new(10000, 2000, 0)
                currentPlayer:SetPrimaryPartCFrame(CFrame.new(newPosition))

                -- After the teleportation, return to the initial position
                wait(0.5)  -- Optional wait before returning
                currentPlayer:SetPrimaryPartCFrame(CFrame.new(initialPosition))  -- Teleport back to the initial position

                -- Unequip the tool after completion
                unequipMove()
            else
                warn("Target player does not have a HumanoidRootPart.")
            end
        else
            warn("Player not found with the name: " .. selectedPlayerName)
        end
    end
})

-- Add the "Kill Player" button
Section:Button({
    text = "Kill Player",
    callback = function()
        -- Get the username from the dropdown
        local targetUsername = Section:FindFirstChild("Dropdown").Value
        local targetPlayer = game.Players:FindFirstChild(targetUsername)

        if targetPlayer then
            -- Target player found, perform actions
            local targetRootPart = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRootPart then
                -- Save the current player's position
                local currentPlayer = game.Players.LocalPlayer.Character
                local initialPosition = currentPlayer.HumanoidRootPart.Position

                -- Repeatedly teleport behind the target and perform actions
                local duration = 1.5  -- Initial teleport duration in seconds
                local startTime = tick()

                -- Initial teleportation while using the move
                while tick() - startTime < duration do
                    -- Calculate position closer behind the target player (using a smaller multiplier for closer distance)
                    local targetPosition = targetRootPart.Position
                    local behindTargetPosition = targetPosition - (targetRootPart.CFrame.LookVector * 3)  -- Adjust to a closer distance, e.g., *3 instead of *5
                    currentPlayer:SetPrimaryPartCFrame(CFrame.new(behindTargetPosition))

                    -- Make the player look at the target while behind them
                    currentPlayer.HumanoidRootPart.CFrame = CFrame.new(currentPlayer.HumanoidRootPart.Position, targetRootPart.Position)

                    -- Equip and use "Flowing Water"
                    equipAndUseMove("Flowing Water")

                    wait(0.1)  -- Small wait to make the action continuous
                end

                -- Teleport up 2000 studs and 10000 studs forward after completing the move
                local newPosition = currentPlayer.HumanoidRootPart.Position + Vector3.new(10000, 2000, 0)
                currentPlayer:SetPrimaryPartCFrame(CFrame.new(newPosition))

                -- After the teleportation, return to the initial position
                wait(0.5)  -- Optional wait before returning
                currentPlayer:SetPrimaryPartCFrame(CFrame.new(initialPosition))  -- Teleport back to the initial position

                -- Unequip the tool after completion
                unequipMove()
            else
                warn("Target player does not have a HumanoidRootPart.")
            end
        else
            warn("Player not found with the username: " .. targetUsername)
        end
    end
})

-- Update the dropdown list every second by directly modifying the list
while true do
    wait(1)
    local updatedPlayersList = updatePlayersList()  -- Get the updated list of players
    local dropdown = Section:FindFirstChild("Dropdown")
    if dropdown then
        dropdown.list = updatedPlayersList  -- Update the dropdown list directly
    end
end

end
