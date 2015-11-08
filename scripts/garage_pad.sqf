/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT(_action);
PARAMS2(selectedGarage,_action);

if !([dayz_playerUID,GARAGE_FULL_ACCESS,selectedGarage] call fnc_checkObjectsAccess)exitWith{
	cutText ["Вы должны иметь полные права для управления этой площадкой!","PLAIN DOWN"]
};

disableSerialization;
padAction="";
selectedPad=nil;
padMarker=ObjNull;

PadItems=[
["Самолеты",PAD_PLANE,"самолетов"],
["Вертолеты",PAD_HELI,"вертолетов"],
["Лодки",PAD_SHIP,"лодок и кораблей"],
["Бронетехника гусеничная",PAD_TANK,"гусенечной бронетехники"],
["Бронетехника колесная",PAD_APC,"колесной бронетехники"],
["Грузовики",PAD_TRUCK,"грузовиков"],
["Мотоциклы",PAD_MOTO,"мотоциклов"],
["Остальные",PAD_OTHER,"легковых (гражданские, внедорожники)"]
];

PadLevel=["Площадка","Нижний","Верхний","Земля"];

onGaragePadUnLoad={
	uiNamespace setVariable ["GaragePad",ObjNull];
	selectedPad=nil;
	if !(isNull padMarker)then{
		deleteVehicle padMarker;
		padMarker=ObjNull;
	};
};

OnPadUpdateBtn={
	PVT6(_msg,_id,_mng,_ctrl,_mode,_item);
	_id=2902;
	_mng = uiNamespace getVariable "GaragePad";
	_mode=GETVAR(selectedPad,SpawnMode,DZE_GaragePadMode);
	{
		_item=[_mode,SEL1(_x)] call fnc_GaragePadModeGetItemByName;
		_ctrl=_mng displayCtrl (_id+20);
		if (CNT(_item)==0)then{
			_ctrl ctrlEnable false;
			_ctrl ctrlSetText SEL0(PadLevel);
			_msg="Выкл"
		}else{
			_ctrl ctrlEnable true;
			_ctrl ctrlSetText SEL(PadLevel,SEL1(_item));
			_msg="Вкл"
		};
		_ctrl=_mng displayCtrl _id;
		_ctrl ctrlSetText format["%1:%2",SEL0(_x),_msg];
		_id=_id+1;
	}forEach PadItems;
};

OnPadChange={
	private ["_access","_state","_msg","_mode","_new","_item","_key","_p"];
	_access=SEL(PadItems,THIS0);
	_key=THIS1;
	if (_key==0)then{
		_access set[4,0];
		if (SEL3(_access))then{_access set[3,false];_msg="Выключен"}else{_access set[3,true];_msg="Включен"};
	}else{
		_p=SEL4(_access);
		_p=_p+1;
		if (_p>=CNT(PadLevel))then{_p=0};
		_access set [4,_p];
	};
	_new=[];
	{
		if(SEL3(_x))then{_new set[CNT(_new),[SEL1(_x),SEL4(_x)]]};
	}forEach PadItems;
	SETVARS(selectedPad,SpawnMode,_new);
	PVDZE_veh_Update=[selectedPad,"friends"];
	publicVariableServer "PVDZE_veh_Update";
	if(_key==0)then{ctrlSetText[2901,format["Режим %1 - %2.",SEL2(_access),_msg]]};
	call OnPadUpdateBtn;
};

_createPadMenu={
	pad_menu =
	[
		["",false],
		["Настроить площадку",[2],"",-5,[["expression","padAction='edit';"]],"1","1"],
		["Переместить площадку",[3],"",-5,[["expression","padAction='move';"]],"1","1"],
		["Отобразить площадки Вкл/Выкл",[4],"",-5,[["expression","padAction='show';"]],"1","1"],
		["Удалить площадку",[5],"",-5,[["expression","padAction='delete';"]],"1","1"],
		["",[-1],"",-5,[["expression",""]],"1","0"],
		["Выход",[6],"",-5,[["expression","padAction='exit'"]],"1","1"]
	];
	showCommandingMenu "#USER:pad_menu";
};

_check_range={
	((selectedGarage distance THIS0)<=THIS1)
};

_edit_pad={
	private ["_mode","_item","_pos"];
	padAction="";
	selectedPad=[player,15,"all"] call fnc_getNearestPad;
	if (isNull selectedPad)exitWith{cutText ["В 15 метрах от вас не найдено площадок!","PLAIN DOWN"]};
	if ((selectedGarage distance selectedPad)>GARAGE_ZONE)exitWith{cutText ["Площадка слишком далеко от гаража!","PLAIN DOWN"]};
	createDialog "GaragePad";
	waitUntil {!isNull (findDisplay IDD_GARAGE_PAD)};
	_pos=getPosATL selectedPad;
	padMarker=createVehicle ["Sign_arrow_down_large_EP1",_pos,[],0,"CAN_COLLIDE"];
	padMarker setPos _pos;
	_mode=GETVAR(selectedPad,SpawnMode,DZE_GaragePadMode);
	{
		_item=[_mode,SEL1(_x)] call fnc_GaragePadModeGetItemByName;
		if(CNT(_item)>0)then{_x set[3,true];_x set[4,SEL1(_item)]}else{_x set[3,false];_x set[4,0]};
	}forEach PadItems;
	
	call OnPadUpdateBtn;
};

_delete_pad={
	PVT2(_pad,_object);
	padAction="";
	_pad=[player,10,"all"] call fnc_getNearestPad;
	if (isNull _pad)exitWith{cutText ["В 10 метрах от вас не найдено площадок!","PLAIN DOWN"]};
	if ((selectedGarage distance _pad)>100)exitWith{cutText ["Площадка слишком далеко от гаража!","PLAIN DOWN"]};
	_object=createVehicle ["Sign_arrow_down_large_EP1",getPosATL _pad,[],0,"CAN_COLLIDE"];
	[0,0,0,_pad] call COMPILE_SCRIPT_FILE(remove.sqf);
	deleteVehicle _object;
};

_move_pad = {
	PVT2(_pad,_object);
	padAction="";
	_pad=[player,10,"all"] call fnc_getNearestPad;
	if (isNull _pad)exitWith{cutText ["В 10 метрах от вас не найдено площадок!","PLAIN DOWN"]};
	[_pad,[],"move"] call player_build;
};

_show_pad={
	PVT3(_pos,_obj,_step);
	padAction="";
	if(!isNil "PAD_Marks")then{
		{deleteVehicle _x;}count PAD_Marks;PAD_Marks=nil;
		systemChat "Отображение площадок - Выключено";
	}else{
		systemChat "Отображение площадок - Включено";
		PAD_Marks=[];
		{
			_pos=getPosATL _x;
			_step=3;
			_obj="Sign_arrow_down_large_EP1" createVehicleLocal _pos;
			_obj setPosATL _pos;
			_obj setDir (getDir _x);
			
			_showDir="Sign_arrow_down_large_EP1" createVehicleLocal [0,0,0];
			_showDir attachto [_obj,[0,1,.58]];
			_showDir setVectorDirAndUp [[0,0,-1],[0,-1,0]];
			PAD_Marks set[count PAD_Marks,_obj];
			PAD_Marks set[count PAD_Marks,_showDir];
			for "_i" from 0 to 20 do{
				_obj="Sign_sphere100cm_EP1" createVehicleLocal [0,0,0];
				_obj setPosATL [_pos select 0,_pos select 1,0+_step];
				_step=_step+2;
				PAD_Marks set[count PAD_Marks,_obj];
			};	
		}forEach (nearestObjects [player,DZE_GaragePad,100]);
	};
};

if (_action=="editpad")exitWith{call _edit_pad};
if (_action=="deletepad")exitWith{call _delete_pad};
if (_action=="movepad")exitWith{call _move_pad};
if (_action=="show")exitWith{call _show_pad};

while {padAction!="exit"}do{
	call _createPadMenu;
	waitUntil {padAction != ""};
	if (padAction=="edit")then{call _edit_pad};
	if (padAction=="delete")then{call _delete_pad};
	if (padAction=="move")then{call _move_pad};
	if (padAction=="show")then{call _show_pad};
};
