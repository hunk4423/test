/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT4(_array,_data,_action,_object);
_array=THIS3;
EXPLODE2(_array,_data,_action);
_object=ObjNull;
switch(_action)do{
	case "fillnearfuel": {_object=_data;[ObjNull,ObjNull,ObjNull,ObjNull] call COMPILE_ACTION_FILE(fill_nearestVehicle.sqf)};
	case "gift": {_array call fnc_SelectPlayerDialog};
	case "takeClothes": {_array call player_takeClothes};
	case "SeaFox": {[_data]call vehicle_loadingToTrack};
#ifdef _ORIGINS
	case "ChengeSkin": {createDialog "vehicle_ChengeSkin";[_data]call fnc_veh_FillSkinList;};
#endif
};
if !(isNull _object)then{UpdateAccess(_object)};