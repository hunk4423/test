#include "defines.h"
(findDisplay 41144) closeDisplay 3000;
(findDisplay 7000) closeDisplay 3;waitUntil {isNull (findDisplay 7000)};
if(CNT(_this) > 1)then{AccessTarget=THIS3}else{AccessTarget=THIS0};
if !([dayz_playerUID,DOOR_PLAYER_ACCESS,AccessTarget] call fnc_checkObjectsAccess)exitWith{
	cutText ["Вы не имеете прав для доступа к менеджеру двери!","PLAIN DOWN"];
};
AccessItems=[
["Полный доступ",DOOR_PLAYER_ACCESS,"полного доступа к двери",false,false],
["Замок",DOOR_OPEN_ACCESS,"открытия/закрытия замка двери",false,false]
];
AccessDefault=[];
createdialog "DoorManagement";
disableSerialization;

fnc_getAccessUpdateCost={
	PVT3(_cost,_old,_new);
	_cost=AccessAddCost;
	{
		_old=SEL2(_x);
		_new=SEL3(_x);
		{
			if (!(_x in _old))exitWith{_cost=_cost+DOOR_CHANGE_COST};
		}forEach _new;
	}count Friends;
	_cost
};

fnc_AccessUpdateInfo={
	PVT(_cost);
	_cost=[] call fnc_getAccessUpdateCost;
	if (_cost==0)exitWith{ctrlSetText[7009,""]};
	ctrlSetText[7009,format["Стоимость изменений:\n%1 %2",[_cost] call BIS_fnc_numberText, CurrencyName]];
};

onAccessUpdate={
	PVT4(_pf,_uf,_levels,_access);
	PARAMS1(_access);
	_levels=[dayz_playerUID,AccessTarget] call fnc_GetAccessLevel;
	_pf=[DOOR_PLAYER_ACCESS,_levels] call fnc_checkAccess;
	_uf=[DOOR_PLAYER_ACCESS,_access] call fnc_checkAccess;
	{
		switch(_forEachIndex)do{
			case 0 : {_x set [3,_pf];_x set [4,_uf]};
			default  {_x set [3,(!_uf)&&_pf];_x set [4,_uf||([SEL1(_x),_access] call fnc_checkAccess)]};
		};
	}forEach AccessItems;
};

onGetOwnerInfo={
	PVT(_name);
	_name=GetOwnerName(AccessTarget);
	if (_name=="")then{_name=GetOwnerUID(AccessTarget)};
	format["Владелец: %1  Код: %2",_name,GetCharID(AccessTarget)]
};

[format["Менеджер двери %1",AccessTarget call object_formatCommentWithID]] call OnAccessInit;
