--[[ ============================================
  WindUI 纯净模板 — 只保留 UI 壳子，无功能逻辑
  用途：所有游戏通用，改品牌 + 填 Callback 即可
  ============================================ ]]

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- ============================================
-- 品牌配置（改这 4 行就行）
-- ============================================
local BRAND = {
    name    = "Lucky助手",
    version = "v0.1",
    author  = "Lucky",
    folder  = "LuckyHub",
    icon    = "zap",
    theme   = "Dark",
    accent  = "#FF6B35",
}

-- ============================================
-- 主窗口
-- ============================================
local Window = WindUI:CreateWindow({
    Title       = BRAND.name,
    Icon        = BRAND.icon,
    IconThemed  = true,
    Author      = BRAND.version,
    Folder      = BRAND.folder,
    Size        = UDim2.fromOffset(580, 440),
    Transparent = true,
    Theme       = BRAND.theme,
    HideSearchBar = false,
    Resizable   = true,
    SideBarWidth = 240,

    Search = {
        Enabled = true,
        Placeholder = "搜索...",
        Callback = function(text) end,
    },

    User = {
        Enabled = true,
        Callback = function()
            WindUI:Notify({
                Title    = "玩家信息",
                Content  = game.Players.LocalPlayer.Name,
                Duration = 2,
                Icon     = "user"
            })
        end,
    },
})

-- ============================================
-- 顶部主题切换按钮
-- ============================================
Window:CreateTopbarButton("ThemeToggle", "moon", function()
    local current = WindUI:GetCurrentTheme()
    if current == "Light" then
        WindUI:SetTheme("Dark")
        WindUI:Notify({ Title = "已切换暗黑主题", Duration = 2, Icon = "moon" })
    else
        WindUI:SetTheme("Light")
        WindUI:Notify({ Title = "已切换明亮主题", Duration = 2, Icon = "sun" })
    end
end, 990)

-- ============================================
-- 屏幕浮动打开按钮（小球）
-- ============================================
Window:EditOpenButton({
    Title           = BRAND.name,
    Icon            = BRAND.icon,
    CornerRadius    = UDim.new(0, 26),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("ADD8E6")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("4169E1")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("ADD8E6")),
    }),
    Draggable = true,
})

-- ============================================
-- 角标标签
-- ============================================
Window:Tag({
    Title = BRAND.name .. " " .. BRAND.version,
    Color = Color3.fromHex(BRAND.accent)
})

local timeTag = Window:Tag({
    Title = os.date("%H:%M:%S"),
    Color = Color3.fromHex("#00ffff")
})
task.spawn(function()
    while Window do
        task.wait(1)
        pcall(function() timeTag:SetTitle(os.date("%H:%M:%S")) end)
    end
end)

-- ============================================
-- 侧边栏分类
-- ============================================
local MainSection = Window:Section({ Title = "功能", Opened = true })

-- ============================================
-- Tab 页签（5 个空 Tab，以后按游戏填）
-- ============================================
local Tab1 = MainSection:Tab({ Title = "Tab1", Icon = "zap" })
local Tab2 = MainSection:Tab({ Title = "Tab2", Icon = "settings" })
local Tab3 = MainSection:Tab({ Title = "Tab3", Icon = "gift" })
local Tab4 = MainSection:Tab({ Title = "Tab4", Icon = "shopping-cart" })
local Tab5 = MainSection:Tab({ Title = "Tab5", Icon = "info" })
Tab1:Select()

-- ============================================
-- 空组件占位（以后删掉重写）
-- ============================================
Tab1:Paragraph({ Title = "功能1", Desc = "在这里写功能说明" })
Tab1:Toggle({ Title = "开关1", Default = false, Callback = function(state) end })
Tab1:Button({ Title = "按钮1", Callback = function() end })
Tab1:Input({ Title = "输入1", Callback = function(value) end })
Tab1:Slider({ Title = "滑动1", Min = 1, Max = 100, Default = 50, Callback = function(value) end })

Tab2:Paragraph({ Title = "功能2", Desc = "在这里写功能说明" })
Tab2:Toggle({ Title = "开关2", Default = false, Callback = function(state) end })

Tab3:Paragraph({ Title = "功能3", Desc = "在这里写功能说明" })
Tab3:Button({ Title = "按钮3", Callback = function() end })

Tab4:Paragraph({ Title = "功能4", Desc = "在这里写功能说明" })
Tab4:Toggle({ Title = "开关4", Default = false, Callback = function(state) end })

Tab5:Paragraph({ Title = "关于", Desc = BRAND.name .. " " .. BRAND.version .. "\n作者: " .. BRAND.author })
Tab5:Button({ Title = "关闭脚本", Variant = "Destructive", Callback = function() Window:Destroy() end })

-- ============================================
-- Anti-AFK
-- ============================================
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

print("[" .. BRAND.name .. "] UI 纯净模板已加载 ✅")

--[[ ============================================
  使用方式：
  1. 复制这个文件
  2. 改 BRAND 表里的 name/version
  3. 改 Tab 标题和图标
  4. 在 Callback 里填游戏功能逻辑
  5. 删掉不需要的占位组件
  ============================================ ]]
