local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/OpposedDev/Ionic/refs/heads/main/source/ioniclibrary.lua"))()

local window = library:createWindow({
    Title = "Friendship",
    Version = "1.00alpha",
    RestoreKeybind = Enum.KeyCode.Home,
    UseCore = true,
})

local section1 = window:createSection({
    Name = "Main"
})

section1:createButton({
    Name = "IYFE",
    Flag = "button",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})