/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_uniqueid","_array","_hitpoints","_tvih","_selection","_count_ar","_part","_parts","_location","_name_veh","_messages","_object_bot","_finish_box","_veh","_x","_this","_invehicl","_started","_finished","_isRead","_animState"];
disableserialization;
call gear_ui_init;
_onLadder =     (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};
if !("ItemLetter" in magazines player) exitWith {cutText [format["Нужна газета!"], "PLAIN DOWN"]};
CheckActionInProgress(MSG_BUSY);

_invehicle = false;
closeDialog 1;

if (vehicle player != player) then {
	_invehicle = true;
};

if !(_invehicle) then {
player playActionNow "Medic";
};

[player,"document",0,false,20] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;
 
    while {r_doLoop} do {
        _animState = animationState player;
        _isRead = ["Medic", _animState] call fnc_inString;
        if (_isRead) then {
            _started = true;
        };
        if (_started and !_isRead) then {
            r_doLoop = false;
            _finished = true;
        };
        if (r_interrupt) then {
            r_doLoop = false;
        };
		if (_invehicle) then {
		sleep 6;
		r_doLoop = false;
		_finished = true;
		};
        sleep 0.1;
    };
    r_doLoop = false;
 

if (_finished) then {
	if !("ItemLetter" in magazines player) exitWith {DZE_ActionInProgress = false;cutText [format["Нужна газета!"], "PLAIN DOWN"]};
	_num_removed = ([player,"ItemLetter"] call BIS_fnc_invRemove);
	if!(_num_removed == 1) exitWith {cutText ["Ошибка!", "PLAIN DOWN"];DZE_ActionInProgress = false;}; 

	_location = [getPosATL player, 0, 1000, 0, 0, 2000, 0] call BIS_fnc_findSafePos;
	_locationAI = [_location select 0, _location select 1, 1];
	
	//Сообщения
	_messages = [
		"Эти координаты - твой шанс! Спеши!",
		"Тебе выпал шанс! Не упусти!",
		"Координаты Удачи! Проверь! ",
		"Проверь координаты и ты Удачлив и богат!",
		"Интересные координаты... Стоит проверить!"
	] call BIS_fnc_selectRandom;

	//спавним бота
	_object_bot = createAgent ["Worker3", _locationAI, [], 0, "NONE"];	

	//сообщение игроку
	_map_coord = mapGridPosition getPos _object_bot;
	titleText [_messages + "\n Запомни координату: " + _map_coord, "PLAIN DOWN", 5];
	systemChat ("Запомни координату: " + _map_coord);
	playSound "pda";

	//Техника
	_name_veh = ["UAZ_CDF", "UAZ_RU", "UAZ_INS", "Skoda", "SkodaBlue", "SkodaRed", "SkodaGreen", "datsun1_civil_1_open", "datsun1_civil_3_open", "hilux1_civil_1_open", "hilux1_civil_2_covered", "hilux1_civil_3_open", "Lada1", "Lada2", "LadaLM", "Lada1_TK_CIV_EP1", "S1203_ambulance_EP1", "SUV_Blue"] call BIS_fnc_selectRandom;

	_veh = createVehicle [_name_veh, _object_bot,[], 0, "CAN_COLLIDE"];
	_veh setVariable["Letter",true,true];
	_veh setVariable ["Mission","1",true];

	_array =[];
	_hitpoints = _veh call vehicle_getHitpoints;
	_tvih = typeOf _veh;
	{
		_selection = getText(configFile >> "cfgVehicles" >> _tvih >> "HitPoints" >> _x >> "name");
		_array set [count _array,[_selection,(0.3 +(random 0.2))]];
	} count _hitpoints;

	_count_ar = count _array;
	for "_i" from 0 to _count_ar do {
		_part = _array select _i;
		_veh setHit _part;
		_parts = [_veh,_part select 0,_part select 1];
		_parts call Vehicle_HandleDamage;
	};

	clearWeaponCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;
	_veh setFuel ((random 0.4) + 0.2); 
	PVDZE_veh_Init = _veh;
	publicVariable "PVDZE_veh_Init";

	sleep 1;
	deletevehicle _object_bot;
} else {
	r_interrupt = false;
	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		cutText ["Я еще не дочитал!", "PLAIN DOWN"];
	};
};
DZE_ActionInProgress = false;
