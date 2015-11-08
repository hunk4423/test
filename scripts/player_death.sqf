/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_display","_body","_playerID","_method","_humanity","_value","_ppColor"];
disableSerialization;
if (deathHandled) exitWith {};
deathHandled = true;
if ((alive player) && {isNil {dayz_playerName}}) then {
	dayz_playerName = name player;
};
//Prevent client freezes
_display = findDisplay 49;
if(!isNull _display) then {_display closeDisplay 0;};
if (dialog) then {closeDialog 0;};
if (visibleMap) then {openMap false;};

_body = player;
_playerID = getPlayerUID player;

_infected = 0;
if (r_player_infected && DZE_PlayerZed) then {
	_infected = 1;
};
PVDZE_plr_Died = [dayz_characterID,0,_body,_playerID,_infected, dayz_playerName];
publicVariableServer "PVDZE_plr_Died";

if (useDeathSafe)then{
	_id = [player,20,true,getPosATL player] call player_alertZombies;

	_result = false;

	// Ждем помощи
	if (CNT(_this) > 0) then {
		PARAMS2(_source,_method);
		/* _method
		"shothead"
		"explosion"
		"shotheavy"
		"crushed"
		"bled" - кровопотеря
		"dehyd" -жажда
		"starve" - голод
		"rad" 
		*/
		systemChat format["Death from %1 by %2",name _source];
		diag_log format["NeedMedic %1 from %2",dayz_playerName,_method];

		if (isNil "lastDeadSafe") then {lastDeadSafe = 0;};
		if (r_player_blood>=500 && (time - lastDeadSafe)>600) then {
			ds_timeout = 20+round((r_player_blood/r_player_bloodTotal)*30);
	//		r_player_unconscious = true;
			SETVARS(_body,medForceUpdate,true);
			SETVARS(_body,medDeathSafe, true);
			[_body] joinSilent createGroup EAST;
			_pos = position _body;
			_cam = "camera" camCreate [SEL0(_pos),SEL1(_pos),2];
			showCinemaBorder false;
			_cam camSetTarget _body;
			_cam cameraeffect["internal","back"];
			_cam camCommit 0;
			_cam camSetPos [SEL0(_pos),SEL1(_pos)-6,7];
			_cam camCommit 10;

			systemChat format["Вы умираете! Вам осталось жить %1 секунд. Кричите громче, может кто-то вас услышит и поможет!",ds_timeout];
			[200,"deathsafe",[0, ds_timeout]] call fnc_sendNearestPlayer;

			if (vehicle _body == _body) then {
				[objNull, _body, rSWITCHMOVE, "AinjPpneMstpSnonWrflDnon"] call RE;
			};
			//disableUserInput true;
			_timeout=0;
			_lastch=false;
			_snd=['z_panic_0','z_scream_2','z_scream_3','z_scream_4'];
			while {ds_timeout>0} do{
				playSound "heartbeat_1";
				sleep 1;
				if (_timeout==0) then {
					_sound=_snd call BIS_fnc_selectRandom;
					[nil,_body,rSAY,[_sound,100]] call RE;
					_id = [_body,20,true,getPosATL _body] call player_alertZombies;
					_timeout=5;
				}else{
					_timeout=_timeout-1;
				};
				ds_timeout = ds_timeout - 1;
				if (ds_timeout<12 && !_lastch) then {
					[200,"deathsafe",[3,ds_timeout]] call fnc_sendNearestPlayer;
					_lastch=true;
				};
				if (!(_body getVariable ["medDeathSafe", true])) then {
					_nul = [] spawn fnc_usec_recoverUncons;
					// Друг спас жизнь друга
					[200,"deathsafe",[2,ds_timeout]] call fnc_sendNearestPlayer;
					ds_timeout = 0;
					_result = true;
				};
	//			if(animationState _body == "AmovPpneMstpSnonWnonDnon_healed") then {
	//				_nul = [] spawn fnc_usec_recoverUncons;
	//			};
			};
			if (!_result) then {// каша
				if (RND(95)) then {
					systemChat "Вы чудом выжили! Не зря мама в детстве говорила - Пейте дети молоко, будете здоровы!";
					[200,"deathsafe",[4,0]] call fnc_sendNearestPlayer;
					_nul = [] spawn fnc_usec_recoverUncons;
					_result = true;
				}else{
					[200,"deathsafe",[1,ds_timeout]] call fnc_sendNearestPlayer;
					//sleep 5;
				}
			};
			_body setVariable ["medDeathSafe", false, true];
			_cam cameraEffect ["terminate","back"];
			camDestroy _cam;
		};
		[_body] joinSilent createGroup WEST;
	};
	if (_result || !_result) exitWith{
		// Надо оживить в базе
	//	PVDZE_plr_Died = [dayz_characterID,1,_body,_playerID,_infected, dayz_playerName];
	//	publicVariableServer "PVDZE_plr_Died";
		_body setVariable ["deadSafe", false, true];
		lastDeadSafe=time;
		r_player_blood = 12000;//1000
		[objNull, _body, rSWITCHMOVE, "AinjPpneMstpSnonWnonDnon_injuredHealed"] call RE;
		deathHandled = false;
		disableUserInput false;
	};
};
// Совсем помираем
_id = [_body,20,true,getPosATL _body] call player_alertZombies;

//disableUserInput true;
sleep 0.5;

player setDamage 1;


player setVariable ["NORRN_unconscious", false, true];
player setVariable ["unconsciousTime", 0, true];
player setVariable ["USEC_isCardiac",false,true];
player setVariable ["medForceUpdate",true,true];
player setVariable ["startcombattimer", 0];
r_player_unconscious = false;
r_player_cardiac = false;

_method = [
"со словами: пацаны смотрите как я могу!",
"со словами: пфф, да я их одним макаровым!",
"со словами: Поставлю ка я и вторую взрывчатку",
"со словами: хм, он вроде мирный.... ",
"со словами: а как гранату кидать? :) ...",
"со словами: Только через мой труп!",
"со словами: Ещё один дом и точно на базу.",
"со словами: Вроде чисто...",
"со словами: да как? Я же первый начал стрелять",
"со словами: пацаны мне афк надо телефон звонит",
"со словами: Да он не видит...",
"со словами: Посоны, вертолёт летит! Давайте собьём его.",
"со словами: Что-то велик как то заносит...",
"со словами: Сейчас подкручу настройки... ",
"со словами: Откуда?",
"от того что поймал пулю зубами.",
"слушая музыкальные выстрелы с ДШКМ.",
"от голода, потому что не смог открыть банку бобов.",
"от того что кричал ботам френдли.",
"от испуга, когда ему попала пуля в голову.",
"из-за этого большого отверстия в голове...",
"от того что задолжал чёрному рынку.",
"от отравления антибиотиками.",
"от падения метеорита.",
"от приступа икоты."
] call BIS_fnc_selectRandom;

_body setVariable ["deathType",_method,true];
_body setVariable ["isPlayer",true,true];
_body setVariable ["PlayerUID",getPlayerUID player,true];

terminate dayz_musicH;
terminate dayz_slowCheck;
terminate dayz_animalCheck;
terminate dayz_monitor1;
terminate dayz_medicalH;
terminate dayz_gui;

r_player_dead = true;
//playSound "introsong";

3 cutRsc ["default", "PLAIN",3];
4 cutRsc ["default", "PLAIN",3];

showCinemaBorder false;

titlecut["","BLACK OUT",25];

_humanity=GetHumanity(player);
call {	
  if (_humanity<5000)exitWith{_value=0;};
  if (_humanity<10000)exitWith{_value=0.015;};
  if (_humanity<20000)exitWith{_value=0.01;};
  if (_humanity<40000)exitWith{_value=0.005;};
  if (_humanity>40000)exitWith{_value=0.0025;};
	_value=0;
};
cutText [format["Вы погибли...Сожалеем, но Ваша хуманити уменьшилась на %1%2, потеряно %3 хуманити.",(_value*100),"%",round(_humanity*_value)], "PLAIN DOWN"];

_ppColor = ppEffectCreate ["ColorCorrections", 1999]; 
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [0, 0, 0, [0,0,0,0], [0,0,0,0], [0,0,0,0]];
_ppColor ppEffectCommit 25;

_pos=getPosATL _body;	
_cam = "camera" camCreate [_pos select 0,_pos select 1,(_pos select 2) +2];
_cam camSetTarget player;
_cam cameraeffect["internal","back"];
_cam camCommit 0;

_cam camSetPos [_pos select 0,(_pos select 1) + 50,50];
_cam camCommit 25;
sleep 25;
camdestroy _cam;

//Player is Dead!
dayz_originalPlayer enableSimulation true;
addSwitchableUnit dayz_originalPlayer;
setPlayable dayz_originalPlayer;
selectPlayer dayz_originalPlayer;
_body setVariable["combattimeout", 0, true];

//1 cutRsc ["DeathScreen","BLACK OUT",3];

sleep 2;

for  "_x" from 5 to 1 step -1 do {
	titleText [format[localize "str_return_lobby", _x], "PLAIN DOWN", 1];
	sleep 1;
};

PVDZE_Server_Simulation = [_body, false];
publicVariableServer "PVDZE_Server_Simulation";

ppEffectDestroy _ppColor;
endMission "END1";
