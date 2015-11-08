/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
//Medical Event Handlers
"norrnRaLW"					addPVEH {THIS1 execVM "\z\addons\dayz_code\medical\publicEH\load_wounded.sqf"};
"norrnRLact"				addPVEH {THIS1 execVM "\z\addons\dayz_code\medical\load\load_wounded.sqf"};
"norrnRDead"				addPVEH {[THIS1] execVM "\z\addons\dayz_code\medical\publicEH\deadState.sqf"};
"usecBleed"					addPVEH {THIS1 spawn fnc_usec_damageBleed};
"usecBandage"				addPVEH {THIS1 call player_medBandage};
"usecInject"				addPVEH {THIS1 call player_medInject};
"usecEpi"					addPVEH {THIS1 call player_medEpi};
"usecTransfuse"				addPVEH {THIS1 call player_medTransfuse};
"usecMorphine"				addPVEH {["morphine"] call fnc_usec_SplintWound};
"usecSplintWound"			addPVEH {["WoodPile"] call fnc_usec_SplintWound};
"usecPainK"					addPVEH {THIS1 call player_medPainkiller};
"PVDZE_plr_Hit" 			addPVEH {THIS1 call fnc_usec_damageHandler};
"PVDZE_plr_HitV" 			addPVEH {THIS1 call fnc_usec_damageVehicle};
"usecBreakLegs"				addPVEH {THIS1 call player_breaklegs};
"usecnopvp"					addPVEH {THIS1 call player_nopvp};
"usecnopvpmsg"				addPVEH {THIS1 call player_nopvpmsg};
"usecnopvpforgive"			addPVEH {THIS1 call player_nopvpforgive};
"get_trader_price"			addPVEH {{call compile (_x)}forEach THIS1};

//Both
"PVDZE_veh_SFuel"			addPVEH {THIS1 spawn local_setFuel};
"PVDZE_veh_SFix"			addPVEH {THIS1 call object_setFixServer};
"PVDZE_plr_HideBody"		addPVEH {hideBody THIS1};
"PVDZE_obj_Hide"			addPVEH {hideObject  THIS1};
"PVDZE_veh_Lock"			addPVEH {THIS1 spawn local_lockUnlock};
"PVDZE_plr_GutBody"			addPVEH {THIS1 spawn local_gutObject};
"PVDZE_plr_GutBodyZ"		addPVEH {THIS1 spawn local_gutObjectZ};
"PVDZE_plr_DelLocal"		addPVEH {THIS1 call object_delLocal};
"PVDZE_veh_Init"			addPVEH {THIS1 call fnc_veh_ResetEH};
"PVDZE_plr_HumanityChange"	addPVEH {THIS1 spawn player_humanityChange};
"PVDZE_serverObjectMonitor" addPVEH {PVDZE_serverObjectMonitor=dayz_safety};
/* PVS/PVC - Skaronator */
"PVCDZE_vehSH" 				addPVEH {THIS1 call vehicle_handleDamage}; // set damage to vehicle part
"PVDZE_evac" 				addPVEH {THIS1 call evac_handleDamage}; // set damage to vehicle

"PVDZE_Server_Simulation" addPVEH {
	PVT(_array);
	_array=THIS1;
	SEL0(_array) enableSimulation SEL1(_array);
};

//Server only
if (isServer) then {
	/* PVS/PVC - Skaronator */
	"PVDZE_send" addPVEH {THIS1 call server_sendToClient};
	"PVDZE_maintainArea" addPVEH {THIS1 spawn server_maintainArea};

	"PVDZE_atp" addPVEH {
		PVT(_v);
		_v=THIS1;
		if (typeName _v == "STRING")then{diag_log _v};
	};
	"PVDZE_plr_Died"		addPVEH {THIS1 spawn server_playerDied};
	"PVDZE_plr_Save"		addPVEH {THIS1 spawn server_playerSync};
	"PVDZE_obj_Publish"		addPVEH {THIS1 call server_publishObj};
	"PVDZE_veh_Update"		addPVEH {THIS1 spawn server_updateObject};
	"PVDZE_plr_Login"		addPVEH {THIS1 spawn server_playerLogin};
	"PVDZE_plr_Login2"		addPVEH {THIS1 call server_playerSetup};
	"PVDZE_plr_Morph"		addPVEH {THIS1 call server_playerMorph};
	"PVDZE_plr_LoginRecord"	addPVEH {THIS1 spawn dayz_recordLogin};
	//Checking
	"PVDZE_obj_Delete"		addPVEH {THIS1 spawn server_deleteObj};
	// upgrade && maintain
	"PVDZE_obj_Swap"		addPVEH {THIS1 spawn server_swapObject};
	// disable zombies server side
	"PVDZE_zed_Spawn"		addPVEH {THIS1 spawn server_handleZedSpawn};

	// Dayz epoch custom
	"PVDZE_veh_Publish"		addPVEH {THIS1 spawn server_publishVeh};
	"PVDZE_veh_Publish2"	addPVEH {THIS1 spawn server_publishVeh2};
	"PVDZE_veh_Upgrade"		addPVEH {THIS1 spawn server_publishVeh3};
	"PVDZE_obj_Trade"		addPVEH {THIS1 spawn server_tradeObj};
	"PVDZE_plr_TradeMenu"	addPVEH {THIS1 spawn server_traders};
	"PVDZE_plr_DeathB"		addPVEH {THIS1 spawn server_deaths};

	"PVDZE_log_lockUnlock"	addPVEH {THIS1 spawn server_logUnlockLockEvent};
	
	"PVDZE_Garage"			addPVEH {THIS1 spawn server_garage};
	"PVDZE_veh_Colour"		addPVEH {THIS1 call fnc_veh_setColour};
	"PVDZE_ObjectTimeoutCtrl"	addPVEH {THIS1 call server_ObjectTimeoutCtrl};
	"PVDZE_TurboInstall"	addPVEH {THIS1 call server_TurboInstall};
#ifdef _ORIGINS
	"PVDZE_Ori_upgrade"		addPVEH {THIS1 call fnc_veh_OriUpgrade};
	"PVDZE_Ori_Skin"		addPVEH {THIS1 call fnc_veh_OriSkin};
#endif
};

//Client only
if (!isDedicated) then {
	"PVDZE_plr_SetDate"		addPVEH {if (!(player getVariable["Preview",false]))then{setDate THIS1}};
	"PVDZE_plr_SetSaveTime"	addPVEH {DZE_SaveTime = THIS1};
	"PVDZE_obj_RoadFlare"	addPVEH {THIS1 spawn object_roadFlare};
	"PVDZE_plr_Morph2"		addPVEH {THIS1 call player_serverModelChange};
	"PVDZE_plr_Morph"		addPVEH {THIS1 call server_switchPlayer};
	"PVDZE_obj_Fire"		addPVEH {THIS1 spawn BIS_Effects_Burn};
	"PVDZE_plr_FriendRQ"	addPVEH {THIS1 call player_tagFriendlyMsg};

	// "PVDZE_obj_Debris"		addPVEH {THIS1 call local_roadDebris};

	"norrnRaDrag"			addPVEH {THIS1 execVM "\z\addons\dayz_code\medical\publicEH\animDrag.sqf"};
	"norrnRnoAnim"			addPVEH {THIS1 execVM "\z\addons\dayz_code\medical\publicEH\noAnim.sqf"};

	"sayDeathSafe"			addPVEH {THIS1 call player_deathSafeMsg};
	
	"PVDZE_gift"			addPVEH {THIS1 call vehicle_takeGift};

	// DZAI Client-side Addon Configuration File
	if (DZAIC_radio)then{
		"DZAI_SMS" addPVEH {
			if (isNil "DZAI_noRadio")then{
				systemChat THIS1;
				DZAI_noRadio=true;
				THIS1 spawn {
					playsound "radio_shum";
					for "_i" from 1 to 2 do {cutText [_this, "PLAIN DOWN"];sleep 0.5};
					DZAI_noRadio=nil;
				};
			};
		};
	};
	if (DZAIC_zombieEnemy)then{
		"DZAI_ratingModify" addPVEH {
			PVT3(_array,_targets,_rating);
			_array=THIS1;
			_rating=SEL1(_array);
			{if (local _x)then{_x addRating _rating}}forEach SEL0(_array);
		};
	};

	"PVDZE_radio"		addPVEH {
							PVT(_veh); 
							_veh = vehicle player;
							if ("ItemRadio" in (items player) || (_veh != player && !(_veh isKindOf "Bicycle")))then{
								playsound "radio_shum";
								systemChat (THIS1 select 0);
							};
						};
	"PVCDZE_EjectInTow"	addPVEH {THIS1 call fnc_vehInTowEject};

	"PVDZE_EMSMark"	addPVEH {
			PVT4(_array,_msg,_color,_dst);
			_array=THIS1;
			_dst=SEL1(_array);
			if (_dst>1000)then{_color="#FF0000"}else{_color="#5882FA"};
			[_color,format["Игрок %1 поставил метку на миссию за %2 метров.",name SEL0(_array),_dst]]call player_msgEMS;
	};

	"PVDZE_msgEMS" addPVEH {THIS1 call player_msgEMS;playSound "pda"};

	"PVDZE_TaxiCost" addPublicVariableEventHandler { systemChat format["Суммарная стоимость проезда %1 руб.",_this select 1]};

#ifdef RND_TRADERS
	"PVDZE_TradersMarkers"	addPVEH {StaticMarkers=StaticMarkers+THIS1; if (StaticMarkersInit)then{[StaticMarkers] EXECVM_SCRIPT(marker.sqf)}};
#endif
};
