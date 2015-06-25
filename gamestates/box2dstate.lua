
Box2DState = {}

function Box2DState:new (o)
   o = o or {} 
   -- base for inheritance
   setmetatable(o, self)
   -- if try to access a nil field of o, will look in its metatable
   self.__index = self
   
  
   return o
end

function Box2DState:initialize()
   print("Initialize state")
   
   --Input 
   MOAIInputMgr.device.keyboard:setKeyCallback ( Box2DState.onKeyboardKeyEvent )
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
   layer:setUnderlayTable ({ world })

   local floorBody = world:addBody( MOAIBox2DBody.STATIC )
   floorBody:setTransform( 0, -200 )
   local floorFixture = floorBody:addRect(-200, 5, 200, -5)   
    
   -- Ball 
   local ballBody = world:addBody( MOAIBox2DBody.DYNAMIC )
   ballBody:setTransform( 0, 100 )
   local circleFixture = ballBody:addRect(-16, 16, 16, -16)
   circleFixture:setDensity(1)
   circleFixture:setRestitution(0.9)
   ballBody:resetMassData()
   
   -- Add a texture to this ball
   local texture = MOAIGfxQuad2D.new()
   texture:setTexture('Untitled.png')
   texture:setRect(-16, -16, 16, 16)
   
   local sprite = MOAIProp2D.new()
   sprite:setDeck(texture)
   sprite.body = ballBody
   sprite:setParent(ballBody)
   
   layer:insertProp(sprite)
   
   upDown = false
   downDown = false
   leftDown = false
   rightDown = false
   
   self.floorBody = floorBody
   self.sprite = sprite
   self.frames = 0
   self.layers = {}  
   table.insert(self.layers, layer)

end

function Box2DState:getLayers()
   print("Get layers")
   return self.layers
end

function Box2DState:clean()
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

function Box2DState.onKeyboardKeyEvent ( key, down )
	local keyInfo = keyNames [ key ] or tostring ( key )
  if keyInfo == "Z" then
    upDown = down
  end
  if keyInfo == "Q" then
    leftDown = down
  end
  if keyInfo == "S" then
    downDown = down
  end
  if keyInfo == "D" then
    rightDown = down
  end
end


function Box2DState:update()
   
   local velx, vely = self.sprite.body:getLinearVelocity()
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
   
   local impulsex = self.sprite.body:getMass() * vel_changex
   local impulsey = self.sprite.body:getMass() * vel_changey
   
   self.sprite.body:applyLinearImpulse(impulsex, impulsey, self.sprite.body:getWorldCenter())
   
    
end



   
return Box2DState
