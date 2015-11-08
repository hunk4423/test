 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //

private ["_onScreenTime", "_role1", "_role1names", "_role2","_memberFunction","_memberNames","_x","_finalText"];

_onScreenTime = 6; 

sleep 1.5;

_role1 = "Добро пожаловать,";
_role1names = [name player];

{
	sleep 2;
	_memberFunction = _x select 0;
	_memberNames = _x select 1;
	_finalText = format ["<t size='0.60' color='#5882FA' align='right'>%1<br /></t>", _memberFunction];
	_finalText = _finalText + "<t size='0.70' color='#7EC0EE' align='right'>";
	{_finalText = _finalText + format ["%1<br />", _x]} forEach _memberNames;
	_finalText = _finalText + "</t>";
	_onScreenTime + (((count _memberNames) - 1) * 0.5);
	
	[
		_finalText,
		[safezoneX + safezoneW - 0.8,0.50],	//DEFAULT: 0.5,0.35
		[safezoneY + safezoneH - 0.8,0.7], 	//DEFAULT: 0.8,0.7
		_onScreenTime,
		0.5
	] spawn BIS_fnc_dynamicText;
	sleep (_onScreenTime);
} forEach [
	[_role1, _role1names]
];

 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //