/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_inVehicle","_onLadder","_canDo","_uniqueid","_array","_hitpoints","_tvih","_selection","_finish_box","_gun_list","_Backpacks","_med_list","_food_list","_wather_list","_misc_list","_itemBar","_med","_food","_wather","_misc","_location","_name_veh","_messages","_object_bot","_finish_box","_veh","_x","_this","_invehicl","_started","_finished","_isRead","_animState"];
disableserialization;
call gear_ui_init;
_inVehicle = (vehicle player != player);
_onLadder =	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf && !r_player_unconscious && !_onLadder);
if (!_canDo) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
if !("ItemNewspaper" in magazines player) exitWith {cutText [format["Нужна газета!"], "PLAIN DOWN"]};
CheckActionInProgress(MSG_BUSY);

closeDialog 1;

[player,"document",0,false,20] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;

_finished = false;

if (_inVehicle) then {
	_finished = true;
	for "_i" from 1 to 6 do {
		if (GETPVAR(combattimeout,0)>=time)exitWith{_finished=false;};
		sleep 1;
	};
}else{
	ANIMATION_MEDIC(true);
};

if (_finished) then {
	_num_removed = ([player,"ItemNewspaper"] call BIS_fnc_invRemove);
	if!(_num_removed == 1) exitWith {BreakActionInProgress("Нужна газета!");}; 

	_location = [getMarkerPos "center", 0, 7000, 0, 0, 2000, 0] call BIS_fnc_findSafePos;
	_locationAI = [_location select 0, _location select 1, 1];

	//Сообщения
	_messages = [
		"Эти координаты - твой шанс! Спеши!",
		"Тебе выпал шанс! Не упусти!",
		"Координаты Удачи! Проверь! ",
		"Проверь координаты и ты Удачлив и богат!",
		"Интересные координаты... Стоит проверить!"
	] call BIS_fnc_selectRandom;

	//спавним бота
	_object_bot = createAgent ["Worker3", _locationAI, [], 0, "NONE"];	
	
	//сообщение игроку
	_map_coord = mapGridPosition getPos _object_bot;
	titleText [format["%1\n Запомни координату: %2",_messages,_map_coord], "PLAIN DOWN", 5];
	systemChat ("Запомни координату: " + _map_coord);
	playSound "pda";

	if (RND(40)) then {
		_finish_box = createVehicle ["WoodCrate_DZ", _object_bot, [], 0, "NONE"];
		sleep 3;
		//Списки
		_gun_list=[GUN_LIST];
		_Backpacks = ["DZ_Czech_Vest_Puch","DZ_Patrol_Pack_EP1","DZ_Assault_Pack_EP1","DZ_TerminalPack_EP1","DZ_ALICE_Pack_EP1","DZ_TK_Assault_Pack_EP1","DZ_CompactPack_EP1","DZ_British_ACU","DZ_GunBag_EP1","DZ_CivilBackpack_EP1","DZ_Backpack_EP1"] call BIS_fnc_selectRandom;
		_med_list = ["ItemAntibiotic","ItemBandage","ItemBloodbag","ItemEpinephrine","ItemHeatPack","ItemMorphine","ItemPainkiller","ItemTrashToiletpaper"];
		_food_list = ["FoodMRE","FoodCanPasta","FoodCanFrankBeans","FoodCanSardines","FoodCanBakedBeans","FoodPistachio","FoodNutmix","FoodPumpkin","FoodSunFlowerSeed"];
		_wather_list = ["ItemSodaPepsi","ItemSodaCoke","ItemWaterbottleUnfilled","ItemWaterbottle","ItemWaterbottleBoiled"];
		_misc_list = ["5Rnd_127x99_as50", "10Rnd_127x99_m107", "5Rnd_86x70_L115A1", "5Rnd_127x108_KSVK", "20Rnd_9x39_SP5_VSS", "20Rnd_762x51_DMR", "10Rnd_762x54_SVD", "20Rnd_762x51_B_SCAR", "20Rnd_762x51_SB_SCAR", "5Rnd_762x51_M24", "5x_22_LR_17_HMR", "30Rnd_556x45_Stanag", "30Rnd_556x45_StanagSD", "30Rnd_556x45_G36", "30Rnd_556x45_G36SD", "30Rnd_545x39_AK", "30Rnd_545x39_AKSD", "30Rnd_762x39_AK47", "30Rnd_762x39_SA58", "20Rnd_762x51_FNFAL", "100Rnd_762x51_M240", "100Rnd_762x54_PK", "200Rnd_556x45_M249", "100Rnd_556x45_M249", "100Rnd_556x45_BetaCMag", "75Rnd_545x39_RPK", "15Rnd_9x19_M9", "15Rnd_9x19_M9SD", "8Rnd_9x18_Makarov", "8Rnd_9x18_MakarovSD", "17Rnd_9x19_glock17", "6Rnd_45ACP", "7Rnd_45ACP_1911", "8Rnd_B_Saiga12_Pellets", "8Rnd_B_Saiga12_74Slug", "8Rnd_B_Beneli_Pellets", "8Rnd_B_Beneli_74Slug", "2Rnd_shotgun_74Pellets", "2Rnd_shotgun_74Slug", "15Rnd_W1866_Slug", "64Rnd_9x19_Bizon", "64Rnd_9x19_SD_Bizon", "30rnd_9x19_MP5", "30Rnd_9x19_MP5SD", "30Rnd_9x19_UZI", "30Rnd_9x19_UZI_SD", "20Rnd_B_765x17_Ball", "ItemZombieParts","ItemHeatpack","CinderBlocks", "HandRoadFlare", "HandChemBlue", "HandChemRed", "HandChemGreen","SmokeShell","TrashTinCan","TrashJackDaniels","ItemSodaEmpty", "ItemSodaRabbit","ItemWaterbottleUnfilled","ItemWaterbottleBoiled","ItemTrashToiletpaper","ItemJerrycan", "PartFueltank", "PartGlass","PartWoodPile","PartGeneric","PartPlywoodPack","PartPlywoodPack", "PartPlankPack","PartPlankPack","ItemTentDomed","ItemTrashRazor","ItemWire","ItemLightBulb","ItemJerrycanEmpty", "PartWheel", "PartVRotor","Laserbatteries", "ItemDocument", "ItemNewspaper", "ItemDocumentRamp", "ItemORP", "ItemAVE", "ItemLRK", "ItemTNK", "ItemBook1", "ItemBook2", "ItemBook3", "ItemBook4", "ItemLetter", "Skin_Rocker2_DZ", "Skin_SurvivorW2_DZ", "Skin_Functionary1_EP1_DZ", "Skin_Haris_Press_EP1_DZ", "Skin_Priest_DZ", "Skin_SurvivorWpink_DZ", "Skin_SurvivorWurban_DZ", "Skin_SurvivorWcombat_DZ", "Skin_SurvivorWdesert_DZ", "Skin_Survivor2_DZ", "Skin_Rocker1_DZ", "Skin_Rocker3_DZ", "Skin_RU_Policeman_DZ", "Skin_Pilot_EP1_DZ", "Skin_Rocker4_DZ", "FoodBioMeat", "ItemBandage", "MortarBucket","ItemTinBar", "ItemTinBar", "ItemKiloHemp", "Skin_SurvivorW3_DZ"];
		//Стволы
		for "_i" from 0 to 4 do {
			_itemBar=  _gun_list  call BIS_fnc_selectRandom;
			_finish_box addWeaponCargoGlobal [_itemBar, 1];
		};
		//сумку
		_finish_box addBackpackCargo [_Backpacks,1];
		//Медецина
		for "_i" from 0 to 9 do {
			_med = _med_list call BIS_fnc_selectRandom;
			_finish_box addMagazineCargoGlobal [_med, 1];
		};
		//Еда
		for "_i" from 0 to 2 do {
			_food = _food_list call BIS_fnc_selectRandom;
			_finish_box addMagazineCargoGlobal [_food, 1];
		};
		//Вода
		for "_i" from 0 to 2 do {
			_wather = _wather_list call BIS_fnc_selectRandom;
			_finish_box addMagazineCargoGlobal [_wather, 1];
		};
		//Разное
		for "_i" from 0 to 30 do {
			_misc = _misc_list call BIS_fnc_selectRandom;
			_finish_box addMagazineCargoGlobal [_misc, 1];
		};
	} else {
		//Техника
		_name_veh = ["SUV_Camo","SUV_Blue","SUV_Green","SUV_Yellow","SUV_Red","SUV_White","SUV_Pink","SUV_Charcoal","SUV_Orange","SUV_Silver","Ural_CDF","UralCivil_DZE","UralCivil2_DZE","UralRefuel_TK_EP1_DZ","Kamaz","KamazOpen_DZE","KamazRefuel_DZ","Volha_1_TK_CIV_EP1","VolhaLimo_TK_CIV_EP1","LandRover_CZ_EP1","LandRover_TK_CIV_EP1","Ikarus_TK_CIV_EP1","MTVR","MTVR_DES_EP1","Lada1_TK_CIV_EP1","UH1H_DZE","UH60M_EP1_DZE","UH1Y_DZE","MH60S_DZE","MH6J_DZ","AH6X_DZ","V3S_Civ","V3S_RA_TK_GUE_EP1_DZE","V3S_Open_TK_EP1","V3S_TK_EP1_DZE","V3S_Refuel_TK_GUE_EP1_DZ","Mi17_DZE","Mi17_Civilian_DZ"] call BIS_fnc_selectRandom;

		_veh = createVehicle [_name_veh, _object_bot,[], 0, "CAN_COLLIDE"];
		_veh setVariable ["Mission","1",true];

		_array =[];
		_hitpoints = _veh call vehicle_getHitpoints;
		_tvih = typeOf _veh;
		{
			_selection = getText(configFile >> "cfgVehicles" >> _tvih >> "HitPoints" >> _x >> "name");
			_array set [count _array,[_selection,(0.4 +(random 0.4))]];
		} count _hitpoints;

		{
			_veh setHit _x;
			[_veh,_x select 0,_x select 1] call Vehicle_HandleDamage;
		}forEach _array;

		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		_veh setFuel (random 0.2); 
		PVDZE_veh_Init = _veh;
		publicVariable "PVDZE_veh_Init";
	};

	sleep 1;
	deletevehicle _object_bot;
};
DZE_ActionInProgress = false;
