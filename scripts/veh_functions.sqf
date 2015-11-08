/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

fnc_getNearestVehicle={
	PVT4(_unit,_filter,_range,_r);
	PARAMS3(_unit,_filter,_range);
	_r=ObjNull;{if((alive _x)&&(_unit!=_x))exitWith{_r=_x}}count nearestObjects [_unit,_filter,_range];
	_r
};

fnc_checkInTow={
	PVT3(_vehicle,_reason,_rc);
	PARAMS1(_vehicle);
	_rc=true;
	if(GetCanNotTow(_vehicle))then{_reason="%1 не может участвовать в буксировке.";_rc=false};
	if (locked _vehicle)then{_reason="Техника %1 закрыта, нельзя прицепить.";_rc=false};
	if(GetInTow(_vehicle))then{_reason="%1 уже буксируется другой техникой.";_rc=false};
	if(GetTow(_vehicle))then{_reason="%1 уже буксирует другую технику.";_rc=false};
	if(!_rc)then{cutText [format[_reason,[_vehicle]call object_getNameWithComment],"PLAIN DOWN"]};
	_rc
};

fnc_checkForTow={
	PVT3(_truck,_cargo,_rc);
	PARAMS2(_truck,_cargo);
	_rc=([_truck]call fnc_checkInTow)&&([_cargo]call fnc_checkInTow);
	if (_rc)then{
		if ((count (crew _cargo))!=0)then{
			cutText [format["Сцепка с %1 отменена, поскольку в технике люди.",[_cargo]call object_getNameWithComment],"PLAIN DOWN"];
			_rc=false;
		};
	};
	_rc
};

fnc_vehInTow={
	PARAMS2PVT(_truck,_cargo);
	SetInTow(_cargo,true);
	SetTow(_truck,true);
	SetVehInTow(_truck,_cargo);
	SetVehTow(_cargo,_truck);
	[_cargo] spawn{
		Sleep 2;
		{if (isPlayer _x)then{PVDZE_send=[_x,"EjectInTow",[THIS0]];publicVariableServer "PVDZE_send"}}count (crew THIS0);
	};
};

fnc_resetTow={
	PVT2(_vehicle,_car);
	PARAMS1(_vehicle);
	if(GetTow(_vehicle))exitWith{
		SetTow(_vehicle,false);
		_car=GetVehInTow(_vehicle);
		SetVehInTow(_vehicle,nil);
		if(!isNull _car)then{[_car]call fnc_resetTow};
	};
	if(GetInTow(_vehicle))then{
		detach _vehicle;
		SetInTow(_vehicle,false);
		_car=GetVehTow(_vehicle);
		SetVehTow(_vehicle,nil);
		if(!isNull _car)then{[_car]call fnc_resetTow};
	};
};

fnc_vehLockEffect = {
	PARAMS2PVT(_vehicle,_sound);
	player action ["lightOn", _vehicle];
	[objNull, _vehicle, rSAY, _sound, 7] call RE;
	sleep 0.5;
	player action ["lightOff", _vehicle];
};

vehicle_lockUnlock = {
	PARAMS2PVT(_vehicle,_state);
	PVDZE_veh_Lock = [_vehicle,_state];
	if (local _vehicle) then {
		PVDZE_veh_Lock spawn local_lockUnlock;
	} else {
		publicVariable "PVDZE_veh_Lock";
	};
};

vehicle_fired = {
	if (!isServer) then {
		PARAMS1PVT(_vehicle);
		if (_vehicle == (vehicle player))then{
			if (GETVAR(_vehicle,inSafeZone,false))then{
				deleteVehicle(NearestObject[_vehicle,THIS4]);
			};
		};
	};
};

vehicle_takeGift = {
	private ["_vehicle","_name","_key","_msg"];
	PARAMS2(_vehicle,_key);
	_name = getText(configFile >> "cfgVehicles" >> (typeOf _vehicle) >> "displayName");
	call {
		if (([player,_key] call BIS_fnc_invAdd))exitWith{_msg = "ключ добавлен на пояс";};
		
		(unitBackpack player) addWeaponCargoGlobal [_key, 1];
		if (_key in ((getWeaponCargo unitBackpack player) select 0))exitWith{_msg = "ключ добавлен в рюкзак";};
		
		VehicleUnlock(_vehicle);
		if (([_vehicle,_key] call BIS_fnc_invAdd))exitWith{_msg = format["ключ добавлен в '%1'",_name];};

		_msg = "нет места для ключа на поясе, в рюкзаке и в подарке\nТехника открыта, сделайте ключ в гараже до рестарта!";
	};
	cutText [format["Получен подарок '%1', %2!",_name,_msg], "PLAIN DOWN"];
};

fnc_GetOutToHalo={
	player setvelocity [0,64,0];
	if((_this select 0)>300)then{
		sleep 0.2;
		player spawn BIS_fnc_halo;
	}else{
		waituntil {(vehicle player) iskindof "ParachuteBase"};
		deletevehicle (vehicle player);
		player switchmove "HaloFreeFall_non";
		[objNull, player, rSwitchMove,"HaloFreeFall_non"] call RE;
		sleep 1;
		[player] spawn BIS_fnc_halo;
	};
};

vehicle_getIn = {
	PVT4(_vehicle,_position,_unit,_mission);
	PARAMS3(_vehicle,_position,_unit);

	_mission=(GETVAR(_vehicle,Mission,"0")=="1");

	if (isServer)then{
		if (!_mission)exitWith{[_vehicle,"all"] call server_updateObject};
	}else{
		if (_unit==player)then{
			if (GetInTow(_vehicle))then{
				[_vehicle] call fnc_vehInTowEject;
			}else{
				_vehicle setVariable["inSafeZone",([_vehicle] call fnc_inSafeZone),true];
			};
			if(GETVAR(_vehicle,taxi,false))exitWith{
				cutText [format["Добро пожаловать в такси GoldKey.\nСледующая остановка %1",_vehicle getVariable["TaxiNext",""]],"PLAIN DOWN"];
			};
			if (_mission)exitWith{cutText ["Внимание! Техника исчезнет после рестарта.","PLAIN DOWN"]};
			if(GetCharID(_vehicle)=="0")exitWith{cutText["Внимание! Не используйте эту технику для хранения лута.\n Открытая спавненная техника исчезает через 2 дня после спавна.","PLAIN DOWN"]};
		};
	};
};

vehicle_GetOut = {
	private ["_vehicle","_unit","_parachute","_pay","_msg","_rc","_alt"];
	_vehicle=THIS0;
	if(isServer)then{
		[_vehicle,"all"] call server_updateObject;
		if (GetTow(_vehicle))then{
			_vehicle = GetVehInTow(_vehicle);
			if (!isNull _vehicle)then{
				[_vehicle,"all"] call server_updateObject;
			};
		};
	}else{
		_unit=THIS2;
		if (_unit != player)exitWith{};
		_alt=([player] call FNC_getPos) select 2;
		if (_alt>100)then{
			[_alt] spawn fnc_GetOutToHalo;
		};
		_pay=GETVAR(_unit,taxicost,0);
		if(_pay>0)then{
			SETVARS(_unit,taxicost,0);
			_rc=[_unit,_pay,true] call fnc_Payment;
			_msg=[_rc] call fnc_PaymentResultToStr;
			systemChat format ["Оплата проезда. %1.",_msg];
		};
	};
};

vehicle_getKeyByCharID={
	PARAMS1PVT(_charID);
	if((_charID < 1)||(_charID > 12500))exitWith{"0"};
	if(_charID <= 2500)exitWith{format["ItemKeyGreen%1",_charID]};
	if(_charID <= 5000)exitWith{format["ItemKeyRed%1",_charID-2500]};
	if(_charID <= 7500)exitWith{format["ItemKeyBlue%1",_charID-5000]};
	if(_charID <= 10000)exitWith{format["ItemKeyYellow%1",_charID-7500]};
	format["ItemKeyBlack%1",_charID-10000]
};

if (!isServer) then {
	fnc_vehInTowEject = {
		player action ["eject", THIS0];
		cutText ["Нельзя находиться в буксируемой технике.", "PLAIN DOWN"];
	};
};

vehicle_isVehicle={
	PVT3(_vehicle,_addCtatic,_list);
	PARAMS2(_vehicle,_addCtatic);
	if (_addCtatic)then{_list=[VEHICLE_TYPE]}else{_list=[VEHICLE_MOVE_TYPE]};
	{_vehicle isKindOf _x} count _list > 0
};

vehicle_lostTimeFmt={
	PVT4(_cnt,_ust,_h,_m,_d);
	PARAMS2(_cnt,_ust);
	if(_ust)then{_cnt=_cnt+floor (serverTime/60)};
	_d=floor(_cnt/1440);_cnt=_cnt-_d*1440;
	_h=floor(_cnt/60);
	_m=_cnt-_h*60;
	if (_d==0)then{format["%1ч %2м",_h,_m]}else{format["%1д %2ч %3м",_d,_h,_m]}
};

ItemLoadingOffset=[
	["CinderWall_DZ",0.4,0.22,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.8],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.8],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["CinderWallHalf_DZ",0.4,0.2,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.8],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.8],-1.2,1.2],
		[["Kamaz"],[0,-0.95,-0.8],-0.8,0.8],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["CinderWallSmallDoorway_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["CinderWallDoorSmall_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["CinderWallDoorway_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["CinderWallDoor_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.95,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.95,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.95,-0.5],-1.2,1.2],
		[["UralCivil2"],[0,-1.95,-0.5],-1.2,1.2]
	]],
	["WoodSmallWallThird_DZ",0.28,0.15,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.65,-0.9],-1.2,1.2],
		[["KamazOpen"],[0,-0.65,-0.9],-1.2,1.2],
		[["Kamaz"],[0,-0.92,-0.86],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.68,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.68,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.68,-0.54],-1.2,1.2],
		[["UralCivil"],[0,-1.68,-0.54],-1,1],
		[["UralCivil2"],[0,-1.68,-0.54],-1.2,1.2],
		[["UralCivil_DZE"],[0,-1.68,-0.54],-1,1],
		[["Ural_INS"],[0,-1.68,-0.54],-1,1],
		[["Ural_UN_EP1"],[0,-1.68,-0.54],-1,1],
		[["Ural_CDF"],[0,-1.68,-0.54],-1,1],
		[["Ural_TK_CIV_EP1"],[0,-1.68,-0.54],-1,1],
		[["MTVR"],[0,-1.88,-0.45],-1.2,1.2],
		[["MTVR_DES_EP1"],[0,-1.88,-0.45],-1.2,1.2]
	]],
	["WoodSmallWall_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.55,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.55,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,-0.54],-1.2,1.2]
	]],
	["WoodLargeWall_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.68,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.68,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.71,-0.54],-1.2,1.2]
	]],
	["WoodSmallWallWin_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.55,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.55,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,-0.54],-1.2,1.2]
	]],
	["WoodLargeWallWin_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.68,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.68,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.71,-0.54],-1.2,1.2]
	]],
	["Land_DZE_LargeWoodDoor",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.68,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.68,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.71,-0.54],-1.2,1.2]
	]],
	["Land_DZE_WoodDoor",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.55,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.55,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,-0.54],-1.2,1.2]
	]],
	["WoodSmallWallDoor_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.55,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.55,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,-0.54],-1.2,1.2]
	]],
	["WoodLargeWallDoor_DZ",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.68,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.68,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.71,-0.54],-1.2,1.2]
	]],
	["Land_DZE_GarageWoodDoor",0.28,0.17,[[1,0,0],[0,0,1]],[
		[["KamazOpen_DZE"],[0,-0.68,-0.84],-1.2,1.2],
		[["KamazOpen"],[0,-0.68,-0.84],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.71,-0.54],-1.2,1.2],
		[["UralCivil2"],[0,-1.71,-0.54],-1.2,1.2]
	]],
	["WoodFloor_DZ",0.28,0.02,[[0,1,0],[1,0,0]],[
		[["KamazOpen_DZE"],[0,-0.52,1.55],-1.2,1.2],
		[["KamazOpen"],[0,-0.52,1.55],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.55,1.85],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.55,1.85],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.55,1.85],-1.2,1.2],
		[["UralCivil2"],[0,-1.55,1.85],-1.2,1.2]
	]],
	["WoodFloorHalf_DZ",0.28,0.02,[[0,1,0],[1,0,0]],[
		[["KamazOpen_DZE"],[0,-0.55,0.4],-1.2,1.2],
		[["KamazOpen"],[0,-0.55,0.4],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,0.7],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,0.7],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,0.7],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,0.7],-1.2,1.2]
	]],
	["WoodFloorQuarter_DZ",0.28,0.02,[[0,1,0],[1,0,0]],[
		[["KamazOpen_DZE"],[0,0.55,0.4],-1.2,1.2],
		[["KamazOpen"],[0,0.55,0.4],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.58,0.7],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.58,0.7],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.58,0.7],-1.2,1.2],
		[["UralCivil2"],[0,-1.58,0.7],-1.2,1.2]
	]],
	["MetalFloor_DZ",0.28,0.02,[[0,1,0],[1,0,0]],[
		[["KamazOpen_DZE"],[0,-0.85,1.8],-1.2,1.2],
		[["KamazOpen"],[0,-0.85,1.8],-1.2,1.2],
		[["UralCivil2_DZE"],[0,-1.88,0.7],-1.2,1.2],
		[["UralOpen_INS"],[0,-1.88,2.1],-1.2,1.2],
		[["UralOpen_CDF"],[0,-1.88,2.1],-1.2,1.2],
		[["UralCivil2"],[0,-1.88,2.1],-1.2,1.2]
	]],
	["SeaFox_EP1",4,2,[[0,0.98,0.17],[0,-0.17,0.98]],[
		[["KamazOpen_DZE"],[0,-0.5,3.3],-2.01,2.01],
		[["KamazOpen"],[0,-0.5,3.3],-2.01,2.01],
		[["UralCivil2_DZE"],[0,-0.5,3.85],-2.01,2.01],
		[["UralOpen_INS"],[0,-0.5,3.85],-2.01,2.01],
		[["UralOpen_CDF"],[0,-0.5,3.85],-2.01,2.01],
		[["UralCivil2"],[0,-0.5,3.85],-2.01,2.01]
	]],
	["SeaFox",4,2,[[0,0.98,0.17],[0,-0.17,0.98]],[
		[["KamazOpen_DZE"],[0,-0.5,3.3],-2.01,2.01],
		[["KamazOpen"],[0,-0.5,3.3],-2.01,2.01],
		[["UralCivil2_DZE"],[0,-0.5,3.85],-2.01,2.01],
		[["UralOpen_INS"],[0,-0.5,3.85],-2.01,2.01],
		[["UralOpen_CDF"],[0,-0.5,3.85],-2.01,2.01],
		[["UralCivil2"],[0,-0.5,3.85],-2.01,2.01]
	]]
];

vehicle_canLoadingItem={
	PVT2(_class,_rc);
	PARAMS1(_class);
	_rc=false;
	{if(SEL0(_x)==_class)exitWith{_rc=true}}count ItemLoadingOffset;
	_rc
};

vehicle_loadingToTrack={
	private ["_object","_class","_done","_truck","_item","_use","_w","_nameobj","_name","_pos","_v"];
	PARAMS1(_object);
	_class=typeOf _object;
	_done=false;
	_nameobj=[_object]call object_getNameWithComment;
	{if(SEL0(_x)==_class)exitWith{_item=_x;_done=true}}count ItemLoadingOffset;
	if(!_done)exitWith{cutText [format["%1 не поддерживает транспортировку",_nameobj],"PLAIN DOWN"];false};
	_truck=[_object,['Truck'],10]call fnc_getNearestVehicle;
	if(isNull _truck)exitWith{cutText ["Рядом нет грузовика","PLAIN DOWN"];false};
	_name=[_truck]call object_getNameWithComment;
	if(locked _truck)exitWith{cutText [format["%1 закрыт",_name],"PLAIN DOWN"];false};
	_done=false;
	{
		if(typeOf _truck in SEL0(_x))exitWith{
			_w=SEL1(_item);
			_use=0;
			{_use=_use+SEL1(_x)}forEach (_truck getVariable["Cargo",[]]);
			if((SEL3(_x)-SEL2(_x)-_use)>=_w)then{
				_pos=SEL1(_x);
				_v=SEL3(_item);
				[_truck,"loadtrack",[_object,_w,SEL2(_item),_pos,_v]]call fnc_serverUpdateObject;
				player playActionNow "PutDown";
				[player,30,true,(getPosATL player)] spawn player_alertZombies;
				cutText [format["%1 погружено в %2",_nameobj,_name],"PLAIN DOWN"];
				_done=true;
			}else{
				cutText [format["В %1 нет свободного места",_name],"PLAIN DOWN"];
			};
		};
	}count SEL4(_item);
	if(!_done)then{
		cutText [format["%1 не может перевозить %2",_name,_nameobj],"PLAIN DOWN"];
	};
	_done
};

vehicle_unloadCargo={
	private ["_truck","_class","_cargo","_name","_done","_obj"];
	PARAMS2(_truck,_class);
	_name=[_truck] call object_getNameWithComment;
	if!((typeOf _truck)in SeaFoxList)then{
		if(GETVAR(_truck,inSafeZone,false))exitWith{cutText ["Нельзя разгружаться в безопасной зоне","PLAIN DOWN"]};
		if!([_class,position _truck,true] call build_checkCanBuild)exitWith{};
	};
	[_truck,"unloadtrack",[_class,player]]call fnc_serverUpdateObject;
	player playActionNow "PutDown";
	[player,30,true,(getPosATL player)] spawn player_alertZombies;
	cutText [format["Начинается разрузка %1 с %2",_class,_name],"PLAIN DOWN"];
};

fnc_PushTurbo={
	private ["_veh","_type","_boost","_maxSpeed","_speed","_vel","_dir","_damage"];
	_veh=vehicle player;
	_speed=speed _veh;
	if(isEngineOn _veh&&((getPosATL _veh)select 2)<.1&&_speed>=40)then{
		_type=typeOf _veh;
		_maxSpeed=250;
		_boost=.3;
		switch(true)do{
			case(_type isKindOf "Tank"):{_maxSpeed=150;_boost=.07;};
			case(_type isKindOf "Wheeled_APC"):{_maxSpeed=150;_boost=.27;};
		};
		if(_speed>_maxSpeed)then{_boost=0;}; 
		_dir=direction _veh;
		_vel=velocity _veh;
		_veh setVelocity[
			(_vel select 0)+(sin _dir*_boost),
			(_vel select 1)+(cos _dir*_boost),
			(_vel select 2)-.1
		];
		if ((diag_tickTime-TurboTLastDamag)>10)then{
			//systemChat format ["Топливо: %1 Двигатель: %2",(fuel _veh)*100,([_veh,"HitEngine"] call object_getHit)*100];
			_veh setFuel ((fuel _veh)-0.0025);
			_damage=([_veh,"HitEngine"] call object_getHit)+0.0025;
			_veh setHit["motor",_damage];
			_veh setVariable["hit_motor",_damage,true];
			TurboTLastDamag=diag_tickTime;
			if(_damage>=0.75)then{
				cutText[format["Внимание! Повреждение двигателя: %1%2",round(_damage*100),"%"],"PLAIN DOWN"];
			};
		};
	};
};