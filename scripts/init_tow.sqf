/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
/**
 * mf-tow/init.sqf
 * The main script for initalising towing functionality. 
 *
 * Created by Matt Fairbrass (matt_d_rat)
 * Version: 1.1.2
 * MIT Licence
 **/
#include "defines.h"

PVT3(_cursorTarget,_towableVehicles,_towableVehiclesTotal);

// Public variables
MF_Tow_Base_Path		= "scripts\mf-tow"; 	// The base path to the MF-Tow Folder.
MF_Tow_Distance			= 10;					// Minimum distance (in meters) away from vehicle the tow truck must be to tow.

MF_truck = ["Wheeled_APC","Motorcycle","Car","BAF_Jackal2_BASE_D"];
MF_suv =  ["Motorcycle","TowingTractor","Motorcycle","GLT_M300_ST","GLT_M300_LT","LandRover_Base","UAZ_Base","ArmoredSUV_Base_PMC","SUV_Base_EP1","S1203_TK_CIV_EP1","Volha_TK_CIV_Base_EP1","VWGolf","tractor","SkodaBase","Pickup_PK_base","Offroad_DSHKM_base","Lada_base","HMMWV_Base","hilux1_civil_1_open","BTR40_base_EP1","BTR40_MG_base_EP1","BAF_Jackal2_BASE_D"];
MF_v3s =   ["Motorcycle","Truck","BAF_Jackal2_BASE_D"] + MF_suv;

MF_Tow_Towable_Array =
{
	PVT2(_array,_towTruck);
	_towTruck = THIS0;
	_array = [];

	switch true do
	{
		case ((_towTruck isKindOf "Wheeled_APC")||(_towTruck isKindOf "BTR40_base_EP1")||(_towTruck isKindOf "HMMWV_Base")||(_towTruck isKindOf "Ural_Base")||(_towTruck isKindOf "Kamaz_Base")||(_towTruck isKindOf "MTVR")||(_towTruck isKindOf "Tractor")):{_array = MF_truck};
		case ((_towTruck isKindOf "Offroad_DSHKM_base")||(_towTruck isKindOf "M113_Base")||(_towTruck isKindOf "BAF_Jackal2_BASE_D")||(_towTruck isKindOf "UAZ_Base")):{_array = MF_v3s};
		case ((_towTruck isKindOf "LandRover_Base")||(_towTruck isKindOf "ArmoredSUV_Base_PMC")||(_towTruck isKindOf "SUV_Base_EP1")||(_towTruck isKindOf "Ikarus")):{_array = MF_suv};
		case ((_towTruck isKindOf "Lada_base")||(_towTruck isKindOf "Pickup_PK_base")||(_towTruck isKindOf "SkodaBase")||(_towTruck isKindOf "Volha_TK_CIV_Base_EP1")||(_towTruck isKindOf "S1203_TK_CIV_EP1")||(_towTruck isKindOf "GLT_M300_ST")||(_towTruck isKindOf "VWGolf")):{_array = MF_suv};
		case (_towTruck isKindOf "Tank"):{_array = ["LandVehicle"]};
		case (_towTruck isKindOf "TowingTractor"):{_array = ["Air"]};

		case (typeOf _towTruck == "V3S_Open_TK_CIV_EP1"):			{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_Open_TK_EP1"):				{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_Civ"):						{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_RA_TK_GUE_EP1_DZE"):			{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_TK_EP1_DZE"):				{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_Refuel_TK_GUE_EP1_DZ"):		{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_Repair_TK_GUE_EP1"):			{_array = MF_v3s};
		case (typeOf _towTruck == "V3S_Reammo_TK_GUE_EP1"):			{_array = MF_v3s};

		case (typeOf _towTruck == "hilux1_civil_1_open"):			{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_2_covered"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open"):			{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open_EP1"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_1_open_DZE1"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_2_covered_DZE1"):	{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open_DZE1"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_1_open_DZE2"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_2_covered_DZE2"):	{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open_DZE2"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_1_open_DZE3"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_2_covered_DZE3"):	{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open_DZE3"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_1_open_DZE4"):		{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_2_covered_DZE4"):	{_array = MF_v3s};
		case (typeOf _towTruck == "hilux1_civil_3_open_DZE4"):		{_array = MF_v3s};
	};
	_array
};