#include "defines.h"

private["_unit","_selection","_done","_total","_source","_hostiles","_isAir","_index"];

_unit = _this select 0;
_selection = _this select 1;
_total = _this select 2;
_source = _this select 3;

if (local _unit && _total > 0) then {
	_done = false;
	_msg = "";
	if (!isNull _source)then{
		if (isPlayer _source)exitWith{_done = true;};
		if (_source isKindOf "AllVehicles")then{
			_done = [_source] call fnc_checkPlayerInVehicle;
		};
	};
	if (!_done)exitWith{};
	_hostiles = _unit getVariable["evacHostile",[]];
	_item = [];
	{
		if (SEL0(_x) == _source) exitWith {_item = _x;};
	} count _hostiles;
	if (CNT(_item)==0)then{
		_item = [_source,0,0];
		_hostiles set [(count _hostiles),_item];
	};
	if ((time-SEL2(_item))>8)then{
		_item set [2,time];
		_item set [1,SEL1(_item)+1];
		SETVARS(_unit,evacHostile,_hostiles);
		//[source,count,lastattacktime]
		_isAir = _source isKindOf "Air";
		[_unit, _item, _isAir] spawn {
			private ["_unit","_array","_name","_source","_pos","_cnt","_cntmsg","_done","_range","_round","_firepos","_gps","_msg","_isAir"];
			PARAMS3(_unit,_array,_isAir);
			EXPLODE2(_array,_source,_cnt);
			_name = getText (configFile >> "cfgVehicles" >> typeof _unit >> "displayName");
			_pos = getPosATL _source;
			_gps = mapGridPosition _pos;
			_cntmsg = "непрерывно идет";
			switch (_cnt) do {
				case 1 : {_cntmsg = "неожиданно начался"};
				case 2 : {_cntmsg = "повторно открыт";};
				case 3 : {_cntmsg = "опять открыт";};
			};
			_msg = format["Внимание это пилот эвакуационного вертолета %1! По мне %2 огонь из квадрата %3! Срочно прошу огневой поддержки!",_name,_cntmsg,_gps];
			PVDZE_send = [_unit,"RadioMsg",[_msg]];
			publicVariableServer "PVDZE_send";
			sleep (4 + random 3);
			if (_isAir)exitWith{
				_done = false;
				if (_cnt<3)then{
					_msg = format["Информация об обстреле из квадрата %1 передана службе ПВО!",_gps];
				}else{
					_msg = format["ПВО наносит удар по цели в квадрате %1!",_gps];
					_done = true;
				};
				PVDZE_send = [_unit,"RadioMsg",[_msg]];
				publicVariableServer "PVDZE_send";
				if (_done)then{
					sleep 3;
					_pos = getPosATL _source;
					_pos set [2,SEL2(_pos)+3];
					_bom = CreateVehicle[evac_AirSupportType,getPosATL _source,[],0,"CAN_COLLIDE"];
				};
			};
			PVDZE_send = [_unit,"RadioMsg",[format["Открываю огонь по квадрату %1!",_gps]]];
			publicVariableServer "PVDZE_send";
			_range = 110 - _cnt * 10;
			if (_range<40)then{_range = 40;};
			_prec = 40 - _cnt * 10;
			if (_prec<3)then{_prec = 3;};
			_round = _cnt * 2;
			for "_i" from 1 to _round do {
				sleep 2;
				_done = false;
				_firepos = [];
				_count = 10;
				while {!_done && _count>0}do{
					_pos = getPosATL _source;
					_firepos = [_pos,[_range,_range]] call fnc_get_rndRectPos;
					if (({(isPlayer _x) || ([_x] call fnc_checkPlayerInVehicle)} count (_firepos nearEntities [["CAManBase","AllVehicles"], _prec]))==0)exitWith{
						// Удар по позиции _firepos
						if((getPosATL _unit) distance _firepos > 70)then{
							_bom = CreateVehicle[evac_SupportType,_firepos,[],0,"CAN_COLLIDE"];
						};
						_done=true;
					};
					_count=_count-1;
				};
			};
		};
	};
} else {
	PVDZE_send = [_unit,"evacHandleDam",_this];
	publicVariableServer "PVDZE_send";
};

_total = 0;

_total
