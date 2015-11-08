/***********************************************************
ASSIGN DAMAGE HANDLER TO A UNIT
- Function fnc_veh_ResetEH
- unit call fnc_veh_ResetEH
************************************************************/

_this removeAllEventHandlers "HandleDamage";
_this removeAllEventHandlers "Killed";
_this removeAllEventHandlers "GetIn";
_this removeAllEventHandlers "Fired";
_this removeAllEventHandlers "GetOut";
_this addEventHandler ["Fired", {_this call vehicle_fired}];
_this addeventhandler ["HandleDamage",{_this call vehicle_handleDamage}];
_this addeventhandler ["Killed",{_this call vehicle_handleKilled}];
_this addEventHandler ["GetIn", {_this call vehicle_getIn}];
_this addEventHandler ["GetOut", {_this call vehicle_GetOut}];
if(_this getVariable["taxi",false])then{
	_this allowDamage false;
	_this allowCrewInImmobile true;
};
//diag_log(format["%1: all EH reset for %2", __FILE__, _this]);
true