private ["_inv","_keys","_searchString","_keyCount","_ID","_targetPos","_found","_targetID","_targetColor","_finalID","_targetPosition","_toPosition","_targetVehicle","_pPos","_pDir","_moveMethod"];
if (CurrAdminLevel<1) exitWith {};

_inv = [player] call BIS_fnc_invString;
_found = 0;
_moveMethod = _this select 0;
//"MeToCar"; // "CarToMe"
{
	for "_i" from 1 to 2500 do {
		_searchString = format ["ItemKey%1%2",_x,str(_i)];
		if ((_searchString in _inv) && (_found != 1)) then {
			_targetColor = _x;
			_ID = str(_i);
			_found = 1;
		};
	};
} forEach keyColor;

if (_found == 0) exitWith { systemChat "Ключ не найден!";};

_ID = parseNumber _ID;
if (_targetColor == "Green") then { _finalID = _ID; };
if (_targetColor == "Red") then { _finalID = _ID + 2500; };
if (_targetColor == "Blue") then { _finalID = _ID + 5000; };
if (_targetColor == "Yellow") then { _finalID = _ID + 7500; };
if (_targetColor == "Black") then { _finalID = _ID + 10000; };
_found = 0;

if(_moveMethod == "CharID")exitWith{systemChat format ["CharID техники: %1",_finalID];};

{
	private ["_tID"];
	_tID = parseNumber (_x getVariable ["CharacterID","0"]);
	if ((_tID == _finalID) && (_found != 1)) then {
		_targetPosition = getPosATL _x;
		_targetVehicle = _x;
		_found = 1;
	};
} forEach vehicles;

if(_found==0)exitWith{systemChat "Машина не существует или слишком много ключей!";};

if (_moveMethod == "MeToCar") then {
	_toPosition = [_targetPosition,1,10,1,1,5,0] call BIS_fnc_findSafePos;
	player setPos _toPosition;
};

if (_moveMethod == "CarToMe") then {
	_pPos = getPosATL player;
	_pDir = getDir player;
	_targetVehicle setPos _pPos;
	_targetVehicle setDir _pDir;
};

systemChat format ["Найден: %1",typeOf _targetVehicle];
systemChat format ["ID: %1",_finalID];