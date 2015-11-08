/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT2(_lbIndex,_lbText);
_lbIndex=lbCurSel 3901;
_lbText=lbData [3901,_lbIndex];
if(_lbText!="")then{[_lbText,"object",[false]]spawn fnc_Preview;};