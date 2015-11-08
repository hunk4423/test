/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
PVT3(_lock,_obj,_text);
CheckActionInProgress(MSG_BUSY);
_lock=THIS1;	
{
	_obj=_x;
	if(THIS0==(GetObjID(_obj)))then{
		_text=[_obj,true] call object_getNameWithComment;	
		if((typeOf _x)in DZE_DoorsLocked)then{
			if(_lock)then{
				{_obj animate [_x,0];}count["Open_hinge","Open_latch","Open_door"];
				cutText [format["%1 закрыт(а)",_text],"PLAIN DOWN"];
			}else{
				{_obj animate [_x,1];}count["Open_hinge","Open_latch","Open_door"];
				cutText [format["%1 открыт(а)",_text],"PLAIN DOWN"];
			};
		}else{	
			if(_lock)then{
				//Закрыть
				VehicleLock(_obj);
				cutText [format["%1 закрыт(а)",_text],"PLAIN DOWN"];
				[_obj,100,true,(getPosATL _obj)]spawn player_alertZombies;
				[objNull,_obj,rSAY,"lock",10] call RE;
			}else{
				//Открыть
				VehicleUnlock(_x);
				cutText [format["%1 открыт(а)",_text],"PLAIN DOWN"];
				[_x,100,true,getPosATL _x]spawn player_alertZombies;
				[objNull,_x,rSAY,"unlock",10] call RE;
			};
			closeDialog 0;			
		};
	};	
}count(([player] call FNC_GetPos) nearEntities [[VEHICLE_TYPE]+DZE_DoorsLocked,100]);
DZE_ActionInProgress = false;