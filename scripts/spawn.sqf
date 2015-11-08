/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_value","_WelcomeCamera","_showRules","_vip_mode","_vip_spawn","_humanity","_UID","_coins","_spawnPoints","_price","_alt","_ok1","_ok","_ok3","_position","_findSpot","_isNear","_isZero","_counter","_seldLoc","_animal","_fire","_pos"];

on_the_ground = false;
_vip_spawn = false;
_vip_mode=0;
_coins=PLAYER_START_MONEY;
VipSpawnSelect = -1;
_humanity=GetHumanity(player);
_showRules=true;
_WelcomeCamera=true;
#ifdef _CHERNORUS
cutText ["","BLACK OUT",0];
#endif

call {	
  if (_humanity<5000)exitWith{_value=0;};
  if (_humanity<10000)exitWith{_value=0.015;};
  if (_humanity<20000)exitWith{_value=0.01;};
  if (_humanity<40000)exitWith{_value=0.005;};
  if (_humanity>40000)exitWith{_value=0.0025;};
	_value=0;
};
[player,-(_humanity*_value),0] call player_humanityChange;

//Donat spawn config
_UID = (getPlayerUID player);
{
	if (_UID==SEL0(_x)) exitWith {
		_vip_mode=SEL1(_x);
		_ok1 = createDialog "vip_spawn_Dialog";
		waitUntil {VipSpawnSelect != -1};
		if (VipSpawnSelect == 0)then{
			player setPosATL SEL2(_x);
			_vip_spawn=true;
		};
	};
}forEach PremiumList;

if (_vip_spawn && _vip_mode==1)then{
	removeAllWeapons player;removeBackpack player;removeAllItems player;
	player addmagazine "ItemBandage";
	player addweapon "ItemMap";
	_coins=0;
};
#ifdef _OVERPOCH
if (_vip_spawn && _vip_mode==3)then{
	//специальный респавн для игрока lann
	removeBackpack player;
	player addBackpack "DZ_LargeGunBag_EP1";
	player removeMagazine "FoodBioMeat";
	player addMagazine "PartGeneric";
	_coins=PLAYER_START_MONEY;
};
#endif
[player,_coins] call SC_fnc_addCoins;

if (_vip_spawn)exitWith{
	#ifdef _CHERNORUS
	cutText ["","BLACK IN"];
	#endif
	systemChat format["Добро пожаловать домой %1!", name player];
};

call{
	if (_humanity<5000)exitWith{
		_ok=createDialog "DRN_DIALOG_N";
		player addmagazine "ItemLetter";
		player removeWeapon "ItemMap";
		player addWeapon 'ItemGPS';
	};
	if (_humanity>5000)then{
		_ok=createDialog "DRN_DIALOG_Y";
		player removeMagazine "FoodBioMeat";
	};
	if (_humanity>10000)then{
		_showRules=false;
	};
	if (_humanity>40000)then{
		_WelcomeCamera=false;
#ifdef _OVERPOCH
		player removeWeapon "vil_AK_74m_gp";
		player removeMagazine "vil_45Rnd_545x39_AK";
		player removeMagazine "vil_45Rnd_545x39_AK";
		player removeMagazine "1Rnd_HE_GP25";
		player addmagazine "RH_8Rnd_762_tt33";
#else
		player removeWeapon "AKS_74_U";
		player addmagazine "8Rnd_9x18_Makarov";
		player removeMagazine "30Rnd_545x39_AK";
		player removeMagazine "30Rnd_545x39_AK";
#endif		
	};
};

spawnSelect = -1;
waitUntil {spawnSelect != -1};
_cpawncnt=count DZE_spawnPoints;
if (spawnSelect == _cpawncnt) then {spawnSelect = floor (random (_cpawncnt-1))};

_seldLoc = (SEL(DZE_spawnPoints,spawnSelect)) call BIS_fnc_selectRandom;

_findSpot = true;
_counter = 0;
while {_findSpot and _counter < 20} do {
	_position = ([(_seldLoc),0,250,0,0,0,0] call BIS_fnc_findSafePos);
	_isNear = count (_position nearEntities ["Man",100]) == 0;
	_isZero = ((_position select 0) == 0) and ((_position select 1) == 0);
	_counter = _counter + 1;
	if (_isNear and !_isZero) then {_findSpot = false};
};
_position set [2,0];

//halo
_ok3 = createDialog "E_Halo_Dialog";
haloSelect = -1;
waitUntil {haloSelect != -1};

if (haloSelect>0)then{
	_bank = GETPVAR(bank,0);
	//За 5000р, возможен креди в 3000
	if (_bank >= HALO_MIN_BANK)then{
		_prices=SEL([HALO_PRICE],(haloSelect-1));
		EXPLODE2(_prices,_alt,_price);
		player setPosATL [SEL0(_position),SEL1(_position),_alt];
		[player,_alt] spawn BIS_fnc_halo;
		SETPVARS(bank,(_bank-_price));
		SETPVARS(bankchanged,1);
		systemChat "Удачной игры!";
	} else {
		systemChat format["Не достаточно средств для высадки с парашюта! Надо иметь на банковском счету не менее %1 руб.",[HALO_MIN_BANK] call BIS_fnc_numberText];
		haloSelect = 0;
	};
};

[] EXECVM_SCRIPT(Server_WelcomeCredits2.sqf);


if ((haloSelect==0)&&(_WelcomeCamera))then{
	playSound "introsong";
	
	//эффект на жопе с костром
	isPlayerSpawn=true;
	player setPosATL _position;
	player playActionNow "SitDown";
	_animal=["Hen","Cock","Goat01_EP1","Goat02_EP1","Goat","Sheep","Sheep02_EP1","Sheep01_EP1","WildBoar","Rabbit"] call BIS_fnc_selectRandom;
	_fire="Land_Fire_DZ" createVehicle (position player);
	_fire attachto [player,[0,1.7,0]];
	_animal=createAgent [_animal,position player,[],0,"NONE"]; 
	_animal setDamage 1;
	_animal attachto [player,[1.5,0,0]];
	sleep 1;	
	detach _fire;
	detach _animal;	
	_pos=getPosATL _fire;
	_pos set [2,0];
	_fire setPosATL _pos;	
	_pos=getPosATL _animal;
	_pos set [2,0];
	_animal setPosATL _pos;
#ifdef _CHERNORUS
	cutText ["","BLACK IN",4];
#endif

	//camera
	_camDistance = 100;
	showCinemaBorder false;
	camUseNVG false;
	_position=position player;
	_camera = "camera" camCreate [SEL0(_position)-100*sin (round(random 359)), SEL1(_position)-100*cos (round(random 359)),SEL2(_position)+_camDistance];
	_fire inflame true;
	_camera cameraEffect ["internal","back"];
	_camera camSetFOV 1.0;
	_camera camCommit 0;
	waitUntil {camCommitted _camera};
	_camera camSetTarget vehicle player;
	_camera camSetRelPos [0,0,2];
	_camera camCommit 12;
	while {!(camCommitted _camera)}do{
		{ deletevehicle _x;} forEach nearestObjects [getpos player, ["zZombie_base"], 80];
		sleep 1;
	};
	_camera cameraEffect ["terminate","back"];
	camDestroy _camera;	
}else{
	player setPosATL _position;
#ifdef _CHERNORUS
	cutText ["","BLACK IN"];
#endif
};

if (haloSelect==0)then{
	if(_showRules)then{[] EXECVM_SCRIPT(rules.sqf);};
	systemChat ("Удачной игры!");
	if(_WelcomeCamera)then{
		sleep 20;
		isPlayerSpawn = false;
		sleep 160;
		deleteVehicle _fire;
	};
};