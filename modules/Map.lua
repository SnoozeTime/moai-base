-- Parse a lua file coming from tile and use it to display a tiled map

require("modules/utils")

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
 --   print("Decimal " .. el.id  .. "   Hexa " .. tonumber(el.id,16))
    table.insert(hexarow, tonumber(Utils.num2hex(el.id), 16)) --tonumber(string.format("0x%X", el.id)))
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
  
  --grid:setRow(3, 0x01, 0x01, 0x02)
  --grid:setRow(2, 0x02, 0x03, 0x01)
  --grid:setRow(1, 0x03, 0x01, 0x03)
  for y = 1, self.tileny do
    print(getHexRow(self.data[y]))
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




return Map
