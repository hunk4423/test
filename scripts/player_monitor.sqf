/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
if (isServer) then {
	waitUntil{dayz_preloadFinished};
};
_id = [] EXECFSM_SCRIPT(player_monitor.fsm);
if (DZE_R3F_WEIGHT) then {
	_void = [] execVM "\z\addons\dayz_code\external\R3F_Realism\R3F_Realism_Init.sqf";
};