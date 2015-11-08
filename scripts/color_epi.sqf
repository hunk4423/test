/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_EpiLastUsedTime","_overdose","_EpiTime","_heartbeat_2","_heartbeat_1","_rBlood","_hndl"];
_EpiLastUsedTime = 60;
_overdose = false;
if (isNil "lastEpi") then {lastEpi = 0;};
_EpiTime = time - lastEpi;
if (_EpiTime < _EpiLastUsedTime) then { _overdose = true;};
_heartbeat_2 = 60;

if (_overdose) then {
_heartbeat_1 = 5;
_rBlood = random 2500;

cutText ["У меня передозировка, я принял слишком много лекарства!", "PLAIN DOWN"];
[player,"panic",0,false,7] call dayz_zombieSpeak; 
[] EXECVM_SCRIPT(grandshake.sqf);
_hndl = ppEffectCreate ["colorCorrections", 1501];
_hndl ppEffectEnable true;
_hndl ppEffectAdjust [ 0.9, 1, 0, [-2.32, 0.17, 0.71, 0],[1.09, 0.91, 1.1, 0.27],[-1.24, 3.03, 0.37, -1.69]];
_hndl ppEffectCommit 5;
//
r_player_blood = r_player_blood - _rBlood;
//
while {_heartbeat_1 > 0} do {
playSound "heartbeat_1";
_heartbeat_1 = _heartbeat_1 - 1;
sleep 1;
};
};

lastEpi = time; 

_hndl = ppEffectCreate ["colorCorrections", 1501];
_hndl ppEffectEnable true;
_hndl ppEffectAdjust[ 1, 0.57, 0, [0.01, 0.05, 0.08, 0],[0.54, 0.35, 0.3, 1.59],[1.08, 1.09, 1.05, 0.18]];
_hndl ppEffectCommit 5;
//
if (isNil 'oR3F_TIRED_FNCT_Voile_Noir') then {oR3F_TIRED_FNCT_Voile_Noir = R3F_TIRED_FNCT_Voile_Noir;};
if (isNil 'oR3F_TIRED_FNCT_DoBlackVanish') then {oR3F_TIRED_FNCT_DoBlackVanish = R3F_TIRED_FNCT_DoBlackVanish;};
R3F_TIRED_FNCT_Voile_Noir = {};
R3F_TIRED_FNCT_DoBlackVanish = {};
//
while {_heartbeat_2 > 0} do {
playSound "heartbeat_1";
_heartbeat_2 = _heartbeat_2 - 1;
sleep 1;
};
//			
R3F_TIRED_FNCT_Voile_Noir = oR3F_TIRED_FNCT_Voile_Noir;
R3F_TIRED_FNCT_DoBlackVanish = oR3F_TIRED_FNCT_DoBlackVanish;
ppEffectDestroy _hndl;
