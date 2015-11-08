/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT4(_array,_unit,_medic,_isDead);
EXPLODE2(_this,_unit,_medic);

_isDead = _unit getVariable["USEC_isDead",false];

if (local _unit) then {_unit setCaptive false};

if (!_isDead) then {
	_unit switchMove "AmovPpneMstpSnonWnonDnon_healed";
	//no need to public broadcast the variables since this runs on every peer
	_unit setVariable ["NORRN_unconscious", false, false];
	_unit setVariable ["USEC_isCardiac",false, false];
	if (_unit == player) then {
		r_player_unconscious = false;
		disableUserInput false;
		r_player_cardiac = false;
		r_player_handler1 = false;

		[] EXECVM_SCRIPT(color_epi.sqf);
	};
};
