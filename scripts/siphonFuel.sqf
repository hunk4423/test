#include "defines.h"
private ["_vehicle","_curFuel","_newFuel","_started","_finished","_animState","_isMedic","_location1","_location2","_abort","_canNameEmpty","_canSizeEmpty","_canTypeEmpty","_canName","_canSize","_configCanEmpty","_configVeh","_capacity","_nameText","_availableCansEmpty","_rc"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_98") , "PLAIN DOWN"] };
DZE_ActionInProgress = true;

// Use target from addaction
_vehicle=_this select 0;

_abort=false;

// Static vehicle fuel information
_configVeh=configFile >> "cfgVehicles" >> TypeOf(_vehicle);
_capacity=getNumber(_configVeh >> "fuelCapacity");
_nameText=getText(_configVeh >> "displayName");

_availableCansEmpty=["ItemJerrycanEmpty","ItemFuelBarrelEmpty"];
// _availableCans = ["ItemJerrycan","ItemFuelBarrel"];

// Loop to find containers that can could hold fuel && fill them
{
	_configCanEmpty=configFile >> "CfgMagazines" >> _x;
	if(_x in _availableCansEmpty)then{
		_canNameEmpty=_x;
		_canSizeEmpty=getNumber(_configCanEmpty >> "fuelQuantity");
		_canTypeEmpty=getText(_configCanEmpty >> "displayName");

		// Get Full can size
		_canName=configName(inheritsFrom(configFile >> "cfgMagazines" >> _canNameEmpty));
		_canSize=getNumber(configFile >> "cfgMagazines" >> _canName >> "fuelQuantity");

		// is empty
		if(_canSizeEmpty==0)then{
			_curFuel=((fuel _vehicle) * _capacity);
			_newFuel=(_curFuel - _canSize);

			// calculate new fuel
			_newFuel=(_newFuel/_capacity);

			if (_newFuel>0)then{
				cutText [format[(localize "str_epoch_player_133"),_canTypeEmpty], "PLAIN DOWN"];
				// alert zombies
				[player,20,true,(getPosATL player)] spawn player_alertZombies;
				ANIMATION_MEDIC(false);
				if (_finished) then {
					if (_vehicle getVariable["taxi",false])exitWith{
						player setVariable["startcombattimer",1];
						systemchat "Кто тут? Что ты тут делаешь?";sleep 5;
						player playActionNow "CivilSitting03";
						[objNull, player, rSWITCHMOVE, "CivilSitting03"] call RE;
						systemchat "Топливо воруешь? Ну и что же с тобой делать?..."; sleep 5;
						systemchat "Может пулю в лоб?..."; sleep 5;
						systemchat "А чем там у тебя можно поживиться? Деньги есть?..."; sleep 5;
						_rc=[player,1000,false] call fnc_Payment;
						if (_rc select 0)then{
							systemchat ([_rc] call fnc_PaymentResultToStr);Sleep 1;
							systemchat "Пошел вон, чтобы я больше тебя не видел! Радуйся что не пристрелил!";
						}else{
							systemchat "Фу... Голодранец!... Пошел вон, чтобы я больше тебя не видел!";
						};
						sleep 5;
						[objNull,player,rSwitchMove,""] call RE;
						player playActionNow "stop";
						_abort = true;
					};
						
					// Get vehicle fuel levels again
					_curFuel=((fuel _vehicle) * _capacity);
					_newFuel=(_curFuel - _canSize);

					// calculate minimum needed fuel
					_newFuel = (_newFuel / _capacity);

					if (_newFuel > 0) then {
						if(([player,_canNameEmpty] call BIS_fnc_invRemove) == 1) then {
							/* PVS/PVC - Skaronator */
							if (local _vehicle) then {
								[_vehicle,_newFuel] call local_setFuel;
							} else {
								PVDZE_send = [_vehicle,"SFuel",[_vehicle,_newFuel]];
								publicVariableServer "PVDZE_send";
							};

							// Play sound
							[player,"refuel",0,false] call dayz_zombieSpeak;
							player addMagazine _canName;
							cutText [format[(localize "str_epoch_player_171"),_nameText,_canSize], "PLAIN DOWN"];

							call fnc_usec_medic_removeActions;
							r_action = false;
							sleep 1;
						} else {
							_abort = true;
						};
					} else {
						cutText [format[(localize "str_epoch_player_172"),_nameText], "PLAIN DOWN"];
						_abort = true;
					};
				} else {
					cutText [(localize "str_epoch_player_35") , "PLAIN DOWN"];
					_abort = true;
				};
			} else {
				cutText [format[(localize "str_epoch_player_172"),_nameText], "PLAIN DOWN"];
				_abort = true;
			};
		};
	};
	if(_abort) exitWith {};
} count magazines player;

PVDZE_veh_Update = [_vehicle, "all"];
publicVariableServer "PVDZE_veh_Update";
DZE_ActionInProgress = false;
