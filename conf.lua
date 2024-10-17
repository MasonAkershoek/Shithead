-- conf.lua

_RELESE_MODE = false
_GAME_WIDTH = 1920
_GAME_HEIGHT = 1080
_GAME_VERSION = "0.0.1"

function love.conf(t)
    t.version = "11.5"
    t.window.title = "Shithead!"
    --t.window.icon
    t.window.resizable = false
    t.modules.joystick = false
    t.window.vsync = true
end