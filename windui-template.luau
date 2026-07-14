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
-- 工具函数（PVX 通用）
-- ============================================
local R = game:GetService("ReplicatedStorage")
local P = require(R:WaitForChild("Paper"))
local function S(n) local ok, v = pcall(P.Stats.GetValue, n) return ok and v or 0 end
local function F(c, ...) return P.Network.InvokeServer(c, ...) end

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
-- Tab 页签
-- ============================================
local Tab1 = MainSection:Tab({ Title = "鸡场 🐣", Icon = "zap" })
local Tab2 = MainSection:Tab({ Title = "设置", Icon = "settings" })
local Tab3 = MainSection:Tab({ Title = "关于", Icon = "info" })
Tab1:Select()

-- ============================================
-- 鸡场 🐣 自动采集
-- ============================================
local St = { run = false }

local function StopAll()
    St.run = false
    _G.LCF_THREAD = nil
end

local function StartLoop()
    if _G.LCF_THREAD then return end
    St.run = true
    _G.LCF_THREAD = task.spawn(function()
        task.wait(1)
        while St.run do
            if St.eggs then
                local eggs = workspace:FindFirstChild("Eggs")
                if eggs then
                    for _, egg in ipairs(eggs:GetChildren()) do
                        pcall(P.Network.FireServer, "Collect Egg", egg.Name)
                        task.wait()
                    end
                end
            end
            if St.deposit then pcall(F, "Deposit Eggs") end
            if St.cash then
                local cc = S("CashCollect")
                if cc and cc > 0 then pcall(F, "Collect Cash") end
            end
            if St.merge then pcall(F, "Merge Chickens") end
            if St.buy then pcall(F, "Buy Chickens", 100) end
            task.wait(0.15)
        end
        _G.LCF_THREAD = nil
    end)
end

Tab1:Paragraph({ Title = "自动采集", Desc = "鸡场自动化脚本" })

Tab1:Toggle({ Title = "▶ 启动", Default = false, Callback = function(v)
    if v then StartLoop() else StopAll() end
end})

Tab1:Toggle({ Title = "捡蛋", Default = false, Callback = function(v) St.eggs = v end})
Tab1:Toggle({ Title = "存蛋加工", Default = false, Callback = function(v) St.deposit = v end})
Tab1:Toggle({ Title = "收现金", Default = false, Callback = function(v) St.cash = v end})
Tab1:Toggle({ Title = "合成鸡", Default = false, Callback = function(v) St.merge = v end})
Tab1:Toggle({ Title = "买鸡 x100", Default = false, Callback = function(v) St.buy = v end})

Tab1:Button({ Title = "买鸡 x100", Callback = function()
    local ok, r = F("Buy Chickens", 100)
    warn(ok and "✅" or "❌ " .. tostring(r))
end})

Tab1:Button({ Title = "存蛋", Callback = function()
    local ok, r = F("Deposit Eggs")
    warn(ok and "✅" or "❌ " .. tostring(r))
end})

Tab1:Button({ Title = "收钱", Callback = function()
    local ok, r = F("Collect Cash")
    warn(ok and "✅" or "❌ " .. tostring(r))
end})

-- ============================================
-- 设置
-- ============================================
Tab2:Paragraph({ Title = "快捷键", Desc = "菜单切换: RightShift" })
Tab2:Button({ Title = "关闭脚本", Variant = "Destructive", Callback = function()
    Window:Destroy()
end})

-- ============================================
-- 关于
-- ============================================
Tab3:Paragraph({ Title = "关于", Desc = BRAND.name .. " " .. BRAND.version .. "\n作者: " .. BRAND.author })
Tab3:Button({ Title = "关闭脚本", Variant = "Destructive", Callback = function() Window:Destroy() end })

-- ============================================
-- Anti-AFK
-- ============================================
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- 暴露全局给外部脚本调用
_G._LCF_WindUI = WindUI
_G._LCF_TmplWin = Window

print("[" .. BRAND.name .. "] UI 纯净模板已加载 ✅")
