--// UI Fly Script with Mobile Support, Toggle, Lock, Drag //

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- UI Creation
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyUI"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Active = true
mainFrame.Draggable = true

local toggleFly = Instance.new("TextButton", mainFrame)
toggleFly.Size = UDim2.new(1, 0, 0, 40)
toggleFly.Position = UDim2.new(0, 0, 0, 0)
toggleFly.Text = "Toggle Fly"

local lockDrag = Instance.new("TextButton", mainFrame)
lockDrag.Size = UDim2.new(1, 0, 0, 40)
lockDrag.Position = UDim2.new(0, 0, 0, 50)
lockDrag.Text = "Lock UI"

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 0, 100)
statusLabel.Text = "Fly: OFF"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1

-- Variables
local flying = false
local lockUI = false
local velocity = Vector3.new()
local speed = 50

-- Drag Lock
lockDrag.MouseButton1Click:Connect(function()
	lockUI = not lockUI
	mainFrame.Draggable = not lockUI
	lockDrag.Text = lockUI and "Unlock UI" or "Lock UI"
end)

-- Fly Function
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1,1,1) * math.huge
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.P = 10000

local function flyLoop()
	RunService:BindToRenderStep("FlyStep", Enum.RenderPriority.Input.Value, function()
		if flying and character and humanoidRootPart then
			local moveVector = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= workspace.CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += workspace.CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector -= Vector3.new(0,1,0) end
			bodyVelocity.Velocity = moveVector.Unit * speed
			bodyVelocity.Parent = humanoidRootPart
		else
			bodyVelocity.Parent = nil
		end
	end)
end

-- Toggle Fly
flyLoop()
toggleFly.MouseButton1Click:Connect(function()
	flying = not flying
	statusLabel.Text = flying and "Fly: ON" or "Fly: OFF"
end)

-- Cleanup on death
player.CharacterAdded:Connect(function(char)
	character = char
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	bodyVelocity.Parent = nil
end)
