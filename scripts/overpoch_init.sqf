/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
	
	Скрипт инициализации для серверов Overpoch
*/
#include "defines.h"

if (isServer) then {
	_nul = [] EXECVM_SCRIPT(blowout_server.sqf);
};
if (!isDedicated) then {
	_nul = [] EXECVM_SCRIPT(blowout_client.sqf);
};
