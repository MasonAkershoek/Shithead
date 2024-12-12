-- conf.lua

_RELESE_MODE = true
_GAME_WIDTH = 1920
_GAME_HEIGHT = 1080

function love.conf(t)

    -- Love Version
    t.version = "11.5"

    -- Window configurations
    t.window.title = "Shithead"
    t.window.resizable = true
    --t.window.icon

    t.console = true
    t.modules.joystick = false
end
