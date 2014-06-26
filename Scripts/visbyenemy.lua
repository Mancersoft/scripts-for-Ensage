-- Made by Staskkk.

require("libs.Utils")

-- config
xx = 254 -- x parameter of left-top corner of top bar heroes of your team.
yy = 5 -- y parameter of left-top corner of top bar heroes of your team.
ww = 59 -- width of heroes icons.
hh = 32 -- height of heroes icons.
centwidth = 181 -- distance between icons of heroes of different teams.

-- code
sleeptick = 0
panel = {}
init = false

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP and code == hotkey then
		activated = not activated
	end
end

function Tick(tick)
	if not client.connected or client.loading or client.console or tick <= sleeptick or not entityList:GetMyHero() then
		return
	end
	sleeptick = tick + 200
	if not init then
		mp = entityList:GetMyPlayer()
		init = true
	end
	if not couriers or #couriers == 0 then
		couriers = entityList:GetEntities({type=LuaEntity.TYPE_COURIER, team = mp.team, alive=true})
		if #couriers ~= 0 then
			pos = couriers[1].position
		end
	end
	local heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = mp.team, illusion = false})
	for i,v in ipairs(heroes) do
		if not panel[v.handle] then
			if v.team == 3 then
				selftop = centwidth
			else
				selftop = 0
			end
			panel[v.handle] = drawMgr:CreateRect(xx+v.playerId*ww+selftop,yy,ww,hh,0x5050ffff,true)
			panel[v.handle].visible = true
		end
		if panel[v.handle].outline then
			if not v.visible or not v.alive then
				panel[v.handle].color = 0x808080ff
			else
				panel[v.handle].color = 0x5050ffff
			end
		end

		if v.alive and v.visibleToEnemy then
			if panel[v.handle].outline then
				panel[v.handle].color = 0x5050ff88
				panel[v.handle].outline = false
			end
		elseif not panel[v.handle].outline then
			panel[v.handle].color = 0x5050ffff
			panel[v.handle].outline = true
		end
	end
end

function Close()
	panel = {}
	init = false
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_CLOSE,Close)
