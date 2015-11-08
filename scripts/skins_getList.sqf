/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

PVT3(_playerItems,_skins,_item);
Men_Clothing = [];
_playerItems = magazines player;
lbClear 20014;
{
	_item = _x;
	_skins=_item call fnc_GetSkinInfoByName;
	if (CNT(_skins)>0)then{
		_skins=SEL2(_skins);
		{
			if (!(_x in Men_Clothing))then{
				Men_Clothing set [CNT(Men_Clothing), _x];
				lbAdd [20014,_x];
			};
		}forEach _skins;
	};
}forEach _playerItems;
