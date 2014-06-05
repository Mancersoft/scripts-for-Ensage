-- Modified by Staskkk.
-------config-------
manaBar = true
overlaySpell = true
overlayItem = true
topPanel = true
glypPanel = true
roshanPanel = false
centwidth = 181 -- distance between icons of heroes of different teams. (setting for self team topPanel)
-------------------

F10 = drawMgr:CreateFont("F10","Arial",10,500)
F11 = drawMgr:CreateFont("F11","Arial",11,500)
F12 = drawMgr:CreateFont("F12","Arial",12,500)
F13 = drawMgr:CreateFont("F13","Arial",13,500)
F14 = drawMgr:CreateFont("F14","Arial",14,500)
item = {} hero = {} spell = {} panel = {} mana = {}

sleeptick = 0

--Config.
--If u have some problem with positioning u can add screen ration(64 line) and create config for yourself.
if math.floor(client.screenRatio*100) == 177 then
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.527
txxG = 3.47
elseif math.floor(client.screenRatio*100) == 166 then
testX = 1280
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 70
tmanaX = 36
tmanaY = 14
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.558
txxG = 3.62
elseif math.floor(client.screenRatio*100) == 160 then
testX = 1280
testY = 768
tpanelHeroSize = 48.5
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 72
tmanaX = 37
tmanaY = 15
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.579
txxG = 3.735
elseif math.floor(client.screenRatio*100) == 133 then
testX = 1024
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 22
tmanaSize = 72
tmanaX = 37
tmanaY = 14
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.747
txxG = 4.54
else
testX = 1280
testY = 1024
tpanelHeroSize = 59
tpanelHeroDown = 28
tpanelHeroSS = 25
tmanaSize = 96
tmanaX = 48
tmanaY = 21
tglyphX = 1.0258
tglyphY = 1.085
txxB = 2.777
txxG = 4.57
end

--top panel coordinate
x_ = tpanelHeroSize*(client.screenSize.x/testX)
y_ = client.screenSize.y/tpanelHeroDown
ss = tpanelHeroSS*(client.screenSize.x/testX)

--manabar coordinate
manaSizeW = client.screenSize.x/testX*tmanaSize
manaX = client.screenSize.x/testX*tmanaX
manaY = client.screenSize.y/testY*tmanaY

--gliph coordinate
glyph = drawMgr:CreateText(client.screenSize.x/tglyphX,client.screenSize.y/tglyphY,0xFFFFFF60,"",F13)
glyph.visible = false

function Tick(tick)

	if not client.connected or client.loading or client.console or tick < sleeptick  then return end

	sleeptick = tick + 200

	local me = entityList:GetMyHero()

	if not me then return end

	if me.team == 2 then xx = client.screenSize.x/txxB
	elseif me.team == 3 then xx = client.screenSize.x/txxG
	end

	local t1,t2 = 0,0

	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, team = (5-me.team), illusion=false})
	for i,v in ipairs(enemies) do

		local offset = v.healthbarOffset

		if offset == -1 then return end

		--ManaBar
		if manaBar then
			if not hero[v.handle] then hero[v.handle] = {}
				hero[v.handle].manar1 = drawMgr:CreateRect(-manaX-1,-manaY,manaSizeW+2,6,0x010102ff,true) hero[v.handle].manar1.visible = false hero[v.handle].manar1.entity = v hero[v.handle].manar1.entityPosition = Vector(0,0,offset)
				hero[v.handle].manar2 = drawMgr:CreateRect(-manaX,-manaY+1,0,4,0x5279FFff) hero[v.handle].manar2.visible = false hero[v.handle].manar2.entity = v hero[v.handle].manar2.entityPosition = Vector(0,0,offset)
				hero[v.handle].manar3 = drawMgr:CreateRect(0,-manaY+1,0,4,0x00175Fff) hero[v.handle].manar3.visible = false hero[v.handle].manar3.entity = v hero[v.handle].manar3.entityPosition = Vector(0,0,offset)
			end

			for d= 1, v.maxMana/100 do
				if not not mana[d] then mana[d] = {} end
				if not hero[v.handle].mana then hero[v.handle].mana = {} end
				if not hero[v.handle].mana[d] then hero[v.handle].mana[d] = {}
				hero[v.handle].mana[d].cage = drawMgr:CreateRect(0,-manaY+1,1,5,0x0D1453ff,true) hero[v.handle].mana[d].cage.visible = false hero[v.handle].mana[d].cage.entity = v hero[v.handle].mana[d].cage.entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if offset ~= -1 and v.visible and v.alive then
					hero[v.handle].mana[d].cage.visible = true hero[v.handle].mana[d].cage.x = -manaX+manaSizeW/v.maxMana*100*d
				else
					hero[v.handle].mana[d].cage.visible = false
				end
			end

			if v.visible and v.alive then
				local manaPercent = v.mana/v.maxMana
				local printMe = string.format("%i",math.floor(v.mana))
				hero[v.handle].manar1.visible = true
				hero[v.handle].manar2.visible = true hero[v.handle].manar2.w = manaSizeW*manaPercent
				hero[v.handle].manar3.visible = true hero[v.handle].manar3.x = -manaX+manaSizeW*manaPercent hero[v.handle].manar3.w = manaSizeW*(1-manaPercent)
			else
				hero[v.handle].manar1.visible = false
				hero[v.handle].manar2.visible = false
				hero[v.handle].manar3.visible = false
			end
		end

		--Spell
		if overlaySpell then
			  for a= 1, 7 do
				if not spell[a] then spell[a] = {} end
				if not hero[v.handle].spell then hero[v.handle].spell = {} end

				if not hero[v.handle].spell[a] then hero[v.handle].spell[a] = {}
					hero[v.handle].spell[a].bg = drawMgr:CreateRect(a*16-46,81,14,12,0x00000095) hero[v.handle].spell[a].bg.visible = false hero[v.handle].spell[a].bg.entity = v hero[v.handle].spell[a].bg.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].nl = drawMgr:CreateRect(a*16-47,80,16,14,0xCE131399,true) hero[v.handle].spell[a].nl.visible = false hero[v.handle].spell[a].nl.entity = v hero[v.handle].spell[a].nl.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].lvl1 = drawMgr:CreateRect(a*16-45,91,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl1.visible = false hero[v.handle].spell[a].lvl1.entity = v hero[v.handle].spell[a].lvl1.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].lvl2 = drawMgr:CreateRect(a*16-42,91,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl2.visible = false hero[v.handle].spell[a].lvl2.entity = v hero[v.handle].spell[a].lvl2.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].lvl3 = drawMgr:CreateRect(a*16-39,91,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl3.visible = false hero[v.handle].spell[a].lvl3.entity = v hero[v.handle].spell[a].lvl3.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].lvl4 = drawMgr:CreateRect(a*16-36,91,2,2,0xFFFF00FF) hero[v.handle].spell[a].lvl4.visible = false hero[v.handle].spell[a].lvl4.entity = v hero[v.handle].spell[a].lvl4.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].textT = drawMgr:CreateText(0,80,0xFFFFFFff,"",F12) hero[v.handle].spell[a].textT.visible = false hero[v.handle].spell[a].textT.entity = v hero[v.handle].spell[a].textT.entityPosition = Vector(0,0,offset)
					hero[v.handle].spell[a].vvv = true
					hero[v.handle].spell[a].zzz = true
				end

				local Spell = v:GetAbility(a)

				if v.alive and v.visible and Spell ~= nil then
					hero[v.handle].spell[a].vvv = true

					if Spell.name ~= "attribute_bonus" and not Spell.hidden then
						hero[v.handle].spell[a].zzz = true
						hero[v.handle].spell[a].bg.visible = true
						if Spell.state == 16 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.color = 0xCE131399
							hero[v.handle].spell[a].textT.visible = false
						elseif Spell.state == -1 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.color = 0x00994C99
							hero[v.handle].spell[a].textT.visible = false					
						elseif Spell.cd > 0 then
							local cooldown = math.ceil(Spell.cd)
							if cooldown > 100 then shift1 = -3 elseif cooldown < 10 then shift1 = 2 else shift1 = 0 end
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.color = 0xA1A4A199
							hero[v.handle].spell[a].textT.visible = true hero[v.handle].spell[a].textT.x = a*16-44+shift1 hero[v.handle].spell[a].textT.text = ""..cooldown hero[v.handle].spell[a].textT.color = 0xFFFFFFff
						elseif Spell.state == 17 then
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.color = 0xCC660099
							hero[v.handle].spell[a].textT.visible = false
						elseif v.mana - Spell.manacost < 0 and Spell.cd == 0 then
							local ManaCost = math.floor(math.ceil(Spell.manacost) - v.mana)
							if ManaCost > 100 then shift2 = -3 elseif ManaCost < 10 then shift2 = 2 else shift2 = 0 end
							hero[v.handle].spell[a].nl.visible = true hero[v.handle].spell[a].nl.color = 0x047AFF99
							hero[v.handle].spell[a].textT.visible = true hero[v.handle].spell[a].textT.x = a*16-44+shift2 hero[v.handle].spell[a].textT.text = ""..ManaCost hero[v.handle].spell[a].textT.color = 0xBBA9EEff
						else
							hero[v.handle].spell[a].nl.visible = false
							hero[v.handle].spell[a].textT.visible = false
						end

						if Spell.level == 1 then
							hero[v.handle].spell[a].lvl1.visible = true
						elseif Spell.level == 2 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
						elseif Spell.level == 3 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
							hero[v.handle].spell[a].lvl3.visible = true
						elseif Spell.level >= 4 then
							hero[v.handle].spell[a].lvl1.visible = true
							hero[v.handle].spell[a].lvl2.visible = true
							hero[v.handle].spell[a].lvl3.visible = true
							hero[v.handle].spell[a].lvl4.visible = true
						else
							hero[v.handle].spell[a].lvl1.visible = false
							hero[v.handle].spell[a].lvl2.visible = false
							hero[v.handle].spell[a].lvl3.visible = false
							hero[v.handle].spell[a].lvl4.visible = false
						end
					else
						if hero[v.handle].spell[a].zzz == true then
							hero[v.handle].spell[a].bg.visible = false
							hero[v.handle].spell[a].nl.visible = false
							hero[v.handle].spell[a].lvl1.visible = false
							hero[v.handle].spell[a].lvl2.visible = false
							hero[v.handle].spell[a].lvl3.visible = false
							hero[v.handle].spell[a].lvl4.visible = false
							hero[v.handle].spell[a].textT.visible = false
							hero[v.handle].spell[a].zzz = false
						end
					end
				else
					if hero[v.handle].spell[a].vvv == true then
						hero[v.handle].spell[a].bg.visible = false
						hero[v.handle].spell[a].nl.visible = false
						hero[v.handle].spell[a].lvl1.visible = false
						hero[v.handle].spell[a].lvl2.visible = false
						hero[v.handle].spell[a].lvl3.visible = false
						hero[v.handle].spell[a].lvl4.visible = false
						hero[v.handle].spell[a].textT.visible = false
						hero[v.handle].spell[a].vvv =  false
					end
				end
			end
		end

		--some items
		if overlayItem then
		enemies[v.name] = 0

			for c = 1, 6 do

				if not item[c] then item[c] = {} end
				if not hero[v.handle].item then hero[v.handle].item = {} end

				if not hero[v.handle].item[c] then hero[v.handle].item[c] = {}
					hero[v.handle].item[c].gem = drawMgr:CreateText(0, 95,0x7CFC0099,"G",F12) hero[v.handle].item[c].gem.visible = false hero[v.handle].item[c].gem.entity = v hero[v.handle].item[c].gem.entityPosition = Vector(0,0,offset)
					hero[v.handle].item[c].dust = drawMgr:CreateText(0, 95,0xFF00FF99,"D",F12) hero[v.handle].item[c].dust.visible = false hero[v.handle].item[c].dust.entity = v hero[v.handle].item[c].dust.entityPosition = Vector(0,0,offset)
					hero[v.handle].item[c].sentry = drawMgr:CreateText(0, 95,0x00BFFF99,"S",F12) hero[v.handle].item[c].sentry.visible = false hero[v.handle].item[c].sentry.entity = v hero[v.handle].item[c].sentry.entityPosition = Vector(0,0,offset)
					hero[v.handle].item[c].sphere = drawMgr:CreateText(0, 95,0x67C5EE99,"",F12) hero[v.handle].item[c].sphere.visible = false hero[v.handle].item[c].sphere.entity = v hero[v.handle].item[c].sphere.entityPosition = Vector(0,0,offset)
					hero[v.handle].item[c].sword = drawMgr:CreateText(0, 95,0xC731F599,"",F12) hero[v.handle].item[c].sword.visible = false hero[v.handle].item[c].sword.entity = v hero[v.handle].item[c].sword.entityPosition = Vector(0,0,offset)
					hero[v.handle].item[c].vvv = true
				end

				local Items = v:GetItem(c)

				if v.alive and v.visible and Items ~= nil then
					hero[v.handle].item[c].vvv = true


					if Items.name == "item_gem" then
						enemies[v.name] = enemies[v.name]  + 15
						hero[v.handle].item[c].gem.visible = true hero[v.handle].item[c].gem.x = enemies[v.name] - 45
					else
						hero[v.handle].item[c].gem.visible = false
					end
					if Items.name == "item_dust" then
						enemies[v.name] = enemies[v.name]  + 15
						hero[v.handle].item[c].dust.visible = true hero[v.handle].item[c].dust.x = enemies[v.name] - 45 hero[v.handle].item[c].dust.text = "D"..v:GetItem(c).charges
					else
						hero[v.handle].item[c].dust.visible = false
					end
					if Items.name == "item_ward_sentry" then
						enemies[v.name] = enemies[v.name]  + 15
						hero[v.handle].item[c].sentry.visible = true hero[v.handle].item[c].sentry.x = enemies[v.name] - 45 hero[v.handle].item[c].sentry.text = "S"..v:GetItem(c).charges
					else
						hero[v.handle].item[c].sentry.visible = false
					end

					if Items.name == "item_sphere" then
						enemies[v.name] = enemies[v.name]  + 15
						if Items.cd ~= 0 then
							local cdL = math.ceil(v:GetItem(c).cd)
							hero[v.handle].item[c].sphere.visible = true hero[v.handle].item[c].sphere.x = enemies[v.name] - 45 hero[v.handle].item[c].sphere.text = ""..cdL
						else
							hero[v.handle].item[c].sphere.visible = true hero[v.handle].item[c].sphere.x = enemies[v.name] - 45 hero[v.handle].item[c].sphere.text = "L"
						end
					else
						hero[v.handle].item[c].sphere.visible = false
					end

					if Items.name == "item_invis_sword" then
						enemies[v.name] = enemies[v.name]  + 15
						if Items.cd ~= 0 then
							local cdS = math.ceil(v:GetItem(c).cd)
							hero[v.handle].item[c].sword.visible = true hero[v.handle].item[c].sword.x = enemies[v.name] - 45 hero[v.handle].item[c].sword.text = ""..cdS
						else
							hero[v.handle].item[c].sword.visible = true hero[v.handle].item[c].sword.x = enemies[v.name] - 45 hero[v.handle].item[c].sword.text = "SB"
						end
					else
						hero[v.handle].item[c].sword.visible = false
					end
				else
					if hero[v.handle].item[c].vvv == true then
						hero[v.handle].item[c].gem.visible = false
						hero[v.handle].item[c].dust.visible = false
						hero[v.handle].item[c].sentry.visible = false
						hero[v.handle].item[c].sphere.visible = false
						hero[v.handle].item[c].sword.visible = false
						hero[v.handle].item[c].vvv = false
					end
				end

			end
		end

		if glypPanel then
			--gliph cooldown
			local team = 5 - entityList:GetMyHero().team
			local Time = client:GetGlyphCooldown(team)
			if Time == 0 then sms = "Ry" else sms = Time end
			glyph.visible = true glyph.text = ""..sms
		end
	end

	local selftop
	local allheroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	for i,v in ipairs(allheroes) do
		if topPanel then
		selftop = 0
		if v.team == me.team then
			selftop = centwidth
			if v.team == 2 then
				selftop = -1*selftop
			end
		end
			--ulti panel
			if not panel[v.playerId] then panel[v.playerId] = {}
				panel[v.playerId].hpT = drawMgr:CreateText(0,y_,0xFF3333ff,"",F12) panel[v.playerId].hpT.visible = false
				local color
				if v.team ~= me.team then
					color = 0xFF5151ff
				else
					color = 0x52EE52ff
				end
				panel[v.playerId].hpIN = drawMgr:CreateRect(0,y_,0,8,color) panel[v.playerId].hpIN.visible = false
				panel[v.playerId].hpINB = drawMgr:CreateRect(0,y_,x_-1,8,0x00000070) panel[v.playerId].hpINB.visible = false
				panel[v.playerId].hpB = drawMgr:CreateRect(0,y_,x_-1,8,0x000000ff,true) panel[v.playerId].hpB.visible = false
				panel[v.playerId].ulti = drawMgr:CreateRect(0,y_-7,13,13,0x0EC14A80) panel[v.playerId].ulti.visible = false			
				panel[v.playerId].ultiCDT = drawMgr:CreateText(0,y_-7,0xFFFFFFff,"",F11) panel[v.playerId].ultiCDT.visible = false
			end
				t1 = t1 + 1
				for d = 4,8 do
					if v:GetAbility(d) ~= nil then
						if v:GetAbility(d).abilityType == 1 then
							panel[v.playerId].ulti.x = xx-2+x_*v.playerId+selftop
							if v:GetAbility(d).cd > 0 then
								local cooldownUlti = math.ceil(v:GetAbility(d).cd)
								if cooldownUlti > 100 then shift3 = -2 elseif cooldownUlti < 10 then shift3 = 3 else shift3 = 1 end
								panel[v.playerId].ulti.visible = true 
								panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("Stuff/ulti_cooldown")
								panel[v.playerId].ultiCDT.visible = true panel[v.playerId].ultiCDT.x = xx+x_*v.playerId+selftop + shift3 panel[v.playerId].ultiCDT.text = ""..cooldownUlti
							elseif v:GetAbility(d).cd == 0 and v:GetAbility(d).state == 14 then
								panel[v.playerId].ulti.visible = true 
								panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("Stuff/ulti_nomana")
								panel[v.playerId].ultiCDT.visible = false
							elseif v:GetAbility(d).cd == 0 and v:GetAbility(d).state ~= 16 then
								panel[v.playerId].ulti.visible = true 
								panel[v.playerId].ulti.textureId = drawMgr:GetTextureId("Stuff/ulti_ready")
								panel[v.playerId].ultiCDT.visible = false
							elseif v:GetAbility(d).state == 16 then
								panel[v.playerId].ultiCDT.visible = false
								panel[v.playerId].ulti.visible = false
							end
						end
					end
				end
			if v.respawnTime == 0 then
				local health = string.format("%i",math.floor(v.health))
				local healthPercent = v.health/v.maxHealth
				local manaPercent = v.mana/v.maxMana
				panel[v.playerId].hpINB.visible = true panel[v.playerId].hpINB.x = xx-ss+x_*v.playerId+selftop
				panel[v.playerId].hpIN.visible = true panel[v.playerId].hpIN.x = xx-ss+x_*v.playerId+selftop panel[v.playerId].hpIN.w = (x_-2)*healthPercent
				panel[v.playerId].hpB.visible = true panel[v.playerId].hpB.x = xx-ss+x_*v.playerId+selftop
			else
				panel[v.playerId].hpINB.visible = false
				panel[v.playerId].hpIN.visible = false
				panel[v.playerId].hpB.visible = false
			end
		end
	end


end

function GameClose()
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	glyph.visible = false
	collectgarbage("collect")
end

function Roshan( kill )
    if kill.name == "dota_roshan_kill" then
		if roshanPanel then
			script:RegisterEvent(EVENT_TICK,Roha)
		end
    end
end

function Roha(tick)
	if aa == nil then
		sleep = tick + 1000
		aa = 1
	end
	if tick > sleep then
		client:ExecuteCmd("chatwheel_say 53")
 		client:ExecuteCmd("chatwheel_say 57")
		client:ExecuteCmd("exec roshan.cfg")
		aa = nil
		script:UnregisterEvent(Roha)
	end
end

script:RegisterEvent(EVENT_DOTA,Roshan)
script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK,Tick)
