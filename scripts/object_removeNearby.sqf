/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT4(_nearByObjects,_targetObject,_error,_objects);
if(!([dayz_playerUID,BUILD_ACCESS,getNearPlots(player,PLOT_RADIUS)] call fnc_checkObjectsAccess))exitWith{BreakActionInProgressLocalize2(str_epoch_player_141,_needText,PLOT_RADIUS)};
_objects=THIS0;
_error=THIS2;
if(isNil "_error")then{_tree=true;_error="Вблизи нет построенных деревьев.";}else{_error=(localize _error);};
_onLadder=(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo=(!r_drag_sqf && !r_player_unconscious && !_onLadder);
_nearByObjects=nearestObjects [player,_objects,THIS1];
if(count _nearByObjects==0)exitWith{cutText[(_error),"PLAIN DOWN"];};
_targetObject = _nearByObjects select 0;
if(!isNull _targetObject && _canDo)then{
	[0,1,2,_targetObject] spawn player_removeObject;
}else{
	cutText[(_error),"PLAIN DOWN"];
};