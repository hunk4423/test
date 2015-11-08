/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_nul","_itemwater","_eat_mre","_abort","_num_removedW","_havewater","_gorged","_eat_chips","_onLadder","_itemorignal","_hasfooditem","_rawfood","_hasoutput","_config","_text","_regen","_dis","_sfx","_itemtodrop","_nearByPile","_item","_display","_rawexceptions","_badfood","_invehicle"];

disableserialization;
call gear_ui_init;
if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};
if(dayz_hunger < 100) exitWith {cutText ["Я не голоден, поем позже...","PLAIN DOWN"]};
if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
_itemorignal = _this;
_hasfooditem = _itemorignal in magazines player;
if (!_hasfooditem) exitWith {cutText [format[(localize "str_player_31"),_text,"consume"] , "PLAIN DOWN"]};
DZE_ActionInProgress = true;

_rawfood = _itemorignal in meatraw;
_rawexceptions = _itemorignal in exceptionsraw;
//_cookedfood = _itemorignal in meatcooked;
_hasoutput = _itemorignal in food_with_output;

_badfood = _itemorignal in badfood;
_num_removedW = 0;
_config =   configFile >> "CfgMagazines" >> _itemorignal;
_text = 	getText (_config >> "displayName");
_regen = 	getNumber (_config >> "bloodRegen");
_gorged = true;
_eat_chips = false;
_eat_mre = false;
_abort = false;
_havewater = false;
_invehicle = false;
closeDialog 1;

if (vehicle player != player) then {_invehicle = true;};
if !(_invehicle) then {player playMove "AinvPknlMstpSlayWrflDnon_healed";}; 

if (["FoodPumpkin",_itemorignal] call fnc_inString) then {
	_eat_chips = true;
};  

if (["FoodSunFlowerSeed",_itemorignal] call fnc_inString) then {
	_eat_chips = true;
}; 
 
if (["FoodNutmix",_itemorignal] call fnc_inString) then {
	_eat_chips = true;
};  

if (["FoodPistachio",_itemorignal] call fnc_inString) then {
	_eat_chips = true;
}; 

if (["FoodMRE",_itemorignal] call fnc_inString) then {
	_eat_chips = true;
	_eat_mre = true;

	//нет фляжки
	if !(("ItemWaterbottle" in magazines player) or ("ItemWaterbottleBoiled" in magazines player)) then {
		cutText ["Нет фляжки с водой, придётся кушать в сухомятку...", "PLAIN DOWN"]; 
		_nul = [objNull, player, rSAY, "eat_chips", 5] call RE;
	} else {
		//Есть фляжка
		_havewater = true;
		[player,"drink",0,false,6] call dayz_zombieSpeak;
	};

	//есть не кипеченная	
	if !("ItemWaterbottleBoiled" in magazines player) then {
		if ("ItemWaterbottle" in magazines player) then {cutText ["Эх, вода не кипячёная, не заразиться бы...", "PLAIN DOWN"]; };
	};
};

//звук. хрустим чипсами
if (_eat_chips and !_eat_mre) then {
	_nul = [objNull, player, rSAY, "eat_chips", 5] call RE;
};

//звук. едим мягкую еду
if !(_eat_chips and _eat_mre) then {
	[player,"eat",0,false,6] call dayz_zombieSpeak;
};
	
[player,10,true,(getPosATL player)] spawn player_alertZombies;

r_interrupt = false;
_animState = animationState player;
r_doLoop = true;
_started = false;
_finished = false;
 
while {r_doLoop} do {
	_animState = animationState player;
	_isDrink = ["AinvPknlMstpSlayWrflDnon_healed", _animState] call fnc_inString;
	if (_isDrink) then {
		_started = true;
	};
	if (_started and !_isDrink) then {
		r_doLoop = false;
		_finished = true;
	};
	if (r_interrupt) then {
		r_doLoop = false;
	};
	if (_invehicle) then {
		sleep 6;
		r_doLoop = false;
		_finished = true;
	};
	sleep 0.1;
};
r_doLoop = false;

if (_finished) then {
	//anti-duping
	_num_removed = ([player,_itemorignal] call BIS_fnc_invRemove);
	if!(_num_removed == 1) exitWith {cutText ["Ошибка!", "PLAIN DOWN"];DZE_ActionInProgress = false;}; 

	if (_havewater and _eat_mre) then {
		[player,"eat",0,false,6] call dayz_zombieSpeak;
		if ("ItemWaterbottle" in magazines player) then {_itemwater ="ItemWaterbottle";};
		if ("ItemWaterbottleBoiled" in magazines player) then {_itemwater ="ItemWaterbottleBoiled";};
		_num_removedW = ([player,_itemwater] call BIS_fnc_invRemove);
		
		if ((RND(50)) and (_itemwater == "ItemWaterbottle")) then {
			r_player_infected = true;
			player setVariable["USEC_infected",true,true];
		};
	};
	
	if(_num_removedW == 1) then {
		player addMagazine "ItemWaterbottleUnfilled";
	};	
	
	if (!(_num_removedW == 1) and (_havewater)) exitWith {
		cutText ["Ошибка!", "PLAIN DOWN"];
		DZE_ActionInProgress = false;
	};

	if (_hasoutput and !_invehicle) then {
		// Selecting output
		_itemtodrop = food_output select (food_with_output find _itemorignal);
		_nearByPile= nearestObjects [(getposATL player), ["WeaponHolder","WeaponHolderBase"],2];
		if (count _nearByPile ==0) then { 
			_iPos = getPosATL player;
			_item = createVehicle ["WeaponHolder", _iPos, [], 0, "CAN_COLLIDE"];
			_item setposATL _iPos;
		} else {
			_item = _nearByPile select 0;
		};
		_item addMagazineCargoGlobal [_itemtodrop,1];
	} else {
	//trash in a car
	};


	if (_rawfood and !_rawexceptions and (random 15 < 1)) then {
		r_player_infected = true;
		player setVariable["USEC_infected",true,true];
	};

	if (_badfood and (random 2 < 1)) then {
		r_player_infected = true;
		player setVariable["USEC_infected",true,true];
	};

	if (_eat_mre) then {
		_eat_chips = false;
		_gorged = false;
	
		if (_havewater) then {
			[3000+(random 500)] spawn fnc_usec_addBlood;
			dayz_hunger = 0;
			dayz_thirst = 0;
		} else {
			dayz_hunger = 0;
			dayz_thirst = dayz_thirst + 250;
			[300+(random 100)] spawn fnc_usec_addBlood;
		};
	} else {
		[_regen+(random 500)] spawn fnc_usec_addBlood;
	};

	if (_eat_chips) then {
		if (dayz_hunger >= 500) then {
			dayz_hunger = dayz_hunger - 500;
			_gorged = false;
		};
		dayz_thirst = dayz_thirst + 250;
	};  

	if (_gorged) then {
		dayz_hunger = 0;
	};

	player setVariable ["messing",[dayz_hunger,dayz_thirst],true];
	player setVariable["USEC_BloodQty",r_player_blood,true];
	player setVariable["medForceUpdate",true];
	//["PVDZE_plr_Save",[player,[],true]] call callRpcProcedure;
	PVDZE_plr_Save = [player,[],true,true];
	publicVariableServer "PVDZE_plr_Save";

	//Ensure Control is visible
	_display = uiNamespace getVariable 'DAYZ_GUI_display';
	(_display displayCtrl 1301) ctrlShow true;
//
	if (r_player_blood / r_player_bloodTotal >= 0.2) then {
		(_display displayCtrl 1300) ctrlShow true;
	};
//
	cutText [format[(localize  "str_player_consumed"),_text], "PLAIN DOWN"];
	DZE_ActionInProgress = false;
} else {
	r_interrupt = false;
	DZE_ActionInProgress = false;
	if (vehicle player == player) then {
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		cutText ["Я еще не доел!", "PLAIN DOWN"];
	};
};