/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private["_withkey","_vehicle","_vehicleClass","_dir","_pos","_location","_result","_inventory","_backpack","_access","_msg","_class","_done","_penalty","_parking"];

PARAMS2(_vehicle,_withkey);
CheckActionInProgress(MSG_BUSY);
disableSerialization;
[false] call onGarageDlgEnableBtn;
if(CNT(_vehicle)==0)exitWith{["Транспорт не выбран"]call fnc_GarageBreakAction};
_parking=GETVAR(selectedGarage,parking,false);
_penalty=GETVAR(selectedGarage,penalty,false);
if(!(_parking||_penalty))then{UpdateAccess(selectedGarage)};
//[ID,Classname,OwnerUID,PlayerName]
_class=SEL1(_vehicle);
_vehicleClass = getText(configFile >> "CfgVehicles" >> _class >> "vehicleClass");
if (SEL2(_vehicle)==dayz_playerUID)then{
	if (_parking||_penalty)then{_access=true}else{_access=[dayz_playerUID,GARAGE_SELF_ACCESS,selectedGarage] call fnc_checkObjectsAccess};
}else{
	_access=[dayz_playerUID,GARAGE_OTHER_ACCESS,selectedGarage] call fnc_checkObjectsAccess;
};
if (!_access)exitWith{["У вас недостаточно прав для доступа к данному транспорту"]call fnc_GarageBreakAction};

_pos=[];
if(_vehicleClass!="Air")then{_pos=[_class,[selectedGarage,GARAGE_ZONE,"land"] call fnc_getNearestPads] call fnc_GetPadPlace};
if(CNT(_pos)==0)then{_pos=[_class,[selectedGarage,GARAGE_ZONE,"all"] call fnc_getNearestPads] call fnc_GetPadPlace};
if(CNT(_pos)==0)exitWith{["Необходима свободная площадка для техники"]call fnc_GarageBreakAction};

EXPLODE2(_pos,_dir,_location);
_location set [2,SEL2(_location)+0.1];

_object=createVehicle ["Sign_arrow_down_large_EP1",_location,[],0,"CAN_COLLIDE"];
_object setPosATL _location;

if !([[[_object,GetObjID(selectedGarage),[_dir,_location],player,SEL0(_vehicle)],"spawn"],10] call fnc_GarageResultWait)exitWith{[GarageLastError]call fnc_GarageBreakAction};

_object=SEL0(PVDZE_GarageResult);_msg="";
if ((typeName _object)=="OBJECT")then{
	if (GETVAR(selectedGarage,penalty,false))then{
		_cost=[timeInGarage]call fnc_GaragePenaltyCost;
		if (_cost>0 && currAdminLevel<1)then{
			_rc=[player,_cost,true]call fnc_Payment;
			_done=SEL0(_rc);
			_rc=[_rc]call fnc_PaymentResultToStr;
			if(!_done)then{[_rc]call fnc_GarageSetStatus}else{systemchat _rc}
		};
	};
	if (_withkey)then{
		_characterID=parsenumber GetCharID(_object);
		if(_characterID!=0) then {
			_result=[_characterID] call vehicle_getKeyByCharID;
			_inventory = (weapons player);
			_backpack = SEL0(getWeaponCargo unitBackpack player);
			if (_result in (_inventory+_backpack)) then {
				if (_result in _inventory) then {_msg=format["Ключ [%1] уже есть на поясе!",_result]};
				if (_result in _backpack) then {_msg=format["Ключ [%1] уже есть в рюкзаке!",_result]};
			} else {
				player addweapon _result;
				_msg=format["Ключ [%1] добавлен на пояс!",_result];
			};
		}else{_msg="Транспорт не имеет ключа!"};
	};
	_msg=format["%1 извлечен из гаража. %2",getText(configFile >> "CfgVehicles" >> _class >> "displayName"),_msg];
}else{
	_msg=format["Ошибка! %1.",_object];
};
[_msg]call fnc_GarageBreakAction;