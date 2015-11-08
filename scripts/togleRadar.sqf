/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT(_chopper);
_chopper = THIS3;

if (AL_Hud_Cond) then {
	AL_Hud_Cond = false;
} else {
	AL_Hud_Cond = true;
};

_chopper removeAction AeroLiftHudId;
[_chopper] call fnc_togleRadarAction;