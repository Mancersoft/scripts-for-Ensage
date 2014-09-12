-- Made by Staskkk.

require("libs.Utils")

-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Activate", "T")
config:SetParameter("Xcord", 50)
config:SetParameter("Ycord", 40)
config:SetParameter("HpPercentFamiliars", 0.30)
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
hotkey = numpad(config.Activate) -- hotkey for combo relocate return
hpPercent = config.HpPercentFamiliars

-- Code

function Key(msg,code)
	if client.console or client.chat or not init then return end
	if msg == KEY_UP and code == hotkey then
		active = not active
		if active then
			text.text = "Visage script: ACTIVE, HpPercent = "..hpPercent
		else
			text.text = "Visage script: NOT ACTIVE, HpPercent = "..hpPercent
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
			local spell = v:GetAbility(1)
			if v.health*(1+v.dmgResist) <= 0.3*v.maxHealth*(1+v.dmgResist) and spell.state ~= LuaEntityAbility.STATE_COOLDOWN then
				v:CastAbility(spell)
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
