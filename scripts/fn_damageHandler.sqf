/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

scriptName "scripts\fn_damageHandler.sqf";
/***********************************************************
	PROCESS DAMAGE TO A UNIT
	- Function
	- [unit, selectionName, damage, source, projectile] call fnc_usec_damageHandler;
	- [cursortarget, "legs", 0.5] call fnc_usec_damageHandler;
************************************************************/
private ["_bloodloss","_pvp","_unit","_humanityHit","_myKills","_hit","_damage","_isPlayer","_unconscious","_wound","_isHit","_isInjured","_type","_hitPain","_isCardiac","_isHeadHit","_isMinor","_scale","_canHitFree","_rndPain","_rndInfection","_hitInfection","_lowBlood","_isPZombie","_source","_ammo","_unitIsPlayer","_isBandit"];
_unit = THIS0;

if((_unit getVariable["inSafeZone",false]))exitWith{};
if((_unit getVariable["taxi",false]))exitWith{};

_hit = THIS1;
_damage = THIS2;
_unconscious = _unit getVariable ["NORRN_unconscious", false];
_isPZombie = player isKindOf "PZombie_VB";
_source = THIS3;
_ammo = THIS4;
_type = [_damage,_ammo] call fnc_usec_damageType;

_isMinor = (_hit in USEC_MinorWounds);
_isHeadHit = (_hit == "head_hit");
//_evType = "";
//_recordable = false;
_isPlayer = (isPlayer _source);
_humanityHit = 0;
_myKills = 0;
_unitIsPlayer = _unit == player;
_pvp = false;


if((_ammo=="zombie")&&_unitIsPlayer)then{
	r_player_blood=r_player_blood-500-(random 200);
	1 call fnc_usec_bulletHit;
	_unit setVariable["startcombattimer", 1];

	if(RND(15))then{
		r_player_infected = true;
		player setVariable["USEC_infected",true,true];
	};

	if(RND(1.5))then{
		r_fracture_legs = true;
		player setHit["legs",1];
	};
	
	if(RND(80))then{
		_wound=_hit call fnc_usec_damageGetWound;

		if (RND(30)) then {
			r_player_inpain = true;
		};

		_unit setVariable[_wound,true,true];
		[_unit,_wound,_hit] spawn fnc_usec_damageBleed;
		{
			// only send to other players
			if(isPlayer _x && _x != player) then {
				PVDZE_send = [_x,"Bleed",[_unit,_wound,_hit]];
				publicVariableServer "PVDZE_send";
			};
		} count ((getPosATL _unit) nearEntities ["CAManBase",700]);

		//Set Injured if not already
		if !(_unit getVariable["USEC_injured",false]) then {
			_unit setVariable["USEC_injured",true,true];
			dayz_sourceBleeding = _source;
		};

		//Set ability to give blood
		if!(_unit getVariable["USEC_lowBlood",false]) then {
			_unit setVariable["USEC_lowBlood",true,true];
		};		
		r_player_injured = true;
	};
};

//PVP Damage
_scale = 200;
if (_ammo != "zombie") then {
	_scale = _scale + 50;
};
if (_isHeadHit) then {
	_scale = _scale + 500;
};
if ((isPlayer _source) && !(player == _source)) then {
	_scale = _scale + 800;
	if (_isHeadHit) then {
		_scale = _scale + 500;
	};
};
switch (_type) do {
	case 1: {_scale = _scale + 200};
	case 2: {_scale = _scale + 200};
};

//пвп защита
if (_unitIsPlayer) then {
	if ((_source != player) && _isPlayer) then {
		//Ложное срабатывание на меня
		if (name _source == name player) exitWith {};
		//Ложное срабатывание тем, кто у меня в машине.
		if (player in crew vehicle _source) exitWith {};

		//годмод
		_pvp = true;
		r_player_blood = r_player_blood - 10;
		
		//кровопотеря
		_bloodloss = (_damage * _scale);
		nopvpbloodloss = nopvpbloodloss + _bloodloss;

		//Сообщения
		if (isNil "shooting1") then {
			//Сообщения
			cutText [format["Игрок %1 пытается вас убить. Сделайте скриншот(нажмите F12). \n Обязательно сообщите администрации!",name _source], "PLAIN DOWN"];
			systemChat format ["Игрок %1 пытается вас убить. Сделайте скриншот(нажмите F12). Обязательно сообщите администрации!",name _source];

			//игрок в технике
			if (player != vehicle player) then {
				//Предупреждаем игрока
				PVDZE_send = [_source,"nopvp",[player,"NO"]];
				publicVariableServer "PVDZE_send";
			};
			
			shooting1 = true;
			[] EXECVM_SCRIPT(nopvp_timer.sqf);
		};

		//пеший
		if (nopvpbloodloss > 5000) then {
			if (isNil "shooting") then {
				//Наказываем игрока
				PVDZE_send = [_source,"nopvp",[player,"YES"]];
				publicVariableServer "PVDZE_send";

				nopvpbloodloss = 0;

				shooting = true;
				[] EXECVM_SCRIPT(nopvp_timer.sqf);
				[_source] EXECVM_SCRIPT(player_timer_forgiveness.sqf);
			};
		};	
	_source setVariable["startcombattimer",1];
	};
};

//Если пвп, выходим
if (_pvp) exitWith {};

//Record Damage to Minor parts (legs, arms)
if (_hit in USEC_MinorWounds) then {
	if (_ammo == "zombie") then {
		if (_hit == "legs") then {
			[_unit,_hit,(_damage / 6)] call object_processHit;
		} else {
			[_unit,_hit,(_damage / 4)] call object_processHit;
		};
	} else {
		[_unit,_hit,(_damage / 2)] call object_processHit;
	};
	if (_ammo == "") then {
		[_unit,_hit,_damage] call object_processHit;
	};
};

if (_unitIsPlayer) then {
//incombat
	_unit setVariable["startcombattimer", 1];
};

if (_damage > 0.1) then {
	if (_unitIsPlayer) then {
		//shake the cam, frighten them!
		//player sidechat format["Processed bullet hit for %1 (should only be for me!)",_unit];
		1 call fnc_usec_bulletHit;
	};
	if (local _unit) then {
		_unit setVariable["medForceUpdate",true,true];
	};
};
if (_damage > 0.4) then {	//0.25
	/*
		BLEEDING
	*/
	_wound = _hit call fnc_usec_damageGetWound;
	_isHit = _unit getVariable[_wound,false];
	if (_unitIsPlayer) then {
		_rndPain =		(random 10);
		_rndInfection = (random 500);
		_hitPain =		(_rndPain < _damage);
		if ((_isHeadHit) || (_damage > 1.2 && _hitPain)) then {
			_hitPain = true;
		};
		_hitInfection = (_rndInfection < 1);
		//player sidechat format["HitPain: %1, HitInfection %2 (Damage: %3)",_rndPain,_rndInfection,_damage]; //r_player_infected
		if (_isHit) then {
			//Make hit worse
			if (_unitIsPlayer) then {
				r_player_blood = r_player_blood - 50;
			};
		};
		if (_hitInfection) then {
			//Set Infection if not already
			if (_unitIsPlayer && !_isPZombie) then {
				r_player_infected = true;
				player setVariable["USEC_infected",true,true];
			};
		};
		if (_hitPain) then {
			//Set Pain if not already
			if (_unitIsPlayer) then {
				r_player_inpain = true;
				player setVariable["USEC_inPain",true,true];
			};
		};
		if ((_damage > 1.5) && _isHeadHit) then {
			[_source,"shothead"] spawn player_death;
		};
	};
	if(!_isHit) then {
		if(!_isPZombie) then {
			//Create Wound
			_unit setVariable[_wound,true,true];

			[_unit,_wound,_hit] spawn fnc_usec_damageBleed;
			/* PVS/PVC - Skaronator */
			_pos = getPosATL _unit;
			_inRange = _pos nearEntities ["CAManBase",1000];
			{
				// only send to other players
				if(isPlayer _x && _x != player) then {
					PVDZE_send = [_x,"Bleed",[_unit,_wound,_hit]];
					publicVariableServer "PVDZE_send";
				};
			} count _inRange;

			//Set Injured if not already
			_isInjured = _unit getVariable["USEC_injured",false];
			if (!_isInjured) then {
				_unit setVariable["USEC_injured",true,true];
			if ((_unitIsPlayer) && (_ammo != "zombie")) then {
					dayz_sourceBleeding = _source;
				};
			};
			//Set ability to give blood
			_lowBlood = _unit getVariable["USEC_lowBlood",false];
			if (!_lowBlood) then {
				_unit setVariable["USEC_lowBlood",true,true];
			};
			if (_unitIsPlayer) then {
				r_player_injured = true;
			};
		};
	};
};
if (_type == 1) then {
	/*
		BALISTIC DAMAGE
	*/
	if ((_damage > 0.01) && (_unitIsPlayer)) then {
		//affect the player
		[20,45] call fnc_usec_pitchWhine; //Visual , Sound
	};
	if (_damage > 4) then {
		//serious ballistic damage
		if (_unitIsPlayer) then {
			[_source,"explosion"] spawn player_death;
		};
	} else {
		if (_damage > 2) then {
			_isCardiac = _unit getVariable["USEC_isCardiac",false];
			if (!_isCardiac) then {
				_unit setVariable["USEC_isCardiac",true,true];
				r_player_cardiac = true;
			};
		};
	};
};
if (_type == 2) then {
	/*
		HIGH CALIBRE
	*/
	if (_damage > 4) then {
		//serious ballistic damage
		if (_unitIsPlayer) then {
			[_source,"shotheavy"] spawn player_death;
		};
	} else {
		if (_damage > 2) then {
			_isCardiac = _unit getVariable["USEC_isCardiac",false];
			if (!_isCardiac) then {
				_unit setVariable["USEC_isCardiac",true,true];
				r_player_cardiac = true;
			};
		};
	};
};

if (!_unconscious && !_isMinor && ((_damage > 2) || ((_damage > 0.5) && _isHeadHit))) then {
	//set unconsious
	[_unit,_damage] call fnc_usec_damageUnconscious;
};
