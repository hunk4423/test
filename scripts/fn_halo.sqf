/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
#define V_LIMIT 0.1
#define H_LIMIT 0.3

private ["_unit","_parachute","_dir","_pos","_brightness","_destination","_vel","_alt"];

scriptName "fn_HALO.sqf";
sleep 0.01;

//--- HALO -
if (typename _this == "OBJECT") then {
	_unit = _this;

	//--- Eject!
	waituntil {(vehicle _unit) iskindof "ParachuteBase" || !isnil {_unit getvariable "bis_fnc_halo_now"}};
	if (!local _unit)exitwith{};
 
	//--- Delete parachute
	_parachute = vehicle _unit;
	if (_parachute != _unit)then{deletevehicle _parachute};

	if (isNil "HaloAltimeter")then{
		[] EXECVM_SCRIPT(altimeter.sqf);
	};

	//--- Init
	_dir = ([[0,0,0],velocity _unit] call bis_fnc_dirto);
	_unit setdir _dir;
	[objNull, player, rSwitchMove,"HaloFreeFall_non"] call RE;
	player switchmove "HaloFreeFall_non";

	//--- Key controls
	if (_unit == player)then{
		//--- PLAYER --

		_brightness = 0.99;
		_pos = [player] call FNC_GetPos;
		bis_fnc_halo_clouds = "#particlesource" createVehicleLocal _pos;
		bis_fnc_halo_clouds setParticleParams [
			/* 00 */		["\Ca\Data\ParticleEffects\Universal\Universal", 16, 12, 13, 0],
			/* 01 */		"",
			/* 02 */		"Billboard",
			/* 03 */		1,
			/* 04 */		3,
			/* 05 */		[0,0,-200],
			/* 06 */		wind,
			/* 07 */		0,
			/* 08 */		1.275,
			/* 09 */		1,
			/* 10 */		0,
			/* 11 */		[100],
			/* 12 */		[[_brightness,_brightness,_brightness,0],[_brightness,_brightness,_brightness,0.01],[_brightness,_brightness,_brightness,0.10],[_brightness,_brightness,_brightness,0]],
			/* 13 */		[1000],
			/* 14 */		0,
			/* 15 */		0,
			/* 16 */		"",
			/* 17 */		"",
			/* 18 */		player
		];
		bis_fnc_halo_clouds setParticleRandom [0, [100, 100, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 1];
		bis_fnc_halo_clouds setParticleCircle [00, [00, 00, 00]];
		bis_fnc_halo_clouds setDropInterval (0.4 - (0.3 * overcast));

		//--- Effects
		bis_fnc_halo_ppRadialBlur = ppeffectcreate ["RadialBlur",464];
		bis_fnc_halo_ppRadialBlur ppEffectAdjust [0.01,0.01,0.3,0.3];
		bis_fnc_halo_ppRadialBlur ppEffectCommit 0.01;
		bis_fnc_halo_ppRadialBlur ppEffectEnable true ;
		bis_fnc_halo_soundLoop = time;
		playsound "BIS_HALO_Flapping";

		bis_fnc_halo_action = _unit addaction [localize "STR_HALO_OPEN_CHUTE",SCRIPT_FILE(fn_halo.sqf),[],1,true,true,"Eject"];

		bis_fnc_halo_keydown = {
			private "_key";
			_key = _this select 1;

			//--- Forward
			//if (_key in (actionkeys 'HeliForward')) then {
			if (_key in (actionkeys 'MoveForward')) exitWith {
				if (bis_fnc_halo_vel < +bis_fnc_halo_velLimit) then {bis_fnc_halo_vel = bis_fnc_halo_vel + bis_fnc_halo_velAdd};
			};

			//--- Backward
			//if (_key in (actionkeys 'HeliBack')) then {
			if (_key in (actionkeys 'MoveBack')) exitWith {
				if (bis_fnc_halo_vel > -bis_fnc_halo_velLimit) then {bis_fnc_halo_vel = bis_fnc_halo_vel - bis_fnc_halo_velAdd};
			};

			//--- Left
			//if (_key in (actionkeys 'HeliCyclicLeft')) then {
			if (_key in (actionkeys 'TurnLeft')) exitWith {
				if (bis_fnc_halo_dir > -bis_fnc_halo_dirLimit) then {bis_fnc_halo_dir = bis_fnc_halo_dir - bis_fnc_halo_dirAdd};
			};
 
			//--- Right
			//if (_key in (actionkeys 'HeliCyclicRight')) then {
			if (_key in (actionkeys 'TurnRight')) exitWith {
				if (bis_fnc_halo_dir < +bis_fnc_halo_dirLimit) then {bis_fnc_halo_dir = bis_fnc_halo_dir + bis_fnc_halo_dirAdd};
			};                        

			//--- Eject
			if (_key == 0x13) exitWith {
				[player] spawn bis_fnc_halo;
			};
		};
		bis_fnc_halo_keydown_eh = (finddisplay 46) displayAddEventHandler ["keyDown","_this call bis_fnc_halo_keydown"];

		//--- Loop
		bis_fnc_halo_vel = 0;
		bis_fnc_halo_velLimit = 0.2;
		bis_fnc_halo_velAdd = 0.03;
		bis_fnc_halo_dir = 0;
		bis_fnc_halo_dirLimit = 1;
		bis_fnc_halo_dirAdd = 0.06;

		[] spawn {
			private ["_time","_fpsCoef","_dir","_vel","_anim","_v","_h"];
			_time = time - 0.1;
			while {alive player && vehicle player == player && isnil {player getvariable "bis_fnc_halo_terminate"}} do {
				//--- FPS counter
				_fpsCoef = ((time - _time) * 60) / acctime; //Script is optimized for 60 FPS
				_time = time;
				bis_fnc_halo_velLimit = 0.2 * _fpsCoef;
				bis_fnc_halo_velAdd = 0.03 * _fpsCoef;
				bis_fnc_halo_dirLimit = 1 * _fpsCoef;
				bis_fnc_halo_dirAdd = 0.06 * _fpsCoef;

				//--- Dir
				bis_fnc_halo_dir = bis_fnc_halo_dir * 0.98;
				_dir = direction player + bis_fnc_halo_dir;
				player setdir _dir;
 
				//--- Velocity
				_vel = velocity player;
				bis_fnc_halo_vel = bis_fnc_halo_vel * 0.96;
				player setvelocity [
					(_vel select 0) + (sin _dir * bis_fnc_halo_vel),
					(_vel select 1) + (cos _dir * bis_fnc_halo_vel),
					(_vel select 2)
				];

				//--- Animation system
				_anim = "HaloFreeFall_non";
				_v = bis_fnc_halo_vel;
				_h = bis_fnc_halo_dir;

				if ((abs _v) > V_LIMIT || (abs _h) > H_LIMIT)then{
					_vAnim = "";
					if (_v > +V_LIMIT)then{_vAnim="F"};
					if (_v < -V_LIMIT)then{_vAnim="B"};
					_hAnim = "";
					if (_h>+H_LIMIT) then {_hAnim="R"};
					if (_h<-H_LIMIT) then {_hAnim="L"};
					_anim="HaloFreeFall_"+_vAnim+_hAnim;
				};

				player playmovenow _anim;

				//--- Sound
				if ((time - bis_fnc_halo_soundLoop) > 4.5) then {
					playsound "BIS_HALO_Flapping";
					bis_fnc_halo_soundLoop = time;
				};

				//--- Effects
				/*
				bis_fnc_halo_ppRadialBlur ppEffectAdjust [0.02,0.02,0.3 - (bis_fnc_halo_vel/7)/_fpsCoef,0.3 - (bis_fnc_halo_vel/7)/_fpsCoef];
				bis_fnc_halo_ppRadialBlur ppEffectCommit 0.01;
				*/
				sleep 0.01;
			};
			//--- End
			player removeaction bis_fnc_halo_action;
			(finddisplay 46) displayremoveeventhandler ["keydown",bis_fnc_halo_keydown_eh];
			// ppeffectdestroy bis_fnc_halo_ppRadialBlur;
			deletevehicle bis_fnc_halo_clouds;

			bis_fnc_halo_clouds = nil;
			bis_fnc_halo_vel = nil;
			bis_fnc_halo_velLimit = nil;
			bis_fnc_halo_velAdd = nil;
			bis_fnc_halo_dir = nil;
			bis_fnc_halo_dirLimit = nil;
			bis_fnc_halo_dirAdd = nil;
			bis_fnc_halo_action = nil;
			bis_fnc_halo_keydown = nil;
			bis_fnc_halo_keydown_eh = nil;

			if (!alive player) then {
				[objNull, player, rSwitchMove,"adthppnemstpsraswrfldnon_1"] call RE;
				player switchmove "adthppnemstpsraswrfldnon_1";
				player setvelocity [0,0,0];
			};
		};
	} else {
		//--- AI ----
		while {(([_unit] call FNC_GetPos) select 2) > 100} do {
			_destination = expecteddestination _unit select 0;
			_pos = [_unit] call FNC_GetPos;
			if ((_destination distance [(_pos select 0),(_pos select 1),0]) > 10) then {
				_vel = velocity _unit;
				_dir = [_unit,_destination] call bis_fnc_dirto;
				if (player distance _unit > 500) then {
					_unit setdir _dir;
				};
				_unit setvelocity [
					(_vel select 0) + (sin _dir * 0.2),
					(_vel select 1) + (cos _dir * 0.2),
					(_vel select 2)
				];
			};
			sleep 0.01;
		};

		//--- Open
		[_unit] spawn bis_fnc_halo;
	};
};

//--- PARA -
if (typename _this == typename []) then {
	_unit = _this select 0;
	if (!local _unit) exitwith {};

	//--- Free fall
	if (count _this == 2) exitwith {
		_alt = _this select 1;
		_pos = [_unit] call FNC_GetPos;
		_unit setpos [(_pos select 0),(_pos select 1),_alt];
		_unit setvariable ["bis_fnc_halo_now",true];
		_unit spawn bis_fnc_halo;
	};
	//-----

	_parachute = objnull;
	_vel = [];
	_pos = [_unit] call FNC_GetPos;
	_parachute = createVehicle ["ParachuteWest", _pos, [], 0, "CAN_COLLIDE"];
	//_parachute = "BIS_Steerable_Parachute" createVehicle position _unit;
	_parachute setpos _pos;
	_parachute setdir direction _unit;
	_vel = velocity _unit;
	_unit moveindriver _parachute;
	//_unit moveingunner _parachute;
	_parachute lock false;

	bis_fnc_halo_para_dirAbs = direction _parachute;

	//--- Key controls
	if (_unit == player) then {
		_parachute setvelocity [(_vel select 0),(_vel select 1),(_vel select 2)*1];

		/*
		bis_fnc_halo_DynamicBlur = ppeffectcreate ["DynamicBlur",464];
		bis_fnc_halo_DynamicBlur ppEffectEnable true;
		bis_fnc_halo_DynamicBlur ppEffectAdjust [8.0];
		bis_fnc_halo_DynamicBlur ppEffectCommit 0;
		bis_fnc_halo_DynamicBlur ppEffectAdjust [0.0];
		bis_fnc_halo_DynamicBlur ppEffectCommit 1;
		*/

		bis_fnc_halo_para_vel = 0;
		bis_fnc_halo_para_velLimit = 0.5;
		bis_fnc_halo_para_velAdd = 0.01;
		bis_fnc_halo_para_dir = 0;
		bis_fnc_halo_para_dirLimit = 1.5;
		bis_fnc_halo_para_dirAdd = 0.03;

		bis_fnc_halo_para_keydown = {
			private "_key";
			_key = _this select 1;

			//--- Forward
			if (_key in (actionkeys 'MoveForward'))then{
				if (bis_fnc_halo_para_vel < +bis_fnc_halo_para_velLimit) then {bis_fnc_halo_para_vel = bis_fnc_halo_para_vel + bis_fnc_halo_para_velAdd};
			};

			//--- Backward
			if (_key in (actionkeys 'MoveBack'))then{
				if (bis_fnc_halo_para_vel > -bis_fnc_halo_para_velLimit*0) then {bis_fnc_halo_para_vel = bis_fnc_halo_para_vel - bis_fnc_halo_para_velAdd};
			};

			//--- Left
			if (_key in (actionkeys 'TurnLeft'))then{
				if (bis_fnc_halo_para_dir > -bis_fnc_halo_para_dirLimit) then {bis_fnc_halo_para_dir = bis_fnc_halo_para_dir - bis_fnc_halo_para_dirAdd};
			};

			//--- Right
			if (_key in (actionkeys 'TurnRight'))then{
				if (bis_fnc_halo_para_dir < +bis_fnc_halo_para_dirLimit) then {bis_fnc_halo_para_dir = bis_fnc_halo_para_dir + bis_fnc_halo_para_dirAdd};
			};
		};
		bis_fnc_halo_para_loop_time = time - 0.1;
		bis_fnc_halo_para_velZ = velocity _parachute select 2;
		bis_fnc_halo_para_loop = {
			private ["_fpsCoef","_parachute","_dir","_velZ"];
			if (!isnil {player getvariable "bis_fnc_halo_terminate"}) exitwith {};
			if (time == bis_fnc_halo_para_loop_time) exitwith {}; //--- FPS too high

			_parachute = vehicle player;

			//--- FPS counter
			_fpsCoef = ((time - bis_fnc_halo_para_loop_time) * 20) / acctime; //Script is optimized for 20 FPS
			bis_fnc_halo_para_loop_time = time;

			//_fpsCoef = _fpsCoef / 3;
			bis_fnc_halo_para_velLimit = 0.3 * _fpsCoef;
			bis_fnc_halo_para_velAdd = 0.002 * _fpsCoef;
			bis_fnc_halo_para_dirLimit = 1.5 * _fpsCoef;
			bis_fnc_halo_para_dirAdd = 0.03 * _fpsCoef;
 
			//--- Dir
			bis_fnc_halo_para_dir = bis_fnc_halo_para_dir * 0.98;
			bis_fnc_halo_para_dirAbs = bis_fnc_halo_para_dirAbs + bis_fnc_halo_para_dir;
			_parachute setdir bis_fnc_halo_para_dirAbs;
			_dir = direction _parachute;

			//--- Crash
			_velZ = velocity _parachute select 2;
			if ((_velZ - bis_fnc_halo_para_velZ) > 7 && (getposatl _parachute select 2) < 100) then {player setdamage 1;debuglog ["Log::::::::::::::",(_velZ - bis_fnc_halo_para_velZ)];};
			bis_fnc_halo_para_velZ = _velZ;

			//--- Pos
			_parachute setposasl [
				(getposasl _parachute select 0) + (sin _dir * (0.1 + bis_fnc_halo_para_vel)),
				(getposasl _parachute select 1) + (cos _dir * (0.1 + bis_fnc_halo_para_vel)),
				(getposasl _parachute select 2) - 0.01 - 0.1 * abs bis_fnc_halo_para_vel
			];

			[
				_parachute,
				(-bis_fnc_halo_para_vel * 75) + 0.5*(sin (time * 180)),
				(+bis_fnc_halo_para_dir * 25) + 0.5*(cos (time * 180))
			] call bis_fnc_setpitchbank;
		};

		bis_fnc_halo_para_mousemoving_eh = (finddisplay 46) displayaddeventhandler ["mousemoving","_this call bis_fnc_halo_para_loop;"];
		bis_fnc_halo_para_mouseholding_eh = (finddisplay 46) displayaddeventhandler ["mouseholding","_this call bis_fnc_halo_para_loop;"];

		sleep 4;

		// ppeffectdestroy bis_fnc_halo_DynamicBlur;
		bis_fnc_halo_para_keydown_eh = (finddisplay 46) displayaddeventhandler ["keydown","_this call bis_fnc_halo_para_keydown;"];

		//--- End
		//waituntil {vehicle player == player};
		player setvariable ["bis_fnc_halo_terminate",nil];
		waituntil {(([(vehicle player)] call FNC_GetPos) select 2) < 2 || !isnil {player getvariable "bis_fnc_halo_terminate"}};
		(finddisplay 46) displayremoveeventhandler ["keydown",bis_fnc_halo_para_keydown_eh];
		(finddisplay 46) displayremoveeventhandler ["mousemoving",bis_fnc_halo_para_mousemoving_eh];
		(finddisplay 46) displayremoveeventhandler ["mouseholding",bis_fnc_halo_para_mouseholding_eh];

		bis_fnc_halo_para_vel = nil;
		bis_fnc_halo_para_velLimit = nil;
		bis_fnc_halo_para_velAdd = nil;
		bis_fnc_halo_para_dir = nil;
		bis_fnc_halo_para_dirLimit = nil;
		bis_fnc_halo_para_dirAdd = nil;
		bis_fnc_halo_para_keydown = nil;
		bis_fnc_halo_para_loop = nil;
		bis_fnc_halo_para_keydown_eh = nil;
		bis_fnc_halo_para_mousemoving_eh = nil;
		bis_fnc_halo_para_mouseholding_eh = nil;
	};
};