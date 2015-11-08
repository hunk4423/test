/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/

(findDisplay 106) closeDisplay 1;
waitUntil { isNull (FindDisplay 106) };

_EXECscript1 = '["%1"] execVM "scripts\call_trader.sqf"';
	 
trade_bot_menu =
[
	["",true],
		["Цена вызова: 15,000р.", [], "", -5, [["expression", ""]], "1", "0"],
		["Торговец оружием", [],  "", -5, [["expression", 	format[_EXECscript1,"weapon"]]], "1", "1"],
		["Торговец разным", [],  "", -5, [["expression", 	format[_EXECscript1,"other"]]], "1", "1"],
		["Доктор", [],  "", -5, [["expression", 			format[_EXECscript1,"medic"]]], "1", "1"],
		["Девушку", [],  "", -5, [["expression", 			format[_EXECscript1,"gerl"]]], "1", "1"],
		["", [], "", -5, [["expression", ""]], "1", "0"],
		["Выход", [], "", -5, [["expression", ""]], "1", "1"]
];
showCommandingMenu "#USER:trade_bot_menu";
