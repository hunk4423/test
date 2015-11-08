/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT3(_id,_unit,_num_removed);

disableserialization;

_unit = (THIS3) select 0;

call fnc_usec_medic_removeActions;
r_action = false;

if (vehicle player == player) then {player playActionNow "PutDown"; playsound "paink_use";};
sleep 3; 


_num_removed = ([player,"ItemPainkiller"] call BIS_fnc_invRemove);
if(_num_removed == 1) then {
	_display = findDisplay 106;
	_display closeDisplay 0;

	if ((_unit == player) or (vehicle player != player)) then {
		_id = [player,player] EXECVM_SCRIPT(medPainkiller.sqf);
	} else {
		[player,10] call player_humanityChange;
		sleep 1;
		PVDZE_send = [_unit,"Painkiller",[_unit,player]];
		publicVariableServer "PVDZE_send";
	};
};
