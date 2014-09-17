-- Made by Staskkk.

require("libs.Utils")
-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Fontsize", 20)
config:SetParameter("Imagesize", 20)
config:SetParameter("Distancefontimage", 15)
config:SetParameter("Verticaldistance", 14)
config:SetParameter("Antiheight", 150)
config:Load()

-- config
fontsize = config.Fontsize
imagesize = config.Imagesize
distance = config.Distancefontimage -- Distance between font and image. All parameters in pixels.
verticaldistance = config.Verticaldistance -- Distance between two different modifiers.
height = -1*config.Antiheight -- Height of modifiers (may be positive and negative).

-- Code
modifnames = {
{
"modifier_chen_test_of_faith_teleport",
"modifier_crystal_maiden_frostbite",
"modifier_ember_spirit_searing_chains",
"modifier_kunkka_x_marks_the_spot",
"modifier_meepo_earthbind",
"modifier_black_king_bar_immune",
"modifier_omniknight_repel",
"modifier_abaddon_borrowed_time",
"modifier_keeper_of_the_light_recall",
"modifier_pugna_decrepify",
"modifier_ghost_state",
"modifier_item_ethereal_blade_ethereal",
"modifier_juggernaut_blade_fury",
"modifier_nyx_assassin_spiked_carapace",
"modifier_medusa_stone_gaze",
"modifier_slark_shadow_dance",
"modifier_windrunner_windrun",
"modifier_brewmaster_primal_split",
"modifier_puck_phase_shift",
"modifier_heavens_halberd_debuff",
"modifier_tinker_laser_blind",
"modifier_invoker_deafening_blast_disarm",
"modifier_keeper_of_the_light_blinding_light",
"modifier_life_stealer_rage",
"modifier_bloodseeker_rupture"
},
{
"modifier_drowranger_wave_of_silence_knockback",
"modifier_ancientapparition_coldfeet_freeze",
"modifier_axe_berserkers_call",
"modifier_bane_nightmare",
"modifier_bane_fiends_grip",
"modifier_batrider_flaming_lasso",
"modifier_dark_seer_vacuum",
"modifier_earth_spirit_boulder_smash",
"modifier_earthshaker_fissure_stun",
"modifier_elder_titan_echo_stomp",
"modifier_faceless_void_timelock_freeze",
"modifier_invoker_cold_snap_freeze",
"modifier_invoker_deafening_blast_knockback",
"modifier_invoker_tornado",
"modifier_jakiro_ice_path_stun",
"modifier_kunkka_torrent",
"modifier_legion_commander_duel",
"modifier_lion_impale",
"modifier_lion_voodoo",
"modifier_lone_druid_spirit_bear_entangle_effect",
"modifier_magnataur_skewer_impact",
"modifier_magnataur_skewer_movement",
"modifier_medusa_stone_gaze_stone",
"modifier_morphling_adaptive_strike",
"modifier_naga_siren_ensnare",
"modifier_naga_siren_song_of_the_siren_aura",
"modifier_teleporting",
"modifier_necrolyte_reapers_scythe",
"modifier_nyx_assassin_impale",
"modifier_obsidian_destroyer_astral_imprisonment_prison",
"modifier_pudge_dismember",
"modifier_sandking_impale",
"modifier_shadow_shaman_voodoo",
"modifier_shadow_shaman_shackles",
"modifier_knockback",
"modifier_blinding_light_knockback",
"modifier_storm_spirit_electric_vortex_pull",
"modifier_tidehunter_ravage",
"modifier_tiny_avalanche_stun",
"modifier_treant_overgrowth",
"modifier_troll_warlord_berserkers_rage",
"modifier_tusk_walrus_punch_air_time",
"modifier_windrunner_shackle_shot",
"modifier_brewmaster_storm_cyclone",
"modifier_eul_cyclone",
"modifier_sheepstick_debuff",
"modifier_rattletrap_cog_push",
"modifier_shadow_demon_disruption",
"modifier_dark_troll_warlord_ensnare",
"modifier_stunned"
},
{
"modifier_bloodseeker_bloodrage",
"modifier_silence",
"modifier_doom_bringer_doom",
"modifier_earth_spirit_boulder_smash_silence",
"modifier_night_stalker_crippling_fear",
"modifier_silencer_global_silence",
"modifier_skywrath_mage_ancient_seal",
"modifier_orchid_malevolence_debuff"
}
}

function regi(v,z)
	if not timers[v.handle] then
		timers[v.handle] = {}
	end
	if not timers[v.handle][z] then
		timers[v.handle][z] = {}
		local offset = v.healthbarOffset+height
		timers[v.handle][z].time = drawMgr:CreateText(0,0,-1,"",font)
		timers[v.handle][z].texture = drawMgr:CreateRect(0,0,imagesize,imagesize,0x000000FF)
		timers[v.handle][z].time.entity = v
		timers[v.handle][z].texture.entity = v
		timers[v.handle][z].time.entityPosition = Vector(0, (imagesize+verticaldistance)*z-1, offset)
		timers[v.handle][z].texture.entityPosition = Vector(-1*(imagesize+distance), (imagesize+verticaldistance)*z-1, offset)
	end
end

function Modifadd(v,modif)
	if (v.type == LuaEntity.TYPE_HERO and not v.illusion) or (v.type == LuaEntity.TYPE_NPC and v.modifiers and (v.modifiers[1].name == "modifier_enigma_black_hole_thinker" or v.modifiers[1].name == "modifier_disruptor_static_storm_thinker" or v.modifiers[1].name == "modifier_riki_smoke_screen_thinker" or v.modifiers[1].name == "modifier_faceless_void_chronosphere_selfbuff" or v.modifiers[1].name == "modifier_phoenix_sun")) then
		z = 0
		stun = false
		while not stun and z ~= 3 do
			z = z+1
			x = 0
			while not stun and x ~= #modifnames[z] do
				x = x+1
				if v.type == LuaEntity.TYPE_NPC or (modif.name == modifnames[z][x] and (not timers[v.handle] or not timers[v.handle][z] or not timers[v.handle][z].time.visible or (timers[v.handle][z].entity:FindModifier(timers[v.handle][z].name) and modif.remainingTime > timers[v.handle][z].modif.remainingTime))) then
					regi(v,z)
					timers[v.handle][z].entity = v
					timers[v.handle][z].modif = modif
					timers[v.handle][z].name = modif.name
					timers[v.handle][z].time.visible = true
					if v.type ~= LuaEntity.TYPE_NPC then
						timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/"..string.sub(modif.name,10))
					else
						timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/"..modif.texture)
					end
					timers[v.handle][z].texture.visible = true
					stun = true
				end
			end
		end
	end
end

function Tick(tick)
	if not client.connected or client.loading or client.console or not entityList:GetMyHero() then
		return
	end
	if sleeptick < tick then
		sleeptick = tick+50
		entities[1] = entityList:GetEntities({classId = CDOTA_BaseNPC})
		entities[2] = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
		entities[3] = entityList:GetEntities({classId = CDOTA_BaseNPC_Additive})
		for _,w in ipairs(entities) do
			for i,v in ipairs(w) do
				for q = 1,3 do
					if timers[v.handle] and timers[v.handle][q] and timers[v.handle][q].time.visible then
						if not timers[v.handle][q].name then
							if not v.alive then
								timers[v.handle][q].time.text = tostring(math.floor(v.respawnTime*10)/10)
							else
								timers[v.handle][q].time.visible = false
								timers[v.handle][q].texture.visible = false
								timers[v.handle][q].visible = false
								timers[v.handle][q].name = "1"
							end
						elseif timers[v.handle][q].entity:FindModifier(timers[v.handle][q].name) then
							if timers[v.handle][q].name ~= "modifier_enigma_black_hole_thinker" then
								timers[v.handle][q].time.text = tostring(math.floor(timers[v.handle][q].modif.remainingTime*10)/10)
								if timers[v.handle][q].modif.texture == "wisp_relocate" then
									if math.floor(timers[v.handle][q].modif.remainingTime*10) == 1 then
										wisp.pos = v.position
									elseif timers[v.handle][q].modif.remainingTime == 0 then
										count = 121
										pretime,delay = math.modf(client.totalGameTime*10)
										pretime = pretime+1
									end
								end
							else
								timers[v.handle][q].time.text = tostring(math.floor((4-timers[v.handle][q].modif.elapsedTime)*10)/10)
							end
						else
							timers[v.handle][q].time.visible = false
							timers[v.handle][q].texture.visible = false
							timers[v.handle][q].visible = false
						end
					end
				end
				if v.reincarnating then
					regi(v,3)
					timers[v.handle][3].entity = v
					timers[v.handle][3].modif = nil
					timers[v.handle][3].name = nil
					timers[v.handle][3].time.visible = true
					timers[v.handle][3].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/skeleton_king_reincarnate_slow")
					timers[v.handle][3].texture.visible = true
				end
			end
		end
	end
	if pretime then
		local gametime = client.totalGameTime*10
		if gametime >= pretime+delay then
			pretime = pretime+1
			count = count-1
			wisp.time.text = tostring(count/10)
		end
		q,positi = client:ScreenPosition(wisp.pos)
		if q then
			wisp.time.position = Vector2D(positi.x+distance,positi.y)
			wisp.texture.position = Vector2D(positi.x-distance,positi.y)
			if not wisp.time.visible then
				wisp.time.visible = true
				wisp.texture.visible = true
			end
		elseif wisp.time.visible then
			wisp.time.visible = false
			wisp.texture.visible = false
		end
		if count == 0 then
			wisp.time.visible = false
			wisp.texture.visible = false
			pretime = nil
		end
	end
end

function Load()
	if registered then return end
font = drawMgr:CreateFont("timersfont","Arial",fontsize,500)
timers = {}
entities = {}
wisp = {}
wisp.time = drawMgr:CreateText(0,0,-1,"",font)
wisp.time.visible = false
wisp.texture = drawMgr:CreateRect(0,0,imagesize,imagesize,0x000000FF,drawMgr:GetTextureId("NyanUI/modifiers/wisp_relocate_return"))
wisp.texture.visible = false
registered = false
sleeptick = 0
	script:RegisterEvent(EVENT_TICK,Tick)
	script:RegisterEvent(EVENT_MODIFIER_ADD,Modifadd)
	registered = true
end

function Close()
	script:UnregisterEvent(Tick)
	script:UnregisterEvent(Modifadd)
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
