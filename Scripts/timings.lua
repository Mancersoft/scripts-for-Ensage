-- Made by Staskkk.

require("libs.Utils")

-- config
fontsize = 20
imagesize = 20
distance = 15 -- Distance between font and image. All parameters in pixels.
verticaldistance = 14 -- Distance between two different modifiers.
height = -14 -- Height of modifiers (may be positive and negative).

-- Code
modifnames = {
{"modifier_ancientapparition_coldfeet_freeze",1},
{"modifier_axe_berserkers_call",1},
{"modifier_bane_nightmare",1},
{"modifier_bane_fiends_grip",1},
{"modifier_batrider_flaming_lasso",1},
{"modifier_chen_test_of_faith_teleport",0},
{"modifier_crystal_maiden_frostbite",0},
{"modifier_dark_seer_vacuum",1},
{"modifier_earth_spirit_boulder_smash",1},
{"modifier_earthshaker_fissure_stun",1},
{"modifier_elder_titan_echo_stomp",1},
{"modifier_ember_spirit_searing_chains",0},
{"modifier_enigma_black_hole_pull",1},
{"modifier_faceless_void_timelock_freeze",1},
{"modifier_faceless_void_chronosphere_freeze",1},
{"modifier_invoker_cold_snap_freeze",1},
{"modifier_invoker_deafening_blast_knockback",1},
{"modifier_invoker_tornado",1},
{"modifier_jakiro_ice_path_stun",1},
{"modifier_kunkka_torrent",1},
{"modifier_kunkka_x_marks_the_spot",0},
{"modifier_legion_commander_duel",1},
{"modifier_lion_impale",1},
{"modifier_lion_voodoo",1},
{"modifier_lone_druid_spirit_bear_entangle_effect",1},
{"modifier_magnataur_skewer_impact",1},
{"modifier_magnataur_skewer_movement",1},
{"modifier_medusa_stone_gaze_stone",1},
{"modifier_meepo_earthbind",0},
{"modifier_morphling_adaptive_strike",1},
{"modifier_naga_siren_ensnare",1},
{"modifier_naga_siren_song_of_the_siren_aura",1},
{"modifier_teleporting",1},
{"modifier_necrolyte_reapers_scythe",1},
{"modifier_nyx_assassin_impale",1},
{"modifier_obsidian_destroyer_astral_imprisonment_prison",1},
{"modifier_pudge_dismember",1},
{"modifier_sandking_impale",1},
{"modifier_shadow_shaman_voodoo",1},
{"modifier_shadow_shaman_shackles",1},
{"modifier_knockback",1},
{"modifier_blinding_light_knockback",1},
{"modifier_storm_spirit_electric_vortex_pull",1},
{"modifier_tidehunter_ravage",1},
{"modifier_tiny_avalanche_stun",1},
{"modifier_treant_overgrowth",1},
{"modifier_troll_warlord_berserkers_rage",1},
{"modifier_tusk_walrus_punch_air_time",1},
{"modifier_windrunner_shackle_shot",1},
{"modifier_brewmaster_storm_cyclone",1},
{"modifier_eul_cyclone",1},
{"modifier_sheepstick_debuff",1},
{"modifier_black_king_bar_immune",0},
{"modifier_omniknight_repel",0},
{"modifier_abaddon_borrowed_time",0},
{"modifier_keeper_of_the_light_recall",0},
{"modifier_drowranger_wave_of_silence_knockback",0},
{"modifier_pugna_decrepify",0},
{"modifier_ghost_state",0},
{"modifier_item_ethereal_blade_ethereal",0},
{"modifier_rattletrap_cog_push",1},
{"modifier_shadow_demon_disruption",1},
{"modifier_dark_troll_warlord_ensnare",1},
{"modifier_stunned",1},
{"modifier_bloodseeker_bloodrage",2},
{"modifier_silence",2},
{"modifier_disruptor_static_storm",2},
{"modifier_doom_bringer_doom",2},
{"modifier_earth_spirit_boulder_smash_silence",2},
{"modifier_juggernaut_blade_fury",0},
{"modifier_nyx_assassin_spiked_carapace",0},
{"modifier_medusa_stone_gaze",0},
{"modifier_night_stalker_crippling_fear",2},
{"modifier_riki_smoke_screen",2},
{"modifier_silencer_global_silence",2},
{"modifier_skywrath_mage_ancient_seal",2},
{"modifier_slark_shadow_dance",0},
{"modifier_windrunner_windrun",0},
{"modifier_brewmaster_primal_split",0},
{"modifier_phoenix_supernova_hiding",0},
{"modifier_puck_phase_shift",0},
{"modifier_sniper_assassinate",0},
{"modifier_orchid_malevolence_debuff",2},
{"modifier_heavens_halberd_debuff",0},
{"modifier_tinker_laser_blind",0},
{"modifier_invoker_deafening_blast_disarm",0},
{"modifier_keeper_of_the_light_blinding_light",0}
}

font = drawMgr:CreateFont("timersfont","Arial",fontsize,500)
timers = {}
k = {}
registered = false
sleeptick = 0

function Tick(tick)
	if not client.connected or client.loading or sleeptick > tick or client.console or not entityList:GetMyHero() then
		return
	end
	sleeptick = tick+50
	heroes = entityList:GetEntities({type=LuaEntity.TYPE_HERO, illusion = false})
	for i,v in ipairs(heroes) do
		local offset = v.healthbarOffset+height
		for z = 0,2 do
			local f = 0
			for d,t in ipairs(modifnames) do
				if t[2] == z then
					m = v:FindModifier(t[1])
					if m and f < m.remainingTime then 
						f = m.remainingTime
						s = m
					end
				end
			end
			if s then
				if not timers[v.handle] then
					timers[v.handle] = {}
					k[v.handle] = {}
				end
				if not timers[v.handle][z] then
					timers[v.handle][z] = {}
					timers[v.handle][z].time = drawMgr:CreateText(0,0,-1,"",font)
					timers[v.handle][z].texture = drawMgr:CreateRect(0,0,imagesize,imagesize,0x000000FF)
					timers[v.handle][z].time.visible = false
					timers[v.handle][z].texture.visible = false
					timers[v.handle][z].time.entity = v
					timers[v.handle][z].texture.entity = v
					timers[v.handle][z].time.entityPosition = Vector(0, (imagesize+verticaldistance)*z, offset)
					timers[v.handle][z].texture.entityPosition = Vector(-1*(imagesize+distance), (imagesize+verticaldistance)*z, offset)
				end
				if s.name ~= k[v.handle][z] then
					timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/"..string.sub(s.name,10))
					k[v.handle][z] = s.name
				end
				if not timers[v.handle][z].time.visible then
					timers[v.handle][z].time.visible = true
					timers[v.handle][z].texture.visible = true
				end
				timers[v.handle][z].time.text = tostring(math.floor(s.remainingTime*10)/10)
			elseif timers[v.handle] and timers[v.handle][z] and timers[v.handle][z].time.visible then
				timers[v.handle][z].time.visible = false
				timers[v.handle][z].texture.visible = false
			end
			s = nil
		end
	end
end

function Load()
	if registered then return end
	script:RegisterEvent(EVENT_TICK,Tick)
	registered = true
end

function Close()
	script:UnregisterEvent(Tick)
	collectgarbage("collect")
	registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
	Load()
end
