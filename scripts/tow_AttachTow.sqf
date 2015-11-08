/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
/**
 * mf-tow/tow_AttachTow.sqf
 * The action for attaching the tow to another vehicle. 
 *
 * Created by Matt Fairbrass (matt_d_rat)
 * Version: 1.1.2
 * MIT Licence
 **/
#include "defines.h"

private ["_cargo","_started","_finished","_animState","_isMedic","_cargoName","_truckName","_towTruck","_towableVehicles","_towableVehiclesTotal","_cargoOffsetY","_towTruckOffsetY","_offsetZ","_hasToolbox"];

CheckActionInProgressLocalize(str_epoch_player_96);

player removeAction s_player_towing;s_player_towing=-1;

_towTruck = THIS3;
_towableVehicles=[_towTruck] call MF_Tow_Towable_Array;
_towableVehiclesTotal=count (_towableVehicles);
_cargo=[_towTruck,_towableVehicles,MF_Tow_Distance]call fnc_getNearestVehicle;
if!(isNull _cargo)then{
	_hasToolbox = "ItemToolbox" in (items player);
	if(!_hasToolbox)exitWith{cutText ["Необходим Набор инструментов.","PLAIN DOWN"]};
	if!([_towTruck,_cargo]call fnc_checkForTow)exitWith{};

	_cargoName=[_cargo]call object_getNameWithComment;
	_truckName=[_towTruck]call object_getNameWithComment;
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	[player,20,true,(getPosATL player)] spawn player_alertZombies;
	[1,1] call dayz_HungerThirst;
	cutText [format["Начинаю сцепку с %1...",_cargoName],"PLAIN DOWN"];
	ANIMATION_MEDIC(false);

	if(_finished)then{
		if!([_towTruck,_cargo]call fnc_checkForTow)exitWith{};

		if(((vectorUp _cargo) select 2) > 0.5)then{
			if( _towableVehiclesTotal>0)then{
				_towTruckOffsetY=0.8;
				_cargoOffsetY=0.8;
				_offsetZ=0.1;

				// Calculate the offset positions depending on the kind of tow truck
				switch(true)do{
					case (_towTruck isKindOf "ArmoredSUV_Base_PMC");
					case (_towTruck isKindOf "SUV_Base_EP1"):{_towTruckOffsetY=0.9};
					case (_towTruck isKindOf "UAZ_Base" && !(_cargo isKindOf "UAZ_Base")) : {_offsetZ=1.8};
				};

				// Calculate the offset positions depending on the kind of vehicle
				switch(true)do{
					case (_cargo isKindOf "Truck" && !(_towTruck isKindOf "Truck")) : {_cargoOffsetY = 0.9};
					case (_cargo isKindOf "UAZ_Base" && !(_towTruck isKindOf "UAZ_Base")) : {_offsetZ = -1.8};
					case (_cargo isKindOf "Mi17_base") : {_offsetZ = -0.4};
					case (_cargo isKindOf "Mi24_Base") : {_offsetZ = -0.4};
					case (_cargo isKindOf "UH60_Base") : {_offsetZ = -0.2};
					case (_cargo isKindOf "Ka60_GL_PMC") : {_offsetZ = -0.1};
					case (_cargo isKindOf "AN2_DZ") : {_offsetZ = -0.4};
					case (_cargo isKindOf "An2_1_TK_CIV_EP1") : {_offsetZ = -0.4};
					case (_cargo isKindOf "An2_2_TK_CIV_EP1") : {_offsetZ = -0.4};
					case (_cargo isKindOf "AH1_Base") : {_offsetZ = -0.3};
					case (_cargo isKindOf "AH64_base_EP1") : {_offsetZ = -0.3};
					case (_cargo isKindOf "AW159_Lynx_BAF") : {_offsetZ = -0.7};
					case (_cargo isKindOf "Mi17_DZE") : {_offsetZ = -0.4};
					case (_cargo isKindOf "Mi17_Civilian_DZ") : {_offsetZ = -0.4};
					case (_cargo isKindOf "MH60S_DZE") : {_offsetZ = -0.2};
					case (_cargo isKindOf "UH60M_EP1_DZE") : {_offsetZ = -0.2};
					case (_cargo isKindOf "A10_US_EP1") : {_offsetZ = -4.0};
					case (_cargo isKindOf "A10") : {_offsetZ = -4.0};
					case (_cargo isKindOf "Su34") : {_offsetZ = -1.0};
					case (_cargo isKindOf "L39_TK_EP1") : {_offsetZ = -0.2};
					case (_cargo isKindOf "Su25_base") : {_offsetZ = -0.2};
					case (_cargo isKindOf "F35B") : {_offsetZ = -0.5};
				};
					
				// Attach the vehicle to the tow truck
				_cargo attachTo [_towTruck,
					[
						0,
						(boundingBox _towTruck select 0 select 1)*_towTruckOffsetY+(boundingBox _cargo select 0 select 1)*_cargoOffsetY,
						(boundingBox _towTruck select 0 select 2)-(boundingBox _cargo select 0 select 2)+_offsetZ
					]
				];

				[_towTruck,_cargo] call fnc_vehInTow;
				cutText [format["К %1 прицеплен(а) %2.",_truckName,_cargoName],"PLAIN DOWN"];
			};
		};
	}else{
		cutText [format["Сцепка %1 и %2 отменена.",_cargoName,_truckName],"PLAIN DOWN"];
	};
}else{
	cutText [format["Разрешённая для буксировки техника не обнаружена. Минимальное расстояние для сцепки %1м.",MF_Tow_Distance], "PLAIN DOWN"];
};
DZE_ActionInProgress=false;
