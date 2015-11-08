/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_unit"];
disableserialization;
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
_unit=(THIS3) select 0;

call fnc_usec_medic_removeActions;
r_action = false;
(findDisplay 106)closeDisplay 1;

playsound "epipans";
if(NotInVeh(player))then{
	player playActionNow "PutDown";
};

if(([player,"ItemMorphine"] call BIS_fnc_invRemove)==1)then{
	if(_unit==player)then{
		["morphine"] call fnc_usec_SplintWound;
	}else{
		[player,10] call player_humanityChange;
		sleep 1;
		PVDZE_send=[_unit,"Morphine",[_unit,player]];
		publicVariableServer "PVDZE_send";
	};
};
