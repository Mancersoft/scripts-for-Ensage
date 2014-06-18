-- Made by Staskkk.

-- Config
x = 50 -- x lable position
y = 40 -- y lable position
hotkey = string.byte("T") -- hotkey for combo relocate return

-- Code
font = drawMgr:CreateFont("iofont","Arial",14,500)
registered = false
init = false
unreg = false
active = false
delay = {2300,2050,1800}
sleeptick = 0

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP and code == hotkey and not active then
		local spell = me:GetAbility(7)
		if spell.state == LuaEntityAbility.STATE_READY then
			mp:UseAbility(spell,foun)
			eff = Effect(me, "range_display")
			eff:SetVector(1, Vector(1800, 0, 0))
			sleeptick = GetTick() + delay[spell.level]
			active = true
		end
	end
	if active and msg == LBUTTON_UP then
		local mate = entityList:GetMouseover()
		if mate and mate.type == LuaEntity.TYPE_HERO and mate.team == mp.team and not mate.illusion and mate ~= me then
			mp:Select(me)
			target = mate
			targ = Effect(target, "urn_of_shadows_heal")
			targ:SetVector(1, Vector(0,0,0))
		end
	end
end

function Tick(tick)
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then
		return
	end
	if not init then
		me = entityList:GetMyHero()
		if me.name ~= "npc_dota_hero_wisp" then
			unreg = true
			script:UnregisterEvent(Key)
			script:UnregisterEvent(Tick)
			return
		end
		text = drawMgr:CreateText(x,y,-1,"Io script: ACTIVE",font)
		mp = entityList:GetMyPlayer()
		if mp.team == LuaEntity.TEAM_RADIANT then
			foun = Vector(-7200,-6700,270)
		else
			foun = Vector(7200,6624,256)
		end
		init = true
	end
	if active then
		text.text = "Io script: "..tostring((sleeptick-tick)/1000).." sec"
		if tick > sleeptick then
			text.text = "Io script: ACTIVE"
			active = false
			if target then
				if math.sqrt((target.position.x-me.position.x)^2+(target.position.y-me.position.y)^2) <= 1800 then
					local spell = me:GetAbility(1)
					if spell.name ~= "wisp_tether" then
						spell = me:GetAbility(2)
					end
					if spell.state == LuaEntityAbility.STATE_READY then
						mp:UseAbility(spell,target)
					end
				end
				targ = nil
				target = nil
			end
			eff = nil
		end
	end
end

function Load()
	if registered then return end
	script:RegisterEvent(EVENT_TICK,Tick)
	script:RegisterEvent(EVENT_KEY,Key)
	registered = true
end

function Close()
	if not unreg then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
	end
	text = nil
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
