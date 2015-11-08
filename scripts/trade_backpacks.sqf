/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_buy_or_sell","_item","_textPart","_price","_removed","_cash","_msg"];
if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_103") , "PLAIN DOWN"];};
DZE_ActionInProgress = true;

//Блокируем игрока
disableuserinput true;disableuserinput true;disableuserinput true;

//["SVD",2500,"СВД","buy"]
_item = THIS0;
_price = THIS1;
_textPart = THIS2;
_buy_or_sell = THIS3;

if(_buy_or_sell == "buy") then {
	/* ПОКУПКА */
	if (!isNull unitBackpack player) exitWith {cutText ["Слот для сумки занят.", "PLAIN DOWN"];};
	
	_removed = [player, _price] call SC_fnc_removeCoins;
	if (_removed) then {
		player playActionNow "PutDown";
		removeBackpack player;
		player addBackpack _item;
		cutText [format["Куплено %1 за %2 руб.", _textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
	} else {
		_cash = player getVariable ["headShots",0];
		cutText [format["Нужно еще %1 руб.",[_price - _cash] call BIS_fnc_numberText], "PLAIN DOWN"];
	};

} else {
	/* ПРОДАЖА */
	if((typeOf (unitBackpack player)) == _item) then {
		player playActionNow "PutDown";
		removeBackpack player;
		[player, _price] call SC_fnc_addCoins;		
		cutText [format["Продано %1 за %2 руб.",_textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
	};
};

disableuserinput false;disableuserinput false;disableuserinput false;
call finish_old_trade;