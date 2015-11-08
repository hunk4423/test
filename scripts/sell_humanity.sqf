/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT1(_dialog);
if(isNil "OnSellHumanityClick")then{
	OnSellHumanityClick = {
		PVT3(_humanity,_amount,_addcash);
		CheckActionInProgress(MSG_BUSY);
		_humanity = GETPVAR(humanity,0);
		_amount = parseNumber (THIS0);
		if (_amount < 1 or _amount > _humanity) exitWith {BreakActionInProgress("Нельзя продать больше чем у вас есть.");};
		_addcash=_amount*2;
		[player,-_amount,0] call player_humanityChange;
		[player,_addcash] call SC_fnc_addCoins;
		cutText [format["Продано %1 хуманити за %2 руб.",_amount,_addcash], "PLAIN DOWN"];
		DZE_ActionInProgress = false;		
	};
};
_dialog = createdialog "SellHumanityDialog";
ctrlSetText [14501, format["%1", [(player getVariable ['humanity', 0])] call BIS_fnc_numberText]];
waitUntil { !dialog };