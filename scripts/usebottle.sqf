/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_txt","_item","_hastinitem"];

if (dayz_combat == 1) exitWith {
	_txt = "Нельзя использовать во время боя.";
	cutText [_txt, "PLAIN DOWN"];
};

if (isNil "hasGutsOnHim") then {hasGutsOnHim = false;};
if (!hasGutsOnHim) exitWith {
	_txt = "Смывать нечего.";
	cutText [_txt, "PLAIN DOWN"];
};

// If we're not swimming, let's start the animation to have the player squat
if (!dayz_isSwimming) then {
	player playActionNow "Medic";
};

_hastinitem = false;
{
	if (_x in magazines player) then {
		_hastinitem = true;
		_item = _x;
	};
} count ["ItemWaterbottle","ItemWaterbottleBoiled"];

if !(_hastinitem) exitWith {cutText ["Нужна Фляжка с водой!", "PLAIN DOWN"]};

if ([[_item, 1]] call player_checkAndRemoveItems) then {
	sleep 1;
	[player,"fillwater",0,false,5] call dayz_zombieSpeak;
	[player,5,true,(getPosATL player)] spawn player_alertZombies;
	player addMagazine "ItemWaterbottleUnfilled";

	sand_washed = true;
	hasGutsOnHim = false;

	detach soundFly;
	deletevehicle soundFly;
} else {cutText ["Ошибка", "PLAIN DOWN"];};

cutText ["О, да! Свежий воздух! Наконец я смыл это с себя!", "PLAIN DOWN"];	
