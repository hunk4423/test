/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private["_parking","_withkey","_unit","_object","_charID","_objectID","_ownerUID","_keyavailable","_msg","_key","_class","_name","_oth","_my"];

PARAMS2(_object,_withkey);
CheckActionInProgress(MSG_BUSY);
disableSerialization;
[false]call onGarageDlgEnableBtn;
_unit=player;
if (isNull _object)exitWith{["Транспорт отсутствует."]call fnc_GarageBreakAction};
_charID=GetCharID(_object);
_objectID=GetObjID(_object);
_ownerUID=GetOwnerUID(_object);
_class=typeOf _object;
_parking=GETVAR(selectedGarage,parking,false);

if (_objectID=="" || _objectID=="0" || _objectID=="1")exitWith{["Нельзя поставить в гараж временные объекты."]call fnc_GarageBreakAction};
if (_ownerUID=="0")exitWith{["Транспорт должен иметь владельца."]call fnc_GarageBreakAction};

_my=false;
_oth=false;
if (_ownerUID==dayz_playerUID)then{
	if (_parking)then{_my=true}else{_my=[dayz_playerUID,GARAGE_SELF_ACCESS,selectedGarage] call fnc_checkObjectsAccess};
}else{
	_oth=[dayz_playerUID,GARAGE_OTHER_ACCESS,selectedGarage] call fnc_checkObjectsAccess;
};

_keyavailable=false;
_key=[_unit,_charID] call fnc_checkPlayerKey;
if (CNT(_key)>0)then{_key=SEL0(_key);_keyavailable=true};
if (curradminlevel>0&&!_keyavailable)then{_keyavailable=true;_withkey=false};

if (_ownerUID==dayz_playerUID && !_my)exitWith{["У вас недостаточно прав для постановки своего транспорта."]call fnc_GarageBreakAction};
if (_ownerUID!=dayz_playerUID && !_oth)exitWith{["У вас недостаточно прав для постановки чужого транспорту."]call fnc_GarageBreakAction};
if (_ownerUID!=dayz_playerUID && !_keyavailable)exitWith{["Вы должны иметь ключ от чужого транспорта."]call fnc_GarageBreakAction};
if ((count (crew _object))!=0)exitWith{["Нельзя поставить в гараж, в технике люди."]call fnc_GarageBreakAction};
if (GetTow(_object)||GetInTow(_object))exitWith{["Нельзя поставить в гараж, техника участвует в буксировке."]call fnc_GarageBreakAction};
if (count(_object getVariable["Cargo",[]])>0)exitWith{["Нельзя поставить в гараж, техника везет груз."]call fnc_GarageBreakAction};

if(!GETVAR(selectedGarage,parking,false))then{UpdateAccess(selectedGarage)};
_object setvehiclelock "locked";
_name=getText(configFile >> "CfgVehicles" >> _class >> "displayName");
[format["%1 перемещается в гараж. Ожидайте...",_name]]call fnc_GarageSetStatus;
if !([[[_object,GetObjID(selectedGarage),player],"store"],10] call fnc_GarageResultWait)exitWith{[GarageLastError,true]call fnc_GarageBreakAction};

if(PVDZE_GarageResult)then{
	_msg="";
	if(_withkey && _keyavailable)then{[_unit,_key] call BIS_fnc_invRemove;_msg="Ключ удален с пояса!"};
	_msg=format["%1 помещен в гараж. %2",_name,_msg];
}else{_msg="Ошибка!"};

PVDZE_GarageResult=nil;
[_msg]call fnc_GarageBreakAction;