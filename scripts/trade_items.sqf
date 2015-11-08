/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_buy_or_sell","_item","_textPart","_price","_tradeCounter","_abort","_emptySlots","_no_free_space","_cash","_removed","_qty","_msg"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_103") , "PLAIN DOWN"];};
DZE_ActionInProgress = true;

//["SVD",2500,"СВД","buy"]
_item = THIS0;
_price = THIS1;
_textPart = THIS2;
_buy_or_sell = THIS3;

_tradeCounter = 0;
_abort = false;

/* ПОКУПКА */
if(_buy_or_sell == "buy") then {

	cutText [(localize "str_epoch_player_105"), "PLAIN DOWN"];
	sleep 0.5;

	//Покупаем
	r_interrupt = false;
	while {true} do {
		//Проверка на сдинулся и на свободное место
		_emptySlots = [player] call BIS_fnc_invSlotsEmpty;
		_no_free_space = ((_emptySlots select 4) < 1);		
		if(r_interrupt || _no_free_space) exitWith {
			if (_no_free_space) then {
				cutText [localize "str_player_24", "PLAIN DOWN"]; //нет места
			} else {
				cutText [(localize "str_epoch_player_106") , "PLAIN DOWN"]; //Сделка отменена
			};
			[objNull, player, rSwitchMove,""] call RE;		
		};
		
		//Покупка
		_removed = [player, _price] call SC_fnc_removeCoins;
		if (_removed) then {
			_tradeCounter = _tradeCounter + 1;
			player addMagazine _item;
			cutText [format["Куплено %1 за %2 рублей. Всего куплено: %3", _textPart,[_price] call BIS_fnc_numberText,_tradeCounter], "PLAIN DOWN"];
		} else {
			_cash = player getVariable ["headShots",0];
			cutText [format["Нужно еще %1 руб.",[_price - _cash] call BIS_fnc_numberText], "PLAIN DOWN"];//не хватает денег
			_abort = true;
		};
		
		if(_abort) exitWith {};
		sleep 1.5;
	};

} else {
	
	/* ПРОДАЖА */
	_qty = {_x == _item} count magazines player;
	_removed = 0;

	if (_qty < 1) exitWith {
		cutText [format["Нет %1 на продажу.",_textPart], "PLAIN DOWN"]; //нет вещи на продажу
	};

	cutText [(localize "str_epoch_player_105"), "PLAIN DOWN"];
	sleep 0.5;
	
	//Продаем
	r_interrupt = false;
	while {true} do {
		//Проверка на сдинулся ли игрок
		if(r_interrupt) exitWith {
			cutText [(localize "str_epoch_player_106") , "PLAIN DOWN"]; //Сделка отменена
			[objNull, player, rSwitchMove,""] call RE;		
		};

		_removed = [player,_item,1] call BIS_fnc_invRemove;
		if (_removed > 0) then {
				_tradeCounter = _tradeCounter + 1;
				[player, _price] call SC_fnc_addCoins;	
				cutText [format["Продано %1 за %2 рублей. Всего продано: %3", _textPart,[_price] call BIS_fnc_numberText,_tradeCounter], "PLAIN DOWN"];
		} else {
			cutText [format["Нет %1 на продажу.",_textPart], "PLAIN DOWN"];
			_abort = true;
		};
	
		if(_abort) exitWith {};
		sleep 1.5;
	};	
};

call finish_old_trade;