--<<Invoker helper. Combos and hotkeys for spells and orbs>>
-- Made by Sophylax for old version. Reworked by Staskkk for New version.

require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("combo1", "Z")
config:SetParameter("combo2", "X")
config:SetParameter("combo3", "C")
config:SetParameter("combo4", "T")
config:SetParameter("combo5", "V")
config:SetParameter("combo6", "B")
config:SetParameter("combo7", "G")
config:SetParameter("combo8", "H")
config:SetParameter("a1qqq", "1")
config:SetParameter("a2qqw", "2")
config:SetParameter("a3qww", "3")
config:SetParameter("a4www", "4")
config:SetParameter("a5wwe", "5")
config:SetParameter("a6wee", "6")
config:SetParameter("a7eee", "7")
config:SetParameter("a8qee", "8")
config:SetParameter("a9qqe", "9")
config:SetParameter("a0qwe", "0")
config:SetParameter("KeyForCastingOrbs", "space")
config:SetParameter("Xcord", 50)
config:SetParameter("Ycord", 30)
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
                elseif strkey == "f1" then return 112
                elseif strkey == "f2" then return 113
                elseif strkey == "f3" then return 114
                elseif strkey == "f4" then return 115
                elseif strkey == "f5" then return 116
                elseif strkey == "f6" then return 117
                elseif strkey == "f7" then return 118
                elseif strkey == "f8" then return 119
                elseif strkey == "f9" then return 120
                elseif strkey == "f10" then return 121
                elseif strkey == "f11" then return 122
                elseif strkey == "f12" then return 123
                elseif strkey == "space" then return 32
                elseif strkey == "alt" then return 18
                elseif strkey == "backspace" then return 8
                elseif strkey == "tab" then return 9
                elseif strkey == "enter" then return 13
                elseif strkey == "shift" then return 16
                elseif strkey == "ctrl" then return 17
                elseif strkey == "capslock" then return 20
                elseif strkey == "esc" then return 27
                elseif strkey == "insert" then return 45
                elseif strkey == "pageup" then return 33
                elseif strkey == "pagedown" then return 34
                elseif strkey == "end" then return 35
                elseif strkey == "home" then return 36
                elseif strkey == "arrow_left" then return 37
                elseif strkey == "arrow_up" then return 38
                elseif strkey == "arrow_right" then return 39
                elseif strkey == "arrow_down" then return 40
                elseif strkey == "delete" then return 46
                elseif strkey == "printscreen" then return 44
                elseif strkey == "scrolllock" then return 145
                elseif strkey == "pause" then return 19
                elseif strkey == "numlock" then return 144
                elseif strkey == "lwin" then return 91
                elseif strkey == "rwin" then return 92
                elseif strkey == "apps" then return 93
                elseif string.len(strkey) > 2 or strkey == "" then return 124
                else return string.byte( strkey )
        end
end

-- config
x = config.Xcord
y = config.Ycord
KeyForCastingOrbs = numpad(config.KeyForCastingOrbs)
combokey = {numpad(config.combo1),numpad(config.combo2),numpad(config.combo3),numpad(config.combo4),numpad(config.combo5),numpad(config.combo6),
numpad(config.combo7),numpad(config.combo8)}
-- 1 - TotalCombo: Tornado - EMP - Chaos Meteor - Deafening Blast - Cold Snap - Forge Spirit - Sun Strike - Ice Wall
-- 2 - TornadoEMPCombo: Tornado - EMP
-- 3 - TornadoMeteorWallCombo: Tornado - Chaos Meteor - Ice Wall
-- 4 - MeteorBlastCombo: Chaos Meteor - Deafening Blast
-- 5 - SnapDPSCombo: Cold Snap - Forge Spirit - Alacrity
-- 6 - EulSSMeteorBlast Eul - Sun Strike - Chaos Meteor - Deafening Blast
-- 7 - Tornado - EMP - Chaos Meteor - Deafening Blast
-- 8 - Tornado - Chaos Meteor - Deafening Blast
hotkey = {numpad(config.a1qqq), numpad(config.a2qqw), numpad(config.a3qww), numpad(config.a4www), numpad(config.a5wwe), numpad(config.a6wee), numpad(config.a7eee), numpad(config.a8qee), numpad(config.a9qqe), numpad(config.a0qwe)}
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
torndur = {800,1100,1400,1700,2000,2300,2500}
empdelay = 2900
meteordelay = 1300
tornspeed = 1000
--blastspeed = 1000
sundelay = 1700

queue = {}
future = {}
Keys = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
activeCombo = false
chatting = {false,false}
combos = {"TotalCombo","TornadoEMP","TornadoMeteorWall","MeteorBlast","SnapDPS","EulSSMeteorBlast","TornadoEMPBlast","TornadoMeteorBlast"}
 
-------------------------- COMBO SETTINGS --------------------------

-- Tornado - EMP - Chaos Meteor - Deafening Blast - Cold Snap - Forge Spirit - Sun Strike - Ice Wall
function TotalCombo( )
        if target then
                local blasttime = math.floor((GetDistance2D(me,target)-34)/tornspeed*1000)
                local torntime = blasttime+torndur[me:GetAbility(1).level]
                if torntime > empdelay and torntime > meteordelay then
                        torntime = torntime-300
                        if torntime-empdelay < 0 then torntime = empdelay end
                        queue = {qww,{"wait",torntime-empdelay},www,{"wait",empdelay-meteordelay-700},wee,{"wait",meteordelay-blasttime},qwe,qqq,qee,eee}
                elseif torntime > meteordelay then
                        torntime = torntime+300
                        if empdelay-torntime < 0 then torntime = empdelay end
                        meteordel = meteordelay+700
                        if torntime-meteordel < 0 then meteordel = torntime end
                        queue = {www,{"wait",empdelay-torntime},qww,{"wait",torntime-meteordel},wee,{"wait",meteordel-blasttime},qwe,qqq,qee,eee}
                else
                        torntime = torntime+300
                        queue = {www,wee,qww,{"wait",torntime-blasttime},qwe,qqq,qee,eee}
                end
        else
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-empdelay+250},www,{"wait",100},wee,{"wait",1300},qwe,qqq,qee,eee}
        end
end
 
-- Tornado - EMP
function TornadoEMPCombo( )
        if target then
                local torntime = math.floor((GetDistance2D(me,target)-34)/tornspeed*1000)+torndur[me:GetAbility(1).level]
                if torntime > empdelay then
                        torntime = torntime-300
                        if torntime-empdelay < 0 then torntime = empdelay end
                        queue = {qww,{"wait",torntime-empdelay},www}
                else
                        torntime = torntime+300
                        if empdelay-torntime < 0 then torntime = empdelay end
                        queue = {www,{"wait",empdelay-torntime},qww}
                end
        else
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-empdelay+250},www}
        end
end
 
-- Tornado - Chaos Meteor - Ice Wall
function TornadoMeteorWallCombo( )
        if target then
                local torntime = math.floor((GetDistance2D(me,target)-34)/tornspeed*1000)+torndur[me:GetAbility(1).level]
                if torntime > meteordelay then
                        torntime = torntime-300
                        if torntime-meteordelay < 0 then torntime = meteordelay end
                        queue = {qww,{"wait",torntime-meteordelay},wee,qqe}
                else
                        torntime = torntime+300
                        if meteordelay-torntime < 0 then torntime = meteordelay end
                        queue = {wee,{"wait",meteordelay-torntime},qww,qqe}
                end
        else
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-1300},wee,{"wait",1000},qqe}
        end
end
 
-- Chaos Meteor - Deafening Blast
function MeteorBlastCombo( )
        queue = {wee,{"wait",700},qwe}
end
 
-- Cold Snap - Forge Spirit - Alacrity
function SnapDPSCombo( )
        queue = {qqq,qee,wwe}
end
 
-- Eul - Sun Strike - Chaos Meteor - Deafening Blast
function EulSSMeteorBlast( )
        if target then
            local me = entityList:GetMyHero()
            local cyclone = me:FindItem("item_cyclone")
            if cyclone and cyclone:CanBeCasted() then
                me:CastAbility(cyclone, target)
                return
			end
		else
			 queue = {{"item_unit","item_cyclone"},{"wait",1000},eee,{"wait",400},wee,qwe}
        end		
end
 
-- Tornado - EMP - Chaos Meteor - Deafening Blast
function TornadoEMPMeteorBlastCombo( )
        if target then
                local blasttime = math.floor((GetDistance2D(me,target)-34)/tornspeed*1000)
                local torntime = blasttime+torndur[me:GetAbility(1).level]
                if torntime > empdelay and torntime > meteordelay then
                        torntime = torntime-300
                        if torntime-empdelay < 0 then torntime = empdelay end
                        queue = {qww,{"wait",torntime-empdelay},www,{"wait",empdelay-meteordelay-700},wee,{"wait",meteordelay-blasttime},qwe}
                elseif torntime > meteordelay then
                        torntime = torntime+300
                        if empdelay-torntime < 0 then torntime = empdelay end
                        meteordel = meteordelay+700
                        if torntime-meteordel < 0 then meteordel = torntime end
                        queue = {www,{"wait",empdelay-torntime},qww,{"wait",torntime-meteordel},wee,{"wait",meteordel-blasttime},qwe}
                else
                        torntime = torntime+300
                        queue = {www,wee,qww,{"wait",torntime-blasttime},qwe,qqq,qee,eee}
                end
        else
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-empdelay+250},www,{"wait",100},wee,{"wait",1300},qwe}
        end
end
 
-- Tornado - Chaos Meteor - Deafening Blast
function TornadoMeteorBlastCombo( )
        if target then
                local blasttime = math.floor((GetDistance2D(me,target)-34)/tornspeed*1000)
                local torntime = blasttime+torndur[me:GetAbility(1).level]
                if torntime > meteordelay then
                        torntime = torntime-300
                        if torntime-meteordelay < 0 then torntime = meteordelay end
                        queue = {qww,{"wait",torntime-meteordelay},wee,{"wait",meteordelay-blasttime-400},qwe}
                else
                        torntime = torntime+300
                        if meteordelay-torntime < 0 then torntime = meteordelay end
                        queue = {wee,{"wait",meteordelay-torntime},qww,{"wait",torntime-blasttime-700},qwe}
                end
        else
                queue = {qww,{"wait",torndur[me:GetAbility(1).level]-1600},wee,{"wait",1450},qwe}
        end
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
                        elseif Keys[22] then
                                PrepareCombo(TornadoEMPMeteorBlastCombo( ))
                        elseif Keys[23] then
                                PrepareCombo(TornadoMeteorBlastCombo( ))
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
                        elseif Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 first = true
                                 TotalCombo( )
                                activeCombo = true
                        elseif not Keys[11] and Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 TornadoEMPCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 TornadoMeteorWallCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 MeteorBlastCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 SnapDPSCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and Keys[21] and not Keys[22] and not Keys[23] and not activeCombo then
                                 EulSSMeteorBlast( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and Keys[22] and not Keys[23] and not activeCombo then
                                 TornadoEMPMeteorBlastCombo( )
                                activeCombo = true
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and Keys[23] and not activeCombo then
                                 TornadoMeteorBlastCombo( )
                                activeCombo = true
                        elseif (Keys[11] or  Keys[12] or  Keys[13] or  Keys[14] or  Keys[20] or  Keys[21] or Keys[22] or Keys[23])and activeCombo then
                                Combo()
                        elseif not Keys[11] and not Keys[12] and not Keys[13] and not Keys[14] and not Keys[20] and not Keys[21] and not Keys[22] and not Keys[23] then
                                first = false
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
		if target~= nil and me then
		    local cycloneModif = target:FindModifier("modifier_eul_cyclone")
		    if cycloneModif then
		        if cycloneModif.remainingTime < 1.80 then 
                    queue = {eee} 
			    end
		    end
		    if cycloneModif then
		        if cycloneModif.remainingTime < 1.3 then 
                    queue = {wee} 
			    end
		    end
            if cycloneModif then
		        if cycloneModif.remainingTime < 0.6 then 
                    queue = {qwe} --I'm not much of scripter per say, so this might seem odd the way I separated it, but it works much better.
			    end
		    end
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
        if func == nil then return end
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
        return (Keys[11] or  Keys[12] or  Keys[13] or  Keys[14] or  Keys[20] or Keys[21] or Keys[22] or Keys[23])
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
                        if first then
                                fir = entityList:GetEntities(function (a) return a.name == queue[1][4] end)
                                if fir[1] and fir[1].cd ~= 0 then
                                        table.remove(queue,1)
                                else
                                        CastCombination(queue[1])
                                        if nextStep then
                                                table.remove(queue,1)
                                                nextStep = false
                                        end
                                end
                        else
                                CastCombination(queue[1])
                                if nextStep then
                                        table.remove(queue,1)
                                        nextStep = false
                                end
                        end
                end
        end
        if #queue == 0 then first = false end
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
                if code == hotkey[1] then Keys[1] = (msg == KEY_DOWN)
        elseif code == hotkey[2] then Keys[2] = (msg == KEY_DOWN)
        elseif code == hotkey[3] then Keys[3] = (msg == KEY_DOWN)
        elseif code == hotkey[4] then Keys[4] = (msg == KEY_DOWN)
        elseif code == hotkey[5] then Keys[5] = (msg == KEY_DOWN)    
        elseif code == hotkey[6] then Keys[6] = (msg == KEY_DOWN)
        elseif code == hotkey[7] then Keys[7] = (msg == KEY_DOWN)
        elseif code == hotkey[8] then Keys[8] = (msg == KEY_DOWN)
        elseif code == hotkey[9] then Keys[9] = (msg == KEY_DOWN)
        elseif code == hotkey[10] then Keys[10] = (msg == KEY_DOWN)    
        elseif code == combokey[1] then Keys[11] = (msg == KEY_DOWN)
        elseif code == combokey[2] then Keys[12] = (msg == KEY_DOWN)
        elseif code == combokey[3] then Keys[13] = (msg == KEY_DOWN)
        elseif code == combokey[4] then Keys[14] = (msg == KEY_DOWN)
        elseif code == combokey[5] then Keys[20] = (msg == KEY_DOWN)
        elseif code == combokey[6] then Keys[21] = (msg == KEY_DOWN)
        elseif code == combokey[7] then Keys[22] = (msg == KEY_DOWN)
        elseif code == combokey[8] then Keys[23] = (msg == KEY_DOWN)
        elseif code == KeyForCastingOrbs then Keys[15] = (msg == KEY_DOWN)      
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
        first = false
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
