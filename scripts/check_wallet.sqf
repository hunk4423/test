#include "defines.h"
private ["_body","_hisMoney","_abort"];
CheckActionInProgress(MSG_BUSY);
_body=THIS3;
player removeAction s_can_get_money;s_can_get_money=-1;

_abort=true;
if(((typeOf _body)in AI_BanditTypes)||(_body isKindOf "zZombie_base"))then{
	_abort=false;
}else{
	if((dayz_playerName==GETVAR(_body,bodyName,""))||((GETVAR(_body,PlayerUID,0))in(profileNamespace getVariable["savedGroup",[]])))then{
		_abort=false;
	};
};
if(_abort)exitWith{BreakActionInProgress("Снимать наличные с трупа игрока можно, только если вы в одной группе.")};

if(([_body,7] call fnc_getNearPlayersCount)>0)exitWith{BreakActionInProgress("Нельзя в присутствии других игроков!")};
_hisMoney=GetCash(_body);
if(isNil "_hisMoney")exitWith{BreakActionInProgress("Наличных не найдено")};
if(typeName _hisMoney != "SCALAR")exitWith{BreakActionInProgress("Наличных не найдено")};

SetCash(_body,0);
[player,_hisMoney]call SC_fnc_addCoins;
systemChat format ['Наличных найдено: %1 руб.',[_hisMoney] call BIS_fnc_numberText];
DZE_ActionInProgress=false;