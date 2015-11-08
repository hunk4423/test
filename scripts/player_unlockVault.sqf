/*
	DayZ Lock Safe
	Usage: [_obj] spawn player_unlockVault;
	Made for DayZ Epoch please ask permission to use/edit/distrubute email vbawol@veteranbastards.com.
*/
#include "defines.h"

private ["_objectID","_objectUID","_obj","_ownerUID","_ownerName","_dir","_pos","_holder","_weapons","_magazines","_backpacks","_objWpnTypes","_objWpnQty","_countr","_alreadyPacking","_playerNear","_playerID","_claimedBy","_unlockedClass","_text","_nul","_objType","_characterID","_friends","_comment"];


CheckActionInProgressLocalize(str_epoch_player_21);

{player removeAction _x} count s_player_combi;s_player_combi = [];s_player_unlockvault=-1;
player removeAction s_player_safeManagement;s_player_safeManagement = -1;

_obj = _this;
_objType = typeOf _obj;

if (!(_objType in DZE_LockedStorage)) exitWith {DZE_ActionInProgress = false};

_playerNear = _obj call dze_isnearest_player;
if(_playerNear) exitWith {BreakActionInProgressLocalize(str_epoch_player_20)};

// Silently exit if object no longer exists || alive
if(isNull _obj || !(alive _obj)) exitWith { DZE_ActionInProgress = false};

_unlockedClass = getText (configFile >> "CfgVehicles" >> _objType >> "unlockedClass");
_text = getText (configFile >> "CfgVehicles" >> _objType >> "displayName");

_alreadyPacking = GETVAR(_obj,packing,0);
_claimedBy = GETVAR(_obj,claimed,"0");
_characterID = GetCharID(_obj);
_ownerUID = GetOwnerUID(_obj);
_ownerName = GetOwnerName(_obj);
_comment=GetComment(_obj);
_friends=_obj getVariable ["friends",[]];

if (_alreadyPacking == 1) exitWith {DZE_ActionInProgress = false; cutText [format[(localize "str_epoch_player_124"),_text], "PLAIN DOWN"]};

// Promt user for password if _ownerUID != dayz_playerUID
if ((_characterID == dayz_combination) || ([dayz_playerUID,SOPEN_ACCESS,_obj] call fnc_checkObjectsAccess)) then {

	// Check if any players are nearby if not allow player to claim item.
	_playerNear = {isPlayer _x} count (player nearEntities ["CAManBase", 6]) > 1;
	_playerID = getPlayerUID player;

	// Only allow if not already claimed.
	if (_claimedBy == "0" || !_playerNear) then {
		// Since item was not claimed proceed with claiming it.
		SETVARS(_obj,claimed,_playerID);
	};

	_dir = direction _obj;
	_vector = [(vectorDir _obj), (vectorUp _obj)];
	_pos = GETVAR(_obj,OEMPos,(getposATL _obj));
	_objectID = GetObjID(_obj);
	_objectUID = GetObjUID(_obj);
	_claimedBy = GETVAR(_obj,claimed,"0");

	if (_claimedBy == _playerID) then {

		if(!isNull _obj && alive _obj) then {

			[1,1] call dayz_HungerThirst;
			[player,"tentpack",0,false] call dayz_zombieSpeak;
			ANIMATION_MEDIC(false);
			if (_finished)then{
				PVDZE_log_lockUnlock = [player, _obj, false];
				publicVariableServer "PVDZE_log_lockUnlock";

				SETVARS(_obj,packing,1);
				_weapons =		GETVAR(_obj,WeaponCargo,[]);
				_magazines =	GETVAR(_obj,MagazineCargo,[]);
				_backpacks =	GETVAR(_obj,BackpackCargo,[]);
				_holder = createVehicle [_unlockedClass,_pos,[], 0, "CAN_COLLIDE"];
				// Remove locked vault
				deleteVehicle _obj;
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
				SETVARS(_holder,friends,_friends);
				SetComment(_holder,_comment);

				if (count _weapons > 0) then {
					//Add weapons
					_objWpnTypes = SEL0(_weapons);
					_objWpnQty = SEL1(_weapons);
					_countr = 0;
					{
						_holder addweaponcargoGlobal [_x,(_objWpnQty select _countr)];
						_countr = _countr + 1;
					} count _objWpnTypes;
				};

				if (count _magazines > 0) then {
					//Add Magazines
					_objWpnTypes = SEL0(_magazines);
					_objWpnQty = SEL1(_magazines);
					_countr = 0;
					{
						if( _x != "CSGAS" ) then
						{
							_holder addmagazinecargoGlobal [_x,(_objWpnQty select _countr)];
							_countr = _countr + 1;
						};
					} count _objWpnTypes;
				};

				if (count _backpacks > 0) then {
					//Add Backpacks
					_objWpnTypes = SEL0(_backpacks);
					_objWpnQty = SEL1(_backpacks);
					_countr = 0;
					{
						_holder addbackpackcargoGlobal [_x,(_objWpnQty select _countr)];
						_countr = _countr + 1;
					} count _objWpnTypes;
				};
				cutText [format[(localize "str_epoch_player_125"),_text], "PLAIN DOWN"];
				UpdateAccess(_holder);
			};
		};
	} else {
		DZE_ActionInProgress = false; 
		cutText [format[(localize "str_player_beinglooted"),_text] , "PLAIN DOWN"];
	};
} else {
	[10,10] call dayz_HungerThirst;
	[player,"repair",0,false] call dayz_zombieSpeak;
	[player,25,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(false);
	if (_finished)then{
		cutText [format[(localize "str_epoch_player_126"),_text], "PLAIN DOWN"];
	};
};
s_player_unlockvault = -1;
DZE_ActionInProgress = false;
