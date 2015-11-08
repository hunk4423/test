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
if(_vehicle isKindOf "Air")then{_amount = 0.0015;};
_isOK=[player,_price] call fnc_Payment;
if(SEL0(_isOK))then{
	_name=getText(configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
	if (isNil "SP_refueling") then {
		SP_refueling=true;
		_vehicle engineOn false;
		cutText [format["О! от души, уже заправляю твой %1 ...",_name], "PLAIN DOWN"];
		[_vehicle,"refuel",0,false] call dayz_zombieSpeak;

		while{(vehicle player == _vehicle)&&(local _vehicle)||((assignedGunner _vehicle)==player)}do{
			if ([0,0,0] distance (velocity _vehicle) > 1)exitWith{
				cutText["эээй ты куда поехал?! не дозаправил, же! ну все, плати по новой!", "PLAIN DOWN"];
			};
			_fuel=(fuel _vehicle)+_amount;
			if(_fuel > 0.95)exitWith{
				_vehicle setFuel (1-(random 0.12));
				cutText["...все, я заправил, мне тут бежать нужно...", "PLAIN DOWN"];
			};
			_vehicle setFuel _fuel;
			sleep 0.01;
		};
		SP_refueling = nil;
	};
	systemChat format ["%1",([_isOK] call fnc_PaymentResultToStr)];
} else {
    cutText [format["Нужно %1 %2",_price,CurrencyName] , "PLAIN DOWN"];
};