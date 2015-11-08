/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT5(_vehicle,_OwnerUID,_charID,_isOK,_vehicleName);

_vehicle = THIS3; 
Z_vehicle = _vehicle;
_OwnerUID = GetOwnerUID(_vehicle);
_charID = GetCharID(_vehicle);
_isOK = true;

if(_charID !="0" && _OwnerUID == "0")then{
	systemChat "Нельзя выбрать технику для торговли, у которой нет владельца.";
	_isOK=false;
};
if(_isOK)then{
	_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf Z_vehicle >> "displayName");
	_vehicle setVariable["Premium_Trade",name player,true];
	systemChat format["%1 выбран(а) для торговли.", _vehicleName];
};