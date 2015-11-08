/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT1(_skins);
lbClear 20014;
VehicleForChengeSkin=THIS0;
_skins=([VehicleForChengeSkin,1] call fnc_veh_getSkinFiles)select 1;
if(_skins==0)exitWith{CloseDialog 0;cutText["Извините. Расширенных покрасок для этой техники не найдено.","PLAIN DOWN"];};
for "_i" from 1 to _skins do{lbAdd [20014,format["Расширенная покраска #%1",_i]];};