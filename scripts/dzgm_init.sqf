#include "defines.h"

private ["_loginGroup","_loginVar"];

_loginVar = if (isClass(configFile >> "CfgWeapons" >> "Chainsaw")) then {"PVDZE_plr_LoginRecord"} else {"PVDZ_plr_LoginRecord"};
waitUntil {uiSleep .25;(!isNil _loginVar)};
if (count units group player > 1) then {[player] join grpNull;};

_savedGroup = profileNamespace getVariable["savedGroup",[]];
player setVariable ["savedGroup",_savedGroup,true];
player setVariable ["purgeGroup",0,true];
if (count _savedGroup > 1) then {
	{
		if (((getPlayerUID _x) in _savedGroup) && {(getPlayerUID player) in (_x getVariable["savedGroup",[]])} && {_x != player}) exitWith {
			_loginGroup = group player;
			[player] join (group _x);
			if (count units _loginGroup < 1) then {deleteGroup _loginGroup;};
		};
	} count playableUnits;
};

acceptGroupInvite = COMPILE_SCRIPT_FILE(acceptGroupInvite.sqf);
declineGroupInvite = COMPILE_SCRIPT_FILE(declineGroupInvite.sqf);
disbandGroup = COMPILE_SCRIPT_FILE(disbandGroup.sqf);
dzgmSlowLoop = COMPILE_SCRIPT_FILE(slowLoop.sqf);
inviteToGroup = COMPILE_SCRIPT_FILE(inviteToGroup.sqf);
kickFromGroup = COMPILE_SCRIPT_FILE(kickFromGroup.sqf);
leaveGroup = COMPILE_SCRIPT_FILE(leaveGroup.sqf);
playerSelectChange = COMPILE_SCRIPT_FILE(playerSelectChange.sqf);
tagName = true;
updatePlayerList = COMPILE_SCRIPT_FILE(updatePlayerList.sqf);
	
if (isNil "dzgmInit") then {call COMPILE_SCRIPT_FILE(dzgm_icons.sqf);};
uiSleep 1;
[] spawn dzgmInit;
[] spawn dzgmSlowLoop;
uiSleep 1;
systemChat "Технику можно искать по ключу, нажмите ПКМ на GPS или карту.";
systemChat "Нажмите правый Alt, чтобы открыть управление группами.";
systemChat "Нажмите F7, обязательно ознакомьтесь с правилами.";
systemChat "Нажмите F11, для снижения громкости звука.";