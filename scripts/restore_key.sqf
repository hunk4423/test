/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_keyNumberSelect","_new","_keyID","_array","_ownerPUID","_name","_cash","_action","_keySelected","_finished","_isOK"];
CheckActionInProgress(MSG_BUSY);
{player removeAction _x} count s_player_lockunlock;s_player_lockunlock = [];
s_player_lockUnlock_crtl = -1;
_array=THIS3;
EXPLODE2(_array,_object,_action);
_ownerPUID=GETOVAR(ownerPUID,"0");
_name=getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName");
_cash=GetCash(player)+GetBank(player);
if(_cash < 10000)exitWith{BreakActionInProgress("Не достаточно средств. Цена 10,000 руб.");};
if (dayz_playerUID != _ownerPUID)exitWith{BreakActionInProgress1("Вы не являетесь владельцем %1!",_name);};
_new=false;
switch (_action)do{
	case "new": {
		cutText [format["Создаю новый ключ для %1. Стоимость 10,000 рублей. Двигайтесь для отмены.",_name], "PLAIN DOWN"];
		_keySelected=["Random"] call fnc_GenerateVehicleKey;
		_new=true;
	};	
	case "old": {
		cutText [format["Восстанавливаю ключ для %1. Стоимость 10,000 рублей. Двигайтесь для отмены.",_name], "PLAIN DOWN"];
		_keySelected=[parsenumber(GetCharID(_object))] call vehicle_getKeyByCharID;
	};
};
ANIMATION_MEDIC(true);
if(_finished)then{
	_isOK=isClass(configFile >> "CfgWeapons" >> _keySelected);
	if(_isOK)then{
		_isOK=[player,_keySelected] call BIS_fnc_invAdd;
	};
	if(!_isOk)exitWith{cutText[localize "str_epoch_player_107","PLAIN DOWN"]};
	_isOK=[player, 10000] call fnc_Payment;
	if(!SEL0(_isOk))exitWith{
		player removeMagazine _keySelected;
		cutText[([_isOK] call fnc_PaymentResultToStr),"PLAIN DOWN"];
	};
	if(_new)then{
		PVDZE_vkc_Success = nil;

		_keyID = getNumber(configFile >> "CfgWeapons" >> _keySelected >> "keyid");
		_keyNumberSelect = format["%1", _keyID];
		PVDZE_veh_Update = [_object, "vehiclekey", player, _keyNumberSelect]; 
		publicVariableServer "PVDZE_veh_Update";

		waitUntil {!isNil "PVDZE_vkc_Success"};
		if (PVDZE_vkc_Success==1) then {
			cutText ["Новый ключ добавлен на пояс.", "PLAIN DOWN"];
		}else{
			cutText ["Что-то пошло не так, попробуйте позже.", "PLAIN DOWN"];
			[player, 10000] call SC_fnc_addCoins;
			player removeMagazine _keySelected;
		};
	}else{cutText ["Ключ добавлен на пояс.", "PLAIN DOWN"];};
};
DZE_ActionInProgress = false;