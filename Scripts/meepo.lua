-- Made by Staskkk.

require("libs.Utils")
require("libs.stackpos")

-- Config
x = 50 -- x lable position
y = 30 -- y lable position
hpPercent = 0.50 -- % when meepo go to base for heal
hotkeys = {
string.byte("R"), -- poof all meepo's to selected meepo
string.byte("E"), -- poof all meepo's to selected meepo and selected meepo poof on hisself
string.byte("D"), -- use poof to fountain side
string.byte("F"), -- with Shift
string.byte("Q"), -- all meepos using his net to catch enemy ,ur mouse cursor must be on enemy hero, it using net one by one.
string.byte(" "), -- Press for script activate(one time)
string.byte("F"), -- WomboCombo with blinkdagger
string.byte("S"), -- stop combo, working only if script activated
219, -- use to plus 0.05 hpPercent
221,
string.byte("T")} -- poof selected meepo's to first selected meepo

-- Code
font = drawMgr:CreateFont("meepofont","Arial",14,500)
registered = false
init = false
activated = false
fount = {false,false,false,false,false}
unreg = false
com = false
meeponumb = {}
ordered = {}
sleep = {0, 0, 0, 0}

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP and code == hotkeys[6] then
		activated = not activated 
		if activated then
			text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
		else
			local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO})
			for n,m in ipairs(meepos) do
				meeponumb[m.handle] = 0
			end
			text.text = "Meepo script: NOT ACTIVE"
		end
	end
	if activated then
		if msg == KEY_UP then
			if code == hotkeys[9] then
				hpPercent = hpPercent-0.05
				text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
			end
			if code == hotkeys[10] then
				hpPercent = hpPercent+0.05
				text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
			end
			if code == hotkeys[7] and not IsKeyDown(16) then
				local sel = mp.selection[1]
				local spell = sel:FindItem("item_blink")
				if sel and sel.name == "npc_dota_hero_meepo" and spell and spell.state == LuaEntityAbility.STATE_READY then
					poofall(sel,false)
					if not eff then
						eff = Effect(sel, "range_display")
						eff:SetVector( 1, Vector(1200,0,0) )
					end
					targ = entityList:GetMouseover()
					dot = nil
					if targ and targ.type == LuaEntity.TYPE_HERO and targ.team ~= mp.team then
						nota = 0
							dot = Effect(targ, "urn_of_shadows_damage")
							dot:SetVector( 1, Vector(0,0,0))
					else
						nota = client.mousePosition
							dot = Effect(nota, "fire_torch")
							dot:SetVector(0, nota)
					end
					seld = sel
					dag = spell
					if sleep[2] <= GetTick() then
						sleep[2] = GetTick() + 1400
						com = true
					end
				end
			end
			if code == hotkeys[8] and com then
				sleep[2] = 0
				sele = false
				com = false
				eff = nil
				dot = nil
				local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
				for i,v in ipairs(meepos) do
					v:Stop()
				end
			end
			if code == hotkeys[1] or code == hotkeys[2] then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					poofall(sel,false)
					if code == hotkeys[2] and sel.health/sel.maxHealth >= hpPercent then
						local spell = sel:GetAbility(2)
						if spell.state == LuaEntityAbility.STATE_READY then
							sel:CastAbility(spell,sel)
						end
					end
				end
			end
			if code == hotkeys[11] then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					poofall(sel,true)
				end
			end
			if code == hotkeys[3] then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					local spell = sel:GetAbility(2)
					if spell.state == LuaEntityAbility.STATE_READY then
						sel:CastAbility(spell,foun)
					end
				end
			end
			if code == hotkeys[4] and IsKeyDown(16) then
				local sel = mp.selection[1]
				if not meeponumb[sel.handle] or meeponumb[sel.handle] == 0 then
					if sel then
						local range = 100000
						for n,m in ipairs(routes) do 
							local rang = GetDistance2D(sel.position,m[1])
							local empty = true
							local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
							for o,p in ipairs(meepos) do
								if meeponumb[p.handle] and meeponumb[p.handle] == n then
									empty = false
								end
							end
							if m.team == mp.team and range > rang and empty then
								range = rang
								meeponumb[sel.handle] = n
							end
						end
						sel:Move(routes[meeponumb[sel.handle]][3])
					end
				else
					meeponumb[sel.handle] = 0
				end
			end
		end
		if msg == KEY_DOWN and code == hotkeys[5] and target and target.visible and ((sleep[3] <= GetTick() and target == targe) or (target ~= targe)) then
			targe = target
			local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
			local throw = true
			for i,v in ipairs(meepos) do 
				local spell = v:GetAbility(1)
				if throw and spell.state == LuaEntityAbility.STATE_READY and GetDistance2D(target.position,v.position) <= spell.castRange then
					v:CastAbility(spell,Vector(target.position.x+220*math.cos(target.rotR), target.position.y+220*math.sin(target.rotR), target.position.z))
					v:Attack(target,true)
					sleep[3] = GetTick() + 1500
					throw = false
				end
			end
		end
	end
end

function poofall(sel,selecti)
	if selecti then
		meeposs = mp.selection
		local retu = false
		for i,v in ipairs(meeposs) do
			if v.name ~= "npc_dota_hero_meepo" then
				retu = true
			end
		end
		if not meeposs or retu then
			return
		end
	else
		meeposs = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
	end
	for i,v in ipairs(meeposs) do
		if v ~= sel and v.health/v.maxHealth >= hpPercent then
			local spell = v:GetAbility(2)
			if spell.state == LuaEntityAbility.STATE_READY and not spell.abilityPhase then
				v:CastAbility(spell,sel)
				if not selecti then
					n = 0
					sele = true
					sleep[4] = GetTick() + 1500
				end
			end
		end
	end
end

function Tick(tick)
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then
		return
	end
	if com and tick > sleep[2] then
		com = false
		eff = nil
		dot = nil
		if nota ~= 0 then
			seld:CastAbility(dag, nota)
		else 
			seld:CastAbility(dag, targ.position)
		end
		n = 0
		spell = seld:GetAbility(1)
		if spell and spell.state == LuaEntityAbility.STATE_READY then
			if nota ~= 0 then
				seld:CastAbility(spell, nota,true)
			else
				seld:CastAbility(spell, targ.position,true)
			end
		end
		spell = seld:GetAbility(2)
		if spell and spell.state == LuaEntityAbility.STATE_READY then
			if nota ~= 0 then
				seld:CastAbility(spell, nota,true)
			else
				seld:CastAbility(spell, targ.position,true)
			end
		end
	end
	if sele and tick > sleep[4] then
	local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
	local sel = mp.selection[1]
		if n == 0 then
			for i,v in ipairs(meepos) do
				if v ~= sel then
					mp:SelectAdd(v)
				end
			end
		elseif v ~= sel then
			mp:SelectAdd(meepos[n])
		end
		sele = false
	end
	if tick <= sleep[1] then return end
	sleep[1] = tick + 200
	if not init then
		if entityList:GetMyHero().name ~= "npc_dota_hero_meepo" then
			unreg = true
			script:UnregisterEvent(Key)
			script:UnregisterEvent(Tick)
			return
		end
		text = drawMgr:CreateText(x,y,-1,"Meepo script: NOT ACTIVE",font)
		mp = entityList:GetMyPlayer()
		if mp.team == LuaEntity.TEAM_RADIANT then
				foun = Vector(-7272,-6757,270)
			else
				foun = Vector(7200,6624,256)
			end
		init = true
	end
	local ent = entityList:GetMouseover()
	if ent and ent.type == LuaEntity.TYPE_HERO and ent.team ~= mp.team then
		target = ent
	end
	if activated then
		local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
		for i,v in ipairs(meepos) do
			if meeponumb[v.handle] and meeponumb[v.handle] ~= 0 and not ordered[v.handle] and isPosEqual(v.position,routes[meeponumb[v.handle]][3],100) and math.floor(client.gameTime%60) == 51 then
				ordered[v.handle] = true
				v:Move(routes[meeponumb[v.handle]][1])
				v:Move(routes[meeponumb[v.handle]][2],true)
				v:Move(routes[meeponumb[v.handle]][3],true)
			elseif ordered[v.handle] and math.floor(client.gameTime%60) < 51 then
				ordered[v.handle] = false
			end
			if not fount[i] and v.health/v.maxHealth < hpPercent then
				mp:Unselect(v)
					v:Move(foun)
				fount[i] = true
			end
			if fount[i] and v.health == v.maxHealth then
				if GetDistance2D(v.position,foun) <= 1200 then
					local sel = mp.selection[1]
					if sel and sel.name == "npc_dota_hero_meepo" then
						local spell = v:GetAbility(2)
						if spell.state == LuaEntityAbility.STATE_READY then
							v:CastAbility(spell,sel)
							sleep[4] = tick + 1500
							n = i
							sele = true
							fount[i] = false
						end
					end
				else
					fount[i] = false
				end
			end
		end
	end
end

function isPosEqual(v1, v2, d)
	return (v1-v2).length <= d
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
	if text then
		text.visible = false
	end
	init = false
	activated = false
	fount = {false,false,false,false,false}
	unreg = false
	com = false
	ordered = {}
	meeponumb = {}
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
