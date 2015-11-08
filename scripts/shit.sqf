/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_msg_finish","_msg_start","_msg_dump","_toilet","_dir","_pos","_soundFly","_anim","_pToilet","_type"];
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];
s_player_GK_actions_ctrl = false;

if(isNil "UKdump_taken")then{UKdump_taken=false;};

if (UKdump_taken)exitWith{ 
	_msg_dump = [
		"Да нечем уже...",
		"Ничего хорошего из меня уже не выйдет!",
		"Я уже и так все!",
		"Так и геморрой можно заработать!"
	] call BIS_fnc_selectRandom;
	cutText [format["%1",_msg_dump], "PLAIN DOWN"];
};

if!("ItemTrashToiletpaper" in magazines player)exitWith{cutText["Нужна туалетная бумага! Не рукой же вытирать!", "PLAIN DOWN"]};
CheckActionInProgress(MSG_BUSY);

_msg_start = [
	"Надо бы облегчиться!",
	"Снесу ка я яичко над водичкой!",
	"Ну, здравствуй, фарфоровый друг!",
	"Ох, ну наконец то!!!",
	"Как долго я этого ждал!"
] call BIS_fnc_selectRandom;

_msg_finish =[
	"Фух! Пронесло! Как фанерку над Парижем!",
	"Еле успел!",
	"Бомбы ушли!!!",
	"Ох, как сразу легко то стало!!!"
] call BIS_fnc_selectRandom;

_anim=[
"CtsPercMstpSnonWnonDnon_idle30rejpaniVuchu",
"CtsPercMstpSnonWnonDnon_idle32podrbaniNanose",
"CtsPercMstpSnonWnonDnon_idle33rejpaniVzadku"
] call BIS_fnc_selectRandom;

UKdump_taken=true;
player removeMagazine "ItemTrashToiletpaper";
_toilet=_this select 3;

_dir=getDir _toilet;
_pos=getPosATL player;
_pToilet=getPosATL _toilet;
_type=typeOf _toilet;
sleep 1;
[objNull, player, rSwitchMove,"miles_c0briefing_odpovedel_loop"] call RE;
if (_type=="MAP_P_toilet_b_02")then{
	player setDir(_dir-1);
}else{
	player setDir(_dir-170);
};
player setPosATL _pToilet; 

cutText [format["%1",_msg_start], "PLAIN DOWN"];
sleep 15;
[player,"document",0,false,20] call dayz_zombieSpeak;
sleep 5;

dayz_temperatur=dayz_temperatur-2;
r_player_inpain=false;
R3F_TIRED_Accumulator=0;
dayz_hunger=dayz_hunger+500;
dayz_thirst=dayz_thirst+500;
[3000]spawn fnc_usec_addBlood;
"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;

player setPosATL _pos;
cutText [format["%1",_msg_finish],"PLAIN DOWN"];
[objNull,player,rSwitchMove,_anim]call RE;
_soundFly=createSoundSource["Sound_Flies",_pToilet,[],0];
_soundFly setVariable["timeout",time+300,true];

sleep 4;
if((_type=="Land_KBud")&&RND(20))then{
	r_player_infected=true;
	player setVariable["USEC_infected",true,true];
};
player setVariable["medForceUpdate",true,true];
DZE_ActionInProgress = false;