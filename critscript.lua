-- 100% critical strike. Made by Staskkk. It DOESN'T work with CRYSTALYS or DAEDALUS and with fast attack, sorry.

-- Config
hotkey = "F"
x = 50
y = 30

-- Code
activated = false
registered = false
wait = false
stwait = true
font = drawMgr:CreateFont("critfont","Arial",14,500)
defaultText = "Critscript: Disabled"
text = drawMgr:CreateText(x,y,-1,defaultText,font)

function Key(msg,code)
	if msg ~= KEY_DOWN or not client.connected or client.loading then
		return
	end
	if code == string.byte(hotkey) then
		mh = entityList:GetMyHero()
		if mh.name ~= "npc_dota_hero_juggernaut" and mh.name ~= "npc_dota_hero_phantom_assassin" 
		and mh.name ~= "npc_dota_hero_brewmaster" and mh.name ~= "npc_dota_hero_skeleton_king" 
		and mh.name ~= "npc_dota_hero_chaos_knight" then
			script:Disable() Close() return
		end
		if not activated then
			me = entityList:GetMyPlayer()
			text.text = "Critscript: Enabled"
		else
			text.text = defaultText
		end
		activated = not activated
	end
end

function Tick(tick)
	if not activated then
		return
	end
	if mh.activity == 424 and not wait then
		stwait = false
		me:HoldPosition()
		wait = true
	end
	if mh.activity == 419 and not stwait then
		wait = false
		me:AttackMove(client.mousePosition)
		stwait = true
	end
end

function Close()
	text.text = defaultText
	text.visible = false
	activated = false
	mh = nil
	registered = false
end

function Load()
	if registered then return end
	text.visible = true
	registered = true
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)

if client.connected and not client.loading then
	Load()
end
