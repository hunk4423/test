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
_removed=[["Skin_Survivor2_DZ",1]];
while {true}do{
	if (r_player_unconscious)exitWith{titleText ["Действие отменено.", "PLAIN DOWN", 0.5]};
	_WorkBench=[player,3] call fnc_getNearWorkBench;
	if (!isNull _WorkBench)then{UpdateAccess(_WorkBench)};
	if !(_removed call player_checkItems)exitWith{cutText ["Для создания необходим скин Civilian clothing","PLAIN DOWN"]};
	if !(("ItemToolbox" in items player)&&("ItemKnife" in items player))exitWith{cutText [format["Необходимы Инструменты и Охотничий нож"],"PLAIN DOWN"]};
	if (InVeh(player))exitWith{cutText [format["Нельзя крафтить в технике!"],"PLAIN DOWN"]};
	if (dayz_combat==1)exitwith{cutText [format["В бою нельзя крафтить!"],"PLAIN DOWN"]};
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,15,true,(getPosATL player)] spawn player_alertZombies;
	ANIMATION_MEDIC(true);
	if (!_finished)exitwith{};
	if !(_removed call player_checkAndRemoveItems)exitWith{cutText [[_removed] call fnc_getMissingMessage,"PLAIN DOWN"]};
	player addMagazine "ItemCanvas";
	cutText [format["Создал 1 Canvas"], "PLAIN DOWN"];
	sleep 2;
};
DZE_ActionInProgress=false;
