_ai = _this select 0;
_aikiller = _this select 1;
_humanityBoost = -10000; //Set this to whatever you want the humanity to increase by

_humanity = _aikiller getVariable ["humanity",0];
_humanity = _humanity + _humanityBoost;
_aikiller setVariable["humanity", _humanity,true];

uiSleep 0.5;
deletevehicle _ai;