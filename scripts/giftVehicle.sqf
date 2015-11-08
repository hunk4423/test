#include "defines.h"
private ["_object","_objectID","_ownerPUID","_characterID","_playerTo","_playerFrom","_playerFromUID","_playerToUID","_keyavailable","_key","_keySelected","_isKeyOK","_name","_animState","_started","_finished"];
PARAMS2(_object,_playerTo);
_playerFrom = player;

CheckActionInProgress(MSG_BUSY);
call s_player_removeActionsLock;

_objectID =	GetObjID(_object);
_ownerPUID = GetOwnerUID(_object);
_characterID = GetCharID(_object);
_playerFromUID = getPlayerUID _playerFrom;
_playerToUID = getPlayerUID _playerTo;
_name = getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName");

if (_playerFromUID != _ownerPUID)exitWith{BreakActionInProgress1("Вы не являетесь владельцем %1, который дарите!",_name);};

_keyavailable = [_playerFrom,_characterID] call fnc_isPlayerHaveKey;
if (!_keyavailable)exitWith{BreakActionInProgress1("Нельзя подарить %1, не имея от него ключей!",_name);};

_keySelected=["Random"] call fnc_GenerateVehicleKey;

_isKeyOK = 	isClass(configFile >> "CfgWeapons" >> _keySelected);
if (_isKeyOK)then{
	_isKeyOK = [_playerTo,_keySelected] call BIS_fnc_invAdd;
	if (_isKeyOK)then{[_playerTo,_keySelected,1] call BIS_fnc_invRemove;};
};

if (!_isKeyOK)exitWith{BreakActionInProgress("У получателя подарка нет места для нового ключа на поясе.")};

cutText [format["Если %1 имеет восстановления, при подарке, все восстановления аннулируются. Двигайтесь для отмены.",_name], "PLAIN DOWN"];

ANIMATION_MEDIC(false);

if (_finished)then{
	PVDZE_upd_Success = nil;
	cutText [format["Начинаю передачу прав %1 игроку %2, ожидайте...",_name,name _playerTo], "PLAIN DOWN"];

	PVDZE_veh_Update=[_object,"gift",_playerFrom,_playerTo,_keySelected];
	publicVariableServer "PVDZE_veh_Update";

	waitUntil {!isNil "PVDZE_upd_Success"};
	if (PVDZE_upd_Success) then{
		cutText [format["Передача прав на %1 игроку %2 успешно завершена!",_name,name _playerTo], "PLAIN DOWN"]
	}else{
		cutText [format["Ошибка передачи прав на %1 игроку %2!",_name,name _playerTo], "PLAIN DOWN"];
	};
};
DZE_ActionInProgress = false;
