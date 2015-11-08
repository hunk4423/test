/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_started","_finished","_animState","_isMedic","_id","_unit","_display"];

disableserialization;
if (r_player_unconscious) exitWith {titleText ["Нельзя перевязать себя находясь в обмороке.", "PLAIN DOWN", 0.5];};

_unit = (_this select 3) select 0;

call fnc_usec_medic_removeActions;
r_action = false;
[player,"bandage",0,false] call dayz_zombieSpeak;

if (vehicle player == player) then {
	//not in a vehicle
	player playActionNow "Medic";
};

[1,1] call dayz_HungerThirst;

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;

while {r_doLoop} do {
	_animState = animationState player;
	_isMedic = ["medic",_animState] call fnc_inString;
	if (_isMedic) then {
		_started = true;
	};
	if (_started && !_isMedic) then {
		r_doLoop = false;
		_finished = true;
	};
	if (r_interrupt) then {
		r_doLoop = false;
	};
	if (vehicle player != player) then {
		sleep 3;
		r_doLoop = false;
		_finished = true;
	};
	sleep 0.1;
};
r_doLoop = false;

if (_finished) then {

	_num_removed = ([player,"ItemBandage"] call BIS_fnc_invRemove);
	if(_num_removed == 1) then {

		if (vehicle player != player) then {
			_display = findDisplay 106;
			_display closeDisplay 0;
		};	

		if ((_unit == player) || (vehicle player != player)) then {
			//Self Healing
			_id = [player,player] execVM "\z\addons\dayz_code\medical\publicEH\medBandaged.sqf";
			dayz_sourceBleeding =	objNull;
		} else {
			/* PVS/PVC - Skaronator */
			PVDZE_send = [_unit,"Bandage",[_unit,player]];
			publicVariableServer "PVDZE_send";
			[player,10] call player_humanityChange;
		};

		{_unit setVariable[_x,false,true];} count USEC_woundHit;
		_unit setVariable ["USEC_injured",false,true];

	};
if ((hasGutsOnHim) and !(r_player_infected)) then {
	if (RND(80)) then {
		r_player_infected = true;
		player setVariable["USEC_infected",true,true];
		cutText ["Кровь зомби попала на рану, я заражен!", "PLAIN DOWN"];
	};
};

} else {
	r_interrupt = false;
	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
	};
};

 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //