/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_txt","_dis","_sfx"];

player removeAction s_player_cleanguts;
s_player_cleanguts = -1;

if (dayz_combat == 1) exitWith {
	_txt = "Нельзя использовать во время боя.";
	cutText [_txt, "PLAIN DOWN"];
};

// If we're not swimming, let's start the animation to have the player squat
if (!dayz_isSwimming) then {
	player playActionNow "Medic";
};

sleep 1;
_dis = 5;
_sfx = "fillwater";
[player,_sfx,0,false,_dis] call dayz_zombieSpeak;
[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
sand_washed = true;
hasGutsOnHim = false;
detach soundFly;
deletevehicle soundFly;
cutText ["О, да! Свежий воздух! Наконец я смыл это с себя!","PLAIN DOWN"];
