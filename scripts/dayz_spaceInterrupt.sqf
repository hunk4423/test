/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_isDriver","_oUID","_target","_vehicle","_inVehicle","_dikCode","_handled","_primaryWeapon","_secondaryWeapon","_nearbyObjects","_shift","_ctrl","_alt","_dropPrimary","_dropSecondary","_iItem","_removed","_iPos","_radius","_item"];
_dikCode=THIS1;
_shift=THIS2;
_ctrl=THIS3;
_alt=THIS4;
_vehicle=vehicle player;
_inVehicle=_vehicle!=player;

_handled=false;
if(r_player_dead)exitWith{_handled=true;_handled};

if (_dikCode in[0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x58,0x57,0x44,0x43,0x42,0x41,0x40,0x3F,0x3E,0x3D,0x3C,0x3B])then{
	if (currAdminLevel>0 && (Group_control && !_shift))then{_handled=false}else{_handled=true};
};

if ((_dikCode == 0x3E || _dikCode == 0x0F || _dikCode == 0xD3)) then {
	if(diag_tickTime - dayz_lastCheckBit > 10) then {
		dayz_lastCheckBit = diag_tickTime;
		call dayz_forceSave;
	};
	call dayz_EjectPlayer;
};

if(_inVehicle)then{
	_isDriver=player==(driver _vehicle);
	//Турбина
	if(_dikCode==0x39)then{
		if((GETVAR(_vehicle,TurboInstalled,"0"))=="0")exitWith{systemChat "Турбина не установлена.";Turbo_on=false;};
		Turbo_on=!Turbo_on;
		if(Turbo_on)then{
			cutText["Турбина: ВКЛЮЧЕНА","PLAIN DOWN"];
		}else{
			cutText["Турбина: ВЫКЛЮЧЕНА","PLAIN DOWN"];
		};
	};
	if(Turbo_on&&_isDriver&&(((_dikCode in actionKeys "carForward")&&_shift)||_dikCode==0x12))then{
		if((GETVAR(_vehicle,TurboInstalled,"0"))=="1")then{
			call fnc_PushTurbo;
		}else{
			Turbo_on=false;
		};
	};
	
	//Пониженная передача
	if(CHECHKEY(_dikCode,CarSlowForward))then{
		if(_isDriver&&(_vehicle isKindOf "Tank")&&!(typeOf _vehicle in M113List))then{
			[objNull, _vehicle, rSAY, "LowGear", 20] call RE;
			if((speed _vehicle)>60)exitwith{cutText["Скорость слишком высока.","PLAIN DOWN"];};
			if(RIPLOWGEARON)then{				
				cutText["Пониженная передача: ВЫКЛЮЧЕНА","PLAIN DOWN"];
				RIPLOWGEARON=false;
			}else{
				cutText["Пониженная передача: ВКЛЮЧЕНА","PLAIN DOWN"];
				[] spawn LowGearOn;
			};
		};
	};
};

//thx CCG
if(_dikCode == 0x57)then{
	CCGEARPLUGS=!CCGEARPLUGS;
	if(CCGEARPLUGS)then{
		1 fadeSound 0.4;
	}else{
		1 fadeSound 1;
	};
};

//Управление группой ботов
if(currAdminLevel>0)then{
	if(_dikCode == 0x4C)then{
		Group_control = !Group_control;
		if(Group_control)then{systemChat "Управление группой включено."}else{systemChat "Управление группой выключено."};
	};
};

//Открыть гараж
if (_dikCode == 0x15) then {
	if("ItemRadio" in (items player))then{
		if(isNull (findDisplay 2800))then{
			[player,'store'] spawn fnc_GarageOpenNearest;
		}else{
			(findDisplay 2800) closeDisplay 1;
		};
	}else{
		cutText["Для дистанционного открытия гаража, нужна рация.", "PLAIN DOWN"];
	};
};

//debug
if (_dikCode == 0xCF) then {
	hintSilent '';
	EXECVM_SCRIPT(custom_monitor.sqf);
};

//правила
if (_dikCode == 0x41 && !Group_control) then {
	(findDisplay 106) closeDisplay 1;
	EXECVM_SCRIPT(template\rules.sqf);
};

//отдых
if(_dikCode in actionKeys "SitDown")then{
	EXECVM_SCRIPT(get_rest.sqf);
};

//Фикс дюпа через esc
if (_dikCode == 0x01)then{
	if (BuildMode)exitWith{BuildMode=false;_handled=true};
	EXECVM_SCRIPT(esc.sqf);
	DZE_cancelBuilding = true;
	call dayz_EjectPlayer;
	OpenGear = nil;
};

//Фикс воровства с закрытых тачек
if((_dikCode in actionKeys "Gear")&&!_inVehicle)then{
	if (isNil "OpenGear") then {
		(findDisplay 106) closeDisplay 1;
		_ct=cursorTarget;
		if (!(_ct isKindOf "Man") and (player distance _ct <= 7) and ((typeOf _ct in GearStorags) or (_ct isKindOf "AllVehicles"))) then {
			player action ["gear", _ct];
			} else {
			createGearDialog [player, "RscDisplayGear"];
		};
		OpenGear = true;
	} else {
		(findDisplay 106) closeDisplay 1;
		OpenGear = nil;
	};
	_handled = true;
};

//Открыть сумку на H
if (_dikCode == 0x23) then {
	if (isNil "OpenGear") then {
		(findDisplay 106) closeDisplay 1;
		player action ["gear", unitBackpack player];
		OpenGear = true;
		} else {
		(findDisplay 106) closeDisplay 1;
		OpenGear = nil;
	};
	_handled = true;
};


// Стройка
// helperDetach true - объект привязан к стройке (не к игроку), можно крутить/наклонять/поднимать
// BuildMode true - идет строительство
if (BuildMode && !_shift)then{
	//numpad 5(76),F key
	if ((_dikCode==0x21||CHECHKEY(_dikCode,User19)) && (!_alt && !_ctrl))then{
		DZE_F=true;
		_handled=true;
	};
	//numpad 3,pgdn 0xD1(209)
	if (_dikCode==209||CHECHKEY(_dikCode,User16))then{
		_handled=true;
		if (_alt&&_ctrl)exitWith{DZE_DN=-0.005};
		if (_alt && !_ctrl)exitWith{DZE_DN=-1;};
		if (!_alt && _ctrl)exitWith{DZE_DN=-0.01;};
		DZE_DN=-0.1;
	};
	// numpad 1(79) Q 0x10(16)
	if ((_dikCode==0x10||CHECHKEY(_dikCode,User18))&&(!_alt && !_ctrl))then{
		_handled=true;
		DZE_RL=true;
	};
	// space 0x39(57)
	if (_dikCode==0x39 && (!_alt && !_ctrl)) then {_handled=true;DZE_SET=true;};
	// numpad 7(71), E 0x12
	if ((_dikCode==0x12||CHECHKEY(_dikCode,User17))&&(!_alt && !_ctrl))then{
		_handled=true;
		DZE_RR=true;
	};
	// numpad 9(73), pgup 0xC9
	if (_dikCode==0xC9 || CHECHKEY(_dikCode,User15))then{
		_handled=true;
		if (_alt&&_ctrl)exitWith{DZE_UP=0.005};
		if (!_alt && _ctrl)exitWith{DZE_UP=0.01;};
		if (_alt && !_ctrl)exitWith{DZE_UP=1;};
		DZE_UP=0.1;
	};
	//numpad 2(80),j(36)
	if (CHECHKEY(_dikCode,User8))then{
		_handled = true;
		if(_alt&&_ctrl)exitWith{DZE_Back=-0.005};
		if(_alt)exitWith{DZE_Back=-1;};
		if(_ctrl)exitWith{DZE_Back=-0.01;};
		DZE_Back=-0.1;
	};
	//numpad 4(75)
	if (CHECHKEY(_dikCode,User9))exitWith{
		_handled = true;
		if(_alt && _ctrl)exitWith{DZE_Left=-0.005};
		if(_alt)exitWith{DZE_Left=-1;};
		if(_ctrl)exitWith{DZE_Left=-0.01;};
		DZE_Left=-0.1;
	};
	//numpad 6(77)
	if (CHECHKEY(_dikCode,User10)) then {
		_handled = true;
		if(_alt && _ctrl)exitWith{DZE_Right=0.005};
		if(_alt)exitWith{DZE_Right=1;};
		if(_ctrl)exitWith{DZE_Right=0.01;};
		DZE_Right=0.1;
	};
	//numpad 8(72)
	if (CHECHKEY(_dikCode,User7)) then {
		_handled = true;
		if(_alt && _ctrl)exitWith{DZE_Forward=0.005};
		if(_alt)exitWith{DZE_Forward=1;};
		if(_ctrl)exitWith{DZE_Forward=0.01;};
		DZE_Forward=0.1;
	};
};
if (_handled)exitWith{_handled};
/*
//Перелом ноги
if((r_fracture_legs||r_fracture_arms)&&(NotInVeh(player)))then{
	if(SplintWound_Fall>time)exitWith{};	
	SplintWound_pos2=position player;
	SplintWound_time2=time;
	_time=SplintWound_time2-SplintWound_time1;
	if(_time==0)exitWith{};
	_speed=(SplintWound_pos1 distance SplintWound_pos2)/_time;
	SplintWound_pos1=position player;
	SplintWound_time1=SplintWound_time2;

	if(_speed>=2.1)then{
		switch(GETVAR(player,SplintWound,0))do{
			case 0: {cutText["Черт, нога сломана! Срочно нужен морфий и шина из дров и бинта!","PLAIN DOWN"];};			
			case 1: {cutText["Черт, не могу бежать! Нога же сломана, нужна шина из дров и бинта!","PLAIN DOWN"];};				
			case 2: {cutText["Как больно бегать! Шину наложил, но морфий не вколол!","PLAIN DOWN"];};
		};
		r_player_blood=r_player_blood-floor((random 500)+200);
		player setVariable['USEC_BloodQty',r_player_blood,true];
		[player,15,true,(getPosATL player)] spawn player_alertZombies;
		player playMove "AmovPpneMstpSrasWrflDnon";
		SplintWound_Fall=time+3;
		if!(r_player_inpain)then{
			player setVariable ["USEC_inPain",true,true];
			r_player_inpain=true;
		};
	};
};
*/
if (CHECHKEY(_dikCode,MoveForward)) exitWith {r_interrupt = true;};
if (CHECHKEY(_dikCode,MoveLeft)) exitWith {r_interrupt = true;};
if (CHECHKEY(_dikCode,MoveRight)) exitWith {r_interrupt = true;};
if (CHECHKEY(_dikCode,MoveBack)) exitWith {r_interrupt = true;};
if (_dikCode==0x2F) exitWith {r_interrupt = true;};


//Prevent exploit of drag body
if (CHECHKEY(_dikCode,Prone) && r_drag_sqf) exitWith { force_dropBody = true; };
if (CHECHKEY(_dikCode,Crouch) && r_drag_sqf) exitWith { force_dropBody = true; };

//diag_log format["Keypress: %1", _this];
if (CHECHKEY(_dikCode,Gear) && _inVehicle && !_shift && !_ctrl && !_alt && !dialog) then {
	createGearDialog [player, "RscDisplayGear"];
	_handled = true;
};

/*
if (CHECHKEY(_dikCode,GetOver)) then {
	
	if (player isKindOf  "PZombie_VB") then {
		_handled = true;
		DZE_PZATTACK = true;
	} else {
		_nearbyObjects = nearestObjects[getPosATL player, dayz_disallowedVault, 8];
		if (count _nearbyObjects > 0) then {
			if((diag_tickTime - dayz_lastCheckBit > 4)) then {
				[objNull, player, rSwitchMove,"GetOver"] call RE;
				player playActionNow "GetOver";
				dayz_lastCheckBit = diag_tickTime;
			} else {
				_handled = true;
			};
		};
	};
};
*/
//if (_dikCode == 57) then {_handled = true}; // space
//if (_dikCode in actionKeys 'MoveForward' || _dikCode in actionKeys 'MoveBack') then {r_interrupt = true};
if (_dikCode == 210) then {
	execvm "\z\addons\dayz_code\actions\playerstats.sqf";
};

if (CHECHKEY(_dikCode,ForceCommandingMode)) then {_handled = true};
if (CHECHKEY(_dikCode,PushToTalk) && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	//[player,300,true,(getPosATL player)] spawn player_alertZombies;
};
if (CHECHKEY(_dikCode,VoiceOverNet) && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	//[player,50,true,(getPosATL player)] spawn player_alertZombies;
};
if (CHECHKEY(_dikCode,PushToTalkDirect) && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	//[player,15,false,(getPosATL player)] spawn player_alertZombies;
};
if (CHECHKEY(_dikCode,Chat) && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	//[player,15,false,(getPosATL player)] spawn player_alertZombies;
};
if (CHECHKEY(_dikCode,User20) && (diag_tickTime - dayz_lastCheckBit > 5)) then {
	dayz_lastCheckBit = diag_tickTime;
	execvm "\z\addons\dayz_code\actions\playerstats.sqf";
};
if (_dikCode == 0xB8) then {
	if (dialog) then {closeDialog 0;groupManagementActive = false;} else {[] EXECVM_SCRIPT(loadGroupManagement.sqf);};
};
if (_dikCode == 0x9D) then {
	if (tagname)then{tagname=false;}else{tagname=true;};
};



_handled
