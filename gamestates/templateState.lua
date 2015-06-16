
--Template class for a gamestate
local Hero = require("../entities/templateEntity")

BaseState = {}

function BaseState:new (o)
   o = o or {} 
   -- base for inheritance
   setmetatable(o, self)
   -- if try to access a nil field of o, will look in its metatable
   self.__index = self
   
  
   return o
end

function BaseState:initialize()
   print("Initialize state")
   
   --Input 
   MOAIInputMgr.device.keyboard:setKeyCallback ( onKeyboardKeyEvent )

   -- Set the viewport and the layer for rendering                                                                   
   viewport = MOAIViewport.new()
   viewport:setScale(800,600)
   viewport:setSize(800,600)

   layer = MOAILayer2D.new()
   layer:setViewport(viewport)                                                                                    
   --===============================                                                                                 
   -- Add a lobster                                                                                                  
   --================================                                                                                
   --create a new GfxQuad to hold texture                                                                            
   lobsterGfx = MOAIGfxQuad2D.new()
   lobsterGfx:setTexture("openlobster.png")
   --set the size of the quad                                                                                        
   lobsterGfx:setRect(-128, -128, 128, 128)

   --Create a new prop                                                                                               
   base = MOAIProp2D.new()
   base:setDeck(lobsterGfx)
   -- Coordinates simulation style. 0,0 is center of the screen and y increases with height                          
   baseX = 0
   baseY = -240
   base:setLoc(baseX, baseY)

   --Insert the prop into the layer so it can be seen                                                                
   layer:insertProp(base)
   
   self.frames = 0
   self.layers = {}  
   table.insert(self.layers, layer)
   
   -- Some properties for our lobster
    base.upDown = false
    base.leftDown = false
    base.downDown = false
    base.rightDown = false
end

function BaseState:getLayers()
   print("Get layers")
   return self.layers
end

function BaseState:clean()
   print("Clean state")
end

--==============================================
-- CALLBACKS FOR INPUT AND UPDATE FUNCTION
--==============================================
local keyNames = {}
for name, value in pairs ( MOAIKeyCode ) do
	if type( value ) == "number" then
		keyNames [ value ] = name
	end
end

function onKeyboardKeyEvent ( key, down )
	local keyInfo = keyNames [ key ] or tostring ( key )
  if keyInfo == "Z" then
    base.upDown = down
  end
  if keyInfo == "Q" then
    base.leftDown = down
  end
  if keyInfo == "S" then
    base.downDown = down
  end
  if keyInfo == "D" then
    base.rightDown = down
  end
end


function BaseState:update()
   self.frames = self.frames + 1
   if self.frames > 180 then
      print("Update state " .. self.frames)
      self.frames = 0
   end
   
   local x, y = base:getLoc()
    if base.upDown == true then
      y = y + 10
    end
    if base.rightDown == true then
      x = x + 10
    end
    if base.downDown == true then
      y = y - 10
    end
    if base.leftDown == true then
      x = x - 10
    end
    base:setLoc(x, y)
    
    
end



   
return BaseState
