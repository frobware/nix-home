hs.hotkey.bind("cmd", 'H', function() end)
hs.hotkey.bind({"shift", "cmd"}, 'Q', function() end)
hs.hotkey.bind({"control", "cmd"}, 'Q', function() end)
hs.hotkey.bind({"cmd", "shift"}, 'e', function () hs.application.launchOrFocus("Emacs") end)
hs.hotkey.bind({"cmd", "shift"}, 'n', function () hs.application.launchOrFocus("Alacritty") end)
hs.hotkey.bind({"cmd", "shift"}, 'c', function () hs.application.launchOrFocus("GoLand") end)
hs.hotkey.bind({"cmd", "shift", "control"}, 'n', function() hs.application.launchOrFocus("Safari") end)

hs.application.enableSpotlightForNameSearches(true)
