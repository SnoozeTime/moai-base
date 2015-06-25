BaseEntity = {}

function BaseEntity:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  -----------------------
  local texture = MOAIGfxQuad2D.new()
  texture:setTexture("Untitled.png")
  texture:setRect(-16,-16,16,16)
  ------------------------
  local prop = MOAIProp2D.new()
  prop:setDeck(texture)
  --prop:setLoc(0, 0)
  -----------------------
  
  self.texture = texture
  self.prop = prop
  self.upDown = false
  self.leftDown = false
  self.downDown = false
  self.rightDown = false
  
  return o
end

function BaseEntity:addBox2D(world)
  
   local body = world:addBody( MOAIBox2DBody.DYNAMIC )
   body:setTransform( 0, -200 )
   local circleFixture = body:addRect(-16, 16, 16, -16)
   circleFixture:setDensity(1)
   circleFixture:setRestitution(0.9)
   body:resetMassData()
   
   self.body = body
   self.prop:setParent(self.body)
   
end

return BaseEntity
