#!/usr/bin/env lua5.2

local numpictures = tonumber(... or 1)
local interval = tonumber(select(2, ...) or 10000)

if interval < 3000 then
	interval = 3000
	print 'interval to low, set to 3000'
end

local function remainingtime(i, numpictures, interval)
	local remainingseconds = (numpictures - i) * (interval / 1000)
	local remainingminutes = 0
	if remainingseconds >= 60 then
		remainingminutes = math.floor(remainingseconds / 60)
		remainingseconds = remainingseconds % 60
	end
	local remaininghours = 0
	if remainingminutes >= 60 then
		remaininghours = math.floor(remainingminutes / 60)
		remainingminutes = remainingminutes % 60
	end
	local remainingdays = 0
	if remaininghours >= 24 then
		remainingdays = math.floor(remaininghours / 24)
		remaininghours = remaininghours % 24
	end
	if remainingdays > 0 then
		return string.format('%dd %02dh %02dm %02ds', remainingdays, remaininghours, remainingminutes, remainingseconds)
	elseif remaininghours > 0 then
		return string.format('%02dh %02dm %02ds', remaininghours, remainingminutes, remainingseconds)
	elseif remainingminutes > 0 then
		return string.format('%02dm %02ds', remainingminutes, remainingseconds)
	else
		return string.format('%02ds', remainingseconds)
	end
end

print(numpictures .. ' pictures total.\n1 picture each ' .. interval .. 'ms.\nIt will take ' .. remainingtime(0, numpictures, interval))

local raspicam = require 'raspicam'

local capture = raspicam:new()
capture.width = 1920
capture.height = 1080
capture.timeout = 3000

local function mkdir(dir)
	os.execute('mkdir -p ' .. dir)
end

local function sleep(duration)
	os.execute('sleep ' .. (duration / 1000) .. 's')
end

mkdir 'pictures'

for i = 1, numpictures do
	local output = string.format('pictures/picture%04d.jpg', i)
	io.write('\r' .. output .. ' - ' .. remainingtime(i, numpictures, interval) .. ' remaining                        ')
	io.flush()
	capture.output = output
	if i < numpictures then
		capture:capture(true)
		sleep(interval)
	else
		capture:capture()
	end
end

print()
