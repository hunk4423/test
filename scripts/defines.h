/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz

	Defines all
*/

#define SCRIPT_PATH scripts
#define CUSTOM_PATH custom

#define MAX_PLAYER			36
#define DYNAMIC_DEBRIS		50
#define SPAWNSCRIPT			"scripts\spawn.sqf"

#define AL_DROP_DAMAGE		0.8

#define PLOT_RADIUS			60
#define PLOT_MIN_DIST		150

#define FUEL_RANGE			60

#define PLAYER_START_MONEY	100

// минимальная наличность для прыжка
#define HALO_MIN_BANK		2000

#define PLOT_CHANGE_COST	1000
#define DOOR_CHANGE_COST	1000
#define SAFE_CHANGE_COST	1000

#define MAKE_KEY_COST		100

#define COLD_HEIGHT 		300
#define Z_HUMANITY 			5

//Шанс того что зомби будут бегать/ходить
#define Z_SPEED_CHANCE 		70

// высота,сумма
#define HALO_PRICE			[1500,2000],[3000,5000]

#define ITEMoffNUMACTIONS	"ItemNewspaper","ItemBloodbag"

#define DEF_MAGAZINES		"ItemBandage","ItemBandage","ItemBandage","ItemPainkiller","FoodBioMeat","ItemMorphine","30Rnd_545x39_AK","30Rnd_545x39_AK","8Rnd_9x18_Makarov"
#define DEF_WEAPONS			"AKS_74_U","Makarov","ItemMap","ItemRadio","ItemHatchet_DZE"
#define DEF_BACKPACK		"DZ_Assault_Pack_EP1"

#define VEHICLE_TYPE		"LandVehicle","Air","Ship"
#define VEHICLE_MOVE_TYPE	"Car","Motorcycle","Tank","Air","Ship"

// Доступ. Подробнее в defines.h сервера
#define FULL_ACCESS			"full"
#define ANY_ACCESS			"any"

#define PLOT_FULL_ACCESS	"full"
#define PLOT_PLAYER_ACCESS	"player"
#define PLOT_BUILD_ACCESS	"build"
#define BUILD_ACCESS		[PLOT_FULL_ACCESS,PLOT_PLAYER_ACCESS,PLOT_BUILD_ACCESS]

#define DOOR_PLAYER_ACCESS	"player"
#define DOOR_OPEN_ACCESS	"open"
#define DOPEN_ACCESS	[DOOR_PLAYER_ACCESS,DOOR_OPEN_ACCESS]

#define SAFE_FULL_ACCESS	"full"
#define SAFE_PLAYER_ACCESS	"player"
#define SAFE_OPEN_ACCESS	"open"
#define SOPEN_ACCESS	[SAFE_FULL_ACCESS,SAFE_PLAYER_ACCESS,SAFE_OPEN_ACCESS]

#define GARAGE_FULL_ACCESS	"full"
#define GARAGE_PLAYER_ACCESS	"player"
#define GARAGE_SELF_ACCESS		"my"
#define GARAGE_OTHER_ACCESS		"other"
#define PAD_PLANE	"Plane"
#define PAD_HELI	"Helicopter"
#define PAD_SHIP	"Ship"
#define PAD_TANK	"Tank"
#define PAD_APC		"Wheeled_APC"
#define PAD_TRUCK	"Truck"
#define PAD_MOTO	"Motorcycle"
#define PAD_OTHER	"Car"
#define PAD_HIGH	"ToHigh"
#define PAD_LOW		"ToLow"

#define GARAGE_ZONE	100
#define PAD_ZONE	15
#define IDD_GARAGE_LIST		2800
#define IDD_GARAGE_PAD		2900
#define GARAGE_AIR_SPAWN	"HeliH","HeliHCivil","HeliHRescue","MAP_Heli_H_army","MAP_Heli_H_cross","HeliHEmpty"
#define GARAGE_LAND_SPAWN	"Sr_border"
#define GARAGE_PADS	GARAGE_AIR_SPAWN,GARAGE_LAND_SPAWN

#define CREATE_MARKER(mname,mposX,mposZ,mposY,mtext,mtype,mcolor) \
	_marker = createMarker [mname,[mposX,mposY]]; _marker setMarkerText mtext; \
	_marker setMarkerType mtype; _marker setMarkerColor mcolor;

#define POSPREVIEWPAD [14840.4,13674.1,0] 

#define BASE_SKINS \
	["Survivor2_DZ","Skin_Survivor2_DZ",["Survivor2_DZ"]],\
	["SurvivorWcombat_DZ","Skin_SurvivorWcombat_DZ",["SurvivorWcombat_DZ"]],\
	["SurvivorWdesert_DZ","Skin_SurvivorWdesert_DZ",["SurvivorWdesert_DZ"]],\
	["SurvivorWurban_DZ","Skin_SurvivorWurban_DZ",["SurvivorWurban_DZ"]],\
	["SurvivorWsequishaD_DZ","Skin_SurvivorWsequishaD_DZ",["SurvivorWsequishaD_DZ"]],\
	["SurvivorWsequisha_DZ","Skin_SurvivorWsequisha_DZ",["SurvivorWsequisha_DZ"]],\
	["SurvivorWpink_DZ","Skin_SurvivorWpink_DZ",["SurvivorWpink_DZ"]],\
	["SurvivorW3_DZ","Skin_SurvivorW3_DZ",["SurvivorW3_DZ"]],\
	["SurvivorW2_DZ","Skin_SurvivorW2_DZ",["SurvivorW2_DZ"]],\
	["Bandit2_DZ","Skin_Bandit2_DZ",["Bandit2_DZ"]],\
	["BanditW1_DZ","Skin_BanditW1_DZ",["BanditW1_DZ"]],\
	["BanditW2_DZ","Skin_BanditW2_DZ",["BanditW2_DZ"]],\
	["Soldier_Crew_PMC","Skin_Soldier_Crew_PMC",["Soldier_Crew_PMC"]],\
	["Sniper1_DZ","Skin_Sniper1_DZ",["Sniper1_DZ"]],\
	["Soldier1_DZ","Skin_Soldier1_DZ",["Soldier1_DZ"]],\
	["Rocker1_DZ","Skin_Rocker1_DZ",["Rocker1_DZ"]],\
	["Rocker2_DZ","Skin_Rocker2_DZ",["Rocker2_DZ"]],\
	["Rocker3_DZ","Skin_Rocker3_DZ",["Rocker3_DZ"]],\
	["Rocker4_DZ","Skin_Rocker4_DZ",["Rocker4_DZ"]],\
	["Priest_DZ","Skin_Priest_DZ",["Priest_DZ"]],\
	["Functionary1_EP1_DZ","Skin_Functionary1_EP1_DZ",["Functionary1_EP1_DZ"]],\
	["Haris_Press_EP1_DZ","Skin_Haris_Press_EP1_DZ",["Haris_Press_EP1_DZ"]],\
	["Pilot_EP1_DZ","Skin_Pilot_EP1_DZ",["Pilot_EP1_DZ"]],\
	["RU_Policeman_DZ","Skin_RU_Policeman_DZ",["RU_Policeman_DZ"]],\
	["Ins_Soldier_GL_DZ","Skin_Ins_Soldier_GL_DZ",["Ins_Soldier_GL_DZ"]],\
	["Soldier_Sniper_PMC_DZ","Skin_Soldier_Sniper_PMC_DZ",["Soldier_Sniper_PMC_DZ"]],\
	["Soldier_Bodyguard_AA12_PMC_DZ","Skin_Soldier_Bodyguard_AA12_PMC_DZ",["Soldier_Bodyguard_AA12_PMC_DZ"]],\
	["Drake_Light_DZ","Skin_Drake_Light_DZ",["Drake_Light_DZ"]],\
	["FR_OHara_DZ","Skin_FR_OHara_DZ",["FR_OHara_DZ"]],\
	["FR_Rodriguez_DZ","Skin_FR_Rodriguez_DZ",["FR_Rodriguez_DZ"]],\
	["CZ_Soldier_Sniper_EP1_DZ","Skin_CZ_Soldier_Sniper_EP1_DZ",["CZ_Soldier_Sniper_EP1_DZ"]],\
	["GUE_Soldier_MG_DZ","Skin_GUE_Soldier_MG_DZ",["GUE_Soldier_MG_DZ"]],\
	["GUE_Soldier_Sniper_DZ","Skin_GUE_Soldier_Sniper_DZ",["GUE_Soldier_Sniper_DZ"]],\
	["GUE_Soldier_Crew_DZ","Skin_GUE_Soldier_Crew_DZ",["GUE_Soldier_Crew_DZ"]],\
	["GUE_Soldier_CO_DZ","Skin_GUE_Soldier_CO_DZ",["GUE_Soldier_CO_DZ"]],\
	["INS_Lopotev_DZ","Skin_INS_Lopotev_DZ",["INS_Lopotev_DZ"]],\
	["INS_Soldier_AR_DZ","Skin_INS_Soldier_AR_DZ",["INS_Soldier_AR_DZ"]],\
	["INS_Soldier_CO_DZ","Skin_INS_Soldier_CO_DZ",["INS_Soldier_CO_DZ"]],\
	["INS_Bardak_DZ","Skin_INS_Bardak_DZ",["INS_Bardak_DZ"]],\
	["TK_Soldier_Sniper_EP1_DZ","Skin_TK_Soldier_Sniper_EP1_DZ",["TK_Soldier_Sniper_EP1_DZ"]],\
	["TK_Commander_EP1_DZ","Skin_TK_Commander_EP1_DZ",["TK_Commander_EP1_DZ"]]

#define AL_SLOW				1.0025
#define AL_SLOW_H			1.0015

#define AL_HIGH_POWER \
	"CH_47F_EP1_DZE",\
	"CH_47F_BAF",\
	"CH53_DZE",\
	"BAF_Merlin_HC3_D",\
	"BAF_Merlin_DZE",\
	"Mi17_CDF",\
	"Mi17_medevac_Ins",\
	"Mi17_medevac_CDF",\
	"Mi17_medevac_RU",\
	"Mi17_Ins",\
	"Mi17_CDF",\
	"Mi17_UN_CDF_EP1",\
	"Mi171Sh_rockets_CZ_EP1",\
	"Mi17_rockets_RU",\
	"Mi17_TK_EP1",\
	"Mi24_D",\
	"Mi24_P",\
	"Mi24_V",\
	"Mi17_DZE",\
	"Mi171Sh_CZ_EP1",\
	"Mi17_Civilian_DZ",\
	"Mi24_D_TK_EP1"

#define FORBIDEN_BUILDING	"Land_stodola_old_open","Land_Misc_PowerStation","Land_Hangar_2","Land_A_BuildingWIP","Land_Tovarna2","Land_Mil_Barracks","Land_Mil_Barracks_i","Land_SS_hangar","Land_A_Hospital","Land_a_stationhouse","Land_Mil_ControlTower","Land_Mil_House","Land_A_FuelStation_Feed","Land_Ind_FuelStation_Feed_EP1","Land_FuelStation_Feed_PMC","FuelStation","Land_ibr_FuelStation_Feed","Land_fuelstation","land_fuelstation_w","Land_A_Castle_Bergfrit","Land_A_Castle_Donjon","Land_A_Castle_Wall2_30","Land_A_Castle_Bastion","Land_A_Castle_Gate","Land_Church_03","Land_HouseV2_02_Interier","Land_HouseV_3I3","Land_HouseV_1L2","Land_Shed_Ind02","Land_Farm_Cowshed_a","Land_helfenburk_brana","Land_helfenburk","Land_helfenburk_budova2","Land_smd_helfenburk"
#define TAKE_CLOTHES		[["TK_Special_Forces_TL_EP1","TK_Special_Forces_MG_EP1_DZ"],["TK_INS_Bonesetter_EP1","TK_INS_Warlord_EP1_DZ" ],["TK_INS_Soldier_2_EP1","TK_INS_Warlord_EP1_DZ"],["TK_INS_Soldier_3_EP1","TK_INS_Warlord_EP1_DZ"],["TK_INS_Soldier_4_EP1","TK_INS_Warlord_EP1_DZ"],["TK_INS_Soldier_AT_EP1","TK_INS_Warlord_EP1_DZ"],["TK_INS_Soldier_AAT_EP1","TK_INS_Warlord_EP1_DZ"],["TK_INS_Soldier_AA_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_AR_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_MG_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_Sniper_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_TL_EP1","TK_INS_Soldier_EP1_DZ"],["TK_INS_Soldier_Warlord_EP1","TK_INS_Soldier_EP1_DZ"]]
#define GUN_LIST 			"M4A1","M4A1_Aim","M4A1_Aim_camo","M4A1_HWS_GL_camo","M4A1_RCO_GL","M4A3_CCO_EP1","M4A3_RCO_GL_EP1","M16A2GL","M16a4","M16a4_acg","M16A4_GL","M16A4_ACG_GL","BAF_L85A2_UGL_Holo","BAF_L85A2_UGL_ACOG","BAF_L85A2_UGL_SUSAT","BAF_L86A2_ACOG","m8_carbine","m8_carbine_pmc","m8_carbineGL","m8_compact","m8_sharpshooter","m8_SAW","AKS_74_U","AKS_74_UN_kobra","AK_74_GL","AK_74_GL_kobra","AKS_74","AKS_74_kobra","AKS_74_pso","AK_107_kobra","AK_107_GL_kobra","AK_107_pso","AK_107_GL_pso","AK_47_M","AK_47_S","Sa58V_RCO_EP1","Sa58V_CCO_EP1","SVD","M40A3","M24_des_EP1","M24","M4SPR","M14_EP1","huntingrifle","M240_DZ","Mk_48_DZ","M249_EP1_DZ","M249_DZ","MG36","MG36_camo","RPK_74","bizon_silenced","bizon","MP5SD","MP5A5","Saiga12K","M1014","Remington870_lamp","LeeEnfield","Winchester1866","MR43","DMR","SVD_CAMO","VSS_vintorez","m240_scoped_EP1_DZE","M249_m145_EP1_DZE","Mk_48_DZ","M60A4_EP1_DZE","PK_DZ","AA12_PMC","M79_EP1","M4A1_AIM_SD_camo","MP5SD"

#define POWER_ARRAY		"Generator_DZ","MAP_PowerGenerator"
#define FUEL_ARRAY		"FuelPump_DZ","Land_A_FuelStation_Feed","Land_Ind_FuelStation_Feed_EP1","Land_FuelStation_Feed_PMC","Land_smd_benzina_schnell_open","Land_smd_fuelstation_army"
#define DZE_ISWRECK 	"SKODAWreck","HMMWVWreck","UralWreck","datsun01Wreck","hiluxWreck","datsun02Wreck","UAZWreck","Land_Misc_Garb_Heap_EP1","Fort_Barricade_EP1","Rubbish2"
#define DZE_AMMOTRADERS 	"FR_AR","MVD_Soldier_TL","CZ_Special_Forces_TL_DES_EP1","TK_Commander_EP1","RU_Farmwife1","Soldier_GL_PMC","Soldier_Sniper_KSVK_PMC","UN_CDF_Soldier_Guard_EP1"

#define GETVAR(O,N,D)			(O getVariable[#N,D])
#define GETPVAR(N,D)			GETVAR(player,N,D)
#define GETCVAR(N,D)			GETVAR(_character,N,D)
#define GETUVAR(N,D)			GETVAR(_unit,N,D)
#define GETOVAR(N,D)			GETVAR(_object,N,D)
#define GETCTVAR(N,D)			GETVAR(_cursorTarget,N,D)

#define SETVARS(O,N,V)			O setVariable[#N,V,true]
#define SETPVARS(N,V)			SETVARS(player,N,V)
#define SETOVARS(N,V)			SETVARS(_object,N,V)
#define SETCVARS(N,V)			SETVARS(_character,N,V)

#define GetID(O,N)				GETVAR(O,N,"0")
#define GetObjID(O)				GetID(O,ObjectID)
#define GetObjUID(O)			GetID(O,ObjectUID)
#define GetOwnerUID(O)			GetID(O,ownerPUID)
#define GetOwnerName(O)			GETVAR(O,OwnerName,"")
#define GetCharID(O)			GetID(O,CharacterID)
#define GetComment(O)			GETVAR(O,Comment,"")
#define GetHumanity(O)			GETVAR(O,humanity,0)
#define GetLostTime(O)			GETVAR(O,LostTime,0)

#define SetCharID(O,V)			SETVARS(O,CharacterID,V)
#define SetObjID(O,V)			SETVARS(O,ObjectID,V)
#define SetObjUID(O,V)			SETVARS(O,ObjectUID,V)
#define SetOwnerUID(O,V)		SETVARS(O,ownerPUID,V)
#define SetOwnerName(O,V)		SETVARS(O,OwnerName,V)
#define SetComment(O,V)			SETVARS(O,Comment,V)
#define SetHumanity(O,V)		SETVARS(O,humanity,V)
#define SetLostTime(O,V)		SETVARS(O,LostTime,V)

#define GetCash(O)				GETVAR(O,headShots,0)
#define GetBank(O)				GETVAR(O,bank,0)
#define SetCash(O,V)			SETVARS(O,headShots,V)
#define SetBank(O,V)			SETVARS(O,bank,V)


#define VAR_TOW IsTowing
#define VAR_INTOW InTow
#define VAR_VEHINTOW VehicleInTow
#define VAR_VEHTOW VehicleTow
#define VAR_CANNOTTOW CannotTow

#define GetTow(O)				GETVAR(O,VAR_TOW,false)
#define GetInTow(O)				GETVAR(O,VAR_INTOW,false)
#define GetVehInTow(O)			GETVAR(O,VAR_VEHINTOW,ObjNull)
#define GetVehTow(O)			GETVAR(O,VAR_VEHTOW,ObjNull)
#define GetCanNotTow(O)			GETVAR(O,VAR_CANNOTTOW,false)
#define SetTow(O,V)				SETVARS(O,VAR_TOW,V)
#define SetInTow(O,V)			SETVARS(O,VAR_INTOW,V)
#define SetVehInTow(O,V)		SETVARS(O,VAR_VEHINTOW,V)
#define SetVehTow(O,V)			SETVARS(O,VAR_VEHTOW,V)
#define SetCanNotTow(O,V)		SETVARS(O,VAR_CANNOTTOW,V)

#define QUOTE(var1) #var1
#define PATHTO_SYS(var1,var2) ##var1\##var2

#define PATHTO_SCRIPT(var1) 'PATHTO_SYS(SCRIPT_PATH,var1)'

#define SCRIPT_FILE(var1) QUOTE(PATHTO_SYS(SCRIPT_PATH,var1))

#define COMPILE_FILE_CFG_SYS(var1) compile preProcessFileLineNumbers var1
#define COMPILE_FILE_SYS(var1) COMPILE_FILE_CFG_SYS(var1)

#define COMPILE_FILE2_SYS(var1,var2) COMPILE_FILE_SYS('PATHTO_SYS(var1,var2)')

#define COMPILE_FILE(var1) COMPILE_FILE_CFG_SYS(QUOTE(var1))
#define COMPILE_SCRIPT_FILE(var1) COMPILE_FILE2_SYS(SCRIPT_PATH,var1)
#define COMPILE_CUSTOM_FILE(var1) COMPILE_FILE2_SYS(CUSTOM_PATH,var1)
#define COMPILE_CODE_FILE(var1) COMPILE_FILE2_SYS(\z\addons\dayz_code\compile,var1)
#define COMPILE_ACTION_FILE(var1) COMPILE_FILE2_SYS(\z\addons\dayz_code\actions,var1)

#define EXECVM_FILE_CFG_SYS(var1) execVM var1
#define EXECVM_FILE_SYS(var1) EXECVM_FILE_CFG_SYS(var1)
#define EXECVM_FILE2_SYS(var1,var2) EXECVM_FILE_SYS('PATHTO_SYS(var1,var2)')

#define EXECVM_SCRIPT(var1) EXECVM_FILE2_SYS(SCRIPT_PATH,var1)

#define EXECFSM_FILE_CFG_SYS(var1) execFSM var1
#define EXECFSM_FILE_SYS(var1) EXECFSM_FILE_CFG_SYS(var1)
#define EXECFSM_FILE2_SYS(var1,var2) EXECFSM_FILE_SYS('PATHTO_SYS(var1,var2)')

#define EXECFSM_SCRIPT(var1) EXECFSM_FILE2_SYS(SCRIPT_PATH,var1)

#define ACTION_EXEC(var1)	PATHTO_SCRIPT(comp_file.sqf),var1

#define PVT(A)				private #A
#define PVT1(A)				PVT(A)
#define PVT2(A,B)			private [#A,#B]
#define PVT3(A,B,C)			private [#A,#B,#C]
#define PVT4(A,B,C,D)		private [#A,#B,#C,#D]
#define PVT5(A,B,C,D,E)		private [#A,#B,#C,#D,#E]
#define PVT6(A,B,C,D,E,F)	private [#A,#B,#C,#D,#E,#F]

#define EXPLODE1(ARRAY,A)			A=(ARRAY) select 0
#define EXPLODE1_PVT(ARRAY,A)		PVT1(A);EXPLODE1(ARRAY,A)
#define EXPLODE2(ARRAY,A,B)			EXPLODE1(ARRAY,A);B=(ARRAY) select 1
#define EXPLODE2_PVT(ARRAY,A,B)		PVT2(A,B);EXPLODE2(ARRAY,A,B)
#define EXPLODE3(ARRAY,A,B,C)		EXPLODE2(ARRAY,A,B);C=(ARRAY) select 2
#define EXPLODE3_PVT(ARRAY,A,B,C)	PVT3(A,B,C);EXPLODE3(ARRAY,A,B,C)
#define EXPLODE4(ARRAY,A,B,C,D)		EXPLODE3(ARRAY,A,B,C);D=(ARRAY) select 3
#define EXPLODE4_PVT(ARRAY,A,B,C,D)	PVT4(A,B,C,D);EXPLODE4(ARRAY,A,B,C,D)
#define EXPLODE5(ARRAY,A,B,C,D,E)	EXPLODE4(ARRAY,A,B,C,D);E=(ARRAY) select 4
#define EXPLODE5_PVT(ARRAY,A,B,C,D,E)	PVT5(A,B,C,D);EXPLODE5(ARRAY,A,B,C,D,E)

#define PARAMS1PVT(A)			EXPLODE1_PVT(_this,A)
#define PARAMS2PVT(A,B)			EXPLODE2_PVT(_this,A,B)
#define PARAMS3PVT(A,B,C)		EXPLODE3_PVT(_this,A,B,C)
#define PARAMS4PVT(A,B,C,D)		EXPLODE4_PVT(_this,A,B,C,D)
#define PARAMS5PVT(A,B,C,D,E)	EXPLODE5_PVT(_this,A,B,C,D,E)

#define PARAMS1(A)			EXPLODE1(_this,A)
#define PARAMS2(A,B)		EXPLODE2(_this,A,B)
#define PARAMS3(A,B,C)		EXPLODE3(_this,A,B,C)
#define PARAMS4(A,B,C,D)	EXPLODE4(_this,A,B,C,D)
#define PARAMS5(A,B,C,D,E)	EXPLODE5(_this,A,B,C,D,E)

#define CONTROL				displayCtrl

#define addPVEH				addPublicVariableEventHandler

#define SEL(ARRAY,N)		(ARRAY select (N))
#define SEL0(X)				SEL(X,0)
#define SEL1(X)				SEL(X,1)
#define SEL2(X)				SEL(X,2)
#define SEL3(X)				SEL(X,3)
#define SEL4(X)				SEL(X,4)
#define SEL5(X)				SEL(X,5)
#define SEL6(X)				SEL(X,6)
#define SEL7(X)				SEL(X,7)
#define SEL8(X)				SEL(X,8)
#define SEL9(X)				SEL(X,9)

#define THIS0				SEL0(_this)
#define THIS1				SEL1(_this)
#define THIS2				SEL2(_this)
#define THIS3				SEL3(_this)
#define THIS4				SEL4(_this)
#define THIS5				SEL5(_this)
#define THIS6				SEL6(_this)
#define THIS7				SEL7(_this)
#define THIS8				SEL8(_this)

#define CNT(X)				(count (X))
#define RND(X)				((round(random 100))<=X)

#define CHECHKEY(K,A)		(K in actionKeys #A)

#define ANIMATION_MEDIC(checkCombat) \
	player playActionNow "Medic";_animState=animationState player;\
	r_interrupt=false;r_doLoop=true;_started=false;_finished=false;\
	while {r_doLoop}do{\
		_animState=animationState player;\
		_isMedic=["medic",_animState] call fnc_inString;\
		if (_isMedic)then{_started=true;};\
		if (_started && !_isMedic)then{\
			if ((["amovpknlmstp",_animState] call fnc_inString))then{ r_doLoop=false;_finished=true;}else{r_interrupt=true;};\
		};\
		if (r_interrupt)then{r_doLoop=false;};\
		if (checkCombat)then{if (GETPVAR(combattimeout,0)>=time)then{r_doLoop = false;};};\
		sleep 0.1;\
	};\
	r_doLoop=false;\
	if (!_finished)then{\
		r_interrupt=false;\
		if (vehicle player==player)then{\
			cutText ["Действие отменено.", "PLAIN DOWN"];\
			[objNull,player,rSwitchMove,""] call RE;\
			player playActionNow "stop";\
		};\
	};

#define getNearObj(P,N,D) ((P) nearEntities [N, D])
#define getNear(P,N,D) ((P) nearEntities [N, D])
#define getNearPlots(P,D) ((P) nearEntities ["Plastic_Pole_EP1_DZ",D])
#define getNearestPlots(P,D) (nearestObjects [(P),["Plastic_Pole_EP1_DZ"],D])

#define UpdateObj(O,M)	[O,#M]call fnc_serverUpdateObject
#define UpdateAll(O)	UpdateObj(O,all)
#define UpdateGear(O)	UpdateObj(O,gear)
#define UpdateAccess(O)	UpdateObj(O,access)

#define VehicleLock(V)		([V,true] call vehicle_lockUnlock)
#define VehicleUnlock(V)	([V,false] call vehicle_lockUnlock)

#define InVeh(O) (vehicle (O)!=(O))
#define NotInVeh(O) (vehicle (O)==(O))

#define MSG_BUSY "Я занят..."
#define MSG_CANCEL "Действие отменено"

#define CheckActionInProgress(Msg) if(DZE_ActionInProgress)exitWith{cutText [(Msg),"PLAIN DOWN"];};DZE_ActionInProgress=true
#define CheckActionInProgressLocalize(MsgID) if(DZE_ActionInProgress)exitWith{cutText [(localize #MsgID),"PLAIN DOWN"];};DZE_ActionInProgress=true

#define BreakActionInProgress(Msg) DZE_ActionInProgress=false;cutText [(Msg),"PLAIN DOWN"]
#define BreakActionInProgress1(Fmt,P1) DZE_ActionInProgress=false;cutText [format[Fmt,P1],"PLAIN DOWN"]
#define BreakActionInProgress2(Fmt,P1,P2) DZE_ActionInProgress=false;cutText [format[Fmt,P1,P2],"PLAIN DOWN"]
#define BreakActionInProgressLocalize(MsgID) DZE_ActionInProgress=false;cutText [(localize #MsgID),"PLAIN DOWN"]
#define BreakActionInProgressLocalize1(MsgID,P1) DZE_ActionInProgress=false;cutText [format[(localize #MsgID),P1],"PLAIN DOWN"]
#define BreakActionInProgressLocalize2(MsgID,P1,P2) DZE_ActionInProgress=false;cutText [format[(localize #MsgID),P1,P2],"PLAIN DOWN"]

#define DamageEnable(O) (O) allowDamage true;(O) RemoveAllEventHandlers "handleDamage";(O) addEventHandler ["handleDamage",{_this call vehicle_handleDamage}]

#define DamageDisable(O) (O) allowDamage false;(O) RemoveAllEventHandlers "handleDamage";(O) addEventHandler ["handleDamage",{false}]

// Должно быть последним для приоритета локальных настроек сервера перед глобальными
#include "localdef.h"
