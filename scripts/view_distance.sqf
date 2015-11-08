(findDisplay 106) closeDisplay 1;
waitUntil { isNull (FindDisplay 106) };
viewdistance_menu =
[
	["",false],
	[" 1 метр",     [2],  "", -5, [["expression", 			"setViewDistance 1;0 setfog 0.2;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 1 метр');"]], "1", "1"],
	[" 400 метров", [3],  "", -5, [["expression", 			"setViewDistance 400;0 setfog 0.2;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 400 метров');"]], "1", "1"],
	[" 800 метров", [4],  "", -5, [["expression", 			"setViewDistance 800;0 setfog 0.2;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 800 метров');"]], "1", "1"],
	["1000 метров", [5],  "", -5, [["expression", 			"setViewDistance 1000;0 setfog 0.18;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 1000 метров');"]], "1", "1"],
	["1250 метров", [6],  "", -5, [["expression", 			"setViewDistance 1250;0 setfog 0.17;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 1250 метров');"]], "1", "1"],
	["1400 метров(Стандарт)", [7],  "", -5, [["expression",	"setViewDistance 1400;0 setfog 0.15;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 1400 метров(Стандарт)');"]], "1", "1"],
	["2000 метров", [8],  "", -5, [["expression", 			"setViewDistance 2000;0 setfog 0.1;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 2000 метров'); systemChat('Внимание: Большие значения дальности прорисовки существенно сказываются на быстродействии игры');"]], "1", "1"],
	["3000 метров", [9],  "", -5, [["expression", 			"setViewDistance 3000;0 setfog 0;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 3000 метров'); systemChat('Внимание: Большие значения дальности прорисовки существенно сказываются на быстродействии игры');"]], "1", "1"],
	["5000 метров", [10],  "", -5, [["expression", 			"setViewDistance 5000;0 setfog 0;CustomViewDistance=true; systemChat('Дальность прорисовки установлена на: 5000 метров'); systemChat('Внимание: Большие значения дальности прорисовки существенно сказываются на быстродействии игры');"]], "1", "1"],
	
	["", [-1], "", -5, [["expression", ""]], "1", "0"],
	["Выход", [13], "", -5, [["expression", ""]], "1", "1"]
];

showCommandingMenu "#USER:viewdistance_menu";