/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_control","_parent","_group","_pos","_item","_conf","_name","_cfgActions","_numActions","_height","_menu","_config","_script","_compile","_array","_name","_erc_cfgActions","_erc_numActions","_count","_temp_keys_names","_ownerKeyId","_ownerKeyName","_locked","_obj","_text","_ObjID"];

disableSerialization;
_control=THIS0;
_parent=findDisplay 106;

if(THIS1==1)then{
	_group=_parent displayCtrl 6902;
	_pos=ctrlPosition _group;
	_pos set [0,((_this select 2) + 0.48)];
	_pos set [1,((_this select 3) + 0.07)];

	_item=gearSlotData _control;
	_conf=configFile >> "cfgMagazines" >> _item;
	if(!isClass _conf)then{_conf=configFile >> "cfgWeapons" >> _item;};
	_name=getText(_conf >> "displayName");

	_cfgActions=_conf >> "ItemActions";
	_numActions=(count _cfgActions);
	_height=0;
	if(_item in[ITEMoffNUMACTIONS])then{_numActions=0;};

	//Populate Menu
	for "_i" from 0 to(_numActions - 1)do{
		_menu=_parent displayCtrl (1600 + _i);
		_menu ctrlShow true;
		_config=(_cfgActions select _i);
		_script=getText(_config >> "script");
		_height=_height + (0.025 * safezoneH);
		_compile=format["_id = '%2' %1;",_script,_item];
		uiNamespace setVariable ['uiControl', _control];
		if(getNumber(_config >> "outputOriented")==1)then{
			/*
				This flag means that the action is output oriented
				the output class will then be transferred to the script
				&& the type used for the name
			*/			
			_array=getArray(_config >> "output");
			_name=getText (configFile >> (_array select 1) >> (_array select 0) >> "displayName");
			_compile=format["_id = ['%2',%3] %1;",_script,_item,_array];
		};
		_menu ctrlSetText format[getText(_config >> "text"),_name];
		_menu ctrlSetEventHandler ["ButtonClick",_compile];
	};
	
	// Add extra context menus
	_erc_cfgActions=(missionConfigFile >> "ExtraRc" >> _item);
	_erc_numActions=(count _erc_cfgActions);
	if(isClass _erc_cfgActions)then{
		for "_j" from 0 to(_erc_numActions - 1)do{
			_menu=_parent displayCtrl (1600 + _j + _numActions);
			_menu ctrlShow true;
			_config=(_erc_cfgActions select _j);
			_script=getText(_config >> "script");
			_height=_height+(0.025 * safezoneH);
			_compile=format["_id = '%2' %1;",_script,_item];
			uiNamespace setVariable['uiControl', _control];			
			_menu ctrlSetText(getText (_config >> "text"));
			_menu ctrlSetTextColor[1,0.25,0.25,1];
			_menu ctrlSetEventHandler ["ButtonClick",_script];
		};
	};

	//Открыть/закрыть ворота/технику
	_count=0;
	_temp_keys_names=[];
	// find available keys
	if(configName(inheritsFrom(configFile >> "CfgWeapons" >> _item))in itemKeyColor)then{
		_ownerKeyId=getNumber(configFile >> "CfgWeapons" >> _item >> "keyid");
		_ownerKeyName=getText(configFile >> "CfgWeapons" >> _item >> "displayName");
		_temp_keys_names set[_ownerKeyId,_ownerKeyName];
		{
			if(alive _x)then{
				_locked=true;
				_obj=_x;
				_text=[_obj,true] call object_getNameWithComment;		
				if((typeOf _x)in DZE_DoorsLocked)then{
					{
						if((_obj animationPhase _x)==1)exitWith{
							_locked=false;
						};	
					}count["Open_hinge","Open_latch","Open_door"];
				}else{
					if!(locked _obj)then{
						_locked=false;
					};
				};					
				_ObjID=GetObjID(_obj);
				if((GetCharID(_obj))==str(_ownerKeyId))then{
					if(_locked)then{
						//Unlock
						_menu=_parent displayCtrl(1600+_numActions+_erc_numActions+_count);
						_menu ctrlShow true;
						_height=_height+(0.025 * safezoneH);
						uiNamespace setVariable['uiControl', _control];
						_menu ctrlSetText (format["Открыть %1",_text]);
						_menu ctrlSetTextColor[1,0.25,0.25,1];
						_menu ctrlSetEventHandler["ButtonClick","['"+_ObjID+"',false] execVM 'scripts\remote_lock_unlock.sqf'"];
					}else{
						//Lock
						_menu=_parent displayCtrl(1600+_numActions+_erc_numActions+_count);
						_menu ctrlShow true;
						_height=_height+(0.025 * safezoneH);
						uiNamespace setVariable['uiControl', _control];
						_menu ctrlSetText (format["Закрыть %1",_text]);
						_menu ctrlSetTextColor[1,0.25,0.25,1];
						_menu ctrlSetEventHandler["ButtonClick","['"+_ObjID+"',true] execVM 'scripts\remote_lock_unlock.sqf'"];
					};
					_count=_count+1;
				};
			};
		}count(nearestObjects [getPos player,[VEHICLE_TYPE]+DZE_DoorsLocked, 100]);
	};
	/*
	//Скин в канвас
	if(["Skin_",_item] call fnc_inString)then{
		_menu=_parent displayCtrl(1600+_numActions);
		_menu ctrlShow true;
		_height=_height+(0.025 * safezoneH);
		uiNamespace setVariable ['uiControl',_control];
		_menu ctrlSetText "Создать: Canvas";
		_menu ctrlSetTextColor[1,0.25,0.25,1];
		_menu ctrlSetEventHandler["ButtonClick","[_item] execVM 'scripts\сanvas.sqf'"];
	};
	*/
	_pos set[3,_height];
	_group ctrlShow true;
	ctrlSetFocus _group;
	_group ctrlSetPosition _pos;
	_group ctrlCommit 0;
};