/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/

#include "instance_id.h"
#include "scripts\defines.h"

startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

//REALLY IMPORTANT VALUES
dayZ_instance = INSTANCEID;		//The instance
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

//disable greeting menu 
player setVariable ["BIS_noCoreConversations", true];
// May prevent "how are you civillian?" messages from NPC
enableSentences false;

// DayZ Epoch config
DZE_fUpdateMoney = true;
DZE_noRotate = []; //Objects that cannot be rotated. Ex: DZE_noRotate = ["VaultStorageLocked"]
DZE_curPitch = 45; //Starting rotation angle. Only 1, 5, 45, or 90.

DZE_StaticConstructionCount = 3; // Only one animation to build
DZE_APlotforLife = true; // A plot for Life on (true) or off (false)
DZE_modularBuild = true; // Modular build framework on (true) or off (false).  This is a coding framework and has no in game effect but also includes snap build pro.

dayz_tameDogs = false;
spawnShoremode = 0;
spawnArea= 300;
MaxVehicleLimit = MAX_VECHICLE;
MaxDynamicDebris = DYNAMIC_DEBRIS;
dayz_MapArea = MAP_AREA;
dayz_zedsAttackVehicles = true;
dayz_fullMoonNights = true;
DZE_BuildingLimit = 400;
DZE_BuildOnRoads = true; // Default: False
dayZ_serverName = "GoldKey";
MaxHeliCrashes = MAX_HELICRASH; 
MaxAmmoBoxes = AMMO_BOXES;
MaxMineVeins = MINE_VEINS;

dayz_maxLocalZombies = 12;
dayz_maxGlobalZombiesInit = 12;
dayz_maxGlobalZombiesIncrease = 4;
dayz_maxZeds = 500;
DZE_AllowForceSave = true;

dayz_minpos = MAP_MIN_POS; 
dayz_maxpos = MAP_MAX_POS;
dayz_sellDistance_vehicle = 30;
dayz_sellDistance_boat = 30;
dayz_sellDistance_air = 40;
dayz_maxAnimals = 2;

DynamicVehicleDamageLow = 40;
DynamicVehicleDamageHigh = 100;
DynamicVehicleFuelLow = 5;
DynamicVehicleFuelHigh = 10;

DZE_GodModeBase = true;

DZE_ForceNameTags = true;
DZE_HumanityTargetDistance = 50;
DZE_FriendlySaving = true;
DZE_SelfTransfuse = true;
EnableRadio true;
#ifdef _BLOWOUT
ns_blowout_dayz = true;
ns_blow_itemapsi = "CDF_dogtags";
#endif
#ifdef _OVERPOCH
DZE_MissionLootTable = true;
#endif
DefaultMagazines = [DEF_MAGAZINES]; 
DefaultWeapons = [DEF_WEAPONS]; 
DefaultBackpack = DEF_BACKPACK; 
DefaultBackpackWeapon = "";

DZE_PlayerZed = false;
DZE_HeliLift = false;

EpochEvents = [["any","any","any","any",30,"crash_spawner"],["any","any","any","any",0,"crash_spawner"],["any","any","any","any",15,"supply_drop"]];

// DZAI Client-side Addon Configuration File
//Enables use of client-side radio functions.
DZAIC_radio = true;
//Enables AI hostility to zombies.
DZAIC_zombieEnemy = true;


//Load in compiled functions
call COMPILE_FILE(variables.sqf);				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call COMPILE_SCRIPT_FILE(publicEH.sqf);
progressLoadingScreen 0.2;
call COMPILE_SCRIPT_FILE(setup_functions_med.sqf);	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call COMPILE_FILE(compiles.sqf);				//Compile regular functions
progressLoadingScreen 0.5;
call COMPILE_FILE(server_traders.sqf);				//Compile trader configs
//progressLoadingScreen 0.6;
progressLoadingScreen 0.7;
call COMPILE_SCRIPT_FILE(Crafting_Compiles.sqf);
progressLoadingScreen 0.8;
call COMPILE_SCRIPT_FILE(textBoxx_init.sqf);
progressLoadingScreen 0.9;
call COMPILE_SCRIPT_FILE(veh_functions.sqf);
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

call COMPILE_SCRIPT_FILE(garage_function.sqf);

if (isServer) then {
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\scripts\dynamic_vehicle.sqf";
	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
#ifdef _BLOWOUT
	_nil = [ns_blow_emp] EXECVM_SCRIPT(blowout_server.sqf);
#endif
};

if (!isDedicated) then {
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");

	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = [] EXECVM_SCRIPT(player_monitor.sqf);
	dayz_playerName = name player;

#ifdef _BLOWOUT
	_nil = [] EXECVM_SCRIPT(blowout_client.sqf);
#endif
	_nil = [] EXECVM_SCRIPT(service_point.sqf);
	_nil = [] EXECVM_SCRIPT(dzgm_init.sqf);
	_nil = [] EXECVM_SCRIPT(GG_MapMarker.sqf);
	_nil = [] EXECVM_SCRIPT(init_tow.sqf);
	_nil = [] EXECVM_SCRIPT(nosidechat.sqf);
	_nil = [] EXECVM_SCRIPT(antibackpack.sqf);
	[] EXECVM_SCRIPT(aerolift_init.sqf);
	[] EXECVM_SCRIPT(walkamongstthedead.sqf);
	[] EXECVM_SCRIPT(marker.sqf);
	call COMPILE_SCRIPT_FILE(fnc_garage_dialog.sqf);
	call COMPILE_SCRIPT_FILE(select_player.sqf);
};

#include "\z\addons\dayz_code\system\BIS_Effects\init.sqf"
BIS_Effects_AirDestructionStage2 = COMPILE_SCRIPT_FILE(AirDestructionStage2.sqf);

_nil = [] EXECVM_SCRIPT(DynamicWeatherEffects.sqf);
_nil = [] EXECVM_SCRIPT(gold_init.sqf);
_nil = [] EXECVM_SCRIPT(andre_ddos_heli_guard.sqf);

if (!isServer) then {
#ifdef _ORIGINS
	_nil = [] EXECVM_SCRIPT(clean_up_map.sqf);
#endif
#ifdef _SAHRANI
	_nil = [] EXECVM_SCRIPT(sahrani.sqf);
#endif
	_nil = [] EXECVM_SCRIPT(custom_monitor.sqf);
	[] EXECVM_SCRIPT(infistar_safe_zone.sqf);
	_nil = [] EXECVM_SCRIPT(EvacChopper_init.sqf);
	_nil = [] EXECVM_SCRIPT(advancedTrading_init.sqf);

	if (!isNil "dayZ_serverName") then {
		[] spawn {
			waitUntil {(!isNull Player) and (alive Player) and (player == player)};
			waituntil {!(isNull (findDisplay 46))};
			5 cutRsc ["wm_disp","PLAIN"];
			((uiNamespace getVariable "wm_disp") displayCtrl 1) ctrlSetText dayZ_serverName;
		};
	};
	waitUntil {!isNil ("PVDZE_plr_LoginRecord")};

	[getPlayerUID player] spawn {
		PVT2(_puid,_ch);
		PARAMS1(_puid);
		while {true}do{
			_ch=false;
			if (!IsNil "PV_LowLevel_List" && !IsNil "PV_NormalLevel_List" && !IsNil "PV_SuperLevel_List" && !IsNil "PV_DevUlDs")then{
				if (_puid in PV_LowLevel_List)then{AdminLevel=1;_ch=true;};
				if (_puid in PV_NormalLevel_List)then{AdminLevel=2;_ch=true;};
				if (_puid in PV_SuperLevel_List)then{AdminLevel=3;_ch=true;};
				if (_puid in PV_DevUlDs)then{AdminLevel=4;_ch=true;};
			};
			if (_ch && CurrAdminLevel==-1)exitWith{CurrAdminLevel=AdminLevel;};
			sleep 5;
		};
		if (CurrAdminLevel>0)then{PremiumList_trade=PremiumList_trade+[_puid]};
	};
	call COMPILE_SCRIPT_FILE(AccessDialog.sqf);
	call COMPILE_SCRIPT_FILE(build_functions.sqf);

	if (dayzPlayerLogin2 select 2) then { 
		[] execVM SPAWNSCRIPT;
	} else {
		[] EXECVM_SCRIPT(Server_WelcomeCredits.sqf);
	};
};

#include "localinit.sqf"
