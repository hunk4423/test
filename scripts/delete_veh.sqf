/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT(_vehicle);
CheckActionInProgress(MSG_BUSY);
player removeAction s_player_delTrashVeh;s_player_delTrashVeh=-1;

_vehicle = _this select 3; 
if ((count (crew _vehicle)) != 0)exitWith{BreakActionInProgress("Нельзя удалить технику, поскольку в ней люди!")};
if !(typeOf _vehicle in TrashVeh)exitWith{BreakActionInProgress("Этот объект нельзя удалить!")};
if(([_vehicle,7] call fnc_getNearPlayersCount) >0)exitWith{BreakActionInProgress("Нельзя удалять в присутствии других игроков!")};

//Удалить из базы
[GetObjID(_vehicle),GetObjUID(_vehicle),player] call fnc_serverDeleteObject;
deleteVehicle _vehicle;

[player, 100] call SC_fnc_addCoins;
systemChat "100р. добавлено на счет";
BreakActionInProgress("Техника удалена.");