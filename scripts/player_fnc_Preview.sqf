/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
	
	[object,type,[params]]spawn fnc_Preview;
*/
#include "defines.h"

private ["_openTraderDialog","_TraderMenuItem","_TraderMenuCategory","_SliderPos","_previewHeli","_openObjectDialog","_addWeapon","_class","_method","_data","_pos","_msgCnt","_OriVehSkins","_skins","_paint","_openSkinDialog","_displayName","_VehicleInfoText","_vehicleName","_vehicleSpeed","_vehicleSeats","_vehicleWeapons","_vehicleMagazines","_vehicleBackpacks","_vehicleArmor","_vehicleFuel","_skinsNumber","_colour1","_colour2","_SkinList","_delArray","_previewObj","_vehicleInit","_vd","_cfgCam"];
CheckActionInProgress(MSG_BUSY);
_class=THIS0;
_data=THIS2;
CamDistanceY=20;
CamDistanceZ=5;
PreviewLoop=true;
PreviewTorsion=true;
_pos=[971.266,984.902,3000];
_msgCnt=0;
_OriVehSkins=false;
_skins=false;
_paint=false;
_openSkinDialog=false;
_addWeapon=false;
_openObjectDialog=false;
_previewHeli=false;
_openTraderDialog=false;
_cfgCam=[30,2505,[0,20,5]];

switch(THIS1)do{
	case "object":{
		_openObjectDialog=true;
		_VehicleInfoText=format["<t size='0.7' align='center' color='#5882FA'>%1</t>",_class];
		if(ComboBoxResult in ["Billboards","Helipads","Tents","Wells","Fuel","FlagsNations","FlagsOrganizations","FlagsMedical","FlagsPlain","FlagsMisc","DHpad"])then{
			_VehicleInfoText=format ["<t size='0.7' align='center' color='#5882FA'>%1</t><br/><br/><t size='0.5'align='left'color='#FFBF00'>Этот объект можно установить только за донат.</t><br/><t size='0.5'align='left'color='#FFBF00'>Подробности в группе: vk.com/goldkey_dz</t>",_class];
		};
		if(ComboBoxResult=="LargeTrees")then{
			CamDistanceY = 30;
			_cfgCam=[30,2505,[0,30,5]];
		};
		if(_class in DZE_GaragePad)then{
			_pos=POSPREVIEWPAD;
			_previewHeli=true;
		};
		{ctrlShow [_x,false];} forEach [1800, 1801, 1802, 1000, 1001, 1002, 1003, 1004, 3900, 3901, 4900, 4901, 4902, 5900, 5901, 5902, 5903, 6900, 6901, 6902, 6903, 6904, 6905, 6906, 6907, 6908, 6909, 6910, 6911];
		{ctrlShow [_x,true];} forEach [1105,4903,4904,4905,4906,4907,4908,4909];
	};
	case "skin":{
		_class=Men_Clothing select SEL0(_data);
		systemChat format ["Скин: %1",_class];
		_openSkinDialog=true;
		_pos=[1601.08,980.832,2500.2];
		_cfgCam=[10,2502,[0,10,2]];
		CamDistanceY=10;CamDistanceZ=2;
		_addWeapon=true;
	};
	case "vehicle":{
		_openTraderDialog=true;_TraderMenuCategory=SEL0(_data);_TraderMenuItem=SEL1(_data);
		_vehicleName=getText (configFile>>"CfgVehicles">>_class>>"displayName");
		_vehicleSpeed=getNumber (configFile>>"CfgVehicles">>_class>>"maxSpeed");
		_vehicleSeats=getNumber (configFile>>"CfgVehicles">>_class>>"transportSoldier");
		_vehicleWeapons=getNumber (configFile>>"CfgVehicles">>_class>>"transportMaxWeapons");
		_vehicleMagazines=getNumber (configFile>>"CfgVehicles">>_class>>"transportMaxMagazines");
		_vehicleBackpacks=getNumber (configFile>>"CfgVehicles">>_class>>"transportMaxBackpacks");
		_vehicleFuel=getNumber (configFile>>"CfgVehicles">>_class>>"fuelCapacity");
		
		switch(true)do{
			case (_class in ArmorAir):{_vehicleArmor="4 попадания ПЗРК";};
			case ((_class isKindOf "Air")&&!(_class in ArmorAir)):{_vehicleArmor="3 попадания ПЗРК";};
			case (_class in ["BTR90","T72_TK_EP1","T72_CDF","T72_INS","T72_RU","T72_Gue","T55_TK_EP1","T55_TK_GUE_EP1","BMP3"]):{_vehicleArmor="6 попаданий ПЗРК";};
			case (_class in ["T34","T34_TK_EP1","M2A2_EP1","M2A3_EP1","M6_EP1","AAV","BTR60_TK_EP1","LAV25","BMP2_TK_EP1","BMP2_UN_EP1","BMP2_CDF","BMP2_INS"]):{_vehicleArmor="4 попадания ПЗРК";};
			case (_class in ["BTR90_HQ_DZ","LAV25_HQ_DZ","GAZ_Vodnik_HMG"]):{_vehicleArmor="3 попадания ПЗРК";};
			default {_vehicleArmor=getNumber (configFile>>"CfgVehicles">>_class>>"armor");};
		};

		_VehicleInfoText=format["
			<t size='0.7'align='center'color='#5882FA'>%1</t><br/><t></t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Максимальная скорость:</t><t size='0.5'color='#FFFFFF'align='right'>%2 км/ч</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Количество мест:</t><t size='0.5'color='#FFFFFF'align='right'>%3</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Оружейные слоты:</t><t size='0.5'color='#FFFFFF'align='right'>%4</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Общие слоты:</t><t size='0.5'color='#FFFFFF'align='right'>%5</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Слоты для сумок:</t><t size='0.5'color='#FFFFFF'align='right'>%6</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Топливо:</t><t size='0.5'color='#FFFFFF'align='right'>%7 л.</t><br/>
			<t size='0.5'align='left'color='#FFBF00'>Броня:</t><t size='0.5'color='#FFFFFF'align='right'>%8</t>",
			_vehicleName,_vehicleSpeed,(_vehicleSeats+1),_vehicleWeapons,_vehicleMagazines,_vehicleBackpacks,_vehicleFuel,_vehicleArmor
		];		
	};
	case "OriVehSkins":{
		_class=typeOf VehicleForChengeSkin;_OriVehSkins=true;_skinsNumber=SEL0(_data)+1;
		systemChat format ["Предпросмотр расширенной покраски #%1",_skinsNumber];
		_displayName=getText(configFile>>"CfgVehicles">>_class>>"displayName");
		_VehicleInfoText=format["<t size='0.7' align='center' color='#5882FA'>%1</t><br/><t></t><br/><t size='0.5' align='center' color='#7EC0EE'>Предпросмотр расширенной покраски #%2</t><br/>",_displayName,_skinsNumber];
	};
	case "paint":{
		_class=typeOf VehicleToPaint;_paint=true;_colour1=SEL0(_data);_colour2=SEL1(_data);_SliderPos=SEL2(_data);
		_displayName=[VehicleToPaint,true] call object_getNameWithComment;
		_VehicleInfoText=format["<t size='0.7' align='center' color='#5882FA'>%1</t>",_displayName];
	};
	case "itemSkins":{
		_displayName=getText(configFile>>"CfgMagazines">>_class>>"displayName");
		_VehicleInfoText=format["<t size='0.7' align='center' color='#5882FA'>%1</t><br/><t></t><br/><t size='0.5' align='center' color='#7EC0EE'>%2</t><br/>",_displayName,_class];
		_openTraderDialog=true;_TraderMenuCategory=SEL0(_data);_TraderMenuItem=SEL1(_data);_SkinList=SEL2(_class call fnc_GetSkinInfoByName);
		if(CNT(_SkinList)>1)then{
			CamDistanceY=15;CamDistanceZ=3;
			_cfgCam=[30,2503,[0,15,3]];
			_delArray=[];
			_pos=[971.266,984.902,2500.2];
			_skins=true;
			PreviewTorsion=false;
		}else{
			CamDistanceY=10;CamDistanceZ=2;
			_pos=[1601.08,980.832,2500.2];
			_cfgCam=[10,2502,[0,10,2]];
			_class=SEL0(_SkinList);
			_addWeapon=true;
		};
	};	
};

if(!_openObjectDialog)then{closeDialog 0;};
0 cutText ["Подготовка к просмотру...","BLACK OUT",1];
if(!isNil "previewHelper")then{deleteVehicle previewHelper;previewHelper=objNull;};

previewHelper="Sign_sphere10cm_EP1" createVehicleLocal _pos;
if(_previewHeli)then{previewHelper setPosATL _pos;}else{previewHelper setPosASL _pos;};
previewHelper setDir 0;
previewHelper setVelocity [0,0,0];
previewHelper setObjectTexture [0,""];

//Создание объекта
if(_skins)then{
	{
		_previewObj=_x createVehicleLocal([_pos, 0, 5, 0, 2, 2500, 0] call BIS_fnc_findSafePos);
		_previewObj addweapon "DMR";
		_delArray set[count _delArray,_previewObj];
	}count _SkinList;
}else{
	_previewObj=_class createVehicleLocal _pos;
	_previewObj attachto [previewHelper,[0,0,0]];
	if(_addWeapon)then{_previewObj addweapon "DMR";};
};

if(_paint)then{
	_previewObj setObjectTexture[0,format["#(argb,8,8,3)color(%1)",_colour1]];
	_previewObj setObjectTexture[1,format["#(argb,8,8,3)color(%1)",_colour2]];
};
#ifdef _ORIGINS
if(_OriVehSkins)then{
	_vehicleInit="";
	{
		_previewObj setObjectTexture [_forEachIndex,format["\ori\vehicles\%1",_x]];
		_vehicleInit=_vehicleInit+(format["this setObjectTexture [%1, ""\ori\vehicles\%2""];",_forEachIndex,_x]);
	}forEach(([_previewObj,_skinsNumber] call fnc_veh_getSkinFiles)select 0);
};
if(_class in OriProtectedVeh)then{{_previewObj animate [_x,1];}count["hopa","doska"];};
#endif

//Дальность, камера, звук, обработчики
_vd=viewdistance;setViewDistance 300;0 fadeSound 0;
ObjPreview_Camera="camera" camCreate [SEL0(_pos),SEL1(_pos)-SEL0(_cfgCam),SEL1(_cfgCam)];
showCinemaBorder false;
ObjPreview_Camera cameraEffect ["internal","back"];
ObjPreview_Camera camSetTarget previewHelper;
ObjPreview_Camera camSetRelPos SEL2(_cfgCam);
ObjPreview_Camera camCommit 0;
waitUntil {camCommitted ObjPreview_Camera};
PreviewAbortHotkey = (findDisplay 46) displayAddEventHandler ["KeyDown", "_handled=false;if((_this select 1)==0x3F)then{PreviewLoop=false;PreviewTorsion=false;(findDisplay 46) displayRemoveEventHandler ['KeyDown', PreviewAbortHotkey];(findDisplay 46) displayRemoveEventHandler ['KeyDown', PreviewRotateHotkey];(findDisplay 46) displayRemoveEventHandler ['KeyDown', PreviewZoomHotkey];_handled = true;};_handled"];
PreviewRotateHotkey = (findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = false;if((_this select 1)==0xCB)then{PreviewTorsion=false;_dir = getDir previewHelper;if(_dir==0)then{previewHelper setDir 359.5;};previewHelper setDir(_dir - 0.5);_handled = true;};if((_this select 1)==0xCD)then{PreviewTorsion=false;_dir = getDir previewHelper;if(_dir==359.5)then{previewHelper setDir 0;};previewHelper setDir(_dir + 0.5);_handled = true;};_handled"];
PreviewZoomHotkey = (findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = false;if((_this select 1)==0xC8)then{PreviewTorsion=false;if(CamDistanceY > 5)then{CamDistanceY = CamDistanceY - 0.1;ObjPreview_Camera camSetRelPos [0,CamDistanceY,CamDistanceZ];ObjPreview_Camera camCommit 0;};_handled = true;};if((_this select 1)==0xD0)then{PreviewTorsion=false;if(CamDistanceY < 35)then{CamDistanceY = CamDistanceY + 0.1;ObjPreview_Camera camSetRelPos [0,CamDistanceY,CamDistanceZ];ObjPreview_Camera camCommit 0;};_handled = true;};_handled"];
0 cutText ["","BLACK IN",1];

[]spawn{
	while{PreviewTorsion}do{
		previewHelper setDir(getDir previewHelper+0.15);
		uiSleep .01;
	};
};
cutText["Для выхода из просмотра нажмите F5","PLAIN DOWN"];
while{PreviewLoop}do{
	if(_msgCnt==5)then{
		cutText["Что бы повернуть технику нажимайте кнопки НАЛЕВО/НАПРАВО\nДля приближения/отдаления ВПЕРЕД/НАЗАД","PLAIN DOWN"];
		[_VehicleInfoText, [safezoneX + safezoneW - 0.8,0.50], [safezoneY + safezoneH - 0.8,0.7], 6, 0] spawn BIS_fnc_dynamicText;
	};
	if(_msgCnt==10)then{
		cutText["Для выхода из просмотра нажмите F5","PLAIN DOWN"];
		[_VehicleInfoText, [safezoneX + safezoneW - 0.8,0.50], [safezoneY + safezoneH - 0.8,0.7], 6, 0] spawn BIS_fnc_dynamicText;
		_msgCnt=0;
	};
	_msgCnt=_msgCnt+1;
	uiSleep 1;
};

0 cutText["","BLACK OUT",1];
deleteVehicle previewHelper;previewHelper=objNull;
ObjPreview_Camera cameraEffect ["terminate","back"];camDestroy ObjPreview_Camera;
if(_skins)then{
	{deletevehicle _x;}count _delArray;
}else{
	deletevehicle _previewObj;
};
setViewDistance _vd;0 fadeSound 1;
0 cutText["","BLACK IN",1];

if(_openSkinDialog)exitWith{
	createDialog "MenClothing";call FillSkinList;
	DZE_ActionInProgress=false;
};
if(_OriVehSkins)exitWith{
	createDialog "vehicle_ChengeSkin";[VehicleForChengeSkin]call fnc_veh_FillSkinList;
	DZE_ActionInProgress=false;
};
if(_openObjectDialog)exitWith{
	{ctrlShow [_x,true];} forEach [1800, 1801, 1802, 1000, 1001, 1002, 1003, 1004, 3900, 3901, 4900, 4901, 4902, 5900, 5901, 5902, 5903, 6900, 6901, 6902, 6903, 6904, 6905, 6906, 6907, 6908, 6909, 6910, 6911];
	{ctrlShow [_x,false];} forEach [1105,4903,4904,4905,4906,4907,4908,4909];
	DZE_ActionInProgress=false;
};
if(_paint)exitWith{
	_nil=[nil,nil,nil,VehicleToPaint]EXECVM_SCRIPT(player_paint.sqf);
	uiSleep 0.3;
	{sliderSetPosition [SEL0(_x),SEL1(_x)];}forEach _SliderPos;
	call VehicleColourUpdate;call VehicleColourUpdate2;
	DZE_ActionInProgress=false;
};
if(_openTraderDialog)exitWith{
	DZE_ActionInProgress=false;
	_nil=[nil,nil,nil,LastTraderMenu]EXECVM_SCRIPT(show_dialog.sqf);
	waitUntil {dialog};
	lbSetCurSel [12000, _TraderMenuCategory];
	[_TraderMenuCategory] spawn TraderDialogLoadItemList;
	//uisleep 0.5;
	lbSetCurSel [12001, _TraderMenuItem];
	[_TraderMenuItem] spawn TraderDialogShowPrices;
	LastTraderSelectCategory=nil;
	LastTraderSelectItem=nil;
	PreviewListCfg=nil;	
};
DZE_ActionInProgress=false;