/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT3(_num_removed,_hasMeds,_med);

if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
player playActionNow "PutDown";
playsound "paink_use";

_num_removed = ([player,"ItemAntibiotic"] call BIS_fnc_invRemove);
if!(_num_removed == 1) exitWith {cutText ["Ошибка", "PLAIN DOWN"]};

//remove infection
r_player_infected = false;
player setVariable["USEC_infected",false,true];

dayz_thirst = dayz_thirst + 250;
[] EXECVM_SCRIPT(abio.sqf);
