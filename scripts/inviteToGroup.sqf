if (player != leader group player) exitWith {systemChat "You are not the leader and can not invite people.";};

disableSerialization;

private ["_dialog","_playerListBox","_pTarget","_index","_playerData","_check","_hasInvite"];

_dialog = findDisplay 55510;
_playerListBox = _dialog displayCtrl 55511;
_index = lbCurSel _playerListBox;
_playerData = _playerListBox lbData _index;
_hasInvite = false;
_check = 0;
{
	if ((!isNull _x) && {isPlayer _x} && {str(_x) == _playerData}) exitWith {_pTarget = _x;_check = 1;};
} count playableUnits;

if (_check == 0) exitWith {systemChat "Вы должны выбрать кого-то для начала.";};
if (_pTarget == player) exitWith {systemChat "Вы не можете пригласить себя.";};
if (count units group _pTarget > 1) exitWith {systemChat "Этот игрок уже в группе.";};

{if (_x select 1 == getPlayerUID _pTarget) then {_hasInvite = true;};} forEach currentInvites;
if (_hasInvite) exitWith {systemChat "Предложение о вступлении в группу уже отправлено.";};
currentInvites set [count currentInvites,[getPlayerUID player,getPlayerUID _pTarget]];
publicVariableServer "currentInvites";

[nil,_pTarget,"loc", rTITLETEXT, format["\n\n Вы получили предложение вступить в группу. Нажмите правый Alt, чтобы посмотреть."], "PLAIN", 0] call RE;

systemChat format["Вы пригласили %1 присоединиться к группе",name _target];