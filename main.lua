
local stateMgr = require("modules.GameStateMgr")
local BaseState = require("gamestates.templateState")

-- ==================================
--    Window
-- ==================================
--=====================================                                                                           
-- setup moai                                                                                                     
--=====================================                                                                           
function init()
   --Open a window (title, width, height) - Sim for simulation: reference to coordinate system                       
   MOAISim.openWindow("Rocket Lobster", 320, 480)
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


    
