/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_param1","_param2"];
_param1=THIS0;
_param2=THIS1;
_msg=THIS2;
cutText[format[_msg,_param1,_param2], "PLAIN DOWN"];
systemChat format[_msg,_param1,_param2];