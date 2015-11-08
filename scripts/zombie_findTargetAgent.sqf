/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_agent","_target","_targets","_targetDis","_man","_manDis","_range"];
_agent = _this;
_target = objNull;
_targets = [];
_targetDis = [];
_range = 70;
_manDis = 0;
_targets = _agent getVariable ["targets",[]];

if (isNil "_targets") exitWith {};

//Search for objects
if(count _targets==0)then{
	{
		private["_dis"];
		if(!(_x in _targets))then{
			_targets set [count _targets,_x];
			_targetDis set [count _targetDis,_dis];
		};
	} count (nearestObjects [_agent,["ThrownObjects","GrenadeHandTimedWest","SmokeShell"],50]);
};

//Find best target
if(count _targets > 0)then{
	_man=_targets select 0;
	_manDis=_man distance _agent;
	{
		private["_dis"];
		_dis =  _x distance _agent;
		if (_dis < _manDis) then
		{
			_man = _x;
			_manDis = _dis;
		};
		if (_dis > _range) then
		{
			_targets = _targets - [_x];
		};
		if (_x isKindOf "SmokeShell") then
		{
			_man = _x;
			_manDis = _dis;
		};
	} count _targets;
	_target=_man;
};

//Check if too far
if(_manDis>_range)then{
	_targets=_targets-[_target];
	_target=objNull;
};

_target