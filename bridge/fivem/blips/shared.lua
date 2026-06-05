local blips = {}

local sprites = {
    {blipId = 0, name = 'radar_higher'},
    {blipId = 1, name = 'radar_level'},
    {blipId = 2, name = 'radar_lower'},
    {blipId = 3, name = 'radar_police_ped'},
    {blipId = 4, name = 'radar_wanted_radius'},
    {blipId = 5, name = 'radar_area_blip'},
    {blipId = 6, name = 'radar_centre'},
    {blipId = 7, name = 'radar_north'},
    {blipId = 8, name = 'radar_waypoint'},
    {blipId = 9, name = 'radar_radius_blip'},
    {blipId = 10, name = 'radar_radius_outline_blip'},
    {blipId = 11, name = 'radar_weapon_higher'},
    {blipId = 12, name = 'radar_weapon_lower'},
    {blipId = 13, name = 'radar_higher_ai'},
    {blipId = 14, name = 'radar_lower_ai'},
    {blipId = 15, name = 'radar_police_heli_spin'},
    {blipId = 16, name = 'radar_police_plane_move'},
    {blipId = 27, name = 'radar_mp_crew'},
    {blipId = 28, name = 'radar_mp_friendlies'},
    {blipId = 36, name = 'radar_cable_car'},
    {blipId = 37, name = 'radar_activities'},
    {blipId = 38, name = 'radar_raceflag'},
    {blipId = 40, name = 'radar_safehouse'},
    {blipId = 41, name = 'radar_police'},
    {blipId = 42, name = 'radar_police_chase'},
    {blipId = 43, name = 'radar_police_heli'},
    {blipId = 44, name = 'radar_bomb_a'},
    {blipId = 47, name = 'radar_snitch'},
    {blipId = 48, name = 'radar_planning_locations'},
    {blipId = 50, name = 'radar_crim_carsteal'},
    {blipId = 51, name = 'radar_crim_drugs'},
    {blipId = 52, name = 'radar_crim_holdups'},
    {blipId = 54, name = 'radar_crim_player'},
    {blipId = 56, name = 'radar_cop_patrol'},
    {blipId = 57, name = 'radar_cop_player'},
    {blipId = 58, name = 'radar_crim_wanted'},
    {blipId = 59, name = 'radar_heist'},
    {blipId = 60, name = 'radar_police_station'},
    {blipId = 61, name = 'radar_hospital'},
    {blipId = 62, name = 'radar_assassins_mark'},
    {blipId = 63, name = 'radar_elevator'},
    {blipId = 64, name = 'radar_helicopter'},
    {blipId = 66, name = 'radar_random_character'},
    {blipId = 67, name = 'radar_security_van'},
    {blipId = 68, name = 'radar_tow_truck'},
    {blipId = 70, name = 'radar_illegal_parking'},
    {blipId = 71, name = 'radar_barber'},
    {blipId = 72, name = 'radar_car_mod_shop'},
    {blipId = 73, name = 'radar_clothes_store'},
    {blipId = 75, name = 'radar_tattoo'},
    {blipId = 76, name = 'radar_armenian_family'},
    {blipId = 77, name = 'radar_lester_family'},
    {blipId = 78, name = 'radar_michael_family'},
    {blipId = 79, name = 'radar_trevor_family'},
    {blipId = 80, name = 'radar_jewelry_heist'},
    {blipId = 82, name = 'radar_drag_race_finish'},
    {blipId = 84, name = 'radar_rampage'},
    {blipId = 85, name = 'radar_vinewood_tours'},
    {blipId = 86, name = 'radar_lamar_family'},
    {blipId = 88, name = 'radar_franklin_family'},
    {blipId = 89, name = 'radar_chinese_strand'},
    {blipId = 90, name = 'radar_flight_school'},
    {blipId = 91, name = 'radar_eye_sky'},
    {blipId = 92, name = 'radar_air_hockey'},
    {blipId = 93, name = 'radar_bar'},
    {blipId = 94, name = 'radar_base_jump'},
    {blipId = 95, name = 'radar_basketball'},
    {blipId = 96, name = 'radar_biolab_heist'},
    {blipId = 99, name = 'radar_cabaret_club'},
    {blipId = 100, name = 'radar_car_wash'},
    {blipId = 102, name = 'radar_comedy_club'},
    {blipId = 103, name = 'radar_darts'},
    {blipId = 104, name = 'radar_docks_heist'},
    {blipId = 105, name = 'radar_fbi_heist'},
    {blipId = 106, name = 'radar_fbi_officers_strand'},
    {blipId = 107, name = 'radar_finale_bank_heist'},
    {blipId = 108, name = 'radar_financier_strand'},
    {blipId = 109, name = 'radar_golf'},
    {blipId = 110, name = 'radar_gun_shop'},
    {blipId = 111, name = 'radar_internet_cafe'},
    {blipId = 112, name = 'radar_michael_family_exile'},
    {blipId = 113, name = 'radar_nice_house_heist'},
    {blipId = 114, name = 'radar_random_female'},
    {blipId = 115, name = 'radar_random_male'},
    {blipId = 118, name = 'radar_rural_bank_heist'},
    {blipId = 119, name = 'radar_shooting_range'},
    {blipId = 120, name = 'radar_solomon_strand'},
    {blipId = 121, name = 'radar_strip_club'},
    {blipId = 122, name = 'radar_tennis'},
    {blipId = 123, name = 'radar_trevor_family_exile'},
    {blipId = 124, name = 'radar_michael_trevor_family'},
    {blipId = 126, name = 'radar_triathlon'},
    {blipId = 127, name = 'radar_off_road_racing'},
    {blipId = 128, name = 'radar_gang_cops'},
    {blipId = 129, name = 'radar_gang_mexicans'},
    {blipId = 130, name = 'radar_gang_bikers'},
    {blipId = 133, name = 'radar_snitch_red'},
    {blipId = 134, name = 'radar_crim_cuff_keys'},
    {blipId = 135, name = 'radar_cinema'},
    {blipId = 136, name = 'radar_music_venue'},
    {blipId = 136, name = 'radar_music_venue'},
    {blipId = 138, name = 'radar_police_station_blue'},
    {blipId = 139, name = 'radar_airport'},
    {blipId = 140, name = 'radar_crim_saved_vehicle'},
    {blipId = 141, name = 'radar_weed_stash'},
    {blipId = 142, name = 'radar_hunting'},
    {blipId = 143, name = 'radar_pool'},
    {blipId = 144, name = 'radar_objective_blue'},
    {blipId = 145, name = 'radar_objective_green'},
    {blipId = 146, name = 'radar_objective_red'},
    {blipId = 147, name = 'radar_objective_yellow'},
    {blipId = 148, name = 'radar_arms_dealing'},
    {blipId = 149, name = 'radar_mp_friend'},
    {blipId = 150, name = 'radar_weapon_assault_rifle'},
    {blipId = 151, name = 'radar_weapon_bat'},
    {blipId = 152, name = 'radar_weapon_grenade'},
    {blipId = 153, name = 'radar_weapon_health'},
    {blipId = 154, name = 'radar_weapon_knife'},
    {blipId = 155, name = 'radar_weapon_molotov'},
    {blipId = 156, name = 'radar_weapon_pistol'},
    {blipId = 157, name = 'radar_weapon_rocket'},
    {blipId = 158, name = 'radar_weapon_shotgun'},
    {blipId = 159, name = 'radar_weapon_smg'},
    {blipId = 160, name = 'radar_weapon_sniper'},
    {blipId = 161, name = 'radar_mp_noise'},
    {blipId = 162, name = 'radar_poi'},
    {blipId = 163, name = 'radar_passive'},
    {blipId = 164, name = 'radar_usingmenu'},
    {blipId = 171, name = 'radar_gang_cops_partner'},
    {blipId = 173, name = 'radar_weapon_minigun'},
    {blipId = 175, name = 'radar_weapon_armour'},
    {blipId = 176, name = 'radar_property_takeover'},
    {blipId = 177, name = 'radar_gang_mexicans_highlight'},
    {blipId = 178, name = 'radar_gang_bikers_highlight'},
    {blipId = 179, name = 'radar_triathlon_cycling'},
    {blipId = 180, name = 'radar_triathlon_swimming'},
    {blipId = 181, name = 'radar_property_takeover_bikers'},
    {blipId = 182, name = 'radar_property_takeover_cops'},
    {blipId = 183, name = 'radar_property_takeover_vagos'},
    {blipId = 184, name = 'radar_camera'},
    {blipId = 185, name = 'radar_centre_red'},
    {blipId = 186, name = 'radar_handcuff_keys_bikers'},
    {blipId = 187, name = 'radar_handcuff_keys_vagos'},
    {blipId = 188, name = 'radar_handcuffs_closed_bikers'},
    {blipId = 189, name = 'radar_handcuffs_closed_vagos'},
    {blipId = 192, name = 'radar_camera_badger'},
    {blipId = 193, name = 'radar_camera_facade'},
    {blipId = 194, name = 'radar_camera_ifruit'},
    {blipId = 197, name = 'radar_yoga'},
    {blipId = 198, name = 'radar_taxi'},
    {blipId = 205, name = 'radar_shrink'},
    {blipId = 206, name = 'radar_epsilon'},
    {blipId = 207, name = 'radar_financier_strand_grey'},
    {blipId = 208, name = 'radar_trevor_family_grey'},
    {blipId = 209, name = 'radar_trevor_family_red'},
    {blipId = 210, name = 'radar_franklin_family_grey'},
    {blipId = 211, name = 'radar_franklin_family_blue'},
    {blipId = 212, name = 'radar_franklin_a'},
    {blipId = 213, name = 'radar_franklin_b'},
    {blipId = 214, name = 'radar_franklin_c'},
    {blipId = 225, name = 'radar_gang_vehicle'},
    {blipId = 226, name = 'radar_gang_vehicle_bikers'},
    {blipId = 227, name = 'radar_gang_vehicle_cops'},
    {blipId = 228, name = 'radar_gang_vehicle_vagos'},
    {blipId = 229, name = 'radar_guncar'},
    {blipId = 230, name = 'radar_driving_bikers'},
    {blipId = 231, name = 'radar_driving_cops'},
    {blipId = 232, name = 'radar_driving_vagos'},
    {blipId = 233, name = 'radar_gang_cops_highlight'},
    {blipId = 234, name = 'radar_shield_bikers'},
    {blipId = 235, name = 'radar_shield_cops'},
    {blipId = 236, name = 'radar_shield_vagos'},
    {blipId = 237, name = 'radar_custody_bikers'},
    {blipId = 238, name = 'radar_custody_vagos'},
    {blipId = 251, name = 'radar_arms_dealing_air'},
    {blipId = 252, name = 'radar_playerstate_arrested'},
    {blipId = 253, name = 'radar_playerstate_custody'},
    {blipId = 254, name = 'radar_playerstate_driving'},
    {blipId = 255, name = 'radar_playerstate_keyholder'},
    {blipId = 256, name = 'radar_playerstate_partner'},
    {blipId = 262, name = 'radar_ztype'},
    {blipId = 263, name = 'radar_stinger'},
    {blipId = 264, name = 'radar_packer'},
    {blipId = 265, name = 'radar_monroe'},
    {blipId = 266, name = 'radar_fairground'},
    {blipId = 267, name = 'radar_property'},
    {blipId = 268, name = 'radar_gang_highlight'},
    {blipId = 269, name = 'radar_altruist'},
    {blipId = 270, name = 'radar_ai'},
    {blipId = 271, name = 'radar_on_mission'},
    {blipId = 272, name = 'radar_cash_pickup'},
    {blipId = 273, name = 'radar_chop'},
    {blipId = 274, name = 'radar_dead'},
    {blipId = 275, name = 'radar_territory_locked'},
    {blipId = 276, name = 'radar_cash_lost'},
    {blipId = 277, name = 'radar_cash_vagos'},
    {blipId = 278, name = 'radar_cash_cops'},
    {blipId = 279, name = 'radar_hooker'},
    {blipId = 280, name = 'radar_friend'},
    {blipId = 281, name = 'radar_mission_2to4'},
    {blipId = 282, name = 'radar_mission_2to8'},
    {blipId = 283, name = 'radar_mission_2to12'},
    {blipId = 284, name = 'radar_mission_2to16'},
    {blipId = 285, name = 'radar_custody_dropoff'},
    {blipId = 286, name = 'radar_onmission_cops'},
    {blipId = 287, name = 'radar_onmission_lost'},
    {blipId = 288, name = 'radar_onmission_vagos'},
    {blipId = 289, name = 'radar_crim_carsteal_cops'},
    {blipId = 290, name = 'radar_crim_carsteal_bikers'},
    {blipId = 291, name = 'radar_crim_carsteal_vagos'},
    {blipId = 292, name = 'radar_band_strand'},
    {blipId = 293, name = 'radar_simeon_family'},
    {blipId = 294, name = 'radar_mission_1'},
    {blipId = 295, name = 'radar_mission_2'},
    {blipId = 296, name = 'radar_friend_darts'},
    {blipId = 297, name = 'radar_friend_comedyclub'},
    {blipId = 298, name = 'radar_friend_cinema'},
    {blipId = 299, name = 'radar_friend_tennis'},
    {blipId = 300, name = 'radar_friend_stripclub'},
    {blipId = 301, name = 'radar_friend_livemusic'},
    {blipId = 302, name = 'radar_friend_golf'},
    {blipId = 303, name = 'radar_bounty_hit'},
    {blipId = 304, name = 'radar_ugc_mission'},
    {blipId = 305, name = 'radar_horde'},
    {blipId = 306, name = 'radar_cratedrop'},
    {blipId = 307, name = 'radar_plane_drop'},
    {blipId = 308, name = 'radar_sub'},
    {blipId = 309, name = 'radar_race'},
    {blipId = 310, name = 'radar_deathmatch'},
    {blipId = 311, name = 'radar_arm_wrestling'},
    {blipId = 312, name = 'radar_mission_1to2'},
    {blipId = 313, name = 'radar_shootingrange_gunshop'},
    {blipId = 314, name = 'radar_race_air'},
    {blipId = 315, name = 'radar_race_land'},
    {blipId = 316, name = 'radar_race_sea'},
    {blipId = 317, name = 'radar_tow'},
    {blipId = 318, name = 'radar_garbage'},
    {blipId = 319, name = 'radar_drill'},
    {blipId = 320, name = 'radar_spikes'},
    {blipId = 321, name = 'radar_firetruck'},
    {blipId = 322, name = 'radar_minigun2'},
    {blipId = 323, name = 'radar_bugstar'},
    {blipId = 324, name = 'radar_submarine'},
    {blipId = 325, name = 'radar_chinook'},
    {blipId = 326, name = 'radar_getaway_car'},
    {blipId = 327, name = 'radar_mission_bikers_1'},
    {blipId = 328, name = 'radar_mission_bikers_1to2'},
    {blipId = 329, name = 'radar_mission_bikers_2'},
    {blipId = 330, name = 'radar_mission_bikers_2to4'},
    {blipId = 331, name = 'radar_mission_bikers_2to8'},
    {blipId = 332, name = 'radar_mission_bikers_2to12'},
    {blipId = 333, name = 'radar_mission_bikers_2to16'},
    {blipId = 334, name = 'radar_mission_cops_1'},
    {blipId = 335, name = 'radar_mission_cops_1to2'},
    {blipId = 336, name = 'radar_mission_cops_2'},
    {blipId = 337, name = 'radar_mission_cops_2to4'},
    {blipId = 338, name = 'radar_mission_cops_2to8'},
    {blipId = 339, name = 'radar_mission_cops_2to12'},
    {blipId = 340, name = 'radar_mission_cops_2to16'},
    {blipId = 341, name = 'radar_mission_vagos_1'},
    {blipId = 342, name = 'radar_mission_vagos_1to2'},
    {blipId = 343, name = 'radar_mission_vagos_2'},
    {blipId = 344, name = 'radar_mission_vagos_2to4'},
    {blipId = 345, name = 'radar_mission_vagos_2to8'},
    {blipId = 346, name = 'radar_mission_vagos_2to12'},
    {blipId = 347, name = 'radar_mission_vagos_2to16'},
    {blipId = 348, name = 'radar_gang_bike'},
    {blipId = 349, name = 'radar_gas_grenade'},
    {blipId = 350, name = 'radar_property_for_sale'},
    {blipId = 351, name = 'radar_gang_attack_package'},
    {blipId = 352, name = 'radar_martin_madrazzo'},
    {blipId = 353, name = 'radar_enemy_heli_spin'},
    {blipId = 354, name = 'radar_boost'},
    {blipId = 355, name = 'radar_devin'},
    {blipId = 356, name = 'radar_dock'},
    {blipId = 357, name = 'radar_garage'},
    {blipId = 358, name = 'radar_golf_flag'},
    {blipId = 359, name = 'radar_hangar'},
    {blipId = 360, name = 'radar_helipad'},
    {blipId = 361, name = 'radar_jerry_can'},
    {blipId = 362, name = 'radar_mask'},
    {blipId = 363, name = 'radar_heist_prep'},
    {blipId = 364, name = 'radar_incapacitated'},
    {blipId = 365, name = 'radar_spawn_point_pickup'},
    {blipId = 366, name = 'radar_boilersuit'},
    {blipId = 367, name = 'radar_completed'},
    {blipId = 368, name = 'radar_rockets'},
    {blipId = 369, name = 'radar_garage_for_sale'},
    {blipId = 370, name = 'radar_helipad_for_sale'},
    {blipId = 371, name = 'radar_dock_for_sale'},
    {blipId = 372, name = 'radar_hangar_for_sale'},
    {blipId = 373, name = 'radar_placeholder_6'},
    {blipId = 374, name = 'radar_business'},
    {blipId = 375, name = 'radar_business_for_sale'},
    {blipId = 376, name = 'radar_race_bike'},
    {blipId = 377, name = 'radar_parachute'},
    {blipId = 378, name = 'radar_team_deathmatch'},
    {blipId = 379, name = 'radar_race_foot'},
    {blipId = 380, name = 'radar_vehicle_deathmatch'},
    {blipId = 381, name = 'radar_barry'},
    {blipId = 382, name = 'radar_dom'},
    {blipId = 383, name = 'radar_maryann'},
    {blipId = 384, name = 'radar_cletus'},
    {blipId = 385, name = 'radar_josh'},
    {blipId = 386, name = 'radar_minute'},
    {blipId = 387, name = 'radar_omega'},
    {blipId = 388, name = 'radar_tonya'},
    {blipId = 389, name = 'radar_paparazzo'},
    {blipId = 390, name = 'radar_aim'},
    {blipId = 391, name = 'radar_cratedrop_background'},
    {blipId = 392, name = 'radar_green_and_net_player1'},
    {blipId = 393, name = 'radar_green_and_net_player2'},
    {blipId = 394, name = 'radar_green_and_net_player3'},
    {blipId = 395, name = 'radar_green_and_friendly'},
    {blipId = 396, name = 'radar_net_player1_and_net_player2'},
    {blipId = 397, name = 'radar_net_player1_and_net_player3'},
    {blipId = 398, name = 'radar_creator'},
    {blipId = 399, name = 'radar_creator_direction'},
    {blipId = 400, name = 'radar_abigail'},
    {blipId = 401, name = 'radar_blimp'},
    {blipId = 402, name = 'radar_repair'},
    {blipId = 403, name = 'radar_testosterone'},
    {blipId = 404, name = 'radar_dinghy'},
    {blipId = 405, name = 'radar_fanatic'},
    {blipId = 407, name = 'radar_info_icon'},
    {blipId = 408, name = 'radar_capture_the_flag'},
    {blipId = 409, name = 'radar_last_team_standing'},
    {blipId = 410, name = 'radar_boat'},
    {blipId = 411, name = 'radar_capture_the_flag_base'},
    {blipId = 412, name = 'radar_mp_crew'},
    {blipId = 413, name = 'radar_capture_the_flag_outline'},
    {blipId = 414, name = 'radar_capture_the_flag_base_nobag'},
    {blipId = 415, name = 'radar_weapon_jerrycan'},
    {blipId = 416, name = 'radar_rp'},
    {blipId = 417, name = 'radar_level_inside'},
    {blipId = 418, name = 'radar_bounty_hit_inside'},
    {blipId = 419, name = 'radar_capture_the_usaflag'},
    {blipId = 420, name = 'radar_capture_the_usaflag_outline'},
    {blipId = 421, name = 'radar_tank'},
    {blipId = 422, name = 'radar_player_heli'},
    {blipId = 423, name = 'radar_player_plane'},
    {blipId = 424, name = 'radar_player_jet'},
    {blipId = 425, name = 'radar_centre_stroke'},
    {blipId = 426, name = 'radar_player_guncar'},
    {blipId = 427, name = 'radar_player_boat'},
    {blipId = 428, name = 'radar_mp_heist'},
    {blipId = 429, name = 'radar_temp_1'},
    {blipId = 430, name = 'radar_temp_2'},
    {blipId = 431, name = 'radar_temp_3'},
    {blipId = 432, name = 'radar_temp_4'},
    {blipId = 433, name = 'radar_temp_5'},
    {blipId = 434, name = 'radar_temp_6'},
    {blipId = 435, name = 'radar_race_stunt'},
    {blipId = 436, name = 'radar_hot_property'},
    {blipId = 437, name = 'radar_urbanwarfare_versus'},
    {blipId = 438, name = 'radar_king_of_the_castle'},
    {blipId = 439, name = 'radar_player_king'},
    {blipId = 440, name = 'radar_dead_drop'},
    {blipId = 441, name = 'radar_penned_in'},
    {blipId = 442, name = 'radar_beast'},
    {blipId = 443, name = 'radar_edge_pointer'},
    {blipId = 444, name = 'radar_edge_crosstheline'},
    {blipId = 445, name = 'radar_mp_lamar'},
    {blipId = 446, name = 'radar_bennys'},
    {blipId = 447, name = 'radar_corner_number_1'},
    {blipId = 448, name = 'radar_corner_number_2'},
    {blipId = 449, name = 'radar_corner_number_3'},
    {blipId = 450, name = 'radar_corner_number_4'},
    {blipId = 451, name = 'radar_corner_number_5'},
    {blipId = 452, name = 'radar_corner_number_6'},
    {blipId = 453, name = 'radar_corner_number_7'},
    {blipId = 454, name = 'radar_corner_number_8'},
    {blipId = 455, name = 'radar_yacht'},
    {blipId = 456, name = 'radar_finders_keepers'},
    {blipId = 457, name = 'radar_assault_package'},
    {blipId = 458, name = 'radar_hunt_the_boss'},
    {blipId = 459, name = 'radar_sightseer'},
    {blipId = 460, name = 'radar_turreted_limo'},
    {blipId = 461, name = 'radar_belly_of_the_beast'},
    {blipId = 462, name = 'radar_yacht_location'},
    {blipId = 463, name = 'radar_pickup_beast'},
    {blipId = 464, name = 'radar_pickup_zoned'},
    {blipId = 465, name = 'radar_pickup_random'},
    {blipId = 466, name = 'radar_pickup_slow_time'},
    {blipId = 467, name = 'radar_pickup_swap'},
    {blipId = 468, name = 'radar_pickup_thermal'},
    {blipId = 469, name = 'radar_pickup_weed'},
    {blipId = 470, name = 'radar_weapon_railgun'},
    {blipId = 471, name = 'radar_seashark'},
    {blipId = 472, name = 'radar_pickup_hidden'},
    {blipId = 473, name = 'radar_warehouse'},
    {blipId = 474, name = 'radar_warehouse_for_sale'},
    {blipId = 475, name = 'radar_office'},
    {blipId = 476, name = 'radar_office_for_sale'},
    {blipId = 477, name = 'radar_truck'},
    {blipId = 478, name = 'radar_contraband'},
    {blipId = 479, name = 'radar_trailer'},
    {blipId = 480, name = 'radar_vip'},
    {blipId = 481, name = 'radar_cargobob'},
    {blipId = 482, name = 'radar_area_outline_blip'},
    {blipId = 483, name = 'radar_pickup_accelerator'},
    {blipId = 484, name = 'radar_pickup_ghost'},
    {blipId = 485, name = 'radar_pickup_detonator'},
    {blipId = 486, name = 'radar_pickup_bomb'},
    {blipId = 487, name = 'radar_pickup_armoured'},
    {blipId = 488, name = 'radar_stunt'},
    {blipId = 489, name = 'radar_weapon_lives'},
    {blipId = 490, name = 'radar_stunt_premium'},
    {blipId = 491, name = 'radar_adversary'},
    {blipId = 492, name = 'radar_biker_clubhouse'},
    {blipId = 493, name = 'radar_biker_caged_in'},
    {blipId = 494, name = 'radar_biker_turf_war'},
    {blipId = 495, name = 'radar_biker_joust'},
    {blipId = 496, name = 'radar_production_weed'},
    {blipId = 497, name = 'radar_production_crack'},
    {blipId = 498, name = 'radar_production_fake_id'},
    {blipId = 499, name = 'radar_production_meth'},
    {blipId = 500, name = 'radar_production_money'},
    {blipId = 501, name = 'radar_package'},
    {blipId = 502, name = 'radar_capture_1'},
    {blipId = 503, name = 'radar_capture_2'},
    {blipId = 504, name = 'radar_capture_3'},
    {blipId = 505, name = 'radar_capture_4'},
    {blipId = 506, name = 'radar_capture_5'},
    {blipId = 507, name = 'radar_capture_6'},
    {blipId = 508, name = 'radar_capture_7'},
    {blipId = 509, name = 'radar_capture_8'},
    {blipId = 510, name = 'radar_capture_9'},
    {blipId = 511, name = 'radar_capture_10'},
   -- more entries can be added when FiveM docs expands
}

local colors = {
    [0] = { color = "#fefefe", name = "White" },
    [1] = { color = "#e03232", name = "Red" },
    [2] = { color = "#71cb71", name = "Green" },
    [3] = { color = "#e03232", name = "Red" },
    [4] = { color = "#5db6e5", name = "Blue" },
    [5] = { color = "#e03232", name = "Red" },
    [6] = { color = "#fefefe", name = "White" },
    [7] = { color = "#e03232", name = "Red" },
    [8] = { color = "#5db6e5", name = "Blue" },
    [9] = { color = "#eec64e", name = "Yellow" },
    [10] = { color = "#c25050", name = "Light Brown" },
    [11] = { color = "#9c6eaf", name = "Violet" },
    [12] = { color = "#fe7ac3", name = "Pink" },
    [13] = { color = "#f59d79", name = "Light Orange" },
    [14] = { color = "#b18f83", name = "Light Brown" },
    [15] = { color = "#8dcea7", name = "Light Green" },
    [16] = { color = "#70a8ae", name = "Light Blue" },
    [17] = { color = "#d3d1e7", name = "Light Purple" },
    [18] = { color = "#8f7e98", name = "Dark Purple" },
    [19] = { color = "#6ac4bf", name = "Cyan" },
    [20] = { color = "#d5c398", name = "Light Yellow" },
    [21] = { color = "#ea8e50", name = "Orange" },
    [22] = { color = "#97cae9", name = "Medium Purple" },
    [23] = { color = "#b26287", name = "Salmon" },
    [24] = { color = "#8f8d79", name = "Dark Green" },
    [25] = { color = "#afa8a8", name = "Blizzard Blue" },
    [26] = { color = "#bbd65b", name = "Oracle Blue" },
    [27] = { color = "#0c7b56", name = "Silver" },
    [28] = { color = "#7ac3fe", name = "Brown" },
    [29] = { color = "#ab3ce6", name = "East Bay" },
    [30] = { color = "#cda80c", name = "Mulberry Pink" },
    [31] = { color = "#A0A0A0", name = "Alto Gray" },
    [32] = { color = "#276a9f", name = "Jelly Bean Blue" },
    [33] = { color = "#D87B1B", name = "Dark Orange" },
    [34] = { color = "#8E8393", name = "Mamba" },
    [35] = { color = "#F0CB57", name = "Yellow Orange" },
    [36] = { color = "#65B9E7", name = "Blue" },
    [37] = { color = "#3D3D3D", name = "Transparent Black" }
}

local spritesById = {}
local spritesByName = {}

local docsBaseUrl = "https://docs.fivem.net"

local function trim(value)
    if type(value) ~= "string" then return value end
    return value:gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeAssetName(value)
    if type(value) == "number" then return tostring(value) end
    if type(value) ~= "string" then return nil end

    value = trim(value):lower()
    value = value:gsub("", ""):gsub("\"", ""):gsub("'", "")
    value = value:gsub("%s+", "_")

    return value ~= "" and value or nil
end

local function normalizeBlipName(value)
    local name = normalizeAssetName(value)
    if not name then return nil end

    if spritesByName[name] then return name end

    local radarName = name:find("^radar_") and name or ("radar_%s"):format(name)
    if spritesByName[radarName] then return radarName end

    return name
end

local function buildUrl(kind, value, extension, transform)
    local name = normalizeAssetName(value)
    if not name then return nil end

    if transform == "upper" then
        name = name:upper()
    end

    return ("%s/%s/%s.%s"):format(docsBaseUrl, kind, name, extension)
end

for i = 1, #sprites do
    local sprite = sprites[i]
    spritesById[sprite.blipId] = sprite
    spritesByName[sprite.name] = sprite
end

blips.sprites = sprites
blips.colors = colors

function blips.getSprite(value)
    if type(value) == "number" then return spritesById[value] end

    local name = normalizeBlipName(value)
    if not name then return nil end

    return spritesByName[name]
end

function blips.getSpriteName(value)
    local sprite = blips.getSprite(value)
    return sprite and sprite.name or normalizeBlipName(value)
end

function blips.getSpriteId(value)
    local sprite = blips.getSprite(value)
    return sprite and sprite.blipId or nil
end

function blips.getColorInfo(colorId)
    colorId = tonumber(colorId)
    return colorId and colors[colorId] or nil
end

function blips.listSprites()
    return sprites
end

function blips.listColors()
    return colors
end

function blips.setDocsBaseUrl(url)
    if type(url) == "string" and url ~= "" then
        docsBaseUrl = url:gsub("/+$", "")
    end
end

function blips.getBlipImageUrl(value)
    local name = blips.getSpriteName(value)
    return name and buildUrl("blips", name, "png") or nil
end

blips.getImageUrl = blips.getBlipImageUrl

function blips.getPedImageUrl(model)
    return buildUrl("peds", model, "webp")
end

function blips.getVehicleImageUrl(model)
    return buildUrl("vehicles", model, "webp")
end

function blips.getCheckpointImageUrl(checkpointId)
    return buildUrl("checkpoints", checkpointId, "png")
end

function blips.getMarkerImageUrl(markerId)
    return buildUrl("markers", markerId, "png")
end

function blips.getWeaponImageUrl(model)
    return buildUrl("weapons", model, "png", "upper")
end

function blips.getAssetImageUrl(kind, value)
    kind = normalizeAssetName(kind)
    if kind == "blip" or kind == "blips" then return blips.getBlipImageUrl(value) end
    if kind == "ped" or kind == "peds" then return blips.getPedImageUrl(value) end
    if kind == "vehicle" or kind == "vehicles" then return blips.getVehicleImageUrl(value) end
    if kind == "checkpoint" or kind == "checkpoints" then return blips.getCheckpointImageUrl(value) end
    if kind == "marker" or kind == "markers" then return blips.getMarkerImageUrl(value) end
    if kind == "weapon" or kind == "weapons" then return blips.getWeaponImageUrl(value) end

    return nil
end

function blips.describe(value, colorId)
    local sprite = blips.getSprite(value)
    local color = blips.getColorInfo(colorId)

    return {
        id = sprite and sprite.blipId or tonumber(value),
        name = sprite and sprite.name or normalizeBlipName(value),
        image = blips.getBlipImageUrl(value),
        color = color,
    }
end

return blips
