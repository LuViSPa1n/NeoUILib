-- Aurora UI Library v3.0 (稳定版)
local Aurora = {}
Aurora.__index = Aurora

-- 核心设计系统
local DesignSystem = {
    Primary = Color3.fromRGB(138, 180, 248),  -- 主色：柔和蓝
    Surface = Color3.fromRGB(28, 28, 36),     -- 背景：深空灰
    OnSurface = Color3.fromRGB(240, 243, 249),-- 文字：浅灰白
    GlassAlpha = 0.92,                        -- 玻璃透明度
    CornerRadius = UDim.new(0.28, 0),         -- 超大圆角
    Elevation = {
        DropShadow = Color3.fromRGB(15, 25, 45), -- 投影色
        Offset = Vector2.new(0, 4)               -- 投影偏移
    }
}

-- 创建玻璃背景 (修复版)
local function createGlassBackground(parent)
    local Glass = Instance.new("Frame")
    Glass.Name = "GlassBackground"
    Glass.BackgroundColor3 = DesignSystem.Surface
    Glass.BackgroundTransparency = DesignSystem.GlassAlpha
    Glass.Size = UDim2.new(1, 0, 1, 0)
    Glass.ZIndex = -1
    Glass.Parent = parent
    
    -- 添加圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = DesignSystem.CornerRadius
    corner.Parent = Glass
    
    -- 创建渐变效果 (正确方式)
    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 90
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.2, 0.85),
        NumberSequenceKeypoint.new(1, 1)
    })
    Gradient.Parent = Glass
    
    return Glass
end

-- 创建主窗口
function Aurora:CreateWindow(title, iconId)
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AuroraUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- 主容器（居中显示）
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.32, 0, 0.45, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    -- 应用玻璃背景
    createGlassBackground(MainFrame)

    -- 标题栏
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0.09, 0)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    -- 图标+标题组合
    local TitleGroup = Instance.new("Frame")
    TitleGroup.BackgroundTransparency = 1
    TitleGroup.Size = UDim2.new(0.7, 0, 1, 0)
    TitleGroup.Parent = TitleBar

    local Icon = Instance.new("ImageLabel")
    Icon.Image = "rbxassetid://"..(iconId or "14308089379") -- 默认图标
    Icon.Size = UDim2.new(0.12, 0, 0.7, 0)
    Icon.Position = UDim2.new(0.03, 0, 0.15, 0)
    Icon.BackgroundTransparency = 1
    Icon.Parent = TitleGroup

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title or "AURORA UI"
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = DesignSystem.OnSurface
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.15, 0, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleGroup

    -- 标题下划线
    local TitleUnderline = Instance.new("Frame")
    TitleUnderline.Size = UDim2.new(0.25, 0, 0.08, 0)
    TitleUnderline.Position = UDim2.new(0.03, 0, 0.98, 0)
    TitleUnderline.BackgroundColor3 = DesignSystem.Primary
    
    -- 为下划线添加圆角
    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(0.5, 0)
    underlineCorner.Parent = TitleUnderline
    
    TitleUnderline.Parent = TitleBar

    -- 控制按钮组
    local ControlGroup = Instance.new("Frame")
    ControlGroup.BackgroundTransparency = 1
    ControlGroup.Size = UDim2.new(0.3, 0, 1, 0)
    ControlGroup.Position = UDim2.new(0.7, 0, 0, 0)
    ControlGroup.Parent = TitleBar

    -- 最小化按钮
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Text = "─"
    MinimizeBtn.Font = Enum.Font.GothamMedium
    MinimizeBtn.TextSize = 18
    MinimizeBtn.TextColor3 = DesignSystem.OnSurface
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
    MinimizeBtn.Position = UDim2.new(0.3, 0, 0.15, 0)
    MinimizeBtn.Parent = ControlGroup

    -- 关闭按钮
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.TextSize = 18
    CloseBtn.TextColor3 = DesignSystem.OnSurface
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
    CloseBtn.Position = UDim2.new(0.6, 0, 0.15, 0)
    CloseBtn.Parent = ControlGroup

    -- 内容区域
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.ScrollBarImageColor3 = DesignSystem.Primary
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Size = UDim2.new(1, -20, 0.85, 0)
    ContentFrame.Position = UDim2.new(0, 10, 0.15, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- 内容布局
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 15)
    ContentLayout.Parent = ContentFrame

    -- 窗口拖拽功能
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
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

    -- 按钮悬停效果
    MinimizeBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            MinimizeBtn,
            TweenInfo.new(0.2),
            {TextColor3 = DesignSystem.Primary}
        ):Play()
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            MinimizeBtn,
            TweenInfo.new(0.3),
            {TextColor3 = DesignSystem.OnSurface}
        ):Play()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            CloseBtn,
            TweenInfo.new(0.2),
            {TextColor3 = Color3.fromRGB(255, 100, 100)}
        ):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            CloseBtn,
            TweenInfo.new(0.3),
            {TextColor3 = DesignSystem.OnSurface}
        ):Play()
    end)

    -- 按钮功能
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        ContentFrame.Visible = not ContentFrame.Visible
    end)

    -- 返回窗口对象
    local Window = {}
    
    -- 创建标签页功能
    function Window:CreateTab(name)
        local Tab = {}
        
        -- 标签按钮
        local TabButton = Instance.new("TextButton")
        TabButton.Text = name
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.TextColor3 = DesignSystem.OnSurface
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
        
        -- 标签布局
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
            TabButton.BackgroundColor3 = DesignSystem.Primary
        end
        
        -- 标签按钮样式
        TabButton.MouseEnter:Connect(function()
            if not TabFrame.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabFrame.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(TitleBar:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= MinimizeBtn and btn ~= CloseBtn then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
            end
            TabButton.BackgroundColor3 = DesignSystem.Primary
        end)
        
        -- 创建按钮
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Text = text
            Button.Font = Enum.Font.GothamMedium
            Button.TextSize = 14
            Button.TextColor3 = DesignSystem.OnSurface
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(0.9, 0, 0, 40)
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
                    {BackgroundColor3 = DesignSystem.Primary}
                ):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(
                    Button,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}
                ):Play()
            end)
            
            -- 按钮回调
            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end
        
        return Tab
    end
    
    return Window
end

return Aurora