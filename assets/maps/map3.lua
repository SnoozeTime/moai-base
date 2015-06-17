return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "2015-06-05",
  orientation = "orthogonal",
  width = 4,
  height = 4,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "tilesheet",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../tilesheet.png",
      imagewidth = 384,
      imageheight = 192,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 72,
      tiles = {
        {
          id = 4,
          properties = {
            ["collide"] = ""
          }
        },
        {
          id = 5,
          properties = {
            ["collide"] = ""
          }
        },
        {
          id = 16,
          properties = {
            ["collide"] = ""
          }
        },
        {
          id = 17,
          properties = {
            ["collide"] = ""
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        20, 5, 6, 10,
        8, 17, 18, 10,
        8, 7, 20, 10,
        10, 10, 10, 10
      }
    }
  }
}
