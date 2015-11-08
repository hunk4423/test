#include "defines.h"
(findDisplay 7000) closeDisplay 3;waitUntil {isNull (findDisplay 7000)};
if(CNT(_this)>2)then{AccessTarget=THIS3}else{AccessTarget=THIS0};
if !([dayz_playerUID,GARAGE_FULL_ACCESS,AccessTarget] call fnc_checkObjectsAccess)exitWith{
	cutText ["Вы не имеете прав для доступа к менеджеру прав гаража!","PLAIN DOWN"];
};
AccessItems=[
["Полный доступ",GARAGE_FULL_ACCESS,"полного доступа к технике и управления гаражом",false,false],
["Чужой транспорт",GARAGE_OTHER_ACCESS,"доступа к чужой технике",false,false],
["Мой транспорт",GARAGE_SELF_ACCESS,"доступа к своей технике",false,false]
];
AccessDefault=[GARAGE_SELF_ACCESS];
createdialog "GarageManagement";
disableSerialization;

fnc_getAccessUpdateCost={AccessAddCost};

fnc_AccessUpdateInfo={ctrlSetText[7009,""]};

onPlayerAdd={
	AccessAddCost=AccessAddCost+500;
};

onAccessUpdate={
	PVT4(_pf,_uf,_levels,_access);
	PARAMS1(_access);
	_levels=[dayz_playerUID,AccessTarget] call fnc_GetAccessLevel;
	_pf=[GARAGE_FULL_ACCESS,_levels] call fnc_checkAccess;
	_uf=[GARAGE_FULL_ACCESS,_access] call fnc_checkAccess;
	{
		switch(_forEachIndex)do{
			case 0 : {_x set [3,_pf];_x set [4,_uf]};
			case 1 : {_x set [3,(!_uf)&&_pf];_x set [4,_uf||([SEL1(_x),_access] call fnc_checkAccess)]};
			default  {_x set [3,(!_uf)&&_pf];_x set [4,_uf||([SEL1(_x),_access] call fnc_checkAccess)]};
		};
	}forEach AccessItems;
};

onGetOwnerInfo={
	PVT(_name);
	_name=GetOwnerName(AccessTarget);
	if (_name=="")then{_name=GetOwnerUID(AccessTarget)};
	format["Владелец: %1",_name]
};

[format["Менеджер гаража %1",AccessTarget call object_formatCommentWithID]] call OnAccessInit;