/*
	GoldKey

	F507DMT aka ����� �.�. 
	BlackGoga aka ������� �.�.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private "_vehicle";
_vehicle=s_player_lastSub;
call s_player_removeActionsSub;
if (isNull _vehicle)exitWith{};
_vehicle animate ["sink",(_this select 3)];