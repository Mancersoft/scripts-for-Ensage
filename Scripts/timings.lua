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
"modifier_sniper_assassinate",
"modifier_heavens_halberd_debuff",
"modifier_tinker_laser_blind",
"modifier_invoker_deafening_blast_disarm",
"modifier_keeper_of_the_light_blinding_light",
"modifier_life_stealer_rage"
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
"modifier_enigma_black_hole_pull",
"modifier_faceless_void_timelock_freeze",
"modifier_faceless_void_chronosphere_freeze",
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
"modifier_disruptor_static_storm",
"modifier_doom_bringer_doom",
"modifier_earth_spirit_boulder_smash_silence",
"modifier_night_stalker_crippling_fear",
"modifier_riki_smoke_screen",
"modifier_silencer_global_silence",
"modifier_skywrath_mage_ancient_seal",
"modifier_orchid_malevolence_debuff"
}
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
			for d,t in ipairs(modifnames[z+1]) do
				m = v:FindModifier(t)
				if m and f < m.remainingTime then 
					f = m.remainingTime
					s = m
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
