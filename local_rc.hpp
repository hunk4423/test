/*
	GoldKey
	Файл классов специфичный для сервера

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
class ItemORP {
	class ItemORP {
		text = "Армировать";
		script = "[0] execVM 'scripts\upgrade.sqf'";
	};
};
class ItemAVE {
	class ItemAVE {
		text = "Армировать";
		script = "[1] execVM 'scripts\upgrade.sqf'";
	};
};
class ItemLRK {
	class ItemLRK {
		text = "Армировать";
		script = "[2] execVM 'scripts\upgrade.sqf'";
	};
};
class ItemTNK {
	class ItemTNK {
		text = "Армировать";
		script = "[3] execVM 'scripts\upgrade.sqf'";
	};
};
class ItemHeatPack {
	class ItemHeatPack {
		text = "Использовать Грелку";
		script = "'ItemHeatPack' spawn player_useMeds;";
	};
};