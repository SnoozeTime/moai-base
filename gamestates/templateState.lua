
--Template class for a gamestate


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

   -- Set the viewport and the layer for rendering                                                                   
   viewport = MOAIViewport.new()
   viewport:setScale(320,480)
   viewport:setSize(320,480)

   layer = MOAILayer2D.new()
   layer:setViewport(viewport)                                                                                    
   MIN_ENNEMY_SPEED = 200
   MAX_ENNEMY_SPEED = 300

   ALLY_SPEED = 300

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
end

function BaseState:getLayers()
   print("Get layers")
   return self.layers
end

function BaseState:clean()
   print("Clean state")
end

function BaseState:update()
   self.frames = self.frames + 1
   if self.frames > 180 then
      print("Update state " .. self.frames)
      self.frames = 0
   end
end



   
return BaseState
