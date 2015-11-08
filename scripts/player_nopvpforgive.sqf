/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_pvpstatus"];
_pvpstatus=GETPVAR(PvPStatus,nil);
if(isNil "_pvpstatus")exitWith{systemChat format "Время вышло.";};	

[2500] spawn fnc_usec_addBlood;
[player,1000] call player_humanityChange;
player setVariable["medForceUpdate",true];
player setVariable ["NORRN_unconscious", false, true];
player setVariable ["USEC_isCardiac",false,true];
player setVariable["PvPStatus",nil,true];	

PVDZE_send=[player,"nopvpmsg",[name THIS0,name player,"Игрок %1 простил игрока %2 за попытку убийства."]];
publicVariableServer "PVDZE_send";