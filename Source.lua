local Xonix = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function tween(object, info, goals)
	TweenService:Create(object, info, goals):Play()
end

function Xonix:Create(titleName)
	local Window = {}
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "XonixUI"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -415, 0.5, -202)
	MainFrame.Size = UDim2.new(0, 831, 0, 405)
	
	local dragging, dragInput, dragStart, startPos
	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)
	MainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	local UserLabel = Instance.new("TextLabel")
	UserLabel.Parent = MainFrame
	UserLabel.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	UserLabel.BackgroundTransparency = 1
	UserLabel.Position = UDim2.new(0, 90, 0, 0)
	UserLabel.Size = UDim2.new(0, 200, 0, 50)
	UserLabel.Font = Enum.Font.SourceSans
	UserLabel.TextSize = 18
	UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	UserLabel.Text = "Welcome, " .. LocalPlayer.Name

	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.Parent = MainFrame
	AvatarImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Position = UDim2.new(0, 10, 0, 0)
	AvatarImage.Size = UDim2.new(0, 50, 0, 50)
	
	local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	AvatarImage.Image = content
	
	local UICornerAvg = Instance.new("UICorner")
	UICornerAvg.CornerRadius = UDim.new(1, 0)
	UICornerAvg.Parent = AvatarImage

	local ConsoleFrame = Instance.new("Frame")
	ConsoleFrame.Name = "workspacee"
	ConsoleFrame.Parent = MainFrame
	ConsoleFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	ConsoleFrame.BorderSizePixel = 0
	ConsoleFrame.Position = UDim2.new(0, 10, 0, 60)
	ConsoleFrame.Size = UDim2.new(0, 283, 0, 335)

	local Container = Instance.new("ScrollingFrame")
	Container.Name = "ElementsContainer"
	Container.Parent = MainFrame
	Container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 305, 0, 60)
	Container.Size = UDim2.new(0, 515, 0, 335)
	Container.ScrollBarThickness = 2
	
	local UIList = Instance.new("UIListLayout")
	UIList.Parent = Container
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 5)

	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
	end)

	function Window:Button(text, callback)
		local BtnFrame = Instance.new("Frame")
		BtnFrame.Parent = Container
		BtnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		BtnFrame.Size = UDim2.new(1, -10, 0, 35)
		BtnFrame.BorderSizePixel = 0
		
		local Btn = Instance.new("TextButton")
		Btn.Parent = BtnFrame
		Btn.Size = UDim2.new(1, 0, 1, 0)
		Btn.BackgroundTransparency = 1
		Btn.Text = text
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		Btn.Font = Enum.Font.SourceSans
		Btn.TextSize = 16

		Btn.MouseButton1Click:Connect(function()
			pcall(callback)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
			task.wait(0.1)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
		end)
	end

	function Window:Toggle(text, callback)
		local toggled = false
		
		local TogFrame = Instance.new("Frame")
		TogFrame.Parent = Container
		TogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TogFrame.Size = UDim2.new(1, -10, 0, 35)
		TogFrame.BorderSizePixel = 0
		
		local TogTitle = Instance.new("TextLabel")
		TogTitle.Parent = TogFrame
		TogTitle.Text = text
		TogTitle.Size = UDim2.new(0.7, 0, 1, 0)
		TogTitle.Position = UDim2.new(0, 10, 0, 0)
		TogTitle.BackgroundTransparency = 1
		TogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TogTitle.TextXAlignment = Enum.TextXAlignment.Left
		TogTitle.Font = Enum.Font.SourceSans
		TogTitle.TextSize = 16
		
		local Indicator = Instance.new("Frame")
		Indicator.Parent = TogFrame
		Indicator.Size = UDim2.new(0, 25, 0, 25)
		Indicator.Position = UDim2.new(1, -35, 0.5, -12)
		Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		Indicator.BorderSizePixel = 0
		
		local Trigger = Instance.new("TextButton")
		Trigger.Parent = TogFrame
		Trigger.Size = UDim2.new(1, 0, 1, 0)
		Trigger.BackgroundTransparency = 1
		Trigger.Text = ""
		
		Trigger.MouseButton1Click:Connect(function()
			toggled = not toggled
			pcall(callback, toggled)
			
			if toggled then
				tween(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 255, 50)})
			else
				tween(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)})
			end
		end)
	end

	function Window:Slider(text, min, max, callback)
		local SlideFrame = Instance.new("Frame")
		SlideFrame.Parent = Container
		SlideFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		SlideFrame.Size = UDim2.new(1, -10, 0, 50)
		SlideFrame.BorderSizePixel = 0
		
		local SlideTitle = Instance.new("TextLabel")
		SlideTitle.Parent = SlideFrame
		SlideTitle.Text = text
		SlideTitle.Size = UDim2.new(1, 0, 0, 25)
		SlideTitle.BackgroundTransparency = 1
		SlideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SlideTitle.Font = Enum.Font.SourceSans
		SlideTitle.TextSize = 16
		
		local SliderBar = Instance.new("Frame")
		SliderBar.Parent = SlideFrame
		SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		SliderBar.Size = UDim2.new(0.9, 0, 0, 10)
		SliderBar.Position = UDim2.new(0.05, 0, 0.7, -5)
		
		local SliderFill = Instance.new("Frame")
		SliderFill.Parent = SliderBar
		SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
		SliderFill.Size = UDim2.new(0, 0, 1, 0)
		
		local SlideBtn = Instance.new("TextButton")
		SlideBtn.Parent = SliderBar
		SlideBtn.Size = UDim2.new(1, 0, 1, 0)
		SlideBtn.BackgroundTransparency = 1
		SlideBtn.Text = ""
		
		local dragging = false
		
		local function update(input)
			local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
			tween(SliderFill, TweenInfo.new(0.1), {Size = pos})
			
			local val = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
			pcall(callback, val)
			SlideTitle.Text = text .. ": " .. tostring(val)
		end
		
		SlideBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				update(input)
			end
		end)
		
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				update(input)
			end
		end)
	end

	return Window
end

return Xonix
