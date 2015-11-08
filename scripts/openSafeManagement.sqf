#include "defines.h"
(findDisplay 7000) closeDisplay 3;waitUntil {isNull (findDisplay 7000)};
AccessTarget=THIS3;
if !([dayz_playerUID,SAFE_PLAYER_ACCESS,AccessTarget] call fnc_checkObjectsAccess)exitWith{
	cutText ["Вы не имеете прав для доступа к менеджеру сейфа!","PLAIN DOWN"];
};
AccessItems=[
["Полный доступ",SAFE_FULL_ACCESS,"полного доступа к сейфу",false,false],
["Менеджер",SAFE_PLAYER_ACCESS,"ограниченного управления настроек сейфа",false,false],
["Замок",SAFE_OPEN_ACCESS,"открытия/закрытия замка сейфа",false,false]
];
AccessDefault=[SAFE_OPEN_ACCESS];
createdialog "SafeManagement";
disableSerialization;

onPlayerAdd=fnc_AccessAddCost;

fnc_getAccessUpdateCost={
	PVT3(_cost,_old,_new);
	_cost=AccessAddCost;
	{
		_old=SEL2(_x);
		_new=SEL3(_x);
		{
			if (!(_x in _old))exitWith{_cost=_cost+SAFE_CHANGE_COST};
		}forEach _new;
	}count Friends;
	_cost
};

fnc_AccessUpdateInfo={
	PVT(_cost);
	_cost=[] call fnc_getAccessUpdateCost;
	if (_cost==0)exitWith{ctrlSetText[7009,""]};
	ctrlSetText[7009,format["Стоимость изменений: %1 %2",[_cost] call BIS_fnc_numberText, CurrencyName]];
};

onAccessUpdate={
	PVT6(_pf,_pp,_pf,_pp,_levels,_access);
	PARAMS1(_access);
	_levels=[dayz_playerUID,AccessTarget] call fnc_GetAccessLevel;
	_pf=[SAFE_FULL_ACCESS,_levels] call fnc_checkAccess;
	_pp=[SAFE_PLAYER_ACCESS,_levels] call fnc_checkAccess;
	_uf=[SAFE_FULL_ACCESS,_access] call fnc_checkAccess;
	_up=[SAFE_PLAYER_ACCESS,_access] call fnc_checkAccess;
	{
		switch(_forEachIndex)do{
			case 0 : {_x set [3,_pf];_x set [4,_uf]};
			case 1 : {_x set [3,(!_uf)&&_pp];_x set [4,_up||_uf]};
			default  {_x set [3,(!_uf)&&(!_up)&&_pp];_x set [4,_uf||_up||([SEL1(_x),_access] call fnc_checkAccess)]};
		};
	}forEach AccessItems;
};

onGetOwnerInfo={
	PVT(_name);
	_name=GetOwnerName(AccessTarget);
	if (_name=="")then{_name=GetOwnerUID(AccessTarget)};
	format["Владелец: %1  Код: %2",_name,GetCharID(AccessTarget)]
};

OnPackBtn={["","","",AccessTarget] spawn COMPILE_ACTION_FILE(vault_pack.sqf);closeDialog 0};

ctrlShow[7023,([dayz_playerUID,SAFE_FULL_ACCESS,AccessTarget] call fnc_checkObjectsAccess)&&(!((typeOf AccessTarget) in DZE_LockedStorage))];
[format["Менеджер сейфа %1",AccessTarget call object_formatCommentWithID]] call OnAccessInit;
