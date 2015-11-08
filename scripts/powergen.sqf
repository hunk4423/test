/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru https://vk.com/goldkey_dz
*/
#include "defines.h"

if(DZE_ActionInProgress) exitWith { cutText ["Уже занят другим.", "PLAIN DOWN"] };

player removeAction s_power_onoff;
s_power_onoff=-1;

PVT4(_array,_generator,_mode,_finished);

_array=THIS3;
EXPLODE2(_array,_generator,_mode);

if (_mode==1)then{
	cutText [(localize "str_epoch_player_25"), "PLAIN DOWN"];
	[player,15,true,(getPosATL player)] spawn player_alertZombies;
	[1,1] call dayz_HungerThirst;

	ANIMATION_MEDIC(false);
	if (_finished) then {
		SETVARS(_generator,GeneratorRunning,true);
		SETVARS(_generator,PowerCable,true);
		SETVARS(_generator,LightCable,true);
		SETVARS(_generator,GeneratorRunning,true);
		cutText [localize "str_epoch_player_28", "PLAIN DOWN"];
	}
}else{
	player playActionNow "PutDown";
	sleep 3;
	_generator setVariable ["GeneratorRunning",false,true];
	cutText [localize "str_epoch_player_101", "PLAIN DOWN"];
};
// Для теста обработать фонари вокруг
//[getPos _generator,_mode,1000] EXECVM_SCRIPT(stritlight.sqf);
