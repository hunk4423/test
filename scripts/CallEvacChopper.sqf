/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz

	JAEM
	Just another Chopper-Evac Mod v1.4
	OtterNas3
	01/14/2014
	Last update: 06/14/2014
*/
#include "defines.h"

private ["_cnt","_evacFieldID","_checkForChopper","_evacCallerID","_evacCallerUID","_evacFields","_heliHRescue","_routeFinished","_evacZone","_chopperStartPos","_getChopperStartPos","_evacZoneDistance","_startZoneWaypoint","_evacZoneWaypoint","_done","_damage","_hitpoints","_evacChopperFuel","_finishMarker","_evacZonePos","_dayTime"];
/* 5 seconds timeout to cancel a call on accident */
_cnt = 5;
r_interrupt = false;
for "_p" from 1 to 5 do
{
	systemChat(format ["Эвакуационный вертолёт будет вызван через %1c - Двигайтесь для отмены!",_cnt]);
	if (r_interrupt) then {
		systemChat "Вызов эвакуационного вертолёта отменен!";
		breakOut "exit";
	};
	sleep 1;
	_cnt = _cnt - 1;
};
systemChat "Ищу Ваш эвакуационный вертолёт - Ждите...";
sleep 5;

//Setting needed variables to check which Evac-Field the player owns
_evacCallerID = (player getVariable ["CharacterID","0"]);
_evacCallerUID = ([player] call ON_fnc_convertUID);

//If Player seems not to have a Evac-Chopper
//we getting all HeliHRescue signs on Server and check if Player is owner
//This is just for the case the check on playerlogin failed
if (!playerHasEvacField) then { 
	_evacFields = PVDZE_EvacChopperFields;
	if ((count _evacFields) > 0) then {
		{
			_evacFieldID = _x getVariable ["CharacterID", "0"];
			if (_evacCallerID == _evacFieldID || _evacCallerUID == _evacFieldID) then {
				playerHasEvacField = true;
				playersEvacField = _x;
			};
		} forEach _evacFields;
	};
};

//Player has no evac field, exit
if (!playerHasEvacField) exitWith {
	systemChat "Эвакуационный вертолёт не найден.";
};

//Player has a evac field now check if a Chopper is on it
_checkForChopper = nearestObjects [playersEvacField, evac_AllowedChoppers, 10];
if ((count _checkForChopper) == 0) exitWith {
	systemChat "Эвакуационный вертолёт не найден на посадочной зоне.";
};
evacChopper = _checkForChopper select 0;

//We found a Chopper
systemChat "Эвакуационный вертолёт найден. Проверка приборов и уровня топлива...";
sleep 3;

//Let's get the Damage of the Chopper and the fuel
//Fuel check
_evacChopperFuel = fuel evacChopper;
if (_evacChopperFuel < 0.2) exitWith {
	systemChat "Низкий уровень топлива. Полет невозможен!";
	systemChat "Заправляйте вертолёт заранее.";
};

//Damage check

_done = true;
_hitpoints = evacChopper call vehicle_getHitpoints;
{			
	_damage = [evacChopper,_x] call object_getHit;
	if (_damage>0.5)then{
		if(["Engine",_x,false] call fnc_inString) then {
			_done = false;
		};
		if(["VRotor",_x,false] call fnc_inString) then {
			_done = false;
		};
		if(["HRotor",_x,false] call fnc_inString) then {
			_done = false;
		};
	};
	if (!_done) exitWith {
		systemChat "Вертолёт поврежден!  Полет невозможен!";
		systemChat "Чините вертолёт заранее.";
	};
} forEach _hitpoints;
if(!_done)exitWith{};
sleep 2;

//All is okay and we can start the creation of the Rescue sign
//create the AI Pilot and waypoints
//and get him on his way to the player
systemChat "Вертолёт в норме, вылетаю!";

//Create the Evacuation Zone Marker
_heliHRescue = "HeliHRescue" createVehicle ([player] call FNC_GetPos);
_heliHRescue setDir (getDir player);
_heliHRescue setPosATL (([player] call FNC_GetPos));

//Reset of the checkpoint bool's
evacZoneReached = false;
_routeFinished = false;

//Get needed positions
_evacZonePos = ([_heliHRescue] call FNC_GetPos);
_evacZone = _evacZonePos;
_getChopperStartPos = ([evacChopper] call FNC_GetPos);
_chopperStartPos = _getChopperStartPos;

evacChopper setVariable["evacHostile",[],true];
evacChopper setVariable["evacHeli",true,true];

//Unlocking the Chopper and create the AI Pilot
evacChopper setVehicleLock "UNLOCKED";
evacChopperGroup = createGroup WEST;
evacChopperPilot = evacChopperGroup createUnit ["USMC_Soldier_Pilot", evacChopper, [], 0,"LIEUTENANT"];
evacChopperPilot setcaptive true;
evacChopperPilot setVariable["clothesTaken",true,true];
{[evacChopperPilot, _x, 1] call BIS_fnc_invRemove;}forEach items evacChopperPilot;
{[evacChopperPilot, _x, 1] call BIS_fnc_invRemove;}forEach magazines evacChopperPilot;
{[evacChopperPilot, _x, 1] call BIS_fnc_invRemove;}forEach weapons evacChopperPilot;
evacChopperPilot assignAsDriver evacChopper;
evacChopperPilot moveInDriver evacChopper;
evacChopperPilot setSkill 1;
evacChopperGroup setBehaviour "CARELESS";
sleep 1;

//Lock the Chopper again so noone can jump in
evacChopper setVehicleLock "LOCKED";

evacChopperPilot allowDamage false;
evacChopper removeAllEventHandlers "HandleDamage";
evacChopper addEventHandler ["HandleDamage", {_this call evac_handleDamage}];

//Turn the Engine on and set fly height for the Pilot
evacChopper engineOn true;
evacChopper flyInHeight 250;

//Create the Waypoint for the Evacuation Zone
_startZoneWaypoint = evacChopperGroup addWaypoint [_chopperStartPos, 0];
_startZoneWaypoint setWaypointBehaviour "CARELESS";
_startZoneWaypoint setWaypointType "MOVE";
_startZoneWaypoint setWaypointCompletionRadius 5;
_startZoneWaypoint setWaypointSpeed "FULL";
_evacZoneWaypoint = evacChopperGroup addWaypoint [_evacZone, 0];
_evacZoneWaypoint setWaypointBehaviour "CARELESS";
_evacZoneWaypoint setWaypointType "MOVE";
_evacZoneWaypoint setWaypointCompletionRadius 5;
_evacZoneWaypoint setWaypointSpeed  "FULL" ;
_evacZoneWaypoint setWaypointStatements ["true", "evacZoneReached = true; evacChopper land 'LAND';"];
_evacZoneWaypoint setWaypointCombatMode "BLUE";

//Checking for player still alive - Evac Zone reached - Chopper still alive
//Showing a Hint-Box with informations to the player
//about the Evac-Chopper - Height - Speed - Distance
hintSilent '';
_nill = EXECVM_SCRIPT(custom_monitor.sqf);

sleep 2;

while {sleep 0.5; alive player && !_routeFinished && alive evacChopper} do {
	//Still on his way
	if (!evacZoneReached) then {
		_evacZoneDistance = format["%1м", round (evacChopper distance _evacZone)];
	} else {
		//Arrived!
		if ((([evacChopper] call FNC_GetPos) select 2) < 1) then {
			waitUntil {sleep 0.1;!isEngineOn evacChopper};
			_routeFinished = true;
			_evacZoneDistance = "!!! ПРИБЫЛ !!!";
			_evacZoneWaypoint = evacChopperGroup addWaypoint [_evacZone, 0];
			_evacZoneWaypoint setWaypointType "GETOUT";
		} else {
			_evacZoneDistance = format["%1м", round (evacChopper distance _evacZone)];
		};
	};

	hintSilent parseText format ["
		<t size='1.15' font='Bitstream'align='center' color='#5882FA'>Эвакуационный вертолёт</t><br/>
		<br/>
		<t size='1' font='Bitstream'align='left'>Высота:</t><t size='1' font='Bitstream'align='right' color='#7EC0EE'>%1</t><br/>
		<t size='1' font='Bitstream'align='left'>Скорость:</t><t size='1' font='Bitstream'align='right' color='#7EC0EE'>%2</t><br/>
		<t size='1' font='Bitstream'align='left'>Дистанция:</t><t size='1' font='Bitstream'align='right' color='#7EC0EE'>%3</t><br/>",
		(round (([evacChopper] call FNC_GetPos) select 2)), (round (speed evacChopper)), _evacZoneDistance
	];

};

//If Chopper got destroyed delete AI Pilot and his group
//give a Hint to the player about the Crash
//and exit the script
if (!alive evacChopper) then {
	{deleteWaypoint _x} forEach waypoints evacChopperGroup;
	deleteVehicle evacChopperPilot;
	waitUntil{sleep 5; count units group evacChopperPilot == 0};
	deleteGroup evacChopperGroup;
	deleteVehicle _heliHRescue;
	hintSilent parseText format ["
		<t size='1.15' font='Bitstream' align='center' color='#5882FA'>Эвакуационный вертолёт</t><br/><br/>
		<t size='1.15' font='Bitstream' align='center' color='#7EC0EE'>!!! РАЗБИЛСЯ !!!</t><br/>"
	];
	sleep 5;
	debugMonitor = true;
	_nill = EXECVM_SCRIPT(custom_monitor.sqf);
	breakOut "exit";
};

//If player dies reset the Evac-Chopper to the start position
//remove the AI Pilot and his group
//delete the Evac-Zone Marker
//and exit the script
if (!alive player) then {
	deleteVehicle _heliHRescue;
	evacChopper engineOn false;
	evacChopper setPosATL _chopperStartPos;
	evacChopper setVelocity [0,0,0.01];
	{deleteWaypoint _x} forEach waypoints evacChopperGroup;
	_evacZoneWaypoint = evacChopperGroup addWaypoint [_chopperStartPos, 0];
	_evacZoneWaypoint setWaypointType "GETOUT";
	waitUntil{sleep 0.1;{_x in evacChopper} count units group evacChopperPilot == 0};
	{deleteWaypoint _x} forEach waypoints evacChopperGroup;
	deleteVehicle evacChopperPilot;
	waitUntil{sleep 5; count units group evacChopperPilot == 0};
	deleteGroup evacChopperGroup;
	evacChopper setVariable["evacHeli",false,true];
	DamageDisable(evacChopper);
	evacChopper setVariable["evacHostile",nil];
	evacChopper setVehicleLock "LOCKED";
	breakOut "exit";
};

//All good to this point
//Create Visible Marker
_finishMarker = ObjNull;
_dayTime = dayTime;
if (_dayTime > 6 && _dayTime < 18.5) then {
	_finishMarker = "SmokeShellGreen" createVehicle ([evacChopper] call FNC_GetPos);
	_finishMarker setPosATL ([evacChopper] call FNC_GetPos);
	_finishMarker attachTo [evacChopper,[0,0,0]];
};
if (_dayTime > 18.5 && _dayTime < 6) then {
	_finishMarker = "ARTY_Flare_Medium" createVehicle ([evacChopper] call FNC_GetPos);
	_finishMarker setPosATL ([evacChopper] call FNC_GetPos);
	_finishMarker attachTo [evacChopper, [0,0,0]];
};

//We delete the AI Pilot his group and the Evac-Zone Marker
//Wait until Pilot left the Chopper
waitUntil{sleep 0.1;{_x in evacChopper} count units group evacChopperPilot == 0};
{deleteWaypoint _x} forEach waypoints evacChopperGroup;
deleteVehicle evacChopperPilot;

//Wait until the pilot is deleted so we can delete the group
waitUntil{sleep 0.5; count units group evacChopperPilot == 0};
deleteGroup evacChopperGroup;

//Delete the target zone marker
deleteVehicle _heliHRescue;


//Wait until player dies - Chopper get destroyed or
//the player moves close to the Evac-Chopper
waitUntil {sleep 1; (player distance evacChopper) < 10 || !alive player || !alive evacChopper};

evacChopper setVariable["evacHostile",nil];
deleteVehicle _finishMarker;

//If player dies reset the Evac-Chopper to the start position
//remove the AI Pilot and his group
//delete the Evac-Zone Marker
//and exit the script
if (!alive player) then {
	evacChopper setPosATL _chopperStartPos;
	evacChopper setVelocity [0,0,0.01];
	{deleteWaypoint _x} forEach waypoints evacChopperGroup;
	_evacZoneWaypoint = evacChopperGroup addWaypoint [_chopperStartPos, 0];
	_evacZoneWaypoint setWaypointType "GETOUT";
	waitUntil{sleep 0.1;{_x in evacChopper} count units group evacChopperPilot == 0};
	{deleteWaypoint _x} forEach waypoints evacChopperGroup;
	deleteVehicle evacChopperPilot;
	waitUntil{sleep 5; count units group evacChopperPilot == 0};
	deleteGroup evacChopperGroup;
	DamageDisable(evacChopper);
	evacChopper setVehicleLock "LOCKED";
	breakOut "exit";
}else{
	systemChat "Вертолёт доставлен! Добро пожаловать на борт!";
	evacChopper setVehicleLock "UNLOCKED";
	DamageEnable(evacChopper);
};
sleep 5;

debugMonitor = true;
_nil = EXECVM_SCRIPT(custom_monitor.sqf);
