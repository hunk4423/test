/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT1(_num);
CloseDialog 0;
if(THIS0<0) exitWith {cutText["Расширенная покраска не выбрана.","PLAIN DOWN"];};
CheckActionInProgressLocalize(str_epoch_player_63);
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];s_player_GK_actions_ctrl = false;
_isOK=[player,5000]call fnc_Payment;
if(SEL0(_isOK))then{
	_num=(THIS0)+1;
	if(_num==507)then{_num=0;};
	PVDZE_Ori_Skin=[VehicleForChengeSkin,_num,true];
	publicVariableServer "PVDZE_Ori_Skin";
	if(_num!=0)then{
		cutText [format["Установлена расширенная покраска #%1. Подождите, пока обновятся текстуры.",_num], "PLAIN DOWN"];
	}else{
		cutText["Установлена стандартная покраска. Текстуры обновятся после рестарта.","PLAIN DOWN"];
	};
	systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];
}else{BreakActionInProgress("Не достаточно средств для перекраски техники. Необходимо 5,000 рублей.");};
DZE_ActionInProgress = false;