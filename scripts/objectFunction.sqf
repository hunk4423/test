/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

fnc_serverDeleteObject={if(isServer)then{_this call server_deleteObj}else{PVDZE_obj_Delete=_this;publicVariableServer "PVDZE_obj_Delete"}};

fnc_serverUpdateObject={if(isServer)then{_this call server_updateObject}else{PVDZE_veh_Update=_this;publicVariableServer "PVDZE_veh_Update"}};

object_setComment={
	PVT3(_object,_comment,_array);
	PARAMS2(_object,_comment);
	_array=toArray(_comment);
	{if(_x==22)then{_x=27}}forEach _array;
	_comment=toString(_array);
	if (!isNull _object)then{SetComment(_object,_comment);[_object,"comment"]call fnc_serverUpdateObject};
};

fnc_MakeNameWithComment={
	PARAMS3PVT(_n,_c,_co);
	if (_c!="")then{if (_co)then{_n=_c}else{_n=format["%1 (%2)",_n,_c]}};
	_n
};

object_getNameWithComment={
	PVT2(_o,_f);
	PARAMS1(_o);
	if (CNT(_this)>1)then{_f=THIS1}else{_f=false};
	[getText(configFile >> "CfgVehicles" >> (typeOf _o) >> "displayName"),GetComment(_o),_f]call fnc_MakeNameWithComment
};

object_formatCommentWithID={
	PVT2(_i,_n);
	_n=GetComment(_this);_i=GetObjID(_this);
	if (_n!="")then{_n=format['"%1" ',_n]};
	format["%1(ID:%2)",_n,_i]
};

object_CommentDlg={
	PVT2(_charID,_ownerUID);
	CheckActionInProgress(MSG_BUSY);
	selectedObject=THIS0;
	createDialog "ObjectComment";
	waitUntil {!isNull (findDisplay 3100)};
	ctrlSetText [3102,GetComment(selectedObject)];
	DZE_ActionInProgress=false;
};

object_findByID={
	PVT6(_id,_pos,_filter,_range,_objects,_rc);
	PARAMS4(_id,_pos,_filter,_range);
	_rc=ObjNull;
	_objects=nearestObjects [_pos,_filter,_range];
	{if (GetObjID(_x)==_id)exitWith{_rc=_x}}count _objects;
	_rc
};


fnc_checkObjectIntersect={
	private ["_obj1","_obj2","_pos1","_size1","_dir1","_pos2","_size2","_dir2","_z1","_z2","_cos1","_cos2","_sin1","_sin1"];
	PARAMS4(_obj1,_obj2);
	EXPLODE3(_obj1,_pos1,_size1,_dir1);
	EXPLODE3(_obj2,_pos2,_size2,_dir2);
	// Проверка по высоте
	_z1 = SEL2(_pos1);
	_z2 = SEL2(_pos2);
	if (_z1>(_z2+SEL2(_size2)))exitWith{false};
	if ((_z1+SEL2(_size1))<_z2)exitWith{false};
	// Проверка перекрытия
	// За базу берем _obj1
	_cos1=cos(_dir1);_sin1=sin(_dir1);
	_cos2=cos(_dir2);_sin2=sin(_dir2);
	// 
};

fnc_getNearWorkBench={
	PVT3(_unit,_range,_rc);
	PARAMS2(_unit,_range);
	_rc=nearestObjects[_unit,["Wooden_shed_DZ","WoodShack_DZ","WorkBench_DZ"],_range];
	if (CNT(_rc)>0)then{_rc=SEL0(_rc)}else{_rc=ObjNull};
	_rc
};

fnc_getNearInFlame={
	PVT3(_unit,_range,_rc);
	PARAMS2(_unit,_range);
	_rc=ObjNull;
	{if(inflamed _x)exitWith{_rc=_x}}count(nearestObjects[_unit,[],_range]);
	_rc
};
