private ["_invehicle","_animState","_started","_finished","_isRead","_removed"];
_cash = player getVariable["headShots",0];  
if (_cash < 10000) exitWith {cutText [format["Не достаточно средств. Цена 10,000 руб."], "PLAIN DOWN"];};
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
DZE_ActionInProgress = true;

closeDialog 1;
_invehicle = false;
if (vehicle player != player) then {_invehicle = true;};
if !(_invehicle) then {player playActionNow "Medic";};

[player,"document",0,false,20] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;

 cutText ["Цена сохранения всей техники 10,000руб., двигайтесь для отмены.","PLAIN DOWN"];
    while {r_doLoop} do {
        _animState = animationState player;
        _isRead = ["Medic", _animState] call fnc_inString;
        if (_isRead) then {
            _started = true;
        };
        if (_started and !_isRead) then {
            r_doLoop = false;
            _finished = true;
        };
        if (r_interrupt) then {
            r_doLoop = false;
        };
		if (_invehicle) then {
		sleep 6;
		r_doLoop = false;
		_finished = true;
		};
        sleep 0.1;
    };
    r_doLoop = false;
 

if (_finished) then {

 _removed = [player, 10000] call SC_fnc_removeCoins;
 if (_removed) then { 


private ["_inv","_searchString","_ID","_found","_targetColor","_finalID","_targetPosition","_targetVehicle","_count","_key","_keyName","_showMapMarker","_markerColour","_foundv"];

//**************************************************************************************************************************************
// CONFIG

_showMapMarker = True;            // True = display the map markers, False = just identify the keys
_markerColour = "ColorOrange";    // Alternatives = "ColorBlack", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWhite"

//**************************************************************************************************************************************
_inv = [player] call BIS_fnc_invString;
_keyColor = [];
_keyID = [];
_removedID = [];
_count = 0;

closedialog 0;
{
    for "_i" from 1 to 2500 do {
        _searchString = format ["ItemKey%1%2",_x,str(_i)];
        if ((_searchString in _inv)) then {
			_count = _count + 1;
            _targetColor = _x;
			_keyColor = _keyColor + [_targetColor];
            _ID = str(_i);
			_ID = parseNumber _ID;
			if (_targetColor == "Green") then { _finalID = _ID; };
			if (_targetColor == "Red") then { _finalID = _ID + 2500; };
			if (_targetColor == "Blue") then { _finalID = _ID + 5000; };
			if (_targetColor == "Yellow") then { _finalID = _ID + 7500; };
			if (_targetColor == "Black") then { _finalID = _ID + 10000; };
			_keyID = _keyID + [_finalID];
			_removedID = _removedID + [_ID];
        };
    };
} forEach keyColor;

_i = 0;
for "_i" from 0 to 50 do {deleteMarkerLocal ("vehicleMarker"+ (str _i));};

if (_count == 0) exitWith { systemChat "Ключей не найдено!";DZE_ActionInProgress = true;};

_count = _count - 1;
_i = 0;
_foundv=0;
for "_i" from 0 to _count do {
	_finalID = _keyID select _i;
	_ID = _removedID select _i;
	_targetColor = _keyColor select _i;
	_key = format["ItemKey%1%2",_targetColor,_ID];
	_keyName = getText (configFile >> "CfgWeapons" >> _key >> "displayName");
	_found = 0;
	
	{
		private ["_tID","_vehicle_type"];
		_vehicle_type = typeOf _x;
		_tID = parseNumber (_x getVariable ["CharacterID","0"]);
		if ((_tID == _finalID) && ([_vehicle_type,true] call vehicle_isVehicle)) then {
			_targetPosition = getPosATL _x;
			_found = 1;
			_foundv = _foundv +1;
			
			PVDZE_veh_Update = [_x, "all"];
			publicVariableServer "PVDZE_veh_Update";
			
			_vehicleName = gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayName");
			systemChat format ["%1 от %2. CharID: %3",_keyName,_vehicleName,_finalID];
			_Marker = "vehicleMarker" + str(floor(random 50));
			_vehicleMarker = createMarkerLocal [_Marker,[(_targetPosition select 0),(_targetPosition select 1)]];
			_vehicleMarker setMarkerShapeLocal "ICON";
			_vehicleMarker setMarkerTypeLocal "DOT";
			_vehicleMarker setMarkerColorLocal _markerColour;
			_vehicleMarker setMarkerSizeLocal [1.0, 1.0];
			_vehicleMarker setMarkerTextLocal format ["%1",_vehicleName];
		
		};
	} forEach vehicles;

	if (_found == 0) then {systemChat format ["%1 - CharID: %2 - (Техника не существует)",_keyName,_finalID];};	
};

systemChat format ["Ключей найдено: %1",(_count +1)];
systemChat format ["Всего сохранено техники: %1",_foundv];
if (_foundv != 0) then {systemChat "Техника отмечена на карте."};

 } else {
 cutText [format["Не достаточно средств. Цена 10,000 рублей"], "PLAIN DOWN"];	
 };

	} else {
	r_interrupt = false;

	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		cutText ["Отменено.", "PLAIN DOWN"];
	};
	};

DZE_ActionInProgress = false;