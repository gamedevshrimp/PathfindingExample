--- grid.lua
--- The coordinate system of a map. 
--- Provides the functions for working with a map.
--- The world origin (0, 0) is at the bottom-left corner of the map.
--- X increases from left to right, while Z decreases from bottom to top.
local M = {}

M.WIDTH = 50
M.HEIGHT = 50
M.CELL_SIZE = 1

M.MIN_Z = 0
M.MAX_Z = 50

M.COLUMNS = 50
M.ROWS = 50


--- Converts world position to cell coordinates.
---@param position vector3 The world position
---@return table | nil cell Returns a table with cell coordinates
function M.world_to_cell(position)
	if position.x < 0 or position.x >= M.WIDTH then
		return nil
	end
	if position.z < M.MIN_Z or position.z >= M.MAX_Z then
		return nil
	end

	-- X increases from left to right
	local cell_x = math.floor(position.x / M.CELL_SIZE) + 1

	-- Z increases to the bottom edge
	-- That is why the row calculated relative to MIN_Z
	local cell_z = math.floor((position.z - M.MIN_Z) / M.CELL_SIZE) + 1
	return { x = cell_x, z = cell_z }
end

--- Converts cell coordinates to world position.
--- Assumes the Y position is 0.
---@param cell_x number The X cell coordinate
---@param cell_z number The Z cell coordinate
---@return vector3 position The world position of the cell's center on the XZ-plane
function M.cell_to_world(cell_x, cell_z)
	local world_x = (cell_x - 1 + 0.5) * M.CELL_SIZE
	local world_z = M.MIN_Z + (cell_z - 1 + 0.5) * M.CELL_SIZE

	return vmath.vector3(world_x, 0, world_z)
end

--- Checks if the cell is placed inside the world map.
---@param cell_x number The X cell coordinate
---@param cell_z number The Z cell coordinate
---@return boolean status Is the cell inside the world map
function M.is_inside(cell_x, cell_z)
	return cell_x >= 1
		and cell_x <= M.COLUMNS
		and cell_z >= 1
		and cell_z <= M.ROWS
end

--- Converts cell's coordinates to the index in the array.
--- The array stores rows sequentially:
--- first the entire first row, then the second, and so on.
---@param cell_x number The X cell coordinate
---@param cell_z number The Z cell coordinate
---@return number index The index of cell in the table
function M.get_index(cell_x, cell_z)
	return (cell_z - 1) * M.COLUMNS + cell_x
end

return M
