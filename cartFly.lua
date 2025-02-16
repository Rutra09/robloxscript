-- Create the GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true

-- Add rounded corners to the main frame
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Background Blur (Localized to the GUI)
local blurBackground = Instance.new("Frame", frame)
blurBackground.Size = UDim2.new(1, 0, 1, 0)
blurBackground.BackgroundColor3 = Color3.new(0, 0, 0)
blurBackground.BackgroundTransparency = 0.5
blurBackground.ZIndex = 0 -- Ensure it's behind other elements

-- Add a BlurEffect to the background
local blur = Instance.new("BlurEffect", blurBackground)
blur.Size = 24

-- Title Bar
local titleBar = Instance.new("TextLabel", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.Text = "Levitate Controls"
titleBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleBar.BackgroundTransparency = 0.5
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.ZIndex = 2 -- Ensure it's above the blur background
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

-- Levitate Speed Input
local levitateSpeedLabel = Instance.new("TextLabel", frame)
levitateSpeedLabel.Size = UDim2.new(0.4, 0, 0, 20)
levitateSpeedLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
levitateSpeedLabel.Text = "Levitate Speed:"
levitateSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
levitateSpeedLabel.BackgroundTransparency = 1
levitateSpeedLabel.ZIndex = 2

local levitateSpeedInput = Instance.new("TextBox", frame)
levitateSpeedInput.Size = UDim2.new(0.4, 0, 0, 20)
levitateSpeedInput.Position = UDim2.new(0.55, 0, 0.2, 0)
levitateSpeedInput.Text = "10" -- Default value
levitateSpeedInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
levitateSpeedInput.BackgroundTransparency = 0.5
levitateSpeedInput.TextColor3 = Color3.new(1, 1, 1)
levitateSpeedInput.ZIndex = 2
local speedInputCorner = Instance.new("UICorner", levitateSpeedInput)
speedInputCorner.CornerRadius = UDim.new(0, 8)

-- Move Speed Input
local moveSpeedLabel = Instance.new("TextLabel", frame)
moveSpeedLabel.Size = UDim2.new(0.4, 0, 0, 20)
moveSpeedLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
moveSpeedLabel.Text = "Move Speed:"
moveSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
moveSpeedLabel.BackgroundTransparency = 1
moveSpeedLabel.ZIndex = 2

local moveSpeedInput = Instance.new("TextBox", frame)
moveSpeedInput.Size = UDim2.new(0.4, 0, 0, 20)
moveSpeedInput.Position = UDim2.new(0.55, 0, 0.35, 0)
moveSpeedInput.Text = "20" -- Default value
moveSpeedInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
moveSpeedInput.BackgroundTransparency = 0.5
moveSpeedInput.TextColor3 = Color3.new(1, 1, 1)
moveSpeedInput.ZIndex = 2
local moveInputCorner = Instance.new("UICorner", moveSpeedInput)
moveInputCorner.CornerRadius = UDim.new(0, 8)

-- Toggle Levitation Button
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.55, 0)
toggleButton.Text = "Toggle Levitation"
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.BackgroundTransparency = 0.5
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.ZIndex = 2
local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0, 8)

-- Set Speed Button
local setSpeedButton = Instance.new("TextButton", frame)
setSpeedButton.Size = UDim2.new(0.9, 0, 0, 30)
setSpeedButton.Position = UDim2.new(0.05, 0, 0.75, 0)
setSpeedButton.Text = "Set Speed"
setSpeedButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
setSpeedButton.BackgroundTransparency = 0.5
setSpeedButton.TextColor3 = Color3.new(1, 1, 1)
setSpeedButton.ZIndex = 2
local setSpeedCorner = Instance.new("UICorner", setSpeedButton)
setSpeedCorner.CornerRadius = UDim.new(0, 8)

-- Variables for the script
local levitateSpeed = 10
local moveSpeed = 20
local levitating = false
local seat = nil
local bodyVelocity = nil

-- Function to handle levitation and rotation
local function levitateAndRotate()
    while levitating do
        if not seat then
            warn("Seat is no longer available. Stopping levitation.")
            levitating = false
            break
        end

        local camera = workspace.CurrentCamera
        local cameraCFrame = camera.CFrame
        local lookVector = cameraCFrame.LookVector
        lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit

        local desiredRotation = CFrame.new(seat.Position, seat.Position + lookVector)
        seat.CFrame = desiredRotation

        local direction = Vector3.new(0, 0, 0)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Up) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Down) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            direction = direction + lookVector
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
            seat.Velocity = Vector3.new(0, direction.Y * levitateSpeed, 0)
            bodyVelocity.Velocity = direction * moveSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            seat.Velocity = Vector3.new(0, 0, 0)
        end

        game:GetService("RunService").Heartbeat:Wait()
    end
end

-- Toggle Levitation Button Click Event
toggleButton.MouseButton1Click:Connect(function()
    levitating = not levitating
    if levitating then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        seat = humanoid.SeatPart

        if not seat then
            warn("Player is not seated in a vehicle.")
            levitating = false
            return
        end

        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity", seat)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end

        levitateAndRotate()
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end)

-- Set Speed Button Click Event
setSpeedButton.MouseButton1Click:Connect(function()
    levitateSpeed = tonumber(levitateSpeedInput.Text) or 10
    moveSpeed = tonumber(moveSpeedInput.Text) or 20
end)