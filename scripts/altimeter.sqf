/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_myalt"];
HaloAltimeter=1;
sleep 3;
_myalt = getPos player select 2;
_myalt = round(_myalt);
cutText ["\n\n Для открытия парашюта нажмите кнопку R", "PLAIN DOWN"];

while {(_myalt) > 0} do {
	_myalt = getPos player select 2;
	_myalt = round(_myalt);

	titleText [("Высота: " + str _myalt + ""), "PLAIN DOWN", 0.1];
	sleep 0.2;
};
HaloAltimeter=nil;