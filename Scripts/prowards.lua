-- Made by Staskkk.
-- This script shows you professional (the best) positions for observer wards.
-- Some wards shows for Radiant, some for Dire, some for both.
-- Array of wards team: 1 = BOTH teams, 2 = Radiant, 3 = Dire. Type = type of effect.
-- Type of wards: 1 = rune (red), 2 = extra (red), 3 = gank or def (red),
-- 4 = wood (blue), 5 = push (blue), 6 = situational (blue).
-- I don't have effects for each type,
-- which we can see in darkness (only red and blue fires), so effects repeat.
-- Number of wards you can check on minimap screen.

wards = {
	{ x = -2173, y = 2664, z = 256, team = 1, type = 1 }, --1
	{ x = -3421, y = 2163, z = 384, team = 1, type = 1 }, --2
	{ x = -934, y = 1199, z = 128, team = 1, type = 1 }, --3
	{ x = -1675, y = 600, z = 128, team = 1, type = 1 }, --4
	{ x = -2001, y = 403, z = 256, team = 1, type = 1 }, --5
	{ x = 2197, y = -1100, z = 127, team = 1, type = 1 }, --6
	{ x = 3451, y = -2402, z = 256, team = 1, type = 1 }, --7
	{ x = 2498, y = -2507, z = 260, team = 1, type = 1 }, --8
	{ x = 1654, y = -2746, z = 256, team = 1, type = 1 }, --9
	--10 not worked
	{ x = 3119, y = -2966, z = 256, team = 3, type = 1 }, --11
	{ x = 2308, y = -3189, z = 253, team = 3, type = 1 }, --12
	{ x = 4107, y = -3545, z = 256, team = 1, type = 1 }, --13
--
	{ x = 1037, y = 4742, z = 512, team = 1, type = 2 }, --14
	{ x = -1558, y = -4414, z = 497, team = 1, type = 2 }, --15
--
	{ x = -5057, y = 3818, z = 256, team = 3, type = 3 }, --16
	{ x = -6595, y = 3123, z = 256, team = 3, type = 3 }, --17
	{ x = -132, y = 2405, z = 256, team = 1, type = 3 }, --18
	{ x = -338, y = 509, z = 125, team = 2, type = 3 }, --19
	{ x = 3546, y = 492, z = 256, team = 1, type = 3 }, --20
	{ x = -1419, y = -349, z = 128, team = 3, type = 3 }, --21
	{ x = 840, y = -691, z = 128, team = 2, type = 3 }, --22
	{ x = 9, y = -1011, z = 128, team = 3, type = 3 }, --23
	{ x = -4050, y = -2207, z = 256, team = 2, type = 3 }, --24
	{ x = 5746, y = -2803, z = 256, team = 2, type = 3 }, --25
	{ x = 5336, y = -3171, z = 258, team = 2, type = 3 }, --26
--27 missed
	{ x = -3339, y = 5014, z = 256, team = 2, type = 4 }, --28
	{ x = -3869, y = 4132, z = 256, team = 2, type = 4 }, --29
	{ x = -3358, y = 4004, z = 256, team = 2, type = 4 }, --30
	{ x = -1207, y = 4044, z = 256, team = 2, type = 4 }, --31
	{ x = 4127, y = -578, z = 254, team = 1, type = 4 }, --32
	{ x = 773, y = -2519, z = 256, team = 1, type = 4 }, --33
	{ x = 2294, y = -4294, z = 256, team = 3, type = 4 }, --34
	{ x = 1944, y = -4769, z = 256, team = 3, type = 4 }, --35
	{ x = 3605, y = -5228, z = 256, team = 3, type = 4 }, --36
--
	{ x = -6182, y = 642, z = 256, team = 3, type = 5 }, --37
	{ x = -6310, y = -1784, z = 265, team = 3, type = 5 }, --38
	{ x = -5586, y = -1995, z = 255, team = 3, type = 5 }, --39
	{ x = -2525, y = -1955, z = 127, team = 3, type = 5 }, --40
	{ x = -3782, y = -3677, z = 128, team = 3, type = 5 }, --41
	{ x = 3578, y = -6060, z = 256, team = 3, type = 5 }, --42
	{ x = -1442, y = -5770, z = 256, team = 3, type = 5 }, --43
	{ x = -5412, y = -3366, z = 261, team = 3, type = 5 }, --44
	{ x = -3808, y = -4985, z = 261, team = 3, type = 5 }, --45
	{ x = -3388, y = 5872, z = 256, team = 2, type = 5 }, --46
	{ x = 851, y = 5455, z = 256, team = 2, type = 5 }, --47
	{ x = 1679, y = 1218, z = 127, team = 2, type = 5 }, --48
	{ x = 3307, y = 2964, z = 127, team = 2, type = 5 }, --49
	{ x = 6024, y = -657, z = 256, team = 2, type = 5 }, --50
	{ x = 3144, y = 6629, z = 256, team = 2, type = 5 }, --51
	{ x = 3323, y = 4756, z = 256, team = 2, type = 5 }, --52
	{ x = 5103, y = 2964, z = 256, team = 2, type = 5 }, --53
--
	{ x = -5892, y = 5669, z = 256, team = 2, type = 6 }, --54
	{ x = -2718, y = 4337, z =256, team = 2, type = 6 }, --55
	{ x = -3504, y = 4537, z = 256, team = 2, type = 6 }, --missed
	{ x = -149, y = 1699, z = 271, team = 1, type = 6 }, --56
	{ x = 3656, y = 1121, z = 269, team = 1, type = 6 }, --57
	{ x = 6295, y = 993, z = 269, team = 2, type = 6 }, --58
	{ x = 5437, y = -219, z = 256, team = 2, type = 6 }, --59
	{ x = -3341, y = -1641, z = 253, team = 2, type = 6 }, --60
	{ x = 3795, y = -4430, z = 256, team = 3, type = 6 }, --61
	{ x = 2666, y = -4356, z = 256, team = 3, type = 6 }, --missed
	{ x = 5844, y = -5559, z = 256, team = 3, type = 6 } --62
}
effects = { }
registered = false

function Tick(tick)
	if not client.connected or client.loading then
		return
	end
	me = entityList:GetMyPlayer()
	for i = 1,#wards do
		if wards[i].team == 1 or wards[i].team == me.team then
			if wards[i].type == 1 then ef = "fire_camp_02" end
			if wards[i].type == 2 then ef = "fire_camp_01" end
			if wards[i].type == 3 then ef = "fire_camp_02" end
			if wards[i].type == 4 then ef = "blueTorch_flame" end
			if wards[i].type == 5 then ef = "blueTorch_flame" end
			if wards[i].type == 6 then ef = "blueTorch_flame" end
			vec = Vector( wards[i].x, wards[i].y, wards[i].z)
			effects[i] = Effect( vec, ef)
			effects[i]:SetVector( 0, vec)
		end
	end
	print("Prowards registered!")
	script:UnregisterEvent(Tick)
end

function Load()
	if registered then return end
	script:RegisterEvent(EVENT_TICK,Tick)
	registered = true
end

function Close()
	effects = { }
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
