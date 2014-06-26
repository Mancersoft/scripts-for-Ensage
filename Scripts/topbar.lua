-- Made by Staskkk.
-- This script allows you use spells and attack or follow on icons of heroes in top bar.
-- All spells works only if you see target, but target spells lead you to the enemy.
-- Target spells affect on heroes, area spells affect on heroes positions.
-- Spells only work if you use they by hotkeys.
-- Right click on friendly hero - follow him, on enemy - attack him.
-- Use config for change hotkeys and size and position top bar for your monitor size.
-- (not good works on Invoker, Rubick and Doom D and E hotkeys and Brewmaster ulti)

require("libs.spelltype")
----------config------------
Spells = {
string.byte("Q"), --first ability hotkey.
string.byte("W"), --second ability hotkey.
string.byte("E"), --third ability hotkey.
string.byte("R"), --fourth ability hotkey.
string.byte("D"), --fifth ability hotkey.
string.byte("F")} --sixth ability hotkey.
xx = 254 -- x parameter of left-top corner of top bar heroes of your team.
yy = 5 -- y parameter of left-top corner of top bar heroes of your team.
ww = 59 -- width of heroes icons.
hh = 32 -- height of heroes icons.
centwidth = 181 -- distance between icons of heroes of different teams.
----------------------------
using = false
selected = false
panel = {}
heroes = {}
init = false
sleeptick = 0

function Key(msg,code)
	if not client.connected or client.loading or client.console or not init then return end

	if msg == RBUTTON_UP then
		using = false
	end

	if not client.chat and msg == KEY_UP and code == Spells[1] or code == Spells[2] or 
code == Spells[3] or code == Spells[4] or code == Spells[5] or code == Spells[6] then
		for i,v in ipairs(sel.abilities) do
			if list2[v.name] and code == Spells[list2[v.name].number] and v.state == LuaEntityAbility.STATE_READY then
				Skill = v
				using = true
			end
		end
	end

	if heroes and msg == RBUTTON_UP or msg == LBUTTON_UP then

		for i,v in ipairs(heroes) do
			if v.team == 3 then
				selftop = centwidth
			else
				selftop = 0
			end

			if IsMouseOnButton(xx+v.playerId*ww+selftop,yy,hh,ww) then

				if msg == RBUTTON_UP then
					if v.team == sel.team then
						if IsKeyDown(16) then
							sel:Follow(v,true)
						else
							sel:Follow(v)
						end
						if v ~= sel then selected = true end
					else
						if IsKeyDown(16) then
							sel:Attack(v,true)
						else
							sel:Attack(v)
						end
					end
				end

				if msg == LBUTTON_UP and Skill and using then
					if list2[Skill.name].target == "target" then
						if IsKeyDown(16) then
							sel:SafeCastAbility(Skill,v,true)
						else
							sel:SafeCastAbility(Skill,v)
						end
					using = false
					elseif v.visible then
						if IsKeyDown(16) then
							sel:SafeCastAbility(Skill,v.position,true)
						else
							sel:SafeCastAbility(Skill,v.position)
						end
					using = false
					end
					if v ~= sel and v.team == sel.team then selected = true end
				end

			end
		end
	end

end
 
function IsMouseOnButton(x,y,h,w)
        local mx = client.mouseScreenPosition.x
        local my = client.mouseScreenPosition.y
        return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function Tick(tick)
	if not client.connected or client.loading or client.console or tick < sleeptick  or not entityList:GetMyHero() then
		return
	end
	sleeptick = tick + 200

	if not init then
		mp = entityList:GetMyPlayer()
		if not mp.selection[1] then return end
		init = true
	end
	sel = mp.selection[1]
	heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	for i,v in ipairs(heroes) do
		if not panel[v.playerId] then
			if v.team == 3 then
				selftop = centwidth
			else
				selftop = 0
			end
			panel[v.playerId] = drawMgr:CreateRect(xx+v.playerId*ww+selftop,yy,ww,hh,0x5050ffff,true)
			panel[v.playerId].visible = true
		end
		if not v.visible or not v.alive then
			panel[v.playerId].color = 0x808080ff
		else
			panel[v.playerId].color = 0x5050ffff
		end
	end

	if using and Skill and Skill.abilityPhase then
		using = false
	end

	if selected then
		mp:Select(sel)
		selected = false
	end

end

function Close()
	spells = {}
	panel = {}
	heroes = {}
	using = false
	selected = false
	init = false
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)
