-- Made by Sophylax for old version. Reworked by Staskkk for New version.

require("libs.Utils")

-- config
x = 50
y = 30
combokey = {"Z","X","C","T","V","B"}
-- 1 - TotalCombo: Tornado - EMP - Chaos Meteor - Deafening Blast - Cold Snap - Forge Spirit - Sun Strike - Ice Wall
-- 2 - TornadoEMPCombo: Tornado - EMP
-- 3 - TornadoMeteorWallCombo: Tornado - Chaos Meteor - Ice Wall
-- 4 - MeteorBlastCombo: Chaos Meteor - Deafening Blast
-- 5 - SnapDPSCombo: Cold Snap - Forge Spirit - Alacrity
-- 6 - EulSSMeteorBlast Eul - Sun Strike - Chaos Meteor - Deafening Blast
hotkey = {qqq="1", qqw="2", qww="3", www="4", wwe="5", wee="6", eee="7", qee="8", qqe="9", qwe="0"}
-- "Q" with space = 3 Quas, "W" with space = 3 Wex, "E" with space = 3 Exort
-- Tab - shows you combos hotkeys
range = 1000
-- code
sleepTick = 0
registered = false
unreg = false
init = false
font = drawMgr:CreateFont("invokerfont","Arial",14,500)
nextStep = false
currentTick = nil
comboTick = 0
trackTick = 0
forgeAttack = false
forgeTick = 0
sleeep = 0
cycleSleep = 0
wallCast = false
wallTick = 0
prepWall = false
prepTick = 0
target = nil
torndur = {0800,1100,1400,1700,2000,2300,2500}
empdelay = {3700,3400,3150,2850,2600,2300,2000}
queue = {}
future = {}
Keys = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
activeCombo = false
chatting = {false,false}
combos = {"TotalCombo","TornadoEMP","TornadoMeteorWall","MeteorBlast","SnapDPS","EulSSMeteorBlast"}
 
-------------------------- COMBO SETTINGS --------------------------

-- Tornado - EMP - Chaos Meteor - Deafening Blast - Cold Snap - Forge Spirit - Sun Strike - Ice Wall
function TotalCombo( )
        if me:GetAbility(1).level ~= 0 and me:GetAbility(2).level ~= 0 then
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-empdelay[me:GetAbility(2).level]+250},www,{"wait",100},wee,{"wait",1300},qwe,qqq,qee,eee}
        end
end
 
-- Tornado - EMP
function TornadoEMPCombo( )
        if me:GetAbility(1).level ~= 0 and me:GetAbility(2).level ~= 0 then
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-empdelay[me:GetAbility(2).level]+250},www}
        end
end
 
-- Tornado - Chaos Meteor - Ice Wall
function TornadoMeteorWallCombo( )
        if me:GetAbility(1).level ~= 0 then
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-1300},wee,{"wait",1000},qqe}
        end
end
 
-- Chaos Meteor - Deafening Blast
function MeteorBlastCombo( )
        queue = {wee,{"wait",1450},qwe}
end
 
-- Cold Snap - Forge Spirit - Alacrity
function SnapDPSCombo( )
        queue = {qqq,qee,wwe}
end
 
-- Eul - Sun Strike - Chaos Meteor - Deafening Blast
function EulSSMeteorBlast( )
        queue = {{"item_unit","item_cyclone"},{"wait",800},eee,{"wait",400},wee,{"wait",1000},qwe}
end
 
function StopCombo( )
        queue = {}
end
 
-------------------------- COMBO SETTINGS --------------------------
 
function Tick( tick )
 
        if not client.connected or client.loading or client.console or not entityList:GetMyHero() then
                return
        end
        if not init then
                me = entityList:GetMyHero()
                if me and me.name ~= "npc_dota_hero_invoker"  then
                        script:UnregisterEvent(Key)
                        script:UnregisterEvent(Tick)
                        unreg = true
                        return
                end
                mp = entityList:GetMyPlayer()
                text = drawMgr:CreateText(x,y,-1,"Invoker script",font)
                qqq = {me:GetAbility(1),me:GetAbility(1),me:GetAbility(1),"invoker_cold_snap",1000}
                qqw = {me:GetAbility(1),me:GetAbility(1),me:GetAbility(2),"invoker_ghost_walk",-1}
                qqe = {me:GetAbility(1),me:GetAbility(1),me:GetAbility(3),"invoker_ice_wall",300}
                qww = {me:GetAbility(1),me:GetAbility(2),me:GetAbility(2),"invoker_tornado",400 + (me:GetAbility(2).level * 400)}
                qwe = {me:GetAbility(1),me:GetAbility(2),me:GetAbility(3),"invoker_deafening_blast",1000}
                qee = {me:GetAbility(1),me:GetAbility(3),me:GetAbility(3),"invoker_forge_spirit",-1}
                www = {me:GetAbility(2),me:GetAbility(2),me:GetAbility(2),"invoker_emp",1000}
                wwe = {me:GetAbility(2),me:GetAbility(2),me:GetAbility(3),"invoker_alacrity",-1}
                wee = {me:GetAbility(2),me:GetAbility(3),me:GetAbility(3),"invoker_chaos_meteor",450+(150*me:GetAbility(2).level)}
                eee = {me:GetAbility(3),me:GetAbility(3),me:GetAbility(3),"invoker_sun_strike",-1}
                init = true
        end
        currentTick = tick
        if prepWall and tick > prepTick + 1000 and CanCast(GetSpell("invoker_ice_wall")) then
                CastIceWall(target)
                prepTick = false
        end
       
        if wallCast and tick > wallTick and CanCast(GetSpell("invoker_ice_wall")) then
                mp:Stop()
                mp:UseAbility(GetSpell("invoker_ice_wall"))
                wallCast = false
        end
       
        if forgeAttack and tick > forgeTick + 500 then
                ForgeAttack()
                forgeAttack = false
        end
       
        for i,v in ipairs(future) do
                if tick > v[2] then
                        CastInvoked(v[1][4])
                        table.remove(future,i)
                end
        end
       
        if me.alive == true and SleepCheck() then
                if Keys[15]  then
                        if Keys[1] then
                                Invoke(qqq)
                        elseif Keys[2] then
                                Invoke(qqw)
                        elseif Keys[3] then
                                Invoke(qww)
                        elseif Keys[4] then
                                Invoke(www)
                        elseif Keys[5] then
                                Invoke(wwe)
                        elseif Keys[6] then
                                Invoke(wee)
                        elseif Keys[7] then
                                Invoke(eee)
                        elseif Keys[8] then
                                Invoke(qee)
                        elseif Keys[9] then
                                Invoke(qqe)
                        elseif Keys[10] then
                                Invoke(qwe)
                        elseif Keys[11] then
                                PrepareCombo(TotalCombo( ))
                        elseif Keys[12] then
                                PrepareCombo(TornadoEMPCombo( ))
                        elseif Keys[13] then
                                PrepareCombo(TornadoMeteorWallCombo( ))
                        elseif Keys[14] then
                                PrepareCombo(MeteorBlastCombo( ))
                        elseif Keys[20] then
                                PrepareCombo(SnapDPSCombo( ))
                        elseif Keys[21] then
                                PrepareCombo(EulSSMeteorBlast( ))
                        elseif Keys[16] and CanCast(me:GetAbility(1)) then
                                mp:UseAbility(me:GetAbility(1))
                                mp:UseAbility(me:GetAbility(1))
                                mp:UseAbility(me:GetAbility(1))
                                Sleep(250)
                        elseif Keys[17] and CanCast(me:GetAbility(2)) then
                                mp:UseAbility(me:GetAbility(2))
                                mp:UseAbility(me:GetAbility(2))
                                mp:UseAbility(me:GetAbility(2))
                                Sleep(250)
                        elseif Keys[18] and CanCast(me:GetAbility(3)) then
                                mp:UseAbility(me:GetAbility(3))
                                mp:UseAbility(me:GetAbility(3))
                                mp:UseAbility(me:GetAbility(3))
                                Sleep(250)
                        end
                elseif SleepCheck() then
                        if Keys[1] then
                                CastCombination(qqq)
                        elseif Keys[2] then
                                CastCombination(qqw)
                        elseif Keys[3] then
                                CastCombination(qww)
                        elseif Keys[4] then
                                CastCombination(www)
                        elseif Keys[5] then
                                CastCombination(wwe)
                        elseif Keys[6] then
                                CastCombination(wee)
                        elseif Keys[7] then
                                CastCombination(eee)
                        elseif Keys[8] then
                                CastCombination(qee)
                        elseif Keys[9] then
                                CastCombination(qqe)
                        elseif Keys[10] then
                                CastCombination(qwe)
                        elseif Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not activeCombo then
                                 TotalCombo( )
                                activeCombo = true
                        elseif not Keys[11] and Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not activeCombo then
                                 TornadoEMPCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not activeCombo then
                                 TornadoMeteorWallCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and Keys[14] and not Keys[20] and not Keys[21] and not activeCombo then
                                 MeteorBlastCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and Keys[20] and not Keys[21] and not activeCombo then
                                 SnapDPSCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and Keys[21] and not activeCombo then
                                 EulSSMeteorBlast( )
                                activeCombo = true
                        elseif (Keys[11] or  Keys[12] or  Keys[13] or  Keys[14] or  Keys[20] or  Keys[21])and activeCombo then
                                Combo()
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] then
                                StopCombo()
                                activeCombo = false
                        end
                end
        end
        if tick <= sleeep then return end
        sleeep = tick + 200
        FindTarget()
        if target ~= nil and me then
                 text.text = "Target : "..string.sub(target.name,15).."; Distance : "..math.floor(GetDistance2D(target,me))
        else
                 text.text = "Search Range : "..range
        end
        if Keys[19] and me then
                local hkey = ""
                for i,v in ipairs(combokey) do
                        hkey = hkey..v..": "..combos[i].."; "
                end
                        text.text = hkey
        end
end
 
--Invokes the input combination
function Invoke(cmb)
        if cmb and cmb[4] and not HasSpell(cmb[4]) and SleepCheck() then
                invoke = me:GetAbility(6)
                if CanCast(invoke) and CanCast(cmb[1]) and CanCast(cmb[2]) and CanCast(cmb[3]) then
                        mp:UseAbility(cmb[1])
                        mp:UseAbility(cmb[2])
                        mp:UseAbility(cmb[3])
                        mp:UseAbility(invoke)
                        Sleep(250)
                end
        end
end
 
--Casts the combination whether if it is already invoked or not
function CastCombination(cmb)
        if cmb and cmb[4] and HasSpell(cmb[4])then
                CastInvoked(cmb[4])
        elseif cmb and cmb[4] and not HasSpell(cmb[4]) then
                CastUnInvoked(cmb)
        end
end
 
--Casts an uninvoked combination
function CastUnInvoked(cmb)
        Invoke(cmb)
        table.insert(future,{cmb,currentTick})
end
 
--Casts an invoked spell
function CastInvoked(SpellName)
        if SpellName and HasSpell(SpellName) then
                ProcessSpell(GetSpell(SpellName))
                Sleep(250)
        end
end
 
--Manages spells as no-target, ally-target, enemy-target and point-target
function ProcessSpell(spell)
        if spell and spell.name and CanCast(spell) then
                if spell.name == "invoker_ghost_walk" or (spell.name == "invoker_forge_spirit" and target) then
                        mp:UseAbility(spell)
                        if spell.name == "invoker_forge_spirit" then
                                forgeAttack = true
                                forgeTick = currentTick
                        end
                elseif spell.name == "invoker_ice_wall" then
                        CastIceWall(target)
                elseif spell.name == "invoker_alacrity" then
                        mp:UseAbility(spell,me)
                elseif target and spell.name == "invoker_cold_snap" then
                        mp:UseAbility(spell,target)
                elseif target then
                        mp:UseAbility(spell,target.position)
                end
                if InCombo() then
                        nextStep = true
                end
        elseif target then
                if InCombo() then
                        nextStep = true
                end
        end
end
 
--Returns true if the input spell can be casted
function CanCast(spell)
        return  spell and spell.level ~= 0 and spell.state == LuaEntityAbility.STATE_READY
end
 
--Returns true if Invoker has specified spell
function HasSpell(SpellName)
        return (me:GetAbility(4).name == SpellName) or (me:GetAbility(5).name == SpellName)
end
 
--Returns the spell from the name if invoker has it
function GetSpell(SpellName)
        if SpellName and HasSpell(SpellName) then
                if me:GetAbility(4).name == SpellName then
                        return me:GetAbility(4)
                else
                        return me:GetAbility(5)
                end
        end
end
 
function PrepareCombo(func)
        func()
        local tempqueue = {{"wait",10}}
        for k,v in pairs(queue) do tempqueue[k] = v end
        StopCombo()
       
        k = 1
        i = 1
        while i <= 2 do
                if tempqueue[k][1] ~= "wait" and tempqueue[k][1] ~= "item_unit" and tempqueue[k][1] ~= "item_point" and tempqueue[k][1] ~= "item_self" and tempqueue[k][1] ~= "item_notarget" then
                        Invoke(tempqueue[k])
                        i = i +1
                end
                k = k + 1
    end
end
 
function InCombo()
        return (Keys[11] or  Keys[12] or  Keys[13] or  Keys[14] or  Keys[20] or Keys[21])
end
 
function Combo()
        if #queue > 0 and InCombo and currentTick > comboTick then
                if queue[1][1] == "wait" then
                        comboTick = currentTick + queue[1][2]
                        table.remove(queue,1)
                elseif queue[1][1] == "item_unit" and target then
                        item = me:FindItem(queue[1][2])
                        if item and item.state == LuaEntityAbility.STATE_READY then
                                mp:UseAbility(item,target)
                                table.remove(queue,1)
                        end
                elseif queue[1][1] == "item_point" and target then
                        item = me:FindItem(queue[1][2])
                        if item and item.state == LuaEntityAbility.STATE_READY then
                                mp:UseAbility(item,target.position)
                                table.remove(queue,1)
                        end
                elseif queue[1][1] == "item_self" and target then
                        item = me:FindItem(queue[1][2])
                        if item and item.state == LuaEntityAbility.STATE_READY then
                                mp:UseAbility(item,me)
                                table.remove(queue,1)
                        end
                elseif queue[1][1] == "item_notarget" then
                        item = me:FindItem(queue[1][2])
                        if item and item.state == LuaEntityAbility.STATE_READY and target then
                                mp:UseAbility(item)
                                table.remove(queue,1)
                        end
                elseif target then
                        CastCombination(queue[1])
                        if nextStep then
                                table.remove(queue,1)
                                nextStep = false
                        end
                end
        end
        if #queue > 1 and InCombo then
                if queue[2][1] ~= "wait" and queue[2][1] ~= "item_unit" and queue[2][1] ~= "item_point" and queue[2][1] ~= "item_self" and queue[2][1] ~= "item_notarget" then
                        Invoke(queue[2])
                end
        end
end
 
function ForgeAttack()
        local forge = entityList:FindEntities({team=me.team,alive=true,visible=true})
        for i,v in ipairs(forge) do
                if (string.find(v.name,"Invoker Forged Spirit")) ~= nil then
                        mp:SelectAdd(v)
                end
        end
        mp:Unselect(me)
        mp:Attack(target)
        mp:Select(me)
end
  
function PrepareIceWall()
        mp:Stop()
        prepWall = true
        prepTick = currentTick
end
function CastIceWall(t)
        if t and GetDistance2D(me,t) < 700 and GetDistance2D(me,t) > 225 then
                mp:Stop()
                local v = {t.position.x-me.position.x,t.position.y-me.position.y}
                local a = math.acos(225/GetDistance2D(me,t))
                if a ~=nil then
                        local m = {}
                        x1 = rotateX(v[1],v[2],a)
                        y1 = rotateY(v[1],v[2],a)
                        if x1 and y1 then      
                                local k = {x1*25/math.sqrt((x1*x1)+(y1*y1)),y1*25/math.sqrt((x1*x1)+(y1*y1))}
                                mp:Move(Vector(k[1]+me.position.x,k[2]+me.position.y,me.position.z))
                                wallCast = true
                                wallTick = currentTick + a*1000/math.pi
                        end
                end
        end
end
 
function rotateX(x,y,angle)
        return x*math.cos(angle) - y*math.sin(angle)
end
       
function rotateY(x,y,angle)
        return y*math.cos(angle) + x*math.sin(angle)
end
 
--Sets target as the most vulnerable in the specified range
function FindTarget()
        if not InCombo() or not target or target.health < 0 or target.alive == false or target.visible == false then
                local lowenemy = nil
                local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,team=5-me.team,alive=true,visible=true,illusion=false})
                for i,v in ipairs(enemies) do
                        distance = GetDistance2D(me,v)
                        if distance <= range then
                                if lowenemy == nil then
                                        lowenemy = v
                                elseif (lowenemy.health*(1-lowenemy.magicDmgResist)) > (v.health*(1-v.magicDmgResist)) then
                                        lowenemy = v
                                end
                        end
                end
                target = lowenemy
        end
end

function Sleep(duration)
        sleepTick = currentTick + duration
end
 
function SleepCheck()
        return sleepTick == nil or currentTick > sleepTick
end
 
--Input detector
function Key( msg, code )
    if code == 13  then
        if msg == KEY_UP and chatting[2] then
            chatting[1] = (not chatting[1])
        end
        chatting[2] = (not chatting[2])
        end
        if chatting[1] then return end
       
                if code == string.byte(hotkey.qqq) then Keys[1] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.qqw) then Keys[2] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.qww) then Keys[3] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.www) then Keys[4] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.wwe) then Keys[5] = (msg == KEY_DOWN)    
        elseif code == string.byte(hotkey.wee) then Keys[6] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.eee) then Keys[7] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.qee) then Keys[8] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.qqe) then Keys[9] = (msg == KEY_DOWN)
        elseif code == string.byte(hotkey.qwe) then Keys[10] = (msg == KEY_DOWN)    
        elseif code == string.byte(combokey[1]) then Keys[11] = (msg == KEY_DOWN)
        elseif code == string.byte(combokey[2]) then Keys[12] = (msg == KEY_DOWN)
        elseif code == string.byte(combokey[3]) then Keys[13] = (msg == KEY_DOWN)
        elseif code == string.byte(combokey[4]) then Keys[14] = (msg == KEY_DOWN)
        elseif code == string.byte(combokey[5]) then Keys[20] = (msg == KEY_DOWN)
        elseif code == string.byte(combokey[6]) then Keys[21] = (msg == KEY_DOWN)   
        elseif code == string.byte(" ") then Keys[15] = (msg == KEY_DOWN)      
        elseif code == string.byte("Q") then Keys[16] = (msg == KEY_DOWN)      
        elseif code == string.byte("W") then Keys[17] = (msg == KEY_DOWN)      
        elseif code == string.byte("E") then Keys[18] = (msg == KEY_DOWN)
        elseif code == 0x09 then Keys[19] = (msg == KEY_DOWN)   --Tab
    elseif code == 219 then range = range - 10
    elseif code == 221 then range = range + 10
        end
end
 
function GetDistance2D(a,b)
        return math.sqrt(math.pow(a.position.x-b.position.x,2)+math.pow(a.position.y-b.position.y,2))
end
 
function Load()
        if registered then return end
        script:RegisterEvent(EVENT_KEY,Key)
        script:RegisterEvent(EVENT_TICK,Tick)
        registered = true
end
 
function Close()
	if not unreg then
        script:UnregisterEvent(Key)
        script:UnregisterEvent(Tick)
	end
	if text then text.visible = false end
    init = false
	collectgarbage("collect")
	registered = false
end
 
script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
 
if client.connected and not client.loading and not registered then
        Load()
end
