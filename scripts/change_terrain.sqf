(findDisplay 106) closeDisplay 1;
waitUntil { isNull (FindDisplay 106) };
change_terrain =
[
	["",false],
		["Выберите качество:", [], "", -5, [["expression", ""]], "1", "0"],
		["Ультра",     [2],  "", -5, [["expression","setTerrainGrid 10; systemChat('Качество травы установлено на: Ультра');"]], "1", "1"],
		["Высоко", [3],  "", -5, [["expression","setTerrainGrid 25; systemChat('Качество травы установлено на: Высоко');"]], "1", "1"],
		["Стандарт", [4],  "", -5, [["expression","setTerrainGrid 40; systemChat('Качество травы установлено на: Стандарт');"]], "1", "1"],
		["Отключено", [5],  "", -5, [["expression","setTerrainGrid 50; systemChat('Качество травы установлено на: Отключено');"]], "1", "1"],

		["", [-1], "", -5, [["expression", ""]], "1", "0"],
		["Выход", [13], "", -5, [["expression", ""]], "1", "1"]
];

showCommandingMenu "#USER:change_terrain";