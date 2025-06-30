-- NeoUI.lua
local NeoUI = {}
NeoUI.__index = NeoUI

-- 创建主屏幕GUI
function NeoUI:CreateScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeoUIScreen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return ScreenGui
end

-- 创建主窗口
function NeoUI:CreateWindow(title)
    local ScreenGui = self:CreateScreenGui()
    
    -- 主容器
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "NeoWindow"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- 玻璃效果
    local GlassEffect = Instance.new("Frame")
    GlassEffect.Name = "GlassEffect"
    GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassEffect.BackgroundTransparency = 0.95
    GlassEffect.Size = UDim2.new(1, 0, 1, 0)
    GlassEffect.ZIndex = -1
    GlassEffect.Parent = MainFrame
    
    -- 标题栏
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
    TitleBar.Parent = MainFrame
    
    -- 标题文本
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = title or "NeoUI"
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- 关闭按钮
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 22
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 230)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0.1, 0, 1, 0)
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.Parent = TitleBar
    
    -- 内容容器
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, -20, 0.85, 0)
    ContentFrame.Position = UDim2.new(0, 10, 0.15, 0)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    ContentFrame.Parent = MainFrame
    
    -- 自动布局
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ContentFrame
    
    -- 添加圆角
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.04, 0)
    UICorner.Parent = MainFrame
    
    -- 添加阴影
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Image = "rbxassetid://5234388159"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.8
    DropShadow.BackgroundTransparency = 1
    DropShadow.Size = UDim2.new(1, 24, 1, 24)
    DropShadow.Position = UDim2.new(0, -12, 0, -12)
    DropShadow.ZIndex = -1
    DropShadow.Parent = MainFrame
    
    -- 拖动功能
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- 关闭按钮功能
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- 窗口对象
    local Window = {}
    
    -- 创建标签页
    function Window:CreateTab(name)
        local Tab = {}
        
        -- 标签按钮
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."TabButton"
        TabButton.Text = name
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 220)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TabButton.Size = UDim2.new(0.2, 0, 0.9, 0)
        TabButton.Position = UDim2.new(0.1 + (#TitleBar:GetChildren() - 3) * 0.2, 0, 0.05, 0)
        TabButton.Parent = TitleBar
        
        -- 标签内容
        local TabFrame = Instance.new("Frame")
        TabFrame.Name = name.."Tab"
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.Parent = ContentFrame
        
        -- 标签自动布局
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 15)
        TabLayout.Parent = TabFrame
        
        -- 标签选择逻辑
        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            TabFrame.Visible = true
        end)
        
        -- 默认显示第一个标签
        if #TitleBar:GetChildren() == 3 then -- 第一个标签
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        end
        
        -- 标签按钮样式
        TabButton.MouseEnter:Connect(function()
            if not TabFrame.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabFrame.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(TitleBar:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= CloseButton then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        end)
        
        -- 创建按钮
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Text = text
            Button.Font = Enum.Font.GothamMedium
            Button.TextSize = 14
            Button.TextColor3 = Color3.fromRGB(220, 220, 255)
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(0.9, 0, 0, 30)
            Button.Position = UDim2.new(0.05, 0, 0, 0)
            Button.Parent = TabFrame
            
            -- 按钮圆角
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0.2, 0)
            ButtonCorner.Parent = Button
            
            -- 按钮悬停效果
            Button.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(
                    Button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(70, 70, 100)}
                ):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(
                    Button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}
                ):Play()
            end)
            
            -- 按钮点击效果
            Button.MouseButton1Down:Connect(function()
                game:GetService("TweenService"):Create(
                    Button,
                    TweenInfo.new(0.1),
                    {BackgroundColor3 = Color3.fromRGB(90, 90, 130)}
                ):Play()
            end)
            
            Button.MouseButton1Up:Connect(function()
                game:GetService("TweenService"):Create(
                    Button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(70, 70, 100)}
                ):Play()
            end)
            
            -- 按钮回调
            Button.MouseButton1Click:Connect(callback)
            
            -- 更新内容尺寸
            TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
            end)
            
            return Button
        end
        
        -- 创建开关
        function Tab:CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text.."Toggle"
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
            ToggleFrame.Position = UDim2.new(0.05, 0, 0, 0)
            ToggleFrame.Parent = TabFrame
            
            -- 标签文本
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Text = text
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            -- 开关背景
            local ToggleBG = Instance.new("Frame")
            ToggleBG.Name = "ToggleBG"
            ToggleBG.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            ToggleBG.Size = UDim2.new(0.2, 0, 0.6, 0)
            ToggleBG.Position = UDim2.new(0.75, 0, 0.2, 0)
            ToggleBG.Parent = ToggleFrame
            
            -- 开关圆角
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0.5, 0)
            ToggleCorner.Parent = ToggleBG
            
            -- 开关滑块
            local ToggleSlider = Instance.new("Frame")
            ToggleSlider.Name = "Slider"
            ToggleSlider.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
            ToggleSlider.Size = UDim2.new(0.45, 0, 0.9, 0)
            ToggleSlider.Position = default and UDim2.new(0.55, 0, 0.05, 0) or UDim2.new(0, 0, 0.05, 0)
            ToggleSlider.Parent = ToggleBG
            
            -- 滑块圆角
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0.5, 0)
            SliderCorner.Parent = ToggleSlider
            
            -- 开关状态
            local state = default or false
            
            -- 切换函数
            local function ToggleState()
                state = not state
                if state then
                    game:GetService("TweenService"):Create(
                        ToggleSlider,
                        TweenInfo.new(0.2),
                        {Position = UDim2.new(0.55, 0, 0.05, 0)}
                    ):Play()
                    ToggleBG.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
                else
                    game:GetService("TweenService"):Create(
                        ToggleSlider,
                        TweenInfo.new(0.2),
                        {Position = UDim2.new(0, 0, 0.05, 0)}
                    ):Play()
                    ToggleBG.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
                callback(state)
            end
            
            -- 初始化状态
            if state then
                ToggleBG.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
            end
            
            -- 点击切换
            ToggleBG.MouseButton1Click:Connect(ToggleState)
            
            -- 更新内容尺寸
            TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
            end)
            
            return {
                SetState = function(newState)
                    if state ~= newState then
                        ToggleState()
                    end
                end,
                GetState = function()
                    return state
                end
            }
        end
        
        -- 创建滑块
        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text.."Slider"
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
            SliderFrame.Position = UDim2.new(0.05, 0, 0, 0)
            SliderFrame.Parent = TabFrame
            
            -- 标签文本
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.Text = text
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Size = UDim2.new(1, 0, 0.4, 0)
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            -- 值显示
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.Text = tostring(default)
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextSize = 14
            ValueLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
            ValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame
            
            -- 滑块背景
            local SliderBG = Instance.new("Frame")
            SliderBG.Name = "SliderBG"
            SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            SliderBG.Size = UDim2.new(1, 0, 0.3, 0)
            SliderBG.Position = UDim2.new(0, 0, 0.6, 0)
            SliderBG.Parent = SliderFrame
            
            -- 滑块圆角
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0.5, 0)
            SliderCorner.Parent = SliderBG
            
            -- 滑块填充
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBG
            
            -- 填充圆角
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0.5, 0)
            FillCorner.Parent = SliderFill
            
            -- 滑块按钮
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Text = ""
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.ZIndex = 2
            SliderButton.Parent = SliderBG
            
            -- 滑块值
            local value = math.clamp(default, min, max)
            
            -- 更新滑块
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                value = math.floor(min + (max - min) * pos.X.Scale)
                ValueLabel.Text = tostring(value)
                callback(value)
            end
            
            -- 拖动逻辑
            SliderButton.MouseButton1Down:Connect(function()
                UpdateSlider(game:GetService("UserInputService"):GetMouseLocation())
                local move
                move = game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                local release
                release = game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        release:Disconnect()
                    end
                end)
            end)
            
            -- 更新内容尺寸
            TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
            end)
            
            return {
                SetValue = function(newValue)
                    newValue = math.clamp(newValue, min, max)
                    value = newValue
                    SliderFill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
                    ValueLabel.Text = tostring(newValue)
                    callback(newValue)
                end,
                GetValue = function()
                    return value
                end
            }
        end
        
        return Tab
    end
    
    return Window
end

return NeoUI