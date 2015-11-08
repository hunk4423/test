/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

systemChat format ["В радиусе %1 метров от вас %2 объектов.",PLOT_RADIUS,count(nearestObjects [player,dayz_allowedObjects,PLOT_RADIUS])];
