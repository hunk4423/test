#include "defines.h"

fnc_Load_Mats_and_Tools = {
//5900-5903 tools
//6901-6912 materials
{ctrlSetText [_x,""]}forEach[5900,5901,5902,5903,6900,6901,6902,6903,6904,6905,6906,6907,6908,6909,6910,6911];

_lbText=lbData[3901,lbCurSel 3901];

_toolTmp = "";
_weaps = weapons player;
_requiredtools = getArray (missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _lbText >> "requiredtools");
_craftdialog = uiNamespace getVariable "Advanced_CraftingV";
_counter=0;

while {count _requiredtools > 0} do { 
	_toolTmp=_requiredtools select 0;
	_tmp_Pos=_weaps find _toolTmp;

	switch (_counter) do {
	case 0: {
		if (_tmp_Pos > -1) then {
			(_craftdialog displayCtrl 5900) ctrlSetTextColor [0.2,0.839,0.2,1];
			_weaps set [_tmp_Pos,objNull];
		} else {
			(_craftdialog displayCtrl 5900) ctrlSetTextColor [1,0.278,0.278,1];
		};
		ctrlSetText [5900,_toolTmp];
	};
	case 1: {
		if (_tmp_Pos > -1) then {
			(_craftdialog displayCtrl 5901) ctrlSetTextColor [0.2,0.839,0.2,1];
			_weaps set [_tmp_Pos,objNull];
		} else {
			(_craftdialog displayCtrl 5901) ctrlSetTextColor [1,0.278,0.278,1];
		};
		ctrlSetText [5901,_toolTmp];
	};
case 2: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 5902) ctrlSetTextColor [0.2,0.839,0.2,1];
_weaps set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 5902) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [5902,_toolTmp];
};
case 3: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 5903) ctrlSetTextColor [0.2,0.839,0.2,1];
_weaps set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 5903) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [5903,_toolTmp];
};
default {};
};
_requiredtools set [0,objNull];
_requiredtools=_requiredtools-[objNull];
_weaps = _weaps-[objNull];
_counter=_counter + 1;
};

_materialTmp = "";
_mags = magazines player;
_requiredmaterials = getArray (missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _lbText >> "requiredmaterials");
_counter=0;

while{count _requiredmaterials>0} do { 

_materialTmp = _requiredmaterials select 0;
_tmp_Pos=_mags find _materialTmp;
switch (_counter) do {
case 0: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6900) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6900) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6900,_materialTmp];
};
case 1: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6901) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6901) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6901,_materialTmp];
};
case 2: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6902) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6902) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6902,_materialTmp];
};
case 3: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6903) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6903) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6903,_materialTmp];
};
case 4: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6904) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6904) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6904,_materialTmp];
};
case 5: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6905) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6905) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6905,_materialTmp];
};
case 6: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6906) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6906) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6906,_materialTmp];
};
case 7: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6907) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6907) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6907,_materialTmp];
};
case 8: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6908) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6908) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6908,_materialTmp];
};
case 9: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6909) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6909) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6909,_materialTmp];
};
case 10: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6910) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6910) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6910,_materialTmp];
};
case 11: 
{
if (_tmp_Pos > -1) then {
(_craftdialog displayCtrl 6911) ctrlSetTextColor [0.2,0.839,0.2,1];
_mags set [_tmp_Pos,objNull];
} else {
(_craftdialog displayCtrl 6911) ctrlSetTextColor [1,0.278,0.278,1];
};
ctrlSetText [6911,_materialTmp];
};

default {};
};
_requiredmaterials set [0,objNull];
_requiredmaterials=_requiredmaterials-[objNull];
_mags=_mags-[objNull];
_counter=_counter + 1;
}; 

};

fnc_Load_Items={
	PVT5(_items,_entry,_class,_text,_index);
	lbClear 3901;
	_items=(missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult);
	for "_i" from 0 to ( count _items)-1 do {
		_entry=_items select _i;
		if(isClass _entry)then{
			_class=configName _entry;
			_text=getText(missionConfigFile >> "Custom_Buildables" >> "Buildables" >> ComboBoxResult >> _class >> "displayName");
			if (_text=="")then{_text=_class};
			_index=lbAdd [3901,_text];
			lbSetData [3901,_index,_class];
        }; 
    }; 
	GlobalComboboxVariable=99;
};
