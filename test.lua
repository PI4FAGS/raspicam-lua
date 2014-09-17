#!/usr/bin/env lua5.2

local numpictures = tonumber(... or 1)

local raspicam = require 'raspicam'

local capture = raspicam:new()
capture.width = 1920
capture.height = 1080
capture.timeout = 3000

local function sleep(duration)
	os.execute('sleep ' .. (duration / 1000) .. 's')
end

for i = 1, numpictures do
	local output = string.format('picture%04d.jpg', i)
	print(output)
	capture.output = output
	if i < numpictures then
		capture:capture(true)
		sleep(10000)
	else
		capture:capture()
	end
end
