-- Made by Staskkk.

-- Config
hpPercent = 0.50
hotkeys = {
string.byte("R"),
string.byte("E"),
string.byte("D"),
string.byte("F"), -- with Shift
string.byte("Q"),
string.byte(" "),
string.byte("F")} 

-- Code
registered = false
init = false
activated = false
fount = {false,false,false,false,false}
unreg = false
com = false
sleeptick = 0
sleep = 0
--font = drawMgr:CreateFont("critfont","Arial",14,500)
--defaultText = "Critscript: Disabled"
--text = drawMgr:CreateText(x,y,-1,defaultText,font)

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP and code == hotkeys[6] then activated = not activated end
	if activated then
		if msg == KEY_UP then
			if code == hotkeys[7] and not IsKeyDown(16) then
				targ = entityList:GetMouseover()
				if targ and targ.type == LuaEntity.TYPE_HERO and targ.team ~= mp.team then
					local sel = mp.selection[1]
					local spell = sel:FindItem("item_blink")
					if sel and sel.name == "npc_dota_hero_meepo" and spell and spell.state == LuaEntityAbility.STATE_READY then
						poofall(sel)
						eff = Effect(sel, "range_display")
						eff:SetVector( 1, Vector(1200,0,0) )
						dot = Effect(targ, "urn_of_shadows_damage")
						dot:SetVector( 1, Vector(0,0,0))
						seld = sel
						dag = spell
						sleep = GetTick() + 1400
						com = true
					end
				end
			end
			if code == hotkeys[1] or code == hotkeys[2] then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					poofall(sel)
					if code == hotkeys[2] then
						local spell = sel:GetAbility(2)
						if spell.state == LuaEntityAbility.STATE_READY then
							sel:CastAbility(spell,sel)
						end
					end
				end
			end
			if code == hotkeys[3] then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					local spell = sel:GetAbility(2)
					if spell.state == LuaEntityAbility.STATE_READY then
						if sel.team == LuaEntity.TEAM_RADIANT then
							sel:CastAbility(spell,Vector(-7272,-6757,270))
						else
							sel:CastAbility(spell,Vector(7200,6624,256))
						end
					end
				end
			end
			if code == hotkeys[4] and IsKeyDown(16) then
				local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
				if mp.team == LuaEntity.TEAM_RADIANT then
					if meepos[1] then meepos[1]:AttackMove(Vector(-991,-4183,127)) end
					if meepos[2] then meepos[2]:AttackMove(Vector(-389,-2958,127)) end
					if meepos[3] then meepos[3]:AttackMove(Vector(1602,-3780,256)) end
					if meepos[4] then meepos[4]:AttackMove(Vector(3184,-3400,256)) end
					if meepos[5] then meepos[5]:AttackMove(Vector(3120,-4421,256)) end
				else
					if meepos[1] then meepos[1]:AttackMove(Vector(1302,3396,256)) end
					if meepos[2] then meepos[2]:AttackMove(Vector(-443,3800,256)) end
					if meepos[3] then meepos[3]:AttackMove(Vector(-1505,2649,127)) end
					if meepos[4] then meepos[4]:AttackMove(Vector(-3035,4534,256)) end
					if meepos[5] then meepos[5]:AttackMove(Vector(-4389,3573,256)) end
				end
			end
		end
		if msg == KEY_DOWN and code == hotkeys[5] and target then
			local sel = mp.selection[1]
			if sel and sel.name == "npc_dota_hero_meepo" then
				local spell = sel:GetAbility(1)
				if spell.state == LuaEntityAbility.STATE_READY then
					sel:CastAbility(spell,target.position)
				end
			end
		end
	end
end

function poofall(sel)
	local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
	for i,v in ipairs(meepos) do
		if v ~= sel then
			local spell = v:GetAbility(2)
			if spell.state == LuaEntityAbility.STATE_READY then
				v:CastAbility(spell,sel)
			end
		end
	end
end

function Tick(tick)
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then
		return
	end
	if com and tick >= sleep then
		com = false
		eff = nil
		dot = nil
		seld:CastAbility(dag, targ.position)
		spell = seld:GetAbility(1)
		if spell and spell.state == LuaEntityAbility.STATE_READY then
			seld:CastAbility(spell, targ.position,true)
		end
		spell = seld:GetAbility(2)
		if spell and spell.state == LuaEntityAbility.STATE_READY then
			seld:CastAbility(spell, targ.position,true)
		end
	end
	if tick < sleeptick then return end
	if entityList:GetMyHero().name ~= "npc_dota_hero_meepo" then
		unreg = true
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		return
	end
	sleeptick = tick + 200
	if not init then
		mp = entityList:GetMyPlayer()
		init = true
	end
	local cur = entityList:GetMouseover()
	if cur and cur.type == LuaEntity.TYPE_HERO and cur.team ~= mp.team then
		target = cur
	end
	if activated then
		local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
		for i,v in ipairs(meepos) do
			if not fount[i] and v.health/v.maxHealth < hpPercent then
				mp:Unselect(v)
				if v.team == LuaEntity.TEAM_RADIANT then
					v:Move(Vector(-7272,-6757,270))
				else
					v:Move(Vector(7200,6624,256))
				end
				fount[i] = true
			end
			if fount[i] and v.health == v.maxHealth then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					local spell = v:GetAbility(2)
					if spell.state == LuaEntityAbility.STATE_READY then
						v:CastAbility(spell,sel)
						mp:SelectAdd(v)
						fount[i] = false
					end
				end
			end
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
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
