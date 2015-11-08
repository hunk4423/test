#include "defines.h"
PVT3(_pos,_toRemove,_friends);
_pos = THIS0;
if (_pos<0)exitWith{};
_toRemove=SEL(Friends,_pos);
_friends=GETVAR(TheDoor,friends,[]);
_newList=[];
{
	if(SEL0(_x)!=SEL0(_toRemove))then{
		_newList=_newList+[_x];
	};
} count _friends;
SETVARS(TheDoor,friends,_newList);
PVDZE_veh_Update = [TheDoor,"gear"];
publicVariableServer "PVDZE_veh_Update";
systemChat format["Игрок %1 удален из доступа к этой двери",SEL1(_toRemove)];
call fnc_updDoorList;