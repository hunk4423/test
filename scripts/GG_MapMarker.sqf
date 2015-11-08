/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
// GG_MapMarker.sqf [1.0]
// Script adds player name to the created map marker
// by Prodavec, thanks to Gunter Severloh, PvPscene, Maca
#include "defines.h"

#define MMT_DIK_ESC				1
#define MMT_DIK_ENTER			28
#define MMT_DIK_KPENTER			156
#define MMT_SEARCHTIME			2
#define MMT_DISPLAY_MAP			12
#define MMT_DISPLAY_MARKER		54
#define MMT_CONTROL_MAP			51
#define MMT_CONTROL_MARKER		101

fnc_marker_keyUp_EH = {
	PVT5(_display,_dikCode,_control,_text,_dst);
	PARAMS2(_display,_dikCode);

	if ((_dikCode == MMT_DIK_ENTER)||(_dikCode == MMT_DIK_KPENTER))then{
		_control=_display displayCtrl MMT_CONTROL_MARKER;
		_text=ctrlText _control;
		if (!isNil "MissionMarkers")then{
			{
				if ((MapClickPos distance _x)<300)exitWith{
					_dst=round(_x distance (getpos player));
					if (_text == "") then {_text = format ["(%1м)",_dst]}else{_text=format["(%1м) %2",_dst,_text]};
					PVDZE_send=[player,"EMSMark",_dst];
					publicVariableServer "PVDZE_send";
				};
			}forEach MissionMarkers;
		};
		if (_text=="")then{
			_text=format ["%1",name player];
		}else{
			_text=format ["%1: %2",name player,_text];
		};
		_control ctrlSetText _text;
		_display displayRemoveAllEventHandlers "keyUp";
		_display displayRemoveAllEventHandlers "keyDown";
	};
	false
};

fnc_marker_keyDown_EH = {
	PVT2(_display,_dikCode);
	PARAMS2(_display,_dikCode);

    if (_dikCode==MMT_DIK_ESC)then{
        _display displayRemoveAllEventHandlers "keyUp";
        _display displayRemoveAllEventHandlers "keyDown";
    };
	false
};

fnc_map_mouseButtonDblClick_EH = {
    PVT(_display);
	MapClickPos=THIS0 posScreenToWorld [THIS2,THIS3];
    disableUserInput true;

    (time+MMT_SEARCHTIME)spawn{
        disableSerialization;

        while {time<_this} do {
            _display=findDisplay MMT_DISPLAY_MARKER;
            if !(isNull _display)exitWith{
                _display displayAddEventHandler ["keyUp","_this call fnc_marker_keyUp_EH"];
                _display displayAddEventHandler ["keyDown","_this call fnc_marker_keyDown_EH"];
            };
        };
        disableUserInput false;
    };
    true;
};

waitUntil {sleep 0.1; !isNull (findDisplay MMT_DISPLAY_MAP)};
((findDisplay MMT_DISPLAY_MAP) displayCtrl MMT_CONTROL_MAP) ctrlAddEventHandler ["mouseButtonDblClick", "call fnc_map_mouseButtonDblClick_EH"];