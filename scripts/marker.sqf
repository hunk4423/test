/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT6(_marker,_name,_pos,_text,_size,_sizes);
//PARAMS1PVT(_array);
waitUntil {!isNil "StaticMarkers"};
{
	_name=SEL0(_x);
	_pos=SEL1(_x);
	_text=SEL2(_x);
	//0-"имя",1-[позиция],2-"Текст",3-"тип",4-"Цвет",{5-направление,6-[размер]}
	[_name,_pos,_text,SEL3(_x),SEL4(_x)] call fnc_CreateMarkerLocal;
	if (CNT(_x)>5)then{
		// Круг запрета парковки
		_sizes=SEL7(_x);
		if (CNT(_sizes)>1)then{
			_size=SEL1(_sizes);
			if (CNT(_size)>1)then{
				_marker = [_name+"_np",_pos,"","Empty","ColorBlue",SEL6(_x),_size,SEL5(_x),"Border"] call fnc_CreateMarkerLocal;
			};
		};
		// Зона запрета стройки
		if (CNT(_sizes)>2)then{
			_name=_name+"_nb";
			if (showNoBuildZone && CurrAdminLevel>0)then{
				_size=SEL2(_sizes);
				if (CNT(_size)>1)then{
					_marker = [_name,_pos,"","Empty","ColorRed",SEL6(_x),_size,SEL5(_x),"Border"] call fnc_CreateMarkerLocal;
				};
			}else{
				deleteMarkerLocal _name;
			};
		};
	};
} forEach StaticMarkers;
StaticMarkersInit=true;
