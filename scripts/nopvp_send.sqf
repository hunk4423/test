/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT2(_source,_Nsource);
_source=THIS0;
_Nsource=name _source;
if(_Nsource==name player)exitWith{};
cutText [format["Игрок %1 пытается вас убить. Сделайте скриншот(нажмите F12). \n Обязательно сообщите администрации!",_Nsource], "PLAIN DOWN"];
systemChat format ["Игрок %1 пытается вас убить. Сделайте скриншот(нажмите F12). Обязательно сообщите администрации!",_Nsource];
PVDZE_send = [_source,"nopvp",[player]];
publicVariableServer "PVDZE_send";
nopvpbloodloss = 0;