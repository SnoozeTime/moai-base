
--Template class for a gamestate
local Hero = require("../entities/templateEntity")
local Map = require("../modules/Map")

upDown = false
downDown = false
leftDown = false
rightDown = false


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
   
   -- ==============================
   -- Box2D
   -- ==============================
   world = MOAIBox2DWorld.new ()
   world:setGravity ( 0, 0 )
   world:setUnitsToMeters ( .05 )
   world:start ()
   
   --===============================
   -- Add a map
   --================================
   map = Map:new("assets/maps/map3")
   
   layer:insertProp(map.prop)
   layer:insertProp(map:drawDebug())
   
   map:initCollisions(world)
   --===============================                                                                                 
   -- Add a lobster                                                                                                  
   --================================                                                                                
   base = Hero:new()
   base:addBox2D(world)

   layer:setOverlayTable ({ world })
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
  if keyInfo == "W" then
    upDown = down
  end
  if keyInfo == "A" then
    leftDown = down
  end
  if keyInfo == "S" then
    downDown = down
  end
  if keyInfo == "D" then
    rightDown = down
  end
end

function BaseState:update()
   
  local velx, vely = base.body:getLinearVelocity()
   local desired_velx = 0
   local desired_vely = 0
   
   if leftDown == true then
     desired_velx = -200
   end
   if upDown == true then
     desired_vely = 200
   end
   if downDown == true then
     desired_vely = -200
   end
   if rightDown == true then
     desired_velx = 200
   end
   
   local vel_changex = desired_velx - velx
   local vel_changey = desired_vely - vely
   
   local impulsex = base.body:getMass() * vel_changex
   local impulsey = base.body:getMass() * vel_changey
   
   base.body:applyLinearImpulse(impulsex, impulsey, base.body:getWorldCenter())
    
    
end



   
return BaseState
