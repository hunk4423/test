/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

#define AL_MOTO			"Motorcycle"
#define AL_CAR			"Ship","TowingTractor","Motorcycle","GLT_M300_ST","GLT_M300_LT","LandRover_Base","UAZ_Base","ArmoredSUV_Base_PMC","SUV_Base_EP1","S1203_TK_CIV_EP1","Volha_TK_CIV_Base_EP1","VWGolf","tractor","SkodaBase","Pickup_PK_base","Offroad_DSHKM_base","Lada_base","HMMWV_Base","hilux1_civil_1_open","BTR40_base_EP1","BTR40_MG_base_EP1","BAF_Jackal2_BASE_D"
#define AL_TRUCK		"Truck","BRDM2_Base","M113_Base"
#define AL_APS			"Car","BAF_Jackal2_BASE_D"

BTC_lift_pilot	= [];
AL_status		= 0;
AL_lift_min_h	= 2.5;
AL_lift_max_h	= 18;
AL_lift_radius	= 5;
AL_Liftable		= ["Motorcycle","Car","Truck","Wheeled_APC","Tracked_APC","Ship","Tank","Air"];
AL_Hud_Cond		= false;
AL_HUD_x		= (SafeZoneW+2*SafeZoneX) + 0.045;
AL_HUD_y		= (SafeZoneH+2*SafeZoneY) + 0.045;

AL_filter = [
	[AL_MOTO],
	[AL_MOTO,AL_CAR],
	[AL_MOTO,AL_CAR,AL_TRUCK],
	[AL_MOTO,AL_APS],
	["LandVehicle","Ship"],
	["LandVehicle","Ship","Air"]
];
	
AL_class = [
	[["AH6_Base_EP1","CSJ_GyroC","pook_H13_base"],0],
	[["CH47_base_EP1","USEC_ch53_E","CH53_DZE"],5],
	[["AW159_Lynx_BAF","Ka60_Base_PMC"],1],
	[["UH1_Base","UH60_Base","AH1_Base","Kamov_Base","AH64_base_EP1","Mi17_DZE","Mi17_Civilian_DZ"],2],
	[["Mi17_base","Mi24_Base"],3],
	[["BAF_Merlin_HC3_D","BAF_Merlin_DZE"],4]
];

[] EXECVM_SCRIPT(radar.sqf);

//Functions
fnc_getLiftableArray = {
	PVT3(_chopper,_array,_done);
	PARAMS1(_chopper);
	_array = [];
	_done=false;
	{
		_kof = SEL0(_x);
		_id = SEL1(_x);
		{
			if (_chopper isKindOf(_x))exitWith{_array = SEL(AL_filter,_id);_done=true};
		}count _kof;
		if (_done)exitWith{};
	} count AL_class;
	_array
};

fnc_ParaDrop = {
	private ["_chute","_height","_plane","_cargo","_chute_type","_alt","_t"];
	PARAMS3(_plane,_cargo,_chute_type);
	_t = diag_tickTime + 60;
	_height = [_plane, _cargo] call fnc_getHeightCargo;
	if (_cargo isKindOf "Air")then{_alt=4}else{_alt=1};
	if (_height > 50) then {
		if (typeOf _plane == "MH6J_DZ") then {
			_chute = createVehicle [_chute_type,[((position _plane) select 0)-5,((position _plane) select 1)-10,((position _plane) select 2)- 4],[],0,"NONE"];
		} else {
			_chute = createVehicle [_chute_type,[((position _plane) select 0)-5,((position _plane) select 1)-3,((position _plane) select 2)- 4],[],0,"NONE"];
		};
		_smoke = "SmokeshellGreen" createVehicle position _plane;
		_smoke attachto [_cargo, [0,0,0]]; 
		_cargo attachTo [_chute, [0,0,0]];
		while {_height > 5}do{
			sleep 0.1;
			_height = [_plane, _cargo] call fnc_getHeightCargo;
		};
		detach _cargo;
	};
	while {(SEL2([_cargo] call FNC_getPos)>_alt)&&(diag_tickTime < _t)}do{
		sleep 0.1;
	};
	_cargo setVelocity [0,0,0];
	sleep 2;
	SetInTow(_cargo,false);
	UpdateAll(_cargo);
};

fnc_getHeightCargo={
	PVT4(_plane,_cargo,_objects,_height);
	PARAMS2(_plane,_cargo);

	_cargo_position=getpos(_cargo);
	_cargo_position_asl=getposASL(_cargo);
	_height=0;
	_objects=lineIntersectsWith [_cargo_position_asl,[SEL0(_cargo_position_asl),SEL1(_cargo_position_asl),-2000],_plane,_cargo,true];
	if ((count _objects)>0)then{
		_height=_cargo distance SEL0(_objects);
	}else{
		_height=SEL2(_cargo_position);
	};
	//diag_log format ["DEBUG BTC LIFT: Pre _height: %1", _height];
	_height
};

fnc_togleRadarAction={
	PARAMS1PVT(_vehicle);
	if (AL_Hud_Cond)then{
		AeroLiftHudId=_vehicle addAction ["<t color='#ED2744'>Выключить радар</t>",SCRIPT_FILE(togleRadar.sqf),_chopper,0,false,false];
	} else {
		AeroLiftHudId=_vehicle addAction ["<t color='#ED2744'>Включить радар</t>",SCRIPT_FILE(togleRadar.sqf),_chopper,0,false,false];
	};
};