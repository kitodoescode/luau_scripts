-- init stuff for teh lib
local InsertService = game:GetService("InsertService")

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId

ReGui:Init({
	Prefabs = InsertService:LoadLocalAsset(PrefabsId)
})

-- editor lib
local EditorLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/lib/ide.lua'))()

-- more defs stuff
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ToggleUIKey = Enum.KeyCode.Home
local HideGUI = false
local HideWatermark = false
local TimeString = DateTime.now():FormatLocalTime("dddd hh:mm:ss A", "en-us")

ReGui:DefineTheme("Cherry", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 100, 120),
	Text = Color3.fromRGB(200, 180, 200),
	
	FrameBg = Color3.fromRGB(25, 20, 25),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(120, 100, 120),
	FrameBgTransparencyActive = 0.4,
	
	CheckMark = Color3.fromRGB(150, 100, 150),
	SliderGrab = Color3.fromRGB(150, 100, 150),
	ButtonsBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
	RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),
	
	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(35, 30, 35),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
	RegionBgTransparency = 1,

	TabBg = Color3.fromRGB(50, 35, 50),
    TabBgActive = Color3.fromRGB(120, 80, 120),
    TabsBarBg = Color3.fromRGB(35, 25, 35),
})

ReGui:DefineTheme("Watermark", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 100, 120),
	Text = Color3.fromRGB(200, 180, 200),
	
	FrameBg = Color3.fromRGB(25, 20, 25),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(120, 100, 120),
	FrameBgTransparencyActive = 0.4,
	
	CheckMark = Color3.fromRGB(150, 100, 150),
	SliderGrab = Color3.fromRGB(150, 100, 150),
	ButtonsBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
	RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),

	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(35, 30, 35),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
	RegionBgTransparency = 1,

	TabBg = Color3.fromRGB(50, 35, 50),
    TabBgActive = Color3.fromRGB(120, 80, 120),
    TabsBarBg = Color3.fromRGB(35, 25, 35),
})

-- actual stuff from here

-- tabbed window
local Window = ReGui:TabsWindow({
	Title = "Ash - Main",
    Theme = "Cherry",
    Size = UDim2.fromOffset(500, 300),
    Position = UDim2.fromOffset(20, -20),
    Visibility = not HideGUI,
    NoClose = true
})

local ConsoleWindow = ReGui:Window({
    Title = "Ash - Console",
    Theme = "Cherry",
    Size = UDim2.fromOffset(500, 300),
    Position = UDim2.fromOffset(540, -20),
    Visibility = not HideGUI,
    NoClose = true
})

local WatermarkWindow = ReGui:Window({
    Theme = "Watermark",
    Visible = not HideWatermark,
    CornerRadius = UDim.new(0, 2),
	Position = UDim2.fromOffset(10, 710),
	Size = UDim2.fromOffset(170, 30),
	Border = true,
	BorderThickness = 1,
	BorderColor = ReGui.Accent.Gray,
	--BackgroundTransparency = 0,
	BackgroundColor3 = ReGui.Accent.Black,

    NoCollapse = true,
    NoClose = true,
    NoBackground = true,
    NoTitleBar = true,
    NoResize = true,
    NoMove = true,
    NoScrollBar = true,
    NoSelectEffect = true,
    NoBringToFrontOnFocus = true,
})

local Watermark = WatermarkWindow:Label()

RunService.RenderStepped:Connect(function()
	local TimeString = DateTime.now():FormatLocalTime("HH:mm:ss", "en-us")
	local text = `Ash - Windows | {TimeString}`
	Watermark.Text = text
end)

local ModalWindow = Window:PopupModal({
	Title = "Ash - Welcome",
	AutoSize = "Y",
    Visibility = not HideGUI,
})

ModalWindow:Label({
	Text = [[Welcome To Ash! 
Thanks for using our product.]],
	TextWrapped = true
})
ModalWindow:Separator()

ModalWindow:Button({
	Text = "Continue",
	Callback = function()
		ModalWindow:ClosePopup()
	end,
})

local EditorTab = Window:CreateTab({
    Name = "Editor"
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == ToggleUIKey then
        HideGUI = not HideGUI
        Window:SetVisible(not HideGUI)
        ConsoleWindow:SetVisible(not HideGUI)
        Window:SetFocused(true)
    end
end)

local Console = ConsoleWindow:Console({
    AutoScroll = true,
    TextWrapped = true,
    ReadOnly = true,
    Enabled = true,
    RichText = true,
    BorderThickness = 0,
})

-- cannot put above console cuz console:appendtext wont exist
function Log(type, content)
  type = string.upper(type)
  Console:AppendText("[" .. type .. "]" .. " " .. content)
end

local CodeEditor = EditorLib.CodeFrame.new({
    Editable = true,
    FontSize = 13,
    Colors = SyntaxColors,
    FontFace = TextFont
})

ReGui:ApplyFlags({
	Object = CodeEditor.Gui,
	WindowClass = Window,
	Class = {
		Fill = true,
		Parent = EditorTab:GetObject(),
		BackgroundTransparency = 1,
	}
})

local CtrlRow = EditorTab:Row()

local ExecBtn = CtrlRow:Button({
    Text = "Execute",
    Callback = function(self)
      local script = CodeEditor:GetText()
      loadstring(script)()
      Log("success", "Script Executed.")
    end
})

local ClearBtn = CtrlRow:Button({
    Text = "Clear",
    Callback = function(self)
      CodeEditor:ClearText()
      Log("success", "Editor Cleared.")
    end
})

local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

local ToggleKeybind = SettingsTab:Keybind({
	Value = ToggleUIKey,
	Label = "Show / Hide GUI",
    OnKeybindSet = function(self, KeyId)
        ToggleUIKey = KeyId
    end
})

local Watermark = SettingsTab:Checkbox({
	Value = true,
	Label = "Show Watermark",
	Callback = function(self, value: boolean)
		HideWatermark = not value
        WatermarkWindow:SetVisible(not HideWatermark)
	end
})

local ExitBtn = SettingsTab:Button({
	Callback = function()
		Window:Close()
        ConsoleWindow:Close()
        WatermarkWindow:Close()
	end,
	Text = "Unload GUI",
})

Log("info", "Ash Loaded.")
