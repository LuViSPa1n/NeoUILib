-- Aurora UI Library v2.0
local Aurora = {}
Aurora.__index = Aurora

-- 核心设计系统
local DesignSystem = {
    Primary = Color3.fromRGB(138, 180, 248),  -- 主色：柔和蓝
    Surface = Color3.fromRGB(28, 28, 36),     -- 背景：深空灰
    OnSurface = Color3.fromRGB(240, 243, 249),-- 文字：浅灰白
    GlassAlpha = 0.92,                        -- 玻璃透明度
    BlurRadius = 24,                          -- 背景模糊度
    CornerRadius = UDim.new(0.28, 0),         -- 超大圆角
    Elevation = {
        DropShadow = Color3.fromRGB(15, 25, 45), -- 投影色
        Offset = Vector2.new(0, 4)               -- 投影偏移
    }
}

-- 创建动态模糊背景
local function createBlurBackground(parent)
    local Blur = Instance.new("BlurEffect")
    Blur.Name = "AuroraBlur"
    Blur.Size = DesignSystem.BlurRadius
    Blur.Parent = parent
    
    local Glass = Instance.new("Frame")
    Glass.BackgroundColor3 = DesignSystem.Surface
    Glass.BackgroundTransparency = DesignSystem.GlassAlpha
    Glass.Size = UDim2.new(1, 0, 1, 0)
    Glass.ZIndex = -1
    
    -- 渐变边缘处理
    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 90
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.2, 0.85),
        NumberSequenceKeypoint.new(1, 1)
    })
    Glass.BackgroundTransparency = 1
    Glass.UIGradient = Gradient
    
    Glass.Parent = parent
    return Glass
end

-- 动态色彩生成器
function Aurora:GenerateDynamicColor(baseColor, elevation)
    local h, s, v = baseColor:ToHSV()
    return Color3.fromHSV(h, s * 0.8, math.clamp(v * (1 + elevation*0.08), 0, 0.95))
end

-- 创建主窗口
function Aurora:CreateWindow(title, iconId)
    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AuroraUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    -- 主容器（居中显示）
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.32, 0, 0.45, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    -- 应用背景模糊
    createBlurBackground(MainFrame)

    -- 标题栏（带聚光灯效果）
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
    Icon.Image = "rbxassetid://"..(iconId or "14308089379")
    Icon.Size = UDim2.new(0.12, 0, 0.7, 0)
    Icon.Position = UDim2.new(0.03, 0, 0.15, 0)
    Icon.BackgroundTransparency = 1
    Icon.Parent = TitleGroup

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title or "AURORA UI"
    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = DesignSystem.OnSurface
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.15, 0, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleGroup

    -- 动态标题下划线
    local TitleUnderline = Instance.new("Frame")
    TitleUnderline.Size = UDim2.new(0.25, 0, 0.08, 0)
    TitleUnderline.Position = UDim2.new(0.03, 0, 0.98, 0)
    TitleUnderline.BackgroundColor3 = DesignSystem.Primary
    TitleUnderline.Parent = TitleBar

    -- 交互控制按钮组
    local ControlGroup = Instance.new("Frame")
    ControlGroup.BackgroundTransparency = 1
    ControlGroup.Size = UDim2.new(0.3, 0, 1, 0)
    ControlGroup.Position = UDim2.new(0.7, 0, 0, 0)
    ControlGroup.Parent = TitleBar

    -- 最小化按钮
    local MinimizeBtn = self:CreateControlButton("─", ControlGroup, 0.3)
    -- 关闭按钮
    local CloseBtn = self:CreateControlButton("✕", ControlGroup, 0.6)

    -- 内容区域（带弹性滚动）
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.ScrollBarImageColor3 = DesignSystem.Primary
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Size = UDim2.new(1, -20, 0.85, 0)
    ContentFrame.Position = UDim2.new(0, 10, 0.15, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- 动态圆角（仅底部）
    self:ApplyDynamicCorners(MainFrame)

    -- 窗口拖拽逻辑
    self:SetupWindowDragging(TitleBar, MainFrame)

    -- 按钮交互
    CloseBtn.MouseButton1Click:Connect(function()
        game:GetService("TweenService"):Create(
            ScreenGui,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0,0,0,0)}
        ):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        local targetSize = ContentFrame.Visible and UDim2.new(0.32,0,0.09,0) or UDim2.new(0.32,0,0.45,0)
        ContentFrame.Visible = not ContentFrame.Visible
        game:GetService("TweenService"):Create(
            MainFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back),
            {Size = targetSize}
        ):Play()
    end)

    -- 返回窗口对象
    return {
        ScreenGui = ScreenGui,
        ContentFrame = ContentFrame,
        CreateTab = function() 
            -- 标签页实现（略）
        end
    }
end

-- 创建控制按钮（带悬停动效）
function Aurora:CreateControlButton(symbol, parent, xPos)
    local btn = Instance.new("TextButton")
    btn.Text = symbol
    btn.FontFace = Font.new("rbxasset://fonts/families/Arial.json")
    btn.TextSize = 18
    btn.TextColor3 = DesignSystem.OnSurface
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(0.3, 0, 0.7, 0)
    btn.Position = UDim2.new(xPos, 0, 0.15, 0)
    btn.Parent = parent

    -- 悬停光效
    btn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.2),
            {TextColor3 = DesignSystem.Primary}
        ):Play()
    end)

    btn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.3),
            {TextColor3 = DesignSystem.OnSurface}
        ):Play()
    end)

    return btn
end

-- 动态圆角生成（仅底部直角）
function Aurora:ApplyDynamicCorners(frame)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = DesignSystem.CornerRadius
    corner.Parent = frame

    -- 顶部直角覆盖
    local topMask = Instance.new("Frame")
    topMask.Size = UDim2.new(1, 0, 0.05, 0)
    topMask.Position = UDim2.new(0, 0, 0, 0)
    topMask.BackgroundColor3 = DesignSystem.Surface
    topMask.BorderSizePixel = 0
    topMask.ZIndex = 10
    topMask.Parent = frame
end

return Aurora