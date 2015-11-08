#include "defines.h"

private ["_objectID","_veh_found","_vehicles","_found","_finalID","_key","_keyName","_markerColour","_foundv","_garage","_keys","_playerUID"];

_add_marker={
	PVT6(_name,_pos,_key,_keyid,_id,_vehicleMarker);
	PARAMS5(_name,_pos,_key,_keyid,_id);

	systemChat format ["%1. CharID: %2 (%3)",_name,_keyid,_key];

	_vehicleMarker = createMarkerLocal ["vehicleMarker" + str(_id),[SEL0(_pos),SEL1(_pos)]];
	_vehicleMarker setMarkerShapeLocal "ICON";
	_vehicleMarker setMarkerTypeLocal "DOT";
	_vehicleMarker setMarkerColorLocal _markerColour;
	_vehicleMarker setMarkerSizeLocal [1.0, 1.0];
	_vehicleMarker setMarkerTextLocal format ["%1",_name];
};

_make_name={
	format["%1 (%2)",gettext (configFile >> "CfgVehicles" >> THIS0 >> "displayName"),THIS1];
};

_markerColour = "ColorOrange";    // Alternatives = "ColorBlack", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWhite"
_veh_found=[];
_foundv=0;
_playerUID=getPlayerUID player;
closedialog 0;
for "_i" from 0 to 50 do {deleteMarkerLocal ("vehicleMarker"+str(_i))};

_keys=[player]call fnc_getPlayerKeys;
{
	_found = 0;
	EXPLODE2(_x,_finalID,_key);
	_keyName = getText (configFile >> "CfgWeapons" >> _key >> "displayName");
	
	{
		_typeof=typeOf _x;
		if ((parseNumber (GetCharID(_x))==_finalID) && ([_typeof,true]call vehicle_isVehicle) && (GetOwnerUID(_x)==_playerUID))then{
			_found = 1;
			[[_typeof,GetComment(_x)]call _make_name,getPosATL _x,_keyName,_finalID,_foundv] call _add_marker;
			_foundv = _foundv +1;
			_veh_found set[CNT(_veh_found),GetObjID(_x)];
		};
	} forEach vehicles;
	if ([[[1,_finalID,0,player],"vehfind"],15] call fnc_GarageResultWait)then{
		_vehicles=PVDZE_GarageResult;
		if (typeName _vehicles=="ARRAY")then{
			{
				_objectID=SEL1(_x);
				if!(_objectID in _veh_found)then{
					_garage=[SEL0(_x),[0,0,0],DZE_Garage,25000] call object_findByID;
					if!(isNull _garage)then{
						_found=1;
						[[SEL2(_x),SEL4(_x)]call _make_name,getPosATL _garage,_keyName,_finalID,_foundv]call _add_marker;
						_foundv=_foundv+1;
						_veh_found set[CNT(_veh_found),_objectID];
					};
				};
			}forEach _vehicles;
		};
	};
	if (_found==0)then{systemChat format ["%1 - CharID: %2 - (Техника не существует)",_keyName,_finalID]};	
}forEach _keys;

if ([[[4,0,0,player],"vehfind"],15] call fnc_GarageResultWait)then{
	_vehicles=PVDZE_GarageResult;
	if (typeName _vehicles=="ARRAY")then{
		{
			if!(SEL1(_x) in _veh_found)then{
				_garage=[SEL0(_x),[0,0,0],DZE_Garage,25000] call object_findByID;
				if!(isNull _garage)then{
					[[SEL2(_x),SEL4(_x)]call _make_name,getPosATL _garage,"Владелец",SEL3(_x),_foundv] call _add_marker;
					_foundv=_foundv+1;
				};
			};
		}forEach _vehicles;
	};
};

systemChat format ["Ключей найдено: %1",CNT(_keys)];
systemChat format ["Всего техники найдено: %1",_foundv];
if (_foundv!=0)then{systemChat "Техника отмечена на карте."};
