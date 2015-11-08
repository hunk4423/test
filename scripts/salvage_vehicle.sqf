#include "defines.h"
private ["_part","_color","_percent","_string","_handle","_damage","_cmpt","_vehicle","_hitpoints","_max","_min","_skip","_isWrong"];

_vehicle = _this select 3;
if(typeOf _vehicle == "KORD_high")exitWith{};

CheckActionInProgressLocalize(str_epoch_player_94);
_isWrong = typeOf _vehicle in ["MMT_Civ","TT650_Civ","TT650_TK_CIV_EP1","ATV_CZ_EP1","M1030_US_DES_EP1","tractorOld","ATV_US_EP1","TT650_Ins"];
{dayz_myCursorTarget removeAction _x} count s_player_repairActions;s_player_repairActions = [];s_player_repair_crtl=-1;

_hitpoints = _vehicle call vehicle_getHitpoints;
_skip = ["HitLMWheel","HitRMWheel","HitLF2Wheel","HitRF2Wheel"];
{		
	_damage = [_vehicle,_x] call object_getHit;
	_part = "PartGeneric";

	//change "HitPart" to " - Part" rather than complicated string replace
	_cmpt = toArray (_x);
	_cmpt set [0,20];
	_cmpt set [1,toArray ("-") select 0];
	_cmpt set [2,20];
	_cmpt = toString _cmpt;
	
	if(["Engine",_x,false] call fnc_inString) then {
		_part = "PartEngine";
	};
		
	if(["HRotor",_x,false] call fnc_inString) then {
		_part = "PartVRotor"; //yes you need PartVRotor to fix HRotor LOL
	};

	if(["Fuel",_x,false] call fnc_inString) then {
		_part = "PartFueltank";
	};

	if(["Wheel",_x,false] call fnc_inString) then {
		_part = "PartWheel";
	};	
	if(["Glass",_x,false] call fnc_inString) then {
		_part = "PartGlass";
	};
	
	if!(_isWrong && _part == "PartGlass") then {
		// allow removal of any lightly damaged parts
		_max = 1;
		_min = _damage >= 0;
		
		if((_part=="PartEngine")||(_part=="PartFueltank"))then{_max = 0.79;};
		if (_x in _skip) then {_min = _damage > 0;};
			
		if ((_damage <_max) && _min) then {
			call{
				if (_damage >= 0.9)exitWith{_color = "color='#ff0000'"}; //red
				if (_damage >= 0.5)exitWith{_color = "color='#ff8800'"}; //orange
				_color = "color='#ffff00'"; //yellow
			};
			_percent = round(_damage*100);
			_string = format["<t %2>Демонтировать %1 (%3%4)</t>",_cmpt,_color,_percent,"%"]; //Remove - Part
			_handle = dayz_myCursorTarget addAction [_string, "scripts\salvage.sqf",[_vehicle,_part,_x],0,false,true,"",""];
			s_player_repairActions set [count s_player_repairActions,_handle];
		};
	};
} count _hitpoints;

if(count _hitpoints > 0 ) then {	
	_handle = dayz_myCursorTarget addAction [localize "STR_EPOCH_PLAYER_CANCEL","\z\addons\dayz_code\actions\repair_cancel.sqf","repair",0,true,false,"",""];
	s_player_repairActions set [count s_player_repairActions,_handle];
	s_player_repair_crtl = 1;
	s_event_reset=false;
};
DZE_ActionInProgress=false;