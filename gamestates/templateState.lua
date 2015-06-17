
--Template class for a gamestate
local Hero = require("../entities/templateEntity")
local Map = require("../modules/Map")

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
   MOAIInputMgr.device.keyboard:setKeyCallback ( BaseState.onKeyboardKeyEvent )

   -- Set the viewport and the layer for rendering                                                                   
   viewport = MOAIViewport.new()
   viewport:setScale(800,600)
   viewport:setSize(800,600)

   layer = MOAILayer2D.new()
   layer:setViewport(viewport)         
   
   --===============================
   -- Add a map
   --================================
   map = Map:new("assets/maps/map3")
   
   layer:insertProp(map.prop)
   layer:insertProp(map:drawDebug())
   --===============================                                                                                 
   -- Add a lobster                                                                                                  
   --================================                                                                                
   base = Hero:new()

   --Insert the prop into the layer so it can be seen                                                                
   layer:insertProp(base.prop)
   
   self.frames = 0
   self.layers = {}  
   table.insert(self.layers, layer)

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

function BaseState.onKeyboardKeyEvent ( key, down )
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
   
   local x, y = base.prop:getLoc()
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
    base.prop:setLoc(x, y)
    
    
end



   
return BaseState
