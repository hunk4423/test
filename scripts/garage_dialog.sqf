/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private "_action";
PARAMS2(selectedGarage,_action);
if (_action=="list" && !(isNull selectedGarage))then{garageDialogModeGet=true}else{garageDialogModeGet=false};
player removeAction s_garage_dialog;s_garage_dialog=-1;
createDialog "GarageVehicles";
disableSerialization;
waitUntil {!isNull (findDisplay IDD_GARAGE_LIST)};
if !(isNull selectedGarage)then{
	if (GETVAR(selectedGarage,parking,false))exitWith{ctrlSetText [2801,format["Общественный гараж. %1",GetComment(selectedGarage)]]};
	if (GETVAR(selectedGarage,penalty,false))exitWith{ctrlSetText [2801,format["Штрафная стоянка. %1",GetComment(selectedGarage)]]};
	ctrlSetText [2801,format["Гараж %1",selectedGarage call object_formatCommentWithID]];
};
ctrlSetText [2856,str(DZE_GarageRange)];
call OnGarageModeChange;
