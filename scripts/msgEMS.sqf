/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_msg","_color","_chat","_unit"];
PARAMS2(_color,_msg);
if(CNT(_this)>3)then{_chat=THIS2;_unit=THIS3}else{_chat="system"};
[format["<t size='0.6' color='%1'>%2</t>",_color,_msg],-1,-(safezoneH-1.05)/2,25,-1,0,3010] spawn bis_fnc_dynamicText;
switch(_chat)do{
case "vehicle" : {_unit vehicleChat _msg};
case "group" : {_unit groupChat _msg};
case "side" : {_unit sideChat _msg};
default {systemChat _msg};
};