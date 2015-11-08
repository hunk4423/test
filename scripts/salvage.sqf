/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_vehicle","_part","_hitpoint","_type","_selection","_array","_started","_finished","_animState","_isMedic","_isOK","_brokenPart","_findPercent","_damage","_nameType","_namePart","_brokenTool","_dam"];

CheckActionInProgressLocalize(str_epoch_player_94);
{dayz_myCursorTarget removeAction _x} count s_player_repairActions;s_player_repairActions = [];s_player_repair_crtl=-1;

_array = THIS3;
EXPLODE3(_array,_vehicle,_part,_hitpoint);
_type = typeOf _vehicle; 

// moving this here because we need to know which part needed if we don't have it
_nameType = getText(configFile >> "cfgVehicles" >> _type >> "displayName");
_namePart = getText(configFile >> "cfgMagazines" >> _part >> "displayName");

{_vehicle removeAction _x} count s_player_repairActions;s_player_repairActions = [];s_player_repair_crtl = -1;
if !("ItemToolbox" in items player)then{BreakActionInProgressLocalize1(str_epoch_player_170,_namePart)};

_isOK = false;
_brokenPart = false;

[1,1] call dayz_HungerThirst;
[player,"repair",50,50] call fnc_alertSound;
ANIMATION_MEDIC(true);

_brokenTool = false;
if(RND(5)) then {_brokenTool = true};
_dam = 1;
if (_finished) then {
	_damage = [_vehicle,_hitpoint] call object_getHit;
	if (_damage < 1) then {
		if(_brokenTool)then{
			//Сломал инструменты
			if(([player,"ItemToolbox",1] call BIS_fnc_invRemove) > 0) then {
				if(_part == "PartEngine" || _part == "PartFueltank") then {_dam = 0.8;};
				_selection = getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _hitpoint >> "name");

				PVDZE_veh_SFix = [_vehicle,_selection,_dam];
				if (local _vehicle) then {
					PVDZE_veh_SFix call object_setFixServer;
				}else{
					publicVariable "PVDZE_veh_SFix";
				};
				_vehicle setvelocity [0,0,1];

				cutText [format["%1 сломан, %2 уничтожен(о) при разборе.",getText(configFile >> "CfgWeapons" >> "ItemToolbox" >> "displayName"),_namePart], "PLAIN DOWN"];
				[objNull, player, rSwitchMove,""] call RE;
				player playActionNow "stop";
			};
		}else{
			//Не сломал инструменты
			_findPercent = (1 - _damage) * 10;
			if(ceil (random _findPercent) == 1) then {
				_isOK = true;
				_brokenPart = true;
			} else {
				_isOK = [player,_part] call BIS_fnc_invAdd;
				_brokenPart = false;
			};
		
			if (_isOK) then {
				//break the part
				_selection = getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _hitpoint >> "name");
			
				//vehicle is owned by whoever is in it, so we have to have each client try && fix it
				//["PVDZE_veh_SFix",[_vehicle,_selection,1],_vehicle] call broadcastRpcCallIfLocal;
				if( _part == "PartEngine" || _part == "PartFueltank" ) then {_dam = 0.8;};
				
				PVDZE_veh_SFix = [_vehicle,_selection,_dam];
				if (local _vehicle) then {
					PVDZE_veh_SFix call object_setFixServer;
				}else{
					publicVariable "PVDZE_veh_SFix";
				};

				_vehicle setvelocity [0,0,1];

				if(_brokenPart) then {
					//Failed!
					cutText [format[(localize "str_epoch_player_168"),_namePart,_nameType], "PLAIN DOWN"];
				} else {
					//Success!
					cutText [format[(localize "str_epoch_player_169"),_namePart,_nameType], "PLAIN DOWN"];
				};
			} else {
				cutText [localize "STR_DAYZ_CODE_2", "PLAIN DOWN"];
			};
		};
	};
};

DZE_ActionInProgress = false;
