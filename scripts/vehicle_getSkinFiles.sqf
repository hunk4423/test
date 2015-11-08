/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private["_object","_type","_array","_SEL0","_path","_num","_abort","_count"];
_object=THIS0;
if(isNull _object)exitWith{};	
_num=(THIS1)-1;
_type=typeOf _object;
_abort=false;
_path=[];
if(_type in ["ori_p85_originsmod_CUCV","ori_p85_originsmod_cucv_pickup","ori_originsmod_pickupoldfuel","ori_vil_originsmod_volvo_fl290","ori_KaTransp","ori_originsmod_pickupold","ori_col_truck_tent","ori_col_truck_fuel"])exitWith{_path=["",0];_path};

switch(true)do{
	//Skin1
	case(_object isKindOf "AH6_Base_EP1"): {_array=[["AH6X_Ori_black_co.paa","AH6X_Ori_blue_co.paa","AH6X_Ori_camo_u_co.paa","AH6X_Ori_camo_w_co.paa","AH6X_Ori_pink_co.paa","AH6X_Ori_red_co.paa","AH6X_Ori_special1_co.paa","AH6X_Ori_special2_co.paa","AH6X_Ori_special3_co.paa","AH6X_Ori_special4_co.paa","AH6X_Ori_special5_co.paa","AH6X_Ori_special6_co.paa","AH6X_Ori_yellow_co.paa"],"skins1\AH6X_Ori"];};	
	case(_object isKindOf "ATV_Base_EP1"): {_array=[["ATV_Ori_black_co.paa","ATV_Ori_blue_co.paa","ATV_Ori_camo_u_co.paa","ATV_Ori_camo_w_co.paa","ATV_Ori_pink_co.paa","ATV_Ori_red_co.paa","ATV_Ori_yellow_co.paa"],"skins1\ATV_Ori"];};
	case(_object isKindOf "car_hatchback"): {_array=[["car_hatchback_black_co.paa","car_hatchback_blue_co.paa","car_hatchback_camo_u_co.paa","car_hatchback_camo_w_co.paa","car_hatchback_pink_co.paa","car_hatchback_red_co.paa","car_hatchback_special1_co.paa","car_hatchback_yellow_co.paa"],"skins1\car_hatchback"];};	
	case(_object isKindOf "car_sedan"): {_array=[["car_sedan_black_co.paa","car_sedan_blue_co.paa","car_sedan_camo_u_co.paa","car_sedan_camo_w_co.paa","car_sedan_pink_co.paa","car_sedan_red_co.paa","car_sedan_yellow_co.paa"],"skins1\car_sedan"];};	
	case(_object isKindOf "hilux1_civil_1_open"): {_array=[["Hilux_black_co.paa","Hilux_blue_co.paa","Hilux_camo_u_co.paa","Hilux_camo_w_co.paa","Hilux_pink_co.paa","Hilux_red_co.paa","Hilux_special1_co.paa","Hilux_special2_co.paa","Hilux_special3_co.paa", "Hilux_special4_co.paa", "Hilux_yellow_co.paa"],"skins1\Hilux"];};	
	case(_object isKindOf "HMMWV_Base"): {_array=[["hmmwv_telo_co.paa"],"skins1\hmmwv"];};
	case(_object isKindOf "Kamaz_Base"): {_array=[[["kamaz_black_co.paa","kamaz_back_white_co.paa"],["kamaz_blue_co.paa","kamaz_back_white_co.paa"],["kamaz_camo_u_co.paa","kamaz_back_camo_u_co.paa"],["kamaz_camo_w_co.paa","kamaz_back_camo_w_co.paa"],["kamaz_pink_co.paa","kamaz_back_white_co.paa"],["kamaz_red_co.paa","kamaz_back_white_co.paa"],["kamaz_yellow_co.paa","kamaz_back_white_co.paa"]],"skins1\kamaz"];};	
	case(_object isKindOf "Lada_base"): {_array=[["lada1_black_co.paa","lada1_blue_co.paa","lada1_camo_u_co.paa","lada1_camo_w_co.paa","lada1_pink_co.paa","lada1_red_co.paa","lada1_special1_co.paa","lada1_white_co.paa","lada1_yellow_co.paa"],"skins1\Lada1"];};
	case(_type=="ori_vil_lada_2105_rust"): {_array=[["Lada2015_black_co.paa","Lada2015_blue_co.paa","Lada2015_camo_u_co.paa","Lada2015_camo_w_co.paa","Lada2015_pink_co.paa","Lada2015_red_co.paa","Lada2015_special1_co.paa","Lada2015_yellow_co.paa"],"skins1\Lada2015"];};
	case(_type=="LandRover_Ori"): {_array=[["LandRover_black_co.paa","LandRover_blue_co.paa","LandRover_camo_u_co.paa","LandRover_camo_w_co.paa","LandRover_pink_co.paa","LandRover_red_co.paa","LandRover_special1_co.paa","LandRover_special2_co.paa","LandRover_special3_co.paa", "LandRover_yellow_co.paa"],"skins1\LandRover"];};	
	case(_object isKindOf "ori_vil_originsmod_lublin_truck"): {_array=[["lublin_camo_u_co.paa","lublin_camo_w_co.paa"],"skins1\Lublin"];};

	//Skin2
	case(_object isKindOf "UH60_Base"): {_array=[[["MH60S_Ori_1_black_co.paa","MH60S_Ori_2_black_co.paa"],["MH60S_Ori_1_blue_co.paa","MH60S_Ori_2_blue_co.paa"],["MH60S_Ori_1_camo_u_co.paa","MH60S_Ori_2_camo_u_co.paa"],["MH60S_Ori_1_camo_w_co.paa","MH60S_Ori_2_camo_w_co.paa"],["MH60S_Ori_1_pink_co.paa","MH60S_Ori_2_pink_co.paa"],["MH60S_Ori_1_red_co.paa","MH60S_Ori_2_red_co.paa"],["MH60S_Ori_1_special1_co.paa","MH60S_Ori_2_special1_co.paa"],["MH60S_Ori_1_special2_co.paa","MH60S_Ori_2_special2_co.paa"],["MH60S_Ori_1_special3_co.paa","MH60S_Ori_2_special3_co.paa"],["MH60S_Ori_1_special4_co.paa","MH60S_Ori_2_special4_co.paa"],["MH60S_Ori_1_special5_co.paa","MH60S_Ori_2_special5_co.paa"],["MH60S_Ori_1_special6_co.paa","MH60S_Ori_2_special6_co.paa"],["MH60S_Ori_1_special7_co.paa","MH60S_Ori_2_special7_co.paa"],["MH60S_Ori_1_yellow_co.paa","MH60S_Ori_2_yellow_co.paa"]],"skins2\MH60S_Ori"];};
	case(_object isKindOf "Mi17_base"): {_array=[["Mi17_Ori_black_co.paa","Mi17_Ori_blue_co.paa","Mi17_Ori_camo_u_co.paa","Mi17_Ori_camo_w_co.paa","Mi17_Ori_pink_co.paa","Mi17_Ori_red_co.paa","Mi17_Ori_special10_co.paa","Mi17_Ori_special11_co.paa","Mi17_Ori_special12_co.paa","Mi17_Ori_special13_co.paa","Mi17_Ori_special1_co.paa","Mi17_Ori_special2_co.paa","Mi17_Ori_special3_co.paa","Mi17_Ori_special4_co.paa","Mi17_Ori_special5_co.paa","Mi17_Ori_special6_co.paa","Mi17_Ori_special7_co.paa","Mi17_Ori_special8_co.paa","Mi17_Ori_special9_co.paa","Mi17_Ori_yellow_co.paa"],"skins2\Mi17_Ori"];};
	case(_object isKindOf "Old_moto_base"): {_array=[["old_moto_black_co.paa","old_moto_blue_co.paa","old_moto_camo_u_co.paa","old_moto_camo_w_co.paa","old_moto_pink_co.paa","old_moto_red_co.paa","old_moto_special1_co.paa","old_moto_special2_co.paa","old_moto_yellow_co.paa"],"skins2\old_moto"];};
	case(_type=="ori_buchanka"): {_array=[["ori_buhanka_black_co.paa","ori_buhanka_blue_co.paa","ori_buhanka_camo_u_co.paa","ori_buhanka_camo_w_co.paa","ori_buhanka_pink_co.paa","ori_buhanka_red_co.paa","ori_buhanka_special1_co.paa","ori_buhanka_special10_co.paa","ori_buhanka_special11_co.paa","ori_buhanka_special2_co.paa", "ori_buhanka_special3_co.paa", "ori_buhanka_special4_co.paa", "ori_buhanka_special5_co.paa", "ori_buhanka_special6_co.paa", "ori_buhanka_special7_co.paa", "ori_buhanka_special8_co.paa", "ori_buhanka_special9_co.paa", "ori_buhanka_yellow_co.paa"],"skins2\ori_buhanka"];};
	case(_type=="ori_m3"): {_array=[["ori_m3_black_co.paa","ori_m3_blue_co.paa","ori_m3_camo_u_co.paa","ori_m3_camo_w_co.paa","ori_m3_pink_co.paa","ori_m3_red_co.paa","ori_m3_special1_co.paa","ori_m3_special2_co.paa","ori_m3_special3_co.paa", "ori_m3_special4_co.paa", "ori_m3_special5_co.paa", "ori_m3_special6_co.paa", "ori_m3_yellow_co.paa"],"skins2\ori_m3"];};
	case(_type=="ori_maniac"): {_array=[["ori_maniac_black_co.paa","ori_maniac_blue_co.paa","ori_maniac_camo_u_co.paa","ori_maniac_camo_w_co.paa","ori_maniac_pink_co.paa","ori_maniac_red_co.paa","ori_maniac_special1_co.paa","ori_maniac_special2_co.paa","ori_maniac_special3_co.paa", "ori_maniac_special4_co.paa", "ori_maniac_special5_co.paa", "ori_maniac_special6_co.paa", "ori_maniac_special7_co.paa", "ori_maniac_special8_co.paa", "ori_maniac_yellow_co.paa"],"skins2\ori_maniac"];};
	case(_type=="ori_taviander"): {_array=[["ori_taviander_black_co.paa","ori_taviander_blue_co.paa","ori_taviander_camo_u_co.paa","ori_taviander_camo_w_co.paa","ori_taviander_pink_co.paa","ori_taviander_red_co.paa","ori_taviander_special1_co.paa","ori_taviander_special2_co.paa","ori_taviander_special3_co.paa", "ori_taviander_special4_co.paa", "ori_taviander_special5_co.paa", "ori_taviander_special6_co.paa", "ori_taviander_yellow_co.paa"],"skins2\ori_taviander"];};
	case(_type=="ori_zaz968m"): {_array=[["ori_zaz968m_black_co.paa","ori_zaz968m_blue_co.paa","ori_zaz968m_camo_u_co.paa","ori_zaz968m_camo_w_co.paa","ori_zaz968m_pink_co.paa","ori_zaz968m_red_co.paa","ori_zaz968m_special1_co.paa","ori_zaz968m_special2_co.paa","ori_zaz968m_special3_co.paa","ori_zaz968m_special4_co.paa","ori_zaz968m_special5_co.paa", "ori_zaz968m_special6_co.paa","ori_zaz968m_special7_co.paa", "ori_zaz968m_yellow_co.paa"],"skins2\ori_zaz968m"];};

	//Skin3
	case((_type=="ori_poldek")||(_type=="ori_poldek_black")): {_array=[["polonez_black_co.paa","polonez_blue_co.paa","polonez_camo_u_co.paa","polonez_camo_w_co.paa","polonez_pink_co.paa","polonez_red_co.paa","polonez_yellow_co.paa"],"skins3\Polonez"];};
	case((_type=="ori_pragaCopter_green")||(_type=="ori_pragaCopter_yellow")): {_array=[["Praga_black_co.paa","Praga_blue_co.paa","Praga_camo_u_co.paa","Praga_camo_w_co.paa","Praga_pink_co.paa","Praga_red_co.paa","Praga_special1_co.paa","Praga_special2_co.paa","Praga_yellow_co.paa"],"skins3\Praga"];};
	case(_type=="S1203_TK_CIV_EP1"||_type=="S1203_ambulance_EP1"): {_array=[["s1203_black_co.paa","s1203_blue_co.paa","s1203_camo_u_co.paa","s1203_camo_w_co.paa","s1203_pink_co.paa","s1203_red_co.paa","s1203_special1_co.paa","s1203_special2_co.paa","s1203_special3_co.paa", "s1203_yellow_co.paa"],"skins3\S1203"];};
	case(_type=="ori_scrapTank"): {_array=[[["apc_camo_u_co.paa","apc_camo_w_co.paa"],["apc_camo_w_co.paa","apc_camo_u_co.paa"]],"skins3\scrapAPC"];};
	case(_type=="ori_survivorBus"): {_array=[["ScrapBus_black_co.paa","ScrapBus_blue_co.paa","ScrapBus_camo_u_co.paa","ScrapBus_camo_w_co.paa","ScrapBus_nemo_co.paa","ScrapBus_pink_co.paa","ScrapBus_red_co.paa","ScrapBus_yellow_co.paa"],"skins3\ScrapBus"];};	
	case(_object isKindOf "SUV_Base_EP1"): {_array=[["SUV_Special_black_co.paa","SUV_Special_blue_co.paa","SUV_Special_camo_u_co.paa","SUV_Special_camo_w_co.paa","SUV_Special_pink_co.paa","SUV_Special_red_co.paa","SUV_Special_special1_co.paa","SUV_Special_special2_co.paa","SUV_Special_special3_co.paa", "SUV_Special_special4_co.paa", "SUV_Special_special5_co.paa", "SUV_Special_special6_co.paa", "SUV_Special_special7_co.paa", "SUV_Special_special8_co.paa", "SUV_Special_yellow_co.paa"],"skins3\SUV_Special"];};	
	case(_type=="ori_transit"): {_array=[["transit_black_co.paa","transit_blue_co.paa","transit_camo_u_co.paa","transit_camo_w_co.paa","transit_pink_co.paa","transit_red_co.paa","transit_yellow_co.paa"],"skins3\transit"];};	
	case(_type=="uh1h_ori"): {_array=[[["UH1H_Ori_1_black_co.paa","UH1H_Ori_2_black_co.paa"],["UH1H_Ori_1_blue_co.paa","UH1H_Ori_2_blue_co.paa"],["UH1H_Ori_1_camo_u_co.paa","UH1H_Ori_2_camo_u_co.paa"],["UH1H_Ori_1_camo_w_co.paa","UH1H_Ori_2_camo_w_co.paa"],["UH1H_Ori_1_pink_co.paa","UH1H_Ori_2_pink_co.paa"],["UH1H_Ori_1_red_co.paa","UH1H_Ori_2_red_co.paa"],["UH1H_Ori_1_special1_co.paa","UH1H_Ori_2_special1_co.paa"],["UH1H_Ori_1_special2_co.paa","UH1H_Ori_2_special2_co.paa"],["UH1H_Ori_1_special3_co.paa","UH1H_Ori_2_special3_co.paa"],["UH1H_Ori_1_special4_co.paa","UH1H_Ori_2_special4_co.paa"],["UH1H_Ori_1_yellow_co.paa","UH1H_Ori_2_yellow_co.paa"]],"skins3\UH1H_Ori"];};

	//Skin4
	case(_type=="ori_gaika"): {_array=[["body1_co.paa","body2_co.paa"],"skins4\gaika"];};	
	case(_type=="ori_vil_originsmod_truck_civ"): {_array=[[["truck_w_co.paa","vilTruck_back_camo_u_co.paa"],["vilTruck_black_co.paa","vilTruck_back_special2_co.paa"],["vilTruck_black_co.paa","vilTruck_back_special1_co.paa"],["vilTruck_blue_co.paa","vilTruck_back_camo_u_co.paa"],["vilTruck_camo_u_co.paa","vilTruck_back_camo_u_co.paa"],["vilTruck_camo_w_co.paa","vilTruck_back_camo_w_co.paa"],["vilTruck_pink_co.paa","vilTruck_back_camo_u_co.paa"],["vilTruck_red_co.paa","vilTruck_back_special2_co.paa"],["vilTruck_yellow_co.paa","vilTruck_back_special1_co.paa"]],"skins4\vilTruck"];};
	case(_object isKindOf "Volha_TK_CIV_Base_EP1"): {_array=[["volha_black_co.paa","volha_blue_co.paa","volha_camo_u_co.paa","volha_camo_w_co.paa","volha_pink_co.paa","volha_red_co.paa","volha_special1_co.paa","volha_special2_co.paa","volha_yellow_co.paa"],"skins4\volha"];};
	case(_object isKindOf "VWGOLF"): {_array=[["vwgolf_black_co.paa","vwgolf_blue_co.paa","vwgolf_camo_u_co.paa","vwgolf_camo_w_co.paa","vwgolf_pink_co.paa","vwgolf_red_co.paa","vwgolf_special1_co.paa","vwgolf_special2_co.paa","vwgolf_special3_co.paa", "vwgolf_yellow_co.paa"],"skins4\VWGOLF"];};

	//На всякий случай в конце что бы сюда не попали машины из ори
	case(_object isKindOf "UAZ_Base"): {_array=[["uaz_black_co.paa","uaz_blue_co.paa","uaz_camo_u_co.paa","uaz_camo_w_co.paa","uaz_pink_co.paa","uaz_red_co.paa","uaz_yellow_co.paa"],"skins3\UAZ"];};
	case(_object isKindOf "Ural_Base"): {_array=[[["ural_kabina_black_co.paa","ural_back2_black_co.paa"],["ural_kabina_blue_co.paa","ural_back_blue_co.paa"],["ural_kabina_camo_u_co.paa","ural_back_camo_u_co.paa"],["ural_kabina_camo_w_co.paa","ural_back_camo_w_co.paa"],["ural_kabina_pink_co.paa","ural_back_pink_co.paa"],["ural_kabina_red_co.paa","ural_back_red_co.paa"],["ural_kabina_yellow_co.paa","ural_back_yellow_co.paa"],["ural_kabina_special1_co.paa","ural_back_special2_co.paa"],["ural_kabina_special2_co.paa","ural_back_red_co.paa"],["ural_kabina_special4_co.paa","ural_back_red_co.paa"],["ural_kabina_special5_co.paa","ural_back_special1_co.paa"],["ural_kabina_special6_co.paa","ural_back_special2_co.paa"]],"skins3\Ural"];};
	case(_object isKindOf "V3S_Base"): {_array=[[["v3s_kabpar_black_co.paa","v3s_intkor_black_co.paa"],["v3s_kabpar_blue_co.paa","v3s_intkor_blue_co.paa"],["v3s_kabpar_camo_u_co.paa","v3s_intkor_camo_u_co.paa"],["v3s_kabpar_camo_w_co.paa","v3s_intkor_camo_w_co.paa"],["v3s_kabpar_pink_co.paa","v3s_intkor_pink_co.paa"],["v3s_kabpar_red_co.paa","v3s_intkor_red_co.paa"],["v3s_kabpar_yellow_co.paa","v3s_intkor_yellow_co.paa"],["v3s_kabpar_special1_co.paa","v3s_intkor_black_co.paa"]],"skins4\V3S"];};
	case(_object isKindOf "Pickup_PK_base"): {_array=[["pickup_black_co.paa","pickup_blue_co.paa","pickup_camo_u_co.paa","pickup_camo_w_co.paa","pickup_pink_co.paa","pickup_red_co.paa","pickup_special1_co.paa","pickup_special2_co.paa","pickup_special3_co.paa", "pickup_yellow_co.paa"],"skins3\pickup"];};
	default{_abort=true;};
};
if(_abort)exitWith{_path=["",0];_path};

_SEL0=SEL0(_array);
_count=count _SEL0;
if(_num>_count)then{_num=1;};
if((typeName SEL0(_SEL0))=="STRING")then{
	_path=[[format["%1\%2",SEL1(_array),_SEL0 select _num]]];
}else{
	{
		_path=_path+[format["%1\%2",SEL1(_array),_x]];
	}forEach (_SEL0 select _num);
	_path=[_path];
};
_path set [count _path,_count];
_path