/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_buy_or_sell","_item","_textPart","_price","_tradeCounter","_abort","_msg","_config","_wepType","_isToolBelt","_isBinocs","_wp","_secondaryWeapon","_removed","_cash"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_103") , "PLAIN DOWN"];};
DZE_ActionInProgress = true;

//Блокируем игрока
disableuserinput true;disableuserinput true;disableuserinput true;

//["SVD",2500,"СВД","buy"]
_item = THIS0;
_price = THIS1;
_textPart = THIS2;
_buy_or_sell = THIS3;

_abort = false;

/* ПОКУПКА */
if(_buy_or_sell == "buy") then {
	_msg = "Оружейный слот занят.";
	_config = (configFile >> "CfgWeapons" >> _item);
	_wepType = getNumber(_config >> "Type");
	_isToolBelt = false;
	_isBinocs = false;
	_wp = weapons player;
	
	switch (_wepType) do {
		case 1 : {_abort = ((primaryWeapon player) != "");};
		case 2 : {
			_secondaryWeapon = "";
			{
				if ((getNumber (configFile >> "CfgWeapons" >> _x >> "Type")) == 2) exitWith {
						_secondaryWeapon = _x;
				};
			} forEach _wp;
			_abort = (_secondaryWeapon != "");
		};
		case 131072 : {_isToolBelt = true;};
		case 4096 : {_isBinocs = true;};
	};
	
	if(_isToolBelt or _isBinocs) then {
		_abort = _item in _wp;
		_msg = "Этот предмет у вас уже есть.";
	};
	
	if (_abort) exitWith {cutText [_msg, "PLAIN DOWN"];};

	//Покупаем
	_removed = [player, _price] call SC_fnc_removeCoins;
	if (_removed) then {
		player playActionNow "PutDown";
		player addWeapon _item;
		cutText [format["Куплено %1 за %2 руб.", _textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
	} else {
		_cash = player getVariable ["headShots",0];
		cutText [format["Нужно еще %1 руб.",[_price - _cash] call BIS_fnc_numberText], "PLAIN DOWN"];
	};
	
} else {
	/* ПРОДАЖА */
	_removed = [player,_item,1] call BIS_fnc_invRemove;
	if(_removed == 1) then {
		player playActionNow "PutDown";
		[player, _price] call SC_fnc_addCoins;
		cutText [format["Продано %1 за %2 руб.", _textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
	};
};

disableuserinput false;disableuserinput false;disableuserinput false;
call finish_old_trade;