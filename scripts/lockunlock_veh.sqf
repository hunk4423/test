/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private["_array","_vehicle","_state","_key"];
_array=THIS3;
EXPLODE2(_array,_vehicle,_state);
CheckActionInProgressLocalize(str_epoch_player_37);
PVDZE_veh_Lock=[_vehicle,_state];
if(player distance _vehicle<10)then{
	if (local _vehicle)then{
		PVDZE_veh_Lock spawn local_lockUnlock
	}else{
		publicVariable "PVDZE_veh_Lock"
	};
	if(!_state)then{
		cutText [format["%1 used to unlock vehicle.",SEL2(_array)], "PLAIN"];
	};
};
DZE_ActionInProgress=false;