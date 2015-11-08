#include "defines.h"
(findDisplay 7000) closeDisplay 3;waitUntil {isNull (findDisplay 7000)};
AccessTarget=THIS3;
if !([dayz_playerUID,[PLOT_FULL_ACCESS,PLOT_PLAYER_ACCESS],AccessTarget] call fnc_checkObjectsAccess)exitWith{
	cutText ["Вы не имеете прав для доступа к менеджеру плота!","PLAIN DOWN"];
};
AccessItems=[
["Полный доступ",PLOT_FULL_ACCESS,"полного доступа к плоту и стройке в его зоне",false,false],
["Менеджер",PLOT_PLAYER_ACCESS,"ограниченного управления настроек плота",false,false],
["Стройка",PLOT_BUILD_ACCESS,"строительства в зоне плота (за исключением операций с плотом)",false,false]
];
AccessDefault=[PLOT_BUILD_ACCESS];
createdialog "PlotManagement";
disableSerialization;

onPlayerAdd=fnc_AccessAddCost;

fnc_getAccessUpdateCost={
	PVT3(_cost,_old,_new);
	_cost=AccessAddCost;
	{
		_old=SEL2(_x);
		_new=SEL3(_x);
		{
			if (!(_x in _old))exitWith{_cost=_cost+PLOT_CHANGE_COST};
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
	_pf=[PLOT_FULL_ACCESS,_levels] call fnc_checkAccess;
	_pp=[PLOT_PLAYER_ACCESS,_levels] call fnc_checkAccess;
	_uf=[PLOT_FULL_ACCESS,_access] call fnc_checkAccess;
	_up=[PLOT_PLAYER_ACCESS,_access] call fnc_checkAccess;
	//systemchat format["Права %1, plot=%2, player=%3",_levels,_f,_p];
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
	format["Владелец: %1",_name]
};

[format["Менеджер плота %1",AccessTarget call object_formatCommentWithID]] call OnAccessInit;