screenWidth = MOAIEnvironment.screenWidth
screenHeight = MOAIEnvironment.screenHeight
if screenWidth == nil then screenWidth =1280 end
if screenHeight == nil then screenHeight = 800 end

MOAISim.openWindow("Window",screenWidth,screenHeight)

local viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth, screenHeight)

local layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAIRenderMgr.pushRenderPass(layer)

local map = MOAIGrid.new()
map:initRectGrid(2,2,32,32)
map:setRow(2,0x02,0x01)
map:setRow(1,0x03,0x02)


local mapTiles = MOAITileDeck2D.new()
mapTiles:setTexture("tiles.png")
mapTiles:setSize(3, 1)

local prop = MOAIProp2D.new()
prop:setDeck(mapTiles)
prop:setGrid(map)
prop:setLoc(0,0)
-- functionally the same as above
-- prop:setPiv(480/2,320/2)

layer:insertProp(prop)
