/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_obj","_sleepTime","_isTent","_timeLeft","_pos","_coords","_anim","_temp_boost"];
{player removeAction _x}count s_player_GK_actions;s_player_GK_actions=[];s_player_GK_actions_ctrl=false;
_obj=_this select 3;
if(isNil "sleepTimer")then{sleepTimer=0;};
_sleepTime=time-sleepTimer;
if(_sleepTime<180)exitWith{cutText[format["Я не устал! Посплю позже...",(_sleepTime-180)],"PLAIN DOWN"];};/////
if((GETVAR(_obj,isBussy,0))==1)exitWith{cutText["На этой кровати уже кто-то спит!","PLAIN DOWN"];};
if(dayz_combat==1)exitWith{cutText["Нельзя спать в бою! ;)","PLAIN DOWN"];};

CheckActionInProgress(MSG_BUSY);
ANIMATION_MEDIC(true);
if(!_finished)exitWith{BreakActionInProgress(MSG_CANCEL)};

_isTent=_obj isKindOf "TentStorage";
_anim=["CtsPercMstpSnonWnonDnon_idle30rejpaniVuchu","CtsPercMstpSnonWnonDnon_idle32podrbaniNanose","CtsPercMstpSnonWnonDnon_idle33rejpaniVzadku"] call BIS_fnc_selectRandom;
_timeLeft=60;
SETVARS(_obj,isBussy,1);

if(_isTent)then{
	[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_layDown"] call RE;
	sleep 3;
	_temp_boost=-5;
}else{
	titleText["","BLACK OUT",1];
	_pos=getPosATL player;
	_temp_boost=+5;
	sleep 1;
	switch(typeOf _obj)do{
		case "MAP_bed_husbands": 		{_coords=[1,1.15,-.12];};
		case "MAP_vojenska_palanda" :	{_coords=[0,-.2,.4];};
		case "MAP_F_Vojenska_palanda":	{_coords=[0,-.2,.54];};
		case "MAP_postel_manz_kov" :	{_coords=[1,.8,.55];};
		case "MAP_F_postel_manz_kov":	{_coords=[1,0.9,.55];};//
		case "MAP_postel_panelak1" :	{_coords=[.5,0,.35];};
		case "MAP_F_postel_panelak2":	{_coords=[.5,0,.3];};
		case "MAP_F_postel_panelak2":	{_coords=[.5,0,.3];};
	};
	[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE;
	player attachto [_obj,_coords];
	sleep 1;
	titleText["","BLACK IN",1];
};
cutText ["Хорошо то как...", "PLAIN DOWN"];
[4500+(random 500)] spawn fnc_usec_addBlood;

for "_i" from 0 to 60 do{
	sleep 1;
	_timeLeft=_timeLeft-1;
	switch(_timeLeft)do {
		case 58: {if(_isTent)then{[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE;};};
		case 50 : {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE;};
		case 40 : {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep1"] call RE;};
		case 30 : {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep3"] call RE;};
		case 25 : {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE;};
		case 10 : {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep3"] call RE;};
		case 5 :  {[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE;};
	};
};

if(_timeLeft<0)then{
	cutText ["Эх... как не охото вставать... Еще чуть чуть...", "PLAIN DOWN"];
	sleep 5;
	if(_isTent)then{
		[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_standUp"] call RE;
		sleep 5;
	}else{
		titleText["","BLACK OUT",1];
		sleep 1;
		detach player;
		player setPosATL _pos;
		[objNull,player,rSwitchMove,""]call RE;
		sleep 1;
		titleText["","BLACK IN",1];
		sleep 1;
	};	
	dayz_temperatur=dayz_temperatur+_temp_boost;
	dayz_thirst=dayz_thirst+500;
	dayz_hunger=dayz_hunger+500;
	r_player_inpain=false;
	player setVariable['USEC_inPain',false,true];
	player setVariable["USEC_BloodQty",r_player_blood,true];
	player setVariable["medForceUpdate",true,true];	
	
	cutText ["Выспался! Я полон сил и здоровья! Только покушать бы чего-нибудь...", "PLAIN DOWN"];
	[objNull,player,rSwitchMove,_anim]call RE;
	sleepTimer=time;
};
SETVARS(_obj,isBussy,0);
DZE_ActionInProgress = false;