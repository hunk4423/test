/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_upgrade"];

if ([player,10000] call SC_fnc_removeCoins) then {
	_upgrade=VehicleToPaint getVariable ["Upgrade",[0,0,0,0]];
#ifdef _ORIGINS
	if((typeOf VehicleToPaint) in OriUpgVeh)then{
		PVDZE_veh_Colour = [VehicleToPaint,"0","0",dayz_playerUID,dayz_playerName,_upgrade];
		publicVariableServer "PVDZE_veh_Colour";
	} else {
#endif
		PVDZE_veh_Colour = [VehicleToPaint,"0","0",dayz_playerUID,dayz_playerName];
		publicVariableServer "PVDZE_veh_Colour";
#ifdef _ORIGINS
	};
#endif
	titleText ["Цвет техники изменен на стандартный. Расцветка полностью обновится после рестарта.","PLAIN DOWN"];
} else {
	titleText ["Не достаточно средств для перекраски техники.","PLAIN DOWN"];
};