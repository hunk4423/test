/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

fnc_usec_damageHandle = {
	/***********************************************************
	ASSIGN DAMAGE HANDLER TO A UNIT
	- Function
	- [unit] call fnc_usec_damageHandle;
	************************************************************/
	PARAMS1(_unit);
	
	// Remove handle damage override
	// _unit removeEventHandler ["HandleDamage",temp_handler];

	mydamage_eh1 = _unit addeventhandler ["HandleDamage",{_this call fnc_usec_damageHandler;} ];
	mydamage_eh2 = _unit addEventHandler ["Fired", {_this call player_fired;}];
	mydamage_eh3 = _unit addEventHandler ["Killed", {_id = [] spawn player_death;}];
};

fnc_usec_pitchWhine = {
	PARAMS2(_visual,_sound);
	//affect the player
	0 fadeSound 0;
	playMusic ["PitchWhine",0];
	if (!r_player_unconscious) then {
		_visual call fnc_usec_bulletHit;
		_sound fadeSound 1;
	};
	r_pitchWhine = true;
	[] spawn {
		sleep 32;
		r_pitchWhine = false;
	};
};

fnc_usec_damageUnconscious = {
	PVT4(_unit,_damage,_inVehicle,_untime);
	EXPLODE2(_this,_unit,_damage);
	_inVehicle = (vehicle _unit != _unit);
	if ((_unit == player) || (vehicle player != player)) then {
		_untime = round((((random 2) max 0.1) * _damage) * 20);
		if((_untime > 60)&&!pvp_unconscious)then{_untime = 60;};
		if((floor(random(100)+1)<=50)&&("ItemEpinephrine" in magazines _unit)&&!pvp_unconscious&&(_untime > 10)&&!r_player_dead)then{
			_nil = EXECVM_SCRIPT(color_epi_use.sqf);
		};
		r_player_timeout = _untime;
		r_player_unconscious = true;
		player setVariable["medForceUpdate",true,true];
		player setVariable ["unconsciousTime", r_player_timeout, true];
	};
	if !(_inVehicle) then {
		_unit setVariable ["NORRN_unconscious", true, true];
		_unit switchMove "AmovPpneMrunSnonWnonDfr";
	};
};

//Action Handlers added to init file

fnc_usec_bulletHit = {
	PVT(_commit);
	_commit = _this;
	if (!r_player_unconscious) then {
		"colorCorrections" ppEffectEnable true;"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 0.1],  [1, 1, 1, 0.0]];"colorCorrections" ppEffectCommit 0;
		"dynamicBlur" ppEffectEnable true;"dynamicBlur" ppEffectAdjust [2]; "dynamicBlur" ppEffectCommit 0;
		addCamShake [5, 0.5, 25];
		"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 0.0]];"colorCorrections" ppEffectCommit _commit;
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit _commit;
	};
};

fnc_usec_damageType = {
	PVT3(_damage,_ammo,_type);
	EXPLODE2(_this,_damage,_ammo);
	_type = 0;
	if ((_ammo isKindof "Grenade") || (_ammo isKindof "ShellBase") ||  (_ammo isKindof "TimeBombCore") || (_ammo isKindof "BombCore") || (_ammo isKindof "MissileCore") || (_ammo isKindof "RocketCore") || (_ammo isKindof "FuelExplosion") || (_ammo isKindof "GrenadeBase")) then {
		_type = 1;
	};
	if ((_ammo isKindof "B_127x107_Ball") || (_ammo isKindof "B_127x99_Ball")) then {
		_type = 2;
	};
	if (_ammo isKindof "Melee") then {
		_type = 3;
	};

	_type;
};

fnc_usec_damageGetWound = {
	PVT5(_hit,_sPoint,_options,_rnd,_wound);
	_hit = format["%1",_this];
	_sPoint = USEC_woundHit find _hit;
	_options = USEC_woundPoint select _sPoint;
	_rnd = floor(random(count _options));
	_wound = _options select _rnd;
	_wound;
};

fnc_usec_medic_removeActions = {
	PVT(_obj);
	_obj = player;
	{
		_obj = _x;
		{
			_obj removeAction _x;
		} forEach r_player_actions;
	} forEach r_action_targets;
	r_player_actions = [];
	r_action_targets = [];
};

fnc_usec_self_removeActions = {
	{
		player removeAction _x;
	} count r_self_actions;
	r_self_actions = [];
};

fnc_med_publicBlood = {
	while {(r_player_injured || r_player_infected) && r_player_blood > 0} do {
		player setVariable["USEC_BloodQty",r_player_blood,true];
		player setVariable["medForceUpdate",true];
		sleep 5;
	};
};

fnc_usec_playerBleed = {
	private ["_bleedTime","_bleedPerSec","_total","_bTime","_myBleedTime","_id"];
	_bleedTime = 400;		//seconds
	_total = r_player_bloodTotal;
	r_player_injured = true;
	_myBleedTime = (random 300) + 30;
	_bTime = 0;
	while {r_player_injured} do {
		
		_bleedPerSec = 30;
		// If kneeling || crawling reduce bleeding
		if (dayz_isKneeling && !r_player_unconscious) then{
			_bleedPerSec = 15;
		};
		if (dayz_isCrawling && !r_player_unconscious) then{
			_bleedPerSec = 7.5;
		};

		//bleed out
		if (r_player_blood > 0) then {
			r_player_blood = r_player_blood - _bleedPerSec;
		};
		_bTime = _bTime + 1;
		if (_bTime > _myBleedTime) then {
			r_player_injured = false;
			_id = [player,player] execVM "\z\addons\dayz_code\medical\publicEH\medBandaged.sqf";
			dayz_sourceBleeding = objNull;
			{player setVariable[_x,false,true];} count USEC_woundHit;
			player setVariable ["USEC_injured",false,true];
		};
		sleep 1;
	};
};

fnc_usec_damageBleed = {
	/***********************************************************
	PROCESS DAMAGE TO A UNIT
	- Function
	- [_unit, _wound, _injury] call fnc_usec_damageBleed;
	************************************************************/
	private ["_unit","_wound","_injury","_modelPos","_point","_source","_rndX"];
	EXPLODE3(_this,_unit,_wound,_injury);

	_modelPos = [0,0,0];

	switch (_wound) do {
		case "Pelvis": {
			_modelPos = [0,0,0.2];
		};
		case "aimpoint": {
			_rndX = (0.1 - random 0.2);
			_modelPos = [_rndX,0,0.2];
		};
		case "RightShoulder": {
			_modelPos = [0,0,0.2];
		};
		case "LeftShoulder": {
			_modelPos = [0,0,0.2];
		};
	};

	while {true} do {
		scopeName "main";
		
		waitUntil {(vehicle _unit == _unit)};
		
		_point = "Logic" createVehicleLocal getPosATL _unit;
		_source = "#particlesource" createVehicleLocal getPosATL _unit;
		_source setParticleParams
		/*Sprite*/		[["\Ca\Data\ParticleEffects\Universal\Universal", 16, 13, 1],"",// File,Ntieth,Index,Count,Loop(Bool)
		/*Type*/			"Billboard",
		/*TimmerPer*/		1,
		/*Lifetime*/		0.2,
		/*Position*/		[0,0,0],
		/*MoveVelocity*/	[0,0,0.5],
		/*Simulation*/		1,0.32,0.1,0.05,//rotationVel,weight,volume,rubbing
		/*Scale*/			[0.05,0.25],
		/*Color*/			[[0.2,0.01,0.01,1],[0.2,0.01,0.01,0]],
		/*AnimSpeed*/		[0.1],
		/*randDirPeriod*/	0,
		/*randDirIntesity*/	0,
		/*onTimerScript*/	"",
		/*DestroyScript*/	"",
		/*Follow*/			_point];
		_source setParticleRandom [2, [0, 0, 0], [0.0, 0.0, 0.0], 0, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
		_source setDropInterval 0.02;
		_point attachTo [_unit,_modelPos,_wound];
		
		sleep 5;
		
		while {((_unit getVariable["USEC_injured",true]) && (alive _unit))} do {
			scopeName "loop";
			if (vehicle _unit != _unit) then {
				BreakOut "loop";
			};
			sleep 1;
		};
		deleteVehicle _source;
		deleteVehicle _point;
		
		if (!(_unit getVariable["USEC_injured",false])) then {
			BreakOut "main";
		};
	};
	
	deleteVehicle _source;
	deleteVehicle _point;
};

fnc_usec_recoverUncons = {
	player setVariable ["NORRN_unconscious",false,true];
	player setVariable ["unconsciousTime",0,true];
	player setVariable ["USEC_isCardiac",false,true];
	// player setVariable["medForceUpdate",true,true];

	r_player_unconscious = false;
	r_player_cardiac = false;
	r_player_handler1 = false;

	sleep 1;

	disableUserInput false;
	if !(vehicle player != player) then {
		[objNull,player,rSwitchMove,"AmovPpneMrunSnonWnonDfr"] call RE;
	};
	pvp_unconscious = false;
};

fnc_usec_addBlood = {
	PVT3(_value,_boost,_t);
	_boost=THIS0;
	_t=_boost/100;
	_p=_boost/_t;
	for "_i" from 1 to _t do{
		sleep 1;
		_value=_p+r_player_blood;
		if (_value > r_player_bloodTotal)exitWith{r_player_blood=r_player_bloodTotal;};
		r_player_blood=_value;
	};
	if(_boost>100)then{player setVariable['medForceUpdate',true,true];};
};

fnc_usec_setBlood = {
	PARAMS1PVT(_value);
	if (_value > r_player_bloodTotal)exitWith{r_player_blood=r_player_bloodTotal};
	r_player_blood=_value;
};

fnc_usec_SplintWound={
	PVT5(_type,_old,_new,_control,_done);
	_type=THIS0;
	_old=GETVAR(player,SplintWound,0);
	_done=true;
	player setHit["legs",0];
	player setHit["hands",0];
	switch(_type)do{
		case "morphine": {
			
			/*
			_new=1;
			player setVariable['USEC_inPain',false,true];
			r_player_inpain=false;
			R3F_TIRED_Accumulator=0;
			[] EXECVM_SCRIPT(morf.sqf);
			if(r_fracture_legs||r_fracture_arms)then{
				cutText["Уф, боль отпустила, но нога всё еще сломана, могу только ходить. \nНужна шина из дров и бинта.","PLAIN DOWN"];	
			};
			*/
		};
		case "WoodPile": {
			_new=2;
			if(!r_player_infected&&r_player_injured&&(floor(random(100)+1)<=50))then{
				r_player_infected=true;
				cutText["Зафиксировал перелом, но боль адская! Срочно нужно вколоть морфин! \nНу вот, заражение... Дрова же грязные, надо было остановить кровь...","PLAIN DOWN"];
			}else{
				cutText["Зафиксировал перелом, но боль адская! Срочно нужно вколоть морфин!","PLAIN DOWN"];		
			};
		};
	};
	if(true)then{
	// if((_old+_new)==3)then{
		//Болеуталяющее
		r_player_inpain=false;
		R3F_TIRED_Accumulator=0;
		player setVariable ["USEC_inPain", false, true];
		
		//Полный ремонт ног и рук
		r_fracture_legs=false;
		r_fracture_arms=false;
		player setHit['legs',0];
		player setHit['hands',0];
		player setVariable['hit_legs',0,true];
		player setVariable['hit_hands',0,true];
		_control=(uiNamespace getVariable 'DAYZ_GUI_display')displayCtrl 1203;
		_control ctrlShow false;
		// SETVARS(player,SplintWound,0);		
		// cutText["Нога зафиксирована, вроде не больно и могу бегать. Но доктору показаться стоит...","PLAIN DOWN"];
	}else{
		player setHit['legs',0];
		player setHit['hands',0];
		SETVARS(player,SplintWound,_new);
	};
	player setVariable['medForceUpdate',true,true];	
	[] EXECVM_SCRIPT(morf.sqf);
};