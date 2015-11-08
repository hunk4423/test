/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_papers","_hastinitem","_paper","_abort","_invehicle","_started","_finished","_animState","_isRead","_myDance","_itemfordel","_Document","_Newspaper","_obj","heartbeat_1"];
disableserialization;
call gear_ui_init;
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};
if !("ItemKiloHemp" in magazines player) exitWith {cutText [format["Нужен KiloHemp!"], "PLAIN DOWN"]};
if !("ItemMatchbox_DZE" in items player) exitWith {cutText [format["Необходимы Спички."], "PLAIN DOWN"]};

_papers = ["ItemNewspaper","ItemBook4","ItemBook3","ItemBook2","ItemBook1","ItemLetter","ItemPlotDeed","ItemDocument","ItemARM","ItemTNK","ItemLRK","ItemAVE","ItemORP","ItemDocumentRamp","ItemTrashToiletpaper"];
_hastinitem = false;
{
	if (_x in magazines player) then {
		_hastinitem = true;
		_paper = _x;
	};
} count _papers;
if !(_hastinitem) exitWith {cutText [format["Нужна бумага, книжка, газетка или документ!"], "PLAIN DOWN"]};

if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
DZE_ActionInProgress = true;
closeDialog 1;

_invehicle = false;
_Newspaper = false;
_Document = false;
_abort= false;

if (vehicle player != player) then {_invehicle = true;};
if !(_invehicle) then {player playActionNow "Medic";};

[player,"document",0,false,20] call dayz_zombieSpeak;
[player,10,true,(getPosATL player)] spawn player_alertZombies;

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;

while {r_doLoop} do {
	_animState = animationState player;
	_isRead = ["Medic", _animState] call fnc_inString;
	if (_isRead) then {
		_started = true;
	};
	if (_started and !_isRead) then {
		r_doLoop = false;
		_finished = true;
	};
	if (r_interrupt) then {
		r_doLoop = false;
	};
	if (_invehicle) then {
		uiSleep 6;
		r_doLoop = false;
		_finished = true;
	};
	uiSleep 0.1;
};
r_doLoop = false;

if (_finished) then {
//трава
_num_removed = ([player,"ItemKiloHemp"] call BIS_fnc_invRemove);
if!(_num_removed == 1) exitWith {cutText ["Ошибка!", "PLAIN DOWN"];DZE_ActionInProgress = false;}; 

//бумага
_hastinitem = false;
	{
		if (_x in magazines player) then {
			_hastinitem = true;
			_paper = _x;
		};
	} count _papers;
_num_removed = ([player,_paper] call BIS_fnc_invRemove);
if!(_num_removed == 1) exitWith {cutText ["Ошибка!", "PLAIN DOWN"];DZE_ActionInProgress = false;};

//Движения
_myDance = ["ActsPercMstpSnonWnonDnon_DancingDuoIvan","ActsPercMstpSnonWnonDnon_DancingStefan","ActsPercMstpSnonWnonDnon_DancingDuoStefan"] call BIS_fnc_selectRandom;



	if (KiloHemp)  exitWith {
		if (vehicle player == player) then {
			[player,1] call fnc_usec_damageUnconscious;
		};
		[] EXECVM_SCRIPT(grandshake.sqf);
		cutText ["Ох как мне плохо!!! Видать я переборщил...", "PLAIN DOWN"];
		r_player_blood = r_player_blood - 4000;
		_sound = ['z_scream_3','z_scream_4'] call BIS_fnc_selectRandom;
		[nil,player,rSAY,[_sound,250]] call RE;
		[player,100,true,(getPosATL player)] spawn player_alertZombies;
		DZE_ActionInProgress = false;
	};
	KiloHemp = true;

	uiSleep 1;
	_obj = "SmokeShellGreen" createVehicle (position player);
	if !(_invehicle) then {
		_obj attachTo [vehicle player,[0,0,0]];
		player playMove _myDance;
	}else{
		_obj attachTo [vehicle player,[0,0,-1]];
	};

	100 cutText ["Валера! Настало твое время!","PLAIN DOWN"]; titleFadeOut 4;
	dayz_sourceBleeding = objNull;
	r_player_blood = r_player_bloodTotal;
	r_player_infected = false;
	r_player_injured = false;
	dayz_temperatur = 45;
	r_fracture_legs = false;
	r_fracture_arms = false;
	r_player_dead = false;
	r_player_unconscious = false;
	r_player_loaded = false;
	r_player_cardiac = false;
	r_player_lowblood = false;
	r_player_timeout = 0;
	r_handlercount = 0;
	r_interrupt = false;
	r_doLoop = false;
	r_drag_sqf = false;
	r_self = false;
	r_action = false;
	r_action_unload = false;
	r_player_handler = false;
	r_player_handler1 = false;
	disableUserInput false;
	'dynamicBlur' ppEffectAdjust [0];
	'dynamicBlur' ppEffectCommit 5;
	_selection = 'legs';
	_damage = 0;
	player setHit[_selection,_damage];
	player setVariable['NORRN_unconscious',false,true];
	player setVariable['USEC_infected',false,true];
	player setVariable['USEC_injured',false,true];
	player setVariable['USEC_isCardiac',false,true];
	player setVariable['USEC_lowBlood',false,true];
	player setVariable['USEC_BloodQty',12000,true];
	player setVariable['unconsciousTime',0,true];
	player setVariable ['hit_legs',0,true];
	player setVariable ['hit_hands',0,true];
	_display = uiNameSpace getVariable 'DAYZ_GUI_display';
	_control = _display displayCtrl 1303;
	_control ctrlShow false;
	_display = uiNameSpace getVariable 'DAYZ_GUI_display';
	_control = _display displayCtrl 1203;
	_control ctrlShow false;
	player setdamage 0;

	_hndl = ppEffectCreate ["colorCorrections", 1501]; 
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [1.0, 1.0, -0.03, [0.0, 0.0, 0.0, 0.0], [3.0, 5.0, 9.0, 5.0],[0.4,0.0,0.0, 0.7]];
	_hndl ppEffectCommit 1;
	uiSleep 20;
	_hndl = ppEffectCreate ["colorCorrections", 1501];
	_hndl ppEffectAdjust [0, 8, 0.8,8,8, 0.2, 1, 0, 0, 0.08, 0.08, 0, 0, 0, 0.77];
	_hndl ppEffectEnable true;
	_hndl ppEffectCommit 0;
	_hndl = ppEffectCreate ["colorCorrections", 1501]; 
	_hndl ppEffectAdjust [1, 1, 0, [1.5,6,2.5,0.5], [5,3.5,5,-0.5], [-3,5,-5,-0.5]]; 
	_hndl ppEffectCommit 1;
	_hndl ppEffectEnable true; 
	_hndl = ppEffectCreate ["colorCorrections", 1501]; 
	_hndl ppEffectAdjust [0.01,0.01,true];
	_hndl ppEffectCommit 1;
	_hndl ppEffectEnable true;
	_hndl = ppEffectCreate ["colorCorrections", 1501]; 
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [0.02,0.02,0.15,0.15]; 
	_hndl ppEffectCommit 1;
	uiSleep 20;
	_hndl = ppEffectCreate ["colorCorrections", 1501];
	_hndl ppEffectAdjust [1, 1.16, 0.32, 2.56, 0.8, 0.64, 2.64, 0, 0, 1.08, 0.08, 0, 0, 0, 1.77];
	_hndl ppEffectEnable true;
	_hndl ppEffectCommit 0;
	uiSleep 2;
	deletevehicle _obj;
	_hndl = ppEffectCreate ["colorCorrections", 1501]; 
	_hndl ppEffectEnable true;
	_hndl ppEffectAdjust [1.0, 1.0, -0.02, [9.5, 1.5, 2.5, 0.2], [2.0, 7.0, 6.0, 2.0],[0.4,0.0,0.0, 0.7]];
	_hndl ppEffectCommit 1;
	
	dayz_hunger = dayz_hunger + 1000;
	dayz_thirst = dayz_thirst + 1000;
	player setVariable['USEC_inPain',true,true];
	player setVariable['medForceUpdate',true,true];
	
	if (vehicle player == player) then {
		player playActionNow "stop"; player switchMove "AmovPpneMrunSnonWnonDfr";
	};
	0 fadeSound 1;
	uiSleep 10;
	ppEffectDestroy _hndl;

	[player,"panic",0,false,7] call dayz_zombieSpeak; 
	cutText [format["Что со мной сейчас было??!... голова раскалывается, кушать хочу..."], "PLAIN DOWN"];

	uiSleep 5;

	cutText ["Я вроде начинаю что-то вспоминать...", "PLAIN DOWN"];
	uiSleep 10;

	if (RND(30)) then {
		private ["_uniqueid","_array","_hitpoints","_tvih","_selection","_count_ar","_part","_parts","_finish_box","_gun_list","_Backpacks","_med_list","_food_list","_wather_list","_misc_list","_itemBar","_med","_food","_wather","_misc","_location","_name_veh","_messages","_object_bot","_finish_box","_veh","_x","_this"];

		_location = [getMarkerPos "center", 0, 14000, 0, 0, 2000, 0] call BIS_fnc_findSafePos;
		_locationAI = [_location select 0, _location select 1, 1];

	
	//Сообщения
	_messages = [
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
"Эти координаты - твой шанс! Спеши!",
"Тебе выпал шанс! Не упусти!",
"Координаты Удачи! Проверь! ",
"Проверь координаты и ты Удачлив и богат!",
"Интересные координаты... Стоит проверить!"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	] call BIS_fnc_selectRandom;

	//спавним бота
	_object_bot = createAgent ["Worker3", _locationAI, [], 0, "NONE"];
	
	//сообщение игроку
	_map_coord = mapGridPosition getPos _object_bot;
	titleText [_messages + "\n Запомни координату: " + _map_coord, "PLAIN DOWN", 5];
	systemChat ("Запомни координату: " + _map_coord);
	playSound "pda";
	
		if (RND(40)) then {

		_finish_box = createVehicle ["WoodCrate_DZ", _object_bot, [], 0, "NONE"];
		uiSleep 3;
		DZE_ActionInProgress = false;
		
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
		_name_veh = ["SUV_Camo", "SUV_Blue", "SUV_Green", "SUV_Yellow", "SUV_Red", "SUV_White", "SUV_Pink", "SUV_Charcoal", "SUV_Orange", "SUV_Silver", "Ural_CDF", "UralCivil_DZE", "UralCivil2_DZE", "UralRefuel_TK_EP1_DZ", "Kamaz", "KamazOpen_DZE", "KamazRefuel_DZ", "Volha_1_TK_CIV_EP1", "VolhaLimo_TK_CIV_EP1", "LandRover_CZ_EP1", "LandRover_TK_CIV_EP1", "Ikarus_TK_CIV_EP1", "MTVR", "MTVR_DES_EP1", "Lada1_TK_CIV_EP1", "UH1H_DZE", "UH60M_EP1_DZE", "UH1Y_DZE", "MH60S_DZE", "MH6J_DZ", "AH6X_DZ", "V3S_Civ", "V3S_RA_TK_GUE_EP1_DZE", "V3S_Open_TK_EP1", "V3S_TK_EP1_DZE", "V3S_Refuel_TK_GUE_EP1_DZ", "Mi17_DZE", "Mi17_Civilian_DZ"] call BIS_fnc_selectRandom;

		_veh = createVehicle [_name_veh, _object_bot,[], 0, "CAN_COLLIDE"];
		_veh setVariable ["Mission","1",true];

		_array =[];
		_hitpoints = _veh call vehicle_getHitpoints;
		_tvih = typeOf _veh;
		{
				_selection = getText(configFile >> "cfgVehicles" >> _tvih >> "HitPoints" >> _x >> "name");
				_array set [count _array,[_selection,(0.4 +(random 0.4))]];				
		} count _hitpoints;

		_count_ar = count _array;
		for "_i" from 0 to _count_ar do {
		_part = _array select _i;
		_veh setHit _part;
		_parts = [_veh,_part select 0,_part select 1];
		_parts call Vehicle_HandleDamage;
		};
		
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		_veh setFuel (random 0.2); 
		PVDZE_veh_Init = _veh;
		publicVariable "PVDZE_veh_Init";
		
		DZE_ActionInProgress = false;
		
	};

	Sleep 1;
	deletevehicle _object_bot;
	
	} else {cutText ["...а, не, о чем это я?", "PLAIN DOWN"];};
		DZE_ActionInProgress = false;

	_heartbeat_1 = 120;
	while {_heartbeat_1 > 0} do {
		playSound "heartbeat_1";
		_heartbeat_1 = _heartbeat_1 - 1;
		Sleep 1;
	};
	uiSleep 60;
	KiloHemp = nil;
} else {
	r_interrupt = false;
	DZE_ActionInProgress = false;
	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		cutText ["Я еще не закончил!", "PLAIN DOWN"];
	};
};
