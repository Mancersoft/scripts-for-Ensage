-- Made by Staskkk.

require("libs.Utils")
-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Xcord", 254)
config:SetParameter("Ycord", 5)
config:SetParameter("Width", 59)
config:SetParameter("Height", 32)
config:SetParameter("Centwidth", 181)
config:Load()

-- config
xx = config.Xcord -- x parameter of left-top corner of top bar heroes of your team.
yy = config.Ycord -- y parameter of left-top corner of top bar heroes of your team.
ww = config.Width -- width of heroes icons.
hh = config.Height -- height of heroes icons.
centwidth = config.Centwidth -- distance between icons of heroes of different teams.

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
		me = entityList:GetMyHero()
		init = true
	end
	if not couriers or #couriers == 0 then
		couriers = entityList:GetEntities({type=LuaEntity.TYPE_COURIER, team = me.team, alive=true})
		if #couriers ~= 0 then
			pos = couriers[1].position
		end
	end
	local heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = me.team, illusion = false})
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
