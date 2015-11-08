/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
CheckActionInProgress(MSG_BUSY);
call s_player_removeActionsLock;

_object = THIS3;
_objectID = _object getVariable["ObjectID","0"];
_ownerPUID = _object getVariable["ownerPUID","0"];
if (_objectID=="0")exitWith{BreakActionInProgress("Нельзя стать владельцем временного объекта!")};
if (_ownerPUID!="0")exitWith{BreakActionInProgress("Объект уже имеет владельца!")};

PVDZE_upd_Success = nil;

PVDZE_veh_Update = [cursortarget, "takeowner", player];
publicVariable "PVDZE_veh_Update";

cutText ["Запрос отправлен!", "PLAIN DOWN"];

waitUntil {!isNil "PVDZE_upd_Success"};

if (PVDZE_upd_Success)then{
	cutText ["Вы стали владельцем!", "PLAIN DOWN"];
}else{
	cutText ["Ошибка, попробуйте еще чуть позже!", "PLAIN DOWN"];
};
PVDZE_upd_Success = nil;
DZE_ActionInProgress = false;