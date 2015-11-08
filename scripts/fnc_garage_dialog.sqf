/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

fnc_GarageResultWait={
	PVT2(_timeout,_rc);
	PVDZE_GarageResult=nil;PVDZE_Garage=THIS0;publicVariableServer "PVDZE_Garage";
	_timeout=time+THIS1;GarageLastError="";_rc=true;
	while{isNil "PVDZE_GarageResult"}do{sleep 0.1;if(time>_timeout)exitWith{GarageLastError="Таймаут";_rc=false}};
	_rc
};

fnc_GarageGetList={
	private ["_vehicles","_msg","_garage"];
	_garage=THIS0;
	if ([[[_garage,player],"query"],15] call fnc_GarageResultWait)then{_vehicles=PVDZE_GarageResult}else{_vehicles=[]};
	if (typeName _vehicles != "ARRAY")exitWith{
		GarageLastError="Неверный результат. Обновите список.";
		diag_log(format["DEBUG: GarageResult is %1, должно ARRAY", typeName _vehicles]);
		_vehicles=[];
	};
	{
		_x set [CNT(_x),getText (configFile >> 'CfgVehicles' >> SEL1(_x) >> 'picture')];
/*TODO:		if (GETVAR(_garage,penalty,false))then{
			_x set [CNT(_x),
		};*/
	}forEach _vehicles;
	PVDZE_GarageResult=nil;
	_vehicles
};

fnc_GarageGetUsers={
	PVT4(_vehicles,_users,_UID,_name);
	PARAMS1(_vehicles);
	_users=[["0","Все"],[getPlayerUID player,dayz_playerName]];
	{
		_UID = SEL2(_x);
		_name = SEL3(_x);
		if (({SEL0(_x)==_UID}count _users)==0)then{_users set [count _users, [_UID,_name]]};
	} count _vehicles;
	_users
};

fnc_GarageGetStoreList={
	private ["_obj","_objects","_type","_result","_ownerUID","_my","_other"];
	PARAMS1(_obj);
	GarageLastError="";
	_result=[];
	if!(isNull selectedGarage)then{
		if(GETVAR(selectedGarage,penalty,false))exitWith{};
		if (GETVAR(selectedGarage,parking,false))then{_my=true}else{_my=[dayz_playerUID,GARAGE_SELF_ACCESS,selectedGarage]call fnc_checkObjectsAccess};
		_other=[dayz_playerUID,GARAGE_OTHER_ACCESS,selectedGarage] call fnc_checkObjectsAccess;
		if!(_my||_other)exitWith{};
		_objects=_obj nearEntities [[VEHICLE_MOVE_TYPE],GARAGE_ZONE];
		{
			_type=typeOf _x;
			_ownerUID=GetOwnerUID(_x);
			if (_ownerUID!="0" && GetCharID(_x)!="0")then{
				if (((_ownerUID==dayz_playerUID)&&_my)||((_ownerUID!=dayz_playerUID)&&_other))then{
					_result set[CNT(_result),[GetObjID(_x),_type,_ownerUID,GetOwnerName(_x),1,fuel _x,damage _x,GetComment(_x),GetLostTime(_x),getText (configFile >> "CfgVehicles" >> _type >> "picture"),_x]];
				}
			}
		}forEach _objects;
	};
	_result
};

fnc_getNearestPads={
	PVT6(_object,_range,_type,_arr,_result,_tmp);
	PARAMS3(_object,_range,_type);
	switch (_type)do{
		case "air": {_arr=[GARAGE_AIR_SPAWN]};
		case "land": {_arr=[GARAGE_LAND_SPAWN]};
		default {_arr=[GARAGE_PADS]};
	};
	_tmp=nearestObjects [player,_arr,_range*2];
	_arr=nearestObjects [_object,_arr,_range];
	_result=[];
	{if((_x in _arr)&&(GetOwnerUID(_x)!="0"))then{_result set[CNT(_result),_x]}}count _tmp;
	_result
};

fnc_getNearestPad={
	PVT5(_object,_range,_type,_result,_pads);
	PARAMS3(_object,_range,_type);
	_pads=[_object,_range,_type] call fnc_getNearestPads;
	if (CNT(_pads)>0)then{_result=SEL0(_pads)}else{_result=ObjNull};
	_result
};

fnc_GarageAction={
	PARAMS2PVT(_garage,_action);
	switch (_action)do{
	case "store": {_this call garage_dialog};
	case "list": {_this call garage_dialog};
	case "pad": {_this call garage_padSetup};
	case "editpad": {_this call garage_padSetup};
	case "movepad": {_this call garage_padSetup};
	case "show": {call garage_padSetup};
	case "deletepad": {_this call garage_padSetup};
	case "access": {[_garage] call garage_management};
	};
};

fnc_GarageOpenNearest={
	PVT3(_unit,_action,_garage);
	PARAMS2(_unit,_action);
	_garage=ObjNull;
	{if (GetOwnerUID(_x)!="0")exitWith{_garage=_x}}count nearestObjects [_unit,DZE_Garage,GARAGE_ZONE];
	if !(isNull _garage)then{
		[_garage,_action] call fnc_GarageAction;
	}else{
		if (curradminlevel>0)then{[ObjNull,"list"] call fnc_GarageAction};
	};
};

fnc_GarageFindRecord={
	PVT2(_id,_result);
	PARAMS1(_id);
	GarageLastError="";_result=[];
	if (_id>=0)then{
		_id=lbData[2807,_id];
		{if (SEL0(_x)==_id)exitWith{_result=_x}}forEach garageVehicles;
		if (CNT(_result)==0)then{GarageLastError="Транспорт не найден."};
	}else{GarageLastError="Транспорт не выбран."};
	_result
};

fnc_GarageSetStatus={
	PARAMS1PVT(_msg);
	disableSerialization;
	_mng=uiNamespace getVariable "GarageDialog";
	if (isNull _mng)exitWith{systemchat _msg};
	(_mng displayCtrl 2812) ctrlSetText _msg;
};

fnc_GarageBreakAction={
	PVT2(_msg,_upd);PARAMS1(_msg);
	DZE_ActionInProgress=false;_this call fnc_GarageSetStatus;
	if(CNT(_this)>1)then{_upd=THIS1}else{_upd=true};if(_upd)then{call onGarageUpdate};
};

fnc_GarageRestoreVeh={
	PVT3(_garage,_objectID,_result);
	PARAMS2(_garage,_objectID);
	GarageLastError="";
	if (typeName _garage == "OBJECT")then{_garage=GetObjID(_garage)};
	if([[[_garage,_objectID,player],"restore"],15] call fnc_GarageResultWait)then{_result=PVDZE_GarageResult}else{_result="TIMEOUT"};
	_result
};

onGarageVehiclesLoad={
	uiNamespace setVariable ['GarageDialog',_this select 0];
	uiNamespace setVariable ['GarageMonitor',custom_monitor];
	if (custom_monitor)then{custom_monitor=false};
};

onGarageVehiclesUnLoad={
	PVT(_val);
	uiNamespace setVariable ['GarageDialog',ObjNull];
	//garageUsers=nil;garageVehicles=nil;selectedGarage=nil;
	_val=uiNamespace getVariable "GarageMonitor";
	if (_val)then{hintSilent '';EXECVM_SCRIPT(custom_monitor.sqf)};
};

onGarageDlgEnableBtn={
	PARAMS1PVT(_state);
	{ctrlEnable[_x,_state]}forEach [2804,2805,2809,2813,2814,2815,2816];
};

onGarageUserClick={
	private ["_id","_userUID","_vehctrl","_mng","_all","_msg","_name","_index","_img"];
	PARAMS1(_id);
	disableSerialization;
	_mng=uiNamespace getVariable "GarageDialog";
	if (isNull _mng)exitWith{};
	_vehctrl = (_mng displayCtrl 2807);
	lbClear _vehctrl;
	if (_id<0)exitWith{};
	_userUID = SEL0(SEL(garageUsers,_id));
	if(garageDialogModeGet)then{_img=1}else{_img=2};
	_all=(_userUID=="0");
	{
		if (_all || (_userUID==SEL2(_x)))then{
			_name=[getText(configFile >> "CfgVehicles" >> (_x select 1) >> "displayName"),SEL7(_x),false]call fnc_MakeNameWithComment;
			if (_all)then{_name=format["%1: %2",SEL3(_x),_name]};
			if (SEL6(_x)==1)then{_name=_name+" [Уничтожено]"};
			_index=_vehctrl lbAdd _name;
			_vehctrl lbSetPicture [_index,(_x select ((count _x)-_img))];
			_vehctrl lbSetData [_index,SEL0(_x)];
		};
	} count garageVehicles;
	if ((lbSize _vehctrl)>0)then{_vehctrl lbSetCurSel 0};
};

onGarageVehicleClick = {
	private ["_id","_msg","_data","_mng","_life","_lifet","_ctrl","_r","_h"];
	PARAMS1(_id);
	disableSerialization;
	_mng = uiNamespace getVariable "GarageDialog";
	if (isNull _mng)exitWith{};
	_r=false;_lifet="";
	_data=[_id] call fnc_GarageFindRecord;
	if (CNT(_data)>0)then{
		if (garageDialogModeGet)then{
			_life=SEL4(_data)-1;_lifet=str(_life);
			if (_life==0)then{_life="Нет"};
			timeInGarage=SEL8(_data);
			_msg=format["ID: %1<br/>Класс: %2<br/>Владелец: %3<br/>Восстановлений: %4<br/>Простой: %5",SEL0(_data),SEL1(_data),SEL3(_data),_life,[timeInGarage,false] call vehicle_lostTimeFmt];
			if (GETVAR(selectedGarage,penalty,false)) then {
				_msg=_msg+format[" (штраф %1)",[timeInGarage]call fnc_GaragePenaltyCost];
			};
			_r=(SEL6(_data)==1);
		}else{_msg=SEL(_data,10) call vehicle_info};
	}else{_msg=GarageLastError};
	(_mng displayCtrl 2850) ctrlSetText _lifet;
	(_mng displayCtrl 2814) ctrlEnable _r;
	(_mng displayCtrl 2808) ctrlSetStructuredText parseText _msg;
	call onGarageUpdate2;
};

onManagerClick={
	[selectedGarage] spawn garage_management;
	(findDisplay IDD_GARAGE_LIST) closeDisplay 0;
};

onVehRestore={
	PVT5(_id,_data,_rc,_msg,_mng);
	PARAMS1(_id);
	disableSerialization;
	_mng = uiNamespace getVariable "GarageDialog";
	if (isNull _mng)exitWith{};
	_data=[_id] call fnc_GarageFindRecord;
	if (CNT(_data)>0)then{
		if (SEL6(_data)<1)exitWith{_msg="Транспорт не уничтожен."};
		[false] call onGarageDlgEnableBtn;
		["Идет восстановление, ожидайте..."]call fnc_GarageSetStatus;
		_rc=[selectedGarage,SEL0(_data)] call fnc_GarageRestoreVeh;
		call {
			if (_rc=="PASS")exitWith{_msg="Транспорт восстановлен."};
			if (_rc=="TIMEOUT")exitWith{_msg="Таймаут запроса восстановления."};
			_msg="Ошибка восстановления.";
		};
		call onGarageUpdate;
	}else{_msg=GarageLastError};
	[_msg]call fnc_GarageSetStatus
};

OnGarageGetClick={
	PVT6(_id,_withkey,_data,_cost,_done,_rc);
	PARAMS2(_id,_withkey);
	if (_id<0)exitWith{["Транспорт не выбран."]call fnc_GarageSetStatus};
	_data=[_id]call fnc_GarageFindRecord;
	if(CNT(_data)==0)exitWith{[GarageLastError]call fnc_GarageSetStatus};
	if ([SEL1(_data),false] call vehicle_isVehicle)then{
		if (garageDialogModeGet)then{[_data,_withkey] spawn player_getVehicle}else{[SEL(_data,10),_withkey] spawn player_storeVehicle}
	};
};

GarageModeGetText=[[2804,"Забрать транспорт"],[2805,"Забрать транспорт"],[2815,"В режим 'Поставить'"],[2817,"Транспорт в гараже"],[2818,"Забрать без ключа"],[2819,"Поместить ключ на пояс"]];
GarageModeSetText=[[2804,"Поставить транспорт"],[2805,"Поставить транспорт"],[2815,"В режим 'Забрать'"],[2817,"Транспорт рядом"],[2818,"Оставить ключ на поясе"],[2819,"Забрать ключ с пояса"]];

OnGarageModeChange={
	PVT2(_mng,_l);
	disableSerialization;
	_mng=uiNamespace getVariable "GarageDialog";
	if (garageDialogModeGet)then{_l=GarageModeGetText}else{_l=GarageModeSetText};
	{(_mng displayCtrl SEL0(_x)) ctrlSetText SEL1(_x)}forEach _l;
	call onGarageUpdate;
};

onPadmenuClick={closeDialog 0;[selectedGarage,"pad"] spawn garage_padSetup};

onGarageGotoVehicle={
	PVT(_pos);
	if(garageDialogModeGet)exitWith{};
	PARAMS1(_id);
	if (_id<0)exitWith{["Транспорт не выбран."]call fnc_GarageSetStatus};
	_data=[_id] call fnc_GarageFindRecord;
	if(CNT(_data)==0)exitWith{[GarageLastError]call fnc_GarageSetStatus};
	_pos=[SEL(_data,10)]call FNC_GetPos;
	_pos set[1,SEL1(_pos)+3];
	player setPosATL _pos;
};

onGarageSetVehicle={};

onGarageUpdate2={{ctrlShow[_x,false]}forEach[2840,2841,2842,2843,2844,2850,2851,2852,2853,2854,2855,2856,2857]};

onGarageUpdate={
	PVT4(_msg,_mng,_state,_done);
	disableSerialization;
	_mng = uiNamespace getVariable "GarageDialog";
	if (isNull _mng)exitWith{};
	if (isNull selectedGarage && curradminlevel==0)exitWith{
		cutText ["Нет выбранного гаража!","PLAIN DOWN"];
		_mng closeDisplay 1;
	};
	if(curradminlevel==0)then{
		if (GETVAR(selectedGarage,parking,false)||GETVAR(selectedGarage,penalty,false))then{
			_done=true;
		}else{
			_done=[dayz_playerUID,[GARAGE_SELF_ACCESS,GARAGE_OTHER_ACCESS],selectedGarage] call fnc_checkObjectsAccess;
		};
	}else{
		_done=true;
	};
	if(!_done)exitWith{
		cutText ["Вы не имеете прав для доступа в этот гараж!","PLAIN DOWN"];
		_mng closeDisplay 1;
	};
	ctrlShow[2810,true];ctrlShow[2811,true];
	_msg=ctrlText 2812;
	[false] call onGarageDlgEnableBtn;
	lbClear (_mng displayCtrl 2806);
	lbClear (_mng displayCtrl 2807);
	if (garageDialogModeGet)then{
		garageVehicles=[selectedGarage] call fnc_GarageGetList;
	}else{
		if (isNull selectedGarage)then{
			garageVehicles=[player] call fnc_GarageGetStoreList;
		}else{
			garageVehicles=[selectedGarage] call fnc_GarageGetStoreList;
		};
	};
	garageUsers=[garageVehicles] call fnc_GarageGetUsers;
	ctrlShow[2810,false];ctrlShow[2811,false];
	[2806,garageUsers] call fnc_updatePlayersList;
	(_mng displayCtrl 2806) lbSetCurSel 0;
	[lbCurSel 2807] call onGarageVehicleClick;
	//(_mng displayCtrl 2807) lbSetCurSel (lbCurSel 2807);
	(_mng displayCtrl 2809) ctrlEnable ([dayz_playerUID,GARAGE_PLAYER_ACCESS,selectedGarage] call fnc_checkObjectsAccess);
	ctrlSetText[2812,_msg];
	call onGarageUpdate2;
	[true] call onGarageDlgEnableBtn;
	_state=!(isNull selectedGarage);
	{ctrlEnable[_x,_state]}forEach [2804,2805,2809,2814,2815,2816];
};
