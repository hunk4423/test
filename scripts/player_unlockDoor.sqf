/* Zupa Door Management */
#include "defines.h"
disableSerialization;
if(!isNil "DZE_DYN_UnlockDoorInprogress")exitWith{ cutText [(localize "str_epoch_player_21"),"PLAIN DOWN"];};
DZE_DYN_UnlockDoorInprogress=true;
if(!isNull dayz_selectedDoor) then {
	(findDisplay 41144) closeDisplay 1;
	// our target
	cutText ["Проверка доступа...", "PLAIN DOWN"];
	sleep 2;
	// Check allowed
	if ([dayz_playerUID,DOPEN_ACCESS,dayz_selectedDoor] call fnc_checkObjectsAccess) then {
		DZE_Lock_Door = GETVAR(dayz_selectedDoor,CharacterID,'0');
		// unlock if locked
		cutText ["Доступ разрешен", "PLAIN DOWN"];
		if(dayz_selectedDoor animationPhase "Open_hinge" == 0) then {
			dayz_selectedDoor animate ["Open_hinge",1];
		};
		if(dayz_selectedDoor animationPhase "Open_latch" == 0) then {
			dayz_selectedDoor animate ["Open_latch",1];
		};
	} else {
		cutText ["Доступ запрещен","PLAIN DOWN"];
	};
};

DZE_DYN_UnlockDoorInprogress = nil;
