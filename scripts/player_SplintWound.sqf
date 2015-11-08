/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_started","_finished","_animState","_isMedic","_unit","_mp"];
disableserialization;
if(r_player_unconscious)exitWith{cutText["Действие отменено","PLAIN DOWN"];};
_unit=THIS0;
_mp=magazines player;
if!((((GETVAR(_unit,hit_legs,0))>=1)||((GETVAR(_unit,hit_hands,0))>=1))&&((GETVAR(_unit,SplintWound,0))<= 1))exitWith{cutText["Наложение шины не требуется.","PLAIN DOWN"];};
if!("PartWoodPile" in _mp)exitWith{cutText["Необходимы дрова для наложения шины.","PLAIN DOWN"];};
if!("ItemBandage" in _mp)exitWith{cutText["Необходим бинт для фиксации шины.","PLAIN DOWN"];};

[player,"bandage",0,false] call dayz_zombieSpeak;
call fnc_usec_medic_removeActions;
r_action = false;
(findDisplay 106)closeDisplay 1;

if(NotInVeh(player))then{
	ANIMATION_MEDIC(false);
}else{
	sleep 3;
	_finished=true;
};

if(_finished)then{
	(findDisplay 106)closeDisplay 1;
	if([["PartWoodPile",1],["ItemBandage",1]] call player_checkAndRemoveItems)then{
		if(_unit==player)then{
			["WoodPile"] call fnc_usec_SplintWound;
		}else{
			[player,10] call player_humanityChange;
			sleep 1;
			PVDZE_send=[_unit,"SplintWound",[_unit,player]];
			publicVariableServer "PVDZE_send";
		};
	}else{
		cutText["Необходимы дрова для наложения шины и бинт для ее фиксации.","PLAIN DOWN"];
	};
};