-- Parse a lua file coming from tile and use it to display a tiled map
-- Tiled can add properties to its tiles. let's begin by collision
-- 


require("modules/utils")

Map = {}

function Map:new ( mapname )
  o = {}
  setmetatable(o, self)
  self.__index = self
  
  self:importMap(mapname)
  
  return o
end

function Map:importMap( mapname )
  -- Here, we parse the incoming lua file to something more readable by MOAI
  local mapfile = require( mapname )
  
  -- Let's begin simple. We assume that we created just one layer with Tiled and
  -- that everything is in the same tileset.
  
  -- Number of tile along x and y
  self.tilenx = mapfile.width
  self.tileny = mapfile.height
  -- size of the tiles
  self.tilewidth = mapfile.tilewidth
  self.tileheight = mapfile.tileheight
  
  -- tileset and tiles
  self.tileset = mapfile.tilesets[1]
  self.tiles = {}
  for i = 1, self.tileset.tilecount do
    local tile = {}
    tile.id = i
    
    tile.properties = {}
    
    for _, v in ipairs(self.tileset.tiles) do
      if v.id == i then
        tile.properties = v.properties
      end     
    end
    

    table.insert(self.tiles, tile)
  end
  
  self.data = {}
  
  --Now the grid
  local maplayer = mapfile.layers[1]
  
  for y = 1, self.tileny do
    
    local row = {}
    
    for x = 1, self.tilenx do

      local id = maplayer.data[ x + (y - 1) * self.tilenx ]
      table.insert(row, self.tiles[id])
      
    end
    
    table.insert(self.data, row)
  end
  
  self:display()
end

-------------------------------------------------------------------------
-- helper for setRow of MOAIGrid
-----------------------------------------------------------------------
local function getHexRow( row )
 
  local hexarow = {}

  for _, el in ipairs(row) do
    table.insert(hexarow, tonumber(Utils.num2hex(el.id), 16))
  end
  
  return unpack(hexarow)
 
end



----------------------------------------------------------------------
-- Create our MOAI Objects to display the map
------------------------------------------------------------------------

function Map:display()
  -- Here we will construct our moai objects.
  local grid = MOAIGrid.new()
  grid:initRectGrid(self.tilenx, self.tileny, self.tilewidth, self.tileheight)
  
  for y = 1, self.tileny do
    grid:setRow(self.tileny - (y - 1), getHexRow(self.data[y]))
  end
 
  
  local mapTiles = MOAITileDeck2D.new()
  mapTiles:setTexture("tilesheet.png")
  
  local sx = self.tileset.imagewidth / self.tileset.tilewidth
  local sy = self.tileset.imageheight / self.tileset.tileheight
  mapTiles:setSize(sx, sy)
  
  local prop = MOAIProp2D.new()
  prop:setDeck(mapTiles)
  prop:setGrid(grid)
  prop:setLoc(-400, - ( self.tileny * self.tileheight - 300))
  
  -- Miiiiine
  self.grid = grid
  self.mapTiles = mapTiles
  self.prop = prop
  
end

function Map:drawDebug()
  
  -- Red rectangle if properties table contains collide
  local function getDebugRow(row)
    local debugRow = {}
    
    for _, el in ipairs(row) do
      if el.properties["collide"] ~= nil then
        table.insert(debugRow, 1)
      else
        table.insert(debugRow, 2)
      end
    end
    
    return unpack(debugRow)
  end
  
  -------------------------------------------------------------------------------
  
  local collideGrid = MOAIGrid.new()
  collideGrid:initRectGrid(self.tilenx, self.tileny, self.tilewidth, self.tileheight)
  for y = 1, self.tileny do
    print(getDebugRow(self.data[y]))
    collideGrid:setRow(self.tileny - (y - 1), getDebugRow(self.data[y]))
  end
  
  local mapTiles = MOAITileDeck2D.new()
  mapTiles:setTexture("debug.png")
  mapTiles:setSize(2,1)
  
  local prop = MOAIProp2D.new()
  prop:setDeck(mapTiles)
  prop:setGrid(collideGrid)
  prop:setLoc(-400, - ( self.tileny * self.tileheight - 300))
  
  return prop

end




return Map
