 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //

private ["_onScreenTime", "_role1", "_role1names", "_role2", "_role2names","_role3","_role3names","_role4","_role4names","_memberFunction","_memberNames","_x","_finalText"];

_onScreenTime = 6;

//	SCRIPT START

waitUntil {!isNil "dayz_animalCheck"};
sleep 5; //Wait in seconds before the credits start after player IS ingame

_role1 = "Добро пожаловать на";
_role1names = ["GoldKey DayZ Epoch noPVP(PVE) server"];
_role2 = "Помните!";
_role2names = ["Убийство игроков, воровство и угон техники карается БАНОМ!"];
_role3 = "Наша группа вконтакте:";
_role3names = ["vk.com/goldkey_dz"];
_role4 = "Наш TeamSpeak 3:";
_role4names = ["ts3.goldkey-games.ru"];
/* 
_role5 = "Server Mods";
_role5names = ["Dynamic Spawns", "Self-bb", "Custom traders", "More mods"];
_role6 = "Website";
_role6names = ["yourwebsite.com"];
_role7 = "Twitter";
_role7names = ["@yourtwittername"];
_role8 = "Email Support";
_role8names = ["youremailaddress@gmail.com"];
_role9 = "Special Thanks";
_role9names = ["DayZ.ST", "Blurgaming.com", "infiSTAR.de", "HFBservers.com", "ArmAholic.com", "OpendayZ.net", "DayZmod.com"];
*/


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
	//The list below should have exactly the same amount of roles as the list above
	[_role1, _role1names],
	[_role2, _role2names],
	[_role3, _role3names],
	[_role4, _role4names]
	/* 
	[_role5, _role5names],
	[_role6, _role6names],
	[_role7, _role7names],
	[_role8, _role8names],
	[_role9, _role9names]			//make SURE the last one here does NOT have a , at the end
	*/
];

 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //