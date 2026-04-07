-- G13 DOORS V3: FIXED & AUTO-REFRESH
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

-- CONFIGURACIÓN VISUAL (Panel más compacto)
MainFrame.Size = UDim2.new(0, 170, 0, 260)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.7, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local function createBtn(txt, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9, 0, 0.15, 0)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    return b
end

-- VARIABLES DE ESTADO
local _G = {
    AntiEntity = false,
    ESP = false,
    AutoLoot = false,
    FullBright = false,
    FPS = false
}

-- 1. PROTECCIÓN (SCREECH, GIGGLE, EYES)
local btnAnti = createBtn("PROTECCIÓN: OFF", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(80, 0, 120))
btnAnti.MouseButton1Click:Connect(function()
    _G.AntiEntity = not _G.AntiEntity
    btnAnti.Text = _G.AntiEntity and "PROTECCIÓN: ON" or "PROTECCIÓN: OFF"
    btnAnti.BackgroundColor3 = _G.AntiEntity and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(80, 0, 120)
end)

-- 2. ESP MEJORADO (SOLO PUERTA REAL + AUTO-REFRESH)
local btnESP = createBtn("ESP OBJETIVOS: OFF", UDim2.new(0.05, 0, 0.23, 0), Color3.fromRGB(40, 40, 40))
btnESP.MouseButton1Click:Connect(function()
    _G.ESP = not _G.ESP
    btnESP.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
end)

-- 3. AUTO-LOOT (ORO, LLAVES Y CANDADOS)
local btnLoot = createBtn("AUTO-LOOT: OFF", UDim2.new(0.05, 0, 0.41, 0), Color3.fromRGB(40, 40, 40))
btnLoot.MouseButton1Click:Connect(function()
    _G.AutoLoot = not _G.AutoLoot
    btnLoot.Text = _G.AutoLoot and "LOOT: ON" or "LOOT: OFF"
end)

-- 4. FULLBRIGHT PERMANENTE
local btnVis = createBtn("FULLBRIGHT: OFF", UDim2.new(0.05, 0, 0.59, 0), Color3.fromRGB(40, 40, 40))
btnVis.MouseButton1Click:Connect(function()
    _G.FullBright = not _G.FullBright
    btnVis.Text = _G.FullBright and "Luz: ON" or "Luz: OFF"
end)

-- 5. OPTIMIZADOR FPS (REDUCCIÓN DE GRÁFICOS)
local btnFPS = createBtn("FPS OPTIMIZADO", UDim2.new(0.05, 0, 0.77, 0), Color3.fromRGB(0, 100, 0))
btnFPS.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end
    end
end)

-- LOOP PRINCIPAL (ESTO ARREGLA TODO)
task.spawn(function()
    while task.wait(1) do
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Loop de Protección e Iluminación
        if _G.AntiEntity then
            if char:FindFirstChild("Screech") then char.Screech:Destroy() end
            if char:FindFirstChild("Giggle") then char.Giggle:Destroy() end
        end
        
        if _G.FullBright then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
        end

        -- Loop de ESP y Loot
        for _, v in pairs(workspace:GetDescendants()) do
            -- ESP PUERTAS (Solo el modelo de la puerta)
            if _G.ESP and v.Name == "Door" and v:FindFirstChild("Sign") and v.Parent.Name ~= "DupeRoom" then
                if not v:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v)
                    h.FillColor = Color3.new(0, 1, 0)
                    h.OutlineTransparency = 1
                end
            end

            -- AUTO-LOOT (Oro, Llaves, Candados)
            if _G.AutoLoot and v:IsA("ProximityPrompt") then
                local name = v.Parent.Name:lower()
                if name:find("key") or name:find("gold") or name:find("lever") or name:find("lock") then
                    v.HoldDuration = 0
                    if v.Enabled and root and (root.Position - v.Parent:GetPivot().Position).Magnitude < 10 then
                        fireproximityprompt(v)
                    end
                end
            end
        end
    end
end)
