-- G13 DOORS V4: FIX TOTAL (AUTO-LOOT, FULLBRIGHT REAL, ESP MEJORADO)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

-- PANEL CONFIG (Compacto)
MainFrame.Size = UDim2.new(0, 170, 0, 260)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

ToggleBtn.Size = UDim2.new(0, 85, 0, 45) -- Más ancho para texto de alerta
ToggleBtn.Position = UDim2.new(0, 10, 0.7, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
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
    b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b)
    return b
end

local _G = { AntiEntity = false, ESP = false, AutoLoot = false, FullBright = false }

local btnAnti = createBtn("PROTECCIÓN: OFF", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(80, 0, 120))
btnAnti.MouseButton1Click:Connect(function()
    _G.AntiEntity = not _G.AntiEntity
    btnAnti.Text = _G.AntiEntity and "PROTECCIÓN: ON" or "PROTECCIÓN: OFF"
    btnAnti.BackgroundColor3 = _G.AntiEntity and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(80, 0, 120)
end)

local btnESP = createBtn("ESP PUERTAS: OFF", UDim2.new(0.05, 0, 0.23, 0), Color3.fromRGB(40, 40, 40))
btnESP.MouseButton1Click:Connect(function()
    _G.ESP = not _G.ESP
    btnESP.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
end)

local btnLoot = createBtn("AUTO-LOOT: OFF", UDim2.new(0.05, 0, 0.41, 0), Color3.fromRGB(40, 40, 40))
btnLoot.MouseButton1Click:Connect(function()
    _G.AutoLoot = not _G.AutoLoot
    btnLoot.Text = _G.AutoLoot and "LOOT: ON" or "LOOT: OFF"
end)

local btnVis = createBtn("Luz: OFF", UDim2.new(0.05, 0, 0.59, 0), Color3.fromRGB(40, 40, 40))
btnVis.MouseButton1Click:Connect(function()
    _G.FullBright = not _G.FullBright
    btnVis.Text = _G.FullBright and "Luz: ON" or "Luz: OFF"
end)

local btnFPS = createBtn("FPS OPTIMIZADO", UDim2.new(0.05, 0, 0.77, 0), Color3.fromRGB(0, 100, 0))
btnFPS.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end
    end
end)

-- LOOP SÚPER RÁPIDO (0.1s para no perder ni una moneda)
task.spawn(function()
    while task.wait(0.1) do
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Fullbright Invasivo (No deja que DOORS apague la luz ni meta niebla)
        if _G.FullBright then
            game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
            game:GetService("Lighting").OutdoorAmbient = Color3.new(1, 1, 1)
            game:GetService("Lighting").ColorShift_Bottom = Color3.new(1, 1, 1)
            game:GetService("Lighting").ColorShift_Top = Color3.new(1, 1, 1)
            game:GetService("Lighting").FogEnd = 100000
            if game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere") then
                game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere").Density = 0
            end
        end

        -- Alerta de Rush y Protección de Mobs
        if _G.AntiEntity then
            if char and char:FindFirstChild("Screech") then char.Screech:Destroy() end
            if char and char:FindFirstChild("Giggle") then char.Giggle:Destroy() end
            
            -- Radar en el botón de Menú
            if workspace:FindFirstChild("RushMoving") or workspace:FindFirstChild("AmbushMoving") then
                ToggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
                ToggleBtn.Text = "¡ESCONDATE!"
            else
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                ToggleBtn.Text = "MENU"
            end
        end

        if root then
            -- Busca solo en las habitaciones (Evita lag en el Moto G13)
            local rooms = workspace:FindFirstChild("CurrentRooms")
            if rooms then
                for _, v in pairs(rooms:GetDescendants()) do
                    
                    -- ESP ARREGLADO (Cristalino)
                    if _G.ESP and v.Name == "Door" and v:FindFirstChild("Sign") and v.Parent.Name ~= "DupeRoom" then
                        if not v:FindFirstChild("Highlight") then
                            local h = Instance.new("Highlight", v)
                            h.FillColor = Color3.new(0, 1, 0)
                            h.FillTransparency = 0.8  -- Transparente para que veas el número
                            h.OutlineTransparency = 0 -- Borde visible
                            h.OutlineColor = Color3.new(0, 1, 0)
                        end
                    end

                    -- AUTO-LOOT MODO BESTIA
                    if _G.AutoLoot and v:IsA("ProximityPrompt") then
                        local dist = (root.Position - v.Parent:GetPivot().Position).Magnitude
                        if dist < 15 then -- Rango ampliado
                            local n = v.Parent.Name:lower()
                            -- Excluye los roperos y camas para que no te escondas sin querer
                            if not n:find("hide") and not n:find("closet") and not n:find("bed") then
                                v.HoldDuration = 0
                                if v.Enabled then
                                    task.spawn(function()
                                        fireproximityprompt(v)
                                    end)
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
end)
