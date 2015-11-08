//===========================================
// DDOS Heli Guard by Donnovan from Brazil.
//===========================================
// Don't remove credits.
//===========================================

//CHECK PILOT STATE AND IGNITE PROTECTION
private ["_veh","_vehProtected"];
if (hasInterface) then {
	while {true} do {
		if (vehicle player != player) then {
			_veh = vehicle player;
			if (_veh isKindOf "Air" && !(_veh isKindOf "ParachuteBase")) then {
				if (driver _veh == player) then {
					_vehProtected = _veh getVariable ["donn_protect",false];
					if (!_vehProtected) then {
						_veh setVariable ["donn_protect",true,true];
						donn_heli_monitor = _veh;
						publicVariableServer "donn_heli_monitor";
					};
				};
			};
		};
		uiSleep 5;
	};
};
