/*
	DayZ Lock Safe
	Usage: [_obj] spawn player_lockVault;
	Made for DayZ Epoch please ask permission to use/edit/distrubute email vbawol@veteranbastards.com.
*/
#include "defines.h"

private ["_objectID","_objectUID","_obj","_ownerUID","_ownerName","_dir","_pos","_holder","_weapons","_magazines","_backpacks","_alreadyPacking","_lockedClass","_text","_playerNear","_characterID","_friends","_comment"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_10") , "PLAIN DOWN"]; };
DZE_ActionInProgress = true;

player removeAction s_player_lockvault;s_player_lockvault=-1;
player removeAction s_player_safeManagement;s_player_safeManagement=-1;
_obj = _this;
_objType = typeOf _obj;

_lockedClass = getText (configFile >> "CfgVehicles" >> _objType >> "lockedClass");
_text = getText (configFile >> "CfgVehicles" >> _objType >> "displayName");

// Silently exit if object no longer exists
if(isNull _obj) exitWith {DZE_ActionInProgress=false;};

[1,1] call dayz_HungerThirst;
[player,"tentpack",0,false] call dayz_zombieSpeak;
ANIMATION_MEDIC(false);

if (_finished)then{
	_playerNear = _obj call dze_isnearest_player;
	if(_playerNear) exitWith {DZE_ActionInProgress=false; cutText [(localize "str_epoch_player_11"),"PLAIN DOWN"];};

	_characterID=GetCharID(_obj);
	_objectID=GetObjID(_obj);
	_objectUID=GetObjUID(_obj);
	_ownerUID=GetOwnerUID(_obj);
	_ownerName=GetOwnerName(_obj);
	_comment=GetComment(_obj);
	_friends=_obj getVariable ["friends",[]];

	if((_characterID != dayz_combination) && !([dayz_playerUID,SOPEN_ACCESS,_obj] call fnc_checkObjectsAccess)) exitWith {DZE_ActionInProgress=false; cutText [format[(localize "str_epoch_player_115"),_text], "PLAIN DOWN"];};

	_alreadyPacking = GETVAR(_obj,packing,0);
	if (_alreadyPacking == 1) exitWith {DZE_ActionInProgress=false; cutText [format[(localize "str_epoch_player_116"),_text], "PLAIN DOWN"]};
	SETVARS(_obj,packing,1);

	_dir = direction _obj;
	_vector = [(vectorDir _obj),(vectorUp _obj)];
	_pos = GETVAR(_obj,OEMPos,(getposATL _obj));

	if(!isNull _obj) then {

		PVDZE_log_lockUnlock = [player, _obj,true];
		publicVariableServer "PVDZE_log_lockUnlock";

		//place vault
		_holder = createVehicle [_lockedClass,_pos,[], 0, "CAN_COLLIDE"];
		_holder setdir _dir;
		_holder setVectorDirAndUp _vector;
		_holder setPosATL _pos;
		player reveal _holder;

		SetCharID(_holder,_characterID);
		SetObjID(_holder,_objectID);
		SetObjUID(_holder,_objectUID);
		SETVARS(_holder,OEMPos,_pos);
		SetOwnerUID(_holder,_ownerUID);
		SetOwnerName(_holder,_ownerName);
		SetComment(_holder,_comment);

		SETVARS(_holder,friends,_friends);

		_weapons = getWeaponCargo _obj;
		_magazines = getMagazineCargo _obj;
		_backpacks = getBackpackCargo _obj;

		// remove vault
		deleteVehicle _obj;

		// Fill variables with loot
		_holder setVariable ["WeaponCargo", _weapons, true];
		_holder setVariable ["MagazineCargo", _magazines, true];
		_holder setVariable ["BackpackCargo", _backpacks, true];

		cutText [format[(localize "str_epoch_player_117"),_text], "PLAIN DOWN"];
		UpdateAccess(_holder);
	};
};
DZE_ActionInProgress = false;
