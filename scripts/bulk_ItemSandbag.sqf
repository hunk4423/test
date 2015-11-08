/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_ip","_WorkBench","_count","_mag","_finished","_animState","_isMedic","_started","_removed","_bulk_empty","_bp"];
CheckActionInProgressLocalize(str_epoch_player_63);

_ip=items player;
_bulk_empty=[["bulk_empty",1]];
//Проверки
if!(("ItemToolbox" in _ip)&&("ItemSledge" in _ip))exitWith{BreakActionInProgress("Для создания необходимы инструменты и кувалда.")};
if(InVeh(player))exitWith{BreakActionInProgress("Нельзя крафтить в технике!")};
_WorkBench=[player,3] call fnc_getNearWorkBench;
if(!isNull _WorkBench)then{UpdateAccess(_WorkBench)};
if(isNull _WorkBench)exitWith{BreakActionInProgress("Для создания требуется рабочий стол вблизи 3 метров")};
if!(_bulk_empty call player_checkItems)exitWith{BreakActionInProgress("Для создания необходим пустой Supply Crate (bulk_empty).")};
_bp=unitBackpack player;if(isNil "_bp")exitWith{BreakActionInProgress("Для создания необходимо иметь рюкзак и 12 мешков с песком в нем.")};
//проверка есть ли в сумке
_count=0;_mag=(getMagazineCargo(unitBackpack player));{if("ItemSandbag"==_x)exitWith{_count=(_mag select 1) select _forEachIndex;};}forEach(_mag select 0);
if!(_count==12)exitWith{BreakActionInProgress("Недостаточное количество мешков с песком в рюкзаке, необходимо 12шт.")};

ANIMATION_MEDIC(false);
if (!_finished)exitWith{BreakActionInProgress(MSG_CANCEL)};

//Вторые проверки
if!(_bulk_empty call player_checkItems)exitWith{BreakActionInProgress("Для создания необходим пустой Supply Crate (bulk_empty).")};
_bp=unitBackpack player;if(isNil "_bp")exitWith{BreakActionInProgress("Для создания необходимо иметь рюкзак и 12 мешков с песком в нем.")};
//проверка есть ли в сумке
_count=0;_mag=(getMagazineCargo(unitBackpack player));{if("ItemSandbag"==_x)exitWith{_count=(_mag select 1) select _forEachIndex;};}forEach(_mag select 0);
if!(_count==12)exitWith{BreakActionInProgress("Недостаточное количество мешков с песком в рюкзаке, необходимо 12шт.")};
[10,10] call dayz_HungerThirst;

//Удаляем коробку
if!(_bulk_empty call player_checkAndRemoveItems)exitWith{BreakActionInProgress(["bulk_empty",1]call fnc_getMissingMessage)};

//Удаляем мешки из сумки
_removed=0;
{
	_removed=_removed+_x;			
}count(([unitBackpack player,["ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag","ItemSandbag"],[],[]]call ZUPA_fnc_removeWeaponsAndMagazinesCargo)select 0);

//Заканчиваем
if(_removed==12)then{
	player addMagazine "bulk_ItemSandbag";
	cutText["Создание успешно завершено, Supply Crate (bulk_ItemSandbag) добавлен в ваш инвентарь.", "PLAIN DOWN"];
}else{
	cutText["Недостаточное количество мешков с песком в рюкзаке, необходимо 12шт.", "PLAIN DOWN"];
	(unitBackpack player) addMagazineCargoGlobal ["ItemSandbag", _removed];	
};
DZE_ActionInProgress=false;