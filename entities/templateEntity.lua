BaseEntity = {}

function BaseEntity:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  -----------------------
  local texture = MOAIGfxQuad2D.new()
  texture:setTexture("openlobster.png")
  texture:setRect(-128, -128, 128, 128)
  ------------------------
  local prop = MOAIProp2D.new()
  prop:setDeck(texture)
  prop:setLoc(0, -240)
  -----------------------
  
  self.texture = texture
  self.prop = prop
  self.upDown = false
  self.leftDown = false
  self.downDown = false
  self.rightDown = false
  
  return o
end

return BaseEntity
