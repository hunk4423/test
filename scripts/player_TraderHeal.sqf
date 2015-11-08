/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_isOK","_hb","_display","_hndl"];
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];
s_player_GK_actions_ctrl = false;
disableSerialization;
if(hasGutsOnHim)exitWith{cutText ["Ну и запах! Я не хочу иметь с тобой никаких дел!", "PLAIN DOWN"];};
CheckActionInProgressLocalize(str_epoch_player_63);

_isOK=[true];
if!((THIS3)=="free")then{
	_isOK=[player,200] call fnc_Payment;
	if(SEL0(_isOK))then{systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];};
};
if!(SEL0(_isOK))exitWith{BreakActionInProgress("Так, посмотрим... ничего серьезного. Но цена 200 рублей");};

cutText [format["Не двигайся, сейчас тебя подлатаю!"], "PLAIN DOWN"];
player playActionNow "Medic";
sleep 5;

	dayz_sourceBleeding = objNull;
	[12000] spawn fnc_usec_addBlood;
	r_player_inpain = false;
	r_player_infected = false;
	r_player_injured = false;
	dayz_temperatur = 37;
	r_fracture_legs = false;
	r_fracture_arms = false;
	r_player_dead = false;
	r_player_unconscious = false;
	r_player_loaded = false;
	r_player_cardiac = false;
	r_player_lowblood = false;
	r_player_timeout = 0;
	r_handlercount = 0;
	r_interrupt = false;
	r_doLoop = false;
	r_drag_sqf = false;
	r_self = false;
	r_action = false;
	r_action_unload = false;
	r_player_handler = false;
	r_player_handler1 = false;
	disableUserInput false;
	R3F_TIRED_Accumulator = 0;
	resetCamShake;
	R3F_TIRED_Accumulator = 0;

	player setHit['legs',0];
	player setVariable['NORRN_unconscious',false,true];
	player setVariable['USEC_infected',false,true];
	player setVariable['USEC_injured',false,true];
	player setVariable['USEC_inPain',false,true];
	player setVariable["USEC_inPain", false, true];
	player setVariable['USEC_isCardiac',false,true];
	player setVariable['USEC_lowBlood',false,true];
	player setVariable['USEC_BloodQty',12000,true];
	player setVariable['unconsciousTime',0,true];
	player setVariable ['hit_legs',0,true];
	player setVariable ['hit_hands',0,true];
	player setVariable['SplintWound',0,true];
	player setVariable['medForceUpdate',true,true];
	player setdamage 0;

	_display = uiNamespace getVariable 'DAYZ_GUI_display';
	(_display displayCtrl 1300) ctrlShow true;
	(_display displayCtrl 1303) ctrlShow false;
	(_display displayCtrl 1306) ctrlShow true;
	(_display displayCtrl 1203) ctrlShow false;
					
DZE_ActionInProgress = false;

_hndl = ppEffectCreate ["colorCorrections", 1501];
_hndl ppEffectEnable true;
_hndl ppEffectAdjust[ 1, 0.57, 0, [0.01, 0.05, 0.08, 0],[0.54, 0.35, 0.3, 1.59],[1.08, 1.09, 1.05, 0.18]];
_hndl ppEffectCommit 5;

if (isNil 'oR3F_TIRED_FNCT_Voile_Noir') then {oR3F_TIRED_FNCT_Voile_Noir = R3F_TIRED_FNCT_Voile_Noir;};
if (isNil 'oR3F_TIRED_FNCT_DoBlackVanish') then {oR3F_TIRED_FNCT_DoBlackVanish = R3F_TIRED_FNCT_DoBlackVanish;};
R3F_TIRED_FNCT_Voile_Noir = {};
R3F_TIRED_FNCT_DoBlackVanish = {};

cutText["Ты здоров!!","PLAIN DOWN"];

_hb=60;
while{_hb>0}do{
	playSound "heartbeat_1";
	_hb=_hb-1;
	sleep 1;
};
			
R3F_TIRED_FNCT_Voile_Noir = oR3F_TIRED_FNCT_Voile_Noir;
R3F_TIRED_FNCT_DoBlackVanish = oR3F_TIRED_FNCT_DoBlackVanish;
ppEffectDestroy _hndl;