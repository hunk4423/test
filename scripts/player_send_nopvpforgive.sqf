 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //

	private ["_source","_pvpstatus","_ok"];
	disableserialization;
	_source = (_this select 3) select 0;
	_ok = true;
	if(DZE_ActionInProgress) exitWith { cutText ["я занят...", "PLAIN DOWN"]; };
	DZE_ActionInProgress = true;
	
	player playActionNow "Medic";
	[player,"repair",0,false,10] call dayz_zombieSpeak;
	uiSleep 7;
	
	//Вторая проверка
	_pvpstatus = _source getVariable ["PvPStatus",nil];
	if !(_pvpstatus == name player) then {
		systemChat format "Игрок не нуждается в прощении"; 
		DZE_ActionInProgress = false;
		_ok = false;
	};	
	
	if (_ok) then {
	//сообщаем
		PVDZE_send = [_source,"nopvpforgive",[player,_source]];
		publicVariableServer "PVDZE_send";	

		DZE_ActionInProgress = false;
	};

 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //