/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_inVehicle","_onLadder","_finished","_canDo","_finishedTime","_posplr","_dirplr","_object"];

_inVehicle = (vehicle player != player);
_onLadder =	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder and !_inVehicle);
if (!_canDo) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};

if !(("PartGeneric" in magazines player) && ("ItemToolbox" in items player))exitWith{cutText ["Необходимы запчасти и инструменты","PLAIN DOWN"];};

CheckActionInProgress(MSG_BUSY);

player removeWeapon "ItemToolbox";
player removeMagazine "PartGeneric";

[player,"repair",0,false] call dayz_zombieSpeak;
[player,50,true,(getPosATL player)] spawn player_alertZombies;
[1,1] call dayz_HungerThirst;
ANIMATION_MEDIC(false);

if (_finished) then {
	_object = "MMT_Civ" createVehicle (position player);
	_object setVariable ["Mission","1",true];
//	_object attachto [player,[0.0,3.0,1.1]];
	PVDZE_veh_Init = _object;
	publicVariable "PVDZE_veh_Init";
//	sleep 2;
//	detach _object;
	player reveal _object;
	cutText [format["Вы использовали набор инструментов и запчасти чтобы собрать велосипед"], "PLAIN DOWN"];
} else {
	r_interrupt = false;
	player addWeapon "ItemToolbox";
	player addMagazine "PartGeneric";
};
DZE_ActionInProgress=false;
