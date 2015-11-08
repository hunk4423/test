/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
/*
 **  BLOWOUT MODULE - Nightstalkers: Shadow of Namalsk
 *   ..created by Sumrak, ©2010
 *   http://www.nightstalkers.cz
 *   sumrak<at>nightstalkers.cz
 *   PBO edition
 *   CLIENT-SIDE script 
*/
#include "defines.h"

waitUntil {!isNil "ns_blowout"}; 

if (ns_blowout) then {
_sound = ['z_scream_3','z_scream_4','z_panic_0','z_panic_1'] call BIS_fnc_selectRandom;

_rBlood0 = random 1000;
_rBlood1 = _rBlood0 + 9000;


bl_detection = 
{
	playSound "bl_detect";
	Sleep 0.2;
	playSound "bl_detect";
	Sleep 0.5;
	cutRsc ["RscAPSI_h1","PLAIN"];
	playSound "bl_detect";
	Sleep 0.1;
	playSound "bl_detect";    
	Sleep 2;
	playSound "bl_detect";        
	playSound "apsi_on";
	"filmGrain" ppEffectEnable true; 
	"filmGrain" ppEffectAdjust [0.15, 1, 1, 0.1, 1, false];
	"filmGrain" ppEffectCommit 0;
	Sleep 1;
	playSound "bl_detect";
	Sleep 0.2;
	playSound "bl_detect";
	Sleep 23.8;
	waitUntil{ns_blow_status};
	playSound "bl_detect";
	Sleep 0.2;
	playSound "bl_detect";
};

bl_flash =
{
	titleText["","WHITE OUT",1];
	titleText["","WHITE IN",1]; 
	Sleep 0.25;
};

bl_local_check_time = 
{
	if ((daytime >= 17)||(daytime <= 7)) then 
	{
		if (daytime >= 17) then 
		{
			_posun = 9 - daytime;
			skipTime _posun; // skiping time to daylight
			Sleep 14;
			_posun = -_posun;
			skipTime _posun;  // skiping time to previous
		} else {
			if (daytime >= 0) then
			{
				_posun = 14 - daytime;
				skipTime _posun; // skiping time to daylight
				Sleep 14;
				_posun = -_posun;
				skipTime _posun;  // skiping time to previous
			};
		};
	};
};

bl_preparations = {

	20 setOvercast 1;
	
	playSound "ns_fx_drone2";

	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 4;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

Sleep 18;

	playSound "ns_fx_misc4";

	Sleep 13.5;

	playSound "ns_fx_drone2";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 19;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 17;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 15;

	playSound "ns_fx_drone2";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 14;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 13;

	playSound "ns_fx_drone2";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 11;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 9;

	playSound "ns_fx_misc4";
	playSound "ns_fx_drone2";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;

	Sleep 7;

	playSound "ns_fx_drone1";
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.2;
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.1;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.25; 
	"chromAberration" ppEffectEnable false;
};

	if (isNil("ns_blowout_dayz")) then { ns_blowout_dayz = false; };
	if (isNil("ns_blow_ambient_music")) then { ns_blow_ambient_music = false; };

	waitUntil{ns_blow_prep};

	if (player hasWeapon ns_blow_itemapsi) then {
		_bul = [] spawn bl_detection;
	};

	_bul = [] spawn bl_preparations;

	waitUntil{ns_blow_status}; 
	waitUntil{ns_blow_action};

	playSound "bl_begin";
	"dynamicBlur" ppEffectAdjust [8];
	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectCommit 0;
	"dynamicBlur" ppEffectAdjust [0.1];
	"dynamicBlur" ppEffectCommit 0.75;
	"chromAberration" ppEffectAdjust [0.25,0,true];
	"chromAberration" ppEffectEnable true;
	"chromAberration" ppEffectCommit 0.5;
	Sleep 0.5; 
	"chromAberration" ppEffectAdjust [-0.15,0,true];
	"chromAberration" ppEffectCommit 0.35;
	Sleep 0.5;
	"chromAberration" ppEffectAdjust [-0.05,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 0.20;
	"chromAberration" ppEffectAdjust [0,0,true];
	"chromAberration" ppEffectCommit 0.20;
	Sleep 1; 
	"chromAberration" ppEffectEnable false;
	"dynamicBlur" ppEffectAdjust [3];
	"dynamicBlur" ppEffectCommit 2.75;
	Sleep 5;

	_bul = [] call bl_flash;
	_s = round (random 3);
	switch (_s) do 
	{
		case 0: {playSound "bl_hit1";};
		case 1: {playSound "bl_hit2";};
		case 2: {playSound "bl_hit3";};
		case 3: {playSound "bl_hit1";};
	};
	"dynamicBlur" ppEffectAdjust [3];
	"dynamicBlur" ppEffectCommit 5;
	Sleep 1;
	_bul = [] call bl_flash;
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_hit1";};
		case 1: {playSound "bl_hit2";};
		case 2: {playSound "bl_hit3";};
		case 3: {playSound "bl_hit1";};
	}; 
	"dynamicBlur" ppEffectAdjust [2.4];
	"dynamicBlur" ppEffectCommit 6;
	Sleep 4;
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_wave1";};
		case 1: {playSound "bl_wave2";};
		case 2: {playSound "bl_wave3";};
		case 3: {playSound "bl_wave1";};
	};
	Sleep 0.3;       
	_bul = [] call bl_flash; 
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_hit1";};
		case 1: {playSound "bl_hit2";};
		case 2: {playSound "bl_hit3";};
		case 3: {playSound "bl_hit1";};
	};
	Sleep 1; 
	0 setOvercast 1;
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_wave1";};
		case 1: {playSound "bl_wave2";};
		case 2: {playSound "bl_wave3";};
		case 3: {playSound "bl_wave1";};
	};
	
	
	playSound "bl_psi";
	_hndl = ppEffectCreate ["colorCorrections", 1501];
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [ 1, 0.75, 0, [-3.16, 5, 5, 0],[-4.3, 5, 5, 1.28],[-2.96, 5, 5, 5]];
	_hndl ppEffectCommit 5;
	Sleep 1;

	[] EXECVM_SCRIPT(grandshake.sqf);
	Sleep 5;

	_bul = [] call bl_flash; 
	if (!ns_blowout_dayz) then { _bul = [] spawn bl_local_check_time; };
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_hit1";};
		case 1: {playSound "bl_hit2";};
		case 2: {playSound "bl_hit3";};
		case 3: {playSound "bl_hit1";};
	};
	ppEffectDestroy _hndl;
	_nonapsi_ef = ppEffectCreate ["colorCorrections", 1555]; 
	_nonapsi_ef ppEffectEnable true;
	_nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [1.0, 0.2, 0.2, 0.0], [1.0, 0.4, 0.0, 0.1],[1.0,0.3,0.3, 0.5]];
	_nonapsi_ef ppEffectCommit 2;
	Sleep 1;
	
	
	_bul = [] call bl_flash; 
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_wave1";};
		case 1: {playSound "bl_wave2";};
		case 2: {playSound "bl_wave3";};
		case 3: {playSound "bl_wave1";};
	};
	_bul = [] call bl_flash;
	Sleep 3;
	
	[nil,player,rSAY,[_sound,100]] call RE;
	[player,10,true,(getPosATL player)] spawn player_alertZombies;

	Sleep 1;
	setViewDistance 1;
	_bul = [] call bl_flash; 
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_wave1";};
		case 1: {playSound "bl_wave2";};
		case 2: {playSound "bl_wave3";};
		case 3: {playSound "bl_wave1";};
	};
	_nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [1.0, 0.1, 0.1, 0.0], [1.0, 0.1, 0.0, 0.1],[1.0,0.1,0.0, 0.5]];
	_nonapsi_ef ppEffectCommit 6;
	Sleep 1;
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_hit1";};
		case 1: {playSound "bl_hit2";};
		case 2: {playSound "bl_hit3";};
		case 3: {playSound "bl_hit1";};
	};
	Sleep 3;
	_bul = [] call bl_flash;
	_s = round (random 3); 
	switch (_s) do 
	{
		case 0: {playSound "bl_wave1";};
		case 1: {playSound "bl_wave2";};
		case 2: {playSound "bl_wave3";};
		case 3: {playSound "bl_wave1";};
	};

	_nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 5.0],[0.4,0.0,0.0, 0.7]];
	_nonapsi_ef ppEffectCommit 1;
	
	playSound "bl_full";
	Sleep 0.1;

	setViewDistance 1400;
	ppEffectDestroy _nonapsi_ef;
	30 setOvercast 0;

	_vehicle = vehicle player;

	if(ns_blowout_dayz) then {
		if (!(player hasWeapon ns_blow_itemapsi)) then {
			if([player] call fnc_isInsideBuilding) then {
				r_player_inpain = true;
				player setVariable["USEC_inPain",true,true];
			} else {
				if !(_vehicle != player) then {
					r_player_blood = r_player_blood - _rBlood1;
				} else {
					if !(((_vehicle isKindOf "Wheeled_APC") or (_vehicle isKindOf "Tank")) and !(typeOf _vehicle in ["M113_TK_EP1","M113Ambul_TK_EP1_DZ","M113_UN_EP1"])) then {
						r_player_blood = r_player_blood - _rBlood1;
					};
				};
				r_player_inpain = true;
				player setVariable["medForceUpdate",true];
			};
		};
	};

	if !(vehicle player != player) then {
		if (player hasWeapon ns_blow_itemapsi) then {
			//Есть псишлем
			[player,1] call fnc_usec_damageUnconscious;
		} else {
			//Нет шлема
			[player,2] call fnc_usec_damageUnconscious;
		};
	} else {
			//в тачке
			if (player hasWeapon ns_blow_itemapsi) then {
			_timeLeft = 10;
			for "_i" from 0 to 10 do {
				Sleep 1;
				_timeLeft = _timeLeft - 1; // Minus _timeLeft by one every second	
				if (_timeLeft > 0) then {
				cutText [format["Вы в обмороке! Очнетесь через... %1сек.",_timeLeft], "BLACK FADED"]; // Display Sleep countdown while sleeping
				} else {cutText [format["Ничего себе меня отрубило..."], "BLACK FADED"];}; // This is a fix for when timer reaches zero... displays text
				if (r_player_dead) then {_timeLeft = _timeLeft - 10;_i= 10;titleText["","BLACK IN",1];};
			};
		} else {
			_timeLeft = 30;
			for "_i" from 0 to 30 do {
				Sleep 1;
				_timeLeft = _timeLeft - 1; // Minus _timeLeft by one every second	
				if (_timeLeft > 0) then {
				cutText [format["Вы в обмороке! Очнетесь через... %1сек.",_timeLeft], "BLACK FADED"]; // Display Sleep countdown while sleeping
				} else {cutText [format["Ничего себе меня отрубило..."], "BLACK FADED"];}; // This is a fix for when timer reaches zero... displays text
				if (r_player_dead) then {_timeLeft = _timeLeft - 30;_i= 30;titleText["","BLACK IN",1];};
			};
		};
	};

	if (player hasWeapon ns_blow_itemapsi) then {if (floor(random(100)+1) <= 7) then {player removeWeapon "CDF_dogtags"; systemChat ("Пси-защита уничтожена из-за перегрузки!");};};
	[nil,player,rSAY,[_sound,100]] call RE;
	[player,30,true,(getPosATL player)] spawn player_alertZombies;

	Sleep 1;

	waitUntil {!ns_blow_action};
	
	if (player hasWeapon ns_blow_itemapsi) then{
		cutRsc ["RscAPSI_h6","PLAIN"];
		playSound "apsi_off";
		"filmGrain" ppEffectEnable false;
	};

	"dynamicBlur" ppEffectAdjust [0];
	"dynamicBlur" ppEffectCommit 16; 



};