/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

fnc_GaragePadModeGetItemByName={
	private ["_mode","_name","_result"];
	PARAMS2(_mode,_name);
	_result=[];
	{if (SEL0(_x)==_name)exitWith{_result=_x}}count _mode;
	_result
};

fnc_GarageGetPadSpawnPos={
	private ["_pad","_class","_mode","_to","_objects","_result","_cnt","_lv"];
	PARAMS2(_pad,_class);
	_mode=GETVAR(_pad,SpawnMode,DZE_GaragePadMode);
	_result=[];
	{if (_class isKindOf SEL0(_x))exitWith{_result=_x}}forEach _mode;
	if (CNT(_result)>0)then{
		_lv=SEL1(_result);
		_result=getPosASL _pad;
		if (_lv==1||_lv==2)then{
			_to=+_result;
			_to set [2,2000];
			_objects=lineIntersectsWith[_to,_result,_pad,objNull,true];
			_cnt=CNT(_objects);
			if (_cnt>0)then{
				if (_lv==2)then{
					_result set[2,SEL2(getPosASL SEL(_objects,_cnt-1))];
				}else{
					_result set[2,SEL2(getPosASL SEL0(_objects))];
				};
			};
		};
		_result=ASLtoATL _result;
		if (_lv==3)then{_result set[2,0]};
	};
	_result
};

CalcDelta=4;

fnc_GetPadPlace={
	private ["_class","_pads","_pad","_size","_result","_done","_pos","_is_big"];
	PARAMS2(_class,_pads);
	_is_big=(_class isKindOf "Air")||(_class isKindOf "Ship");
	_result=[];
	{
		_done=true;
		if(_x getVariable["taxilock",false])then{_done=false};
		_size=sizeOf (typeof _x);
		if(_size==0)then{_size=15};
		if(!_is_big)then{_size=8};
		_pad=_x;
		_pos=[_pad,_class] call fnc_GarageGetPadSpawnPos;
		if (CNT(_pos)>0)then{
			{
				if ((_x distance _pos)<(_size-CalcDelta))exitWith{_done=false};
			}count (_pos nearEntities [[VEHICLE_MOVE_TYPE],(_size+CalcDelta)]);
		}else{_done=false};
		if (_done)exitWith{_result=[getDir _pad,_pos]};
	}count _pads;
	_result
};

fnc_GaragePenaltyCost={
	private ["_h","_rc"];
	_h=round(THIS0);
	_rc=0;
	if(_h>720)then{_rc=(round((_h-720)/60)*1000) min 10000};
	_rc
};