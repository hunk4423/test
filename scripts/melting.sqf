/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_action","_removed","_added","_upd","_waters","_hastinitem","_itemWater","_finished","_animState","_isMedic","_started","_item","_cnt","_flamed","_ok"];

PARAMS1(_action);
_started=true;
switch (_action)do{
	case "oregold": {_removed=[["PartOreGold",2]];_added=[["ItemGoldBar",2]]};
	case "oreiron": {_removed=[["PartOre",3]];_added=[["PartGeneric",1]]};
	case "oresilver": {_removed=[["PartOreSilver",2]];_added=[["ItemBriefcaseS100oz",1]]};
	default {_started=false};
};
if (!_started)exitWith{cutText ["Неизвестная команда для переплавки","PLAIN DOWN"]};

_upd=false;
_waters=["ItemWaterbottle","ItemWaterbottleBoiled","ItemWaterbottle1oz","ItemWaterbottle2oz","ItemWaterbottle3oz","ItemWaterbottle4oz","ItemWaterbottle5oz","ItemWaterbottle6oz","ItemWaterbottle7oz","ItemWaterbottle8oz","ItemWaterbottle9oz"];
CheckActionInProgressLocalize(str_epoch_player_63);
while {true}do{
	_flamed=[player,3] call fnc_getNearInFlame;
	if (!isNull _flamed && !_upd)then{_upd=true;UpdateAccess(_flamed)};
	if(isNull _flamed)exitWith{cutText ["Нужен рабочий источник огня в пределах 3-х метров.","PLAIN DOWN"]};
	if!(_removed call player_checkItems)exitWith{cutText [[_removed] call fnc_getMissingMessage,"PLAIN DOWN"]};
	if(dayz_combat==1)exitwith{cutText ["В бою нельзя крафтить!","PLAIN DOWN"]};
	if(InVeh(player))exitWith{cutText ["Нельзя крафтить в технике!","PLAIN DOWN"]};
	if!("ItemToolbox" in items player)exitWith{cutText ["Необходимы Инструменты","PLAIN DOWN"]};
	if!(("ItemSledge" in items player)or("MeleeSledge" in weapons player))exitWith{cutText ["Необходима Кувалда","PLAIN DOWN"]};
	if!("TrashTinCan" in magazines player)exitWith{cutText ["Нужна консервная банка","PLAIN DOWN"]};

	_hastinitem=false;
	{if (_x in magazines player)exitWith{_hastinitem=true}}count _waters;
	if !(_hastinitem)exitWith{cutText ["Необходима Фляжка с водой","PLAIN DOWN"]};

	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,10,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(true);
	if(!_finished)exitWith{};	
	_hastinitem=false;
	{
		if (_x in magazines player)exitWith{
			_hastinitem=true;
			_itemWater=_x;
		};
	} count _waters;
	if !(_hastinitem)exitWith{cutText ["Необходима Фляжка с водой","PLAIN DOWN"]};
	if !(_removed call player_checkAndRemoveItems)exitWith{cutText [[_removed] call fnc_getMissingMessage,"PLAIN DOWN"]};
	switch (_itemWater)do{
		case "ItemWaterbottle1oz" : {player removeMagazine "ItemWaterbottle1oz";player addMagazine "ItemWaterbottleUnfilled"};
		case "ItemWaterbottle2oz" : {player removeMagazine "ItemWaterbottle2oz";player addMagazine "ItemWaterbottle1oz"};
		case "ItemWaterbottle3oz" : {player removeMagazine "ItemWaterbottle3oz";player addMagazine "ItemWaterbottle2oz"};
		case "ItemWaterbottle4oz" : {player removeMagazine "ItemWaterbottle4oz";player addMagazine "ItemWaterbottle3oz"};
		case "ItemWaterbottle5oz" : {player removeMagazine "ItemWaterbottle5oz";player addMagazine "ItemWaterbottle4oz"};
		case "ItemWaterbottle6oz" : {player removeMagazine "ItemWaterbottle6oz";player addMagazine "ItemWaterbottle5oz"};
		case "ItemWaterbottle7oz" : {player removeMagazine "ItemWaterbottle7oz";player addMagazine "ItemWaterbottle6oz"};
		case "ItemWaterbottle8oz" : {player removeMagazine "ItemWaterbottle8oz";player addMagazine "ItemWaterbottle7oz"};
		case "ItemWaterbottle9oz" : {player removeMagazine "ItemWaterbottle9oz";player addMagazine "ItemWaterbottle8oz"};
		case "ItemWaterbottleBoiled":{player removeMagazine "ItemWaterbottleBoiled";player addMagazine "ItemWaterbottle9oz"};
		case "ItemWaterbottle"    : {player removeMagazine "ItemWaterbottle";player addMagazine "ItemWaterbottle9oz"};
	};
	{
		EXPLODE2(_x,_item,_cnt);
		for "_i" from 1 to _cnt do {[player,_item] call BIS_fnc_invAdd};
	}count _added;
	sleep 2;
};
DZE_ActionInProgress=false;