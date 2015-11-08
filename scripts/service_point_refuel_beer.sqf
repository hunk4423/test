/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_vehicle","_amount","_price","_isOK","_name","_fuel"];
_vehicle=THIS0;
if ((!local _vehicle)&&!((assignedGunner _vehicle)==player))exitWith{};

_amount=0.0013;
_price=THIS3;
if (_vehicle isKindOf "Air")then{_amount = 0.00152;};
if (_vehicle isKindOf "LandVehicle")then{_amount = 0.00132;};
if (_vehicle isKindOf "Truck")then{_amount = 0.00132;};
if !([["ItemSodaRabbit", _price]] call player_checkAndRemoveItems)exitWith{cutText [format["Для заправки необходимо %1 пива(о).",_price], "PLAIN DOWN"];};

_type=typeOf _vehicle;
_name=getText(configFile >> "cfgVehicles" >> _type >> "displayName");
if (isNil "SP_refueling") then {
	SP_refueling = true;	
	_vehicle engineOn false;
	cutText [format["О! от души, уже заправляю твой %1 ...",_name], "PLAIN DOWN"];
	[_vehicle,"refuel",0,false] call dayz_zombieSpeak;
	
	while{(vehicle player == _vehicle)&&(local _vehicle)||((assignedGunner _vehicle)==player)}do{
		if([0,0,0] distance (velocity _vehicle) > 1)exitWith{
			cutText ["эээй ты куда поехал?! не дозаправил, же! ну все, плати по новой!", "PLAIN DOWN"];
		};
		_fuel=(fuel _vehicle) + _amount;
		if(_fuel > 0.95)exitWith{
			_vehicle setFuel (1-(random 0.2));
			cutText ["мда.. ага.. полный бак! а я пошел, а то пиво кончилось...", "PLAIN DOWN"];
		};
		_vehicle setFuel _fuel;
		sleep 0.01;
	};	
	SP_refueling = nil;
};
