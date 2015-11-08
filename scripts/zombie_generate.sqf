/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private["_speed","_lootTypeCfg","_position","_doLoiter","_unitTypes","_maxControlledZombies","_cantSee","_isok","_zPos","_fov","_safeDistance","_farDistance","_xasl","_ed","_deg","_type","_radius","_method","_agent","_loot","_array","_lootType","_index","_weights","_loot_count","_favStance"];

_position = THIS0;
_doLoiter = THIS1; // wander around
_unitTypes = THIS2; // class of wanted models
_maxControlledZombies = round(dayz_maxLocalZombies);

_cantSee = {
	PVT1(_isok);

	_isok = true;
	_zPos = +(_this select 0);
	if (count _zPos < 3) exitWith {
		//diag_log format["%1::_cantSee illegal pos %2", __FILE__, _zPos];
		false
	};
	_zPos = ATLtoASL _zPos;
	_fov = _this select 1; // players half field of view
	_safeDistance = _this select 2; // minimum distance. closer is wrong
	_farDistance = _this select 3; // distance further we won't check
	_zPos set [2, (_zPos select 2) + 1.7];
	{
		_xasl = getPosASL _x;
		if (_xasl distance _zPos < _farDistance) then {
			if (_xasl distance _zPos < _safeDistance) then {
				_isok = false;
			}
			else {
				_eye = eyePos _x; // ASL
				_ed = eyeDirection _x;
				_ed = (_ed select 0) atan2 (_ed select 1);
				_deg = [_xasl, _zPos] call BIS_fnc_dirTo;
				_deg = (_deg - _ed + 720) % 360;
				if (_deg > 180) then { _deg = _deg - 360; };
				if ((abs(_deg) < _fov) && {( // in right angle sector?
						(!(terrainIntersectASL [_zPos, _eye]) // no terrain between?
						&& {(!(lineIntersects [_zPos, _eye]))}) // && no object between?
					)}) then {
					_isok = false;
				};
			};
		};
		if (!_isok) exitWith {false};
	} count playableUnits;

	_isok
};

if ((dayz_spawnZombies < _maxControlledZombies) && (dayz_CurrentNearByZombies < dayz_maxNearByZombies) && (dayz_currentGlobalZombies < dayz_maxGlobalZeds)) then {
	if ([_position, dayz_cantseefov, 10, dayz_cantseeDist] call _cantSee) then {
		//Check if anyone close
		while{true}do{
			if(([_position,25] call fnc_getNearPlayersCount)==0)exitWith{};
			_position=[_position,10,30,5,0,0,0] call BIS_fnc_findSafePos;
		};
		if (surfaceIsWater _position) exitwith {};

		//Add zeds if unitTypes equals 0
		if (count _unitTypes == 0) then {
			if (DZE_MissionLootTable) then {
				_unitTypes = []+ getArray (missionConfigFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
			} else {
				_unitTypes = []+ getArray (configFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
			};
		};

		// lets create an agent
		_type = _unitTypes call BIS_fnc_selectRandom;
		_radius = 5;
		_method = "NONE";
		if (_doLoiter) then {
			_radius = 40;
			_method = "CAN_COLLIDE";
		};

		//Check if point is in water
		if (surfaceIsWater _position) exitwith {  };

		_agent = createAgent [_type, _position, [], _radius, _method];
		sleep 0.03;
		//add to global counter
		dayz_spawnZombies = dayz_spawnZombies + 1;

		//Add some loot
		_loot = "";
		_array = [];
		if (RND(50)) then {
			_lootType = configFile >> "CfgVehicles" >> _type >> "zombieLoot";
			if (isText _lootType) then {
				if (DZE_MissionLootTable) then {
					_lootTypeCfg = getArray (missionConfigFile >> "CfgLoot" >> getText(_lootType));
				} else {
					_lootTypeCfg = getArray (configFile >> "CfgLoot" >> getText(_lootType));
				};
				
				_array = [];
				{
					_array set [count _array, _x select 0]
				} count _lootTypeCfg;
				if (count _array > 0) then {
					_index = dayz_CLBase find getText(_lootType);
					_weights = dayz_CLChances select _index;
					_loot = _array select (_weights select (floor(random (count _weights))));
					if(!isNil "_array") then {
						if (DZE_MissionLootTable) then {
						  _loot_count =	getNumber(missionConfigFile >> "CfgMagazines" >> _loot >> "count");
						} else {
						  _loot_count =	getNumber(configFile >> "CfgMagazines" >> _loot >> "count");
						};
						if(_loot_count>1) then {
							_agent addMagazine [_loot, ceil(random _loot_count)];
						} else {
						_agent addMagazine _loot;
						};
					};
				};
			};
		};
		_agent setVariable["agentObject",_agent];

		if (!isNull _agent) then {
			_agent setDir random 360;
			//_agent setPosATL _position;
			sleep 0.001;

			_position = getPosATL _agent;

			_favStance = (
				switch ceil(random(3^0.5)^2) do {
					//case 3: {"DOWN"}; // prone
					case 2: {"Middle"}; // Kneel
					default {"UP"} // stand-up
				}
			);
			_agent setUnitPos _favStance;

			_agent setVariable ["stance", _favStance];
			_agent setVariable ["BaseLocation", _position];
			_agent setVariable ["doLoiter", true]; // true: Z will be wandering, false: stay still
			_agent setVariable ["myDest", _position];
			_agent setVariable ["newDest", _position];
			[_agent, _position] call zombie_loiter;
		};
		//add to monitor
		//dayz_zedMonitor set [count dayz_zedMonitor, _agent];

		//Disable simulation
		PVDZE_Server_Simulation = [_agent, false];
		publicVariableServer "PVDZE_Server_Simulation";

		//Start behavior
		if(RND(Z_SPEED_CHANCE))then{_speed=10;}else{_speed=2;};
		_id=[_position,_agent,_speed] EXECFSM_SCRIPT(zombie_agent.fsm);
	};
};
