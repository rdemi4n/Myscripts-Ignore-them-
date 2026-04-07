-- G13 BLUE LOCK LEGACY: V1
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Btn = Instance.new("TextButton", ScreenGui)

Btn.Size = UDim2.new(0, 80, 0, 80)
Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "LEGACY"
Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

local Active = false

Btn.MouseButton1Click:Connect(function()
    Active = not Active
    Btn.Text = Active and "ON" or "LEGACY"
    Btn.BackgroundColor3 = Active and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
    
    -- LOOP DE MEJORAS
    task.spawn(function()
        while Active and task.wait(0.5) do
            local char = game.Players.LocalPlayer.Character
            if char then
                -- 1. Stamina / Energía (Busca el valor en el Char)
                local stats = char:FindFirstChild("Stats") or char
                if stats:FindFirstChild("Stamina") then
                    stats.Stamina.Value = 100
                end
                
                -- 2. Hitbox Expander (Para patear más fácil)
                -- Esto hace que la pelota "sienta" que estás cerca aunque estés a un par de metros
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Football" or v.Name == "Ball" then
                        v.CanCollide = false
                        v.Size = Vector3.new(10, 10, 10) -- La hace "gigante" para tu cliente
                        v.Transparency = 0.7 -- Para que no te tape la vista
                    end
                end
                
                -- 3. Velocidad base (Un toque más rápido)
                if char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = 23
                end
            end
        end
    end)
end)
