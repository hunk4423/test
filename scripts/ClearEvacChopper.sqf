/*------------------------------------*/
/* JAEM                               */
/* Just another Chopper-Evac Mod v1.4 */
/* OtterNas3                          */
/* 01/14/2014                         */
/* Last update: 06/14/2014            */
/*------------------------------------*/
private ["_cnt","_objectID","_objectUID"];
{player removeAction _x} count s_player_lockunlock;s_player_lockunlock=[];
s_player_lockUnlock_crtl=-1;

if(DZE_ActionInProgress)exitWith{cutText ["я занят...","PLAIN DOWN"]};
DZE_ActionInProgress=true;

_cnt=5;
r_interrupt=false;
for "_p" from 1 to 5 do
{
	systemChat(format ["ВНИМАНИЕ! Зона взлета будет удалена через %1 - Двигайтесь для отмены!",_cnt]);
	if (r_interrupt) then {
		systemChat "Удаление зона взлета отменено!";
		DZE_ActionInProgress = false;breakOut "exit";
	};
	sleep 1;
	_cnt=_cnt-1;
};
systemChat "Зона взлета удалена.";

PVDZE_EvacChopperFieldsUpdate=["rem",playersEvacField];
publicVariableServer "PVDZE_EvacChopperFieldsUpdate";

_objectID = playersEvacField getVariable["ObjectID","0"];
_objectUID = playersEvacField getVariable["ObjectUID","0"];

[_objectID,_objectUID,player] call fnc_serverDeleteObject;
deleteVehicle playersEvacField;

playersEvacField=nil;
playerHasEvacField=false;

DZE_ActionInProgress=false;