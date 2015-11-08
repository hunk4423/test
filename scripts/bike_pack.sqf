/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_obj","_nameVehicle","_isOk","_proceed","_brokenTool","_counter","_limit","_isBike","_animState","_started","_finished","_removeTool","_iPos","_materials","_charID","_isLetter","_hitpoints","_skip","_expl_parts","_hit","_chance","_part","_itemId","_itemOut","_countOut","_item","_radius"];

CheckActionInProgress(MSG_BUSY);
player removeAction s_player_packItem;s_player_packItem=-1;

_obj = THIS3;
if(isNull(_obj))exitWith{BreakActionInProgress("Нечего разбирать!")};
if ((count (crew _obj))!=0)exitWith{BreakActionInProgress("Нельзя удалить технику, поскольку в ней люди!")};

_nameVehicle=getText (configFile >> "CfgVehicles" >> (typeOf _obj) >> "displayName");;
if (dayz_combat==1)exitwith{BreakActionInProgress1("Нельзя разбирать %1 в бою!",_nameVehicle)};

if(([_obj,10] call fnc_getNearPlayersCount) >0)exitWith{BreakActionInProgress("Нельзя разбирать в присутствии других игроков ближе 10 метров!")};

_isOk = true;
_proceed = false;
_brokenTool = false;
_counter = 0;
_limit = 3;

_isBike = _obj isKindOf "Bicycle";
if (_isBike) then {_limit = 1};

if (!_isBike)then{
	if !(["ItemCrowbar","ItemToolbox"] call build_checkRequreItems)then{_isOk=false};
};
if (!_isOk)exitWith{DZE_ActionInProgress=false};

cutText [format["Начинаю разбирать %1, двигайтесь для отмены",_nameVehicle], "PLAIN DOWN"];

while {_isOk} do {
	[player,20,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(false);
	if(!_finished) exitWith {_isOk=false;_proceed=false};

	if(_finished) then {
		_counter = _counter + 1;
		if !(_isBike) then {
			if(RND(5))then{_brokenTool=true};
			if !(("ItemToolbox" in items player) && ("ItemCrowbar" in items player))exitWith{_isOk=false;_proceed=false};
		};	
	};
	if(_brokenTool)exitWith{_proceed=false};

	if (_limit>1)then{cutText [format[(localize "str_epoch_player_163"), _nameVehicle, _counter,_limit],"PLAIN DOWN"]};

	if(_counter == _limit)exitWith{_proceed=true};
};

if(_brokenTool)exitWith{
	_removeTool = ["ItemCrowbar","ItemToolbox"] call BIS_fnc_selectRandom;
	if(([player,_removeTool,1] call BIS_fnc_invRemove) > 0) then {
		cutText [format["%1 сломан, невозможно разобрать %2",getText(configFile >> "CfgWeapons" >> _removeTool >> "displayName"),_nameVehicle], "PLAIN DOWN"];
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		DZE_ActionInProgress = false;
	};
};

if (_proceed) then {
	if((count (crew _obj))!=0)exitWith{BreakActionInProgress("Нельзя удалить технику, поскольку в ней люди!")};
	if(!isNull(_obj))then{
		_iPos = getPosATL _obj;
		if (_isBike)then{
			_materials = [_obj] call fnc_GetItemRemoveParts;
		} else {
			_charID=GETVAR(_obj,CharacterID,"0");
			_isLetter=GETVAR(_obj,Letter,false);
			if!(_charID != "0")then{
				_materials=[];
				_hitpoints = _obj call vehicle_getHitpoints;
				_skip = ["HitLMWheel","HitRMWheel","HitLF2Wheel","HitRF2Wheel"];
				_expl_parts = ["HitEngine","HitFuel"];
				if(_isLetter)then{_chance = 5;}else{_chance = 10;};
				{
					if !(_x in _skip) then {
						_hit = [_obj,_x] call object_getHit;
						if (_x in _expl_parts && (_hit > 0.79)) then {_hit = 1};
						if (_hit < 1) then {
							if!(ceil (random ((1 - _hit) * _chance)) == 1)then{
								call{
									if(["Engine",_x,false] call fnc_inString)exitWith{_part="PartEngine"};
									if(["HRotor",_x,false] call fnc_inString)exitWith{_part="PartVRotor";};
									if(["Fuel",_x,false] call fnc_inString)exitWith{_part="PartFueltank"};
									if(["Wheel",_x,false] call fnc_inString)exitWith{_part="PartWheel"};
									if(["Glass",_x,false] call fnc_inString)exitWith{_part="PartGlass"};
									_part = "PartGeneric";
								};
								_materials = _materials + [[2,_part,1]];
							};
						};
					};
				} count _hitpoints;
			};
		};
		//Удалить из базы
		[GetObjID(_obj),GetObjUID(_obj),player] call fnc_serverDeleteObject;
		deleteVehicle _obj;

		if (_iPos select 2 < 0)then{_iPos set [2,0]};
		_radius = 1;
		if((count _materials) > 0)then{
			_item = createVehicle ["WeaponHolder",_iPos,[],_radius,"CAN_COLLIDE"];
			{
				EXPLODE3(_x,_itemId,_itemOut,_countOut);
				if (typeName _countOut == "ARRAY") then {_countOut = round((random (SEL1(_countOut))) + (SEL0(_countOut)))};
				switch(_itemId)do{
				case 1 : {_item addWeaponCargoGlobal [_itemOut,_countOut];};
				case 2 : {_item addMagazineCargoGlobal [_itemOut,_countOut];};
				case 3 : {_item addBackpackCargoGlobal [_itemOut,_countOut];};
				};
			} count _materials;

			_item setposATL _iPos;
			player reveal _item;
			player action ["Gear",_item];
		};
		cutText ["Техника успешно разобрана.", "PLAIN DOWN"];
	} else {
		cutText [(localize "str_epoch_player_91"), "PLAIN DOWN"];
	};
} else {
	r_interrupt = false;
	cutText ["Действие отменено.", "PLAIN DOWN"];
	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
	};
};

DZE_ActionInProgress = false;