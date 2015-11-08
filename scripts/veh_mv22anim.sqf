/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_array","_vehicle"];
_array=_this select 3;
if (s_actionMV22)then{call s_player_removeActionsMV22};
_vehicle = vehicle player;
if (_vehicle isKindOf "MV22_DZ") then {
	[_vehicle,_array select 0,_array select 1] call mv22_anim;
};