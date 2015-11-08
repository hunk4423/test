/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_weapon_player","_mags","_textWeap","_mag","_textMag"];
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions=[];s_player_GK_actions_ctrl=false;
if(hasGutsOnHim)exitWith{cutText ["Ну и запах! Я не хочу иметь с тобой никаких дел!", "PLAIN DOWN"];};

_weapon_player = currentWeapon player;
_mags = getArray (configFile >> "CfgWeapons" >> _weapon_player >> "magazines");
_textWeap =	getText(configFile >> "CfgWeapons" >> _weapon_player >> "displayName");

{
	_mag = _x;
	_textMag =	getText(configFile >> "CfgMagazines" >> _mag >> "displayName"); 
	systemChat format ["Оружие %1: Используется %2 (%3)",_textWeap,_textMag,_mag];
} forEach _mags;