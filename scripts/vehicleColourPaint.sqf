/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_colour","_colour2","_upgrade"];
if ([player,ColourPrice] call SC_fnc_removeCoins) then {
	_colour = ""+str((sliderPosition 5700) / 10)+","+str((sliderPosition 5701) / 10)+","+str((sliderPosition 5702) / 10)+",1";
	_colour2 = ""+str((sliderPosition 6700) / 10)+","+str((sliderPosition 6701) / 10)+","+str((sliderPosition 6702) / 10)+",1";
	_upgrade=VehicleToPaint getVariable ["Upgrade",[0,0,0,0]];

#ifdef _ORIGINS
	if((typeOf VehicleToPaint) in OriUpgVeh)then{
		PVDZE_veh_Colour = [VehicleToPaint,_colour,_colour2,dayz_playerUID,dayz_playerName,_upgrade];
		publicVariableServer "PVDZE_veh_Colour";
	}else{
#endif
		PVDZE_veh_Colour = [VehicleToPaint,_colour,_colour2,dayz_playerUID,dayz_playerName];
		publicVariableServer "PVDZE_veh_Colour";
#ifdef _ORIGINS
	};
#endif
	titleText ["Техника перекрашена. Подождите, пока обновятся текстуры.","PLAIN DOWN"];
} else {
	titleText ["Не достаточно средств для перекраски техники.","PLAIN DOWN"];
};
