/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_removed","_finished","_animState","_isMedic","_started","_WorkBench","_upd","_waters","_haswater"];

CheckActionInProgressLocalize(str_epoch_player_63);
_upd=false;
_removed=[["ItemSandbag",1],["MortarBucket",1]];
_waters=["ItemWaterbottle","ItemWaterbottleBoiled"];
while {true}do{
	if (r_player_unconscious)exitWith{cutText ["Утомился я что-то!","PLAIN DOWN",0.5]};
	_WorkBench=[player,3] call fnc_getNearWorkBench;
	if (!isNull _WorkBench && !_upd)then{_upd=true;UpdateAccess(_WorkBench)};
	if (isNull _WorkBench)exitwith{cutText [format["Для создания требуется рабочий стол вблизи 3 метров"],"PLAIN DOWN"]};
	if !(_removed call player_checkItems)exitWith{cutText ["Для создания необходим Мешок с песком и Ведро цемента","PLAIN DOWN"]};
	_haswater=false;
	{if (_x in magazines player)exitWith{_removed set [CNT(_removed),[_x,1]];_haswater=true}}count _waters;
	if (!_haswater)exitWith{cutText [format["Необходима Фляжка с водой"],"PLAIN DOWN"]};
	if !(("ItemToolbox" in items player)&&("ItemEtool" in items player))exitWith{cutText [format["Необходимы Инструменты и Саперная лопатка"],"PLAIN DOWN"]};
	if (InVeh(player))exitWith{cutText [format["Нельзя крафтить в технике!"],"PLAIN DOWN"]};
	if (dayz_combat==1)exitWith{cutText [format["В бою нельзя крафтить!"],"PLAIN DOWN"]};
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,15,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(true);
	if (!_finished)exitwith{};
	if !(_removed call player_checkAndRemoveItems)exitWith{cutText [[_removed] call fnc_getMissingMessage,"PLAIN DOWN"]};
	player addMagazine "CinderBlocks";
	player addMagazine "ItemWaterbottleUnfilled";
	cutText [format["Создал 1 CinderBlocks"],"PLAIN DOWN"];
	sleep 2;
};
DZE_ActionInProgress=false;
