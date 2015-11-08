/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_msg","_oldparam","_done","_obj","_objectID","_objectUID","_started","_finished","_animState","_isMedic","_counter","_limit","_objType","_itemOut","_countOut","_selectedRemoveOutput","_refundpart","_isWreck","_broken","_isbroken","_removeTool","_isDestructable","_isRemovable","_preventRefund","_ipos","_item","_radius","_isWreckBuilding","_nameVehicle","_isModular","_msg","_require"];

CheckActionInProgressLocalize(str_epoch_player_88);
player removeAction s_player_deleteBuild;s_player_deleteBuild = -1;
player removeAction s_player_deleteVeins;s_player_deleteVeins = -1;
_obj = THIS3;
if (isNull _obj)exitWith{BreakActionInProgressLocalize(str_epoch_player_91)};

if(_obj in DZE_DoorsLocked)exitWith{BreakActionInProgressLocalize(STR_EPOCH_ACTIONS_20)};
if(_obj getVariable ["GeneratorRunning", false])exitWith{BreakActionInProgressLocalize(str_epoch_player_89)};

_objectID = _obj getVariable ["ObjectID","0"];
_objectUID = _obj getVariable ["ObjectUID","0"];
_objType = typeOf _obj;
if (_objType in DZE_Garage)then{
	_msg="ВНИМАНИЕ!!! Если на момент разбора гаража, в нем находится техника, техника будет УДАЛЕНА!!!";
	systemChat _msg;
	systemChat _msg;
	systemChat _msg;
};

// Chance to break tools
_isDestructable = _obj isKindOf "BuiltItems";
_isWreck = _objType in DZE_isWreck;
_isRemovable = _objType in DZE_isRemovable;
_isMine = _objType in CustomVeins;
_isWreckBuilding = (_objType in DZE_isWreckBuilding);
_isModular = _obj isKindOf "ModularItems";

if (_isWreck)then{
	_require=["ItemToolbox","ItemCrowbar"];
	_broken=[1,0,1];
}else{
	_require=["ItemSledge","ItemToolbox","ItemCrowbar"];
	_broken=[1,2,1,2,2,0];
};
_oldparam = "Land_silver_vein_wreck";
if (_objType == "Iron_Vein_DZE") then {_oldparam = "Land_iron_vein_wreck"};

if !(_require call build_checkRequreItems)exitWith{DZE_ActionInProgress=false};

_done=true;
call {
	if (_objType=="Plastic_Pole_EP1_DZ")exitWith{
		if !([dayz_playerUID,PLOT_FULL_ACCESS,_obj] call fnc_checkObjectsAccess)then{
			_msg="Вы не имеете прав удалить чужой плот!";
			_done=false;
		};
	};
	if (_isDestructable || _isRemovable)exitWith{
		if !([dayz_playerUID,BUILD_ACCESS,getNearPlots(_obj,PLOT_RADIUS)] call fnc_checkObjectsAccess)then{
			_msg="Вы не имеете прав для удаления объектов! Обратитесь к менеджеру или владельцу плота!";
			_done=false;
		};
	};
	if(_isMine && ([_obj,10] call fnc_getNearPlayersCount)>2) then {
		_msg="Разобрать руду могут не более 3 человек одновременно!";
		_done=false;
	};
};
if (!_done)exitWith{BreakActionInProgress(_msg)};

_limit = 3;
if (DZE_StaticConstructionCount > 0) then {
	_limit = DZE_StaticConstructionCount;
}else{
	if (isNumber (configFile >> "CfgVehicles" >> _objType >> "constructioncount")) then {
		_limit = getNumber(configFile >> "CfgVehicles" >> _objType >> "constructioncount");
	};
};

_nameVehicle = getText(configFile >> "CfgVehicles" >> _objType >> "displayName");
cutText [format[(localize "str_epoch_player_162"),_nameVehicle], "PLAIN DOWN"];

if (_isModular) then {
	//allow previous cutText to show, then show this if modular.
	cutText [(localize "STR_EPOCH_ACTIONS_21"), "PLAIN DOWN"];
};

// Alert zombies once.
[player,50,true,(getPosATL player)] spawn player_alertZombies;

// Start de-construction loop
_done = true;
_finished = false;
_isbroken = false;
_counter = 0;
while {_done} do {
	// if object no longer exits this should return true.
	if (!_isMine && isNull _obj)exitWith{_finished=false};
	
	[1,1] call dayz_HungerThirst;
	[_obj,"repair",0,false,20] call dayz_zombieSpeak;
	ANIMATION_MEDIC(false);
	if(!_finished) exitWith {};
	_counter = _counter + 1;

	if !(_require call build_checkRequreItems)exitWith{_done=false;_finished=false};
	if(_isMine)then{if(RND(3))then{_isbroken=true}};
	if(_isbroken)exitWith{_finished=false};

	cutText [format[(localize "str_epoch_player_163"),_nameVehicle,_counter,_limit],"PLAIN DOWN"];
	if(_counter==_limit)exitWith{};
};

if(_isbroken) then {
	_removeTool=SEL(_require,(_broken call BIS_fnc_selectRandom));
	if(([player,_removeTool,1] call BIS_fnc_invRemove) > 0) then {
		cutText [format[(localize "str_epoch_player_164"),getText(configFile >> "CfgWeapons" >> _removeTool >> "displayName"),_nameVehicle], "PLAIN DOWN"];
		if (_removeTool == "ItemSledge") then {
			player addMagazine (["ItemSledgeHead","ItemSledgeHandle","ItemSledgeHead"] call BIS_fnc_selectRandom);
		};
	};
};

// Remove only if player waited
if (_finished) then {
	// Double check that object is not null
	if(!(isNull _obj) || _isMine) then {
		if(_objType=="HeliHRescue")then{
			PVDZE_EvacChopperFieldsUpdate=["rem",_obj];publicVariableServer "PVDZE_EvacChopperFieldsUpdate";
			sleep 1;
		};
		_ipos = getPosATL _obj;
		if (_ipos select 2 < 0)then{_ipos set [2,0]};
		deleteVehicle _obj;
		if(!_isWreck) then {
			[_objectID,_objectUID,player] call fnc_serverDeleteObject;
		};
		cutText [format[(localize "str_epoch_player_165"),_nameVehicle], "PLAIN DOWN"];
		_preventRefund = false;
		_selectedRemoveOutput = [];
		call {
			if(_isWreck)exitWith{
				// Find one random part to give back
				_refundpart = ["PartEngine","PartGeneric","PartFueltank","PartWheel","PartGlass","ItemJerrycan"] call BIS_fnc_selectRandom;
				_selectedRemoveOutput=[[_refundpart,1]];
			};
			if(_isWreckBuilding)exitWith{
				_selectedRemoveOutput = getArray (configFile >> "CfgVehicles" >> _objType >> "removeoutput");
			};
			if (_isMine)exitWith{
				_iPos = getPosATL player;
				_selectedRemoveOutput = getArray (configFile >> "CfgVehicles" >> _oldparam >> "removeoutput");
				if(RND(40)) then {
					_gem = ["ItemTopaz","ItemObsidian","ItemSapphire","ItemAmethyst","ItemEmerald","ItemCitrine","ItemRuby"] call BIS_fnc_selectRandom;
					_selectedRemoveOutput set [(count _selectedRemoveOutput),[_gem,1]];
				};
			};
			_selectedRemoveOutput = getArray (configFile >> "CfgVehicles" >> _objType >> "removeoutput");
			_preventRefund = (_objectID == "0" && _objectUID == "0");
		};
		if((count _selectedRemoveOutput) <= 0) then {
			cutText [(localize "str_epoch_player_90"), "PLAIN DOWN"];
		};
		_radius = 1;

		// give refund items
		if((count _selectedRemoveOutput) > 0 && !_preventRefund) then {
			_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
			{
				_itemOut = _x select 0;
				_countOut = _x select 1;
				if (typeName _countOut == "ARRAY") then {
					_countOut = round((random (_countOut select 1)) + (_countOut select 0));
				};
				_item addMagazineCargoGlobal [_itemOut,_countOut];
			} count _selectedRemoveOutput;
			_item setposATL _iPos;
			player reveal _item;
			player action ["Gear",_item];
		};
	}else{
		cutText [(localize "str_epoch_player_91"),"PLAIN DOWN"];
	};
};
DZE_ActionInProgress = false;