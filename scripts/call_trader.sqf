/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_humanity","_namePlayer","_type","_trader","_isOk","_agent","_msg1","_msg2","_msg3","_msg4","_msg5"];
if(DZE_ActionInProgress) exitWith {cutText [(localize "str_epoch_player_63"),"PLAIN DOWN"];};
DZE_ActionInProgress = true;
_namePlayer=name player;
_humanity=GetHumanity(player);
_type = THIS0;
_isOk=false;

switch (_type) do
	{
		case "medic" :{
			_msg1 =["\n %1: Доктор! Мне срочно нужна медицинская помощь! Приезжайте! Безопасность гарантирую!",_namePlayer];
			_msg2 =["\n\n Доктор: Вызов доктора 15,000р. Доктор останется с вами сколько нужно!"];
			_msg3 =["\n\n %1: На данный момент у меня нет такой суммы.",_namePlayer];
			_msg4 =["\n\n Доктор: Извините, ничем не можем помочь, старайтесь выжить!"];
			_msg5 =["\n\n %1: Главное это Здоровье! Жду Вас!",_namePlayer];
			_agent = "Doctor";
			_isOk=true;
		};
		case "other" :{
			_msg1 =["\n %1: Привет! Мне бы продать тут всякого, я туда попал? Приезжайте ко мне? Безопасность гарантирую!",_namePlayer];
			_msg2 =["\n\n Торговец: Да, все верно! У нас есть почти все! Но у нас вызов 15,000р!"];
			_msg3 =["\n\n %1: Блин, не знал, накоплю - сообщу!",_namePlayer];
			_msg4 =["\n\n Торговец: Хорошо! Ждем Вас в любой момент!"];
			_msg5 =["\n\n %1: Да не вопрос! Жду!",_namePlayer];
			_agent = "UN_CDF_Soldier_Guard_EP1";
			_isOk=true;
		};
		case "weapon" :{
			_msg1 =["\n %1: Даров! Это торговец оружием? Есть для тебя заманчивое предложение, приезжай ко мне? Безопасность гарантирую!",_namePlayer];
			_msg2 =["\n\n Торговец: Хм... интересно! Тогда с тебя 15,000р, добирается то не безопасно!"];
			_msg3 =["\n\n %1: Блин, не знал, накоплю - сообщу!",_namePlayer];
			_msg4 =["\n\n Торговец: ахахаха, ага давай, Удачи! жду...)))"];
			_msg5 =["\n\n %1: Да не вопрос! Жду!",_namePlayer];
			call{	
				if (_humanity>40000)exitWith{_agent="US_Soldier_AMG_EP1";};
				if (_humanity>10000)exitWith{_agent="US_Soldier_AAR_EP1";};
				if (_humanity<10000)exitWith{_agent="US_Soldier_EP1";};
				_agent="US_Soldier_EP1";
			};
			_isOk=true;
		};
		case "gerl" :{
			playsound "radio_shum";
			cutText [format["\n\n В данный момент все девушки на вызове!"], "PLAIN DOWN"];
		};
	};
		
//Общение
if(_isOk) then {
	playsound "radio_shum";
	cutText [format _msg1, "PLAIN DOWN"];
	sleep 6;
	playsound "radio_shum";
	cutText [format _msg2, "PLAIN DOWN"];

	_removed = [player, 15000] call SC_fnc_removeCoins;
	if !(_removed) exitWith {
		sleep 4;
		playsound "radio_shum";
		cutText [format _msg3, "PLAIN DOWN"];
		
		sleep 4;
		playsound "radio_shum";
		cutText [format _msg4, "PLAIN DOWN"];
	};

	//оплатил
	sleep 4;
	playsound "radio_shum"; 
	cutText [format _msg5, "PLAIN DOWN"];
	
	sleep 2;
	//моргнул
	titleText["","BLACK OUT",1];  
	sleep 1.5;
	//спавн бота
	_trader = createAgent [_agent, [(getpos player select 0), (getpos player select 1), 10], [], 0, "CAN_COLLIDE"];
	{player removeMagazine _x;} forEach(magazines _trader);removeAllWeapons _trader;removeAllItems _trader;removebackpack _trader;_trader addweapon 'bizon_silenced';	
	_trader addEventHandler ['killed',{_this EXECVM_SCRIPT(bodyclean.sqf)}];
	_trader setVariable["clothesTaken",true,true];
	_trader setcaptive true;
	_trader setVehicleInit "this disableAI 'FSM'; this disableAI 'MOVE'; this disableAI 'AUTOTARGET'; this disableAI 'TARGET'; this setBehaviour 'CARELESS'; this forceSpeed 0; this enableAI 'ANIM';";
	_trader allowDammage true; _trader disableAI 'FSM'; _trader disableAI 'MOVE'; _trader disableAI 'AUTOTARGET'; _trader disableAI 'TARGET'; _trader setBehaviour 'CARELESS'; _trader forceSpeed 0;_trader enableSimulation true;
	_trader attachTo [player, [0,2.5,0.0]];
	_trader setVectorDirAndUp [[1,-1,0],[0,0,1]];
	sleep 0.1;
	detach _trader;
	player reveal _trader;
	sleep 1.5;
	titleText["","BLACK IN",1];
};

DZE_ActionInProgress = false;