/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_status","_vehicle","_upgrade0","_upgrade1","_upgrade2","_upgrade3","_menu_upgrade0","_menu_upgrade1","_menu_upgrade2","_menu_upgrade3"];
_vehicle=THIS3;
_status=_vehicle getVariable ["Upgrade",[0,0,0,0]];;
VehToDowngrade = _vehicle;

EXPLODE4(_status,_upgrade0,_upgrade1,_upgrade2,_upgrade3);	
if (_upgrade0==0)then{_menu_upgrade0="0";}else{_menu_upgrade0="1";};
if (_upgrade1==0)then{_menu_upgrade1="0";}else{_menu_upgrade1="1";};
if (_upgrade2==0)then{_menu_upgrade2="0";}else{_menu_upgrade2="1";};
if (_upgrade3==0)then{_menu_upgrade3="0";}else{_menu_upgrade3="1";};

Ori_downgrade_menu =
[
	["",false],
		["Снять бампер",     [2],  "", -5, [["expression",				"[0] execVM 'scripts\downgrade.sqf';"]], "1", _menu_upgrade0],
		["Снять защиту колес", [3],  "", -5, [["expression",			"[1] execVM 'scripts\downgrade.sqf';"]], "1", _menu_upgrade1],
		["Снять защиту боковых стекол", [4],  "", -5, [["expression",	"[2] execVM 'scripts\downgrade.sqf';"]], "1", _menu_upgrade2],
		["Снять защиту ветрового стекла", [5],  "", -5, [["expression",	"[3] execVM 'scripts\downgrade.sqf';"]], "1", _menu_upgrade3],

		["", [-1], "", -5, [["expression", ""]], "1", "0"],
		["Выход", [6], "", -5, [["expression", "VehToDowngrade = nil;"]], "1", "1"]
];
showCommandingMenu "#USER:Ori_downgrade_menu";