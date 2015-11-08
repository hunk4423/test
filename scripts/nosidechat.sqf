/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"


[] spawn {
	disableSerialization;
	DS_really_loud_sounds = {[60,15] call fnc_usec_pitchWhine;for "_i" from 1 to 15 do {playSound format ["%1",THIS0];};};
	DS_double_cut = {1 cutText [format ["%1",THIS0],"PLAIN DOWN"];2 cutText [format ["%1",THIS0],"PLAIN"];};
	DS_slap_them = {_randomnr = [2,-1] call BIS_fnc_selectRandom;(vehicle player) SetVelocity [_randomnr * random (4) * cos getdir (vehicle player), _randomnr * random (4) * cos getdir (vehicle player), random (4)];};
	while {true} do {
		waitUntil {sleep 1;((!isNull findDisplay 63) && (!isNull findDisplay 55))};
		if(CurrAdminLevel==3)exitWith{};

		if (ctrlText ((findDisplay 63) displayCtrl 101) == localize "str_channel_side") then {
			[] spawn {
				if (isNil "reset_timer") then {
					reset_timer = true;
					sleep 90;
					disconnect_me = nil;
					warn_one = nil;
					warn_two = nil;
					warn_three = nil;
					warn_last = nil;
					reset_timer = nil;
				};
			};
			if (isNil "disconnect_me") then {disconnect_me = 0;} else {disconnect_me = disconnect_me + 1;};
			if (disconnect_me == 0) then {
				if (isNil "warn_one") then {
					warn_one = true;
					systemChat ("Просьба не разговаривать в глобалчате, это первое предупреждение.");
					[] spawn DS_slap_them;
					["beat04"] spawn DS_really_loud_sounds;
					["Запрещено говорить в Глобалчате"] spawn DS_double_cut;
					r_player_inpain = true;
					r_player_blood = r_player_blood - 500;
				};
			};
			if (disconnect_me == 1) then {
				if (isNil "warn_two") then {
					warn_two = true;
					systemChat ("Просьба не разговаривать в глобалчате, это второе предупреждение...");
					[] spawn DS_slap_them;
					["z_scream_3"] spawn DS_really_loud_sounds;
					["Запрещено говорить в Глобалчате"] spawn DS_double_cut;
					r_player_blood = r_player_blood - 3000;
				};
			};
			if (disconnect_me == 2) then {
				if (isNil "warn_three") then {
					warn_three = true;
					systemChat ("ЗАПРЕЩЕНО говорить в Глобалчате! Это последнее предупреждение!");
					systemChat ("ВЫ БУДИТЕ ОТКЛЮЧЕНЫ!");
					[] spawn DS_slap_them;
					["z_scream_4"] spawn DS_really_loud_sounds;
					["ЗАПРЕЩЕНО говорить в Глобалчате! Это последнее предупреждение!"] spawn DS_double_cut;
					r_player_blood = r_player_blood - 4500;
					//_selection = ""legs"";
					//player setHit[_selection,1];
					
				};
			};
			if (disconnect_me >= 3) then {
				if (isNil "warn_last") then {
					warn_last = true;
					playMusic ["PitchWhine",0];
					[] spawn DS_slap_them;
					["beat04"] spawn DS_really_loud_sounds;
					["МЫ предупреждали..."] spawn DS_double_cut;
					1 fademusic 10;
					0 fadeSound 0;
					startLoadingScreen ["ОТКЛЮЧЕНИЕ", "DayZ_loadingScreen"];
					call dayz_forceSave;
					progressLoadingScreen 0.2;sleep 2;
					progressLoadingScreen 0.4;sleep 2.25;
					progressLoadingScreen 0.6;sleep 2;
					progressLoadingScreen 0.8;sleep 2.25;
					progressLoadingScreen 1.0;sleep 2;
					endLoadingScreen;sleep 0.5;
					EXECVM_SCRIPT(player_kick.sqf);
				};
			};
		};
	};
	sleep 2;
};
