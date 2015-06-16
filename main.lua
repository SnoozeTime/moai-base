
local stateMgr = require("modules.GameStateMgr")
local BaseState = require("gamestates.templateState")

-- ==================================
--    Window
-- ==================================
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
                                                                        
function init()
   --Open a window (title, width, height) - Sim for simulation: reference to coordinate system                       
   MOAISim.openWindow("Moai base", SCREEN_WIDTH, SCREEN_HEIGHT)
end
-- ==================================
-- Game loop
-- ==================================
mainThread = MOAICoroutine.new()

function mainFunction()
   stateMgr.pushState( BaseState:new() )   
   while true do
      coroutine.yield()
      
      stateMgr.update()

   end
end

-- Start
init()
mainThread:run( mainFunction )


    
