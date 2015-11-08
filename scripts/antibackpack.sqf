/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
if ( isDedicated || isServer ) exitWith {diag_log ( "Error: Attempting to start AGN products on a server where it should not be!" );}; 


private ["_antiBackpackThread","_antiBackpackThread2","_player"];

waitUntil {!isNil "inSafeZone"};
		
//SCRIPT SETTINGS
AGN_safeZoneMessages = true;								//Should players get messages when entering and exiting the safe zone?
AGN_safeZone_Backpack_EnableAntiBackpack = true;			//Should players not be able to take from peoples bags?
AGN_safeZone_Backpack_AllowGearFromLootPiles = true;		//Should players be able to loot from loot piles?
AGN_safeZone_Backpack_AllowGearFromVehicles = true;		//Should players be able to loot from a vehicles gear?
AGN_safeZone_Backpack_AllowGearFromDeadPlayers = true;		//Should players be able to loot from a dead players corpse?
AGN_safeZone_Backpack_AllowFriendlyTaggedAccess = true;	//Should players who are tagged friendly be able to access eachothers bags?
AGN_safeZone_Vehicles_AllowGearFromWithinVehicles = true;	//Should players be able to open the gear screen while they are inside a vehicle?

//Probs not needed, but meh :)
disableSerialization;

waitUntil {!isNil "dayz_animalCheck"};

while {true} do {

	waitUntil { inSafeZone };

	//if ( AGN_safeZoneMessages ) then { systemChat ("Вы в трейдзоне, переодеватся запрещено, годмод включен!"); };
	
	if ( AGN_safeZone_Backpack_EnableAntiBackpack ) then
	{
		AGN_LastPlayerLookedAt = objNull;
		AGN_LastPlayerLookedAtCountDown = 5;
		_antiBackpackThread = [] spawn {
			private ["_ct","_player"];
			_player = player;
			while {inSafeZone} do
			{
				if ( isNull AGN_LastPlayerLookedAt )then{
					waitUntil {!isNull cursorTarget};
					_ct = cursorTarget;
					if (isPlayer _ct && alive _ct)then{
						if ((_ct distance _player)<6.5)then{
							AGN_LastPlayerLookedAt = _ct;
							AGN_LastPlayerLookedAtCountDown = 5;
						};
					};
				}else{
					AGN_LastPlayerLookedAtCountDown = AGN_LastPlayerLookedAtCountDown - 1;
					if (AGN_LastPlayerLookedAtCountDown < 0) then {AGN_LastPlayerLookedAt=objNull;};
					sleep 1;
				};
			};
		};
			
		_antiBackpackThread2 = [] spawn {
			private ["_player","_dis","_ip","_ia","_skip","_ct","_iv","_lp","_inv","_ctOwnerID","_friendlies","_if"];
			_player = player;
			_ctOwnerID = 0;
			while {inSafeZone} do
			{
				_ct = cursorTarget;
				_skip = false;
				
				if ( !isNull (_ct) )then{
					_dis = _ct distance _player;
					_lp = false;
					if (AGN_safeZone_Backpack_AllowGearFromLootPiles)then{
						{
							if ( (_ct isKindOf _x) && (_dis < 10) )exitWith{_lp = true;};
						} forEach ["WeaponHolder","ReammoBox"];
					};

					_ip = isPlayer _ct;
					_ia = alive _ct;
					_iv = _ct isKindOf "AllVehicles";
					_inv = (vehicle _player != _player);
					
					_if = false;
					if (AGN_safeZone_Backpack_AllowFriendlyTaggedAccess && _ip)then{
						_ctOwnerID = _ct getVariable["CharacterID","0"];
						_friendlies	= _player getVariable ["friendlyTo",[]];
						if(_ctOwnerID in _friendlies) then {
							_if = true;
						};
					};
					
					//Lootpile check
					call {
						if ( _lp )exitWith{_skip=true};
						//Dead body check
						if (!(_ia) && AGN_safeZone_Backpack_AllowGearFromDeadPlayers)exitWith{_skip=true};
						//Vehicle check
						if (_iv && (_dis<10) && !(_ip) && AGN_safeZone_Backpack_AllowGearFromVehicles)exitWith{_skip=true;};
						//In a vehicle check
						if (_inv && AGN_safeZone_Vehicles_AllowGearFromWithinVehicles)exitWith{_skip=true;};
						//Is player friendly?
						if (_if)exitWith{_skip=true;};
					};
				};
				
				if( !isNull (FindDisplay 106) && !_skip ) then{
					if ( isNull AGN_LastPlayerLookedAt ) then
					{
						(findDisplay 106) closeDisplay 1;
						waitUntil { isNull (FindDisplay 106) };
						createGearDialog [_player, 'RscDisplayGear'];
						//if ( AGN_safeZoneMessages ) then { systemChat ("Вы не можете открыть чужую сумку на рынке!"); };
						waitUntil { isNull (FindDisplay 106) };
					} else {
						if ( AGN_safeZoneMessages ) then { systemChat (format["Сейчас вы не можете открыть свое снаряжение, т.к. вы находились рядом с другим игроком в последние 5 секунд."]); };
						(findDisplay 106) closeDisplay 1;
						waitUntil { isNull (FindDisplay 106) };
					};
				};
				Sleep 0.2;
			};
		};
	};

	waitUntil { !inSafeZone };

	terminate _antiBackpackThread;
	terminate _antiBackpackThread2;
	AGN_LastPlayerLookedAt = objNull;
};