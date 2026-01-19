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
	MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -415, 0.5, -202)
	MainFrame.Size = UDim2.new(0, 831, 0, 405)
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

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
	UserLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	UserLabel.BackgroundTransparency = 1
	UserLabel.Position = UDim2.new(0, 75, 0, 15)
	UserLabel.Size = UDim2.new(0, 200, 0, 35)
	UserLabel.Font = Enum.Font.GothamBold
	UserLabel.TextSize = 16
	UserLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	UserLabel.Text = LocalPlayer.Name

	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.Parent = MainFrame
	AvatarImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Position = UDim2.new(0, 15, 0, 10)
	AvatarImage.Size = UDim2.new(0, 45, 0, 45)
	
	local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	AvatarImage.Image = content
	
	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = AvatarImage

	local ConsoleFrame = Instance.new("Frame")
	ConsoleFrame.Name = "workspacee"
	ConsoleFrame.Parent = MainFrame
	ConsoleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	ConsoleFrame.BorderSizePixel = 0
	ConsoleFrame.Position = UDim2.new(0, 15, 0, 65)
	ConsoleFrame.Size = UDim2.new(0, 283, 0, 325)
	
	local ConsoleCorner = Instance.new("UICorner")
	ConsoleCorner.CornerRadius = UDim.new(0, 6)
	ConsoleCorner.Parent = ConsoleFrame

	local Container = Instance.new("ScrollingFrame")
	Container.Name = "ElementsContainer"
	Container.Parent = MainFrame
	Container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 310, 0, 65)
	Container.Size = UDim2.new(0, 505, 0, 325)
	Container.ScrollBarThickness = 3
	Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
	
	local UIList = Instance.new("UIListLayout")
	UIList.Parent = Container
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 8)

	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
	end)

	function Window:Button(text, callback)
		local BtnFrame = Instance.new("Frame")
		BtnFrame.Parent = Container
		BtnFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		BtnFrame.Size = UDim2.new(1, -5, 0, 40)
		BtnFrame.BorderSizePixel = 0
		
		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = BtnFrame
		
		local BtnStroke = Instance.new("UIStroke")
		BtnStroke.Parent = BtnFrame
		BtnStroke.Thickness = 1
		BtnStroke.Color = Color3.fromRGB(60, 60, 60)
		BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		local Btn = Instance.new("TextButton")
		Btn.Parent = BtnFrame
		Btn.Size = UDim2.new(1, 0, 1, 0)
		Btn.BackgroundTransparency = 1
		Btn.Text = text
		Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		Btn.Font = Enum.Font.GothamMedium
		Btn.TextSize = 14

		Btn.MouseButton1Click:Connect(function()
			pcall(callback)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
			task.wait(0.1)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
		end)
	end

	function Window:Toggle(text, callback)
		local toggled = false
		
		local TogFrame = Instance.new("Frame")
		TogFrame.Parent = Container
		TogFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		TogFrame.Size = UDim2.new(1, -5, 0, 40)
		TogFrame.BorderSizePixel = 0
		
		local TogCorner = Instance.new("UICorner")
		TogCorner.CornerRadius = UDim.new(0, 6)
		TogCorner.Parent = TogFrame
		
		local TogStroke = Instance.new("UIStroke")
		TogStroke.Parent = TogFrame
		TogStroke.Thickness = 1
		TogStroke.Color = Color3.fromRGB(60, 60, 60)
		
		local TogTitle = Instance.new("TextLabel")
		TogTitle.Parent = TogFrame
		TogTitle.Text = text
		TogTitle.Size = UDim2.new(0.7, 0, 1, 0)
		TogTitle.Position = UDim2.new(0, 12, 0, 0)
		TogTitle.BackgroundTransparency = 1
		TogTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
		TogTitle.TextXAlignment = Enum.TextXAlignment.Left
		TogTitle.Font = Enum.Font.GothamMedium
		TogTitle.TextSize = 14
		
		local IndicatorOuter = Instance.new("Frame")
		IndicatorOuter.Parent = TogFrame
		IndicatorOuter.Size = UDim2.new(0, 40, 0, 20)
		IndicatorOuter.Position = UDim2.new(1, -50, 0.5, -10)
		IndicatorOuter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		
		local IndCorner = Instance.new("UICorner")
		IndCorner.CornerRadius = UDim.new(1, 0)
		IndCorner.Parent = IndicatorOuter
		
		local IndicatorInner = Instance.new("Frame")
		IndicatorInner.Parent = IndicatorOuter
		IndicatorInner.Size = UDim2.new(0, 16, 0, 16)
		IndicatorInner.Position = UDim2.new(0, 2, 0.5, -8)
		IndicatorInner.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		
		local IndInCorner = Instance.new("UICorner")
		IndInCorner.CornerRadius = UDim.new(1, 0)
		IndInCorner.Parent = IndicatorInner
		
		local Trigger = Instance.new("TextButton")
		Trigger.Parent = TogFrame
		Trigger.Size = UDim2.new(1, 0, 1, 0)
		Trigger.BackgroundTransparency = 1
		Trigger.Text = ""
		
		Trigger.MouseButton1Click:Connect(function()
			toggled = not toggled
			pcall(callback, toggled)
			
			if toggled then
				tween(IndicatorOuter, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)})
				tween(IndicatorInner, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
			else
				tween(IndicatorOuter, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
				tween(IndicatorInner, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)})
			end
		end)
	end

	function Window:Slider(text, min, max, callback)
		local SlideFrame = Instance.new("Frame")
		SlideFrame.Parent = Container
		SlideFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		SlideFrame.Size = UDim2.new(1, -5, 0, 55)
		SlideFrame.BorderSizePixel = 0
		
		local SlideCorner = Instance.new("UICorner")
		SlideCorner.CornerRadius = UDim.new(0, 6)
		SlideCorner.Parent = SlideFrame
		
		local SlideStroke = Instance.new("UIStroke")
		SlideStroke.Parent = SlideFrame
		SlideStroke.Thickness = 1
		SlideStroke.Color = Color3.fromRGB(60, 60, 60)
		
		local SlideTitle = Instance.new("TextLabel")
		SlideTitle.Parent = SlideFrame
		SlideTitle.Text = text
		SlideTitle.Size = UDim2.new(1, 0, 0, 25)
		SlideTitle.Position = UDim2.new(0, 12, 0, 0)
		SlideTitle.BackgroundTransparency = 1
		SlideTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
		SlideTitle.TextXAlignment = Enum.TextXAlignment.Left
		SlideTitle.Font = Enum.Font.GothamMedium
		SlideTitle.TextSize = 14
		
		local ValueLabel = Instance.new("TextLabel")
		ValueLabel.Parent = SlideFrame
		ValueLabel.Text = tostring(min)
		ValueLabel.Size = UDim2.new(0, 50, 0, 25)
		ValueLabel.Position = UDim2.new(1, -60, 0, 0)
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ValueLabel.Font = Enum.Font.Gotham
		ValueLabel.TextSize = 13
		
		local SliderBar = Instance.new("Frame")
		SliderBar.Parent = SlideFrame
		SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		SliderBar.Size = UDim2.new(1, -24, 0, 6)
		SliderBar.Position = UDim2.new(0, 12, 0, 35)
		
		local BarCorner = Instance.new("UICorner")
		BarCorner.CornerRadius = UDim.new(1, 0)
		BarCorner.Parent = SliderBar
		
		local SliderFill = Instance.new("Frame")
		SliderFill.Parent = SliderBar
		SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		SliderFill.Size = UDim2.new(0, 0, 1, 0)
		
		local FillCorner = Instance.new("UICorner")
		FillCorner.CornerRadius = UDim.new(1, 0)
		FillCorner.Parent = SliderFill
		
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
			ValueLabel.Text = tostring(val)
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
