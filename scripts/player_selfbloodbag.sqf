/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_ambulanceFound","_ambulanceEnable","_heliFound","_hospitleFound","_MEDFound","_lowBlood","_sound","_bloodAmount","_infectionChance","_humanityNegBool","_humanityNegAmount","_humanityAmount","_infectedLifeLost","_infectedLifeBool","_lastBloodbag","_bloodbagLastUsedTime","_bloodbagTime","_bloodbagUseTime","_bloodbagUsageTime","_timeout"];
if !("ItemBloodbag" in magazines player) exitWith {cutText [format["Необходим пакет крови"], "PLAIN DOWN"]};
if (dayz_combat == 1) exitwith { cutText [format["В бою нельзя переливать кровь!"], "PLAIN DOWN"]};
if (vehicle player != player) exitWith {cutText [format["Не могу переливать себе кровь в технике"], "PLAIN DOWN"]};
if (r_player_blood == r_player_bloodTotal) exitwith {cutText ["Я не нуждаюсь в переливании крови","PLAIN DOWN"]};
//общие настройки
//_disallowinVehicle = true;
_infectedLifeBool = true; // Whether the player can loose life if infected (True = On | False = off)

_infectedLifeLost = 2000;
_bloodbagLastUsedTime = 180;
if (isNil "lastBloodbag") then {lastBloodbag = 0;};
_bloodbagTime = time - lastBloodbag;
//общие настройки
if(_bloodbagTime < _bloodbagLastUsedTime) exitWith { // If cooldown is not done then exit script
	cutText [format["Нужно подождать %1 секунд. До тех пор не могу перелить кровь!",(_bloodbagTime - _bloodbagLastUsedTime)], "PLAIN DOWN"]; //display text at bottom center of screen when players cooldown is not done
};
CheckActionInProgress(MSG_BUSY);

_ambulanceFound = count nearestObjects[player,["M113Ambul_TK_EP1_DZ","GAZ_Vodnik_MedEvac","BMP2_Ambul_INS","BMP2_Ambul_CDF","HMMWV_Ambulance","HMMWV_Ambulance_DES_EP1","HMMWV_Ambulance_CZ_DES_EP1","S1203_ambulance_EP1","MAP_lekarnicka"],5]; 
_heliFound = count nearestObjects[player,["Mi17_medevac_Ins","Mi17_medevac_CDF","Mi17_medevac_RU","UH60M_MEV_EP1"],10];
_hospitleFound = count nearestObjects[player,["Land_A_Hospital","MASH_EP1"],25];
_MEDFound = _ambulanceFound + _hospitleFound + _heliFound;
if (_MEDFound > 0 ) then {
	_bloodAmount = 8000;
	_bloodbagUseTime = 15;
	_infectionChance = 30;
	cutText [format["Начинаю переливать себе кровь вблизи медицинской техники/больницы/аптечки, шансы хороши!"], "PLAIN DOWN"];
}else{
	_bloodAmount = 5000;
	_bloodbagUseTime = 20;
	_infectionChance = 50;
	cutText [format["Начинаю переливать себе кровь в полевых условиях, эх... была бы рядом больница, медицинская техника или хотя бы аптечка..."], "PLAIN DOWN"];
};

_bloodbagUsageTime = time;
_timeout = player getVariable["combattimeout", 0];

[player,"bandage",0,false] call dayz_zombieSpeak;
player playActionNow "Medic";

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
	if(!_isMedic && !r_interrupt && (time - _bloodbagUsageTime) < _bloodbagUseTime) then {
		player playActionNow "Medic";
		_isMedic = true;
	};
	if (_started && !_isMedic && (time - _bloodbagUsageTime) > _bloodbagUseTime) then {
		r_doLoop = false;
		_finished = true;
	};
	if (r_interrupt) then {
		r_doLoop = false; // if interuppted turns loop off early so _finished is never true
	};
	sleep 0.1;
};
r_doLoop = false;

if (_finished) then {
	_num_removed = ([player,"ItemBloodbag"] call BIS_fnc_invRemove);
	if!(_num_removed == 1) exitWith {BreakActionInProgress("Необходим пакет крови")};
	lastBloodbag = time;

	[_bloodAmount] spawn fnc_usec_addBlood;

	if (RND(_infectionChance)) then {
		r_player_infected = true;
		player setVariable["USEC_infected",true,true]; //tell the server the player is infected

		if (RND(50)) then {
			[] EXECVM_SCRIPT(grandshake.sqf);
			r_player_timeout = 15;
			r_player_unconscious = true;
			player setVariable ["medForceUpdate",true,true];
			player setVariable ["NORRN_unconscious", true, true];
			player setVariable ["unconsciousTime", r_player_timeout, true];
			_lowBlood = player getVariable["USEC_lowBlood",false];
			if (!_lowBlood) then {
				player setVariable["USEC_lowBlood",true,true];
			};
			r_player_injured = true;
			_sound = ['z_scream_3','z_scream_4'] call BIS_fnc_selectRandom;
			[nil,player,rSAY,[_sound,100]] call RE;
			[player,100,true,(getPosATL player)] spawn player_alertZombies;
		};
		cutText [format["Перелил себе кровь, но пакет с кровью был заражен!!!"], "PLAIN DOWN"];

		// check for if loosing life on infection is turned on
		if(_infectedLifeBool) then {
			r_player_blood = r_player_blood - _infectedLifeLost;
			player setVariable["USEC_BloodQty",r_player_blood,true]; //save this blood ammount to the database
		} else {
			r_player_lowblood = false; //set lowblood setting to false
			0 fadeSound 1; //slowly fade their volume back to maximum
			"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5; //disable post processing blur effect
			"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5; //give them their colour back
			r_player_lowblood = false; //just double checking their blood isnt low
			player setVariable["USEC_BloodQty",r_player_blood,true]; //save this blood ammount to the database
		};
	} else { // if not infected
		r_player_lowblood = false;
		0 fadeSound 1;
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;
		"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5;
		r_player_lowblood = false;
		player setVariable["USEC_BloodQty",r_player_blood,true];
		cutText [format["Удачно перелил себе кровь!"], "PLAIN DOWN"];
	};

} else {
	r_interrupt = false;
	player switchMove "";
	player playActionNow "stop";
	cutText [format["Прервал переливание крови"], "PLAIN DOWN"];
};

DZE_ActionInProgress = false;
player setVariable["combattimeout", time + 30, true];
player setVariable["startcombattimer", 0, true];
dayz_combat = 1;
player setVariable["incombat", 1, true];
