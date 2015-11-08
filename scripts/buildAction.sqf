/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_item","_class","_removed"];
_item=_this select 3;
_class=typeOf _item;
player removeAction s_player_move_build;s_player_move_build = -1;
_removed=["PartGeneric"]; 
if (_class isKindOf "ModularItems")then{
	if (_class isKindOf "Land_DZE_WoodDoor_Base")exitWith{_removed=["PartWoodLumber","PartWoodPlywood"]};
	if (_class isKindOf "CinderWallDoor_DZ_Base")exitWith{_removed=["MortarBucket","CinderBlocks"]};
	if (["wood",_class] call fnc_inString)exitWith{_removed=["PartWoodLumber"]};
	if (["metal",_class] call fnc_inString)exitWith{_removed=["ItemPole"]};
	if (["cinder",_class] call fnc_inString)exitWith{_removed=["MortarBucket"]};
};
[_item,_removed,"move"] call player_build;
