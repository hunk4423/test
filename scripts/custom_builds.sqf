/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_lbIndex","_classname","_requiredmaterials"];

_lbIndex = lbCurSel 3901;
_classname = lbData [3901,_lbIndex];
_requiredmaterials = getArray (missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _classname >> "requiredmaterials");
[_classname,_requiredmaterials,"build"] spawn player_build;
