/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private "_smQTY";

if (dayz_combat == 1) exitWith {
	cutText ["Нельзя использовать во время боя.", "PLAIN DOWN"];
};

if (hasGutsOnHim) exitWith {
	cutText ["На мне уже достаточно кишков...", "PLAIN DOWN"];
};

_smQTY = {_x == "ItemZombieParts"} count magazines player;

if (_smQTY >= 2) then {
	r_interrupt = false;
	player playActionNow "Medic";

	if ([["ItemZombieParts", 2]] call player_checkAndRemoveItems) then {
	_humanity = player getVariable["humanity",0];

	[player,"gut",0,false,10] call dayz_zombieSpeak;
	sleep 10;

	sand_USEDGUTS = true; 
	sand_washed =  false;
	hasGutsOnHim = true;

	soundFly = createSoundSource ["Sound_Flies", position player, [], 0];
	soundFly attachto [player,[0,0,-5]];

	if (_humanity >= 10000)  then {
		[player,-100,0] call player_humanityChange;
	}else{
		[player,-150,0] call player_humanityChange;
	};

	if ((r_player_injured) and !(r_player_infected)) then {
		if (RND(80)) then {
			r_player_infected = true;
			player setVariable["USEC_infected",true,true];
			cutText ["Я намазал на себя кишки и внутренности зомби, ...ну и запах! \n Кровь зомби попала на рану, еще и заразился!", "PLAIN DOWN"];
		};
	}else{
		cutText ["Я намазал на себя кишки и внутренности зомби, ...ну и запах!", "PLAIN DOWN"];
	};

	r_interrupt = false;
	player switchMove "";
	player playActionNow "stop";
	sleep 2;

	} else {
		cutText ["Ошибка!", "PLAIN DOWN"];
	};

} else {
	cutText ["Мне нужно 2 Zombie parts, что бы скрытся от зомби.", "PLAIN DOWN"];
};
