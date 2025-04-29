local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Fly Vars
local flying = false
local speed = 50

local bg = Instance.new("BodyGyro")
local bv = Instance.new("BodyVelocity")

-- Fly Funcs
local function startFly()
	bg.P = 9e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = hrp.CFrame.LookVector * speed
	bv.Parent = hrp

	RS:BindToRenderStep("fly", 0, function()
		bg.CFrame = hrp.CFrame
		bv.Velocity = hrp.CFrame.LookVector * speed
	end)
end

local function stopFly()
	bg:Destroy()
	bv:Destroy()
	RS:UnbindFromRenderStep("fly")
end

local function toggleFly()
	flying = not flying
	if flying then
		startFly()
		toggleBtn.Text = "Fly: ON"
	else
		stopFly()
		toggleBtn.Text = "Fly: OFF"
	end
end

-- UI Setup
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "FlyUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 120, 0, 90)
frame.Position = UDim2.new(1, -140, 1, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 0.5, -5)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18
toggleBtn.Text = "Fly: OFF"
toggleBtn.BorderSizePixel = 0

local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size = UDim2.new(1, 0, 0.5, -5)
lockBtn.Position = UDim2.new(0, 0, 0.5, 5)
lockBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
lockBtn.TextColor3 = Color3.new(1, 1, 1)
lockBtn.Font = Enum.Font.SourceSansBold
lockBtn.TextSize = 16
lockBtn.Text = "Lock UI"
lockBtn.BorderSizePixel = 0

toggleBtn.MouseButton1Click:Connect(toggleFly)

lockBtn.MouseButton1Click:Connect(function()
	frame.Draggable = false
	frame.Active = false
	lockBtn.Text = "Locked"
end)

-- PC toggle shortcut
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		toggleFly()
	end
end)
