--<<Shows timing Glimpse and for Disruptor where spell return enemies>>
-- Made by Staskkk.
-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("SizeBig", 60)
config:SetParameter("SizeFont", 20)
config:SetParameter("SizeMini", 16)
config:Load()

-- config
size = config.SizeBig
fontsize = config.SizeFont
minisize = config.SizeMini

-- Code

function Tick(tick)
	if not client.connected or client.loading or client.console then
		return
	end
	if not me then
		me = entityList:GetMyHero()
		return
	end
	if not init then
		local friends = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = me.team, illusion = false})
		local check = false
		for i,v in ipairs(friends) do
			if v.classId == CDOTA_Unit_Hero_Disruptor then
				glimpse = v:GetAbility(2)
				check = true
			end
		end
		if check then
			pretime,delay = math.modf(client.totalGameTime*10)
			pretime = pretime+1
			font = drawMgr:CreateFont("glimpsefont","Arial",fontsize,500)
			init = true
		elseif #friends == 5 then
			unreg = true
			script:UnregisterEvent(Tick)
			return
		end
		return
	end
	local gametime = client.totalGameTime*10
	if gametime >= pretime+delay then
		pretime = pretime+1
		update = true
		if count == 40 then
			count = 0
		end
		count = count+1
	else
		update = false
	end
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = (5-me.team), illusion = false})
	for i,v in ipairs(enemies) do
		if not positions[v.handle] then
			positions[v.handle] = {}
			local nametexture = string.sub(v.name,15)
			positions[v.handle].glimpse = drawMgr:CreateRect(0,0,minisize,minisize,0x000000FF,drawMgr:GetTextureId("NyanUI/spellicons/disruptor_glimpse"))
			positions[v.handle].glimpse.visible = false
			positions[v.handle].icon = drawMgr:CreateRect(0,0,minisize,minisize,0x000000FF,drawMgr:GetTextureId("NyanUI/miniheroes/"..nametexture))
			positions[v.handle].icon.visible = false
			positions[v.handle].npchandle = -1
			positions[v.handle].bigicon = drawMgr:CreateRect(0,0,size,size,0x000000FF,drawMgr:GetTextureId("NyanUI/heroes_vertical/"..nametexture))
			positions[v.handle].bigicon.visible = false
			positions[v.handle].time = drawMgr:CreateText(0,0,-1,"",font)
			positions[v.handle].time.visible = false
		end
		if update then
			positions[v.handle].lastpos = positions[v.handle][count]
			if v.visible then
				positions[v.handle][count] = v.position
			else
				positions[v.handle][count] = nil
			end
		end
		if not positions[v.handle].using then
			if positions[v.handle].lastpos then
				q,positi = client:ScreenPosition(positions[v.handle].lastpos)
				if q then
					local halfsize = math.floor(minisize/2)
					positions[v.handle].glimpse.position = Vector2D(positi.x-halfsize,positi.y)
					positions[v.handle].icon.position = Vector2D(positi.x+halfsize,positi.y)
					if not positions[v.handle].glimpse.visible then
						positions[v.handle].glimpse.visible = true
						positions[v.handle].icon.visible = true
					end
				elseif positions[v.handle].glimpse.visible then
					positions[v.handle].glimpse.visible = false
					positions[v.handle].icon.visible = false
				end
			elseif positions[v.handle].glimpse.visible then
				positions[v.handle].glimpse.visible = false
				positions[v.handle].icon.visible = false
			end
		end
		if positions[v.handle].using then
			q,positi = client:ScreenPosition(positions[v.handle].position)
			if q then
				positions[v.handle].time.position = Vector2D(positi.x-math.floor(fontsize/2),positi.y)
				positions[v.handle].bigicon.position = Vector2D(positi.x+math.floor(size/2),positi.y)
				if not positions[v.handle].time.visible then
					positions[v.handle].time.visible = true
					positions[v.handle].bigicon.visible = true
				end
			elseif positions[v.handle].time.visible then
				positions[v.handle].time.visible = false
				positions[v.handle].bigicon.visible = false
			end
			if update then
				positions[v.handle].timing = positions[v.handle].timing-1
			end
			positions[v.handle].time.text = tostring(positions[v.handle].timing/10)
			if not entityList:GetEntity(positions[v.handle].npchandle) then
				positions[v.handle].using = false
				positions[v.handle].bigicon.visible = false
				positions[v.handle].time.visible = false
			end
		end
	end
	local npc = entityList:GetEntities(function(a) return not npces[a.handle] and a.classId == 287 and a.team == me.team and a.dayVision == 400 and a.movespeed == 300 and a.unitState == 59802112 and a.name == "Version" end)
	if npc[1] then
		for g,h in ipairs(npc) do
			local distance = 30000
			local enemy = nil
			local enem = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = (5-me.team), alive = true, visible = true, illusion = false})
			for i,v in ipairs(enem) do
				if not positions[v.handle].using then
					local range = math.sqrt(math.pow(h.position.x-v.position.x,2)+math.pow(h.position.y-v.position.y,2))
					if distance > range then
						distance = range
						enemy = v
					end
				end
			end
			if enemy and positions[enemy.handle].lastpos then
				positions[enemy.handle].using = true
				npces[h.handle] = true
				positions[enemy.handle].npchandle = h.handle
				positions[enemy.handle].position = positions[enemy.handle].lastpos
				local distance = math.sqrt(math.pow(positions[enemy.handle].lastpos.x-enemy.position.x,2)+math.pow(positions[enemy.handle].lastpos.y-enemy.position.y,2))
				if distance < 1080 then
					positions[enemy.handle].timing = math.floor(distance/60)
				else
					positions[enemy.handle].timing = 18
				end
				positions[enemy.handle].glimpse.visible = false
				positions[enemy.handle].icon.visible = false
			end
		end
	end
end

function Load()
	if registered then return end
registered = false
me = nil
init = false
unreg = false
active = false
positions = {}
npces = {}
count = 0
	script:RegisterEvent(EVENT_TICK,Tick)
	registered = true
end

function Close()
	if not registered then return end
	if not unreg then
		script:UnregisterEvent(Tick)
	end
	positions = {}
	font = nil
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
