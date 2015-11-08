/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT2(_hndl,_HB);
disableserialization;
sleep 3;
if((getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1)exitWith{};
if!("ItemEpinephrine" in magazines player)exitWith{};
if (deathHandled) exitWith {};
if(DZE_ActionInProgress)exitWith{};
DZE_ActionInProgress=true;
closeDialog 1;

if(NotInVeh(player))then{player playActionNow "PutDown"; };
if!(([player,"ItemEpinephrine"] call BIS_fnc_invRemove) == 1)exitWith{};
playsound "epipans";
sleep 3;
DZE_ActionInProgress=false;

if (isNil "lastEpi")then{lastEpi=0;};
if((time-lastEpi)<60)then{
	cutText ["У меня передозировка, я принял слишком много лекарства!", "PLAIN DOWN"];
	[player,"panic",0,false,7] call dayz_zombieSpeak; 
	[] EXECVM_SCRIPT(grandshake.sqf);
	_hndl=ppEffectCreate ["colorCorrections", 1501];
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [ 0.9, 1, 0, [-2.32, 0.17, 0.71, 0],[1.09, 0.91, 1.1, 0.27],[-1.24, 3.03, 0.37, -1.69]];
	_hndl ppEffectCommit 5;
	r_player_blood=r_player_blood-(random 2500);
	_HB=5;
	while {_HB>0} do {
		playSound "heartbeat_1";
		_HB=_HB-1;
		sleep 1;
	};
};
lastEpi=time; 

_hndl = ppEffectCreate ["colorCorrections", 1501];
_hndl ppEffectEnable true;
_hndl ppEffectAdjust[ 1, 0.57, 0, [0.01, 0.05, 0.08, 0],[0.54, 0.35, 0.3, 1.59],[1.08, 1.09, 1.05, 0.18]];
_hndl ppEffectCommit 5;

if(isNil 'oR3F_TIRED_FNCT_Voile_Noir')then{oR3F_TIRED_FNCT_Voile_Noir = R3F_TIRED_FNCT_Voile_Noir;};
if(isNil 'oR3F_TIRED_FNCT_DoBlackVanish')then{oR3F_TIRED_FNCT_DoBlackVanish = R3F_TIRED_FNCT_DoBlackVanish;};
R3F_TIRED_FNCT_Voile_Noir={};
R3F_TIRED_FNCT_DoBlackVanish={};

player setVariable ["NORRN_unconscious", false, true];
player setVariable ["USEC_isCardiac",false,true];
player setVariable["medForceUpdate",true];

_HB=60;
while {_HB>0} do {
	playSound "heartbeat_1";
	_HB=_HB-1;
	sleep 1;
};

R3F_TIRED_FNCT_Voile_Noir=oR3F_TIRED_FNCT_Voile_Noir;
R3F_TIRED_FNCT_DoBlackVanish=oR3F_TIRED_FNCT_DoBlackVanish;
ppEffectDestroy _hndl;