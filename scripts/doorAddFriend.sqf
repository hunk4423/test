#include "defines.h"
PVT3(_pos,_inList,_removed);
_pos=THIS0;
if (_pos<0)exitWith{};
_toAdd=SEL(Humans,_pos);
_friends=GETVAR(TheDoor,friends,[]);
_inList = false;
{if (SEL0(_x)==SEL0(_toAdd)) exitWith {_inList=true;};} count _friends;
if (_inList)exitWith{cutText ["Игрок уже есть в списке","PLAIN DOWN"];};
if (CNT(_friends)==10)exitWith{cutText ["Ограничение 10 игроков","PLAIN DOWN"];};
_removed=[player,10000] call SC_fnc_removeCoins;
if !(_removed)exitWith{cutText ["Не достаточно средств.","PLAIN DOWN"];};
_friends=_friends+[_toAdd];
SETVARS(TheDoor,friends,_friends);
PVDZE_veh_Update=[TheDoor,"gear"];
publicVariableServer "PVDZE_veh_Update";

call fnc_updDoorList;