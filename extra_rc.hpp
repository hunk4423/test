/*
	GoldKey
	Файл классов

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/

class ExtraRc {
	class bulk_empty {
		class bulk_empty {
			text = "Запаковать:Мешки с песком";
			script = "[] execVM 'scripts\bulk_ItemSandbag.sqf'";
		};
	};	
	class ItemBloodbag {
		class ItemBloodbag {
			text = "Самозаливка крови";
			script = "'ItemBloodbag' spawn player_useMeds;";
		};
	};
	
	class PartGeneric {
		class ItemTankTrap {
			text = "Создать:Противотанк.ёж";
			script = "['ItemTankTrap'] execVM 'scripts\ItemCraft.sqf'";
		};		
		class ItemWire {
			text = "Создать:Колюч.проволока";
			script = "['ItemWire'] execVM 'scripts\ItemCraft.sqf'";
		};
	};
	
	class ItemPole {
		class ItemTankTrap {
			text = "Создать:Противотанк.ёж";
			script = "['ItemTankTrap'] execVM 'scripts\ItemCraft.sqf'";
		};		
		class ItemWire {
			text = "Создать:Колюч.проволока";
			script = "['ItemWire'] execVM 'scripts\ItemCraft.sqf'";
		};
	};
	
	class PartOreGold {
		class PartOreGold {
			text = "Переплавить";
			script = "['oregold'] execVM 'scripts\melting.sqf'";
		};
	};

	class PartOreSilver {
		class PartOreSilver {
			text = "Переплавить";
			script = "['oresilver'] execVM 'scripts\melting.sqf'";
		};
	};

	class PartOre {
		class PartOre {
			text = "Переплавить";
			script = "['oreiron'] execVM 'scripts\melting.sqf'";
		};
	};
	class ItemRadio {
		class GroupManagement {
			text = "Управление группой";
			script = "[] execVM 'scripts\loadGroupManagement.sqf'";
		};
		class Garage {text="Открыть гараж";script="closeDialog 0;[player,'store'] spawn fnc_GarageOpenNearest";};
		class JEAM {
			text = "Вызвать вертолет";
			script = "execVM 'scripts\CallEvacChopper.sqf'";
		};
		class call_trade {
			text = "Вызвать торговца";
			script = "execVM 'scripts\call_trader_init.sqf'";
		};    
		class lokatorAI {
			text = "Локатор ботов";
			script = "execVM 'scripts\ai_locator.sqf'";
		};
	};

	class ItemSodaSmasht {
		class changeKey {
			text = "Актив. смену ключей";
			script = "execVM 'scripts\VehicleKeyChanger_init.sqf'";
		};
	};

	class ItemNewspaper {
		class ItemNewspaper {
			text = "Читать газету";
			script = "execVM 'scripts\gazeta.sqf'";
		};
	};	
	
	class 30m_plot_kit {
		class CraftGarage {
			text = "Построить гараж";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\30mPlot.sqf""";
		};		
		class CraftPad {
			text = "Вертолётные площадки";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\30mPlot.sqf""";
		};
	};

	class ItemLetter {
		class ItemLetter {
			text = "Найти машину";
			script = "execVM 'scripts\gazeta_noob.sqf'";
		};
	};

	class ItemEpinephrine{
		class ItemEpinephrine {
			text = "Принять";
			script = "execVM 'scripts\color_epi_use.sqf'";
		};
	};

	class ItemKiloHemp {
		class ItemKiloHemp {
			text = "Скурить";
			script = "execVM 'scripts\ItemKiloHemp.sqf'";
		};
	};

	class AKS_GOLD {
		class AKS_GOLD {
			text = "Переплавить в золото";
			script = "execVM 'scripts\akm_gold.sqf'";
		};
	};
	class revolver_gold_EP1 {
		class revolver_gold_EP1 {
			text = "Переплавить в золото";
			script = "execVM 'scripts\rev_gold.sqf'";
		};
	};

	class ItemToolbox {
		class removeTrees {
			text = "Разобрать доп.крафт";
			script = "closeDialog 0;call player_removeTrees";
		};		
		class DeployBike {
			text = "Собрать велосипед";
			script = "execVM 'scripts\bike_deploy.sqf'";
		};
	};
/*
	class PartWoodPile {
		class actWoodPile {
			text = "Наложить шину";
			script = "closeDialog 0;[player] execVM 'scripts\player_SplintWound.sqf'";
		};
	};	
	
	class ItemBandage {
		class actItemBandage {
			text = "Наложить шину";
			script = "closeDialog 0;[player] execVM 'scripts\player_SplintWound.sqf'";
		};
	};
*/
	class ItemMap {
		class VDistanceM {
			text = "Дальность прорисовки";
			script = "execVM 'scripts\view_distance.sqf'";
		};
		class travaM {
			text = "Качество травы";
			script = "execVM 'scripts\change_terrain.sqf'";
		};
		class locateM {
			text = "Найти технику";
			script = "execVM 'scripts\locate_vehicle.sqf'";
		};
		class save_vehM {
			text = "Сохранить технику";
			script = "execVM 'scripts\save_vehicle.sqf'";
		};
		class Map_ShowMyBodys {
			text = "Показать мои трупы";
			script = "execVM 'scripts\showmybodys.sqf'";
		};
	};

	class ItemGPS {
		class VDistanceGPS {
			text = "Дальность прорисовки";
			script = "execVM 'scripts\view_distance.sqf'";
		};
		class travaGPS {
			text = "Качество травы";
			script = "execVM 'scripts\change_terrain.sqf'";
		};
		class locateGPS {
			text = "Найти технику";
			script = "execVM 'scripts\locate_vehicle.sqf'";
		};
		class save_vehGPS {
			text = "Сохранить технику";
			script = "execVM 'scripts\save_vehicle.sqf'";
		};
		class GPS_ShowMyBodys {
			text = "Показать мои трупы";
			script = "execVM 'scripts\showmybodys.sqf'";
		};
	};

	class ItemSandbag {
		class sement {
			text = "Создать: CinderBlocks";
			script = "execVM 'scripts\CinderBlocks.sqf'";
		};
	};

	class MortarBucket {
		class pesok {
			text = "Создать: CinderBlocks";
			script = "execVM 'scripts\CinderBlocks.sqf'";
		};
	};	
	
	class ItemSledge {
		class chekCountObj {
			text = "Количество объектов";
			script = "execVM 'scripts\chek_count_obj.sqf'";
		};
		class EditPad {text="Настроить площадку";script="closeDialog 0;[player,'editpad'] spawn fnc_GarageOpenNearest";};
		class MovePad {text="Переместить площадку";script="closeDialog 0;[player,'movepad'] spawn fnc_GarageOpenNearest";};
		class ShowPad {text="Отобразить площадки";script="closeDialog 0;[player,'show'] spawn fnc_GarageOpenNearest";};
		class DelPad {text="Удалить площадку";script="closeDialog 0;[player,'deletepad'] spawn fnc_GarageOpenNearest";};
	};

	class ItemAmethyst {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Amethyst.sqf""";
		};
	};
	class ItemCitrine {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Citrine.sqf""";
		};
	};
	class ItemEmerald {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Emerald.sqf""";
		};
	};
	class ItemObsidian {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Obsidian.sqf""";
		};
	};
	class ItemRuby {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Ruby.sqf""";
		};
	};
	class ItemSapphire {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Sapphire.sqf""";
		};
	};
	class ItemTopaz {
		class Start_Crafting {
			text = "Начать крафт!";
			script = "closeDialog 0;createDialog ""Advanced_Crafting"";execVM ""scripts\Topaz.sqf""";
		};
	};

	class ItemZombieParts {
		class zsh {
			text = "Обмазаться кишками";
			script = "[] execVM ""scripts\smear_guts.sqf"";";
		};
	};

	class ItemWaterbottle {
		class zsh {
			text = "Смыть кишки зомби";
			script = "[] execVM ""scripts\usebottle.sqf"";";
		};
	};

	class ItemWaterbottleBoiled {
		class zsh {
			text = "Смыть кишки зомби";
			script = "[] execVM ""scripts\usebottle.sqf"";";
		};
	};
	
	class ItemSodaMzly {
		class me_tp {
			text = "Меня к машине";
			script = "['MeToCar'] execVM 'scripts\tp_veh.sqf'";
		};
		class tp_to_me {
			text = "Машину ко мне";
			script = "['CarToMe'] execVM 'scripts\tp_veh.sqf'";
		};
		class saymecharid {
			text = "Скажи мне CharID";
			script = "['CharID'] execVM 'scripts\tp_veh.sqf'";
		};
	};
#include "local_rc.hpp"
};