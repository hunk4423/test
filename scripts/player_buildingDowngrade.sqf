/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_location","_dir","_classname","_text","_object","_objectID","_objectUID","_newclassname","_refund","_obj","_upgrade","_objectCharacterID","_canBuildOnPlot","_ownerUID","_ownerName","_needText","_i","_invResult","_itemOut","_countOut","_abortInvAdd","_addedItems","_playerUID","_started","_finished","_animState","_isMedic"];

CheckActionInProgressLocalize(str_epoch_player_48);

// get cursortarget from addaction
_obj = THIS3;

player removeAction s_player_downgrade_build;s_player_downgrade_build = -1;

_needText = localize "str_epoch_player_246";
_playerUID = getPlayerUID player;

// check nearby plots ownership && then for friend status
_canBuildOnPlot=[dayz_playerUID,BUILD_ACCESS,getNearPlots(_obj,PLOT_RADIUS)] call fnc_checkObjectsAccess;

// exit if not allowed due to plot pole
if(!_canBuildOnPlot)exitWith{BreakActionInProgressLocalize2(str_epoch_player_141,_needText,PLOT_RADIUS)};

// Current charID
_objectCharacterID = GetCharID(_obj);
_ownerUID = GetOwnerUID(_obj);
_ownerName = GetOwnerName(_obj);
_objectID 	= GetObjID(_obj);
_objectUID	= GetObjUID(_obj);

if(_objectID == "0" && _objectUID == "0")exitWith{BreakActionInProgressLocalize(str_epoch_player_50)};

// Get classname
_classname = typeOf _obj;
// Find display name
_text = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
// Find next upgrade
_upgrade = getArray (configFile >> "CfgVehicles" >> _classname >> "downgradeBuilding");

if (CNT(_upgrade) > 0) then {
	_newclassname = SEL0(_upgrade);
	_refund = _upgrade select 1;
	[1,1] call dayz_HungerThirst;
	[player,"repair",20,20] call fnc_alertSound;
	ANIMATION_MEDIC(true);

	if (!_finished) exitWith {cutText [(localize "STR_EPOCH_PLAYER_26"), "PLAIN DOWN"];};
	_invResult = false;
	_abortInvAdd = false;
	_i = 0;
	_addedItems = [];

	{
		EXPLODE2(_x,_itemOut,_countOut);

		for "_x" from 1 to _countOut do {
			_invResult = [player,_itemOut] call BIS_fnc_invAdd;
			if(!_invResult) exitWith {
				_abortInvAdd = true;
			};
			if(_invResult) then {
				_i = _i + 1;
				_addedItems set [(count _addedItems),[_itemOut,1]];
			};
		};

		if (_abortInvAdd) exitWith {};

	} count _refund;

	// all parts added proceed
	if(_i != 0) then {
		_location=GETVAR(_obj,OEMPos,(getposATL _obj));
		_dir = getDir _obj;
		_vector = [(vectorDir _obj),(vectorUp _obj)];
		// Reset the character ID on locked doors before they inherit the newclassname
		if (_classname in DZE_DoorsLocked) then {
			SetCharID(_obj,dayz_characterID);
			_objectCharacterID = dayz_characterID;
		};
		_classname = _newclassname;
		// Create new object
		_object = createVehicle [_classname,[0,0,0],[],0,"CAN_COLLIDE"];
		_object setDir _dir;
		_object setVectorDirAndUp _vector;
		_object setPosATL _location;
		SetOwnerUID(_object,_ownerUID);
		SetOwnerName(_object,_ownerName);
		SETVARS(_object,BuildMove,GETVAR(_obj,BuildMove,false));

		//diag_log format["Player_buildingdowngrade: [newclassname: %1] [_ownerUID: %2] [_objectCharacterID: %2]",_newclassname, _ownerUID, _objectCharacterID];
		cutText [format[(localize "str_epoch_player_142"),_text], "PLAIN DOWN", 5];
		PVDZE_obj_Swap = [_objectCharacterID,_object,[_dir,_location,_vector],_classname,_obj,player,-1];
		publicVariableServer "PVDZE_obj_Swap";
		player reveal _object;
	} else {
		cutText [format[(localize "str_epoch_player_143"), _i,(getText(configFile >> "CfgMagazines" >> _itemOut >> "displayName"))], "PLAIN DOWN"];
		{
			[player,SEL0(_x),SEL1(_x)] call BIS_fnc_invRemove;
		} count _addedItems;
	};
} else {
	cutText [(localize "str_epoch_player_51"), "PLAIN DOWN"];
};

DZE_ActionInProgress = false;