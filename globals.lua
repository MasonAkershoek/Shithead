GAME_VERSION = "0.0.6"

function Game:setGlobals()
    self.TILE = { "S", "H", "I", "T", "H", "E", "A", "D" }

    -- =================
    -- == Game States ==
    -- =================
    self.MAJORSTATE = nil

    self.MINORSTATE = nil

    self.MAJORSTATES = {
        MAINMENU = 1,
        SINGLEPLAYERMODE = 2,
        MULTIPLAYERMODE = 3
    }

    self.MINORSTATES = {
        MAININTRO = 1,
        MAINMENUIDLE = 2,
        LEAVEMAINMENU = 3,
        MULTIPLAYERMENU = 4,
        STARTGAME = 5,
        TURN = 6,
        BURN = 7,
        PICKUP = 8,
        WIN = 9,
        CLEANUP = 10,
    }

    -- ============
    -- == Timers ==
    -- ============
    self.TIMERMANAGER = TimerManager.new()
    self.TIMERS = {
        UPTIME = 0
    }

    -- =====================
    -- == KeyboardManager ==
    -- =====================
    self.KEYBOARDMANAGER = KeyboardManager.new()

    -- ==============
    -- == Settings ==
    -- ==============
    self.SETTINGS = {
        SHOWFPS = false,
        DEBUGBOXACTIVE = false,
        PAUSED = false,
        ESCAPEMENUACTIVE = false,
        SCREENVARIABLES = {
            SCREENMODE = "fullscreen",
            DIPLAYNUM = 1,
            VSYNC = 1,
            DISPLAY = {
                NAMES = {},
                RESOLUTIONS = {}
            },
            CURRENTDISPLAY = 1,
            YOFFSET = 0,
            SCREENSCALE = 1
        },
        SOUND = {
            VOLUME = 100
        }
    }

    -- ====================
    -- == Card Constants ==
    -- ====================
    self.CARDSPEED = 3000
    self.CARDSUITS = { "Spades", "Diamonds", "Clubs", "Hearts" }
    self.SPECIALCARDS = { 2, 5, 8, 10 }

    -- ===========
    -- == Fonts ==
    -- ===========
    self.FONTMANAGER = FontManager.new()
    self.FONTMANAGER:addFont("GAMEFONT", "resources/graphics/pixelFont.otf")

    -- ==================
    -- == EventManager ==
    -- ==================
    self.EVENTMANAGER = EventManager.new()

    -- ===============
    -- == Instances ==
    -- ===============
    self.UI = {
        BOX = {}
    }
    self.CARDS = {}

    self.CARDAREAS = {}

    self.BUFFEREDFUNCS = {}

    self.DRAWBUFF = {}



    self.EVENTMANAGER:addListener("quit", Event.new(function() G:quit() end))
    self.EVENTMANAGER:addListener("activateEscapeMenu",
        Event.new(
            function()
                G.SETTINGS.ESCAPEMENUACTIVE = true
                G.SETTINGS.PAUSED = true
                MAKE_ESC_MENU()
            end
        )
    )
    -- self.EVENTMANAGER:on("makeWinBox", function()
    --     G.SETTINGS.paused = true
    --     MAKE_WIN_BOX()
    -- end)
end

G = Game.new()
