/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_vehicle","_args","_weapon","_ammo","_price","_weapon","_isOK","_name","_weaponType","_turret"];
_vehicle=THIS0;
if ((!local _vehicle)&&!((assignedGunner _vehicle)==player))exitWith{};

_args=THIS3;
_weapon=SEL1(_args);
_ammo=SEL2(_args);
_price=SEL0(_args);

_isOK=[player,_price] call fnc_Payment;
if(SEL0(_isOK))then{
	_name=getText(configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");	
	_weaponType=SEL0(_weapon);
	_weaponName=SEL1(_weapon);
	_turret=SEL2(_weapon);
	
	// add magazines
	for "_i" from 1 to 3 do {
		_vehicle addMagazineTurret [_ammo,_turret];
	};
	
	cutText [format["\n\n%1 на %2 перезаряжен", _weaponName, _name], "PLAIN DOWN"];
	systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];
} else {
    cutText [format["Нужно %1 %2",_price,CurrencyName] , "PLAIN DOWN"];
};