local Xonix = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function tween(object, info, goals)
	TweenService:Create(object, info, goals):Play()
end

function Xonix:Create(titleName)
	local Window = {}
	local Elements = {} -- To store elements for search functionality
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "XonixUI"
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- // MAIN FRAME
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -415, 0.5, -202)
	MainFrame.Size = UDim2.new(0, 831, 0, 405)
	
	-- // SMOOTH DRAG LOGIC
	local dragging, dragInput, dragStart, startPos
	local dragSpeed = 0.12 -- Lower = Slower/Smoother
	
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
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	
	RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			local targetPos = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			-- Lerp for the "Slow/Smooth" feel
			MainFrame.Position = MainFrame.Position:Lerp(targetPos, dragSpeed)
		end
	end)

	-- // USER INFO
	local UserLabel = Instance.new("TextLabel")
	UserLabel.Parent = MainFrame
	UserLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	UserLabel.BackgroundTransparency = 1
	UserLabel.Position = UDim2.new(0, 75, 0, 15)
	UserLabel.Size = UDim2.new(0, 200, 0, 35)
	UserLabel.Font = Enum.Font.GothamMedium
	UserLabel.TextSize = 14
	UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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

	-- // CONSOLE (WORKSPACE)
	local ConsoleFrame = Instance.new("Frame")
	ConsoleFrame.Name = "workspacee"
	ConsoleFrame.Parent = MainFrame
	ConsoleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ConsoleFrame.BorderSizePixel = 0
	ConsoleFrame.Position = UDim2.new(0, 15, 0, 65)
	ConsoleFrame.Size = UDim2.new(0, 283, 0, 325)
	
	local ConsoleCorner = Instance.new("UICorner")
	ConsoleCorner.CornerRadius = UDim.new(0, 4)
	ConsoleCorner.Parent = ConsoleFrame

	-- // SEARCH BAR
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = MainFrame
	SearchFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	SearchFrame.Position = UDim2.new(0, 310, 0, 65)
	SearchFrame.Size = UDim2.new(0, 505, 0, 30) -- Slim height
	SearchFrame.BorderSizePixel = 0
	
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 4)
	SearchCorner.Parent = SearchFrame
	
	local SearchBox = Instance.new("TextBox")
	SearchBox.Parent = SearchFrame
	SearchBox.Size = UDim2.new(1, -20, 1, 0)
	SearchBox.Position = UDim2.new(0, 10, 0, 0)
	SearchBox.BackgroundTransparency = 1
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.PlaceholderText = "Search scripts..."
	SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	SearchBox.TextSize = 13
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	-- // SCROLLING CONTAINER
	local Container = Instance.new("ScrollingFrame")
	Container.Name = "ElementsContainer"
	Container.Parent = MainFrame
	Container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 310, 0, 100) -- Moved down for search bar
	Container.Size = UDim2.new(0, 505, 0, 290)
	Container.ScrollBarThickness = 2
	Container.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
	
	local UIList = Instance.new("UIListLayout")
	UIList.Parent = Container
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 4) -- Slim padding

	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 5)
	end)

	-- Search Functionality
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local input = SearchBox.Text:lower()
		for _, item in pairs(Elements) do
			if input == "" or item.Text:lower():find(input) then
				item.Frame.Visible = true
			else
				item.Frame.Visible = false
			end
		end
	end)

	-- // ELEMENTS

	function Window:Button(text, callback)
		local BtnFrame = Instance.new("Frame")
		BtnFrame.Parent = Container
		BtnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		BtnFrame.Size = UDim2.new(1, -5, 0, 32) -- Slim height
		BtnFrame.BorderSizePixel = 0
		
		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 4)
		BtnCorner.Parent = BtnFrame
		
		local BtnStroke = Instance.new("UIStroke")
		BtnStroke.Parent = BtnFrame
		BtnStroke.Thickness = 1
		BtnStroke.Color = Color3.fromRGB(40, 40, 40)
		BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		local Btn = Instance.new("TextButton")
		Btn.Parent = BtnFrame
		Btn.Size = UDim2.new(1, 0, 1, 0)
		Btn.BackgroundTransparency = 1
		Btn.Text = text
		Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 13

		Btn.MouseButton1Click:Connect(function()
			pcall(callback)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
			task.wait(0.1)
			tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
		end)
		
		table.insert(Elements, {Frame = BtnFrame, Text = text})
	end

	function Window:Toggle(text, callback)
		local toggled = false
		
		local TogFrame = Instance.new("Frame")
		TogFrame.Parent = Container
		TogFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		TogFrame.Size = UDim2.new(1, -5, 0, 32) -- Slim height
		TogFrame.BorderSizePixel = 0
		
		local TogCorner = Instance.new("UICorner")
		TogCorner.CornerRadius = UDim.new(0, 4)
		TogCorner.Parent = TogFrame
		
		local TogStroke = Instance.new("UIStroke")
		TogStroke.Parent = TogFrame
		TogStroke.Thickness = 1
		TogStroke.Color = Color3.fromRGB(40, 40, 40)
		
		local TogTitle = Instance.new("TextLabel")
		TogTitle.Parent = TogFrame
		TogTitle.Text = text
		TogTitle.Size = UDim2.new(0.7, 0, 1, 0)
		TogTitle.Position = UDim2.new(0, 10, 0, 0)
		TogTitle.BackgroundTransparency = 1
		TogTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
		TogTitle.TextXAlignment = Enum.TextXAlignment.Left
		TogTitle.Font = Enum.Font.Gotham
		TogTitle.TextSize = 13
		
		-- Slim Indicator
		local IndicatorOuter = Instance.new("Frame")
		IndicatorOuter.Parent = TogFrame
		IndicatorOuter.Size = UDim2.new(0, 36, 0, 18)
		IndicatorOuter.Position = UDim2.new(1, -45, 0.5, -9)
		IndicatorOuter.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		
		local IndCorner = Instance.new("UICorner")
		IndCorner.CornerRadius = UDim.new(1, 0)
		IndCorner.Parent = IndicatorOuter
		
		local IndicatorInner = Instance.new("Frame")
		IndicatorInner.Parent = IndicatorOuter
		IndicatorInner.Size = UDim2.new(0, 14, 0, 14)
		IndicatorInner.Position = UDim2.new(0, 2, 0.5, -7)
		IndicatorInner.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		
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
				tween(IndicatorInner, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
			else
				tween(IndicatorOuter, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)})
				tween(IndicatorInner, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
			end
		end)
		
		table.insert(Elements, {Frame = TogFrame, Text = text})
	end

	function Window:Slider(text, min, max, callback)
		local SlideFrame = Instance.new("Frame")
		SlideFrame.Parent = Container
		SlideFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		SlideFrame.Size = UDim2.new(1, -5, 0, 45) -- Slim height
		SlideFrame.BorderSizePixel = 0
		
		local SlideCorner = Instance.new("UICorner")
		SlideCorner.CornerRadius = UDim.new(0, 4)
		SlideCorner.Parent = SlideFrame
		
		local SlideStroke = Instance.new("UIStroke")
		SlideStroke.Parent = SlideFrame
		SlideStroke.Thickness = 1
		SlideStroke.Color = Color3.fromRGB(40, 40, 40)
		
		local SlideTitle = Instance.new("TextLabel")
		SlideTitle.Parent = SlideFrame
		SlideTitle.Text = text
		SlideTitle.Size = UDim2.new(1, 0, 0, 20)
		SlideTitle.Position = UDim2.new(0, 10, 0, 2)
		SlideTitle.BackgroundTransparency = 1
		SlideTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
		SlideTitle.TextXAlignment = Enum.TextXAlignment.Left
		SlideTitle.Font = Enum.Font.Gotham
		SlideTitle.TextSize = 13
		
		local ValueLabel = Instance.new("TextLabel")
		ValueLabel.Parent = SlideFrame
		ValueLabel.Text = tostring(min)
		ValueLabel.Size = UDim2.new(0, 50, 0, 20)
		ValueLabel.Position = UDim2.new(1, -60, 0, 2)
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ValueLabel.Font = Enum.Font.Gotham
		ValueLabel.TextSize = 12
		
		local SliderBar = Instance.new("Frame")
		SliderBar.Parent = SlideFrame
		SliderBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		SliderBar.Size = UDim2.new(1, -20, 0, 4) -- Thinner bar
		SliderBar.Position = UDim2.new(0, 10, 0, 30)
		
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
			tween(SliderFill, TweenInfo.new(0.05), {Size = pos}) -- Faster response
			
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
		
		table.insert(Elements, {Frame = SlideFrame, Text = text})
	end

	return Window
end

return Xonix
