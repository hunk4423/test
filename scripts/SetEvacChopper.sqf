/*------------------------------------*/
/* JAEM                               */
/* Just another Chopper-Evac Mod v1.4 */
/* OtterNas3                          */
/* 01/14/2014                         */
/* Last update: 06/14/2014            */
/*------------------------------------*/

private ["_evac_chopperPrice","_allNearRescueFields","_cnt","_objectID","_objectUID","_targetVehicle","_playerUID","_magazinesPlayer","_hasBriefcase","_location","_dir","_object"];
_evac_chopperPrice = 200000;
{player removeAction _x} count s_player_lockunlock;s_player_lockunlock = [];
s_player_lockUnlock_crtl = -1;

if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
DZE_ActionInProgress = true;

//This prevents the building of Evac-Chopper field on trader signs
_allNearRescueFields = (nearestObjects [player,["HeliHRescue"],50]);
if (count _allNearRescueFields > 0) then {
	systemChat "Здесь невозможно поставить зону взлета.";
	DZE_ActionInProgress = false;breakOut "exit";
} forEach _allNearRescueFields;


//Getting the target Vehicle and needed variables
_targetVehicle = _this select 3;
_location = ([_targetVehicle] call FNC_GetPos);
_dir = getDir _targetVehicle;
_playerUID = ([player] call ON_fnc_convertUID);
_magazinesPlayer = magazines player;

//Cause we can only make a sign on Terrain and not on buildings or buildables
//We check if the Chopper height is below 1m above Terrain
if ((_location) select 2 >= 3) then {
	systemChat "Зону взлета возможно поставить только на ровной поверхности.";
	sleep 2;
	systemChat "Удостоверьтесь, что рядом нет объектов которые могут помешать взлету.";
};

//Check if player has the needed amount of Briefcases to pay for the Evac-Chopper
//If not exit script
_hasBriefcase = player getVariable["headShots",0]; //_hasBriefcase = player getVariable["cashMoney",0];
if (_hasBriefcase < _evac_chopperPrice) then {
	systemChat(format["Цена для установки Эвакуационного вертолёта 200,000руб. Недостаточно средств.", _evac_chopperPrice, CurrencyName]);
	DZE_ActionInProgress = false;breakOut "exit";
};

//If player already has a Evac-Chopper
//tell him that only 1 Evac-Chopper is allowed
//Give him 5 seconds until we change the Evac-Chopper to the current target
r_interrupt = false;
if (playerHasEvacField) then {
	systemChat "Можно иметь только 1 Эвакуационный вертолёт!";
	_cnt = 5;
	for "_p" from 1 to 5 do
	{
		systemChat(format ["ВНИМАНИЕ! Установка зоны взлета через %1с - Двигайтесь для отмены.",_cnt]);
		if (r_interrupt) then {
			systemChat "Установка зоны взлета отменена.";
			DZE_ActionInProgress = false;breakOut "exit";
		};
		sleep 1;
		_cnt = _cnt - 1;
	};
	_objectID = playersEvacField getVariable["ObjectID","0"];
	_objectUID = playersEvacField getVariable["ObjectUID","0"];
	[_objectID,_objectUID,player] call fnc_serverDeleteObject;
	PVDZE_EvacChopperFieldsUpdate = ["rem",playersEvacField];
	publicVariableServer "PVDZE_EvacChopperFieldsUpdate";
	deleteVehicle playersEvacField;
	playerHasEvacField = false;
	playersEvacField = nil;
};

systemChat "Зону взлета возможно поставить только на ровной поверхности.";
sleep 2;
systemChat "Удостоверьтесь, что рядом нет объектов которые могут помешать взлету.";
sleep 2;

_cnt = 10;
for "_i" from 1 to 10 do
{
	systemChat(format ["Установка зоны взлета через %1с - Двигайтесь для отмены.",_cnt]);
	if (r_interrupt) then {
		systemChat "Установка зоны взлета отменена.";
		DZE_ActionInProgress = false;breakOut "exit";
	};
	sleep 1;
	_cnt = _cnt - 1;
};

//Start Building
//Player did not had a Evac-Chopper yet or decided to replace it with the new target
//So we check again if he STILL has the Briefcase in his inventory
//If yes, we remove it and say thanks ^^
if ([player, _evac_chopperPrice] call SC_fnc_removeCoins) then {
	systemChat(format["Установка зоны взлета завершена!", _evac_chopperPrice, CurrencyName]);
} else { 
	systemChat(format["Цена для установки Эвакуационного вертолёта 200,000руб. Недостаточно средств.", _evac_chopperPrice , CurrencyName ]);
	DZE_ActionInProgress = false;breakOut "exit";
};

//The player payd so we make the Sign and write it to the database
//We use the playerUID so the ownage is permanent!
_object = createVehicle ["HeliHRescue", _location, [], 0, "CAN_COLLIDE"];
_object addEventHandler ["HandleDamage", {false}];
_object enableSimulation false;
_object setDir _dir;
_object setPosATL _location;
player reveal _object;
player playActionNow "Medic";
_object setVariable ["CharacterID",_playerUID,true];
_object setVariable ["Classname", "HeliHRescue",true];
PVDZE_obj_Publish = [_playerUID,_object,[_dir,_location],"HeliHRescue",getPlayerUID player,-1];
publicVariableServer "PVDZE_obj_Publish";
PVDZE_EvacChopperFieldsUpdate = ["add",_object];
publicVariableServer "PVDZE_EvacChopperFieldsUpdate";
playerHasEvacField = true;
playersEvacField = _object;
DZE_ActionInProgress = false;