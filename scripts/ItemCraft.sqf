/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_removed","_finished","_animState","_isMedic","_started","_WorkBench"];

CheckActionInProgressLocalize(str_epoch_player_63);
_item=THIS0;
_removed=[["PartGeneric",1],["ItemPole",1]];
while {true}do{
	_WorkBench=[player,3] call fnc_getNearWorkBench;
	if(!isNull _WorkBench)then{UpdateAccess(_WorkBench)};
	if(isNull _WorkBench)exitWith{BreakActionInProgress("Для создания требуется рабочий стол вблизи 3 метров")};
	if !(_removed call player_checkItems)exitWith{cutText ["Для создания необходимы Запчасти и Metal pole","PLAIN DOWN"]};
	if !(("ItemToolbox" in items player)&&("ItemSledge" in items player))exitWith{cutText["Необходимы Инструменты и Кувалда","PLAIN DOWN"]};
	if (InVeh(player))exitWith{cutText["Нельзя крафтить в технике!","PLAIN DOWN"]};
	if (dayz_combat==1)exitwith{cutText["В бою нельзя крафтить!","PLAIN DOWN"]};
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,15,true,(getPosATL player)] spawn player_alertZombies;
	cutText["Создание начато", "PLAIN DOWN"];
	ANIMATION_MEDIC(true);
	if (!_finished)exitwith{};
	if !(_removed call player_checkAndRemoveItems)exitWith{cutText [[_removed] call fnc_getMissingMessage,"PLAIN DOWN"]};
	player addMagazine _item;
	cutText [format["Создано: %1 х 1.",getText (configFile >> 'CfgMagazines' >> _item >> 'displayName')], "PLAIN DOWN"];
	sleep 2;
};
DZE_ActionInProgress=false;