/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
// Vehicle Service Point by Axe Cop
private ["_SP_reammo","_donat_repair","_donat_reammo","_half_free_repair","_half_free_reammo","_free_all","_SP_all","_actionCostsFormat","_SP_array","_lastVehicle","_lastRole","_messageShown","_fnc_removeActions"];
_donat_repair = ["UralRepair_CDF","UralRepair_INS","KamazRepair","MtvrRepair","UralRepair_TK_EP1","MtvrRepair_DES_EP1"];
_donat_reammo = ["UralReammo_CDF","UralReammo_INS","KamazReammo","MtvrReammo","UralReammo_TK_EP1","MtvrReammo_DES_EP1","V3S_Reammo_TK_GUE_EP1"];
_half_free_repair=["V3S_Repair_TK_GUE_EP1"];
_half_free_reammo=["UralOpen_INS"];
_free_all=["WarfareReammoTruck_RU","WarfareReammoTruck_CDF","WarfareReammoTruck_USMC","SeaFox"];
_SP_all=dayz_fuelpumparray+_donat_repair+_donat_reammo+_half_free_repair+_half_free_reammo+_free_all; 
_actionCostsFormat = "%2 %1";

//["тип_техники",заправка,колл_пива,ремонт]
_SP_array=[
	//Самолеты
	["Plane",200,1,200], 
 	
	//Вертолеты	
	["CH_47F_BAF",1000,3,2000],
	["CH_47F_EP1_DZE",1000,3,2000], 
	["BAF_Merlin_HC3_D",1000,3,2000],
	["BAF_Merlin_DZE",1000,3,2000],
	["CH53_DZE",1000,3,2000],
	
	["AH6X_DZ",200,1,500],  
	["AH6J_EP1",200,1,500],  
	["MH6J_DZ",200,1,500],  
	["pook_H13_civ",500,1,500], 
	["pook_H13_civ_ru_yellow",200,1,500], 
	["pook_H13_civ_ru_black",200,1,500], 
	["pook_H13_medevac_CIV_RU",200,1,500], 
	["pook_H13_gunship_PMC",200,1,500],
	["CSJ_GyroP",200,1,500], 
	["CSJ_GyroCover",200,1,500], 
	["CSJ_GyroC",200,1,500], 
	["Air",1000,3,2000], 

	//Колесная броня
	["BTR90",1500,3,1500],
	["BTR90_HQ_DZ",1500,3,1500],
	["LAV25",1500,3,1500],
	["LAV25_HQ_DZ",1500,3,1500],
	["BTR60",1500,3,1500],
	["Wheeled_APC",1000,3,1000], 
	
	//Разное
	["Truck",500,3,1000],
	["Motorcycle",100,1,500],
	["Tank",1000,3,500],
	["Car",300,2,1000],
	["Ship",100,1,200],
	["AllVehicles",300,2,1000]
];
_SP_reammo=[
	["2Rnd_R73",5000],
	["80Rnd_80mm",5000],
	["80Rnd_S8T",5000],
	["Laserbatteries",3000],
	["180Rnd_30mm_GSh301",5000],
	["6Rnd_Ch29",5000],
	["4Rnd_Ch29",5000],
	["4Rnd_R73",5000],
	["192Rnd_57mm",5000],
	["6Rnd_Mk82",5000],
	["64Rnd_57mm",5000],
	["128Rnd_57mm",5000],
	["28Rnd_FFAR",1000],
	["300Rnd_25mm_GAU12",1000],
	["2Rnd_GBU12",5000],
	["2Rnd_Sidewinder_F35",3000],
	["40Rnd_S8T",5000],
	["40Rnd_80mm",5000],
	["12Rnd_Vikhr_KA50",1000],
	["6Rnd_TOW_HMMWV",1000],
	["6Rnd_TOW2",1000],
	["500Rnd_145x115_KPVT",1000],
	["4000Rnd_762x51_M134",3000],
	["ARTY_40Rnd_120mmHE_BM21",0],
	["40Rnd_GRAD",5000],
	["50Rnd_127x108_KORD",500],
	["150Rnd_127x108_KORD",500],
	["8Rnd_AT10_BMP3",3000],
	["33Rnd_85mmHE",1000],
	["10Rnd_85mmAP",1000],
	["60Rnd_762x54_DT",300],
	["210Rnd_25mm_M242_HEI",1000],
	["210Rnd_25mm_M242_APDS",1000],
	["1200Rnd_762x51_M240",1000],
	["100Rnd_762x51_M240",400],
	["2Rnd_TOW",1000],
	["2Rnd_TOW2",1000],
	["8Rnd_AT5_BMP2",5000],
	["100Rnd_127x99_M2",1000],
	["400Rnd_30mm_AGS17",5000],
	["1500Rnd_762x54_PKT",1000],
	["100Rnd_762x54_PK",300],
	["2000Rnd_762x54_PKT",1500],
	["250Rnd_762x54_PKT_T90",600],
	["240Rnd_CMFlare_Chaff_Magazine",500],
	["200Rnd_762x54_PKT",300]
];
_lastVehicle=objNull;
_lastRole=[];
SP_refuel_action = -1;
SP_refuel_beer_action = -1;
SP_repair_action = -1;
SP_rearm_actions = [];
_messageShown = false;

_fnc_removeActions = {
	if (isNull _lastVehicle) exitWith {};
	_lastVehicle removeAction SP_refuel_action;
	_lastVehicle removeAction SP_refuel_beer_action;
	SP_refuel_action = -1;
	SP_refuel_beer_action = -1;
	_lastVehicle removeAction SP_repair_action;
	SP_repair_action = -1;
	{
		_lastVehicle removeAction _x;
	} forEach SP_rearm_actions;
	SP_rearm_actions=[];
	_lastVehicle=objNull;
	_lastRole=[];
};

_fnc_getCosts = {
	PVT5(_vehicle,_status,_cost,_prices,_type);
	PARAMS3(_vehicle,_status,_type);
	if(({_x == 2}count _status) == 3)exitWith{0};
	if(_type==2)then{
		_cost=2000;
		{
			EXPLODE1_PVT(_x,_typeName);
			if(_vehicle == _typeName)exitWith{
				_cost=SEL1(_x);
			};
		} forEach _SP_reammo;
	}else{
		{
			EXPLODE1_PVT(_x,_typeName);
			if(_vehicle isKindOf _typeName)exitWith{
				_prices=_x;
			};
		} forEach _SP_array;
		switch(_type)do{
			case 0: {_cost=SEL1(_prices);};
			case 1: {_cost=SEL3(_prices);};
			case 3: {_cost=SEL2(_prices);};
		};		
	};
	switch(_status select _type)do{
		case 1: {_cost=_cost /2;};
		case 2: {_cost=0;};
	};
	_cost
};
 
_fnc_actionTitle = {
	PVT5(_actionName,_price,_costsText,_actionTitle,_type);
	PARAMS3(_actionName,_price,_type);
	if(_type==3)then{
		_costsText=format[_actionCostsFormat,"пиво",_price];
	}else{
		if(_price>0)then{
			_costsText=format[_actionCostsFormat,"руб.",[_price] call BIS_fnc_numberText];
		}else{
			_costsText="Бесплатно";
		};
	};
	_actionTitle=format["%1 (%2)",_actionName,_costsText];
	_actionTitle
};
 
_fnc_isArmed = {
	PVT2(_role,_armed);
	_role = _this;
	_armed = count _role > 1;
	_armed
};
 
_fnc_getWeapons = {
	PVT3(_vehicle,_role,_weapons);
	PARAMS2(_vehicle,_role);
	_weapons = [];
	if (count _role > 1) then {
		PVT2(_turret,_weaponsTurret);
		_turret=SEL1(_role);
		_weaponsTurret = _vehicle weaponsTurret _turret;
		{
			PVT1(_weaponName);
			_weaponName = getText (configFile >> "CfgWeapons" >> _x >> "displayName");
			_weapons set [count _weapons, [_x, _weaponName, _turret]];
		} forEach _weaponsTurret;
	};
	_weapons
};
_fnc_getTraif  = {
	PARAMS1PVT(_array);
	if({
		if((typeOf _x) in _array)exitWith{1}
	}count _nearestSP == 1)then{true}else{false};	
};
/* 
	_type
	0 - заправка
	1 - ремонт
	2 - перезарядка
	3 - заправка за пиво

	_status=[заправка,починка,перезарядка]
	0 - стандарт
	1 - -50%
	2 - бесплатно
*/	
while{true}do{
	private ["_first_nearestSP","_vehicle","_nearestSP","_role","_actionCondition","_status","_beer","_price","_actionTitle","_mag","_isFlare"];
	_vehicle=vehicle player;
	if (((local _vehicle)||(assignedGunner _vehicle)==player)&&(_vehicle != player))then{
		_first_nearestSP=(nearestObjects [getPosATL _vehicle,_SP_all, 30])-[_vehicle];
		if(count _first_nearestSP>0)then{
			_nearestSP=[];
			{
				if!(locked _x)then{_nearestSP=_nearestSP+[_x]};
			}forEach _first_nearestSP;
			
			if(count _nearestSP>0)then{
				if (assignedDriver _vehicle == player)then{
					_role=["Driver", [-1]];
				} else {
					_role=assignedVehicleRole player;
				};
				if (((str _role) != (str _lastRole)) || (_vehicle != _lastVehicle)) then {
					// vehicle or seat changed
					call _fnc_removeActions;
				};
				_lastVehicle=_vehicle;
				_lastRole=_role;
				_actionCondition="vehicle _this == _target";
			
				_status=[0,0,0];
				_beer=true;
				if([_half_free_repair] call _fnc_getTraif)then{_status set [1,1];};
				if([_half_free_reammo] call _fnc_getTraif)then{_status set [2,1];};
				if([_donat_repair] call _fnc_getTraif)then{_status set [1,2];};
				if([_donat_reammo] call _fnc_getTraif)then{_status set [2,2];};
				if([_free_all] call _fnc_getTraif)then{_status=[2,2,2];_beer=false;};

				if (SP_refuel_action < 0) then {
					_price=[_vehicle,_status,0] call _fnc_getCosts;
					_actionTitle=["<t color='#5882FA'>Заправить технику</t>",_price,0] call _fnc_actionTitle;
					SP_refuel_action=_vehicle addAction [_actionTitle, SCRIPT_FILE(service_point_refuel.sqf),_price, -100, false, true, "", _actionCondition];
				};
				if(_beer)then{
					if (SP_refuel_beer_action < 0) then {
						_price=[_vehicle,_status,3] call _fnc_getCosts;
						_actionTitle = ["<t color='#5882FA'>Заправить технику</t>",_price,3] call _fnc_actionTitle;
						SP_refuel_beer_action = _vehicle addAction [_actionTitle, SCRIPT_FILE(service_point_refuel_beer.sqf),_price, -101, false, true, "", _actionCondition];
					};
				};
				if (SP_repair_action < 0) then {
					_price=[_vehicle,_status,1] call _fnc_getCosts;
					_actionTitle = ["<t color='#5882FA'>Починить технику</t>",_price,1] call _fnc_actionTitle;
					SP_repair_action=_vehicle addAction [_actionTitle, SCRIPT_FILE(service_point_repair.sqf),[_price], -102, false, true, "", _actionCondition];
				};
				if ((_role call _fnc_isArmed) && (count SP_rearm_actions == 0)) then {
				private ["_weapons","_weaponName","_weaponType","_magazines","_weapon"];
					_weapons=[_vehicle,_role] call _fnc_getWeapons;
					{
						_weaponName=SEL1(_x);
						_weaponType=SEL0(_x);
						_magazines=getArray (configFile >> "CfgWeapons" >> _weaponType >> "magazines");
						_weapon=_x;
						{	
							_mag=_x;
							_isFlare=_weaponType=="CMFlareLauncher";
							if(_isFlare)then{_mag="240Rnd_CMFlare_Chaff_Magazine";};
							_price=[_mag,_status,2] call _fnc_getCosts;
							_actionTitle=[format["<t color='#5882FA'>Перезарядить </t>%1 (%2)", _weaponName, getText(configFile >> "CfgMagazines" >> _x >> "displayName")],_price,2] call _fnc_actionTitle;
							SP_rearm_action=_vehicle addAction [_actionTitle, SCRIPT_FILE(service_point_rearm.sqf), [_price,_weapon,_x], -103, false, true, "", _actionCondition];
							SP_rearm_actions set [count SP_rearm_actions, SP_rearm_action];
							if(_isFlare)exitWith{};
						} forEach _magazines;
					} forEach _weapons;
				};
				if(!_messageShown)then{
					_messageShown=true;
					_vehicle vehicleChat "Заправить, починить, зарядить патроны? Подъезжай, не дорого!";
				};
			} else {
				call _fnc_removeActions;
				_messageShown=false;
			};
		} else {
			call _fnc_removeActions;
			_messageShown=false;
		};
	} else {
		call _fnc_removeActions;
		_messageShown = false;
	};
	sleep 3;
};