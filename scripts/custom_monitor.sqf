/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_stime", "_hours", "_minutes", "_minutes2","_pos","_msg","_build"];
if (isNil "custom_monitor")then{custom_monitor=true}else{custom_monitor=!custom_monitor};
if (!custom_monitor)exitWith{};
while {custom_monitor} do 
{
	if(serverTime > 36000)then{_stime=time;}else{_stime=serverTime;};
	_hours=(_stime/60/60);
	_hours=toArray (str _hours);
	_hours resize 1;
	_hours=toString _hours;
	_hours=compile _hours;
	_hours=call  _hours;
	_minutes=floor(_stime/60);
	_minutes2=_minutes - (_hours*60);
	_pos=getPosATL player;
	
	if(BuildMode)then{
	hintSilent parseText format["<t size='1.10'font='Bitstream'shadow='1'align='center' color='#5882FA'>Режим строительства</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Направление:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%1</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Наклон вперед:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%2</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Наклон влево:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%3</t><br/>
	<br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left' >GPS:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%4</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Высота (над уровнем моря):</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%5</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Всего объектов:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%6</t>",
	(round((getDir BuildHelper)*100))/100,DZE_memForBack,DZE_memLeftRight,mapGridPosition _pos,SEL2(getPosASL BuildHelper),TotalBuildNear];
	}else{
	if(CCGEARPLUGS)then{_msg="<t size='0.95'font='Bitstream'shadow='1'align='center' color='#5882FA'>Громкость снижена</t><br/>";}else{_msg=""};
	hintSilent parseText format [
	"<t size='1.10'font='Bitstream'shadow='1'align='center' color='#5882FA'>%1</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Убито зомби: </t><t size='1'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%2</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Убито бандитов: </t><t size='1'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%3</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Хуманити: </t><t size='1'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%4</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Кровь: </t><t size='1'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%5</t><br/>
	%12<br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left' >GPS:</t><t size='0.87'font='Bitstream'shadow='1'align='left' color='#7EC0EE'> %6</t>
	<t size='0.87'font='Bitstream'shadow='1'align='right'>FPS:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'> %7</t><br/>
	<t size='0.87' font='Bitstream' shadow='1' align='left' >Наличные:</t><t size='0.87' font='Bitstream' shadow='1' align='left' color='#FFD700'> %10</t>
	<t size='0.87' font='Bitstream' align='right'>Банк:</t><t size='0.87' font='Bitstream' align='right' color='#FFD700'> %11</t><br/>
	<t size='0.87'font='Bitstream'shadow='1'align='left'>Время до рестарта:</t><t size='0.87'font='Bitstream'shadow='1'align='right' color='#7EC0EE'>%8ч %9мин</t>",
		name player,
		round (GETPVAR(zombieKills,0)),
		round (GETPVAR(banditKills,0)),
		[round(GETPVAR(humanity,0))] call BIS_fnc_numberText,
		[round r_player_blood] call BIS_fnc_numberText,
		mapGridPosition _pos,
		round diag_fps,
		round(HOUR_TO_RESTART-(_hours)),
		round(60-(_minutes2)),
		([GETPVAR(headShots,0)] call BIS_fnc_numberText),
		([GETPVAR(bank,0)] call BIS_fnc_numberText),
		_msg]
	};
	sleep 1;
};
hintSilent "";