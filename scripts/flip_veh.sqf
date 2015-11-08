/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_veh","_pos","_near","_done"];
player removeAction flip_veh_act_id;
flip_veh_act_id = -1;
_veh = _this select 3;

if(count crew _veh > 0) exitWith { cutText ["Нельзя перевернуть технику, поскольку в ней люди.", "PLAIN DOWN"]; };
CheckActionInProgress(MSG_BUSY);

_pos = getPosATL _veh;
_done = true;

_near=getNearPlots(_pos,PLOT_RADIUS);

if ((count _near)>0)then{
	_done = [dayz_playerUID,ANY_ACCESS,_near] call fnc_checkObjectsAccess;
	if (!_done)then{
		_done=true;
		_near = _pos nearObjects 10;
		{
			if ((typeof _x) in dayz_allowedObjects)exitWith{_done=false;};
		}count _near;
	};
};

if (_done)then{
	_veh setPos [_pos select 0, _pos select 1, (_pos select 2)+0.1];
}else{
	systemChat "Транспорт находится в зоне плота рядом с постройкой - действие отменено!";
};
DZE_ActionInProgress = false;