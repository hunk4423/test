/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_humanity","_name","_pPos","_mrkr","_nameID"];

if (visibleMap || (!isNull (findDisplay 88890))) then {
	if("ItemGPS" in items player)then{
		{
			if ((!isNull _x) && (isPlayer _x)) then {
				_name = name _x;
				if (group _x == group player) then {
					_pPos = getPosATL _x;
					if (surfaceIsWater _pPos) then {_pPos = getPosASL _x;};
					if (_name == name player) then {_name = "Я здесь";};
					deleteMarkerLocal _name;
					_mrkr = createMarkerLocal [_name,_pPos];
					_mrkr setMarkerTypeLocal "Select";
					_mrkr setMarkerColorLocal "ColorBlue";
					_mrkr setMarkerTextLocal format ["%1",_name];
				} else {
					deleteMarkerLocal _name;
				};
			};
		} count playableUnits;
	}else{
		deleteMarkerLocal "Я здесь";
	};
	
	_humanity=GetHumanity(player);
	if(((_humanity<=5000)||(_humanity>=40000))||ShowMyBodys)then{
		{
			if (!isNull _x) then {
				_name = _x getVariable["bodyName","unknown"];
				if (_name == name player) then {_name = "Мой труп";};
				_pPos = getPosATL _x;
				_nameID = _name + str(_pPos);
				if (_name == "Мой труп") then {
					deleteMarkerLocal _nameID;
					_mrkr = createMarkerLocal [_nameID,_pPos];
					_mrkr setMarkerTypeLocal "DestroyedVehicle";
					_mrkr setMarkerTextLocal format ["%1",_name];
					_mrkr setMarkerColorLocal "ColorRed";
				} else {
					deleteMarkerLocal _nameID;
				};
			};
		} count allDead;
	};
};