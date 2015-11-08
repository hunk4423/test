private ["_vehicle","_status","_islock"];

_vehicle = _this select 0;
_status = _this select 1;

if (local _vehicle) then {
	_islock = (locked _vehicle);
	if(_status) then {
		_vehicle setVehicleLock "LOCKED";
		_vehicle allowDamage false;
		if (!_islock)then{
			[_vehicle,"q_lock"] call fnc_vehLockEffect;
		};
	} else {
		_vehicle setVehicleLock "UNLOCKED";
		_vehicle allowDamage true;
		if (_islock)then{
			[_vehicle,"q_unlock"] call fnc_vehLockEffect;
			_vehicle setVariable["inSafeZone",([_vehicle] call fnc_inSafeZone),true];
		};
	};
	_vehicle setVariable["LostTime",-(floor (serverTime/60)),true];
};
