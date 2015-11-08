 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //
private ["_num_removed","_contdis","_invehicle","_animState","_finished","_started"];
disableserialization;
call gear_ui_init;
_onLadder =     (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};
if !("ItemRadio" in items player) exitWith {cutText [format["Нужно радио!"], "PLAIN DOWN"]};
if !("ItemToolbox" in items player) exitWith {cutText [format["Необходимы Инструменты"], "PLAIN DOWN"]};
if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
DZE_ActionInProgress = true;

_invehicle = false;
closeDialog 1;


	if (vehicle player != player) then {
		_invehicle = true;
	};
	if (_invehicle) exitWith {cutText [format["Нельзя крафтить в технике!"], "PLAIN DOWN"];DZE_ActionInProgress = false;};
	player playActionNow "Medic";

	[player,"repair",0,false,20] call dayz_zombieSpeak;
	[player,20,true,(getPosATL player)] spawn player_alertZombies;

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
		if (_invehicle) exitWith {cutText [format["Нельзя крафтить в технике!"], "PLAIN DOWN"];};
        sleep 0.1;
    };
    r_doLoop = false;
 

if (_finished) then {
		_num_removed = ([player,"ItemRadio"] call BIS_fnc_invRemove);
		if!(_num_removed == 1) exitWith {cutText ["Ошибка", "PLAIN DOWN"];};
		_contdis = 0;
		
		{
			if (alive _x) then {
				_contdis = _contdis + 1;
			};		
		} forEach (nearestObjects [player, AI_BanditTypes, 500]);
		
		if (_contdis > 0) then {
			cutText [format["В районе 500м обнаружены боты. Колличество сигналов: %1",_contdis], "PLAIN DOWN"];
			systemChat format ["В районе 500м обнаружены боты. Колличество сигналов: %1",_contdis];
		} else {
			cutText [format["В районе 500м боты не обнаружены."], "PLAIN DOWN"];
			systemChat "В районе 500м боты не обнаружены.";
		};
	} else {
		r_interrupt = false;
		if (vehicle player == player) then {
			[objNull, player, rSwitchMove,""] call RE;
			player playActionNow "stop";
			cutText ["Я не закончил крафт!", "PLAIN DOWN"];
		};
	};
DZE_ActionInProgress = false;
 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //