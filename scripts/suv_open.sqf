/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
_vehicle=s_player_lastSuv;
call s_player_removeActionsSuv;
if (isNull _vehicle)exitWith{};
[objNull,_vehicle,rSAY,"gdrazatvor",20] call RE;
[_vehicle,30,true,(getPosATL _vehicle)] spawn player_alertZombies;
_vehicle animate ["HideGun_01",0];
_vehicle animate ["CloseCover1",0];
_vehicle animate ["CloseCover2",0];