/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PARAMS3PVT(_mv22,_action,_phase);

if (_action=="ramp")exitWith{
	[_mv22,_phase] spawn {
	PARAMS2PVT(_mv22,_phase);
	[_mv22,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_mv22 animate ["ramp_top",_phase];
	_mv22 animate ["ramp_bottom",_phase];
	};
};
if (_action=="ramp_top")exitWith{
	[_mv22,_phase] spawn {
	PARAMS2PVT(_mv22,_phase);
	[_mv22,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_mv22 animate ["ramp_top",_phase];
	};
};
if (_action=="ramp_bottom")exitWith{
	[_mv22,_phase] spawn {
	PARAMS2PVT(_mv22,_phase);
	[_mv22,"gdrazatvor",30,50] call fnc_alertSoundRE;
	sleep 1;
	_mv22 animate ["ramp_bottom",_phase];
	};
};
if (_action=="fold")exitWith{
	[_mv22,_phase] spawn {
	PARAMS2PVT(_mv22,_phase);
	[_mv22,"gdrazatvor2",50,100] call fnc_alertSoundRE;
	sleep 2;
	[_mv22,_phase] call mv22_pack;
	};
};