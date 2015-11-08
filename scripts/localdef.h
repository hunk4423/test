/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz

	Local defines for Overpoch Origins
*/
#define _OVERPOCH
#define _BLOWOUT
#define _ORIGINS
#define ON_LOADMISSION		"DayZ Overpoch Origins"
#define ON_LOADINTRO		"Welcome to DayZ Overpoch Origins"
#define MAP_AREA			16000
#define MAP_MIN_POS			-1000
#define MAP_MAX_POS			26000
#define MAX_VECHICLE		150
#define MAX_HELICRASH		3
#define AMMO_BOXES			7
#define MINE_VEINS			50
#define HOUR_TO_RESTART		3
#define DYNAMIC_DEBRIS		0
#define DEF_MAGAZINES		"ItemBandage","ItemBandage","ItemBandage","ItemPainkiller","FoodBioMeat","ItemMorphine","vil_45Rnd_545x39_AK","vil_45Rnd_545x39_AK","RH_8Rnd_762_tt33","RH_8Rnd_762_tt33","1Rnd_HE_GP25"
#define DEF_WEAPONS			"vil_AK_74m_gp","RH_tt33","ItemMap","ItemToolbox","ItemRadio","ItemHatchet_DZE"

#define RND_TRADERS
#define MSG_DEL_VEH
#define HEIGHT_COLD
#define POSPREVIEWPAD [943.467,25019.8,0]
#define ITEMoffNUMACTIONS	"ItemNewspaper","ItemBloodbag","vil_20Rnd_762x51_G3","ItemHeatPack"

// Состав мультискинов
#define MULTI_SKINS \
	["GUE_Commander_DZ","Skin_GUE_Commander_DZ",["FR_Miles","FR_GL","FR_Sykes","FR_Corpsman","FR_AC","FR_Assault_GL","FR_TL","USMC_Soldier","USMC_SoldierS_Sniper","USMC_Soldier_AA","USMC_Soldier_Crew","USMC_Soldier_Pilot","USMC_Soldier_Light","USMC_Soldier_Officer","USMC_LHD_Crew_Blue","USMC_LHD_Crew_Brown","USMC_LHD_Crew_Green","USMC_LHD_Crew_Purple","USMC_LHD_Crew_Red","USMC_LHD_Crew_White","USMC_LHD_Crew_Yellow"]],\
	["GUE_Soldier_2_DZ","Skin_GUE_Soldier_2_DZ",["Ins_Soldier_CO","Ins_Soldier_1","Ins_Soldier_2","Ins_Soldier_AT","Ins_Soldier_Crew","Ins_Soldier_GL"]],\
	["Camo1_DZ","Skin_Camo1_DZ",["UN_CDF_Soldier_AT_EP1","UN_CDF_Soldier_Light_EP1","CDF_Soldier","CDF_Commander","CDF_Soldier_Light","CDF_Soldier_Militia","CDF_Soldier_Sniper","RU_Soldier","RU_Soldier_TL"]],\
	["RU_Soldier_Crew_DZ","Skin_RU_Soldier_Crew_DZ",["RUS_Soldier1","MVD_Soldier_AT","CDF_Soldier_Pilot","RU_Soldier_Pilot","RU_Soldier_Crew","CDF_Soldier_Crew","RU_Soldier_Sniper"]],\
	["Graves_Light_DZ","Skin_Graves_Light_DZ",["Drake","Graves","Herrera","US_Soldier_Pilot_EP1","US_Pilot_Light_EP1","US_Delta_Force_AR_EP1","US_Delta_Force_Assault_EP1","US_Soldier_AR_EP1","US_Soldier_MG_EP1","US_Soldier_Officer_EP1","US_Soldier_SniperH_EP1","US_Soldier_Sniper_NV_EP1"]],\
	["CZ_Special_Forces_GL_DES_EP1_DZ","Skin_CZ_Special_Forces_GL_DES_EP1_DZ",["CZ_Soldier_AT_DES_EP1","CZ_Soldier_Light_DES_EP1","CZ_Special_Forces_DES_EP1","CZ_Special_Forces_GL_DES_EP1","CZ_Special_Forces_TL_DES_EP1","GER_Soldier_TL_EP1"]],\
	["Rocket_DZ","Skin_Rocket_DZ",["BAF_crewman_W","BAF_crewman_MTP","BAF_Soldier_Officer_W","BAF_Soldier_Officer_MTP","BAF_Soldier_L_W","BAF_Soldier_L_MTP","BAF_Pilot_W","BAF_Pilot_MTP","BAF_Soldier_SniperH_MTP","BAF_Soldier_SniperH_W"]],\
	["Soldier_TL_PMC_DZ","Skin_Soldier_TL_PMC_DZ",["Soldier_TL_PMC","Soldier_Sniper_PMC","Soldier_MG_PMC","Soldier_MG_PKM_PMC","Soldier_GL_M16A2_PMC","Soldier_M4A3_PMC","Soldier_GL_PMC","Soldier_PMC","Soldier_Pilot_PMC","Ry_PMC","Dixon_PMC"]],\
	["Bandit1_DZ","Skin_Bandit1_DZ",["TK_Special_Forces_TL_EP1","TK_Aziz_EP1","TK_Soldier_Crew_EP1","TK_Soldier_AT_EP1","TK_Soldier_Officer_EP1","TK_Soldier_Pilot_EP1","TK_Soldier_SniperH_EP1","TK_INS_Bonesetter_EP1","TK_INS_Soldier_Sniper_EP1","TK_GUE_Bonesetter_EP1","TK_GUE_Soldier_3_EP1","TK_GUE_Soldier_2_EP1","TK_GUE_Soldier_MG_EP1","TK_GUE_Soldier_TL_EP1"]],\
	["INS_Worker2_DZ","Skin_INS_Worker2_DZ",["Citizen1","Citizen2","Citizen3","Citizen4","Profiteer1","Profiteer3","Profiteer4","Villager1","Villager2","Villager3","Villager4","Woodlander1","Woodlander2","Woodlander3","Woodlander4","Worker1","Worker2","Worker3","Worker4","Assistant"]],\
	["Drake_Light_DZ","Skin_Drake_Light_DZ",["Desert_SOF_TL","Desert_SOF_GL","Desert_SOF_Marksman","Desert_SOF_AC","Desert_SOF_DA1","Desert_SOF_DA1b","Desert_SOF_DA2","WDL_Mercenary_Default0","WDL_Mercenary_Default2","WDL_Mercenary_Default3","WDL_Mercenary_Default4","WDL_Mercenary_Default5","WDL_Mercenary_Default5a","G_WDL_Mercenary_Default5a","WDL_Mercenary_Default6","WDL_Mercenary_Default8","WDL_Mercenary_Default9","WDL_Mercenary_Default10","WDL_Mercenary_Default11","WDL_Mercenary_Default12","WDL_Mercenary_Default13","WDL_Mercenary_Default14","WDL_Mercenary_Default16"]],\
	["Soldier_Sniper_PMC_DZ","Skin_Soldier_Sniper_PMC_DZ",["SBH_Alpha_Soldier5","SBH_Alpha_Soldier8","SBH_Alpha_Soldier1","SBH_Alpha_Soldier11","SBH_Alpha_Soldier4","LastKing","Sniper1_City","Sniper1_Wood","BanditS_City","BanditS_Wood","Bandit2_black","Hero_black","vil_stskin1","vil_stskin2","vil_stskin4","vil_stskin5","vil_stskin6"]],\
	["CZ_Soldier_Sniper_EP1_DZ","Skin_CZ_Soldier_Sniper_EP1_DZ",["Winter_OPFOR1","Winter_OPFOR10","Winter_SOF_GL","Winter_SOF_TL","Winter_SOF_DA1c","EWinter_OPFOR10","Winter_SOF_Marksman"]],\
	["GUE_Soldier_Sniper_DZ","Skin_GUE_Soldier_Sniper_DZ",["UKSF_des_tl","UKSF_des_op","UKSF_des_ar","UKSF_des_demo","UKSF_des_mrk","UKSF_des_jtac","UKSF_wdl_tl","UKSF_wdl_op","UKSF_wdl_ar","UKSF_wdl_demo","UKSF_wdl_mrk","UKSF_wdl_jtac","UKSF_des_tl_l","UKSF_des_op_l","UKSF_des_ar_l","UKSF_des_demo_l","UKSF_des_mrk_l","UKSF_des_jtac_l","UKSF_wdl_tl_l","UKSF_wdl_op_l","UKSF_wdl_ar_l","UKSF_wdl_demo_l","UKSF_wdl_mrk_l","UKSF_wdl_jtac_l"]],\
	["FR_OHara_DZ","Skin_FR_OHara_DZ",["US_Army_Soldier_Officer","US_Army_Soldier_Light","US_Army_SoldierM_Marksman","frb_tl","frb_gl_mask","arma1_us_soldier_sabmark","SFSG_des_tl","SFSG_des_mrk","SFSG_mtp_tl","SFSG_mtp_mrk","SFSG_mtpw_tl","SFSG_mtpw_mrk"]],\
	["Sniper1_DZ","Skin_Sniper1_DZ",["Navy_SEAL_ACb","Navy_SEAL_ACa","Navy_SEAL_Marksman","Navy_SEAL_diver","Navy_SEAL_diver_land","Navy_SEAL_AC","Navy_SEAL_GL"]],\
	["Bandit2_DZ","Skin_Bandit2_DZ",["G_WDL_Mercenary_Default0","G_WDL_Mercenary_Default2","G_WDL_Mercenary_Default3","G_WDL_Mercenary_Default4","G_WDL_Mercenary_Default5","G_WDL_Mercenary_Default6","G_WDL_Mercenary_Default8","G_WDL_Mercenary_Default9","G_WDL_Mercenary_Default10","G_WDL_Mercenary_Default11","G_WDL_Mercenary_Default12","G_WDL_Mercenary_Default13","G_WDL_Mercenary_Default14","G_WDL_Mercenary_Default16"]],\
	["SurvivorWsequishaD_DZ","Skin_SurvivorWsequishaD_DZ",["gsc_military_helmet_wdl","gsc_military_helmet_wdl_AT","gsc_military_helmet_grey_AT","gsc_military_helmet_wdlSNP","gsc_military_helmet_greySNP","gsc_military_helmet_grey","gsc_military_head_grey","gsc_military_head_greySNP","gsc_military_head_wdlSNP","gsc_military_head_wdl","gsc_military_head_wdl_AT","gsc_military_head_grey_AT","gsc_scientist1","gsc_scientist1_head","gsc_scientist2","gsc_scientist2_head","gsc_eco_stalker_mask_fred","gsc_eco_stalker_head_fred","gsc_eco_stalker_mask_camo","gsc_eco_stalker_head_camo1","gsc_cloth_loner_head","gsc_eco_stalker_mask_duty","gsc_eco_stalker_head_duty","gsc_eco_stalker_mask_neutral","gsc_eco_stalker_head_neutral","nof_fsk_tl","nof_fsk_marksman","nof_fsk_grenadier","nof_fsk_heavy","Navy_SEAL_AT","Navy_SEAL_SD","Desert_SOF_Sabot","Desert_SOF_AT","Desert_SOF_DA1a","Winter_SOF_DA1a","Winter_SOF_DA1b"]],\
	["Soldier_Bodyguard_AA12_PMC_DZ","Skin_Soldier_Bodyguard_AA12_PMC_DZ",["G_Mercenary_Default9a","G_Mercenary_Default9b","Mercenary_Default11","Mercenary_Default26","Mercenary_Default14","Mercenary_Default16","Mercenary_Default27","Mercenary_Default12","Mercenary_Default18","Mercenary_Default19","Mercenary_Default19a","G_Mercenary_Default19a","Mercenary_Default20","G_Mercenary_Default0","G_Mercenary_Default1","G_Mercenary_Default2","G_Mercenary_Default3","G_Mercenary_Default4","G_Mercenary_Default5","G_Mercenary_Default6","G_Mercenary_Default7","G_Mercenary_Default8","G_Mercenary_Default14","G_Mercenary_Default17","G_Mercenary_Default19","G_Mercenary_Default20b"]],\
	["INS_Lopotev_DZ","Skin_INS_Lopotev_DZ",["INS_Lopotev_DZ","Gangsta_merc1","Gangsta_merc2","Gangsta_merc3","Gangsta_merc4","Gangsta_merc5","Gangsta_merc6","Gangsta_merc7","Gangsta_merc8","Gangsta_merc9","Gangsta_merc10","EGangsta_merc1","EGangsta_merc2","EGangsta_merc3","EGangsta_merc4","EGangsta_merc5","EGangsta_merc7","EGangsta_merc9","EGangsta_merc10","Terrorist1","Terrorist2","Terrorist3","Terrorist4","Terrorist5","Terrorist6","Terrorist7","Terrorist8","Terrorist9","Terrorist10","Terrorist11","Terrorist12","ETerrorist1","ETerrorist2","ETerrorist3","ETerrorist5","ETerrorist6","ETerrorist7","ETerrorist8","ETerrorist9","ETerrorist10","ETerrorist11","ETerrorist12"]],\
	["TK_INS_Warlord_EP1_DZ","Skin_TK_INS_Warlord_EP1_DZ",["TK_INS_Warlord_EP1_DZ"]],\
	["TK_INS_Soldier_EP1_DZ","Skin_TK_INS_Soldier_EP1_DZ",["TK_INS_Soldier_EP1_DZ"]],\
	["W_Coat","Skin_W_Coat",["Sniper1_Snow","BanditS_Snow","WinterSkin","ori_hghilie_Snow","ori_bghilie_Snow"]],\
	["SurvivorWpink_DZ","Skin_SurvivorWpink_DZ",["SurvivorWpink_DZ","vil_woman_cop","ori_vil_woman_bandit_1","ori_vil_woman_bandit_2","ori_vil_woman_bandit_3","ori_vil_woman_bandit_4","ori_vil_woman_bandit_5","ori_vil_woman_bandit_6","ori_vil_woman_hero_1","ori_vil_woman_hero_2","ori_vil_woman_hero_3","ori_vil_woman_hero_4","ori_vil_woman_hero_5","ori_vil_woman_hero_6","vil_bdu_cap_woman","vil_bdu_hood_woman","ori_vil_woman_survivor_1","ori_vil_woman_survivor_2","ori_vil_woman_survivor_3","ori_vil_woman_survivor_4","ori_vil_woman_survivor_5","ori_vil_woman_survivor_6","ori_vil_bandit_ghilie","ori_bghilie_City","ori_bghilie_Wood","ori_vil_hero_ghilie","ori_hghilie_City","ori_hghilie_Wood","ori_vil_woman_bandit_cr","ori_vil_woman_ghilie","ori_vil_woman_vjt_1","ori_vil_woman_vjt_2","ori_vil_woman_vjt_3","ori_vil_woman_vjt_4","ori_vil_woman_vjt_5","ori_vil_woman_vjt_6","ori_vil_woman_survivor_cr"]]

#define SKIP_SKINS \
	["Ins_Soldier_GL_DZ","Skin_Ins_Soldier_GL_DZ",[]],\
	["INS_Soldier_CO_DZ","Skin_INS_Soldier_CO_DZ",[]],\
	["Ins_Soldier_AR_DZ","Skin_Ins_Soldier_AR_DZ",[]],\
	["INS_Bardak_DZ","Skin_INS_Bardak_DZ",[]]
	
#define AI_BANDITS 			"Ins_Bardak","Ins_Soldier_1","Ins_Soldier_Medic","Ins_Soldier_2","Ins_Soldier_AR","Ins_Soldier_MG","Ins_Soldier_Crew","Ins_Commander","Ins_Soldier_Sab"
#define TAKE_CLOTHES 		[["Ins_Bardak","Ins_Bardak_DZ"],["Ins_Soldier_1","Ins_Soldier_AR_DZ"],["Ins_Soldier_AR","Ins_Soldier_AR_DZ"],["Ins_Soldier_Crew","Ins_Soldier_AR_DZ"],["Ins_Soldier_MG","Ins_Soldier_GL_DZ"],["Ins_Soldier_Sab","Ins_Soldier_GL_DZ"],["Ins_Soldier_2","Ins_Soldier_GL_DZ"],["Ins_Commander","Ins_Soldier_CO_DZ"],["Ins_Soldier_Medic","INS_Soldier_CO_DZ"]]
#define AMMO_TRADERS		"MVD_Soldier_TL","CZ_Special_Forces_TL_DES_EP1","TK_Commander_EP1","RU_Farmwife1","Soldier_GL_PMC","Soldier_Sniper_KSVK_PMC"

#define GUN_LIST \
	"AEK_973s_1p78","AEK_973s_gp_1p63","AEK_973s_gp","AEK_971_tgp_cln","AEK_971_1p78","AEK_971_gp_1p63","AEK_971_gp""AEK_973s_1pn100","AEK_971_1pn100","revolver_gold_EP1","MakarovSD","RH_browninghp","RH_p226","RH_p38","RH_ppk","RH_mk22","RH_usp","RH_uspm","RH_m1911old","RH_tt33","RH_mk2","RH_m93r","RH_m9","RH_m9c","RH_g19t","vil_APS","vil_USP","vil_USP45","RH_Deagleg","RH_Deaglemzb","RH_Deaglemz","RH_Deaglem","RH_Deagles","RH_deagle","RH_anacg","RH_anac","RH_bull","RH_python","RH_m9csd","RH_m9sd","RH_mk22vsd","RH_mk22sd","RH_uspsd","RH_m1911sd","RH_g17sd","vil_apssd","vil_USPSD","vil_USP45SD","vil_SV_98_69","vil_SV_98","vil_SVU_A","vil_SVD_P21","vil_SVD_S","SVD_CAMO","SVD","vil_PSL1","vil_M76","vil_M91","vil_VAL","RH_sc2","RH_sc2acog","RH_sc2aim","RH_sc2eot","RH_sc2shd","RH_sc2sp","RH_m1s","RH_m1sacog","RH_m1saim","RH_m1seot","RH_m1sshd","RH_m1ssp","M4SPR","FHQ_RSASS_TAN","vil_m40a3","M40A3","vil_M24b","M24_des_EP1","M24","RH_m21","M14_EP1","RH_m14","RH_m14eot","RH_m14acog","huntingrifle","vil_SKS","gms_k98","gms_k98_rg","gms_k98_knife","gms_k98zf39","M240_DZ","Mk_48_DZ","M249_EP1_DZ","M249_DZ","MG36_camo","MG36","vil_PKP_EOT","RPK_74","vil_RPK74M","vil_RPK74M_P29","vil_RPK75_Romania","vil_RPD","vil_zastava_m84","vil_RPK75_M72","vil_MG4","vil_Mg3","vil_Minimi","vil_FnMag","M4A1","M4A1_Aim_camo","M4A1_HWS_GL_camo","M4A3_CCO_EP1","M4A3_RCO_GL_EP1","M16A2GL","M16a4","M16A4_ACG_GL","BAF_L85A2_UGL_Holo","BAF_L85A2_UGL_ACOG","BAF_L85A2_UGL_SUSAT","BAF_L86A2_ACOG","m8_carbineGL","m8_compact","m8_sharpshooter","m8_SAW","RH_ctar21","RH_ctar21mgl","RH_star21","RH_ctar21glacog","vil_Groza_GL","vil_Groza_SD","vil_Groza_SC","RH_masb","RH_masbaim","RH_masbeotech","RH_masbacog","RH_masbsd","RH_masbsdaim","RH_masbsdeotech","RH_masbsdacog","RH_acrbaim","RH_acrbacog","RH_acrbgl","RH_acrbglaim","RH_acrbgleotech","RH_acrbglacog","FN_FAL","vil_AG3","vil_AG3EOT","vil_sg540","vil_sg542f","vil_Insas","vil_Insas_lmg","vil_Galil","vil_Galil_arm","RH_hk416gl","RH_hk416glaim","RH_hk416gleotech","RH_hk416glacog","RH_hk416sgl","RH_hk416sglaim","RH_hk416sgleotech","RH_hk416sglacog","RH_hk416sdgl","RH_hk416sdglaim","RH_hk416sdgleotech","RH_hk417sp","RH_hk417sgl","RH_hk417sglaim","RH_hk417sgleotech","RH_hk417sglacog","RH_hk417sd","RH_hk417sdaim","RH_hk417sdeotech","RH_hk417sdacog","vil_G3TGS","vil_G3a3","vil_G3ZF","vil_G3sg1b","vil_G36a2","vil_AG36KA4","vil_G36VA4Eot","vil_G36KVZ","vil_G36KSK","vil_G36CC","vil_G36KV3","AKS_74_U","AKS_74_UN_kobra","AK_74_GL_kobra","AKS_74","AKS_74_kobra","AKS_74_pso","AK_107_kobra","AK_107_GL_kobra","AK_107_pso","AK_107_GL_pso","AK_47_M","AK_47_S","Sa58V_RCO_EP1","Sa58V_CCO_EP1","vil_AeK_3_K","vil_AKS_47","vil_AK_47","vil_AKM_GL","vil_AKMS_GP25","vil_AK_nato_m1","vil_M64","vil_AMD","vil_AK_nato_m80","vil_AKMSB","vil_AK_74m_EOT","vil_AK_74m_EOT_Alfa","vil_AK_74m_EOT_FSB","vil_AK_74m_c","vil_AK_74m_p29","vil_AK_74m_gp_29","vil_AK_74m_gp","vil_Abakan_gp","vil_Abakan_P29","vil_ak12","vil_ak12_ap","vil_ak12_gp","vil_SVDK","vil_M110","vil_SR25","vil_M21G","vil_M21","vil_vsk94","vil_VSS_PSO","vil_VAL_C","FHQ_XM2010_DESERT","FHQ_XM2010_SD_DESERT","FHQ_XM2010_NV_DESERT","FHQ_XM2010_NV_SD_DESERT","vil_SV_98_SD","SCAR_L_CQC_EGLM_Holo","SCAR_L_CQC_CCO_SD","SCAR_L_STD_HOLO","SCAR_L_CQC_Holo","SCAR_L_CQC","SCAR_H_LNG_Sniper_SD","SCAR_H_LNG_Sniper","SCAR_H_CQC_CCO_SD","SCAR_H_CQC_CCO","M32_EP1","vil_MP5SD_EOTech","bizon_silenced","MP5SD","vil_uzi_SD","vil_uzimini_SD","vil_MP5_EOTech","bizon","MP5A5","vil_uzi_c","vil_uzi","vil_uzimini","vil_9a91_csd","vil_9a91","vil_9a91_c","VSS_vintorez","vil_VAL_N","vil_VSS_N","AKS_74_NSPU","vil_PKM_N","vil_RPK74M_N","vil_AK_74M_N","AA12_PMC","M79_EP1","FHQ_ACR_WDL_HAMR_GL_SD_F","FHQ_ACR_WDL_HAMR_SD_F","FHQ_ACR_WDL_HWS_F","FHQ_ACR_WDL_HWS_GL","FHQ_ACR_WDL_HWS_GL_SD_F","FHQ_ACR_WDL_HWS_SD_F","FHQ_ACR_WDL_IRN_GL","FHQ_ACR_WDL_IRN_GL_SD","FHQ_ACR_WDL_IRN_GL_SD_F","FHQ_ACR_WDL_RCO_F","FHQ_ACR_WDL_RCO_GL","FHQ_ACR_WDL_RCO_GL_SD","FHQ_ACR_WDL_RCO_SD_F","FHQ_ACR_WDL_IRN_SD"

#define RIFLE_AND_MASHINGANS \
	{"M240_DZ",0.15}, \
	{"Mk_48_DZ",0.15}, \
	{"M249_EP1_DZ",0.15}, \
	{"M249_DZ",0.15}, \
	{"MG36_camo",0.15}, \
	{"MG36",0.15}, \
	{"vil_PKP_EOT",0.15}, \
	{"RPK_74",0.15}, \
	{"vil_RPK74M",0.15}, \
	{"vil_RPK74M_P29",0.15}, \
	{"vil_RPK75_Romania",0.15}, \
	{"vil_RPD",0.15}, \
	{"vil_zastava_m84",0.15}, \
	{"vil_RPK75_M72",0.15}, \
	{"vil_MG4",0.15}, \
	{"vil_Mg3",0.15}, \
	{"vil_Minimi",0.15}, \
	{"vil_FnMag",0.15}, \
	{"M4A1",0.2}, \
	{"M4A1_Aim_camo",0.2}, \
	{"M4A1_HWS_GL_camo",0.2}, \
	{"M4A3_CCO_EP1",0.2}, \
	{"M4A3_RCO_GL_EP1",0.2}, \
	{"M16A2GL",0.2}, \
	{"M16a4",0.2}, \
	{"M16A4_ACG_GL",0.2}, \
	{"BAF_L85A2_UGL_Holo",0.2}, \
	{"BAF_L85A2_UGL_ACOG",0.2}, \
	{"BAF_L85A2_UGL_SUSAT",0.2}, \
	{"BAF_L86A2_ACOG",0.2}, \
	{"m8_carbineGL",0.2}, \
	{"m8_compact",0.2}, \
	{"m8_sharpshooter",0.2}, \
	{"m8_SAW",0.2}, \
	{"RH_ctar21",0.2}, \
	{"RH_ctar21mgl",0.2}, \
	{"RH_star21",0.2}, \
	{"RH_ctar21glacog",0.2}, \
	{"vil_Groza_GL",0.2}, \
	{"vil_Groza_SD",0.2}, \
	{"vil_Groza_SC",0.2}, \
	{"RH_masb",0.2}, \
	{"RH_masbaim",0.2}, \
	{"RH_masbeotech",0.2}, \
	{"RH_masbacog",0.2}, \
	{"RH_masbsd",0.2}, \
	{"RH_masbsdaim",0.2}, \
	{"RH_masbsdeotech",0.2}, \
	{"RH_masbsdacog",0.2}, \
	{"RH_acrbaim",0.2}, \
	{"RH_acrbacog",0.2}, \
	{"RH_acrbgl",0.2}, \
	{"RH_acrbglaim",0.2}, \
	{"RH_acrbgleotech",0.2}, \
	{"RH_acrbglacog",0.2}, \
	{"FN_FAL",0.2}, \
	{"vil_AG3",0.2}, \
	{"vil_AG3EOT",0.2}, \
	{"vil_sg540",0.2}, \
	{"vil_sg542f",0.2}, \
	{"vil_Insas",0.2}, \
	{"vil_Insas_lmg",0.2}, \
	{"vil_Galil",0.2}, \
	{"vil_Galil_arm",0.2}, \
	{"RH_hk416gl",0.15}, \
	{"RH_hk416glaim",0.15}, \
	{"RH_hk416gleotech",0.15}, \
	{"RH_hk416glacog",0.15}, \
	{"RH_hk416sgl",0.15}, \
	{"RH_hk416sglaim",0.15}, \
	{"RH_hk416sgleotech",0.15}, \
	{"RH_hk416sglacog",0.15}, \
	{"RH_hk416sdgl",0.15}, \
	{"RH_hk416sdglaim",0.15}, \
	{"RH_hk416sdgleotech",0.15}, \
	{"RH_hk417sp",0.15}, \
	{"RH_hk417sgl",0.15}, \
	{"RH_hk417sglaim",0.15}, \
	{"RH_hk417sgleotech",0.15}, \
	{"RH_hk417sglacog",0.15}, \
	{"RH_hk417sd",0.15}, \
	{"RH_hk417sdaim",0.15}, \
	{"RH_hk417sdeotech",0.15}, \
	{"RH_hk417sdacog",0.15}, \
	{"vil_G3TGS",0.2}, \
	{"vil_G3a3",0.2}, \
	{"vil_G3ZF",0.2}, \
	{"vil_G3sg1b",0.2}, \
	{"vil_G36a2",0.2}, \
	{"vil_AG36KA4",0.2}, \
	{"vil_G36VA4Eot",0.2}, \
	{"vil_G36KVZ",0.2}, \
	{"vil_G36KSK",0.2}, \
	{"vil_G36CC",0.2}, \
	{"vil_G36KV3",0.2}, \
	{"AKS_74_U",0.2}, \
	{"AKS_74_UN_kobra",0.2}, \
	{"AK_74_GL_kobra",0.2}, \
	{"AK_74_GL",0.2}, \
	{"AKS_74",0.2}, \
	{"AKS_74_kobra",0.2}, \
	{"AKS_74_pso",0.2}, \
	{"AK_107_kobra",0.2}, \
	{"AK_107_GL_kobra",0.2}, \
	{"AK_107_pso",0.2}, \
	{"AK_107_GL_pso",0.2}, \
	{"AK_47_M",0.2}, \
	{"AK_47_S",0.2}, \
	{"Sa58V_RCO_EP1",0.2}, \
	{"Sa58V_CCO_EP1",0.2}, \
	{"vil_AKS_47",0.2}, \
	{"vil_AK_47",0.2}, \
	{"vil_AKM_GL",0.2}, \
	{"vil_AKMS_GP25",0.2}, \
	{"vil_AK_nato_m1",0.2}, \
	{"vil_M64",0.2}, \
	{"vil_AMD",0.2}, \
	{"vil_AK_nato_m80",0.2}, \
	{"vil_AKMSB",0.2}, \
	{"vil_AK_74m_EOT",0.2}, \
	{"vil_AK_74m_EOT_Alfa",0.2}, \
	{"vil_AK_74m_EOT_FSB",0.2}, \
	{"vil_AK_74m_c",0.2}, \
	{"vil_AK_74m_p29",0.2}, \
	{"vil_AK_74m_gp_29",0.2}, \
	{"vil_AK_74m_gp",0.2}, \
	{"vil_Abakan_gp",0.2}, \
	{"vil_Abakan_P29",0.2}, \
	{"vil_ak12",0.2}, \
	{"vil_ak12_ap",0.2}, \
	{"vil_ak12_gp",0.2}, \
	{"vil_MP5SD_EOTech",0.2}, \
	{"bizon_silenced",0.2}, \
	{"MP5SD",0.2}, \
	{"vil_uzi_SD",0.2}, \
	{"vil_uzimini_SD",0.2}, \
	{"vil_MP5_EOTech",0.2}, \
	{"bizon",0.2}, \
	{"MP5A5",0.2}, \
	{"vil_uzi_c",0.2}, \
	{"vil_uzi",0.2}, \
	{"vil_uzimini",0.2}, \
	{"vil_9a91_csd",0.2}, \
	{"vil_9a91",0.2}, \
	{"vil_9a91_c",0.2}, \
	{"FHQ_ACR_WDL_HAMR_GL_SD_F",0.2}, \
	{"FHQ_ACR_WDL_HAMR_SD_F",0.2}, \
	{"FHQ_ACR_WDL_HWS_F",0.2}, \
	{"FHQ_ACR_WDL_HWS_GL",0.2}, \
	{"FHQ_ACR_WDL_HWS_GL_SD_F",0.2}, \
	{"FHQ_ACR_WDL_HWS_SD_F",0.2}, \
	{"FHQ_ACR_WDL_IRN_GL",0.2}, \
	{"FHQ_ACR_WDL_IRN_GL_SD",0.2}, \
	{"FHQ_ACR_WDL_IRN_GL_SD_F",0.2}, \
	{"FHQ_ACR_WDL_RCO_F",0.2}, \
	{"FHQ_ACR_WDL_RCO_GL",0.2}, \
	{"FHQ_ACR_WDL_RCO_GL_SD",0.2}, \
	{"FHQ_ACR_WDL_RCO_SD_F",0.2}, \
	{"FHQ_ACR_WDL_IRN_SD",0.2} 	
	
#define DZE_ISWRECK 	"UH60Wreck_DZ","UH1Wreck_DZ","UH60_NAVY_Wreck_DZ","UH60_ARMY_Wreck_DZ","UH60_NAVY_Wreck_burned_DZ","UH60_ARMY_Wreck_burned_DZ","Mass_grave_DZ","SKODAWreck","HMMWVWreck","UralWreck","datsun01Wreck","hiluxWreck","datsun02Wreck","UAZWreck","Land_Misc_Garb_Heap_EP1","Fort_Barricade_EP1","Rubbish2"