/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_veh","_finished","_animState","_isMedic","_started","_prise"];
{player removeAction _x} count s_player_lockunlock;s_player_lockunlock=[];
s_player_lockUnlock_crtl=-1;
_veh=THIS3;
if((GETVAR(_veh,TurboInstalled,"0"))=="1")exitWith{cutText["На этой технике уже установлена турбина.","PLAIN DOWN"];};
if((typeOf _veh) isKindOf "Tank")then{_prise=300000;}else{_prise=200000;};
if(GetCash(player)<_prise)exitWith{
	systemChat format["Недостаточно средств. Для установки турбины необходимо %1 руб.",([_prise] call BIS_fnc_numberText)];
	systemchat "После установки турбины, на технике можно будет постоянно передвигается с высокой скоростью до 250км/ч. Турбину можно включать или отключать, кнопка Пробел. Включение ускорения осуществляется кнопкой Shift.";
	systemchat "Возможность включать/выключать турбину будет доступно в любой момент, не зависимо от рестартов.";
	cutText[format["Недостаточно средств. Для установки турбины необходимо %1 руб.",([_prise] call BIS_fnc_numberText)],"PLAIN DOWN"];
};
CheckActionInProgressLocalize(str_epoch_player_63);
cutText ["Установка турбины, двигайтесь для отмены...", "PLAIN DOWN"];
[player,"repair",0,false,10] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;
ANIMATION_MEDIC(false);
if(!_finished)exitwith{DZE_ActionInProgress = false;};
if(_finished)then{
	if!([player, _prise]call SC_fnc_removeCoins)exitWith{cutText[format["Недостаточно средств. Для установки турбины необходимо %1 руб.",_prise],"PLAIN DOWN"];};
	PVDZE_TurboInstall=[_veh,"1"];
	publicVariableServer "PVDZE_TurboInstall";
	cutText["Турбина успешно установлена.","PLAIN DOWN"];
	systemchat "Турбина успешно установлена, на технике можно постоянно передвигается с высокой скоростью до 250км/ч. Турбину можно включать или отключать, кнопка Пробел. Включение ускорения осуществляется кнопкой Shift.";
	systemchat "Возможность включать/выключать турбину доступно в любой момент, не зависимо от рестартов.";
};
DZE_ActionInProgress = false;