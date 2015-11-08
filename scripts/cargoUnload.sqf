/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_truck","_cargo","_items","_class","_cnt"];

_truck=THIS3;
_cargo=_truck getVariable["Cargo",[]];
if(CNT(_cargo)==0)exitWith{systemchat "Грузовик пуст"};
CheckActionInProgress(MSG_BUSY);
_items=[];
{
	_class=typeOf SEL0(_x);
	if(!(_class in _items))then{_items set[CNT(_items), _class]};
}forEach _cargo;
cutText ["Не стойте рядом с бортом при разгрузке если вы не в каске!","PLAIN DOWN"];
_cnt=2;
cargo_menu=[["Разгрузка",false]];
{
	cargo_menu set[CNT(cargo_menu),[
		getText (configFile >> "CfgVehicles" >> _x >> "displayName"),
		[_cnt],"", -5,[["expression",format["cargoAction=%1",_cnt-2]]],"1","1"
	]];
	_cnt=_cnt+1;
}forEach _items;

cargo_menu=cargo_menu+[["",[-1],"",-5,[["expression",""]],"1","0"],["Выход",[_cnt],"",-5,[["expression","cargoAction=-1"]],"1","1"]];

cargoAction=-2;
while {cargoAction!=-1}do{
	showCommandingMenu "#USER:cargo_menu";
	waitUntil {cargoAction!=-2};
	if(cargoAction>=0)exitWith{
		_class=SEL(_items,cargoAction);
		if(cargoAction>CNT(_items))exitWith{systemchat format["Выбран индекс %1 больше размера массива %2",cargoAction,CNT(_items)]};
		[_truck,_class]call vehicle_unloadCargo;
	};
};
DZE_ActionInProgress=false;
