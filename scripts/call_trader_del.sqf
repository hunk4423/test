/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_agent","_started","_finished","_animState","_isMedic","_abort"];
_agent = _this select 3;
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];
s_player_GK_actions_ctrl = false;

CheckActionInProgress(MSG_BUSY);
cutText ["Двигайтесь для отмены...", "PLAIN DOWN"];
ANIMATION_MEDIC(false);
if (_finished)then{
	titleText["","BLACK OUT",1];  
	Sleep 3;
	titleText["","BLACK IN",1];
	deletevehicle _agent;
	cutText ["Торговец отправился по своим делам.", "PLAIN DOWN"];
}else{
	cutText [MSG_CANCEL, "PLAIN DOWN"];
};
DZE_ActionInProgress = false;
