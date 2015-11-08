/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_isOK"];
if(hasGutsOnHim)exitWith{cutText ["Ну и запах! Я не хочу иметь с тобой никаких дел!", "PLAIN DOWN"];};
CheckActionInProgressLocalize(str_epoch_player_63);
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];s_player_GK_actions_ctrl = false;

_isOK=[true];
if!((THIS3)=="free")then{
	_isOK=[player,100]call fnc_Payment;
	if(SEL0(_isOK))then{systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];};
};
if!(SEL0(_isOK))exitWith{BreakActionInProgress("Комплексный обед стоит 100 рублей");};

cutText [format["Ммм... Как вкусно!"], "PLAIN DOWN"];
player playMove "AinvPknlMstpSlayWrflDnon_healed";
Sleep 2;
[player,"drink",0,false,6] call dayz_zombieSpeak;
Sleep 3;
[player,"eat",0,false,6] call dayz_zombieSpeak;

dayz_hunger=0;
dayz_thirst=0;

[3000+(random 500)]spawn fnc_usec_addBlood;

player setVariable ["messing",[dayz_hunger,dayz_thirst],true];
player setVariable["medForceUpdate",true];
PVDZE_plr_Save = [player,[],true,true];
publicVariableServer "PVDZE_plr_Save";
DZE_ActionInProgress = false;