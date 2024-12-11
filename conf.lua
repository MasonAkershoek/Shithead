-- conf.lua

_RELESE_MODE = false
_GAME_WIDTH = 1920
_GAME_HEIGHT = 1080

function love.conf(t)
    t.version = "11.5"
    t.window.title = "Shithead"
    -- t.window.width = _GAME_WIDTH
    -- t.window.height = _GAME_HEIGHT
    --t.window.icon
    t.console = true
    t.window.resizable = false
    t.modules.joystick = false
    t.window.vsync = true
end
