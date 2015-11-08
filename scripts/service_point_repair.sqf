/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_vehicle","_price","_isOK","_type","_name","_allRepaired","_partName","_selection","_skin"];

_price=(_this select 3)select 0;
if(_price==507)then{
	_vehicle=(_this select 3)select 1;
	_skin=true;
}else{
	_vehicle=THIS0;
	_skin=false;
};
if (!_skin&&(!local _vehicle)&&!((assignedGunner _vehicle)==player))exitWith{};

if!(_skin)then{
	_isOK=[player,_price] call fnc_Payment;
	if(SEL0(_isOK))then{ 
		_type=typeOf _vehicle;
		_name=getText(configFile >> "cfgVehicles" >> _type >> "displayName");
		_vehicle engineOn false;
		[_vehicle,"repair",0,false] call dayz_zombieSpeak;

		_allRepaired = true;
		{
			if((vehicle player != _vehicle) || ((!local _vehicle)&&!((assignedGunner _vehicle)==player)) || ([0,0,0] distance (velocity _vehicle) > 1))exitWith{
				_allRepaired = false;
				cutText [format["Ремонт %1 остановлен.",_name], "PLAIN DOWN"];
			};
			if (([_vehicle,_x] call object_getHit)>0) then {
				_partName = toArray _x;
				_partName set [0,20];
				_partName set [1,45];
				_partName set [2,20];
				_partName = toString _partName;
				titleText [format["Ремонтирую%1 ...", _partName], "PLAIN DOWN", 2];
				sleep 2;
				_selection=getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _x >> "name");
				[_vehicle,_selection,0] call object_setFixServer;
			};
		} forEach (_vehicle call vehicle_getHitpoints);
		
		if (_allRepaired) then {
			_vehicle setDamage 0;
			_vehicle setVelocity [0,0,1];
			_vehicle setVariable["LandFalseDamage",0];
			_vehicle setVariable["hit_zbran",0];
			_vehicle setVariable["hit_vez",0];
			sleep 2;
			cutText [format["\n\n Техника починена!"], "PLAIN DOWN"];
			systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];
		};
	} else {
		cutText [format["Нужно %1 %2",_price,CurrencyName] , "PLAIN DOWN"];
	};
}else{
	_type=typeOf _vehicle;
	_vehicle engineOn false;
	[_vehicle,"repair",0,false] call dayz_zombieSpeak;
	player playActionNow "Medic";
	sleep 7;
	{
		if (([_vehicle,_x] call object_getHit)>0.45) then {
			_selection=getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _x >> "name");
			PVDZE_veh_SFix = [_vehicle,_selection,0.5];
			publicVariable "PVDZE_veh_SFix";
			if (local _vehicle) then {
				PVDZE_veh_SFix call object_setFixServer;
			};
		};
	}forEach(_vehicle call vehicle_getHitpoints);
	_vehicle setVelocity [0,0,1];
	_vehicle setVariable["LandFalseDamage",0];
	_vehicle setVariable["hit_zbran",0];
	_vehicle setVariable["hit_vez",0];
	cutText [format["\n\n Техника починена!"], "PLAIN DOWN"];
};