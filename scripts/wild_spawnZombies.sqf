/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_speed","_unitTypes","_lootType","_lootTypeCfg","_loot_count","_index","_weights","_loot","_array","_player","_doLoiter","_agent","_type","_radius","_method","_position","_isAlive","_myDest","_newDest","_id"];
_player = THIS0;

_unitTypes = [];
if (DZE_MissionLootTable) then {
	_unitTypes = []+ getArray (missionConfigFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
} else {
	_unitTypes = []+ getArray (configFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
};
_doLoiter = true;

_loot =		"";
_array =	[];
_agent =	objNull;

_type = _unitTypes call BIS_fnc_selectRandom;

//Create the Group && populate it
//diag_log ("Spawned: " + _type);
_radius = 50;
_method = "NONE";

//Check if anyone close
while{true}do{
	_position=[_player,30,100,5,0,0,0] call BIS_fnc_findSafePos;
	if(([_position,25] call fnc_getNearPlayersCount)==0)exitWith{};
};
if (surfaceIsWater _position) exitwith {};

_agent = createAgent [_type, _position, [], _radius, _method];
if (_doLoiter) then {
	//_agent setPosATL _position;
	//_agent setVariable ["doLoiter",true,true];
	_agent setDir round(random 180);
};

dayz_spawnZombies = dayz_spawnZombies + 1;

if (random 1 > 0.7) then {
	_agent setUnitPos "Middle";
};

if (isNull _agent) exitWith {
	dayz_spawnZombies = dayz_spawnZombies - 1;
};

_isAlive = alive _agent;

_myDest = getPosATL _agent;
_newDest = getPosATL _agent;
_agent setVariable ["myDest",_myDest];
_agent setVariable ["newDest",_newDest];

//Add some loot
if (RND(50)) then {
	if (DZE_MissionLootTable) then {
		_lootType = getText (missionConfigFile >> "CfgVehicles" >> _type >> "zombieLoot");
	} else {
		_lootType = getText (configFile >> "CfgVehicles" >> _type >> "zombieLoot");
	};

	if (DZE_MissionLootTable) then {
		_lootTypeCfg = getArray (missionConfigFile >> "CfgLoot" >> _lootType);
	} else {
		_lootTypeCfg = getArray (configFile >> "CfgLoot" >> _lootType);
	};
	_array = [];
	{
		_array set [count _array, _x select 0]
	} count _lootTypeCfg;
	if (count _array > 0) then {
		_index = dayz_CLBase find _lootType;
		_weights = dayz_CLChances select _index;
		_loot = _array select (_weights select (floor(random (count _weights))));
		if(!isNil "_array") then {
			if (DZE_MissionLootTable) then {
				_loot_count = getNumber(missionConfigFile >> "CfgMagazines" >> _loot >> "count");
			} else {
				_loot_count = getNumber(configFile >> "CfgMagazines" >> _loot >> "count");
			};
			if(_loot_count>1) then {
				_agent addMagazine [_loot, ceil(random _loot_count)];
			} else {
				_agent addMagazine _loot;
			};
		};
	};
};

//Start behavior
if(RND(Z_SPEED_CHANCE))then{_speed=10;}else{_speed=2;};
_id=[_position,_agent,_speed] EXECFSM_SCRIPT(zombie_agent.fsm);