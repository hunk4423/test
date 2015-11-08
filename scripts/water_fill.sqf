private ["_text","_waters","_canFill","_isWell","_objectsWell","_pondPos","_isPond","_objectsPond","_hastinitem","_water","_playerPos","_onLadder","_hasbottleitem","_config"];

call gear_ui_init;

_playerPos = 	getPosATL player;
_canFill = 		count nearestObjects [_playerPos, ["MAP_barrel_water","Land_pumpa","Land_water_tank","Land_Misc_Well_L_EP1","Land_Misc_Well_C_EP1","Land_Barrel_water"], 4] > 0;
_isPond = 		false;
_isWell = 		false;
_pondPos = 		[];
_objectsWell = 	[];

_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

_hasbottleitem = _this in magazines player;

_config = configFile >> "CfgMagazines" >> _this;
_text = getText (_config >> "displayName");

if (!_hasbottleitem) exitWith {cutText [format[(localize "str_player_31"),_text,"fill"] , "PLAIN DOWN"]};

if (!dayz_isSwimming) then {
	player playActionNow "PutDown";
};

if (!_canFill) then {
	_objectsWell = 	nearestObjects [_playerPos, [], 4];
	{
		//Check for Well
		_isWell = ["_well",str(_x),false] call fnc_inString;
		if (_isWell) then {_canFill = true};
	} count _objectsWell;
};

if (!_canFill) then {
	_objectsPond = 		nearestObjects [_playerPos, [], 50];
	{
		//Check for pond
		_isPond = ["pond",str(_x),false] call fnc_inString;
		if (_isPond) then {
			_pondPos = (_x worldToModel _playerPos) select 2;
			if (_pondPos < 0) then {
				_canFill = true;
			};
		};
	} count _objectsPond;
};

if (_canFill) then {
	_waters = ["ItemWaterbottleUnfilled","ItemWaterbottle1oz","ItemWaterbottle2oz","ItemWaterbottle3oz","ItemWaterbottle4oz","ItemWaterbottle5oz","ItemWaterbottle6oz","ItemWaterbottle7oz","ItemWaterbottle8oz","ItemWaterbottle9oz"];
	_hastinitem = false;
	_qty = 0;
	{
		if (_x in magazines player) then {
		
			_num_removed = ([player,_x] call BIS_fnc_invRemove);
				
				if (_num_removed == 1) then {
				player addMagazine "ItemWaterbottle";
				_qty = _qty+ 1;
				_hastinitem = true;
				};			
		};
	if (_hastinitem) exitWith {};
	} count _waters;
	
	if (_hastinitem) then {cutText ["Фляжка наполнена водой", "PLAIN DOWN"];};
	
} else {
	cutText [(localize "str_player_20") , "PLAIN DOWN"];
};