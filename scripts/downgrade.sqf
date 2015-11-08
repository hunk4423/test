/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
//[0] execVM "scripts\origins\downgrade.sqf";

private ["_wp","_started","_finished","_part","_vehicle","_upgrade","_animState","_isCraft","_status","_loot","_item","_pos"];
player removeAction s_player_removeUpg;s_player_removeUpg = -1;

if (vehicle player != player)exitWith{cutText["Нельзя крафтить в технике!","PLAIN DOWN"]};
_wp=weapons player;
if !(["ItemSledge","ItemCrowbar","ItemToolbox"] call build_checkRequreItems)exitWith{};
CheckActionInProgress(MSG_BUSY);
call s_player_removeActionsLock;

if (player distance VehToDowngrade > 10)exitWith{BreakActionInProgress("Техника слишком далеко."); VehToDowngrade = nil;};

_part=THIS0;
_vehicle=VehToDowngrade;
VehToDowngrade=nil;

if !(typeOF _vehicle in OriUpgVeh)exitWith{BreakActionInProgress("Эту технику невозможно армировать.")};
_status=_vehicle getVariable ["Upgrade",[0,0,0,0]];;
EXPLODE4(_status,_upgrade0,_upgrade1,_upgrade2,_upgrade3);

switch (_part) do {
	case 0 : {cutText ["Начинаю снимать армирование переднего и заднего бампера, двигайтесь для отмены.", "PLAIN DOWN"];};
	case 1 : {cutText ["Начинаю снимать армирование колес, двигайтесь для отмены.", "PLAIN DOWN"];};
	case 2 : {cutText ["Начинаю снимать армирование боковых стекол, двигайтесь для отмены.", "PLAIN DOWN"];};
	case 3 : {cutText ["Начинаю снимать армирование передних и задних стекол, двигайтесь для отмены.", "PLAIN DOWN"];};
};
	
[player,"repair",0,false,10] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;
ANIMATION_MEDIC(false);

if (_finished) then {
	_upgrade=_vehicle getVariable ["Upgrade",[0,0,0,0]];

	switch (_part) do {
		case 0 : {_upgrade set[0,0];_vehicle animate ["pluhPredni", 1];};
		case 1 : {_upgrade set[1,0];_vehicle animate ["kolaOchrana", 1];};
		case 2 : {_upgrade set[2,0];_vehicle animate ["oknaOchrana", 1];};
		case 3 : {_upgrade set[3,0];_vehicle animate ["predniOknoOchrana", 1];};
	};

	PVDZE_Ori_upgrade=[_vehicle,_upgrade,true];
	publicVariableServer "PVDZE_Ori_upgrade";
	
	_pos=position player;
	_loot=["ItemPole","PartGeneric","ItemPole","PartGeneric","ItemCorrugated"];
	_item = createVehicle ["WeaponHolder",_pos,[],1,"CAN_COLLIDE"];
	_item addMagazineCargoGlobal [(_loot call BIS_fnc_selectRandom),1];
	_item addMagazineCargoGlobal [(_loot call BIS_fnc_selectRandom),1];
	_item setposATL _pos;
	player reveal _item;
	player action ["Gear",_item];
	
	cutText ["Снятие армирования завершено успешно!", "PLAIN DOWN"];
};

DZE_ActionInProgress = false;