--- navigation.lua

local grid = require "main.modules.grid"
local M = {}

local CELLS_PER_FRAME = 50
local OBSTACLE_GROUPS = { hash("navigation_obstacle") }

local RAY_TOP = 100
local RAY_BOTTOM = -100

local point_offset = 0.3
local SAMPLE_POINTS = {
	{ 0,             0 },
	{ -point_offset, -point_offset },
	{ point_offset,  -point_offset },
	{ -point_offset, point_offset },
	{ point_offset,  point_offset }
}


--- Casts the ray
---@param x number The X coordinate
---@param z number The Z coordinate
---@return boolean | nil result If the ray find the obstacle returns true
local function has_obstacle(x, z)
	local from = vmath.vector3(x, RAY_TOP, z)
	local to = vmath.vector3(x, RAY_BOTTOM, z)
	local result = physics.raycast(from, to, OBSTACLE_GROUPS)

	return result ~= nil
end


--- Checks if the cell is blocked
---@param cell_x number The X coordinate
---@param cell_z number The Z coordinate
---@return boolean result If the cell is blocked returns true
local function is_cell_blocked(cell_x, cell_z)
	local center = grid.cell_to_world(cell_x, cell_z)
	for _, offset in ipairs(SAMPLE_POINTS) do
		local x = center.x + offset[1] * grid.CELL_SIZE
		local z = center.z + offset[2] * grid.CELL_SIZE

		if has_obstacle(x, z) then
			return true
		end
	end
	return false
end


--- Creates the empty map
---@return table map The empty map
---return schema { world = {...}, scan_index = 1, finished = false }
function M.begin_scan()
	local map = {}
	map.cells = {}

	for i = 1, grid.COLUMNS * grid.ROWS do
		map.cells[i] = 0
	end

	-- Sets up index for the first cell
	map.scan_index = 1
	map.finished = false

	return map
end

--- Gradual scans of the map
--- Returns true, then whole map is scanned.
function M.scan_step(map)
	if map.finished then
		return true
	end

	local total_cells = grid.COLUMNS * grid.ROWS
	local processed = 0

	while map.scan_index <= total_cells
		and processed < CELLS_PER_FRAME do
		local index = map.scan_index

		local cell_x = ((index - 1) % grid.COLUMNS) + 1
		local cell_z = math.floor((index - 1) / grid.COLUMNS) + 1


		if is_cell_blocked(cell_x, cell_z) then
			map.cells[index] = 1
		else
			map.cells[index] = 0
		end

		map.scan_index = map.scan_index + 1
		processed = processed + 1
	end

	if map.scan_index > total_cells then
		map.finished = true
		print("Navigation map scan completed!")
		return true
	end

	return false
end

return M
