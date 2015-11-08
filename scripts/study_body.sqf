private["_body","_name","_method"];
_body = 	_this select 3;
_name = 	_body getVariable["bodyName","unknown"];
_method = 	_body getVariable["deathType","unknown"];

cutText [format["Его звали %1 похоже что он умер %2",_name,_method], "PLAIN DOWN"];