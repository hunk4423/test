/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz

*/
#include "defines.h"
private ["_zed","_killer","_kills","_array","_type","_humanity"];
EXPLODE2(_this,_array,_type);
EXPLODE2(_array,_zed,_killer);
if (local _zed)then{
	_kills=_killer getVariable[_type,0];
	_killer setVariable[_type,(_kills+ 1),true];
	
	_humanity=GetHumanity(_killer)+Z_HUMANITY;
	SetHumanity(_killer,_humanity);
};