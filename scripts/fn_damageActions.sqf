/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

scriptName "Functions\misc\fn_damageActions.sqf";
/***********************************************************
	ADD ACTIONS FOR A CASUALTY
	- Function
	- [] call fnc_usec_damageActions;
************************************************************/
private ["_SplintWound","_Ct","_isAlive","_vehicle","_inVehicle","_isClose","_assignedRole","_driver","_action","_turret","_vehClose","_weaponName","_unconscious","_playerMagazines","_action1","_vehType","_fuel","_typeVeh","_crew","_unconscious_crew","_isAir","_alt","_reset","_isfold","_isramp","_isdoor1","_isdoor2","_isdoor3","_speed","_new_state"];
disableSerialization;
if (DZE_ActionInProgress) exitWith {}; // Do not allow if any script is running.

_Ct = cursorTarget;
_isAlive = alive _Ct;
_vehicle = vehicle player;
_vehType = typeOf _vehicle;
_inVehicle = (_vehicle != player);
_isClose = ((player distance _Ct) < ((sizeOf typeOf _Ct) / 2));

if (_inVehicle) then {
	r_player_lastVehicle = _vehicle;
	_assignedRole = assignedVehicleRole player;
	_driver = driver (vehicle player);
	_isAir = _vehicle isKindOf "Air";
	if (str (_assignedRole) != str (r_player_lastSeat)) then {
		call r_player_removeActions2;
	};
	if (!r_player_unconscious && !r_action2) then {
		r_player_lastSeat = _assignedRole;
		if (_isAir || ({(isPlayer _x) && (alive _x)} count (crew _vehicle) > 1)) then {
			//allow switch to pilot
			if (((_assignedRole select 0) != "driver") && ((!alive _driver) || ((_vehicle emptyPositions "Driver") > 0))) then {
				if (_isAir) then {
					_action = _vehicle addAction[localize "STR_EPOCH_PLAYER_308A", "\z\addons\dayz_code\actions\veh_seatActions.sqf", ["MoveToPilot", _driver], 0, false, true];
				} else {
					_action = _vehicle addAction[localize "STR_EPOCH_PLAYER_308", "\z\addons\dayz_code\actions\veh_seatActions.sqf", ["MoveToPilot", _driver], 0, false, true];
				};
				r_player_actions2 set [count r_player_actions2,_action];
				r_action2 = true;
			};
			//allow switch to cargo
			if (((_assignedRole select 0) != "cargo") && ((_vehicle emptyPositions "Cargo") > 0)) then {
				_action = _vehicle addAction [localize "STR_EPOCH_PLAYER_309", "\z\addons\dayz_code\actions\veh_seatActions.sqf",["MoveToCargo",_driver], 0, false, true];
				r_player_actions2 set [count r_player_actions2,_action];
				r_action2 = true;
			};
			//allow switch to gunner
			if (((_assignedRole select 0) != "Turret") && ((_vehicle emptyPositions "Gunner") > 0)) then {
				_action = _vehicle addAction[localize "STR_EPOCH_PLAYER_310", "\z\addons\dayz_code\actions\veh_seatActions.sqf", ["MoveToTurret", _driver], 0, false, true];
				r_player_actions2 set [count r_player_actions2,_action];
				r_action2 = true;
			};
			//allow switch to commander
			if (((assignedCommander _vehicle) != player) && ((_vehicle emptyPositions "Commander") > 0)) then {
				_action = _vehicle addAction[localize "STR_EPOCH_PLAYER_311", "\z\addons\dayz_code\actions\veh_seatActions.sqf", ["MoveToTurret", _driver], 0, false, true];
				r_player_actions2 set [count r_player_actions2,_action];
				r_action2 = true;
			};
		};
		if (count _assignedRole > 1) then {
			_turret = _assignedRole select 1;
			{
				_weaponName = getText (configFile >> "cfgWeapons" >> _x >> "displayName");
				_action = _vehicle addAction [format["Add AMMO to %1",_weaponName], "\z\addons\dayz_code\actions\ammo.sqf",[_vehicle,_x,_turret], 0, false, true];
				r_player_actions2 set [count r_player_actions2,_action];
				r_action2 = true;
			} count (_vehicle weaponsTurret _turret);
		};
	};
	if(_isAir)exitWith{
		_alt=SEL2([_vehicle] call FNC_getPos);
		if (_vehicle isKindOf "MV22_DZ")exitWith{
			s_player_lastMV22=_vehicle;
			if (_driver==player)then{
				if(_vehicle animationPhase "turn_wing"!=0)then{_isfold=1}else{_isfold=0};
				if((_vehicle animationPhase "ramp_top"!=0)||(_vehicle animationPhase "ramp_bottom"!=0))then{_isramp=1}else{_isramp=0};
				_reset=false;
				if (_isfold==1 && isEngineOn _vehicle)then{
					[_vehicle,"fold",0] call mv22_anim;
					_isfold=0;
					_reset=true;
				};
				_new_state=[_isramp,_isfold];
				if (!_reset)then{
					{if(SEL(_new_state,_forEachIndex)!=_x)exitWith{_reset=true}} forEach s_mv22_state;
				};
				s_mv22_state=_new_state;
				if (_reset&&s_actionMV22)then{
					call s_player_removeActionsMV22;
				};
				if (!r_player_unconscious && !s_actionMV22)then{
					if (_alt<10 && !(isEngineOn _vehicle))then{
						if (_isfold==1)then{
							_action=_vehicle addAction ["<t color='#5882FA'>Режим полета</t>",SCRIPT_FILE(veh_mv22anim.sqf),["fold",0],-9,false,true];
						}else{
							_action=_vehicle addAction ["<t color='#5882FA'>Режим буксировки</t>",SCRIPT_FILE(veh_mv22anim.sqf),["fold",1],-9,false,true];
						};
						s_mv22_action set [CNT(s_mv22_action),_action];
					};
					if (_isramp==1)then{
						_action=_vehicle addAction ["<t color='#5882FA'>Поднять рампу</t>",SCRIPT_FILE(veh_mv22anim.sqf),["ramp",0],-9,false,true];
					}else{
						_action=_vehicle addAction ["<t color='#5882FA'>Опустить рампу</t>",SCRIPT_FILE(veh_mv22anim.sqf),["ramp",1],-9,false,true];
					};
					s_mv22_action set [CNT(s_mv22_action),_action];
					s_actionMV22=true;
				};
			}else{
				if (s_actionMV22)then{call s_player_removeActionsMV22};
			};
		};
		if (_vehicle isKindOf "C130J_base")exitWith{
			s_player_lastC130=_vehicle;
			if (_driver==player)then{
				if((_vehicle animationPhase "ramp_top" == 1)||(_vehicle animationPhase "ramp_bottom" == 1))then{_isramp=1}else{_isramp=0};
				if(_vehicle animationPhase "door_1" == 1)then{_isdoor1=1}else{_isdoor1=0};
				if(_vehicle animationPhase "door_2_1" == 1)then{_isdoor2=1}else{_isdoor2=0};
				if(_vehicle animationPhase "door_2_2" == 1)then{_isdoor3=1}else{_isdoor3=0};
				_speed=speed _vehicle;
				_reset=false;
				if (_speed>5)then{
					if (_isdoor1==1)then{[_vehicle,"door1",0] call c130_anim;_isdoor1=0;_reset=true};
					if (_isdoor2==1)then{[_vehicle,"door2",0] call c130_anim;_isdoor2=0;_reset=true};
					if (_isdoor3==1)then{[_vehicle,"door3",0] call c130_anim;_isdoor3=0;_reset=true};
				};
				_new_state=[_isramp,_isdoor1,_isdoor2,_isdoor3];
				if (!_reset)then{
					{if(SEL(_new_state,_forEachIndex)!=_x)exitWith{_reset=true}} forEach s_c130_state;
				};
				s_c130_state=_new_state;
				if (_reset)then{
					if (s_actionC130)then{call s_player_removeActionsC130};
				};
				if (!r_player_unconscious && !s_actionC130)then{
					if (_speed<5)then{
						if (_isdoor1==1)then{
							_action=_vehicle addAction ["<t color='#5882FA'>Закрыть дверь 1</t>",SCRIPT_FILE(veh_c130anim.sqf),["door1",0],-9,false,true];
						}else{
							_action=_vehicle addAction ["<t color='#5882FA'>Открыть дверь 1</t>",SCRIPT_FILE(veh_c130anim.sqf),["door1",1],-9,false,true];
						};
						s_c130_action set [CNT(s_c130_action),_action];
						if (_isdoor2==1)then{
							_action=_vehicle addAction ["<t color='#5882FA'>Закрыть дверь 2</t>",SCRIPT_FILE(veh_c130anim.sqf),["door2",0],-9,false,true];
						}else{
							_action=_vehicle addAction ["<t color='#5882FA'>Открыть дверь 2</t>",SCRIPT_FILE(veh_c130anim.sqf),["door2",1],-9,false,true];
						};
						s_c130_action set [CNT(s_c130_action),_action];
						if (_isdoor3==1)then{
							_action=_vehicle addAction ["<t color='#5882FA'>Закрыть дверь 3</t>",SCRIPT_FILE(veh_c130anim.sqf),["door3",0],-9,false,true];
						}else{
							_action=_vehicle addAction ["<t color='#5882FA'>Открыть дверь 3</t>",SCRIPT_FILE(veh_c130anim.sqf),["door3",1],-9,false,true];
						};
						s_c130_action set [CNT(s_c130_action),_action];
					};
					if (_isramp==1)then{
						_action=_vehicle addAction ["<t color='#5882FA'>Закрыть рампу</t>",SCRIPT_FILE(veh_c130anim.sqf),["ramp",0],-9,false,true];
					}else{
						_action=_vehicle addAction ["<t color='#5882FA'>Открыть рампу</t>",SCRIPT_FILE(veh_c130anim.sqf),["ramp",1],-9,false,true];
					};
					s_c130_action set [CNT(s_c130_action),_action];
					s_actionC130=true;
				};
			}else{
				if (s_actionC130)then{call s_player_removeActionsC130};
			};
		};
	};
	if (_vehicle isKindOf "ArmoredSUV_Base_PMC")exitWith{
		s_player_lastSuv=_vehicle;
		if(_vehicle animationPhase "HideGun_01" != 0)then{_isfold=1}else{_isfold=0};
		if (_isfold==1) then {
			_unit = _vehicle turretUnit [0];
			if (!(isNull _unit)) then {
				if (_unit==player)then{
					_unit action ["moveToCargo",_vehicle,2];
					titleText ["\n\n Турель опущена","PLAIN DOWN"];titleFadeOut 4;
				};
			};
		};
		if (_driver==player)then{
			if (_isfold!=s_suv_state)then{call s_player_removeActionsSuv;s_suv_state=_isfold};
			if (!r_player_unconscious && s_suv_action==-1)then{
				if (_isfold==1)then{
					s_suv_action = _vehicle addAction ["<t color='#5882FA'>Поднять турель</t>",SCRIPT_FILE(suv_open.sqf),"",-9,false,true];
				}else{
					s_suv_action = _vehicle addAction ["<t color='#5882FA'>Опустить турель</t>",SCRIPT_FILE(suv_close.sqf),"",-9,false,true];
				};
			};
		}else{
			if (s_suv_action>-1)then{call s_player_removeActionsSuv};
		};
	};
#ifdef _ORIGINS
	if (_vehicle isKindOf "ori_submarine")exitWith{
		if (_driver==player)then{
			s_player_lastSub=_vehicle;
			if (!r_player_unconscious && s_sub_action==-1)then{
				if (_vehicle animationPhase "sink" == 1)then{
					s_sub_action=_vehicle addAction ["<t color='#5882FA'>Всплыть</t>",SCRIPT_FILE(veh_sub.sqf),0,-9,false,true];
				}else{
					s_sub_action=_vehicle addAction ["<t color='#5882FA'>Погрузиться</t>",SCRIPT_FILE(veh_sub.sqf),1,-9,false,true];
				};
			};
		}else{
			if (s_sub_action>-1)then{call s_player_removeActionsSub};
		};
	};
#endif
} else {
	if (r_action2)then{
		call r_player_removeActions2;
		r_player_lastVehicle=objNull;
	};
	r_player_lastSeat=[];
	if (s_actionMV22)then{
		call s_player_removeActionsMV22;
		s_player_lastMV22=objNull;
	};
	if (s_actionC130)then{
		call s_player_removeActionsC130;
		s_player_lastC130=objNull;
	};
	if (s_suv_action>-1)then{
		call s_player_removeActionsSuv;
		s_player_lastSuv=objNull;
	};
#ifdef _ORIGINS
	if (s_sub_action>-1)then{
		call s_player_removeActionsSub;
		s_player_lastSub=objNull;
	};
#endif
};

if (!isNull _Ct && _isAlive && !r_drag_sqf && !r_action && !_inVehicle && !r_player_unconscious && _isClose) then {
	_playerMagazines = magazines player;
	if(_Ct isKindOf "Man")then{
		_vehClose =		(getPosATL player) nearEntities [["Car","Tank","Helicopter","Plane","StaticWeapon","Ship"],5];
		_unconscious =	GETVAR(_Ct,NORRN_unconscious,false);

		//Allow player to drag
		if(_unconscious) then {
			r_action = true;
			_action1 = _Ct addAction [localize "str_actions_medical_01", "\z\addons\dayz_code\medical\drag.sqf",_Ct, 0, true, true];
			r_player_actions = r_player_actions + [_action1];

			//Load Vehicle
			if ({alive _x} count _vehClose > 0) then {
				_x = 0;
				r_action = true;
				_vehicle = (_vehClose select _x);
				while{((!alive _vehicle) && (_x < (count _vehClose)))} do {
					_x = _x + 1;
					_vehicle = (_vehClose select _x);
				};
				_action = _Ct addAction [format[localize "str_actions_medical_03",_vehType], "\z\addons\dayz_code\medical\load\load_act.sqf",[player,_vehicle,_Ct], 0, true, true];
				r_player_actions set [count r_player_actions,_action];
			};
		};
		//Allow player to bandage
		if((GETVAR(_Ct,USEC_injured,false)) && ("ItemBandage" in _playerMagazines)) then {
			r_action = true;
			_action = _Ct addAction [localize "str_actions_medical_04", SCRIPT_FILE(bandage.sqf),[_Ct], 0, true, true, "", ""];
			r_player_actions set [count r_player_actions,_action];
		};
		//Allow player to give Epinephrine
		if((_unconscious || (GETVAR(_Ct,medDeathSafe,false))) && ("ItemEpinephrine" in _playerMagazines)) then {
			r_action = true;
			_action = _Ct addAction [localize "str_actions_medical_05", SCRIPT_FILE(epinephrine.sqf),[_Ct], 0, true, true];
			r_player_actions set [count r_player_actions,_action];
		};
		//Allow player to give Morphine
		if((((GETVAR(_Ct,hit_legs,0)) >= 1) || ((GETVAR(_Ct,hit_hands,0)) >= 1)) && ("ItemMorphine" in _playerMagazines)) then {
			r_action = true;
			_action = _Ct addAction [localize "str_actions_medical_06", SCRIPT_FILE(morphine.sqf),[_Ct], 0, true, true, "", ""];
			r_player_actions set [count r_player_actions,_action];			
			if(((GETVAR(_Ct,SplintWound,0))<= 1))then{
				_SplintWound = _Ct addAction ["Наложить шину", SCRIPT_FILE(player_SplintWound.sqf),[_Ct], 0, true, true, "", ""];
				r_player_actions set [count r_player_actions,_SplintWound];
			};
		};
		//Allow player to give Painkillers
		if((GETVAR(_Ct,USEC_inPain,false)) && ("ItemPainkiller" in _playerMagazines)) then {
			r_action = true;
			_action = _Ct addAction [localize "str_actions_medical_07", SCRIPT_FILE(painkiller.sqf),[_Ct], 0, true, true, "", ""];
			r_player_actions set [count r_player_actions,_action];
		};
		//Allow player to transfuse blood
		if((GETVAR(_Ct,USEC_lowBlood,false)) && ("ItemBloodbag" in _playerMagazines)) then {
			r_action = true;
			_action = _Ct addAction [localize "str_actions_medical_08", SCRIPT_FILE(transfusion.sqf),[_Ct], 0, true, true, "", ""];
			r_player_actions set [count r_player_actions,_action];
		};	
		//Прощение после пвп
		if((GETVAR(_Ct,PvPStatus,"")) == name player) then {
			r_action = true;
			_action = _Ct addAction [("<t color='#5882FA'>")+("Понять и простить")+("</t>"), SCRIPT_FILE(player_send_nopvpforgive.sqf),[_Ct], -25, true, true, "", ""];
			r_player_actions set [count r_player_actions,_action];
		};
	}else{
		//Repairs
	if(({_Ct isKindOf _x}count["LandVehicle","Air","Ship"] > 0) && !(typeOf _Ct in ["M240Nest_DZ"])) then {
			_typeVeh = getText(configFile >> "cfgVehicles" >> typeOf _Ct >> "displayName");
			_fuel=fuel _Ct;
			//CAN WE REFUEL THE OBJECT?
			if ((_fuel < 1) && (("ItemJerrycan" in _playerMagazines) || ("ItemFuelBarrel" in _playerMagazines))) then {
				r_action = true;
				_action = _Ct addAction [format[localize "str_actions_medical_10",_typeVeh], "\z\addons\dayz_code\actions\refuel.sqf",[], 0, true, true, "", ""];
				r_player_actions set [count r_player_actions,_action];
			};
			//CAN WE siphon fuel from THE OBJECT?
			if ((_fuel > 0) && (("ItemJerrycanEmpty" in _playerMagazines) || ("ItemFuelBarrelEmpty" in _playerMagazines))) then {
				r_action = true;
				_action = _Ct addAction [format["Слить топливо с %1",_typeVeh], SCRIPT_FILE(siphonFuel.sqf),[], 0, true, true, "", ""];
				r_player_actions set [count r_player_actions,_action];
			};
		};
	};
	
	if (r_action) then {
		r_action_targets = r_action_targets + [_Ct];
	};
};


if (_inVehicle) then {
	//Check if patients
	_crew = crew _vehicle;
	if (count _crew > 0) then {
		_unconscious_crew = [];
		{
			if (_x getVariable "NORRN_unconscious") then {
				_unconscious_crew = _unconscious_crew + [_x]
			};
		} count _crew;
		_patients = (count _unconscious_crew);
		if (_patients > 0) then {
			if (!r_action_unload) then {
				r_action_unload = true;
				_action = _vehicle addAction [format[localize "str_actions_medical_14",_vehType], "\z\addons\dayz_code\medical\load\unLoad_act.sqf",[player,_vehicle], 0, false, true];
				r_player_actions set [count r_player_actions,_action];
			};
		} else {
			if (r_action_unload) then {
				call fnc_usec_medic_removeActions;
				r_action_unload = false;
			};
		};
	};
	//hintSilent format["Crew: %1\nPatients: %2\nAction: %3",(count _crew),_patients,r_action_unload];
} else {
	if (r_action_unload) then {
		r_action_unload = false;
		call fnc_usec_medic_removeActions;
	};
};

//Remove Actions
if ((!_isClose || !_isAlive) && r_action) then {
	call fnc_usec_medic_removeActions;
	r_action = false;
};