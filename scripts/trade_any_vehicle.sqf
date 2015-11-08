/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_temp","_buy_or_sell","_item","_textPart","_price","_finished","_cash","_isBike","_abortS","_keySelected","_tCharID","_tID","_isKeyOK","_isOk","_removed","_helipad","_location","_veh","_obj","_charID","_hitpoints","_objectID","_objectUID","_hasKey","_type","_animState","_started","_isMedic"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_103") , "PLAIN DOWN"];};
DZE_ActionInProgress = true;

//["SVD",2500,"СВД","buy"]
_item = THIS0;
_price = THIS1;
_textPart = THIS2;
_buy_or_sell = THIS3;

_isBike=((_item isKindOf "Bicycle")||(_item in TempVehicles));
_temp=_item in TempVehicles;

cutText [(localize "str_epoch_player_105"), "PLAIN DOWN"];

ANIMATION_MEDIC(false);

if (_finished) then {
	if(_buy_or_sell == "buy") then {
		/* ПОКУПКА */
		//Проверяем, хватает ли денег до выдачи ключей
		_cash = GetCash(player)+GetBank(player);
		if (_cash < _price) exitWith {cutText [format["Нужно еще %1 руб.",[_price - _cash] call BIS_fnc_numberText], "PLAIN DOWN"];};
		
		if !(_isBike) then {
			//Генерируем уникальный ключ
			_keySelected=["Random"] call fnc_GenerateVehicleKey;
			_isKeyOK = _keySelected != "";
			
			//Проверяем ключик, добовляем в инвентарь
			_isKeyOK = 	isClass(configFile >> "CfgWeapons" >> _keySelected);
			_isOk = [player,_keySelected] call BIS_fnc_invAdd;
			_type = false;
			waitUntil {!isNil "_isOk"};
		} else {
			_isKeyOK = true;
			_isOk = true;
			_keySelected = dayz_characterID;
			if(_temp)then{_type=true;}else{_type=false;};
		};
		
		//Проверяем что ключ добавлен
		if (_isOk && _isKeyOK) then {
			//Снимаем плату
			_removed = [player, _price] call fnc_Payment;
			if !(SEL0(_removed)) exitWith {
				[player,_keySelected] call BIS_fnc_invRemove;
				_cash = SEL1(_removed);
				cutText [format["Нужно еще %1 руб.",[_price - _cash] call BIS_fnc_numberText], "PLAIN DOWN"];
			};
			
			//Выбираем место
			_helipad = nearestObjects [player,DZE_GaragePad, 100];
			if(count _helipad > 0) then {
				_location = (getPosATL (_helipad select 0));
			} else {
				_location = [(position player),0,20,1,0,2000,0] call BIS_fnc_findSafePos;
			};
			
			//Спавним
			_veh = createVehicle ["Sign_arrow_down_large_EP1", _location, [], 0, "CAN_COLLIDE"];
			PVDZE_veh_Publish2 = [_veh,[round(random 360),getPosATL _veh],_item,_type,_keySelected,player,1];
			publicVariableServer  "PVDZE_veh_Publish2";
			
			//Сообщения
			if !(_isBike) then {
				cutText [format["Куплено: %1 за %2 руб. Ключ добавлен на пояс.",_textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
			} else {
				cutText [format["Куплено: %1 за %2 руб.",_textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
			};
			
			{player reveal _x;} forEach (player nearObjects ['All',50]);
		} else {
			player removeMagazine _keySelected;
			cutText [(localize "str_epoch_player_107"), "PLAIN DOWN"];
		};
		
	} else {
		/* ПРОДАЖА */
			
		//проверка есть ли тачка
		_obj = nearestObjects [(getPosATL player), [_item], 40];
		_obj = _obj select 0;		
		if (isNil "_obj") exitWith {cutText ["Техника не обнаружена.", "PLAIN DOWN"];};
		if(GETVAR(_obj,taxi,false))exitWith{cutText ["Нельзя продать вертолёт такси! О багоюзе будет сообщено администрации или признайтесь сами", "PLAIN DOWN"];};

		//проверка есть ли ключ от машины
		_charID = GetCharID(_obj);
		_hasKey = (parseNumber _charID) > 0;
		_isKeyOK = false;
		
		if (_hasKey) then {
			_ownerUID = GetOwnerUID(_obj);
			if (_ownerUID == (getPlayerUID player))exitWith{_isKeyOK = true};
			if (([player,_charID] call fnc_isPlayerHaveKey))then{_isKeyOK = true};
		};
		if (_hasKey && !_isBike && !_isKeyOK) exitWith {cutText [format["Для продажи %1, необходим ключ или быть владельцем.",_textPart], "PLAIN DOWN"];};

		//check to make sure vehicle has no more than 75% average tire damage
		_hitpoints = _obj call vehicle_getHitpoints;
		
		if(local _obj and !isNull _obj and alive _obj) then {
			//Вычисляем цену продажи
			_price = [_obj,_price] call Sell_Veh_Price;
			[player, _price] call SC_fnc_addCoins;

			_objectID 	= _obj getVariable ["ObjectID","0"];
			_objectUID	= _obj getVariable ["ObjectUID","0"];

			PVDZE_obj_Delete = [_objectID,_objectUID,player];
			publicVariableServer "PVDZE_obj_Delete";

			deleteVehicle _obj;
			cutText [format["Продано: %1 за %2 руб.",_textPart,[_price] call BIS_fnc_numberText], "PLAIN DOWN"];
		} else {
			cutText [(localize "str_epoch_player_245"), "PLAIN DOWN"];
		};					
	};
};

call finish_old_trade;