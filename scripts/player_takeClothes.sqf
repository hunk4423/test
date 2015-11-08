/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private["_canTake","_corpse","_dir","_body_name","_hisMoney","_body","_skin","_itemNew","_chance","_abort","_item","_takeClothesUsageTime","_started","_finished","_isMedic","_clothesTaken","_bag","_pos","_object","_bmags","_bweps","_agent","_id"];

CheckActionInProgressLocalize(str_epoch_player_63);
player removeAction s_player_clothes;s_player_clothes=-1;

_body=THIS0;
_skin=(typeOf _body);
_itemNew=_skin;
_chance=50;
_abort=false;
_body_name=GETVAR(_body,bodyName,"");
_canTake=((dayz_playerName==_body_name) || ((GETVAR(_body,PlayerUID,0))in(profileNamespace getVariable["savedGroup",[]])));

if(([_body,5] call fnc_getNearPlayersCount) >0)exitWith{
	BreakActionInProgress("Нельзя снимать в присутствии других игроков!");
};

if(_canTake||((typeOf _body)in AI_BanditTypes))then{
	_hisMoney=GetCash(_body);
	if((isNil "_hisMoney")||(_hisMoney==0))exitWith{systemChat "Наличных не найдено";};
	if(typeName _hisMoney != "SCALAR")exitWith{systemChat "Наличных не найдено";};
	SetCash(_body,0);
	[player,_hisMoney] call SC_fnc_addCoins;
	systemChat format ['Наличных найдено: %1 руб.',[_hisMoney] call BIS_fnc_numberText];
}else{
	if((CurrAdminLevel<1)&&(_body_name!=""))then{
		PVDZE_send=[player,"nopvpmsg",[dayz_playerName,_body_name,"Игрок %1 снимает одежду с трупа игрока %2. Если это попытка кражи, сделайте скриншот (нажмите F12). Обязательно сообщите администрации!"]];
		publicVariableServer "PVDZE_send";
	};
};

{
	if(_itemNew ==_x select 0)exitWith{_itemNew=_x select 1;};
}forEach TAKE_CLOTHES;

_item=_itemNew call fnc_GetSkinInfoByModel;
if (CNT(_item)>0)then{
	_itemNew=SEL0(_item);
	_chance=25;	
};

#ifdef _OVERPOCH
if(_itemNew=="SurvivorWsequishaD_DZ")then{_chance=0;};
if((_chance==0)&&!_canTake)exitWith{systemChat "Это скин купленн за донат, снимать его имеет право только хозяин трупа.";DZE_ActionInProgress=false;};
#endif

_itemNew="Skin_" + _itemNew;
r_interrupt=false; 
r_doLoop= true; 
_takeClothesUsageTime=time;
_started=false;
_finished=false;

if(isClass (configFile >> "CfgMagazines" >> _itemNew))then{
	if !(_body getVariable["clothesTaken",false])then{
		while {r_doLoop}do{
			_isMedic = ["medic",animationState player] call fnc_inString;
			_clothesTaken=_body getVariable["clothesTaken",false];
			if(_clothesTaken) then { 
				r_doLoop = false; 
			};
			if (_isMedic) then {
				_started = true;
			};
			if(!_isMedic && !r_interrupt && (time - _takeClothesUsageTime) < 6) then {
				player playActionNow "Medic";
				_isMedic = true;
			};
			if (_started && !_isMedic && (time - _takeClothesUsageTime) > 6) then {
				r_doLoop = false; 
				_finished = true;
			};
			if (r_interrupt) then {
				r_doLoop = false; 
			};
			sleep 0.1;
		};
		r_doLoop = false; 

		if(_finished)then{
			if(([_body,10] call fnc_getNearPlayersCount) >0)exitWith{
				BreakActionInProgress("Нельзя снимать в присутствии других игроков!");
			};
			if(RND(_chance))then{
				_body setVariable["clothesTaken",true,true];
				player addMagazine "Skin_Survivor2_DZ";
				playSound "brokeclothes";
				[player,30,true,(getPosATL player)] spawn player_alertZombies;
				cutText ["Порвал одежду, пока снимал! В следующий раз надо стрелять в голову...", "PLAIN DOWN"];
			}else{
				if ([player,_itemNew] call BIS_fnc_invAdd) then {
					_body setVariable["clothesTaken",true,true];
					cutText [format["Скин %1 у меня в инвентаре",getText (configFile >> "CfgMagazines" >> _itemNew >> "displayName")], "PLAIN DOWN"];
				}else{
					cutText [format["В снаряжении нет места для скина."], "PLAIN DOWN"];
					_abort=true;
				};
			};
			if(_abort)exitWith{DZE_ActionInProgress=false;};
			
			[player,10] call player_humanityChange;
			DZE_ActionInProgress=false;
			
			_bag=unitBackpack _body;
			_pos=getPosATL _body;	
			_object=createVehicle ["WeaponHolder",_pos,[],0,"CAN_COLLIDE"];
			_object setpos _pos;
			{_object addMagazineCargoGlobal [_x,1];}forEach(magazines _body);
			{_object addWeaponCargoGlobal [_x,1];}forEach(weapons _body);
			if !(isNull _bag)then{
				_bmags=getMagazineCargo _bag;
				_bweps=getWeaponCargo _bag;				
				_object addBackpackCargoGlobal [(typeOf _bag), 1];
				{_object addMagazineCargoGlobal [_x, ((_bmags select 1) select _forEachIndex)];} forEach (_bmags select 0);
				{_object addWeaponCargoGlobal [_x, ((_bweps select 1) select _forEachIndex)];} forEach (_bweps select 0);
			};
			deleteVehicle _body;			
			_corpse=createVehicle ["Body",_pos,[],0,"CAN_COLLIDE"];
			_corpse setpos _pos;
			_corpse setDir (random 360);			
			player reveal _object;
			player action ["Gear",_object];
			
			if(RND(70))then{
				sleep (random(170) + 30);
				deleteVehicle _corpse;
				_agent=createAgent [(Army_Zombies call BIS_fnc_selectRandom),_pos,[],0,"CAN_COLLIDE"];
				_id=[_pos,_agent,10] EXECFSM_SCRIPT(zombie_agent.fsm);
				_agent setPos _pos;	
			}else{
				PVDZE_ObjectTimeoutCtrl=[_corpse,300,"delete"];
				publicVariableServer "PVDZE_ObjectTimeoutCtrl";	
			};
			
		} else {
			if(_clothesTaken)then{
				player switchMove "";
				player playActionNow "stop";
				cutText["Этого уже кто-то раздел!","PLAIN DOWN"];
			}else{
				r_interrupt = false;
				player switchMove "";
				player playActionNow "stop";
				cutText [format["Прервал снятие одежды"], "PLAIN DOWN"];
			};
		};
	} else {
		cutText["Этого уже кто-то раздел!","PLAIN DOWN"];
	};
} else {
	cutText[format["%1 не могу снять(((",_skin],"PLAIN DOWN"];
};

DZE_ActionInProgress = false;