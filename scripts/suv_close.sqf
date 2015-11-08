/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_unit","_vehicle"];
_vehicle=s_player_lastSuv;
call s_player_removeActionsSuv;
if (isNull _vehicle)exitWith{};
_unit = _vehicle turretUnit [0];
if (!(isNull _unit)) exitWith {
	titleText ["\n\n Турель занята игроком.","PLAIN DOWN"];titleFadeOut 4;
};

_nul = [objNull,_vehicle,rSAY,"gdrazatvor",20] call RE;
[_vehicle,30,true,(getPosATL _vehicle)] spawn player_alertZombies;
_vehicle animate ["HideGun_01",1];
sleep 1;
_vehicle animate ["CloseCover1",1];
_vehicle animate ["CloseCover2",1];




