/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PARAMS3PVT(_c130,_action,_phase);

if (_action=="ramp")exitWith{
	[_c130,_phase] spawn {
	PARAMS2PVT(_c130,_phase);
	[_c130,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_c130 animate ["ramp_top",_phase];
	_c130 animate ["ramp_bottom",_phase];
	};
};
if (_action=="ramp_top")exitWith{
	[_c130,_phase] spawn {
	PARAMS2PVT(_c130,_phase);
	[_c130,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_c130 animate ["ramp_top",_phase];
	};
};
if (_action=="ramp_bottom")exitWith{
	[_c130,_phase] spawn {
	PARAMS2PVT(_c130,_phase);
	[_c130,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_c130 animate ["ramp_bottom",_phase];
	};
};
if (_action=="door1")exitWith{
	[_c130, 15, true, (getPosATL _c130)] spawn player_alertZombies;
	_c130 animate ["door_1",_phase];
};
if (_action=="door2")exitWith{
	[_c130, 15, true, (getPosATL _c130)] spawn player_alertZombies;
	_c130 animate ["door_2_1",_phase];
};
if (_action=="door3")exitWith{
	[_c130, 15, true, (getPosATL _c130)] spawn player_alertZombies;
	_c130 animate ["door_2_2",_phase];
};