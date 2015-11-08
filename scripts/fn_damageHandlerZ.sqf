/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
//[unit, selectionName, damage, source, projectile]
//will only run when local to the created object
//record any key hits to the required selection
private["_zed","_selection","_damage","_hitter","_projectile","_isBossZ","_headShots","_counzKill","_damageOrg","_unit","_humanity_s"];

_zed =			_this select 0;
_selection =	_this select 1;
_damage =		_this select 2;
_hitter =		_this select 3;
_projectile =	_this select 4;

if (local _zed) then {
	//systemchat format["%1 dam: %2 by %3 %4",_selection,_damage,_hitter,_projectile];
	if (_damage > 1 && _projectile != "") then {
		if (_zed isKindOf "z_Boss_zed") then {
			if (_selection=="head_hit") then {_damage = 0.2;}else{_damage = 0.1;};
		}else{
			//Record deliberate critical damages
			switch (_selection) do {
				case "head_hit": {
					if (!(_zed getVariable["hitRegistered",false])) then {
						//_headShots = _hitter getVariable["headShots",0];
						//_hitter setVariable["headShots",(_headShots + 1),true];
						_zed setVariable["hitRegistered",true];
						_counzKill = _hitter getVariable ["zCountKill",0];
						//diag_log format ["fn_dammZ _counzKill=%1,_hitter=%2",_counzKill,_hitter];
						if (_counzKill == 15) then {
							_humanity_s = _counzKill * 20;
							//diag_log format ["fn_dammZ _counzKill=%1,_humanity_s=%2",_counzKill,_humanity_s];
							[_hitter,_humanity_s] call player_humanltyChange;
							_hitter setVariable ["zCountKill",0,true];
						} else {
							//diag_log ("Zed killed+1");
							_hitter setVariable ["zCountKill",_counzKill+1,true];
						};
					};
				};
				case "leftupleg";
				case "rightupleg";
				case "leftleg";
				case "rightleg";
				case "legs": {
					if (isPlayer _hitter)then{
						if (_damage>1.8)then{
							_damage=0.1;
							if ((random 10)<3)then{
								_zed setHit["legs",1];
							};
						};
					}else{
						_damage=random _damage;
					};
				};

				default {if (isPlayer _hitter)then{_damage=0.1;}else{_damage=random _damage;};};
			};
			if (_projectile isKindOf "Bolt") then {
				_damageOrg = _hitter getVariable["firedDamage",0];
				if (_damageOrg < _damage) then {
					_hitter setVariable["firedHit",[_zed,_selection],true];
					_hitter setVariable["firedDamage",_damage,true];
				};
			};
		};
	};
};
_damage
