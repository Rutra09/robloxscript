-- Create the GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 280) -- Height set to 280
frame.Position = UDim2.new(0.5, -150, 0.5, -140) -- Centered
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

-- Add rounded corners to the blur background
local blurCorner = Instance.new("UICorner", blurBackground)
blurCorner.CornerRadius = UDim.new(0, 12)

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

-- Function to create evenly spaced elements
local function createElement(parent, elementType, positionY, labelText, defaultValue, isButton)
    local elementLabel = Instance.new("TextLabel", parent)
    elementLabel.Size = UDim2.new(0.4, 0, 0, 20)
    elementLabel.Position = UDim2.new(0.05, 0, positionY, 0)
    elementLabel.Text = labelText
    elementLabel.TextColor3 = Color3.new(1, 1, 1)
    elementLabel.BackgroundTransparency = 1
    elementLabel.ZIndex = 2

    local element
    if isButton then
        element = Instance.new("TextButton", parent)
    else
        element = Instance.new("TextBox", parent)
    end
    element.Size = UDim2.new(0.4, 0, 0, 20)
    element.Position = UDim2.new(0.55, 0, positionY, 0)
    element.Text = tostring(defaultValue)
    element.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    element.BackgroundTransparency = 0.5
    element.TextColor3 = Color3.new(1, 1, 1)
    element.ZIndex = 2
    local elementCorner = Instance.new("UICorner", element)
    elementCorner.CornerRadius = UDim.new(0, 8)

    return element
end

-- Calculate positions dynamically
local numElements = 6 -- Total number of elements (2 speed inputs + 3 keybinds + 1 toggle button)
local startY = 0.01 -- Starting Y position (10% from the top)
local spacing = (1 - startY*5 * 2) / (numElements + 1) -- Even spacing between elements

-- Levitate Speed Input
local levitateSpeedInput = createElement(frame, "TextBox", startY + spacing * 1, "Levitate Speed:", "10", false)

-- Move Speed Input
local moveSpeedInput = createElement(frame, "TextBox", startY + spacing * 2, "Move Speed:", "20", false)

-- Keybind Inputs
local keybinds = {
    Up = Enum.KeyCode.Up,
    Down = Enum.KeyCode.Down,
    Forward = Enum.KeyCode.W
}

local function createKeybindInput(labelText, defaultKey, positionY, keybindName)
    local keybindInput = createElement(frame, "TextButton", positionY, labelText, tostring(defaultKey):gsub("Enum.KeyCode.", ""), true)

    keybindInput.MouseButton1Click:Connect(function()
        keybindInput.Text = "Press a key..."
        local input = game:GetService("UserInputService").InputBegan:Wait()
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keybinds[keybindName] = input.KeyCode
            keybindInput.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        end
    end)
end

-- Create keybind inputs
createKeybindInput("Up Keybind", keybinds.Up, startY + spacing * 3, "Up")
createKeybindInput("Down Keybind", keybinds.Down, startY + spacing * 4, "Down")
createKeybindInput("Forward Keybind", keybinds.Forward, startY + spacing * 5, "Forward")

-- Toggle Levitation Button
local toggleButton = createElement(frame, "TextButton", startY + spacing * 6, "Toggle Levitation", "Toggle Levitation", true)

-- Set Speed Button
local setSpeedButton = createElement(frame, "TextButton", startY + spacing * 7, "Set Speed", "Set Speed", true)

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
        if game:GetService("UserInputService"):IsKeyDown(keybinds.Up) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(keybinds.Down) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(keybinds.Forward) then
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