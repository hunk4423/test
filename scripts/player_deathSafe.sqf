/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
/* сообщения другим игрокам
  0 - игрок смертельно ранен
  1 - игрок умер
  2 - игрока спасли
  3 - игрок почти мертв
  4 - пронесло, выжил
*/
PARAMS3PVT(_injured,_mode,_timeout);

switch _mode do {
case 0: {systemChat format["Игрок %1 получил смертельное ранение. Есть морфий? Вы можете помочь ему в течении %2 секунд.", _injured,_timeout];};
case 1: {systemChat format["Игрок %1 погиб! А ведь у вас был шанс его спасти!", _injured];};
case 2: {systemChat format["Игрок %1 был спасен за %2 секунд до своей гибели!", _injured,_timeout];};
case 3: {systemChat format["Игрок %1 почти мертв, последний шанс его спасти!", _injured];};
case 4: {systemChat format["Игрок %1 чудом выжил, наверно много каши в детстве ел!", _injured];};
};