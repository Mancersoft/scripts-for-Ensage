--<<Visage helper - Auto Soul Assumption and Stone Form of familiars>>
-- Made by Staskkk.

require("libs.Utils")

-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Activate", "T")
config:SetParameter("StoneForAll", "F")
config:SetParameter("Xcord", 50)
config:SetParameter("Ycord", 40)
config:SetParameter("HpPercentFamiliars", 0.30)
config:SetParameter("RangeForStun", 400)
config:SetParameter("TimeForStun", 3)
config:Load()

function numpad( strkey )
        if strkey == "n0" then return 96
                elseif strkey == "n1" then return 97
                elseif strkey == "n2" then return 98
                elseif strkey == "n3" then return 99
                elseif strkey == "n4" then return 100
                elseif strkey == "n5" then return 101
                elseif strkey == "n6" then return 102
                elseif strkey == "n7" then return 103
                elseif strkey == "n8" then return 104
                elseif strkey == "n9" then return 105
                elseif strkey == "n*" then return 106
                elseif strkey == "n+" then return 107
                elseif strkey == "n-" then return 109
                elseif strkey == "n." then return 110
                elseif strkey == "n/" then return 111
                elseif strkey == "space" then return 32
                elseif string.len(strkey) > 2 or strkey == "" then return 124
                else return string.byte( strkey )
        end
end

-- config
x = config.Xcord -- x lable position
y = config.Ycord -- y lable position
hotkey1 = numpad(config.Activate) -- hotkey for combo relocate return
hotkey2 = numpad(config.StoneForAll)
hpPercent = config.HpPercentFamiliars
range = config.RangeForStun
if config.TimeForStun > 15 then
	stuntime = 15
else
	stuntime = config.TimeForStun
end

-- Code

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP then
		if code == hotkey1 then
			active = not active
			if active then
				text.text = "Visage script: ACTIVE, HpPercent = "..hpPercent
			else
				text.text = "Visage script: NOT ACTIVE, HpPercent = "..hpPercent
			end
		elseif code == hotkey2 then
			local fams = entityList:FindEntities({classId = CDOTA_Unit_VisageFamiliar, alive = true})
			for q,w in ipairs(fams) do
				local spl = w:GetAbility(1)
				if spl.state == LuaEntityAbility.STATE_READY then
					w:CastAbility(spl)
				end
			end
		end
	end
end

function Tick(tick)
	if sleeptick >= tick and not client.connected or client.loading or client.console or not entityList:GetMyHero() then
		return
	end
	sleeptick = tick+200
	if not init then
		me = entityList:GetMyHero()
		if me.name ~= "npc_dota_hero_visage" then
			unreg = true
			script:UnregisterEvent(Key)
			script:UnregisterEvent(Tick)
			return
		end
		text = drawMgr:CreateText(x,y,-1,"Visage script: ACTIVE, HpPercent = "..hpPercent,font)
		init = true
	end
	if active then
		local modif = me:FindModifier("modifier_visage_soul_assumption")
		if modif then
			local spell = me:GetAbility(2)
			if spell.state == LuaEntityAbility.STATE_READY and modif.stacks == spell.level+2 then
				local enemies = entityList:FindEntities({type = LuaEntity.TYPE_HERO,team = (5-me.team),alive = true, visible = true,illusion = false})
				local hp = 30000
				for i,v in ipairs(enemies) do
					if math.sqrt((me.position.x-v.position.x)^2+(me.position.y-v.position.y)^2) <= spell.castRange and not v:IsMagicDmgImmune() and not v:IsLinkensProtected() then
						local realhp = v.health*(1+v.magicDmgResist)
						if realhp < hp then
							hp = realhp
							enemy = v
						end
					end
				end
				if hp ~= 30000 then
					me:CastAbility(spell,enemy)
				end
			end
		end
		familiars = entityList:FindEntities({classId = CDOTA_Unit_VisageFamiliar, alive = true})
		for i,v in ipairs(familiars) do
			if not famils[v.handle] then
				famils[v.handle] = {}
				famils[v.handle].vec = Vector(0,0,0)
			end
			local spell = v:GetAbility(1)
			if v.health*(1+v.dmgResist) <= 0.3*v.maxHealth*(1+v.dmgResist) and spell.state ~= LuaEntityAbility.STATE_COOLDOWN then
				v:CastAbility(spell)
			end
			if famils[v.handle].enemy and v:FindModifier("modifier_visage_summon_familiars_stone_form_buff") then
				famils[v.handle].enemy = nil
				famils[v.handle].stop = 0
				famils[v.handle].vec = Vector(0,0,0)
				famils[v.handle].sleept = 0
			else
				local modif = v:FindModifier("modifier_visage_summon_familiars_damage_charge")
				if famils[v.handle].enemy or (modif and modif.stacks == 0) then
					local enemies = entityList:FindEntities({type = LuaEntity.TYPE_HERO, team = (5-me.team), alive = true, visible = true, illusion = false})
					local shortest = 30000
					local enemy = nil
					for g,h in ipairs(enemies) do
						local distance = math.sqrt(math.pow(v.position.x-h.position.x,2)+math.pow(v.position.y-h.position.y,2))
						if shortest > distance then
							shortest = distance
							enemy = h
						end
					end
					local spell = v:GetAbility(1)
					if spell.state == STATE_READY or (enemy and spell.cd <= shortest/enemy.movespeed) then
						if shortest <= range then
							if not famils[v.handle].enemy or famils[v.handle].enemy.handle ~= enemy.handle then
								famils[v.handle].enemy = enemy
								famils[v.handle].stop = tick+stuntime*1000
								famils[v.handle].sleept = 0
							end
							if famils[v.handle].stop >= tick then
								local distance = famils[v.handle].enemy.movespeed-295
								famils[v.handle].oldvec = famils[v.handle].vec
								famils[v.handle].vec = Vector(famils[v.handle].enemy.position.x+distance*math.cos(famils[v.handle].enemy.rotR),famils[v.handle].enemy.position.y+distance*math.sin(famils[v.handle].enemy.rotR),famils[v.handle].enemy.position.z)
								local distance = math.sqrt(math.pow(v.position.x-famils[v.handle].vec.x,2)+math.pow(v.position.y-famils[v.handle].vec.y,2))
								if famils[v.handle].oldvec ~= famils[v.handle].vec and distance > 30 then
									v:Move(famils[v.handle].vec)
								end
								local modif = famils[v.handle].enemy:FindModifier("modifier_stunned")
								if famils[v.handle].sleept < tick and distance <= 30 and (not modif or modif.remainingTime <= 1.01) then
									v:CastAbility(spell)
									for g,h in ipairs(familiars) do
										if famils[h.handle].enemy and famils[v.handle].enemy.handle == famils[h.handle].enemy.handle then
											famils[h.handle].sleept = tick + 1200
										end
									end
								end
							end
						else
							v:CastAbility(spell)
						end
					end
				end
			end
		end
	end
end

function Load()
	if registered then return end
font = drawMgr:CreateFont("visagefont","Arial",14,500)
registered = false
init = false
unreg = false
famils = {}
active = true
sleeptick = 0
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
