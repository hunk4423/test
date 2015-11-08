/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

waitUntil {(!isNil "sand_USEDGUTS")};
if (isNil "sand_washed") then {sand_washed = false;};
if (isNil "s_player_cleanguts") then {s_player_cleanguts = -1;};

sand_shieldON = {
	systemChat "Зомби думают что я один из них...";
	//cutText [_txt,"PLAIN DOWN"];
	player_zombieCheck = {};
	player_zombieAttack = {};
	DZE_hasZombieCamo = true;
};

sand_shieldOFF = {
	systemChat "Зомби снова хотят сожрать меня!";
	//cutText [_txt,"PLAIN DOWN"];
	player_zombieCheck = COMPILE_CODE_FILE(player_zombieCheck.sqf);
	player_zombieAttack = COMPILE_SCRIPT_FILE(player_zombieAttack.sqf);
	DZE_hasZombieCamo = false;
};


sand_makeSounds = {
	private ["_type","_chance","_isWoman","_plsound","_bloodleft","_id","_humanity"];
	_isWoman = getText(configFile >> "cfgVehicles" >> (typeOf player) >> "TextPlural") == "Women";	
	_humanity = player getVariable["humanity",0];
	if (_humanity >= 10000) then {
		DZ_ZCAMO_LOSE_HUMANITY = -0.28;
			} else {
		DZ_ZCAMO_LOSE_HUMANITY = -0.42;
	};
	
	while {true} do {
		if (!hasGutsOnHim) exitWith {};
		if (_isWoman) then {
			_type = ["z_fchase_"+str floor(random 4),"z_fspotted_"+str floor(random 4) ];
		} else {
			_type = ["z_idle_"+str floor(random 35)];
		};
		_plsound  = _type call BIS_fnc_selectRandom;
		_chance = ceil (random 10);
		if ((round(random _chance) == _chance) or (_chance == 0)) then {
			[nil,player,rSAY,[_plsound, 10]] call RE;
			if (isNil "showNotificationOnce") then {systemChat ("Что бы не выделяться, я буду издавать звуки зомби..."); showNotificationOnce = false;};
			sleep 1;
		};
		[player,DZ_ZCAMO_LOSE_HUMANITY, 10] call player_humanityChange;
	};
};

sand_cleanCheck = {
	private ["_isRain","_RefillTime","_countdown","_RainAmt","_startRefillTime","_onLadder","_canDo","_playerPos","_isWater","_canClean","_isPond","_isWell","_pondPos","_objectsWell","_objectsPond","_pondNear","_wellNear"];
	while {true} do {
		if(hasGutsOnHim and (!sand_washed)) then {
			 scopeName "rainloop";
			_onLadder	= (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
			_canDo		= (!r_drag_sqf and !r_player_unconscious and !_onLadder);
			_playerPos	= getPosATL player;
			_isWater	= dayz_isSwimming;  //(surfaceIsWater _playerPos) or 
			_canClean	= count nearestObjects [_playerPos, DZ_waterSources, 4] > 0;
			_isPond = false;
			_isWell = false;
			_pondNear = false;
			_wellNear = false;
			_pondPos = [];
			_objectsWell = [];
			_isRain = false;
			if ((!hasGutsOnHim) and sand_washed) then {breakOut "rainloop";};
			if (_isWater) exitwith { cutText [format["Хух! Наконец я смыл это с себя!"], "PLAIN DOWN"]; call sand_endScript;};
			if ((time - DZ_ZCAMO_STARTTIME) > DZ_ZCAMO_USE_TIME and (DZ_ZCAMO_USE_TIME > 0)) exitwith { cutText [format["Кишки уже не пахнут так сильно, снова хотят сожрать меня!"], "PLAIN DOWN"]; call sand_endScript; breakOut "rainloop";};

			// Gather global weather (rain) variable; ranges from 0 to 1 (none to very, very hard rain)
			_RainAmt = drn_var_DynamicWeather_Rain; // referenced from \z\addons\dayz_code\system\DynamicWeatherEffects.sqf

			// If global rain amount is higher than 0, then set flag isRain to true
			if (_RainAmt > 0) then { _isRain = true; };

			_objectsPond = nearestObjects [_playerPos, [], 20];
			{
				//Check for pond
				_isPond = ["pond",str(_x),false] call fnc_inString;
				if (_isPond) then {
					_pondPos = (_x worldToModel _playerPos) select 2;
					if (_pondPos < 0) then {
						_pondNear = true;
					};
				};
			} forEach _objectsPond;

			_objectsWell = nearestObjects [_playerPos, [], 4];
			{
				//Check for Well
				_isWell = ["_well",str(_x),false] call fnc_inString;
				if (_isWell) then {_wellNear = true};
			} forEach _objectsWell;

			if(!isNull player) then {
				if((speed player <= 1) && (_canClean || _pondNear || _wellNear) && _canDo) then {
					if (s_player_cleanguts < 0) then {
						s_player_cleanguts = player addaction["<t color='#5882FA'>Смыть кишки зомби</t>","scripts\usewatersupply.sqf","",-77,false,true,"",""];
					};
				}else{
					player removeAction s_player_cleanguts;
					s_player_cleanguts = -1;
				};
			};

			// It's raining! Remove the zombie parts
			if (!dayz_inside and _isRain and hasGutsOnHim) then {
				// Set initial loop variables
				_startRefillTime = time;
				r_interrupt = false;
				r_doLoop = true;
				// Set refill time depending upon degree of rain (heavy, medium, or light)
				_RefillTime = DZ_ZCAMO_LightRainLoseCamo; // set as default
				if (_RainAmt > 0.53) then { // heavy rain
					_RefillTime = DZ_ZCAMO_HeavyRainLoseCamo; };
				if (_RainAmt > 0.25) then { // medium rain
					_RefillTime = DZ_ZCAMO_MediumRainLoseCamo; }; 
				if (_RainAmt < 0.25) then { // light rain
					_RefillTime = DZ_ZCAMO_LightRainLoseCamo; }; 

				_countdown = _RefillTime;
				// Loop thru required time to fill and check for interruptions
				while {r_doLoop} do {
					if (!dayz_inside) then {
						_countdown = (_countdown - 1);
						// Inform the player how long it will take till camo wears off
						if ((time - _startRefillTime) <= _RefillTime) then {
							 cutText [format["Дождь смывает запах! Осталось: %1 сек.\n Нужно быстро забежать в здание!",str(_countdown)], "PLAIN DOWN"];
						} else {
							cutText ["Дождь смыл весь запах, зомби снова хотят сожрать меня!", "PLAIN DOWN"];
							sand_washed = true;
							hasGutsOnHim = false;  
							detach soundFly;
							deletevehicle soundFly;
							r_doLoop = false;
						};
						_RainAmt = drn_var_DynamicWeather_Rain; // Check for rain stopping

						if (_RainAmt < 0.025) exitWith {
							cutText ["Дождь прекратился. Запах не смылся, я все воняю как зомби.", "PLAIN DOWN"];
							r_doLoop = false;
						};
					};
					if (dayz_inside) exitWith {
						cutText ["Хух! Теперь дождь не помеха.", "PLAIN DOWN"];
						r_doLoop = false;
					};
					sleep 1;          
				}; // end (timed) while loop
			};
		}else{
			if (dayz_combat != 1) then {hasGutsOnHim = true;  player removeAction s_player_cleanguts; s_player_cleanguts = -1;};
			if (sand_washed) then {call sand_endScript;};		
		};
		sleep 1;
	};
};

sand_endScript = {
	hasGutsOnHim = false; 
	sand_washed = true;	
	detach soundFly;
	deletevehicle soundFly;
	sand_USEDGUTS = nil;
	player removeAction s_player_cleanguts;
	s_player_cleanguts = -1;
};

player_guiControlFlash = {
	PVT(_control);
	_control = _this;
	if (ctrlShown _control) then {
		_control ctrlShow false;
	} else {
		_control ctrlShow true;
	};
};

while {true} do {
	waitUntil {sleep 0.5;(hasGutsOnHim)};
	DZ_ZCAMO_STARTTIME = time;
	sand_SkinType = typeOf player;
	[] spawn sand_shieldON;
	[] spawn sand_makeSounds;
	[] spawn sand_cleanCheck;
	waitUntil {sleep 0.5;((!hasGutsOnHim)||(typeOf player != sand_SkinType))};
	// Lose camo if player changes clothes
	if (typeOf player != sand_SkinType) then {
		[] spawn {
			systemChat "Пахну я теперь хорошо, но я не скрыт от зомби...";
			sleep 0.1;
			call sand_endScript;
			//waitUntil {!sand_washed};
			//hasGutsOnHim = true;
		};
	};
	[] spawn sand_shieldOFF;
};
