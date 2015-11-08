/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
disableSerialization;

fnc_AccessUpdateInfo={};
fnc_getAccessUpdateCost={AccessAddCost};

fnc_AccessAddCost={
	PVT3(_unit,_humanity,_value);
	PARAMS1(_unit);
	_humanity=(player getVariable ["humanity",0])+(_unit getVariable ["humanity",0]);
	call {
		if (_humanity<10000)exitWith{_value=2000};
		if (_humanity<11000)exitWith{_value=4000};
		if (_humanity<15000)exitWith{_value=7000};
		if (_humanity<20000)exitWith{_value=10000};
		_value=15000
	};
	AccessAddCost=AccessAddCost+_value;
};

onAccessUpdate={};

onPlayerAdd=fnc_AccessAddCost;

onAccessUnLoad = {
	uiNamespace setVariable ['AccessManagement', nil];
	AccessTarget=nil;
	Friends=nil;
	Humans=nil;
	AccessItems=nil;
	AccessDefault=nil;
};

OnAccessUpdateBtn = {
	PVT6(_access,_state,_msg,_id,_mng,_ctrl);
	PARAMS2(_access,_state);
	_id=7020;
	_mng = uiNamespace getVariable "AccessManagement";
	{
		_ctrl=_mng displayCtrl _id;
		if (SEL4(_x))then{_msg="Включено"}else{_msg="Выключено"};
		_ctrl ctrlSetText format["%1:%2",SEL0(_x),_msg];
		_ctrl ctrlEnable (_state && SEL3(_x));
		_id=_id+1;
	}forEach AccessItems;
};

fnc_AccessUpdate = {
	PVT3(_id,_state,_access);
	PARAMS1(_id);
	_state = _id > -1;
	if (_state)then{
		_access=SEL3(SEL(Friends,_id))
	}else{
		_access=[]
	};
	[_access]call onAccessUpdate;
	[_access,_state] call OnAccessUpdateBtn;
	[] call fnc_AccessUpdateInfo;
	ctrlSetText[7011,""];
};

OnAccessNearChange = {};

OnAccessUserChange = {[THIS0] call fnc_AccessUpdate};

OnAccessChange = {
	PVT6(_access,_id,_user,_state,_msg,_levels);
	_id = lbCurSel 7002;
	if (_id<0)exitWith{};
	_access=SEL(AccessItems,THIS0);
	if(SEL3(_access))then{
		_state=SEL1(_access);
		_user=SEL(Friends,_id);
		_levels=SEL3(_user);
		if (_state in _levels)then{_levels=_levels-[_state];_msg="Выключен"}
		else{_levels set [CNT(_levels),_state];_msg="Включен"};
		_user set[3,_levels];
		[_id] call fnc_AccessUpdate;
		ctrlSetText[7011,format["Режим %1 - %2.",SEL2(_access),_msg]];
	};
};

fnc_updAccessList={
	private "_mng";
	[7001,Humans] call fnc_updatePlayersList;
	[7002,Friends] call fnc_updatePlayersList;
	[lbCurSel 7002] call fnc_AccessUpdate;
};

OnAccessAdd = {
	PVT5(_pos,_inList,_toAdd,_msg,_item);
	PARAMS1(_pos);
	if (_pos<0)exitWith{};
	_item=SEL(Humans,_pos);
	_toAdd=[SEL0(_item),SEL1(_item),+AccessDefault,+AccessDefault];
	_inList=false;
	{if (SEL0(_x)==SEL0(_toAdd))exitWith{_inList=true}} count Friends;
	call {
		if (_inList)exitWith{_msg=format["Игрок %1 уже есть в списке",SEL1(_toAdd)]};
		if (CNT(Friends)>=MaxFriends)exitWith{_msg=format["Ограничение %1 игроков",MaxFriends]};
		Friends set [CNT(Friends),_toAdd];
		[SEL2(_item)] call onPlayerAdd;
		_msg=format["Игрок %1 добавлен в список доступа",SEL1(_toAdd)];
	};
	[] call fnc_updAccessList;
	ctrlSetText[7011,_msg];
};

OnAccessRemove = {
	PVT3(_pos,_toRemove,_newList);
	PARAMS1(_pos);
	if (_pos<0)exitWith{};
	_toRemove=SEL(Friends,_pos);
	_newList=[];
	{
		if(SEL0(_x)!=SEL0(_toRemove))then{
			_newList=_newList+[_x];
		};
	} count Friends;
	Friends=_newList;
	[] call fnc_updAccessList;
	ctrlSetText[7011,format["Игрок %1 удален из доступа к этому плоту",SEL1(_toRemove)]];
};

OnAccessReset = {
	PVT3(_id,_user,_msg);
	PARAMS1(_id);
	if (_id>-1)then{
		_user=SEL(Friends,_id);
		_user set[3,+SEL2(_user)];
		_msg=format["Текущие изменения игрока %1 отменены",SEL1(_user)];
	}else{_msg=""};
	[_id] call fnc_AccessUpdate;
	ctrlSetText[7011,_msg];
};

OnAccessResetAll = {
	AccessAddCost=0;
	Friends=AccessTarget getVariable ["friends",[]];
	{_x set [3, +SEL2(_x)]}count Friends;
	[] call fnc_updAccessList;
	ctrlSetText[7011,"Все текущие изменения отменены"];
};

OnAccessApply = {
	PVT6(_value,_rc,_msg,_friends,_done,_access);
	_done=true;
	_msg="";
	_value=[] call fnc_getAccessUpdateCost;
	if (_value>0)then{
		_rc=[player,_value] call fnc_Payment;
		_done=SEL0(_rc);
		_msg=[_rc] call fnc_PaymentResultToStr;
	};
	if (!_done)exitWith{ctrlSetText[7011,_msg]};
	_friends=[];
	{
		_access=SEL3(_x);
		_x set [2, +_access];
		_friends set [CNT(_friends),[SEL0(_x),SEL1(_x),+_access]];
	}count Friends;
	SETVARS(AccessTarget,friends,_friends);
	PVDZE_veh_Update=[AccessTarget,"friends"];
	publicVariableServer "PVDZE_veh_Update";
	AccessAddCost=0;
	[lbCurSel 7002] call fnc_AccessUpdate;
	ctrlSetText[7011,format["Изменения сохранены. %1",_msg]];
};

onGetOwnerInfo={""};

OnAccessInit={
	ctrlSetText[7003,THIS0];
	AccessAddCost=0;
	Humans=[50] call fnc_getNearPlayersList;
	Friends=AccessTarget getVariable ["friends",[]];
	{_x set [3, +SEL2(_x)]}count Friends;
	ctrlSetText[7010,call onGetOwnerInfo];
	call fnc_updAccessList;
};
