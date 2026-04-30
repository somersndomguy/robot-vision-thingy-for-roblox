local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "multi tool thingy",
   LoadingTitle = "loading your multi tool",
   LoadingSubtitle = "by evilstealerguything on discord",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = {
      TextColor = Color3.fromRGB(255, 255, 255),
      Background = Color3.fromRGB(0, 0, 0),
      AccentColor = Color3.fromRGB(255, 0, 150),
      Main = Color3.fromRGB(15, 15, 15),
      Navbar = Color3.fromRGB(20, 20, 20),
      SectionSide = Color3.fromRGB(255, 0, 150)
   }
})

local MainTab = Window:CreateTab("Tools", 4483345998)

-- Custom Speed Input
MainTab:CreateInput({
   Name = "Custom WalkSpeed",
   PlaceholderText = "Enter speed (e.g. 100)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       local speed = tonumber(Text)
       if speed then
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
       else
           Rayfield:Notify({Title = "Error", Content = "Please enter a valid number!", Duration = 2})
       end
   end,
})

MainTab:CreateButton({
   Name = "Load Infinite Yield",
   Callback = function()
       loadstring(game:HttpGet('https://githubusercontent.com'))()
   end,
})

local ChatTab = Window:CreateTab("Global Chat", 4483345998)
local ChatBox = ChatTab:CreateParagraph({Title = "Chat Log", Content = "Waiting for messages..."})

ChatTab:CreateInput({
   Name = "Message",
   PlaceholderText = "Type message...",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
       local timestamp = os.date("%X")
       local currentText = ChatBox.Content
       if currentText == "Waiting for messages..." then currentText = "" end
       ChatBox:Set({Title = "Chat Log", Content = currentText .. "\n[" .. timestamp .. "] " .. game.Players.LocalPlayer.DisplayName .. ": " .. Text})
   end,
})

Rayfield:Notify({
   Title = "Hub Ready",
   Content = "Drag the top pink bar to move the menu.",
   Duration = 5
})
