/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_showArea","_showDir","_PAD_Marks","_step","_ball","_ShowPad","_array","_action","_isnew","_removed","_NeedItemSledge","_ItemSledgeList","_objectHelperPos","_location","_dir","_classname","_item","_hasrequireditem","_missing","_hastoolweapon","_cancel","_reason","_started","_finished","_animState","_isMedic","_hasbuilditem","_tmpbuilt","_require","_text","_offset","_isOk","_location1","_location2","_counter","_limit","_proceed","_position","_object","_distance","_classnametmp","_ghost","_isPole","_lockable","_rotate","_dx","_dy","_dz","_combination_1","_combination_2","_combination_3","_combination_4","_combination","_combinationDisplay","_abort","_needNear","_tdx","_tdy","_tdz","_playerUID","_vector","_backup","_is_buildable","_veh","_done"];

CheckActionInProgressLocalize(str_epoch_player_40);

call gear_ui_init;closeDialog 1;
_PAD_Marks=[];

_restore_object={_object setdir SEL0(_backup);_object setVectorDirAndUp SEL1(_backup);_object setPosATL SEL2(_backup)};
_remove_build={
	detach _object;detach BuildHelper;deleteVehicle BuildHelper;
	if (_isnew)then{deleteVehicle _object}else{if(THIS0)then{call _restore_object}};
	{deleteVehicle _x;}count _PAD_Marks;
};

if (typeName _this=="STRING")then{
	_item=_this;_removed=[_item];_action="build";_is_buildable=false;
}else{
	_is_buildable=true;EXPLODE3(_this,_item,_removed,_action);
};

_abort=false;_isnew=false;
switch (_action)do{
	case "move": {
		_object=_item;_item=typeOf _object;_is_buildable=false;
		if (GETVAR(_object,BuildMove,false)||CurrAdminLevel>0)then{_removed=[]};
	};
	case "build": {_isnew=true};
	default {_abort=true};
};
if(_abort)exitWith{BreakActionInProgress("Неизвестная команда строительства")};
if(_item in DZE_GaragePad)then{_ShowPad=true}else{_ShowPad=false};
if(_item in["ItemWire","ItemTankTrap","stick_fence_kit","ItemSandbag","BagFenceRound_DZ_kit"])exitWith{BreakActionInProgress("Данный объект нельзя построить, он используется только для крафта.")};
if(_item in["ItemTentOld","ItemTentDomed","ItemTentDomed2"])then{systemChat"ВНИМАНИЕ! Палатка небезопасное место для хранения лута.";systemChat"Администрация не восстанавливает лут украденный из палатки!";};

_ItemSledgeList=["ItemGunRackKit","ItemVault","ItemLockbox","wooden_shed_kit","storage_shed_kit","workbench_kit","wood_shack_kit","ItemWoodCrateKit","PartWoodPile","ItemTentDomed2","ItemTentDomed","ItemTentOld"];
TotalBuildNear=count (nearestObjects [player,dayz_allowedObjects,PLOT_RADIUS]);
if(TotalBuildNear>=DZE_BuildingLimit && _isnew)exitWith{
	DZE_ActionInProgress=false; 
	cutText [(localize "str_epoch_player_41"),"PLAIN DOWN"];
	systemChat format["Если на базе больше %1 объектов, как у вас, ее можно поменять на здание из игры!",DZE_BuildingLimit];
};

if(dayz_isSwimming)exitWith{BreakActionInProgressLocalize(str_player_26)};
if((getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder"))==1)exitWith{BreakActionInProgressLocalize(str_player_21)};
if(InVeh(player))exitWith{BreakActionInProgressLocalize(str_epoch_player_42)};
if(player getVariable["combattimeout", 0]>=time)exitWith{BreakActionInProgressLocalize(str_epoch_player_43)};

if(CNT(_removed)>0)then{_abort=!(_removed call player_checkItems)};

if (_abort)exitWith{
	_missing=[_removed] call fnc_getMissingMessage;
	BreakActionInProgress(_missing);
};

_playerUID=getPlayerUID player;

DZE_UP=0;
DZE_DN=0;
DZE_SET=false;
DZE_RL=false;
DZE_RR=false;
DZE_F=false;
helperDetach=false;
DZE_Loading=false; 
_vector=[];
DZE_BuildVector=[[0,0,0],[0,0,0]];
DZE_cancelBuilding=false;
_cancel=false;
_NeedItemSledge=!(_item in _ItemSledgeList);

// Need Near Requirements
_reason="";
if (_isnew)then{
	_needNear = getArray (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "neednearby");
	//if (_item=="fuel_pump_kit")then{_needNear set [CNT(_needNear),"fueltank"];
	{
		switch(_x) do{
			case "fire":{_distance=3;if({inflamed _x}count(getPosATL player nearObjects _distance) == 0) then {_abort=true;_reason="огонь"}};
			case "workshop":{_distance=3;if(count (player nearEntities [["Wooden_shed_DZ","WoodShack_DZ","WorkBench_DZ"],_distance])==0)then{_abort=true;_reason="верстак"}};
			case "fueltank":{_distance=FUEL_RANGE;if(count (getNearObj(player,dayz_fuelsources,_distance))==0)then{_abort=true;_reason="топливо"}};
		};
	} count _needNear;
};
if(_abort)exitWith{
	DZE_ActionInProgress=false;cutText [format[localize "str_epoch_player_135",_reason,_distance],"PLAIN DOWN"]
};

// get inital players position
_location1=getPosATL player;

if (_isnew)then{
	if (_is_buildable)then{
		_classname=_item;
		_require=getArray (missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _classname >> "requiredtools");
	}else{
		_classname=getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "create");
		_require=getArray (configFile >> "cfgMagazines" >> _item >> "ItemActions" >> "Build" >> "require");
	};
	_abort=!([_classname,_location1,true] call build_checkCanBuild);
}else{
	_require=[];_classname=_item;
};
if (_abort)exitWith{DZE_ActionInProgress=false};

_text="";
if (_isnew)then{
	_classnametmp=_classname;
	if (_is_buildable)then{_text=getText(missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _classname >> "displayName")};
};
if (_text=="")then{_text=getText (configFile >> "CfgVehicles" >> _classname >> "displayName")};
_ghost=getText (configFile >> "CfgVehicles" >> _classname >> "ghostpreview");

_lockable=0;
if(isNumber (configFile >> "CfgVehicles" >> _classname >> "lockable"))then{
	_lockable=getNumber(configFile >> "CfgVehicles" >> _classname >> "lockable");
};

_isAllowedUnderGround = 1;
if(isNumber (configFile >> "CfgVehicles" >> _classname >> "nounderground"))then{
	_isAllowedUnderGround=getNumber(configFile >> "CfgVehicles" >> _classname >> "nounderground");
};

_offset=[0,3.5,0];
if (_is_buildable)then{
	_offset=getArray (missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _classname >> "offset");
}else{
	//_offset = getArray (configFile >> "CfgVehicles" >> _classname >> "offset");
};
if(_classname in ["DesertCamoNet_DZ","ForestCamoNet_DZ","DesertLargeCamoNet_DZ","ForestLargeCamoNet_DZ"])then{_offset=[0,5,1]};

if((count _offset)<=0)then{_offset=[0,3.5,0]};

_isPole=(_classname=="Plastic_Pole_EP1_DZ");

_missing="";
_hasrequireditem=true;
if (_NeedItemSledge) then {_require set [count _require, "ItemSledge"]};
{
	_hastoolweapon=_x in weapons player;
	if(!_hastoolweapon)exitWith{_hasrequireditem=false;_missing=getText (configFile >> "cfgWeapons" >> _x >> "displayName")};
} count _require;

_hasbuilditem=true;
if (!_is_buildable && _isnew)then{
	_hasbuilditem = _item in magazines player;
};
if (!_hasbuilditem)exitWith{BreakActionInProgressLocalize2(str_player_31,_text,"строить")};

if !(_require call build_checkRequreItems)exitWith{DZE_ActionInProgress=false};

_location=[0,0,0];

// if ghost preview available use that instead
/*if (_ghost != "") then {
	_classname = _ghost;
};*/

//Build gizmo
if(_ShowPad)then{
	BuildHelper="Sign_arrow_down_large_EP1" createVehicle _location;
}else{
	BuildHelper="Sign_sphere10cm_EP1" createVehicle _location;
	BuildHelper setobjecttexture [0,"#(argb,8,8,3)color(0,0,0,0,ca)"];
};

DZE_memForBack=0;DZE_memLeftRight=0;
if (_isnew)then{
	_object=createVehicle [_classname,_location,[],0,"CAN_COLLIDE"];
	_object setDir 0;
	BuildHelper attachTo [player, _offset];
	DZE_memDir=getDir BuildHelper;
}else{
	helperDetach=true;
	DZE_memDir=getDir _object;
	_backup=[DZE_memDir,[(vectorDir _object),(vectorUp _object)],getPosATL _object];
	DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
	BuildHelper setPosATL SEL2(_backup);
};

if(_ShowPad)then{
	_object attachTo [BuildHelper,[0,0,-.73]];
	_showDir="Sign_arrow_down_large_EP1" createVehicle _location;
	_showDir attachto [BuildHelper,[0,1,.58]];
	_showDir setVectorDirAndUp [[0,0,-1],[0,-1,0]];
	_PAD_Marks set[count _PAD_Marks,_showDir];
	if(_item!="Sr_border")then{
		_showArea="Sr_border" createVehicle _location;
		_showArea attachto [BuildHelper,[0,0,-.69]];
		_PAD_Marks set[count _PAD_Marks,_showArea];
	};
	_step=3;
	for "_i" from 0 to 20 do{
		_ball="Sign_sphere100cm_EP1" createVehicle _location;
		_ball attachTo [BuildHelper,[0,0,(0+_step)]];
		_step=_step+2;
		_PAD_Marks set[count _PAD_Marks,_ball];
	};
} else {
	_object attachTo [BuildHelper,[0,0,0]];
};
_position = getPosATL BuildHelper;

cutText [(localize "str_epoch_player_45"), "PLAIN DOWN"];

_tdx=0;_tdy=0;_tdz=0;

if (isClass (missionConfigFile >> "SnapBuilding" >> _classname))then{
	["","","",["Init",_object,_classname,BuildHelper]] spawn snap_build;
};

DZE_updateVec = false;
BuildMode=true;
s_build_act=[];
if !(_classname in DZE_noRotate) then{
	s_build_act set [CNT(s_build_act),(player addaction ["Сбросить наклон","scripts\player_vectorChange.sqf","reset"])];
	s_build_act set [CNT(s_build_act),(player addaction ["Сбросить направление","scripts\player_vectorChange.sqf","nord"])];
	s_build_act set [CNT(s_build_act),(player addaction ["<t color='#5882FA'>Наклонить:</t> Вперед","scripts\player_vectorChange.sqf","forward"])];
	s_build_act set [CNT(s_build_act),(player addaction ["<t color='#5882FA'>Наклонить:</t> Назад","scripts\player_vectorChange.sqf","back"])];
	s_build_act set [CNT(s_build_act),(player addaction ["<t color='#5882FA'>Наклонить:</t> Влево","scripts\player_vectorChange.sqf","left"])];
	s_build_act set [CNT(s_build_act),(player addaction ["<t color='#5882FA'>Наклонить:</t> Вправо","scripts\player_vectorChange.sqf","right"])];
	{
		s_build_act set [CNT(s_build_act),(player addaction [format["<t color='#5882FA'>Наклонять на:</t> %1град.",_x],"scripts\player_vectorChange.sqf",_x])];
	} forEach [0.5,1,5,10,45,90];
};
if(!_isnew&&([_item]call vehicle_canLoadingItem))then{s_build_act set [CNT(s_build_act),(player addaction ["<t color='#5882FA'>Погрузить</t>","scripts\player_vectorChange.sqf","loading"])]};

_dx=0;_dy=0;_dz=0;
_rotate = false;
_isOk = true;
while {_isOk} do {
	if(!BuildMode)exitWith{_isOk=false;_cancel=true;_reason="Отменено.";[true]call _remove_build};

	if (DZE_UP!=0)then{_dz=DZE_UP;DZE_UP=0};
	if (DZE_DN!=0)then{_dz=DZE_DN;DZE_DN=0};
	if (DZE_Left!=0)then{_dx=DZE_Left;DZE_Left=0};
	if (DZE_Right!=0)then{_dx=DZE_Right;DZE_Right=0};
	if (DZE_Forward!=0)then{_dy=DZE_Forward;DZE_Forward=0};
	if (DZE_Back!=0)then{_dy=DZE_Back;DZE_Back=0};
	if (DZE_RL)then{
		_rotate=true;DZE_RL=false;
		if (helperDetach)then{DZE_memDir=DZE_memDir-DZE_curPitch}else{DZE_memDir=180};
	};
	if (DZE_RR)then{
		_rotate=true;DZE_RR=false;
		if (helperDetach)then{DZE_memDir=DZE_memDir+DZE_curPitch}else{DZE_memDir=0};
	};

	if(DZE_updateVec) then{
		DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
		DZE_updateVec = false;
	};
	if(DZE_F && !r_drag_sqf && !r_player_unconscious)then{
		if(helperDetach)then{
			BuildHelper attachTo [player];
			DZE_memDir=DZE_memDir-(getDir player);
			helperDetach=false;
			DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
		} else {
			_objectHelperPos=getPosATL BuildHelper;
			detach BuildHelper;
			DZE_memDir=getDir BuildHelper;
			DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
			BuildHelper setPosATL _objectHelperPos;
			BuildHelper setVelocity [0,0,0]; //fix sliding glitch
			helperDetach=true;
		};
		DZE_F=false;
	};

	if(_rotate)then{
		DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
		_rotate=false;
	};

	if(_dx!=0||_dy!=0||_dz!=0)then{
		if(!helperDetach)then{detach BuildHelper};
		_position=getPosASL BuildHelper;
		_dir=getDir _object;
		if(_dx!=0)then{
			_position set [0,(SEL0(_position)+_dx*cos _dir)];
			_position set [1,(SEL1(_position)-_dx*sin _dir)];
		};
		if (_dy!=0)then{
			_position set [0,(SEL0(_position)+_dy*sin _dir)];
			_position set [1,(SEL1(_position)+_dy*cos _dir)];
		};
		_position set [2,(SEL2(_position)+_dz)];
		_tdx=_tdx+_dx;
		_tdy=_tdy+_dy;
		_tdz=_tdz+_dz;

		BuildHelper setDir (getDir BuildHelper);
		BuildHelper setPosASL _position;
		_position=getPosATL BuildHelper;
		if((_isAllowedUnderGround==0)&&(SEL2(_position)<0))then{_position set [2,0]};
		BuildHelper setPosATL _position;

		//diag_log format["DEBUG Change BUILDING POS: %1",_position];

		if(!helperDetach)then{BuildHelper attachTo [player]};
		DZE_BuildVector=[BuildHelper,[DZE_memForBack,DZE_memLeftRight,DZE_memDir]] call build_setPitchBankYaw;
		_dx=0;_dy=0;_dz=0;
	};

	sleep 0.5;

	_location2=getPosATL player;
	_objectHelperPos=getPosATL BuildHelper;

	if(DZE_SET)exitWith{
		helperDetach=false;
		_isOk=false;
		detach _object;
		_dir=getDir _object;
		_vector=[(vectorDir _object),(vectorUp _object)];
		_position=getPosATL _object;
		//diag_log format["DEBUG BUILDING POS: %1", _position];
		[false]call _remove_build;
	};

	if(_location1 distance _location2>10)exitWith{
		_isOk=false;
		_cancel=true;
		_reason="You've moved to far away from where you started building (within 10 meters)";
		[true]call _remove_build;
	};
/*
	if(_location1 distance _objectHelperPos>10)exitWith{
		_isOk=false;
		_cancel=true;
		_reason="Object is placed to far away from where you started building (within 10 meters)";
		[true]call _remove_build;
	};
*/
	if(abs(_tdx)>10||abs(_tdy)>10||abs(_tdz)>10)exitWith{
		_isOk=false;
		_cancel=true;
		_reason="Cannot move more than 10 meters";
		[true]call _remove_build;
	};

	if(player getVariable["combattimeout",0]>=time)exitWith{
		_isOk=false;
		_cancel=true;
		_reason=(localize "str_epoch_player_43");
		[true]call _remove_build;
	};

	if (DZE_cancelBuilding)exitWith{
		_isOk=false;
		_cancel=true;
		_reason="Cancelled building.";
		[true]call _remove_build;
	};
	if(DZE_Loading&&!_isnew)then{
		if([_object]call vehicle_loadingToTrack)then{
			detach BuildHelper;deleteVehicle BuildHelper;
			{deleteVehicle _x;}count _PAD_Marks;
			_isOk=false;
		}else{
			DZE_Loading=false;
		};
	};
};

{player removeAction _x}count s_build_act;

if(DZE_Loading)exitWith{BuildMode=false;DZE_ActionInProgress=false};

if(_cancel)exitWith{
	BuildMode=false;DZE_ActionInProgress=false;
	cutText [format[(localize "str_epoch_player_47"),_text,_reason],"PLAIN DOWN"];
};
//No building on roads unless toggled
if (!DZE_BuildOnRoads&&!DZE_Loading)then{
	if (isOnRoad _position)then{_cancel=true;_reason="Cannot build on a road."};
};

if!([_classname,_location1,false] call build_checkCanBuild)exitWith{BuildMode=false;DZE_ActionInProgress=false};

// Get position based on object
_location = _position;
if((_isAllowedUnderGround==0) && (SEL2(_location)<0))then{_location set [2,0]};

if(_isnew)then{
	_classname = _classnametmp;
	// Start Build
	_tmpbuilt=createVehicle [_classname,_location,[],0,"CAN_COLLIDE"];
	_tmpbuilt setdir _dir;
	_tmpbuilt setVectorDirAndUp _vector;
	_tmpbuilt setPosATL _location;
	cutText [format[(localize "str_epoch_player_138"),_text],"PLAIN DOWN"];
}else{
	_tmpbuilt=_object;
};
_limit=3;
if (DZE_StaticConstructionCount>0)then{
	_limit=DZE_StaticConstructionCount;
}else{
	if(isNumber (configFile >> "CfgVehicles" >> _classname >> "constructioncount"))then{
		_limit = getNumber(configFile >> "CfgVehicles" >> _classname >> "constructioncount");
	};
};

_isOk=true;_proceed=false;_counter=0;

while{_isOk}do{
	[10,10] call dayz_HungerThirst;
	[player,"repair",0,false,20] call dayz_zombieSpeak;
	[player,20,true,(getPosATL player)] spawn player_alertZombies;

	ANIMATION_MEDIC(true);

	if(!_finished)exitWith{_isOk=false;_proceed=false};
	_counter=_counter+1;
	cutText [format[(localize "str_epoch_player_139"),_text, _counter,_limit],"PLAIN DOWN"];
	if(_counter==_limit)exitWith{_isOk=false;_proceed=true};
};

if(_proceed)then{
	if(_removed call player_checkAndRemoveItems)then{
		cutText [format[localize "str_build_01",_text],"PLAIN DOWN"];

		if(_isPole)then{[] spawn player_plotPreview};

		SETVARS(_tmpbuilt,OEMPos,_location);
		SETVARS(_tmpbuilt,BuildMove,true);

		if (_isnew)then{
			if(_lockable>1)then{
				_combinationDisplay="";
				_combination_1=floor(random 10);
				_combination_2=floor(random 10);
				_combination_3=floor(random 10);
				_combination_4=floor(random 10);

				switch (_lockable) do {
					case 2: { // 2 lockbox
						_combinationDisplay=format["%1%2%3",["Red","Green","Blue"] select (floor(random 3)),_combination_2,_combination_3];
						// 100=red,101=green,102=blue
						_combination=format["%1%2%3",_combination_1+100,_combination_2,_combination_3];
						dayz_combination=_combination;
					};

					case 3: { // 3 combolock
						_combination=format["%1%2%3",_combination_1,_combination_2,_combination_3];
						dayz_combination=_combination;
						_combinationDisplay=_combination;
					};

					case 4: { // 4 safe
						_combination=format["%1%2%3%4",_combination_1,_combination_2,_combination_3,_combination_4];
						dayz_combination=_combination;
						_combinationDisplay=_combination;
					};
				};

				SetCharID(_tmpbuilt,_combination);
				SetOwnerUID(_tmpbuilt,_playerUID);
				SetOwnerName(_tmpbuilt,(name player));
				PVDZE_obj_Publish=[_combination,_tmpbuilt,[_dir,_location,_vector],_classname,_playerUID,-1];
				publicVariableServer "PVDZE_obj_Publish";

				cutText [format[(localize "str_epoch_player_140"),_combinationDisplay,_text], "PLAIN DOWN", 5];
			}else{
				SetCharID(_tmpbuilt,dayz_characterID);
				SetOwnerUID(_tmpbuilt,_playerUID);
				_tmpbuilt setVariable ["OwnerName",name player,true];

				// fire?
				if(_tmpbuilt isKindOf "Land_Fire_DZ")then{
					_tmpbuilt spawn player_fireMonitor;
				}else{
					PVDZE_obj_Publish=[dayz_characterID,_tmpbuilt,[_dir,_location,_vector],_classname,_playerUID,-1];
					publicVariableServer "PVDZE_obj_Publish";
				};
			};
			if(_classname=="HeliHRescue")then{
				PVDZE_EvacChopperFieldsUpdate=["add",_tmpbuilt];
				publicVariableServer "PVDZE_EvacChopperFieldsUpdate";
			};
		}else{
			[_tmpbuilt,"buildmove",[_dir,_location,_vector]] call fnc_serverUpdateObject;
		};
		if(_ShowPad)then{[player,"editpad"] spawn fnc_GarageOpenNearest;};
	}else{
		if(_isnew)then{
			deleteVehicle _tmpbuilt;
			{deleteVehicle _x;}count _PAD_Marks;
			cutText [(localize "str_epoch_player_46"),"PLAIN DOWN"];
		};
	};
}else{
	if(_isnew)then{
		deleteVehicle _tmpbuilt;
		{deleteVehicle _x;}count _PAD_Marks;
		cutText [(localize "str_epoch_player_46"),"PLAIN DOWN"];
	}else{call _restore_object};
};

helperDetach=false;
BuildMode=false;
DZE_ActionInProgress=false;
