furniture = {}

function furniture.stand(player, pos)
	local dist = vector.distance(player:getpos(), pos)
	if dist > 0.7 then
		player:set_physics_override({
			sneak = true
		})
		local name = player:get_player_name()
		default.player_attached[name] = false
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		default.player_set_animation(player, "stand" , 30)
	else
		minetest.after(0.3, furniture.stand, player, pos)
	end
end

local tp_seat = function(player, pos)
	player:setpos(pos)
end

local sit = function(pos, node)
	local objs = minetest.get_objects_inside_radius(pos, 0.7)
	for k,v in pairs(objs) do
		local keys = v:get_player_control()
		local name = v:get_player_name()
		if keys.sneak == true and default.player_attached[name] ~= true then
			v:set_physics_override({
				sneak = false
			})
			default.player_attached[name] = true
			v:set_eye_offset({x = 0, y = -6, z = 0}, {x = 0, y = 0, z = 0})
			default.player_set_animation(v, "sit" , 0)
			minetest.after(0.3, tp_seat, v, pos)
			minetest.after(0.3, furniture.stand, v, pos)
		end
	end
end

function furniture.register_seat(node_name)
	minetest.register_abm({
		nodenames = {node_name},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

function furniture.register_chair(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_chair")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Chair"
	end
	if not def.tiles then
		local tile = node_def.tiles[1]
		def.tiles = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_chair_modify.png^[makealpha:255,0,255)"}
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	minetest.register_node(":"..def.prefix.."chair_"..subname, {
		description = def.description,
		tiles = def.tiles,
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
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode ~= 1 then
				return false
			end
		end
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."chair_"..subname,
			recipe = {
				{def.stick, ""},
				{name, name},
				{def.stick, def.stick}
			}
		})

		minetest.register_craft({
			output = def.prefix.."chair_"..subname,
			recipe = {
				{"", def.stick},
				{name, name},
				{def.stick, def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {def.prefix.."chair_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

function furniture.register_stool(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_stool")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Stool"
	end
	if not def.tiles then
		local tile = node_def.tiles[1]
		def.tiles = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_chair_modify.png^[makealpha:255,0,255)"}
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	minetest.register_node(":"..def.prefix.."stool_"..subname, {
		description = def.description,
		tiles = def.tiles,
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

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."stool_"..subname,
			recipe = {
				{name, name},
				{def.stick, def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {def.prefix.."stool_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

function furniture.register_bench(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_bench")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Bench"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	local update = function(pos, node, node_north, node_east, node_south, node_west)
		if node.param2 == 0 or node.param2 == 2 then
			if node_west == false then node_west = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}) end
			if node_east == false then node_east = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}) end
			local connect = 0
			if node_west.param2 == node.param2 and
					(node_west.name == def.prefix.."bench_"..subname or node_west.name == def.prefix.."bench_middle_"..subname or
					node_west.name == def.prefix.."bench_right_"..subname or node_west.name == def.prefix.."bench_left_"..subname) then
				connect = 1
			end
			if node_east.param2 == node.param2 and
					(node_east.name == def.prefix.."bench_"..subname or node_east.name == def.prefix.."bench_middle_"..subname or
					node_east.name == def.prefix.."bench_right_"..subname or node_east.name == def.prefix.."bench_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = def.prefix.."bench_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = def.prefix.."bench_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."bench_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = def.prefix.."bench_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."bench_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_middle_"..subname, param2 = node.param2})
			end
		elseif node.param2 == 1 or node.param2 == 3 then
			if node_north == false then node_north = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}) end
			if node_south == false then node_south = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}) end
			local connect = 0
			if node_north.param2 == node.param2 and
					(node_north.name == def.prefix.."bench_"..subname or node_north.name == def.prefix.."bench_middle_"..subname or
					node_north.name == def.prefix.."bench_right_"..subname or node_north.name == def.prefix.."bench_left_"..subname) then
				connect = 1
			end
			if node_south.param2 == node.param2 and
					(node_south.name == def.prefix.."bench_"..subname or node_south.name == def.prefix.."bench_middle_"..subname or
					node_south.name == def.prefix.."bench_right_"..subname or node_south.name == def.prefix.."bench_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = def.prefix.."bench_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = def.prefix.."bench_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."bench_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = def.prefix.."bench_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."bench_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_middle_"..subname, param2 = node.param2})
			end
		end
	end

	local dig_node = function(pos, oldnode)
		local air = {name = "air", param2 = nil}
		if oldnode.param2 == 0 or oldnode.param2 == 2 then
			local west = {x = pos.x - 1, y = pos.y, z = pos.z}
			local east = {x = pos.x + 1, y = pos.y, z = pos.z}
			local node_west = minetest.get_node(west)
			local node_east = minetest.get_node(east)
			if node_west.param2 == oldnode.param2 and
					(node_west.name == def.prefix.."bench_"..subname or node_west.name == def.prefix.."bench_middle_"..subname or
					node_west.name == def.prefix.."bench_right_"..subname or node_west.name == def.prefix.."bench_left_"..subname) then
				update(west, node_west, false, air, false, false)
			end
			if node_east.param2 == oldnode.param2 and
					(node_east.name == def.prefix.."bench_"..subname or node_east.name == def.prefix.."bench_middle_"..subname or
					node_east.name == def.prefix.."bench_right_"..subname or node_east.name == def.prefix.."bench_left_"..subname) then
				update(east, node_east, false, false, false, air)
			end
		else
			local north = {x = pos.x, y = pos.y, z = pos.z + 1}
			local south = {x = pos.x, y = pos.y, z = pos.z - 1}
			local node_north = minetest.get_node(north)
			local node_south = minetest.get_node(south)
			if node_north.param2 == oldnode.param2 and
					(node_north.name == def.prefix.."bench_"..subname or node_north.name == def.prefix.."bench_middle_"..subname or
					node_north.name == def.prefix.."bench_right_"..subname or node_north.name == def.prefix.."bench_left_"..subname) then
				update(north, node_north, false, false, air, false)
			end
			if node_south.param2 == oldnode.param2 and
					(node_south.name == def.prefix.."bench_"..subname or node_south.name == def.prefix.."bench_middle_"..subname or
					node_south.name == def.prefix.."bench_right_"..subname or node_south.name == def.prefix.."bench_left_"..subname) then
				update(south, node_south, air, false, false, false)
			end
		end
	end

	local rotate = function(pos, node, new_param2)
		local north = {x = pos.x, y = pos.y, z = pos.z + 1}
		local east = {x = pos.x + 1, y = pos.y, z = pos.z}
		local south = {x = pos.x, y = pos.y, z = pos.z - 1}
		local west = {x = pos.x - 1, y = pos.y, z = pos.z}
		local node_north = minetest.get_node(north)
		local node_east = minetest.get_node(east)
		local node_south = minetest.get_node(south)
		local node_west = minetest.get_node(west)
		new_node = {name = node.name, param2 = new_param2}
		update(pos, new_node, node_north, node_east, node_south, node_west)
		if node_north.name == def.prefix.."bench_"..subname or node_north.name == def.prefix.."bench_middle_"..subname or
				node_north.name == def.prefix.."bench_right_"..subname or node_north.name == def.prefix.."bench_left_"..subname then
			update(north, node_north, false, false, new_node, false)
		end
		if node_east.name == def.prefix.."bench_"..subname or node_east.name == def.prefix.."bench_middle_"..subname or
				node_east.name == def.prefix.."bench_right_"..subname or node_east.name == def.prefix.."bench_left_"..subname then
			update(east, node_east, false, false, false, new_node)
		end
		if node_south.name == def.prefix.."bench_"..subname or node_south.name == def.prefix.."bench_middle_"..subname or
				node_south.name == def.prefix.."bench_right_"..subname or node_south.name == def.prefix.."bench_left_"..subname then
			update(south, node_south, new_node, false, false, false)
		end
		if node_west.name == def.prefix.."bench_"..subname or node_west.name == def.prefix.."bench_middle_"..subname or
				node_west.name == def.prefix.."bench_right_"..subname or node_west.name == def.prefix.."bench_left_"..subname then
			update(west, node_west, false, new_node, false, false)
		end
	end

	minetest.register_node(":"..def.prefix.."bench_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.125, -0.3125, 0.375, 0, 0.25},
				{-0.375, 0, 0.1875, 0.375, 0.4375, 0.25},
				{-0.5, -0.5, -0.3125, -0.375, 0.1875, 0.375},
				{0.375, -0.5, -0.3125, 0.5, 0.1875, 0.375},
				{-0.5, 0.1875, 0.1875, -0.375, 0.3125, 0.3125},
				{0.375, 0.1875, 0.1875, 0.5, 0.3125, 0.3125},
				{-0.5, 0.3125, 0.1875, -0.375, 0.5, 0.375},
				{0.375, 0.3125, 0.1875, 0.5, 0.5, 0.375}
			}
		},
		sounds = def.sounds,
		groups = def.groups,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = minetest.get_node(pos)
			update(pos, node, false, false, false, false)
			if node.param2 == 0 or node.param2 == 2 then
				local west = {x = pos.x - 1, y = pos.y, z = pos.z}
				local east = {x = pos.x + 1, y = pos.y, z = pos.z}
				local node_west = minetest.get_node(west)
				local node_east = minetest.get_node(east)
				if node_west.param2 == node.param2 and
						(node_west.name == def.prefix.."bench_"..subname or node_west.name == def.prefix.."bench_middle_"..subname or
						node_west.name == def.prefix.."bench_right_"..subname or node_west.name == def.prefix.."bench_left_"..subname) then
					update(west, node_west, false, false, false, false)
				end
				if node_east.param2 == node.param2 and
						(node_east.name == def.prefix.."bench_"..subname or node_east.name == def.prefix.."bench_middle_"..subname or
						node_east.name == def.prefix.."bench_right_"..subname or node_east.name == def.prefix.."bench_left_"..subname) then
					update(east, node_east, false, false, false, false)
				end
			else
				local north = {x = pos.x, y = pos.y, z = pos.z + 1}
				local south = {x = pos.x, y = pos.y, z = pos.z - 1}
				local node_north = minetest.get_node(north)
				local node_south = minetest.get_node(south)
				if node_north.param2 == node.param2 and
						(node_north.name == def.prefix.."bench_"..subname or node_north.name == def.prefix.."bench_middle_"..subname or
						node_north.name == def.prefix.."bench_right_"..subname or node_north.name == def.prefix.."bench_left_"..subname) then
					update(north, node_north, false, false, false, false)
				end
				if node_south.param2 == node.param2 and
						(node_south.name == def.prefix.."bench_"..subname or node_south.name == def.prefix.."bench_middle_"..subname or
						node_south.name == def.prefix.."bench_right_"..subname or node_south.name == def.prefix.."bench_left_"..subname) then
					update(south, node_south, false, false, false, false)
				end
			end
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_middle_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	local nocgroup = table.copy(def.groups)
	nocgroup.not_in_creative_inventory = 1

	minetest.register_node(":"..def.prefix.."bench_middle_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.125, -0.3125, 0.5, 0, 0.25},
				{-0.5, 0, 0.1875, 0.5, 0.4375, 0.25},
				{-0.5, -0.5, -0.3125, -0.4375, -0.125, 0.3125},
				{0.4375, -0.5, -0.3125, 0.5, -0.125, 0.3125},
				{-0.5, -0.125, 0.25, -0.4375, 0.375, 0.3125},
				{0.4375, -0.125, 0.25, 0.5, 0.375, 0.3125}
			}
		},
		drop = def.prefix.."bench_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_right_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":"..def.prefix.."bench_right_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.125, -0.3125, 0.5, 0, 0.25},
				{-0.375, 0, 0.1875, 0.5, 0.4375, 0.25},
				{-0.5, -0.5, -0.3125, -0.375, 0.1875, 0.375},
				{0.4375, -0.5, -0.3125, 0.5, -0.125, 0.3125},
				{-0.5, 0.1875, 0.1875, -0.375, 0.3125, 0.3125},
				{0.4375, -0.125, 0.25, 0.5, 0.375, 0.3125},
				{-0.5, 0.3125, 0.1875, -0.375, 0.5, 0.375}
			}
		},
		drop = def.prefix.."bench_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_left_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":"..def.prefix.."bench_left_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.125, -0.3125, 0.375, 0, 0.25},
				{-0.5, 0, 0.1875, 0.375, 0.4375, 0.25},
				{-0.5, -0.5, -0.3125, -0.4375, -0.125, 0.3125},
				{0.375, -0.5, -0.3125, 0.5, 0.1875, 0.375},
				{-0.5, -0.125, 0.25, -0.4375, 0.375, 0.3125},
				{0.375, 0.1875, 0.1875, 0.5, 0.3125, 0.3125},
				{0.375, 0.3125, 0.1875, 0.5, 0.5, 0.375}
			}
		},
		drop = def.prefix.."bench_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."bench_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."bench_"..subname,
			recipe = {
				{def.stick, def.stick, def.stick},
				{name, name, name},
				{def.stick, "", def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {def.prefix.."bench_"..subname, def.prefix.."bench_middle_"..subname, def.prefix.."bench_right_"..subname, def.prefix.."bench_left_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

function furniture.register_table(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_table")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Table"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.tiles then
		local tile = node_def.tiles[1]
		def.tiles = {tile, tile, tile.."^("..tile.."^[transformR90^furniture_table_modify.png^[makealpha:255,0,255)"}
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		groups.fence = 1
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.connects_to then
		def.connects_to = {"group:fence"}
	end

	minetest.register_node(":"..def.prefix.."table_"..subname, {
		description = def.description,
		tiles = def.tiles,
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
		connects_to = def.connects_to,
		sounds = def.sounds,
		groups = def.groups
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."table_"..subname,
			recipe = {
				{name, name, name},
				{"", name, ""},
				{"", name, ""}
			}
		})
	end
end

function furniture.register_stump(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_stump")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Stump"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = name
	end

	minetest.register_node(":"..def.prefix.."stump_"..subname, {
		description = def.description,
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

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."stump_"..subname,
			recipe = {
				{name, name},
				{def.stick, def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {def.prefix.."stump_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

function furniture.register_pedestal(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_pedestal")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Pedestal"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		groups.wall = 1
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.connects_to then
		def.connects_to = {"group:wall"}
	end

	minetest.register_node(":"..def.prefix.."pedestal_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			connect_front = {-0.1875, -0.5, -0.5, 0.1875, 0.5, -0.25},
			connect_left = {-0.5, -0.5, -0.1875, -0.25, 0.5, 0.1875},
			connect_back = {-0.1875, -0.5, 0.25, 0.1875, 0.5, 0.5},
			connect_right = {0.25, -0.5, -0.1875, 0.5, 0.5, 0.1875},
			disconnected_top = {-0.5, 0.25, -0.5, 0.5, 0.5, 0.5},
			disconnected_bottom = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}
		},
		connects_to = def.connects_to,
		sounds = def.sounds,
		groups = def.groups
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."pedestal_"..subname,
			recipe = {
				{name, name, name},
				{"", name, ""},
				{"", name, ""}
			}
		})
	end
end

function furniture.register_couch(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_couch")
		end
		return
	end
	if not def.prefix then
		def.prefix = minetest.get_current_modname()..":"
	end
	local subname = name:split(':')[2]
	if not def.description then
		def.description = node_def.description.." Couch"
	end
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wood = 0
		groups.planks = 0
		groups.stone = 0
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	local update = function(pos, node, node_north, node_east, node_south, node_west)
		if node.param2 == 0 or node.param2 == 2 then
			if node_west == false then node_west = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}) end
			if node_east == false then node_east = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}) end
			local connect = 0
			if node_west.param2 == node.param2 and
					(node_west.name == def.prefix.."couch_"..subname or node_west.name == def.prefix.."couch_middle_"..subname or
					node_west.name == def.prefix.."couch_right_"..subname or node_west.name == def.prefix.."couch_left_"..subname) then
				connect = 1
			end
			if node_east.param2 == node.param2 and
					(node_east.name == def.prefix.."couch_"..subname or node_east.name == def.prefix.."couch_middle_"..subname or
					node_east.name == def.prefix.."couch_right_"..subname or node_east.name == def.prefix.."couch_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = def.prefix.."couch_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = def.prefix.."couch_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."couch_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = def.prefix.."couch_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."couch_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_middle_"..subname, param2 = node.param2})
			end
		elseif node.param2 == 1 or node.param2 == 3 then
			if node_north == false then node_north = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}) end
			if node_south == false then node_south = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}) end
			local connect = 0
			if node_north.param2 == node.param2 and
					(node_north.name == def.prefix.."couch_"..subname or node_north.name == def.prefix.."couch_middle_"..subname or
					node_north.name == def.prefix.."couch_right_"..subname or node_north.name == def.prefix.."couch_left_"..subname) then
				connect = 1
			end
			if node_south.param2 == node.param2 and
					(node_south.name == def.prefix.."couch_"..subname or node_south.name == def.prefix.."couch_middle_"..subname or
					node_south.name == def.prefix.."couch_right_"..subname or node_south.name == def.prefix.."couch_left_"..subname) then
				connect = connect + 2
			end
			if connect == 0 then
				minetest.swap_node(pos, {name = def.prefix.."couch_"..subname, param2 = node.param2})
			elseif connect == 1 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = def.prefix.."couch_left_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."couch_right_"..subname, param2 = node.param2})
				end
			elseif connect == 2 then
				if node.param2 == 1 then
					minetest.swap_node(pos, {name = def.prefix.."couch_right_"..subname, param2 = node.param2})
				else
					minetest.swap_node(pos, {name = def.prefix.."couch_left_"..subname, param2 = node.param2})
				end
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_middle_"..subname, param2 = node.param2})
			end
		end
	end

	local dig_node = function(pos, oldnode)
		local air = {name = "air", param2 = nil}
		if oldnode.param2 == 0 or oldnode.param2 == 2 then
			local west = {x = pos.x - 1, y = pos.y, z = pos.z}
			local east = {x = pos.x + 1, y = pos.y, z = pos.z}
			local node_west = minetest.get_node(west)
			local node_east = minetest.get_node(east)
			if node_west.param2 == oldnode.param2 and
					(node_west.name == def.prefix.."couch_"..subname or node_west.name == def.prefix.."couch_middle_"..subname or
					node_west.name == def.prefix.."couch_right_"..subname or node_west.name == def.prefix.."couch_left_"..subname) then
				update(west, node_west, false, air, false, false)
			end
			if node_east.param2 == oldnode.param2 and
					(node_east.name == def.prefix.."couch_"..subname or node_east.name == def.prefix.."couch_middle_"..subname or
					node_east.name == def.prefix.."couch_right_"..subname or node_east.name == def.prefix.."couch_left_"..subname) then
				update(east, node_east, false, false, false, air)
			end
		else
			local north = {x = pos.x, y = pos.y, z = pos.z + 1}
			local south = {x = pos.x, y = pos.y, z = pos.z - 1}
			local node_north = minetest.get_node(north)
			local node_south = minetest.get_node(south)
			if node_north.param2 == oldnode.param2 and
					(node_north.name == def.prefix.."couch_"..subname or node_north.name == def.prefix.."couch_middle_"..subname or
					node_north.name == def.prefix.."couch_right_"..subname or node_north.name == def.prefix.."couch_left_"..subname) then
				update(north, node_north, false, false, air, false)
			end
			if node_south.param2 == oldnode.param2 and
					(node_south.name == def.prefix.."couch_"..subname or node_south.name == def.prefix.."couch_middle_"..subname or
					node_south.name == def.prefix.."couch_right_"..subname or node_south.name == def.prefix.."couch_left_"..subname) then
				update(south, node_south, air, false, false, false)
			end
		end
	end

	local rotate = function(pos, node, new_param2)
		local north = {x = pos.x, y = pos.y, z = pos.z + 1}
		local east = {x = pos.x + 1, y = pos.y, z = pos.z}
		local south = {x = pos.x, y = pos.y, z = pos.z - 1}
		local west = {x = pos.x - 1, y = pos.y, z = pos.z}
		local node_north = minetest.get_node(north)
		local node_east = minetest.get_node(east)
		local node_south = minetest.get_node(south)
		local node_west = minetest.get_node(west)
		new_node = {name = node.name, param2 = new_param2}
		update(pos, new_node, node_north, node_east, node_south, node_west)
		if node_north.name == def.prefix.."couch_"..subname or node_north.name == def.prefix.."couch_middle_"..subname or
				node_north.name == def.prefix.."couch_right_"..subname or node_north.name == def.prefix.."couch_left_"..subname then
			update(north, node_north, false, false, new_node, false)
		end
		if node_east.name == def.prefix.."couch_"..subname or node_east.name == def.prefix.."couch_middle_"..subname or
				node_east.name == def.prefix.."couch_right_"..subname or node_east.name == def.prefix.."couch_left_"..subname then
			update(east, node_east, false, false, false, new_node)
		end
		if node_south.name == def.prefix.."couch_"..subname or node_south.name == def.prefix.."couch_middle_"..subname or
				node_south.name == def.prefix.."couch_right_"..subname or node_south.name == def.prefix.."couch_left_"..subname then
			update(south, node_south, new_node, false, false, false)
		end
		if node_west.name == def.prefix.."couch_"..subname or node_west.name == def.prefix.."couch_middle_"..subname or
				node_west.name == def.prefix.."couch_right_"..subname or node_west.name == def.prefix.."couch_left_"..subname then
			update(west, node_west, false, new_node, false, false)
		end
	end

	minetest.register_node(":"..def.prefix.."couch_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.3125, -0.3125, 0.1875, 0.3125},
				{0.3125, 0, -0.3125, 0.5, 0.1875, 0.3125}
			}
		},
		sounds = def.sounds,
		groups = def.groups,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = minetest.get_node(pos)
			update(pos, node, false, false, false, false)
			if node.param2 == 0 or node.param2 == 2 then
				local west = {x = pos.x - 1, y = pos.y, z = pos.z}
				local east = {x = pos.x + 1, y = pos.y, z = pos.z}
				local node_west = minetest.get_node(west)
				local node_east = minetest.get_node(east)
				if node_west.param2 == node.param2 and
						(node_west.name == def.prefix.."couch_"..subname or node_west.name == def.prefix.."couch_middle_"..subname or
						node_west.name == def.prefix.."couch_right_"..subname or node_west.name == def.prefix.."couch_left_"..subname) then
					update(west, node_west, false, false, false, false)
				end
				if node_east.param2 == node.param2 and
						(node_east.name == def.prefix.."couch_"..subname or node_east.name == def.prefix.."couch_middle_"..subname or
						node_east.name == def.prefix.."couch_right_"..subname or node_east.name == def.prefix.."couch_left_"..subname) then
					update(east, node_east, false, false, false, false)
				end
			else
				local north = {x = pos.x, y = pos.y, z = pos.z + 1}
				local south = {x = pos.x, y = pos.y, z = pos.z - 1}
				local node_north = minetest.get_node(north)
				local node_south = minetest.get_node(south)
				if node_north.param2 == node.param2 and
						(node_north.name == def.prefix.."couch_"..subname or node_north.name == def.prefix.."couch_middle_"..subname or
						node_north.name == def.prefix.."couch_right_"..subname or node_north.name == def.prefix.."couch_left_"..subname) then
					update(north, node_north, false, false, false, false)
				end
				if node_south.param2 == node.param2 and
						(node_south.name == def.prefix.."couch_"..subname or node_south.name == def.prefix.."couch_middle_"..subname or
						node_south.name == def.prefix.."couch_right_"..subname or node_south.name == def.prefix.."couch_left_"..subname) then
					update(south, node_south, false, false, false, false)
				end
			end
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_middle_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	local nocgroup = table.copy(def.groups)
	nocgroup.not_in_creative_inventory = 1

	minetest.register_node(":"..def.prefix.."couch_middle_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5}
			}
		},
		drop = def.prefix.."couch_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_right_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":"..def.prefix.."couch_right_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.3125, -0.3125, 0.1875, 0.3125}
			}
		},
		drop = def.prefix.."couch_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_left_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	minetest.register_node(":"..def.prefix.."couch_left_"..subname, {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.3125, 0.5, 0, 0.5},
				{-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
				{0.3125, 0, -0.3125, 0.5, 0.1875, 0.3125}
			}
		},
		drop = def.prefix.."couch_"..subname,
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			dig_node(pos, oldnode)
		end,
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode == 1 then
				rotate(pos, node, new_param2)
			else
				minetest.swap_node(pos, {name = def.prefix.."couch_"..subname, param2 = node.param2})
			end
			return true
		end
	})

	if def.handle_crafts ~= false then
		minetest.register_craft({
			output = def.prefix.."couch_"..subname,
			recipe = {
				{name, "", name},
				{name, name, name},
				{def.stick, def.stick, def.stick}
			}
		})
	end

	minetest.register_abm({
		nodenames = {def.prefix.."couch_"..subname, def.prefix.."couch_middle_"..subname, def.prefix.."couch_right_"..subname,
				def.prefix.."couch_left_"..subname},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			sit(pos, node)
		end
	})
end

--[[ legacy API ]]
function furniture.register_wooden(name, def)
	minetest.log("warning", "["..minetest.get_current_modname().."] using legacy API furniture.register_wooden")
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
	if not def.description_bench then
		def.description_bench = def.description.." Bench"
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
	local fence_group = table.copy(def.groups)
	fence_group.fence = 1

	furniture.register_chair(name, {
		prefix = "furniture:",
		description = def.description_chair,
		tiles = def.tiles_chair,
		sounds = def.sounds,
		groups = def.groups,
		stick = def.stick,
		handle_crafts = def.handle_crafts
	})

	furniture.register_stool(name, {
		prefix = "furniture:",
		description = def.description_stool,
		tiles = def.tiles_chair,
		sounds = def.sounds,
		groups = def.groups,
		stick = def.stick,
		handle_crafts = def.handle_crafts
	})

	furniture.register_bench(name, {
		prefix = "furniture:",
		description = def.description_bench,
		tiles = def.tiles,
		sounds = def.sounds,
		groups = def.groups,
		stick = def.stick,
		handle_crafts = def.handle_crafts
	})

	furniture.register_table(name, {
		prefix = "furniture:",
		description = def.description_table,
		tiles = def.tiles_table,
		sounds = def.sounds,
		groups = fence_group,
		handle_crafts = def.handle_crafts
	})
end

function furniture.register_stone(name, def)
	minetest.log("warning", "["..minetest.get_current_modname().."] using legacy API furniture.register_stone")
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
		def.description_table = def.description.." Pedestal"
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

	furniture.register_stump(name, {
		prefix = "furniture:",
		description = def.description_stool,
		tiles = def.tiles,
		sounds = def.sounds,
		groups = def.groups,
		handle_crafts = def.handle_crafts
	})

	minetest.register_alias("furniture:stool_"..subname, "furniture:stump_"..subname)

	local wall_group = table.copy(def.groups)
	wall_group.wall = 1

	furniture.register_pedestal(name, {
		prefix = "furniture:",
		description = def.description_table,
		tiles = def.tiles,
		sounds = def.sounds,
		groups = wall_group,
		handle_crafts = def.handle_crafts
	})

	minetest.register_alias("furniture:table_"..subname, "furniture:pedestal_"..subname)
end

function furniture.register_wool(name, def)
	minetest.log("warning", "["..minetest.get_current_modname().."] using legacy API furniture.register_wool")
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "furniture" then
			minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function furniture.register_wool")
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
	if not def.tiles then
		def.tiles = node_def.tiles
	end
	if not def.groups then
		local groups = table.copy(node_def.groups)
		groups.wool = 0
		def.groups = groups
	end
	if not def.sounds then
		def.sounds = node_def.sounds
	end
	if not def.stick then
		def.stick = "group:stick"
	end

	furniture.register_couch(name, {
		prefix = "furniture:",
		description = def.description_chair,
		tiles = def.tiles,
		sounds = def.sounds,
		groups = def.groups,
		stick = def.stick,
		handle_crafts = def.handle_crafts
	})

	minetest.register_alias("furniture:chair_"..subname, "furniture:couch_"..subname)
	minetest.register_alias("furniture:chair_middle_"..subname, "furniture:couch_middle_"..subname)
	minetest.register_alias("furniture:chair_left_"..subname, "furniture:couch_left_"..subname)
	minetest.register_alias("furniture:chair_right_"..subname, "furniture:couch_right_"..subname)

	furniture.register_stump(name, {
		prefix = "furniture:",
		description = def.description_stool,
		tiles = def.tiles,
		sounds = def.sounds,
		groups = def.groups,
		stick = def.stick,
		handle_crafts = def.handle_crafts
	})

	minetest.register_alias("furniture:stool_"..subname, "furniture:stump_"..subname)
end
--]]

for _,v in ipairs({"tree", "jungletree", "pine_tree", "acacia_tree", "aspen_tree"}) do
	furniture.register_stump("default:"..v, {prefix = "furniture:"})
end

for _,v in ipairs({
	{"wood", "Wooden"},
	{"junglewood", "Junglewood"},
	{"pine_wood", "Pine Wood"},
	{"acacia_wood", "Acacia Wood"},
	{"aspen_wood", "Aspen Wood"}
}) do
	furniture.register_chair("default:"..v[1], {prefix = "furniture:", description = v[2].." Chair"})
	furniture.register_stool("default:"..v[1], {prefix = "furniture:", description = v[2].." Stool"})
	furniture.register_bench("default:"..v[1], {prefix = "furniture:", description = v[2].." Bench"})
	furniture.register_table("default:"..v[1], {
		prefix = "furniture:",
		description = v[2].." Table",
		tiles = {"default_"..v[1]..".png", "default_"..v[1]..".png", "default_"..v[1]..".png^[lowpart:87:default_fence_"..v[1]..".png"}
	})
end

for _,v in ipairs({{"cobble", "Cobblestone"}, {"mossycobble", "Mossy Cobblestone"}, {"desert_cobble", "Desert Cobblestone"}}) do
	furniture.register_stump("default:"..v[1], {prefix = "furniture:", description = v[2].." Stool"})
	furniture.register_pedestal("default:"..v[1], {prefix = "furniture:", description = v[2].." Pedestal"})
	minetest.register_alias("furniture:stool_"..v[1], "furniture:stump_"..v[1]) --legacy alias
	minetest.register_alias("furniture:table_"..v[1], "furniture:pedestal_"..v[1]) --legacy alias
end

if minetest.get_modpath("dye") and minetest.get_modpath("wool") then
	for _,v in ipairs(dye.dyes) do
		furniture.register_couch("wool:"..v[1], {prefix = "furniture:wool_", description = v[2].." Wool Chair"})
		furniture.register_stump("wool:"..v[1], {prefix = "furniture:wool_", description = v[2].." Wool Ottoman", stick = "group:stick"})
		minetest.register_alias("furniture:chair_"..v[1], "furniture:wool_couch_"..v[1]) --legacy alias
		minetest.register_alias("furniture:chair_middle_"..v[1], "furniture:wool_couch_middle_"..v[1]) --legacy alias
		minetest.register_alias("furniture:chair_left_"..v[1], "furniture:wool_couch_left_"..v[1]) --legacy alias
		minetest.register_alias("furniture:chair_right_"..v[1], "furniture:wool_couch_right_"..v[1]) --legacy alias
		minetest.register_alias("furniture:stool_"..v[1], "furniture:wool_stump_"..v[1]) --legacy alias
	end
end

if minetest.get_modpath("xdecor") then
	minetest.override_item("xdecor:chair", {
		on_rightclick = function()
			return nil
		end
	})
	minetest.override_item("xdecor:cushion", {
		on_rightclick = function()
			return nil
		end
	})
	furniture.register_seat("xdecor:chair")
	furniture.register_seat("xdecor:cushion")
end
