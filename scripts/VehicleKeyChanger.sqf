/***********************************/ 	
/* Vehicle Key Changer v1.6.0      */
/* Written by OtterNas3            */
/* January, 11, 2014               */
/* Last update: 26/02/2015         */
/* Advanced by BlackGoga           */
/***********************************/
#include "defines.h"
private ["_abort","_vkc_claimKeyPrice","_vkc_changeKeyPrice","_i","_j","_max","_actionArray","_vehicle","_targetVehicleID","_targetVehicleUID","_temp_keys","_targetKey","_ownerID","_keys_names","_carKeyName","_typeOfTargetVehicle","_targetVehiclePos","_targetVehicleDir","_carName","_animState","_started","_keyNumber","_keySelected","_needed","_keyIsAdded","_keyIsOK","_keyName","_keyID","_finished"];

/* Remove the Action Menu entry */
player removeAction s_player_changeKey;
s_player_changeKey = 1;
player removeAction s_player_claimKey;
s_player_claimKey = 1;

//config
_vkc_claimKeyPrice = 0; // Цена создания ключа
_vkc_changeKeyPrice = "ItemSodaSmasht"; // Цена смены ключа

/* Get the array and setup the variables */
_actionArray = _this select 3;
_vehicle = _actionArray select 0;
_targetVehicleID = _vehicle getVariable ["ObjectID","0"];
_targetVehicleUID = _vehicle getVariable ["ObjectUID","0"];
/* Check if the Vehicle is in the Database, if false exit */
if (_targetVehicleID == "0" && _targetVehicleUID == "0") exitWith {cutText ["Временные объекты не поддерживаются!","PLAIN",0];s_player_changeKey = -1;s_player_claimKey = -1;};
_temp_keys = _actionArray select 1;
_ownerID = _actionArray select 2;
_keys_names = _actionArray select 3;
_targetKey = _actionArray select 4;
if(isNil "_targetKey")exitwith{cutText ["Ошибка, попробуйте позже.", "PLAIN DOWN"];};
_abort=false;
if((CurrAdminLevel<1))then{_abort=!([_vkc_changeKeyPrice]call player_checkItems);};
if(_abort)exitwith{cutText ["Для смены ключа нужен донат-предмет.", "PLAIN DOWN"];}; 

if (_ownerID != "0") then { // Убрать из списков ключ цели
	_carKeyName = (_keys_names select (parseNumber _ownerID));
	_temp_keys = _temp_keys-[_ownerID];
};	

_typeOfTargetVehicle = typeOf _vehicle;
_targetVehiclePos = getPosATL _vehicle;
_targetVehicleDir = getDir _vehicle;
_carName = getText (configFile >> "CfgVehicles" >> _typeOfTargetVehicle >> "displayName");

/* Just in case it is a just bought vehicle and does not yet have a ObjectUID variable set */
if (_targetVehicleUID == "0") then {
	_targetVehicleUID = "";
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_targetVehicleUID = _targetVehicleUID + str(round(_x));
	} forEach _targetVehiclePos;
	_targetVehicleUID = _targetVehicleUID + str(round(_targetVehicleDir + time));
	_vehicle setVariable["ObjectUID",_targetVehicleUID,true];
};

/* Setup the Key Names list to select from */
/* Setup the Key Numbers list to select from */
keyNameList = [];
keyNumberList = [];
for "_i" from 0 to (count _temp_keys) -1 do {
	_J = _temp_keys select _i;
	keyNumberList set [(count keyNumberList), _J];
	keyNameList set [(count keyNameList), (_keys_names select (parseNumber _J))];
};

/* Resetting menu variables*/
keyNameSelect = "";
keyColorSelect = "";
exitscript = true;
closeMenu1 = false;
closeMenu2 = false;
snext = false;

/* Creating the menu */
changeKeyMenu = {
	private ["_keyMenu","_keyArray"];
	_keyMenu = [["",true], [format["Выберите новый ключ для %1-%2-%3<:",(_this select 2),(_this select 3),(_this select 4)],[-1],"",-5,[["expression",""]],"1","0"]];
	for "_i" from (_this select 0) to (_this select 1) do {
		_keyArray = [format['%1',keyNameList select (_i)],[_i-(_this select 0)+2],"",-5,[["expression",format ["keyNameSelect=keyNameList select %1;keyNumberSelect=keyNumberList select %1",_i]]],"1","1"];
		_keyMenu set [_i + 2, _keyArray];
	};
	_keyMenu set [(_this select 1) + 2, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];
	if (count keyNameList > (_this select 1)) then {
		_keyMenu set [(_this select 1) + 3, ["Next", [12], "", -5, [["expression", "snext = true;"]], "1", "1"]];
	} else {
		_keyMenu set [(_this select 1) + 3, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];
	};
	_keyMenu set [(_this select 1) + 4, ["Выход", [13], "", -5, [["expression", "keyNameSelect='exitscript';"]], "1", "1"]];
	showCommandingMenu "#USER:_keyMenu";
};

claimKeyMenu = {
	private ["_keyColorMenu"];
	_keyColorMenu = [["",true], [format["Выберите цвет ключа для %1:",(_this select 0)],[-1],"",-5,[["expression", ""]],"1","0"],
		["Зеленый", [2], "", -5, [["expression", "keyColorSelect = 'ItemKeyGreen';"]], "1", "1"],
		["Красный", [3], "", -5, [["expression", "keyColorSelect = 'ItemKeyRed';"]], "1", "1"],
		["Синий", [4], "", -5, [["expression", "keyColorSelect = 'ItemKeyBlue';"]], "1", "1"],
		["Желтый", [5], "", -5, [["expression", "keyColorSelect = 'ItemKeyYellow';"]], "1", "1"],
		["Черный", [6], "", -5, [["expression", "keyColorSelect = 'ItemKeyBlack';"]], "1", "1"],
		["", [], "", -5, [["expression", ""]], "1", "0"],
		["Выход", [13], "", -5, [["expression", "keyColorSelect = 'exitscript';"]], "1", "1"]];
	showCommandingMenu "#USER:_keyColorMenu";
};

/* Wait for the player to select a Key for change or Key color for claiming from the list */
_j = 0;
_max = 10;
if (isNil "s_player_openMenu") then {s_player_openMenu = 0;};
while {keyNameSelect == "" && keyColorSelect == ""} do {
	if (_targetKey != "0") then {
		[_j, (_j + _max) min (count keyNameList),_carName,(count keyNameList),(count keyNumberList)] call changeKeyMenu;
		_j = _j + _max;
	} else {
		[_carName] spawn claimKeyMenu;
	};
	if (s_player_openMenu == 0) then {
		s_player_openMenu = 1;
		closeMenu2 = true;
		waitUntil {keyNameSelect != "" || keyColorSelect != "" || closeMenu1 || snext};
		if (closeMenu1) then {
			breakOut "exit";
		};
		snext = false;
	} else {
		s_player_openMenu = 0;
		closeMenu1 = true;
		closeMenu2 = false;
		waitUntil {keyNameSelect != "" || keyColorSelect != "" || closeMenu2 || snext};
		if (closeMenu2) then {
			breakOut "exit";
		};
		snext = false;
	};
};

/* Player selected a Key or new Key was generated when a vehicle is claimed, lets make the Vehicle update call */
if (keyNameSelect != "exitscript" && keyColorSelect != "exitscript") then
{
	if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_96") , "PLAIN DOWN"] };
	DZE_ActionInProgress = true;

	_finish_key = {
		s_player_changeKey = -1;
		s_player_claimKey = -1;
		s_player_openMenu = 0;
		DZE_ActionInProgress = false;
	};

	[player,20,true,(getPosATL player)] spawn player_alertZombies; // Alert nearby zombies
	[1,1] call dayz_HungerThirst; // Use some hunger and thirst to perform the action
	player playActionNow "Medic";

	cutText [format["Делаю ключи для %1. Двигайтесь для отмены.", _carName], "PLAIN DOWN"];

	ANIMATION_MEDIC(true);
	if (!_finished)exitwith{};
	
	if (_finished) then {
		if (keyColorSelect != "") then {// Захват ничейного транспорта
			// теперь новый ключ
			_keySelected=[keyColorSelect] call fnc_GenerateVehicleKey;
			_keyIsAdded = [player,_keySelected] call BIS_fnc_invAdd;
			_keyIsOK = isClass(configFile >> "CfgWeapons" >> _keySelected);
			_keyName = getText(configFile >> "CfgWeapons" >> _keySelected >> "displayName");
			_keyID = getNumber(configFile >> "CfgWeapons" >> _keySelected >> "keyid");

			if (_keyIsAdded && _keyIsOK) then {
				keyNameSelect = format["%1", _keyName];
				keyNumberSelect = format["%1", _keyID];
				systemChat (format["%1 добавлен на пояс.", _keyName]);
			} else {
				cutText ["На поясе нет места, операция отменена!", "PLAIN DOWN"];
				if (_vkc_claimKeyPrice != 0) then {
					[player, _vkc_claimKeyPrice] call SC_fnc_addCoins;
				};
				call _finish_key;
				breakOut "exit";
			};
		}else{
			// оплата смены ключа
			if((CurrAdminLevel<1))then{
				if !([_vkc_changeKeyPrice] call player_checkAndRemoveItems) then {
					call _finish_key;
					cutText ["Для смены ключа нужен донат-предмет.", "PLAIN DOWN"];
					breakOut "exit";
				};
			};
		};

		/* Lock the vehicle */
		_vehicle setVehicleLock "LOCKED";
		
		/* This calls the custom update function which we put it in server_updateObject.sqf */
		PVDZE_vkc_Success = 0;
//		publicVariableServer "PVDZE_vkc_Success";
		PVDZE_veh_Update = [_vehicle, "vehiclekey", player, keyNumberSelect]; 
		publicVariableServer "PVDZE_veh_Update";

		// Ожидаем сервер
		cutText["~~ Ожидание сервера ~~","PLAIN",1];
		waitUntil {PVDZE_vkc_Success!=0};

		/* Inform the player about the success and tell him to check the Key */
		if (PVDZE_vkc_Success==1) then {
			if (_targetKey == "0") then {
				cutText["~~ Создание ключа выполнено успешно ~~","PLAIN",1];
				if (_vkc_claimKeyPrice != 0) then {
					systemChat (format["Сделан ключ для %1 за %2 %3.",_carName,_vkc_claimKeyPrice,CurrencyName]);
				} else {
					systemChat (format["Сделан ключ для %1.", _carName]);
				};
				systemChat (format["Теперь %1 использует ключ %2!", _carName, _keyName]);
			}else{
				/* Remove the Key from the Toolbelt of the player and put it in the Backpack - No Backpack and the Key gets lost */
				if (!isNull (unitBackpack player)) then {
					// TODO Нужна проверка на свободное место в рюкзаке, иначе ключ пропадет
					[player, _targetKey, 1] call BIS_fnc_invRemove;
					(unitBackpack (vehicle player)) addWeaponCargoGlobal [_targetKey, 1];
					systemChat (format["%1 перемещен в рюкзак.", _carKeyName]);
				};
				cutText["~~ Смена ключа выполнена успешно ~~","PLAIN",1];
				systemChat (format["Выпонена замена %1 на %2.", _carKeyName, keyNameSelect]);
				systemChat (format["Проверьте работу ключа %1 прежде чем выкинуть ключ %2!", keyNameSelect, _carKeyName]);
			};

			/* This updates the Vehicle as it is now, position, gear, damage, fuel */
			/* Should prevent the "backporting" some dudes reported. */
			/* Just fyi i never had that but just in case... */
			[nil,nil,nil,_vehicle] execVM "\z\addons\dayz_code\actions\forcesave.sqf";
		} else {
			/* Something went wrong, inform the player and refund the costs */
			if (_ownerID == "0") then {
				cutText["~~ Создание ключа не удалось ~~","PLAIN",1];
				systemChat ("Что-то пошло не так на сервере.");
				systemChat ("Попробуйте позже или обратитесь к администратору!");
				[player, _keySelected, 1] call BIS_fnc_invRemove;
				systemChat (format["%1 удален.", _keyName]);
				if (_vkc_claimKeyPrice != "0") then {
					[player, _vkc_claimKeyPrice] call SC_fnc_addCoins;
					systemChat (format["Возвращено %1 %2.",_vkc_claimKeyPrice,CurrencyName]);
				};
			}else{
				cutText["~~ Смена ключа не удалась ~~","PLAIN",1];
				systemChat ("Что-то пошло не так на сервере.");
				systemChat ("Попробуйте позже или обратитесь к администратору!");
				if (_vkc_changeKeyPrice != "") then {
					player addMagazine _vkc_changeKeyPrice;
					systemChat "Донат-предмет возвращен.";
				};
			};
		};
	};
};

/* Reset the action menu variables for a new run */
s_player_changeKey = -1;
s_player_claimKey = -1;
s_player_openMenu = 0;
DZE_ActionInProgress = false;