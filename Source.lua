local Xonix = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- // 1. SINGLETON PATTERN (Removes old instance)
if CoreGui:FindFirstChild("XonixUI") then
	CoreGui.XonixUI:Destroy()
end

local function tween(object, info, goals)
	TweenService:Create(object, info, goals):Play()
end

function Xonix:Create(titleName)
	local Window = {}
	local Elements = {}
	local UI_Open = true
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "XonixUI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- // MAIN FRAME
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -415, 0.5, -202)
	MainFrame.Size = UDim2.new(0, 831, 0, 405)
	
	-- // DRAGGING
	local dragging, dragInput, dragStart, startPos
	local dragSpeed = 0.12
	
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
			MainFrame.Position = MainFrame.Position:Lerp(targetPos, dragSpeed)
		end
	end)

	-- // UI TOGGLE ANIMATION (RightControl)
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightControl then
			UI_Open = not UI_Open
			if UI_Open then
				MainFrame.Visible = true
				tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 831, 0, 405), BackgroundTransparency = 0})
				for _, v in pairs(MainFrame:GetDescendants()) do
					if v:IsA("GuiObject") then tween(v, TweenInfo.new(0.3), {BackgroundTransparency = v.Name == "Shadow" and 1 or (v.BackgroundTransparency == 1 and 1 or v.BackgroundColor3 == Color3.fromRGB(18,18,18) and 0 or 0), GroupTransparency = 0}) end
					if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then tween(v, TweenInfo.new(0.3), {TextTransparency = 0}) end
				end
			else
				tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 831, 0, 0), BackgroundTransparency = 1})
				for _, v in pairs(MainFrame:GetDescendants()) do
					if v:IsA("GuiObject") then tween(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}) end
					if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then tween(v, TweenInfo.new(0.3), {TextTransparency = 1}) end
				end
				task.wait(0.3)
				if not UI_Open then MainFrame.Visible = false end
			end
		end
	end)

	-- // CONSOLE (Moved to Top Left)
	local ConsoleFrame = Instance.new("Frame")
	ConsoleFrame.Name = "workspacee"
	ConsoleFrame.Parent = MainFrame
	ConsoleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ConsoleFrame.BorderSizePixel = 0
	ConsoleFrame.Position = UDim2.new(0, 15, 0, 15) -- ROOF
	ConsoleFrame.Size = UDim2.new(0, 283, 0, 325)
	
	local ConsoleCorner = Instance.new("UICorner")
	ConsoleCorner.CornerRadius = UDim.new(0, 4)
	ConsoleCorner.Parent = ConsoleFrame

	-- // PROFILE (Moved to Bottom Left)
	local ProfileContainer = Instance.new("Frame")
	ProfileContainer.Name = "ProfileContainer"
	ProfileContainer.Parent = MainFrame
	ProfileContainer.BackgroundTransparency = 1
	ProfileContainer.Position = UDim2.new(0, 15, 1, -60) -- BOTTOM
	ProfileContainer.Size = UDim2.new(0, 283, 0, 50)

	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.Parent = ProfileContainer
	AvatarImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Position = UDim2.new(0, 0, 0, 2)
	AvatarImage.Size = UDim2.new(0, 45, 0, 45)
	
	local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	AvatarImage.Image = content
	
	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = AvatarImage

	local UserLabel = Instance.new("TextLabel")
	UserLabel.Parent = ProfileContainer
	UserLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	UserLabel.BackgroundTransparency = 1
	UserLabel.Position = UDim2.new(0, 55, 0, 2)
	UserLabel.Size = UDim2.new(0, 200, 0, 45)
	UserLabel.Font = Enum.Font.GothamMedium
	UserLabel.TextSize = 14
	UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	UserLabel.Text = LocalPlayer.Name

	-- // SEARCH BAR (Moved to Top Right)
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = MainFrame
	SearchFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	SearchFrame.Position = UDim2.new(0, 310, 0, 15) -- ROOF
	SearchFrame.Size = UDim2.new(0, 505, 0, 30)
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

	-- // CONTAINER (Under Search)
	local Container = Instance.new("ScrollingFrame")
	Container.Name = "ElementsContainer"
	Container.Parent = MainFrame
	Container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 310, 0, 50)
	Container.Size = UDim2.new(0, 505, 0, 340) -- Taller since it goes to bottom
	Container.ScrollBarThickness = 2
	Container.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
	
	local UIList = Instance.new("UIListLayout")
	UIList.Parent = Container
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 4)

	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 5)
	end)

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

	-- // ELEMENT FUNCTIONS
	
	function Window:Button(text, callback)
		local BtnFrame = Instance.new("Frame")
		BtnFrame.Parent = Container
		BtnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		BtnFrame.Size = UDim2.new(1, -5, 0, 32)
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
		TogFrame.Size = UDim2.new(1, -5, 0, 32)
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
		SlideFrame.Size = UDim2.new(1, -5, 0, 45)
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
		SliderBar.Size = UDim2.new(1, -20, 0, 4)
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
			tween(SliderFill, TweenInfo.new(0.05), {Size = pos})
			local val = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
			pcall(callback, val)
			ValueLabel.Text = tostring(val)
		end
		SlideBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
		end)
		table.insert(Elements, {Frame = SlideFrame, Text = text})
	end

	function Window:Keybind(text, defaultKey, callback)
		local KeybindFrame = Instance.new("Frame")
		KeybindFrame.Parent = Container
		KeybindFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		KeybindFrame.Size = UDim2.new(1, -5, 0, 32)
		KeybindFrame.BorderSizePixel = 0
		
		local KBCorner = Instance.new("UICorner")
		KBCorner.CornerRadius = UDim.new(0, 4)
		KBCorner.Parent = KeybindFrame
		
		local KBStroke = Instance.new("UIStroke")
		KBStroke.Parent = KeybindFrame
		KBStroke.Thickness = 1
		KBStroke.Color = Color3.fromRGB(40, 40, 40)
		
		local KBTitle = Instance.new("TextLabel")
		KBTitle.Parent = KeybindFrame
		KBTitle.Text = text
		KBTitle.Size = UDim2.new(0.7, 0, 1, 0)
		KBTitle.Position = UDim2.new(0, 10, 0, 0)
		KBTitle.BackgroundTransparency = 1
		KBTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
		KBTitle.TextXAlignment = Enum.TextXAlignment.Left
		KBTitle.Font = Enum.Font.Gotham
		KBTitle.TextSize = 13
		
		local BindBtn = Instance.new("TextButton")
		BindBtn.Parent = KeybindFrame
		BindBtn.Size = UDim2.new(0, 80, 0, 20)
		BindBtn.Position = UDim2.new(1, -90, 0.5, -10)
		BindBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		BindBtn.Text = defaultKey.Name
		BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
		BindBtn.Font = Enum.Font.Gotham
		BindBtn.TextSize = 12
		
		local BindCorner = Instance.new("UICorner")
		BindCorner.CornerRadius = UDim.new(0, 4)
		BindCorner.Parent = BindBtn
		
		local binding = false
		local currentKey = defaultKey
		
		BindBtn.MouseButton1Click:Connect(function()
			binding = true
			BindBtn.Text = "..."
			BindBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
		end)
		
		UserInputService.InputBegan:Connect(function(input)
			if binding then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					currentKey = input.KeyCode
					binding = false
					BindBtn.Text = currentKey.Name
					BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
				elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
					binding = false
					BindBtn.Text = currentKey.Name
					BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			elseif input.KeyCode == currentKey then
				pcall(callback)
			end
		end)
		
		table.insert(Elements, {Frame = KeybindFrame, Text = text})
	end

	return Window
end

return Xonix
