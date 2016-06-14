furniture = {}

function furniture.register_wooden(name, def)
  local node_def = minetest.registered_nodes[name]
  if not node_def then
    if minetest.get_current_modname() ~= "furniture" then
      minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_wooden")
    end
    return
  end
  local subname = name:split(':')[2]
  if not def.description then
    def.description = node_def.description
  end
  if not def.description_chair then
    def.description_chair = def.description.." Chair"
  end
  if not def.description_stool then
    def.description_stool = def.description.." Stool"
  end
  if not def.description_table then
    def.description_table = def.description.." Table"
  end
  if not def.tiles then
    def.tiles = node_def.tiles
  end
  if not def.tiles_chair then
    local tile = def.tiles[1]
    def.tiles_chair = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_chair_modify.png^[makealpha:255,0,255)"}
  end
  if not def.tiles_table then
    local tile = def.tiles[1]
    def.tiles_table = {tile, tile, tile.."^[transformR90"}
  end
  if not def.groups then
    local groups = table.copy(node_def.groups)
    groups.wood = 0
    groups.planks = 0
    def.groups = groups
  end
  if not def.sounds then
    def.sounds = node_def.sounds
  end
  if not def.stick then
    def.stick = "group:stick"
  end

  minetest.register_node(":furniture:chair_"..subname, {
    description = def.description_chair,
    tiles = def.tiles_chair,
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.3125, -0.5, 0.1875, -0.1875, 0.5, 0.3125},
        {0.1875, -0.5, 0.1875, 0.3125, 0.5, 0.3125},
        {-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
        {0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
        {-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125},
        {-0.1875, 0.1875, 0.25, 0.1875, 0.4375, 0.3125}
      },
    },
    selection_box = {
      type = "fixed",
      fixed = {
        {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125},
        {-0.3125, 0.0625, 0.1875, 0.3125, 0.5, 0.3125}
      }
    },
    sounds = def.sounds,
    groups = def.groups,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
    	if not player or not player:is_player() then
    		return
    	end
      local name = player:get_player_name()
      if default.player_attached[name] == false then
        player:set_physics_override(0, 0, 0)
        player:setpos(pos)
        default.player_attached[name] = true
        default.player_set_animation(player, "sit" , 0)
      else
        player:set_physics_override(1, 1, 1)
        default.player_attached[name] = false
        default.player_set_animation(player, "stand" , 30)
      end
    end
  })

  minetest.register_node(":furniture:stool_"..subname, {
  	description = def.description_stool,
  	tiles = def.tiles_chair,
  	paramtype = "light",
  	drawtype = "nodebox",
  	node_box = {
  		type = "fixed",
  		fixed = {
        {-0.3125, -0.5, 0.1875, -0.1875, -0.0625, 0.3125},
        {0.1875, -0.5, 0.1875, 0.3125, -0.0625, 0.3125},
        {-0.3125, -0.5, -0.3125, -0.1875, -0.0625, -0.1875},
        {0.1875, -0.5, -0.3125, 0.3125, -0.0625, -0.1875},
        {-0.3125, -0.0625, -0.3125, 0.3125, 0.0625, 0.3125}
  		},
  	},
    selection_box = {
      type = "fixed",
      fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125}
    },
  	sounds = def.sounds,
  	groups = def.groups,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
      if not player or not player:is_player() then
        return
      end
      local name = player:get_player_name()
      if default.player_attached[name] == false then
        player:set_physics_override(0, 0, 0)
        player:setpos(pos)
        default.player_attached[name] = true
        default.player_set_animation(player, "sit" , 0)
      else
        player:set_physics_override(1, 1, 1)
        default.player_attached[name] = false
        default.player_set_animation(player, "stand" , 30)
      end
    end
  })

  minetest.register_node(":furniture:table_"..subname, {
    description = def.description_table,
    tiles = def.tiles_table,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.125, -0.5, -0.125, 0.125, 0.375, 0.125},
        {-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}
      },
    },
    sounds = def.sounds,
    groups = def.groups
  })

  minetest.register_craft({
  	output = "furniture:chair_"..subname,
  	recipe = {
  		{def.stick, ""},
  		{name, name},
  		{def.stick, def.stick}
  	}
  })

  minetest.register_craft({
    output = "furniture:chair_"..subname,
    recipe = {
      {"", def.stick},
      {name, name},
      {def.stick, def.stick}
    }
  })

  minetest.register_craft({
    output = "furniture:stool_"..subname,
    recipe = {
      {name, name},
      {def.stick, def.stick}
    }
  })

  minetest.register_craft({
    output = "furniture:table_"..subname,
    recipe = {
      {name, name, name},
      {"", name, ""},
      {"", name, ""}
    }
  })
end

furniture.register_wooden("default:wood", {description = "Wooden"})
furniture.register_wooden("default:junglewood", {description="Junglewood"})
furniture.register_wooden("default:pine_wood", {description="Pine Wood"})
furniture.register_wooden("default:acacia_wood", {description="Acacia Wood"})
furniture.register_wooden("default:aspen_wood", {description="Aspen Wood"})
