-- Parse a lua file coming from tile and use it to display a tiled map

Map = {}

function Map:new ( mapname )
  o = {}
  setmetatable(o, self)
  self.__index = self
  
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
    
    table.insert(hexarow, tonumber(el.id, 16))--tonumber(string.format("0x%X", el.id)))
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
  mapTiles:setSize(self.tilenx, self.tileny)
  
  local prop = MOAIProp2D.new()
  prop:setDeck(mapTiles)
  prop:setGrid(grid)
  prop:setLoc(-400, -300)
  
  -- Miiiiine
  self.grid = grid
  self.mapTiles = mapTiles
  self.prop = prop
  
end




return Map
