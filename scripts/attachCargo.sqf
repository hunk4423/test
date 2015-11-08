/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.
		Буксировка на вертолете.
		Внимание! Не реализована обработка событий выхода игрока из вертолета.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_chopper","_cargo","_name_cargo","_empty","_intow","_height","_rel_pos","_reduc","_isair","_cargo_pos","_droprdy","_vel","_alt","_cantsee"];
_chopper = vehicle player;
EXPLODE2(THIS3,_cargo,_name_cargo);
_empty = CNT(crew _cargo)==0;
_intow = GetInTow(_cargo);
_isair = (_cargo isKindOf "Air");

_chopper removeAction AeroLiftActionId;
AeroLiftActionId = -1;

if (_empty && !_intow && _chopper != player)then{
	AL_status = 1;
	_cargo_pos = getPosATL _cargo;
	_rel_pos = _chopper worldToModel _cargo_pos;
	_height = SEL2(_rel_pos) + 2.5;

	_cargo attachTo [_chopper, [0,0,_height]];
	[_chopper,_cargo] call fnc_vehInTow;

	_reduc = 1.0025;
	if (typeOf _chopper	in AL_HighPower) then {_reduc = 1.0015};
	if (_cargo isKindOf "C130J_US_EP1")then{_reduc=1.05}else{if (_cargo isKindOf "Tank")then{_reduc=1.015}};

	_chopper vehicleChat format ["%1 зацеплен(а). Скорость снижена", _name_cargo];
	AeroLiftDropActionId=_chopper addAction [format["<t color='#ED2744'>Отцепить %1</t>",_name_cargo],ACTION_EXEC("AL_status=2"),0,false,false]; 

	_droprdy=false;
	while {AL_status!=0}do{
		sleep .1;
		if (damage _chopper>AL_DROP_DAMAGE || damage _cargo == 1)exitWith{};
		if (vehicle player!=_chopper)exitWith{};
		_vel=velocity _chopper;
		_chopper setVelocity [SEL0(_vel)/_reduc,SEL1(_vel)/_reduc,SEL2(_vel)];
		_alt=([_cargo] call FNC_getPos) select 2;
		if (_droprdy && !_isair)then{
			if (_alt>-0.1 && _alt<3)then{AL_status=3};
		}else{
			if(_alt > 20)then{_droprdy=true};
		};
		if (AL_status>1)then{
			_cantsee = lineIntersects [getposASL(_chopper),getposASL(_cargo),_chopper,_cargo];
			if (_alt>-0.1 && !_cantsee)then{
				AL_status=0;
			}else{
				// груз пересекается с объектом? отмена команды расцепки, везем дальше
				AL_status=1;
			};
		};
	};
	_chopper removeAction AeroLiftDropActionId;
	AeroLiftDropActionId=-1;
	_rel_pos=getPosATL _cargo;
	detach _cargo;
	_cargo setPosATL _rel_pos;
	vehicle player vehicleChat format ["%1 отцеплен(а). Скорость нормализована.",_name_cargo];
	// Пока ускорение носителя не учитываем, бывают глюки с ускорением
	// Просто легонько кидаем с точки сброса
	//_vel=velocity _chopper;
	_cargo setVelocity [0,0,0];
	[_chopper,_cargo,"ParachuteWest"] spawn fnc_ParaDrop;
	SetTow(_chopper,false);
	SetVehInTow(_chopper,nil);
	AL_status=0;
};
