#include "defines.h"

checkSelectPlayerAction={};
SelectPlayerClick={};

OnSelectPlayerClick = {
	PARAMS1PVT(_pos);
	if (_pos<0)exitWith{};
	(findDisplay 4800) closeDisplay 1;
	switch(SelectPlayerAction)do{
		case "gift":{[SelectPlayerUnit,SEL2(SEL(Humans,_pos))] spawn player_giftVehicle};
		default {[[SelectPlayerUnit,SEL2(SEL(Humans,_pos))],SelectPlayerAction] spawn SelectPlayerClick};
	};
};

fnc_SelectPlayerDialog = {
	private ["_unit","_action","_range","_msg","_info","_done"];
	PARAMS4(_unit,_action,_range,_msg);
	disableSerialization;
	SelectPlayerUnit=_unit;
	SelectPlayerAction=_action;
	_info="";
	_done = false;
	switch (_action)do{
		case "gift": {
			_info="Если техника имеет восстановления, при<br/>подарке, все восстановления аннулируются";
			_done = true;
		};
		default {_done = [_action] call checkSelectPlayerAction};
	};

	if (!_done)exitWith{
		cutText [format["Неизвестная команда действия '%1'!",_action], "PLAIN DOWN"];
		diag_log(format["SELPLR:Неизвестная команда действия '%1' (unit '%2', msg '%3')",_action,str(_unit),_msg]);
	};
	createdialog "PlayerSelector";
	Humans=[_range] call fnc_getNearPlayersList;
	waitUntil {!isNull (findDisplay 4800)};
	ctrlSetText[4801,_msg];
	((findDisplay 4800)displayCtrl 4803) ctrlSetStructuredText parseText _info;
	[4802,Humans] call fnc_updatePlayersList;
};