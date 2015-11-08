/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_location","_dir","_classname","_missing","_text","_proceed","_num_removed","_object","_missingQty","_itemIn","_countIn","_qty","_removed","_removed_total","_tobe_removed_total","_objectID","_objectUID","_temp_removed_array","_textMissing","_newclassname","_requirements","_obj","_upgrade","_lockable","_combination_1","_combination_2","_combination_3","_combination","_objectCharacterID","_canBuildOnPlot","_needText","_findNearestPoles","_started","_finished","_animState","_isMedic"];

CheckActionInProgressLocalize(str_epoch_player_52);

player removeAction s_player_upgrade_build;s_player_upgrade_build = -1;

_obj = THIS3;
_objectID = GetObjID(_obj);
_objectUID = GetObjUID(_obj);

_needText = localize "str_epoch_player_246";

// check for near plot
_findNearestPoles = getNearPlots(_obj,PLOT_RADIUS);
_canBuildOnPlot = false;
if(CNT(_findNearestPoles) == 0) then {
	_canBuildOnPlot = true;
} else {
	// check nearby plots ownership && then for friend status
	_canBuildOnPlot=[dayz_playerUID,BUILD_ACCESS,_findNearestPoles] call fnc_checkObjectsAccess;
};

// exit if not allowed due to plot pole
if(!_canBuildOnPlot) exitWith {BreakActionInProgressLocalize2(str_epoch_player_157,_needText,PLOT_RADIUS)};

if(_objectID == "0" && _objectUID == "0") exitWith {BreakActionInProgressLocalize(str_epoch_player_50)};

// Get classname
_classname = typeOf _obj;
// Find display name
_text = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
// Find next upgrade
_upgrade = getArray (configFile >> "CfgVehicles" >> _classname >> "upgradeBuilding");

if (CNT(_upgrade) > 0) then {
	_newclassname = SEL0(_upgrade);
	_lockable = 0;
	if(isNumber (configFile >> "CfgVehicles" >> _newclassname >> "lockable")) then {
		_lockable = getNumber(configFile >> "CfgVehicles" >> _newclassname >> "lockable");
	};
	_requirements = SEL1(_upgrade);
	_missingQty = 0;
	_missing = "";
	_proceed = true;
	{
		EXPLODE2(_x,_itemIn,_countIn);
		_qty = { (_x == _itemIn) || (configName(inheritsFrom(configFile >> "cfgMagazines" >> _x)) == _itemIn) } count magazines player;
		if(_qty < _countIn) exitWith { _missing = _itemIn; _missingQty = (_countIn - _qty); _proceed = false; };
	} forEach _requirements;

	if (_proceed) then {
		[1,1] call dayz_HungerThirst;
		[player,"repair",20,20] call fnc_alertSound;
		ANIMATION_MEDIC(true);
		if (!_finished) exitWith {cutText [(localize "STR_EPOCH_PLAYER_26"), "PLAIN DOWN"];};

		_temp_removed_array = [];
		_removed_total = 0;
		_tobe_removed_total = 0;

		{
			_removed = 0;
			EXPLODE2(_x,_itemIn,_countIn);
			// diag_log format["Recipe Finish: %1 %2", _itemIn,_countIn];
			_tobe_removed_total = _tobe_removed_total + _countIn;

			{
				if( (_removed < _countIn) && ((_x == _itemIn) || configName(inheritsFrom(configFile >> "cfgMagazines" >> _x)) == _itemIn)) then {
					_num_removed = ([player,_x] call BIS_fnc_invRemove);
					_removed = _removed + _num_removed;
					_removed_total = _removed_total + _num_removed;
					if(_num_removed >= 1) then {
						_temp_removed_array set [count _temp_removed_array,_x];
					};
				};
			} forEach magazines player;

		} forEach _requirements;

		// all parts removed proceed
		if (_tobe_removed_total == _removed_total) then {
			_location = _obj getVariable["OEMPos",(getposATL _obj)];
			_dir = getDir _obj;
			_vector = [(vectorDir _obj),(vectorUp _obj)];
			_objectCharacterID 	= GetCharID(_obj);
			_classname = _newclassname;
			// Create new object 
			_object = createVehicle [_classname, [0,0,0], [], 0, "CAN_COLLIDE"];
			_object setDir _dir;
			_object setVectorDirAndUp _vector;
			_object setPosATL _location;
			SETVARS(_object,BuildMove,GETVAR(_obj,BuildMove,false));
			if (_lockable == 3) then {
				_combination_1 = floor(random 10);
				_combination_2 = floor(random 10);
				_combination_3 = floor(random 10);
				_combination = format["%1%2%3",_combination_1,_combination_2,_combination_3];
				_objectCharacterID = _combination;
				cutText [format[(localize "str_epoch_player_158"),_combination,_text], "PLAIN DOWN", 5];
			} else {
				cutText [format[(localize "str_epoch_player_159"),_text], "PLAIN DOWN", 5];
			};
			PVDZE_obj_Swap = [_objectCharacterID,_object,[_dir,_location, _vector],_classname,_obj,player,-1];
			publicVariableServer "PVDZE_obj_Swap";
			player reveal _object;
		} else {
			{player addMagazine _x;} count _temp_removed_array;
			cutText [format[(localize "str_epoch_player_145"),_removed_total,_tobe_removed_total], "PLAIN DOWN"];
		};
	} else {
		_textMissing = getText(configFile >> "CfgMagazines" >> _missing >> "displayName");
		cutText [format[(localize "str_epoch_player_146"),_missingQty, _textMissing], "PLAIN DOWN"];
	};
} else {
	cutText [(localize "str_epoch_player_82"), "PLAIN DOWN"];
};
DZE_ActionInProgress = false;