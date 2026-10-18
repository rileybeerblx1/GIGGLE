local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SERVICE_ID = "aurorasoftworks"
local KEY_FILE = "aurora_key.txt"
local HUB_NAME = "Aurora"

local function safeIsFile(path)
    local ok, result = pcall(function()
        return isfile and isfile(path)
    end)
    return ok and result
end

local function safeReadFile(path)
    local ok, result = pcall(function()
        return readfile and readfile(path)
    end)
    return ok and result or nil
end

local function safeWriteFile(path, content)
    local ok = pcall(function()
        if writefile then
            writefile(path, content)
        end
    end)
    return ok
end

local function safeSetClipboard(text)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        end
    end)
end

local Pelinda
local loadSuccess, loadErr = pcall(function()
    Pelinda = loadstring(game:HttpGet("https://api.pandauth.com/lib/external/v3.lua"))()
end)

if not loadSuccess or not Pelinda then
    warn("[Aurora] Failed to load Panda library:", loadErr)
end

local function validateKey(key, silent)
    if not Pelinda then
        return "error!!"
    end

    local result = Pelinda.Init({
        Service = SERVICE_ID,
        Key = key,
        SilentMode = silent == true,
        SecurityLevel = 1
    })

    return result
end

local function getKeyLink()
    if not Pelinda then
        return "https://new.pandadevelopment.net/getkey/" .. SERVICE_ID
    end
    local link = Pelinda.GetKeyLink({ Service = SERVICE_ID })
    return link or ("https://new.pandadevelopment.net/getkey/" .. SERVICE_ID)
end

local function trySavedKey()
    if not safeIsFile(KEY_FILE) then
        return false
    end

    local saved = safeReadFile(KEY_FILE)
    if not saved or saved == "" then
        return false
    end

    local result = validateKey(saved:gsub("%s+", ""), true)
    return result == "validated!!"
end

if trySavedKey() then
    print("[Aurora] Key validated from save. Loading...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jakajakamd-glitch/Fling/refs/heads/main/ui.lua"))()
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuroraKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 320)
Main.Position = UDim2.new(0.5, -190, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 50, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

local BGGradient = Instance.new("UIGradient")
BGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 14, 22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 20, 32)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
})
BGGradient.Rotation = 45
BGGradient.Parent = Main

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 4)
AccentBar.Position = UDim2.new(0, 0, 0, 0)
AccentBar.BorderSizePixel = 0
AccentBar.Parent = Main

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 180)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 120, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(160, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 220))
})
AccentGradient.Parent = AccentBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 36)
Title.Position = UDim2.new(0, 20, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = HUB_NAME
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(230, 240, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 20)
Subtitle.Position = UDim2.new(0, 20, 0, 48)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Complete the Key System to Proceed"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 13
Subtitle.TextColor3 = Color3.fromRGB(120, 140, 170)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, -40, 0, 48)
InputContainer.Position = UDim2.new(0, 20, 0, 90)
InputContainer.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
InputContainer.BorderSizePixel = 0
InputContainer.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = InputContainer

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(45, 55, 80)
InputStroke.Thickness = 1
InputStroke.Parent = InputContainer

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -20, 1, 0)
KeyBox.Position = UDim2.new(0, 12, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.PlaceholderText = "Enter your key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(90, 105, 130)
KeyBox.Text = ""
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextSize = 15
KeyBox.TextColor3 = Color3.fromRGB(220, 230, 245)
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = InputContainer

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 22)
StatusLabel.Position = UDim2.new(0, 20, 0, 148)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextColor3 = Color3.fromRGB(140, 160, 190)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Main

local function createButton(text, pos, color1, color2)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -25, 0, 44)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(235, 245, 255)
    btn.AutoButtonColor = false
    btn.Parent = Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 65, 95)
    stroke.Thickness = 1
    stroke.Parent = btn

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    grad.Rotation = 90
    grad.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 42, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 30, 45)}):Play()
    end)

    return btn
end

local GetKeyBtn = createButton("Get Key", UDim2.new(0, 20, 0, 185),
    Color3.fromRGB(0, 160, 150), Color3.fromRGB(40, 100, 200))

local SubmitBtn = createButton("Submit", UDim2.new(0.5, 5, 0, 185),
    Color3.fromRGB(90, 60, 200), Color3.fromRGB(140, 50, 220))

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -40, 0, 18)
Footer.Position = UDim2.new(0, 20, 1, -32)
Footer.BackgroundTransparency = 1
Footer.Text = "Key is saved automatically  •  New key overrides old one"
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.TextColor3 = Color3.fromRGB(80, 95, 120)
Footer.Parent = Main

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local scale = math.clamp(math.min(vp.X / 450, vp.Y / 500), 0.75, 1.15)
    Main.Size = UDim2.new(0, 380 * scale, 0, 320 * scale)
end

updateScale()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.wait(0.1)
    updateScale()
end)

local isProcessing = false

local function setStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(140, 160, 190)
end

GetKeyBtn.MouseButton1Click:Connect(function()
    local link = getKeyLink()
    safeSetClipboard(link)
    setStatus("Get Key link copied to clipboard!", Color3.fromRGB(0, 210, 160))
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if isProcessing then return end
    isProcessing = true
    local key = KeyBox.Text:gsub("%s+", "")
    if key == "" then
        setStatus("Please enter a key.", Color3.fromRGB(255, 140, 100))
        isProcessing = false
        return
    end
    setStatus("Validating...", Color3.fromRGB(180, 200, 255))
    SubmitBtn.Text = "..."
    task.spawn(function()
        local result = validateKey(key, false)
        if result == "validated!!" then
            safeWriteFile(KEY_FILE, key)
            setStatus("Key accepted! Loading...", Color3.fromRGB(0, 220, 150))
            SubmitBtn.Text = "Success"
            task.wait(0.9)
            ScreenGui:Destroy()
            print("[Aurora] Authenticated successfully.")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/jakajakamd-glitch/Fling/refs/heads/main/ui.lua"))()
        elseif result == "invalid!!" then
            setStatus("Invalid or expired key. Get a new one.", Color3.fromRGB(255, 110, 110))
            SubmitBtn.Text = "Submit"
            if safeIsFile(KEY_FILE) then
                pcall(function()
                    if delfile then delfile(KEY_FILE) end
                end)
            end
        else
            setStatus("Connection error. Try again.", Color3.fromRGB(255, 160, 80))
            SubmitBtn.Text = "Submit"
        end
        isProcessing = false
    end)
end)

KeyBox.FocusLost:Connect(function(enter)
    if enter then
        SubmitBtn:Fire("MouseButton1Click")
    end
end)

print("[Aurora Softworks] Key system loaded. Waiting for key...")
