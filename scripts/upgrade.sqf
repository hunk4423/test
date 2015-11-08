/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
//[0] execVM "scripts\origins\upgrade.sqf";
private ["_wp","_mp","_vehicle","_part","_status","_upgrade","_itembook","_animState","_started","_finished","_isCraft"];
(findDisplay 106) closeDisplay 1;
waitUntil {isNull (FindDisplay 106)};
_wp=weapons player;
_mp=magazines player;
if (vehicle player != player)exitWith{cutText["Нельзя крафтить в технике!", "PLAIN DOWN"]};
if !(["ItemSledge","ItemCrowbar","ItemToolbox"] call build_checkRequreItems)exitWith{};
if !(("ItemPole" in _mp)&&("PartGeneric" in _mp)&&("ItemCorrugated" in _mp))exitWith{cutText ["Для армирования необходимо: 2 гофрированных забора, 2 запчасти, 2 трубы.", "PLAIN DOWN"]};
CheckActionInProgressLocalize(str_epoch_player_63);
call s_player_removeActionsLock;

if(
	{
		if(alive _x && (count (crew _x)) == 0)exitWith{
			_vehicle=_x;
			1
		};
		0
	} count nearestObjects [player, ["LandVehicle"], 10] == 0
)exitWith{BreakActionInProgress("Техника не найдена.");};

if (local _vehicle && !(_vehicle call dze_isnearest_player)) then {
	if !(typeOf _vehicle in OriUpgVeh) exitWith {cutText ["Эту технику невозможно армировать.", "PLAIN DOWN"];};
	_part=THIS0;
	_status=_vehicle getVariable ["Upgrade",[0,0,0,0]];;
	EXPLODE4(_status,_upgrade0,_upgrade1,_upgrade2,_upgrade3);
	if ((_part == 0)&&(_upgrade0 == 1)) exitWith {cutText ["Передний и задний бампер армирован.", "PLAIN DOWN"];};
	if ((_part == 1)&&(_upgrade1 == 1)) exitWith {cutText ["Колеса армированы.", "PLAIN DOWN"];};
	if ((_part == 2)&&(_upgrade2 == 1)) exitWith {cutText ["Боковые стекла армированы.", "PLAIN DOWN"];};
	if ((_part == 3)&&(_upgrade3 == 1)) exitWith {cutText ["Передние и задние стекла армированы.", "PLAIN DOWN"];};
	
	switch (_part) do {
		case 0 : {cutText ["Начинаю армировать передний и задний бампер, двигайтесь для отмены.", "PLAIN DOWN"];_itembook = "ItemORP";};
		case 1 : {cutText ["Начинаю армировать колеса, двигайтесь для отмены.", "PLAIN DOWN"];_itembook = "ItemAVE";};
		case 2 : {cutText ["Начинаю армировать боковые стекла, двигайтесь для отмены.", "PLAIN DOWN"];_itembook = "ItemLRK";};
		case 3 : {cutText ["Начинаю армировать передние и задние стекла, двигайтесь для отмены.", "PLAIN DOWN"];_itembook = "ItemTNK";};
	};
	
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,10,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(false);

	if (_finished) then {
		//remove loot
		if ([["ItemPole",2],["PartGeneric",2],["ItemCorrugated",2],[_itembook,1]] call player_checkAndRemoveItems) then {
			_upgrade=_vehicle getVariable ["Upgrade",[0,0,0,0]];
			switch (_part) do {
				case 0 : {_upgrade set[0,1];_vehicle animate ["pluhPredni", 0];};
				case 1 : {_upgrade set[1,1];_vehicle animate ["kolaOchrana", 0];};
				case 2 : {_upgrade set[2,1];_vehicle animate ["oknaOchrana", 0];};
				case 3 : {_upgrade set[3,1];_vehicle animate ["predniOknoOchrana", 0];};
			};
			PVDZE_Ori_upgrade=[_vehicle,_upgrade,true];
			publicVariableServer "PVDZE_Ori_upgrade";			
			cutText ["Армирование завершено успешно!", "PLAIN DOWN"];					
		} else {
			cutText ["Для армирования необходимо: 2 гофрированных забора, 2 запчасти, 2 трубы.", "PLAIN DOWN"];
		};
	};	
} else {
	cutText [(localize "str_epoch_player_245"), "PLAIN DOWN"];
};				
DZE_ActionInProgress = false;