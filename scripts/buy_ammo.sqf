/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_rifle","_currentWeapon","_mag","_price","_rc","_textMag","_textWeap","_msg"];
{player removeAction _x} count s_player_GK_actions;s_player_GK_actions=[];s_player_GK_actions_ctrl=false;
if(hasGutsOnHim)exitWith{cutText ["Ну и запах! Я не хочу иметь с тобой никаких дел!", "PLAIN DOWN"];};
CheckActionInProgressLocalize(str_epoch_player_63);

_currentWeapon = currentWeapon player;
if (_currentWeapon=="")exitWith{BreakActionInProgress("Ну что можно продать безоружному скитальцу? Чупа-чупса у меня нет...")};
_rifle=(_currentWeapon == (primaryWeapon player));
if (_rifle) then {_price = 200;} else {_price = 30;};
_mag=(getArray (configFile >> "CfgWeapons" >> _currentWeapon >> "magazines")) select 0;

call {
#ifdef _OVERPOCH
	if(_mag == "USSR_5Rnd_408")			exitWith {_price=400};
#endif
	if(_mag == "Strela")				exitWith {_price=2000};
	if(_mag == "Stinger")				exitWith {_price=2000};
	if(_mag == "MAAWS_HEAT")			exitWith {_price=1000};
	if(_mag == "5Rnd_86x70_L115A1")		exitWith {_price=500};
	if(_mag == "5Rnd_127x99_as50")		exitWith {_price=500};
	if(_mag == "10Rnd_127x99_m107")		exitWith {_price=500};
	if(_mag == "100Rnd_762x51_M240")	exitWith {_price=300};
	if(_mag == "100Rnd_762x54_PK")		exitWith {_price=300};
	if(_mag == "200Rnd_556x45_M249")	exitWith {_price=300};
	if(_mag == "6Rnd_HE_M203")			exitWith {_price=1500};
	if(_mag == "20Rnd_B_AA12_HE")		exitWith {_price=300};
	if(_mag == "30Rnd_556x45_Stanag")	exitWith {_price=70};
	if(_mag == "30Rnd_545x39_AK")		exitWith {_price=70};
	if(_mag == "30Rnd_556x45_G36")		exitWith {_price=70};
	if(_mag == "30Rnd_762x39_AK47")		exitWith {_price=100};
	if(_mag == "8Rnd_9x18_MakarovSD")	exitWith {_price=50};
	if(_mag == "15Rnd_9x19_M9SD")		exitWith {_price=100};
	if(_mag == "30Rnd_9x19_UZI_SD")		exitWith {_price=100};
	if(_mag == "10Rnd_762x54_SVD")		exitWith {_price=100};
	if(_mag == "20Rnd_762x51_DMR")		exitWith {_price=100};
};

_rc=[player,_price] call fnc_Payment;
_msg=[_rc] call fnc_PaymentResultToStr;
if (SEL0(_rc)) then {
	player addMagazine _mag;
	_textMag = getText(configFile >> "CfgMagazines" >> _mag >> "displayName");
	_textWeap = getText(configFile >> "CfgWeapons" >> _currentWeapon >> "displayName");
	systemChat format ["Оружие %1: Куплено %2 (%3) за %4 руб. %5.",_textWeap,_textMag,_mag,_price,_msg];
} else {
	systemChat _msg;
};

DZE_ActionInProgress = false;
