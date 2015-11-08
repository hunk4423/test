/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT4(_evacCallerID,_evacCallerUID,_evacFields,_evacFieldID);
waitUntil {!isNil "dayz_animalCheck"};
waitUntil {!isNil "PVDZE_EvacChopperFields"};
_evacFields = PVDZE_EvacChopperFields;
_evacCallerID = GETVAR(player,CharacterID,0);
_evacCallerUID = ([player] call ON_fnc_convertUID);
if ((count _evacFields) > 0) then
{
	{
		_evacFieldID=GETVAR(_x,CharacterID,0);
		if (_evacCallerID==_evacFieldID || _evacCallerUID==_evacFieldID) then {
			playerHasEvacField=true;
			playersEvacField=_x;
		};
	} forEach _evacFields;
};