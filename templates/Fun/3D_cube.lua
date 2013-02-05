--Cube rectangles (frontface has points clockwise)
local cube = {
	-- Front
	{
		{-100, -100, 100},
		{100, -100, 100},
		{100, 100, 100},
		{-100, 100, 100}
	},
	-- Back
	{
		{100, -100, -100},
		{-100, -100, -100},
		{-100, 100, -100},
		{100, 100, -100}
	},
	-- Left
	{
		{-100, -100, -100},
		{-100, -100, 100},
		{-100, 100, 100},
		{-100, 100, -100}
	},
	-- Right
	{
		{100, -100, 100},
		{100, -100, -100},
		{100, 100, -100},
		{100, 100, 100}
	},
	-- Top
	{
		{-100, -100, -100},
		{100, -100, -100},
		{100, -100, 100},
		{-100, -100, 100}
	},
	-- Bottom
	{
		{100, 100, -100},
		{-100, 100, -100},
		{-100, 100, 100},
		{100, 100, 100}
	}
}
-- Frame-wise cube building (10s, 25 FPS)
local line = lines[1]
for s, e, i, n in utils.frames(0, 10000, 40) do
	line.start_time = s
	line.end_time = e
	-- Define rotations
	local x_rotation = i/n * 720
	local y_rotation = i/n * 720
	local z_rotation = i/n * 360
	-- Iterate through cube rectangles (copy)
	for rect_i, rect in ipairs(table.copy(cube)) do
		-- Rotate rectangle points
		for point_i = 1, #rect do
			rect[point_i] = math.rotate(math.rotate(math.rotate(rect[point_i], "x", x_rotation), "y", y_rotation), "z", z_rotation)
		end
		-- Calculate rectangle normal vector
		local vec_right = {rect[2][1] - rect[1][1], rect[2][2] - rect[1][2], rect[2][3] - rect[1][3]}
		local vec_down = {rect[4][1] - rect[1][1], rect[4][2] - rect[1][2], rect[4][3] - rect[1][3]}
		local normal = {
			vec_right[2] * vec_down[3] - vec_right[3] * vec_down[2],
			vec_right[3] * vec_down[1] - vec_right[3] * vec_down[3],
			vec_right[1] * vec_down[2] - vec_right[2] * vec_down[1]
		}
		-- Further process only for visible frontface
		if normal[3] > 0 then
			-- Calculate degree viewer <-> rectangle
			local deg = math.deg(
				math.acos(normal[3] / math.distance(normal[1], normal[2], normal[3]))
			)
			-- At last increase rectangle size 8-fold to shrink it next by \p4 for subpixel precision
			for point_i = 1, #rect do
				rect[point_i][1] = rect[point_i][1] * 8
				rect[point_i][2] = rect[point_i][2] * 8
			end
			-- Create rectangle dialog line
			line.text = string.format("{\\an7\\pos(300,200)\\bord0\\1c%s\\p4}m %d %d l %d %d %d %d %d %d"
									, utils.interpolate(deg / 90, "&HFFFFFF&", "&H000000&")
									, rect[1][1], rect[1][2], rect[2][1], rect[2][2], rect[3][1], rect[3][2], rect[4][1], rect[4][2])
			io.write_line(line)
		end
	end
end