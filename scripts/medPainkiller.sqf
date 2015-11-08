/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT2(_chance,_msg);
PARAMS2(_unit,_medic);
if((_unit == player)or(vehicle player!=player))then{
	call{
		if (r_player_blood<3000)exitWith{_chance=100;};
		if (r_player_blood<6000)exitWith{_chance=60;};
		if (r_player_blood<8000)exitWith{_chance=30;};
		if (r_player_blood<10000)exitWith{_chance=5;};
		_chance=1;
	};
	
	if(RND(_chance))then{
		if(R3F_TIRED_Accumulator>40000)then{
			R3F_TIRED_Accumulator=40000;
		};
		_msg="Болеутоляющие не помогают, нужен морфин...";
		cutText[_msg, "PLAIN DOWN"];
		systemChat _msg;
	}else{
		r_player_inpain=false;
		R3F_TIRED_Accumulator=0;
		player setVariable ["USEC_inPain", false, true];
		player setVariable['medForceUpdate',true,true];
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;			
	};
	
	dayz_thirst=dayz_thirst+250;
	[] EXECVM_SCRIPT(pain.sqf);	
};
