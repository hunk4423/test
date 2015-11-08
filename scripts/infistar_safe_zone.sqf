/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
/*
   by: http://infiSTAR.de || http://DayzAntiHack.com
   *updated on 20.07.2014
*/
#include "defines.h"

// This will log to your .rpt when a player enters or leaves a SafeZone! (only works with infiSTAR.de Admintools / AntiHack)
//#define LOG_EnterLeave

waitUntil { !isNil 'dayz_animalCheck' };
inSafezone = false;
[] spawn {
	private ["_veh","_r","_state"];
	_startSafeZone = {
		if (GETPVAR(humanity,0)>=10000 || isPlayerSpawn)then{
			systemChat "Годмод включен.";
		} else {
			taskHint ['Годмод включен', [0,1,0,1], 'taskDone'];
			systemChat "Годмод включен.";
		};
#ifdef MSG_DEL_VEH		
		systemChat "Въезд на территорию рынка запрещен, техника будет удалена.";
#endif
#ifdef LOG_EnterLeave
		PVDZE_send = [player,'SafeZoneState',[1]];
		publicVariableServer 'PVDZE_send';
#endif
		SETPVARS(inSafeZone,true);
		fnc_usec_damageHandler = {};
		player removeAllEventHandlers 'handleDamage';
		player addEventHandler ['handleDamage', {false}];
		player allowDamage false;
		player setcaptive true;
		_veh = vehicle player;
		if (player != _veh) then {
			SETVARS(_veh,inSafeZone,true);
			if (GetTow(_veh))then{
				_veh = GetVehInTow(_veh);
				if (!isNull(_veh))then{
					SETVARS(_veh,inSafeZone,true);
				};
			};
		};
	};
	_endSafeZone = {
		PVT(_end);

		if (str fnc_usec_damageHandler == '{}') then {
			if (GETPVAR(humanity,0)>=10000) then {
				systemChat "Годмод выключен";
			} else {
				taskHint ['Годмод выключен', [1,0,0.1,1], 'taskFailed'];
			};
		};

#ifdef LOG_EnterLeave
		PVDZE_send = [player,'SafeZoneState',[0]];
		publicVariableServer 'PVDZE_send';
#endif
		SETPVARS(inSafeZone,false);
		player setcaptive false;

		_veh = vehicle player;
		if (player != _veh) then {
			SETVARS(_veh,inSafeZone,false);
			if (GetTow(_veh))then{
				_veh = GetVehInTow(_veh);
				if (!isNull(_veh))then{
					SETVARS(_veh,inSafeZone,false);
				};
			};
		};

		_end = false;
		if (isNil 'gmadmin') then {
			_end = true;
		}else{
			if (gmadmin == 0) then {
				_end = true;
			};
		};
		if (_end) then {
			player allowDamage true;
			fnc_usec_damageHandler = COMPILE_SCRIPT_FILE(fn_damageHandler.sqf);
			player removeAllEventHandlers 'HandleDamage';
			player addeventhandler ['HandleDamage',{_this call fnc_usec_damageHandler;} ];
		};
	};
	while {true} do {
		_state = false;
		_obj = vehicle player;

		if (isNil 'inSafeZone') then { inSafeZone = false; } else { if (typename inSafeZone != 'BOOL') then { inSafeZone = false; }; };
		if (isNil 'canbuild') then { canbuild = true; } else { if (typename canbuild != 'BOOL') then { canbuild = true; }; };

		_state = [_obj] call fnc_inSafeZone;

		if (isPlayerSpawn) then {_state = true;};

		if ((_state && !inSafeZone)||(!_state && inSafeZone)) then {
			inSafeZone = _state;
			if (_state)then{
				call _startSafeZone;
			}else{
				call _endSafeZone;
			};
		};
		if (inSafeZone)then{
			{
				if (!isNull _x) then {
					if !(isPlayer _x) then {
						deletevehicle _x;
					};
				};
			} count (_obj nearEntities ['zZombie_Base',15]);

			{
				if ((!isNull group _x) && !(isPlayer _x)) then {
					deleteVehicle _x;
				};
			} count (player nearEntities [AI_BanditTypes,100]);
		};
		Sleep 2;
	};
};
