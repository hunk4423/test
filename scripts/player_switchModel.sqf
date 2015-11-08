#include "defines.h"
private ["_hight","_obj","_SplintWound","_oldGroup","_savedGroup","_humanity","_weapons","_backpackWpn","_backpackMag","_currentWpn","_backpackWpnTypes","_backpackWpnQtys","_countr","_class","_position","_dir","_currentAnim","_tagSetting","_playerUID","_countMags","_magazines","_primweapon","_secweapon","_newBackpackType","_muzzles","_oldUnit","_group","_newUnit","_playerObjName","_wpnType","_ismelee"];
disableSerialization;
//Старт заставки
startLoadingScreen ["Смена скина", "DayZ_loadingScreen"];
call dayz_forceSave;
//заставка
progressLoadingScreen 0.2;

_class 			= _this;
#ifdef _SAHRANI
if(_class == "Survivor2_DZ")then{
	_class=["smd_civ1_pants","smd_civ2_pants","smd_civ3_pants","smd_civ4_pants","smd_civ5_pants","smd_civ6_pants","smd_civ7_pants","smd_civ1_shorts","smd_civ2_shorts","smd_civ3_shorts","smd_civ4_shorts","smd_civ5_shorts","smd_civ6_shorts","smd_civ7_shorts"] call BIS_fnc_selectRandom;
};
#endif
_position 		= getPosATL player;
_hight=[_position select 0,_position select 1,2500];
_obj=createVehicle["MetalFloor_DZ",_hight,[],0,"CAN_COLLIDE"];
_obj setPos _hight;
player setPosATL [_hight select 0,_hight select 1,2501];

_dir 			= getDir player;
_currentAnim 	= animationState player;
_tagSetting = player getVariable["DZE_display_name",false];
_playerUID = getPlayerUID player;
_weapons 	= weapons player;
_zupaMags = magazines player;
_countMags = call player_countMagazines; 
_magazines = _countMags select 0;
_cashMoney = player getVariable["cashMoney",0];
_bankMoney = player getVariable["bankMoney",0];
_cashMoney2 = player getVariable["headShots",0];
_bankMoney2 = player getVariable["bank",0];
_humanity = player getVariable["humanity",0];
_cId = player getVariable["CharacterID",0];
_SplintWound = player getVariable["SplintWound",0];

if ((_playerUID == dayz_playerUID) && (count _magazines == 0) && (count (magazines player) > 0 )) exitWith {cutText [(localize "str_epoch_player_17"), "PLAIN DOWN"]};

_primweapon	= primaryWeapon player;
_secweapon	= secondaryWeapon player;

if(!(_primweapon in _weapons) && _primweapon != "") then {
	_weapons = _weapons + [_primweapon];
};

if(!(_secweapon in _weapons) && _secweapon != "") then {
	_weapons = _weapons + [_secweapon];
};


//BackUp Backpack
dayz_myBackpack = unitBackpack player;
_newBackpackType = (typeOf dayz_myBackpack);
if(_newBackpackType != "") then {
	_backpackWpn = getWeaponCargo unitBackpack player;
	_backpackMag = _countMags select 1;
};

//Get Muzzle
_currentWpn = currentWeapon player;
_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
if (count _muzzles > 1) then {
	_currentWpn = currentMuzzle player;
};

//Secure Player for Transformation
player setPosATL dayz_spawnPos;

//BackUp Player Object
_oldUnit = player;
_oldGroup = group player;

/**********************************/
//DONT USE player AFTER THIS POINT//
/**********************************/

//Create New Character
_group 		= createGroup west;
_newUnit 	= _group createUnit [_class,dayz_spawnPos,[],0,"NONE"];
[_newUnit] joinSilent createGroup WEST;
_newUnit 	setPosATL _position;
_newUnit 	setDir _dir;

//Clear New Character
removeAllWeapons _newUnit;
removeAllItems _newUnit;
removebackpack _newUnit;

//загрузка
progressLoadingScreen 0.4;

//Equip New Charactar
{
	if (typeName _x == "ARRAY") then {if ((count _x) > 0) then {_newUnit addMagazine [(_x select 0), (_x select 1)]; }; } else { _newUnit addMagazine _x; };
} count _magazines;

{
	_newUnit addWeapon _x;
} count _weapons;

//Check && Compare it
if(str(_weapons) != str(weapons _newUnit)) then {
	//Get Differecnce
	{
		_weapons = _weapons - [_x];
	} count (weapons _newUnit);
	
	//Add the Missing
	{
		_newUnit addWeapon _x;
	} count _weapons;
};

if(_primweapon !=  (primaryWeapon _newUnit)) then {
	_newUnit addWeapon _primweapon;		
};
if (_primweapon == "MeleeCrowbar") then {
	_newUnit addMagazine 'crowbar_swing';
};
if (_primweapon == "MeleeSledge") then {
	_newUnit addMagazine 'sledge_swing';
};
if (_primweapon == "MeleeHatchet_DZE") then {
	_newUnit addMagazine 'Hatchet_Swing';
};
if (_primweapon == "MeleeMachete") then {
	_newUnit addMagazine 'Machete_swing';
};
if (_primweapon == "MeleeFishingPole") then {
	_newUnit addMagazine 'Fishing_Swing';
};

if(_secweapon != (secondaryWeapon _newUnit) && _secweapon != "") then {
	_newUnit addWeapon _secweapon;		
};

if(isNil "_cashMoney")then{_cashMoney = 0;};
if(isNil "_bankMoney")then{_bankMoney = 0;};
if(isNil "_cashMoney2")then{_cashMoney2 = 0;};
if(isNil "_bankMoney2")then{_bankMoney2 = 0;};
//загрузка
progressLoadingScreen 0.6;

_newUnit setVariable ["cashMoney",_cashMoney,true];
_newUnit setVariable ["bankMoney",_bankMoney];

_newUnit setVariable ["headShots",_cashMoney2,true];
_newUnit setVariable ["bank",_bankMoney2];

_newUnit setVariable["CharacterID",_cId,true];

_switchUnit = {
	addSwitchableUnit _newUnit;
	setPlayable _newUnit;
	selectPlayer _newUnit;
	if ((count units _oldGroup > 1) && {!isNil "PVDZE_plr_LoginRecord"}) then {
		[_newUnit] join _oldGroup;
		if (count units _group < 1) then {deleteGroup _group;};
	};	
	removeAllWeapons _oldUnit;
	{_oldUnit removeMagazine _x;} count  magazines _oldUnit;
	deleteVehicle _oldUnit;
	deleteVehicle _obj;
	if(_currentWpn != "") then {_newUnit selectWeapon _currentWpn;};
};

//Add && Fill BackPack
removeBackpack _newUnit;		

if (!isNil "_newBackpackType") then {
	if (_newBackpackType != "") then {	
		_newUnit addBackpack _newBackpackType;
		dayz_myBackpack = unitBackpack _newUnit;
		//Weapons
		_backpackWpnTypes = [];
		_backpackWpnQtys = [];
		if (count _backpackWpn > 0) then {
			_backpackWpnTypes = _backpackWpn select 0;
			_backpackWpnQtys = _backpackWpn select 1;
		};
		[] call _switchUnit;
		if (gear_done) then {sleep 0.001;};
		["1"] call gearDialog_create;
		//magazines
		_countr = 0;
		{
			if (!(isClass(configFile >> "CfgWeapons" >> _x))) then {
				_countr = _countr + 1;
				if ((typeName _x) != "STRING") then {
					(unitBackpack player) addMagazineCargoGlobal [(_x select 0), 1];
					_idc = 4999 + _countr;
					_idc setIDCAmmoCount (_x select 1);
				} else {
					(unitBackpack player) addMagazineCargoGlobal [_x, 1];
				};
			};
		} count _backpackMag;
		(findDisplay 106) closeDisplay 0;
		_countr = 0;
		{
			(unitBackpack player) addWeaponCargoGlobal [_x,(_backpackWpnQtys select _countr)];
			_countr = _countr + 1;
		} count _backpackWpnTypes;
	} else { [] call _switchUnit; };
} else { [] call _switchUnit; };
[objNull, player, rSwitchMove,_currentAnim] call RE;
player disableConversation true;

{
if( !(_x in _weapons))then {
[_x] call player_checkAndRemoveItems;
};
}count (weapons player);
{
if( !(_x in _zupaMags))then {
[_x] call player_checkAndRemoveItems;
};
}count (magazines player);

//player setVariable ["bodyName",dayz_playerName,true]; //Outcommit (Issue #991) - Also removed in DayZ Mod 1.8

//загрузка
progressLoadingScreen 0.8;

player setVariable ["cashMoney",_cashMoney,true];
player setVariable ["bankMoney",_bankMoney];
player setVariable ["headShots",_cashMoney2,true];
player setVariable ["bank",_bankMoney2];
player setVariable ["CharacterID",_cId,true];
player setVariable ["humanity",_humanity,true];
player setVariable ["SplintWound",_SplintWound,true];

if (_tagSetting) then {
	DZE_ForceNameTags = true;
};



_playerUID = getPlayerUID player;
_playerObjName = format["PVDZE_player%1",_playerUID];
call compile format["%1 = player;",_playerObjName];
publicVariableServer _playerObjName; //Outcommit in DayZ 1.8 No clue for what this is - Skaronator

//melee check
_wpnType = primaryWeapon player;
_ismelee = (gettext (configFile >> "CfgWeapons" >> _wpnType >> "melee"));
if (_ismelee == "true") then {
	call dayz_meleeMagazineCheck; 
};

//reveal the same objects we do on login
{player reveal _x} count (nearestObjects [getPosATL player, dayz_reveal, 50]);

//Загрузка
progressLoadingScreen 1.0;
endLoadingScreen;
if!(isNil "Skin_MSG")then{systemChat format ["Вы сменили скин на: %1",(typeOf player)];};Skin_MSG=true;
cutText ["\n\n Вы сменили скин на: " + (typeOf player), "PLAIN DOWN"];

_savedGroup = profileNamespace getVariable["savedGroup",[]];
player setVariable ["savedGroup",_savedGroup,true];
player setVariable ["purgeGroup",0,true];