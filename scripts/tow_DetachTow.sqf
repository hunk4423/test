/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_vehicle","_started","_finished","_animState","_isMedic","_vehicleNameText","_towTruckNameText","_towTruck","_hasToolbox"];

if(DZE_ActionInProgress)exitWith{BreakActionInProgressLocalize(str_epoch_player_96)};

player removeAction s_player_towing;s_player_towing=-1;

// Tow Truck
_towTruck=THIS3;
_towTruckNameText=[_towTruck]call object_getNameWithComment;

// exit if no vehicle is in tow.
if(!GetTow(_towTruck))exitWith{BreakActionInProgress("Ошибка! Буксировка не активна!")};
// Select the vehicle currently in tow
_vehicle = GetVehInTow(_towTruck);

if (!(isNull _vehicle))then{
	_vehicleNameText=[_vehicle]call object_getNameWithComment;
	_finished=false;
	_hasToolbox="ItemToolbox" in (items player);
	
	// Check the player has a toolbox
	if(!_hasToolbox)exitWith{cutText ["Необходим 'Набор инструментов'.","PLAIN DOWN"]};

	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,20,true,(getPosATL player)] spawn player_alertZombies; // Alert nearby zombies
	[1,1] call dayz_HungerThirst; // Use some hunger and thirst to perform the action
	ANIMATION_MEDIC(false);

	if(_finished)then{
		_pos = getPosATL _vehicle;
		_pos set [2,SEL2(_pos)+0.1];
		[_towTruck]call fnc_resetTow;
		_vehicle setPos _pos;
		sleep 2;
		_vehicle setPos _pos;
		PVDZE_veh_Update = [_vehicle, "forcepos"];publicVariableServer "PVDZE_veh_Update";
		cutText [format["%1 отцеплена(а) от %2.",_vehicleNameText,_towTruckNameText],"PLAIN DOWN"];
	}else{
		r_interrupt=false;
		cutText [format["Отцепка %1 и %2 отменена.",_vehicleNameText,_towTruckNameText],"PLAIN DOWN"];
	};
}else{[_towTruck]call fnc_resetTow};

DZE_ActionInProgress = false;
