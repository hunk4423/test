/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/

_pos=_this select 0;
_mode=_this select 1;
_range=_this select 2;
_val="OFF";
if (_mode==1)then{_val="AUTO";};
{_x switchLight _val} forEach (_pos nearObjects ["Streetlamp",_range]);
