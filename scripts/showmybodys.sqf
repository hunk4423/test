/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_finished","_animState","_started","_isMedic"];
closeDialog 1;
CheckActionInProgress(MSG_BUSY);
cutText ["Цена включениея отображения ваших трупов на карте 10,000руб..\nДвигайтесь для отмены.","PLAIN DOWN"];
sleep 2;
[player,"document",0,false,20] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;
ANIMATION_MEDIC(false);
if (_finished)then{
	_isOK=[player,10000] call fnc_Payment;
	if!(SEL0(_isOK))exitWith{BreakActionInProgress("Не достаточно средств. Цена 10,000 руб.");};
	systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];
	ShowMyBodys=true;
	cutText["Все ваши трупы отображены на карте.\n Метки видны только вам и останутся до перезахода в игру.","PLAIN DOWN"];
	systemChat "Все ваши трупы отображены на карте. Метки видны только вам и останутся до перезахода в игру.";
};
DZE_ActionInProgress = false;