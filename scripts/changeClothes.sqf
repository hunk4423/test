/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT4(_unittype,_skin,_myRealModel,_itemToDel);
if(DZE_ActionInProgress) exitWith {cutText ["Действие отменено.", "PLAIN DOWN"];};
if (THIS0<0) exitWith {titleText ["Скин для переодевания не выбран.", "PLAIN DOWN", 0.5];};
_unittype = SEL(Men_Clothing,THIS0);
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
if (inSafezone) exitWith { titleText ["Нельзя менять скин в сейфзоне.", "PLAIN DOWN", 0.5];};
if (!isNull (unitBackpack player)) exitWith {titleText ["Сумка мешает переодеванию, но не стоит сбрасывать ее на землю!", "PLAIN DOWN", 1];};
if (vehicle player != player) exitWith {cutText [(localize "str_epoch_player_85"), "PLAIN DOWN"]};

DZE_ActionInProgress = true;

_skin=(typeOf player) call fnc_GetSkinInfoByModel;
if (CNT(_skin)>0)then{
	_myRealModel=SEL1(_skin);
}else{
	_myRealModel="Skin_Survivor2_DZ";
};

_skin=_unittype call fnc_GetSkinInfoByModel;
if (CNT(_skin)>0)then{
	_itemToDel=SEL1(_skin);
}else{
	_itemToDel=_unittype;
};

if([_itemToDel] call player_checkAndRemoveItems)then{
	CloseDialog 0;
	CloseDialog 1;
	(findDisplay 106) closeDisplay 1;
	[dayz_playerUID,dayz_characterID,_unittype] spawn player_humanityMorph;
	player addMagazine _myRealModel;
};
DZE_ActionInProgress = false;