/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_cTarget","_isOk","_display","_inVehicle","_dis","_bn"];
disableSerialization;
_display = (_this select 0);
_inVehicle = (vehicle player) != player;
_cTarget = cursorTarget;
_dis=(vehicle player) distance _cTarget;
if(_inVehicle)then{_cTarget = (vehicle player);};

if((CurrAdminLevel<1)&&!(alive _cTarget)&&(_cTarget isKindOf "Man")&&!(_cTarget isKindOf "zZombie_base")&&!(_cTarget isKindOf "Animal"))then{
	_bn=GETVAR(_cTarget,bodyName,"");
	if(!((typeOf _cTarget)in AI_BanditTypes)&&(_bn!="")&&(dayz_playerName!=_bn)&&!((GETVAR(_cTarget,PlayerUID,0))in(profileNamespace getVariable["savedGroup",[]])))then{
		PVDZE_send=[player,"nopvpmsg",[dayz_playerName,_bn,"Игрок %1 лутает труп игрока %2. Если это попытка кражи, сделайте скриншот (нажмите F12). Обязательно сообщите администрации!"]];
		publicVariableServer "PVDZE_send";	
	};
};

_isOk = false;
{
	if(!_isOk) then {
		_isOk = _cTarget isKindOf _x;
	};
} forEach ["LandVehicle","Air", "Ship"];

if((locked _cTarget) and _isOk and !_inVehicle && (_dis < 20)) then {
	cutText [(localize "str_epoch_player_7") , "PLAIN DOWN"];
	_display closeDisplay 1;
};