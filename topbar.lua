-- Made by Staskkk.
-- This script allows you use your hero spells and attack or follow on icons of heroes in top bar.
-- Target spells affect on heroes, area spells affect on heroes positions.
-- Spells only work if you use they by hotkey.
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
registered = false
sleeptick = 0

function Key(msg,code)
	if not client.connected or client.loading or client.console or not init then return end

	if msg == RBUTTON_UP then
		using = false
	end

	if not client.chat and msg == KEY_UP and code == Spells[1] or code == Spells[2] or 
code == Spells[3] or code == Spells[4] or code == Spells[5] or code == Spells[6] then
		for i,v in ipairs(me.abilities) do
			if list[v.name] and code == Spells[list[v.name].number] and v.state == LuaEntityAbility.STATE_READY then
				Skill = v
				using = true
			end
		end
	end

	if heroes and msg == RBUTTON_UP or msg == LBUTTON_UP then

		for i,v in ipairs(heroes) do
			selftop = 0
			if v.team ~= me.team then
				selftop = centwidth
				if v.team == 2 then
					selftop = -1*selftop
				end
			end

			if IsMouseOnButton(xx+v.playerId*ww+selftop,yy,hh,ww) then

				if msg == RBUTTON_UP then
					if v.team == me.team then
						if IsKeyDown(16) then
							me:Follow(v,true)
						else
							me:Follow(v)
						end
						if v ~= me then selected = true end
					else
						if IsKeyDown(16) then
							me:Attack(v,true)
						else
							me:Attack(v)
						end
					end
				end

				if msg == LBUTTON_UP and Skill and using then
					if list[Skill.name].target == "target" then
						if IsKeyDown(16) then
							me:SafeCastAbility(Skill,v,true)
						else
							me:SafeCastAbility(Skill,v)
						end
					using = false
					elseif v.visible then
						if IsKeyDown(16) then
							me:SafeCastAbility(Skill,v.position,true)
						else
							me:SafeCastAbility(Skill,v.position)
						end
					using = false
					end
					if v ~= me and v.team == me.team then selected = true end
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
	if not client.connected or client.loading or client.console or tick < sleeptick then return end
	sleeptick = tick + 200

	if not init then
		mp = entityList:GetMyPlayer()
		me = entityList:GetMyHero()
		if not me then return end
		init = true
	end

	heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	for i,v in ipairs(heroes) do
		if not panel[v.playerId] then
			selftop = 0
			if v.team ~= me.team then
				selftop = centwidth
				if v.team == 2 then
					selftop = -1*selftop
				end
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
		mp:Select(me)
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
	registered = false
	collectgarbage("collect")
end

function Load()
	if registered then return end
	registered = true
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_TICK,Tick)

if client.connected and not client.loading then
	Load()
end
