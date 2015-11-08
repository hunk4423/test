/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_chopper","_chopperact","_cargo","_canttow","_can_lift","_cargo_pos","_rel_pos","_cargo_x","_cargo_y","_cargo_z","_hud_y","_hud_x","_rel_y","_hud_x_1","_hud_y_1","_pic_cargo","_name_cargo","_text_action","_array","_ui","_obj_img","_obj_pic","_arrow","_obj_name","_array_hud"];

_radar_visible={
	PARAMS1PVT(_state);
	{_x ctrlShow _state} count _array_hud;
};

disableSerialization;
RadarHudShow=false;
90000 cutRsc ["BTC_Hud","PLAIN"];
_ui        = uiNamespace getVariable "HUD";
_obj_img   = _ui displayCtrl 1002;
_obj_pic   = _ui displayCtrl 1003;
_arrow     = _ui displayCtrl 1004;
_obj_name  = _ui displayCtrl 1005;
_array_hud = [_ui displayCtrl 1000,_ui displayCtrl 1001,_obj_img,_obj_pic,_arrow,_obj_name];
[false] call _radar_visible;
_chopper=objNull;_cargo_pos=[];_rel_pos=[];_cargo_x=0;_cargo_y=0;_cargo_z=0;

while {true} do 
{
	if (!Alive player)then{
		[false] call _radar_visible;
	};
	if (AL_Hud_Cond)then{
		[false] call _radar_visible;
		AL_Hud_Cond = false;
	};

	_array = [];

	waitUntil {
		sleep 1;
		_chopper = vehicle player;
		if (_chopper != player)then{
			if((driver _chopper) == player && _chopper iskindof "Helicopter")then{
				_array = [_chopper] call fnc_getLiftableArray;
			};
		};
		((count _array) > 0)
	};
	
	_chopperact=_chopper;
	[_chopperact] call fnc_togleRadarAction;

	while {_chopper != player && (driver _chopper) == player && (damage _chopper)<1}do{
		_can_lift=false;
		_cargo=objNull;
		{
			if(_x!=_chopper)then{
				if!(lineIntersects [getposASL(_chopper), getposASL(_x), _chopper, _x])then{_cargo=_x};
			};
			if(!isNull _cargo)exitWith{};
		}forEach nearestObjects [_chopper,AL_Liftable,50];
		
		if (!AL_Hud_Cond && RadarHudShow)then{
			[false] call _radar_visible;
			RadarHudShow=false;
		};
		if (!(isNull _cargo))then{			
			_canttow=GetCanNotTow(_cargo)||GetInTow(_cargo)||GetTow(_cargo);
			_name_cargo = getText (configFile >> "cfgVehicles" >> typeof _cargo >> "displayName");
			if (({_cargo isKindOf _x} count _array) > 0)then{
				_can_lift=true;
			};
		};
		if (_can_lift)then{
			_cargo_pos = getPosATL _cargo;
			_rel_pos   = _chopper worldToModel _cargo_pos;
			_cargo_x   = _rel_pos select 0;
			_cargo_y   = _rel_pos select 1;
			_cargo_z   = _rel_pos select 2;
		};
		if (!isNull _cargo && AL_Hud_Cond)then{
			if !(RadarHudShow)then{
				[true] call _radar_visible;
				RadarHudShow = true;
			};
			if (_can_lift)then{
				_obj_img ctrlShow true;
				_hud_x   = (_rel_pos select 0) / 100;
				_rel_y   = (_rel_pos select 1);
				_hud_y   = 0;
				switch (true) do {
					case (_rel_y < 0): {_hud_y = (abs _rel_y) / 100};
					case (_rel_y > 0): {_hud_y = (0 - _rel_y) / 100};
				};
				_hud_x_1 = AL_HUD_x + _hud_x;
				_hud_y_1 = AL_HUD_y + _hud_y;
				_obj_img ctrlsetposition [_hud_x_1, _hud_y_1];
				_obj_img ctrlCommit 0;
			}else{
				_obj_img ctrlShow false;
			};
			
			_pic_cargo = "";
			if (_cargo isKindOf "LandVehicle") then {
				_pic_cargo = getText (configFile >> "cfgVehicles" >> typeof _cargo >> "picture");
			};
			
			_obj_pic ctrlSetText _pic_cargo;
			_obj_name ctrlSetText _name_cargo;
			if ((abs _cargo_z) > AL_lift_max_h) then {
				_arrow ctrlSetText "\ca\ui\data\arrow_down_ca.paa";
			};
			if ((abs _cargo_z) < AL_lift_min_h) then {
				_arrow ctrlSetText "\ca\ui\data\arrow_up_ca.paa";
			};
			if ((abs _cargo_z) > AL_lift_min_h && (abs _cargo_z) < AL_lift_max_h) then {
				if (_canttow || (locked _cargo)) then {
					_arrow ctrlSetText "\ca\ui\data\lock_on_ca.paa";
				} else {
					_arrow ctrlSetText "\ca\ui\data\objective_complete_ca.paa";
				};
			};
			if (!_can_lift && AL_Hud_Cond) then {
				_arrow ctrlSetText "\ca\ui\data\objective_incomplete_ca.paa";
			};
		} else {
			[false] call _radar_visible;
			RadarHudShow=false;
		};
		_canAct = false;
		if (!isNull _cargo && AL_status == 0 && _can_lift)then{
			if (((abs _cargo_z) < AL_lift_max_h) && ((abs _cargo_z) > AL_lift_min_h) && ((abs _cargo_x) < AL_lift_radius) && ((abs _cargo_y) < AL_lift_radius))then{
				if (!(locked _cargo) && AL_status == 0 && !_canttow)then{
					_canAct = true;
				};
			};
		};
		if (_canAct)then{
			if (AeroLiftActionId<0)then{
				AeroLiftActionId = _chopperact addAction ["<t color='#ED2744'>Зацепить "+(_name_cargo)+"</t>", SCRIPT_FILE(attachCargo.sqf), [_cargo, _name_cargo], 7, true, true];
			};
		}else{
			if (AeroLiftActionId>-1)then{
				_chopperact removeAction AeroLiftActionId;
				AeroLiftActionId = -1;
			};
		};
		//высадит скрипт в selfAction
		sleep 0.1;
		_chopper = vehicle player;
	};
	_chopperact removeAction AeroLiftHudId;
	AeroLiftHudId=-1;
	if(AeroLiftActionId>-1)then{
		_chopperact removeAction AeroLiftActionId;
		AeroLiftActionId = -1;
	};
};