/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_victim","_DS_slap_them","_sound","_punishment","_Vname"];
_victim=THIS0;
_punishment=THIS1;
_Vname=name _victim;
if(_Vname==name player)exitWith{};
pvp_unconscious = true;	
//В технике или нет
if (player != vehicle player) then {
	titleText["","WHITE OUT",1];  
	titleText["","WHITE IN",1]; 
} else {
	_DS_slap_them = {_randomnr = [2,-1] call BIS_fnc_selectRandom;(vehicle player) SetVelocity [_randomnr * random (4) * cos getdir (vehicle player), _randomnr * random (4) * cos getdir (vehicle player), random (4)];};
	[] spawn _DS_slap_them;
	[player,100,true,(getPosATL player)] spawn player_alertZombies;
	if (_punishment == "YES") then {
		[player,18] call fnc_usec_damageUnconscious;
		[objNull, player, rSWITCHMOVE, "CivilSitting03"] call RE;
	};
};

//Последствия пвп
taskHint ['!!! ВНИМАНИЕ !!!', [1,0,0.1,1], 'taskFailed'];
titleText [format["Вы пытаетесь убить игрока: %1. Это NO PVP(PVE) сервер! \n Убийство игроков ЗАПРЕЩЕНО!",_Vname], "PLAIN",2];
if (_punishment=="YES")then{
	[player,-2000] call player_humanityChange;
	r_player_blood = r_player_blood - 5000;
	PVDZE_send = [player,"nopvpmsg",[name player,name _victim,"Игрок: %1 пытается убить игрока: %2. Сделайте скриншот(нажмите F12). Обязательно сообщите администрации!"]];
	publicVariableServer "PVDZE_send";
	player setVariable["PvPStatus",_Vname,true];		
};
[60,15] call fnc_usec_pitchWhine;
_sound=['z_scream_3','z_scream_4'] call BIS_fnc_selectRandom;
[nil,player,rSAY,[_sound,100]] call RE;
systemChat format ["Вы пытаетесь убить игрока %1. Это NO PVP(PVE) сервер! Убийство игроков ЗАПРЕЩЕНО!",_Vname];
player setVariable["medForceUpdate",true];