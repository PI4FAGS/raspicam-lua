local raspicam = {}

raspicam.defaults = {
	width = 2592,
	height = 1944,
	quality = 100,
	output = 'cam.jpg',
	timeout = 5,
	verticalflip = false,
	horizontalflip = false
}

--[[
	constructor & methods
]]

function raspicam:new()
	local o = {}
	o.params = setmetatable({}, { __index = self.defaults })
	return setmetatable(o, self)
end

function raspicam:command(async)
	local params = {
		o  = 'output',
		w  = 'width',
		h  = 'height',
		q  = 'quality',
		t  = 'timeout',
		vf = 'verticalflip',
		hf = 'horizontalflip'
	}
	local cmd = 'raspistill'
	for arg, param in pairs(params) do
		local value = self.params[param]
		if type(value) == 'boolean' then
			if value then
				cmd = cmd .. ' -' .. arg
			end
		else
			cmd = cmd .. ' -' .. arg .. ' ' .. value
		end
	end
	if async then
		cmd = cmd .. ' &'
	end
	return cmd
end

function raspicam:capture(async)
	os.execute(self:command(async))
end

--[[
	metamethods
]]

raspicam.__index = raspicam

function raspicam:__newindex(k, v)
	self.params[k] = v
end

return raspicam
