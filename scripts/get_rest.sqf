/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT6(_fnc_usec_addBlood,_count,_abort,_obj,_painOff,_find);
if(DZE_ActionInProgress)exitWith{};
DZE_ActionInProgress=true;
r_interrupt=false;
sleep 5;
if(r_interrupt)exitWith{DZE_ActionInProgress=false;};
if!(["amovpsit",animationState player]call fnc_inString)exitWith{DZE_ActionInProgress=false;};
_count=0;
_abort=false;
_obj=["FireBarrel_DZ","Land_Campfire_burning","Land_Fire_DZ"];
_painOff=round((random 60)+250);
_pos=getpos player;
//TODO: _fractureOff=round((random 80)+240);
_fnc_usec_addBlood={
	PVT(_value);
	_value=THIS0+r_player_blood;
	if(_value>r_player_bloodTotal)exitWith{r_player_blood=r_player_bloodTotal;};
	r_player_blood=_value;
};
while{true}do{
	if!(["amovpsit",animationState player] call fnc_inString)then{_abort=true;};
	if(r_interrupt)then{_abort=true;};
	if(InVeh(player))then{_abort=true;};
	if(_abort)exitWith{cutText["Ну что, отдохнул и в путь!","PLAIN DOWN"];DZE_ActionInProgress=false;};
	
	_find=false;
	{if(inflamed _x)exitWith{_find=true;};}count(nearestObjects [_pos, _obj, 5]);
	if(_find)then{
		if(_count==1)then{cutText["Отдых у костра - что может быть лучше для поднятия настроения и жизненных сил!","PLAIN DOWN"];};
		[5] spawn _fnc_usec_addBlood;
	}else{
		if(_count==1)then{cutText["Хорошо сидим! Здоровье-то восстанавливается! Эх... еще бы костерок развести...","PLAIN DOWN"];};
		[2] spawn _fnc_usec_addBlood;
	};
	if((_count>_painOff)&&(r_player_blood==r_player_bloodTotal))then{
		player setVariable ["USEC_inPain",false,true];
		r_player_inpain=false;
		R3F_TIRED_Accumulator=0;
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;
	};	
	//TODO: нога прошла
	_count=_count+1;
	sleep 1;
};
player setVariable["medForceUpdate",true];