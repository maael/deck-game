return {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 20,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 7,
  nextobjectid = 37,
  properties = {},
  tilesets = {
    {
      name = "Dungeon Crawler",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 9,
      image = "./dungeon_tiles.png",
      imagewidth = 144,
      imageheight = 128,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 72,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      id = 1,
      name = "Floor",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 0, 0, 0,
        0, 0, 24, 24, 24, 16, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 0, 0, 0,
        0, 0, 24, 24, 16, 24, 24, 24, 24, 24, 24, 24, 33, 24, 24, 24, 24, 0, 0, 0,
        0, 0, 24, 24, 24, 24, 33, 33, 33, 24, 32, 24, 33, 24, 12, 24, 24, 0, 0, 0,
        0, 0, 24, 24, 24, 32, 33, 33, 33, 33, 24, 24, 33, 24, 24, 24, 24, 0, 0, 0,
        0, 0, 24, 24, 24, 24, 33, 33, 24, 24, 24, 24, 33, 33, 24, 24, 24, 0, 0, 0,
        0, 0, 0, 0, 24, 24, 33, 33, 24, 24, 24, 24, 33, 33, 12, 24, 24, 0, 0, 0,
        0, 0, 0, 0, 24, 33, 33, 24, 32, 24, 24, 24, 24, 24, 33, 24, 24, 0, 0, 0,
        0, 0, 0, 24, 24, 33, 33, 24, 24, 24, 24, 24, 24, 32, 33, 24, 24, 21, 0, 0,
        0, 0, 0, 0, 24, 24, 24, 24, 24, 24, 33, 24, 24, 24, 33, 33, 33, 24, 0, 0,
        0, 0, 0, 0, 24, 12, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 33, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 33, 33, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 33, 24, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 33, 24, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 33, 33, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 24, 24, 24, 24, 24, 24, 24, 24, 24, 33, 33, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 24, 24, 33, 33, 24, 24, 33, 33, 33, 33, 24, 24, 0, 0,
        0, 0, 0, 0, 0, 0, 24, 24, 24, 33, 33, 33, 33, 24, 24, 24, 24, 34, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "BackgroundObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 47.722,
          y = 157.859,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 29,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["object_type"] = "stairs",
            ["sensor"] = true
          }
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 580.736,
          y = 224.441,
          width = 0.484754,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "WallCollision",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 288.429,
          y = 122.643,
          width = 31.0243,
          height = 196.81,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 297.154,
          width = 294.246,
          height = 22.7835,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.484754,
          y = 185.176,
          width = 222.502,
          height = 86.7711,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.969509,
          y = 270.493,
          width = 94.5271,
          height = 33.4481,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.484754,
          y = 158.03,
          width = 67.8656,
          height = 35.3871,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.484754,
          y = 108.585,
          width = 63.0181,
          height = 32.9633,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = -1.45426,
          y = 140.579,
          width = 47.9907,
          height = 17.4512,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = -0.484754,
          y = -0.484754,
          width = 32.4785,
          height = 115.372,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 28,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.484754,
          y = 0,
          width = 318.968,
          height = 31.0243,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 29,
          name = "",
          type = "",
          shape = "rectangle",
          x = 272.917,
          y = 32.9633,
          width = 47.5059,
          height = 110.524,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 30,
          name = "",
          type = "",
          shape = "rectangle",
          x = 254.011,
          y = 248.194,
          width = 8.72558,
          height = 5.3323,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 273.886,
          y = 227.35,
          width = 7.27132,
          height = 4.84754,
          rotation = 0,
          visible = false,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "GameObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 103.737,
          y = 54.2925,
          width = 0,
          height = 0,
          rotation = 0,
          visible = false,
          properties = {
            ["object_type"] = "player_spawn"
          }
        },
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 143.669,
          y = 111.679,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["item_type"] = "key",
            ["object_type"] = "pickup_item",
            ["sensor"] = true
          }
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 224.258,
          y = 63.2349,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["item_type"] = "heal_potion",
            ["object_type"] = "pickup_item",
            ["sensor"] = true
          }
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      id = 2,
      name = "Wall",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 41, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 40, 0, 0,
        0, 50, 43, 53, 43, 43, 43, 43, 43, 53, 43, 43, 43, 43, 43, 54, 43, 49, 0, 0,
        0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0,
        0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0,
        0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0,
        0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0,
        0, 59, 60, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0,
        0, 0, 41, 69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 40, 0,
        0, 0, 50, 44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 49, 0,
        0, 0, 59, 57, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 65, 66, 66, 66, 66, 66, 66, 66, 66, 60, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 41, 56, 57, 57, 57, 57, 57, 57, 69, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 50, 44, 44, 44, 44, 44, 44, 44, 44, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 0,
        0, 0, 0, 0, 0, 59, 60, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 58, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "CollidableObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 139.13,
          y = 272.62,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 14,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 199.152,
          y = 35.8788,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 3,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 214.546,
          y = 36.2996,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 3,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 270.406,
          y = 232.145,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["lootable"] = true
          }
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 250.554,
          y = 254.261,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {
            ["lootable"] = true
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 208.685,
          y = 110.768,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 11,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 193.143,
          y = 110.768,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["static"] = true
          }
        }
      }
    }
  }
}
