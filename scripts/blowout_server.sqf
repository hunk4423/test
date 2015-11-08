/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
/*
 **  BLOWOUT MODULE - Nightstalkers: Shadow of Namalsk
 *   ..created by Sumrak, ©2010
 *   http://www.nightstalkers.cz
 *   sumrak<at>nightstalkers.cz
 *   PBO edition
 *   SERVER-SIDE script 
*/

private["_emp_tg_namalsk"];

// init
ns_blowout = false; 
if (RND(40)) then {
	ns_blowout = true; 
};
publicVariable "ns_blowout";

if(ns_blowout)then{
	_emp_tg_namalsk = 0;
	ns_blow_prep = false;
	publicVariable "ns_blow_prep";
	ns_blow_status = false; 
	publicVariable "ns_blow_status";
 
	SleepBlowOut = ((random 10000) +2000);
	sleep SleepBlowOut;

	// Preparations before blowout - APSI / players running to take a cover
	ns_blow_prep = true;
	publicVariable "ns_blow_prep";
	sleep 165;
	ns_blow_prep = false;
	publicVariable "ns_blow_prep";

	// main blowout variable - 1 == blowout in progress, 0 == no current blowout
	ns_blow_status = true;
	publicVariable "ns_blow_status";

	ns_blow_action = true;
	publicVariable "ns_blow_action";

	sleep 48;

	ns_blow_action = false;
	publicVariable "ns_blow_action";

	sleep 25;
	ns_blow_status = false; 
	publicVariable "ns_blow_status";
	ns_blowout = false; 
};