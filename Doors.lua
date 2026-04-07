-- G13 DOORS V5: OPTIMIZADO PARA MOTO G13 (FIX TOTAL)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)

-- UI COMPACTA
MainFrame.Size = UDim2.new(0, 160, 0, 240)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

ToggleBtn.Size = UDim2.new(0, 70, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0.7, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local _G = { Anti = false, ESP = false, Loot = false, Light = false }

local function createBtn(txt, pos, color, var)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9, 0, 0.18, 0)
    b.Position = pos
    b.Text = txt .. ": OFF"
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.Text = txt .. ": " .. (_G[var] and "ON" or "OFF")
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 200, 0) or color
    end)
end

createBtn("PROTECT", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(60, 0, 100), "Anti")
createBtn("ESP", UDim2.new(0.05, 0, 0.28, 0), Color3.fromRGB(40, 40, 40), "ESP")
createBtn("LOOT", UDim2.new(0.05, 0, 0.51, 0), Color3.fromRGB(40, 40, 40), "Loot")
createBtn("LUZ", UDim2.new(0.05, 0, 0.74, 0), Color3.fromRGB(40, 40, 40), "Light")

-- LÓGICA DE ESCANEO LOCAL (MÁS RÁPIDA)
task.spawn(function()
    while task.wait(0.3) do
        local p = game.Players.LocalPlayer
        local char = p.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local root = char.HumanoidRootPart

        -- 1. LUZ Y PROTECCIÓN
        if _G.Light then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = 2
        end
        if _G.Anti then
            if char:FindFirstChild("Screech") then char.Screech:Destroy() end
            if char:FindFirstChild("Giggle") then char.Giggle:Destroy() end
            if workspace:FindFirstChild("RushMoving") or workspace:FindFirstChild("AmbushMoving") then
                ToggleBtn.Text = "¡RUSH!"
                ToggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
            else
                ToggleBtn.Text = "MENU"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
        end

        -- 2. LOOT Y ESP (SOLO EN HABITACIÓN ACTUAL)
        local rooms = workspace:FindFirstChild("CurrentRooms")
        if rooms then
            for _, room in pairs(rooms:GetChildren()) do
                for _, v in pairs(room:GetDescendants()) do
                    
                    -- ESP DE PUERTA (SIN BLOQUE GORDO)
                    if _G.ESP and v.Name == "Door" and v:FindFirstChild("Sign") and v.Parent.Name ~= "DupeRoom" then
                        if not v:FindFirstChild("BillboardGui") then
                            local bg = Instance.new("BillboardGui", v)
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(0, 100, 0, 50)
                            local tl = Instance.new("TextLabel", bg)
                            tl.Size = UDim2.new(1, 0, 1, 0)
                            tl.Text = "PUERTA"
                            tl.TextColor3 = Color3.new(0, 1, 0)
                            tl.BackgroundTransparency = 1
                        end
                    end

                    -- AUTO-LOOT (ORO, LLAVES, CANDADOS)
                    if _G.Loot then
                        if v:IsA("ProximityPrompt") and v.Enabled then
                            local dist = (root.Position - v.Parent:GetPivot().Position).Magnitude
                            if dist < 12 then
                                local n = v.Parent.Name:lower()
                                if n:find("key") or n:find("gold") or n:find("lever") or n:find("lock") or n:find("coin") then
                                    fireproximityprompt(v)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
