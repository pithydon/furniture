furniture = {}

function furniture.stand(player, pos)
	local player_pos = player:getpos()
	local dist = vector.distance(player_pos, pos)
	if dist > 0.7 then
		local name = player:get_player_name()
		default.player_attached[name] = false
		default.player_set_animation(player, "stand" , 30)
	else
		minetest.after(0.5, furniture.stand, player, pos)
	end
end

function furniture.register_seat(node_name)
	minetest.register_abm({
		nodenames = {node_name},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

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
		def.tiles_table = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_table_modify.png^[makealpha:255,0,255)"}
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
		groups = def.groups
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
		groups = def.groups
	})

	local fence_group = table.copy(def.groups)
	fence_group.fence = 1

	minetest.register_node(":furniture:table_"..subname, {
		description = def.description_table,
		tiles = def.tiles_table,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-0.125, -0.5, -0.125, 0.125, 0.375, 0.125}, {-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}},
			connect_front = {{-0.0625, 0.1875, -0.5, 0.0625, 0.3125, -0.125}, {-0.0625, -0.3125, -0.5, 0.0625, -0.1875, -0.125}},
			connect_left = {{-0.5, 0.1875, -0.0625, -0.125, 0.3125, 0.0625}, {-0.5, -0.3125, -0.0625, -0.125, -0.1875, 0.0625}},
			connect_back = {{-0.0625, 0.1875, 0.125, 0.0625, 0.3125, 0.5}, {-0.0625, -0.3125, 0.125, 0.0625, -0.1875, 0.5}},
			connect_right = {{0.125, 0.1875, -0.0625, 0.5, 0.3125, 0.0625}, {0.125, -0.3125, -0.0625, 0.5, -0.1875, 0.0625}}
		},
		connects_to = {"group:fence"},
		sounds = def.sounds,
		groups = fence_group
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

	minetest.register_abm({
		nodenames = {"furniture:chair_"..subname, "furniture:stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

function furniture.register_stone(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_stone")
		end
		return
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description
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
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.stone = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end

	minetest.register_node(":furniture:stool_"..subname, {
		description = def.description_stool,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.0625, 0.3125}
		},
		sounds = def.sounds,
		groups = def.groups
	})

	local wall_group = table.copy(def.groups)
	wall_group.wall = 1

	minetest.register_node(":furniture:table_"..subname, {
		description = def.description_table,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-0.25, -0.5, -0.25, 0.25, 0.3125, 0.25}, {-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5}},
			connect_front = {-0.1875, -0.5, -0.5, 0.1875, 0.3125, -0.25},
			connect_left = {-0.5, -0.5, -0.1875, -0.25, 0.3125, 0.1875},
			connect_back = {-0.1875, -0.5, 0.25, 0.1875, 0.3125, 0.5},
			connect_right = {0.25, -0.5, -0.1875, 0.5, 0.3125, 0.1875}
		},
		connects_to = {"group:wall"},
		sounds = def.sounds,
		groups = wall_group
	})

	minetest.register_craft({
		output = "furniture:stool_"..subname,
		recipe = {
			{name, name},
			{name, name}
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

	minetest.register_abm({
		nodenames = {"furniture:stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local objs = minetest.get_objects_inside_radius(pos, 0.7)
			for k,v in pairs(objs) do
				local keys = v:get_player_control()
				if keys.sneak == true and default.player_attached[name] ~= true then
					local name = v:get_player_name()
					v:setpos(pos)
					default.player_attached[name] = true
					default.player_set_animation(v, "sit" , 0)
					minetest.after(0.5, furniture.stand, v, pos)
				end
			end
		end
	})
end

furniture.register_wooden("default:wood", {description = "Wooden"})
furniture.register_wooden("default:junglewood", {description="Junglewood"})
furniture.register_wooden("default:pine_wood", {description="Pine Wood"})
furniture.register_wooden("default:acacia_wood", {description="Acacia Wood"})
furniture.register_wooden("default:aspen_wood", {description="Aspen Wood"})

furniture.register_stone("default:cobble", {})
furniture.register_stone("default:mossycobble", {})
furniture.register_stone("default:desert_cobble", {})
