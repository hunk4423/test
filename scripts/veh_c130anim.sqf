/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_array","_vehicle"];
_array=_this select 3;
if (s_actionC130)then{call s_player_removeActionsC130};
_vehicle = vehicle player;
if (_vehicle isKindOf "C130J_base") then {
	[_vehicle,_array select 0,_array select 1]call c130_anim;
};