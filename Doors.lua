-- G13 DOORS: UNIVERSAL SMART GUI (AUTO-DETECT P1 & P2)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local AntiGodBtn = Instance.new("TextButton")
local ItemBtn = Instance.new("TextButton")
local InteractBtn = Instance.new("TextButton")
local VisBtn = Instance.new("TextButton")
local OptBtn = Instance.new("TextButton")

-- DETECCIÓN AUTOMÁTICA DE PISO (ANTI-KICK)
local IsMines = false
if game.PlaceId == 11532560810 or workspace:FindFirstChild("Mines") or workspace:FindFirstChild("Floor2") then
    IsMines = true
end

ScreenGui.Parent = game.CoreGui

-- 1. BOTÓN MINIMIZAR (CÍRCULO FLOTANTE)
ToggleBtn.Parent = ScreenGui
ToggleBtn.Text = IsMines and "MINES" or "HOTEL"
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 10, 0.6, 0)
ToggleBtn.BackgroundColor3 = IsMines and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(150, 0, 0)
ToggleBtn.Draggable = true
ToggleBtn.Active = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- 2. PANEL PRINCIPAL
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Size = UDim2.new(0, 190, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Visible = true
MainFrame.Draggable = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. ANTI-ENTIDADES (SCREECH, EYES, LOOKMAN & GIGGLE)
local antiActive = false
AntiGodBtn.Parent = MainFrame
AntiGodBtn.Text = "PROTECCIÓN: OFF"
AntiGodBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
AntiGodBtn.Position = UDim2.new(0.05, 0, 0.03, 0)
AntiGodBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
AntiGodBtn.TextColor3 = Color3.new(1, 1, 1)

AntiGodBtn.MouseButton1Click:Connect(function()
    antiActive = not antiActive
    AntiGodBtn.Text = antiActive and "PROTECCIÓN: ON" or "PROTECCIÓN: OFF"
    AntiGodBtn.BackgroundColor3 = antiActive and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(80, 0, 120)
    
    task.spawn(function()
        while antiActive do
            local char = game.Players.LocalPlayer.Character
            -- Anti-Screech (Universal)
            if char:FindFirstChild("Screech") then char.Screech:Destroy() end
            
            -- Anti-Giggle (Solo en P2 para evitar sospechas)
            if IsMines and char:FindFirstChild("Giggle") then char.Giggle:Destroy() end
            
            -- Anti-Eyes & Lookman (Universal)
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Eyes" or v.Name == "Lookman" then
                    game:GetService("ReplicatedStorage").EntityInfo.EyesOnScreen:FireServer(false)
                end
            end
            task.wait(0.2)
        end
    end)
end)

-- 4. ESP INTELIGENTE (DUPE / SEEK GUIDE / PUERTA REAL)
ItemBtn.Parent = MainFrame
ItemBtn.Text = "ESP: OBJETIVOS"
ItemBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
ItemBtn.Position = UDim2.new(0.05, 0, 0.19, 0)

ItemBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        -- GUÍA DE SEEK (Luz Azul en P2)
        if IsMines and (v.Name == "SeekGuideLight" or v.Name == "GuideLight") then
            local h = Instance.new("Highlight", v)
            h.FillColor = Color3.fromRGB(0, 200, 255)
            h.FillTransparency = 0.2
        
        -- PUERTA CORRECTA (Ignora Dupe en P1)
        elseif v.Name == "Door" and v:FindFirstChild("Sign") then
            if not IsMines and v.Parent.Name ~= "DupeRoom" then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.new(0, 1, 0) -- Verde = Real
            elseif IsMines then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.new(0, 1, 0)
            end
            
        -- ITEMS, LLAVES Y LIBROS
        elseif v.Name == "Key" or v.Name == "MinesKey" or v.Name == "Lever" or v.Name == "LiveHintBook" then
            local h = Instance.new("Highlight", v)
            h.FillColor = Color3.new(1, 1, 0)
        end
    end
end)

-- 5. AUTO-LOOT (COFRES, CAJONES Y ORO)
local lootActive = false
InteractBtn.Parent = MainFrame
InteractBtn.Text = "AUTO-LOOT: OFF"
InteractBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
InteractBtn.Position = UDim2.new(0.05, 0, 0.35, 0)

InteractBtn.MouseButton1Click:Connect(function()
    lootActive = not lootActive
    InteractBtn.Text = lootActive and "AUTO-LOOT: ON" or "AUTO-LOOT: OFF"
    InteractBtn.BackgroundColor3 = lootActive and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(60, 60, 60)
    
    task.spawn(function()
        while lootActive do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Parent and v.Parent.Name ~= "Wardrobe" then
                    v.HoldDuration = 0
                    if v.Enabled and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent:GetPivot().Position).Magnitude < 8 then
                        fireproximityprompt(v)
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end)

-- 6. FULLBRIGHT (VISIBILIDAD TOTAL)
VisBtn.Parent = MainFrame
VisBtn.Text = "ILUMINAR MAPA"
VisBtn.Size = UDim2.new(0, 171, 0, 42)
VisBtn.Position = UDim2.new(0.05, 0, 0.51, 0)
VisBtn.MouseButton1Click:Connect(function()
    local l = game:GetService("Lighting")
    l.Brightness = 2
    l.ClockTime = 14
    l.FogEnd = 100000
end)

-- 7. OPTIMIZADOR FPS (G13 LIGHT MODE)
OptBtn.Parent = MainFrame
OptBtn.Text = "OPTIMIZAR FPS"
OptBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
OptBtn.Position = UDim2.new(0.05, 0, 0.67, 0)
OptBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)

OptBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end
        if v:IsA("PointLight") or v:IsA("SpotLight") then v.Shadows = false end
    end
    OptBtn.Text = "FPS OPTIMIZADO"
end)
