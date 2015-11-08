/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
	
	[unit, selectionName, damage, source, projectile] call Vehicle_HandleDamage;
*/
private["_unit","_unit","_selection","_strH","_total","_damage","_needUpdate","_type","_now","_typeOf","_dmg","_advDmg","_wh","_state"];
_unit=_this select 0;
_selection=_this select 1;
_total=_this select 2;
_type=_this select 4;
if((_unit getVariable["inSafeZone",false])||(_unit getVariable["taxi",false])||((locked _unit)&&(count (crew _unit)==0)))then{_total=0};
if(_total>0)then{
	_typeOf=typeOf _unit;
	_now=0;
	if(_unit isKindOf "Air")then{
		_now=_unit getVariable[("hit_"+_selection),0];		
		if(_typeOf in ArmorAir)then{_dmg=.26}else{_dmg=.3};
		switch(_type)do{
			case "B_127x107_Ball":	{_total=.01;};
			case "M_Strela_AA":		{_total=(random.05)+_dmg;};
			case "M_Stinger_AA":	{_total=(random.05)+_dmg;};
			default {_total=(_total-_now)/2};
		};
	};		
	if((_typeOf in ArmorLand)&&(_type in["M_Strela_AA","M_Stinger_AA"]))then{
		_now=_unit getVariable[("hit_"+_selection),0];
		_advDmg=[0,0,0];
		_wh=false;
		switch(_typeOf)do{
			case "BTR90":			{_dmg=.11;_wh=true;_advDmg=[0.15,0.30,0.98];};
			case "BTR90_HQ_DZ":		{_dmg=.11;_wh=true;_advDmg=[0.15,0.30,0.53];};
			case "LAV25_HQ_DZ":		{_dmg=.11;_wh=true;_advDmg=[0.15,0.30,0.53];};
			case "BTR60_TK_EP1":	{_dmg=.11;_wh=true;_advDmg=[0.15,0.30,0.56];};
			case "LAV25":			{_dmg=.11;_wh=true;_advDmg=[0.15,0.30,0.56];};
			case "GAZ_Vodnik_HMG":	{_dmg=.28;};				
			case "T34":				{_dmg=.155;_advDmg=[0.01,0.21];};
			case "T34_TK_EP1":		{_dmg=.155;_advDmg=[0.01,0.21];};
			case "M2A2_EP1":		{_dmg=.16;_advDmg=[0.01,0.21];};
			case "M2A3_EP1":		{_dmg=.16;_advDmg=[0.01,0.21];};
			case "M6_EP1":			{_dmg=.16;_advDmg=[0.01,0.21];};
			case "AAV":				{_dmg=.16;_advDmg=[0.01,0.22];};
			default 				{_dmg=.11;_advDmg=[0.15,0.30];};
		};
		_total=(random.05)+_dmg;
		if(_wh)then{_state=_unit getVariable["LandFalseDamage",0];};			
		switch(_selection)do{
			case "pas_l":			{if(_now>=(_advDmg select 0))then{_total=1.0};};
			case "pas_p":			{if(_now>=(_advDmg select 0))then{_total=1.0};};				
			case "zbran":			{if(_now>=(_advDmg select 1))then{_total=1.0};};
			case "vez":				{if(_now>=(_advDmg select 1))then{_total=1.0};};				
			case "wheel_2_4_steering":{
				if(_wh)then{
					if(_state>=(_advDmg select 2))exitWith{_unit setDamage 1;};
					_unit setVariable["LandFalseDamage",(_state+0.18)];						
				};
			};
		};
		if(_wh&&(_selection in BTR_Wheels)&&(_state>=0.2))then{_total=1;};
	};				
	_total=_total+_now;	
	if(_selection!="")then{_strH="hit_"+_selection}else{_strH="totalDmg"};
	if(_total>=0.98)then{_total=1.0};
	if(local _unit)then{
		_unit setVariable [_strH,_total,true];
		_unit setHit [_selection,_total];
		[_unit,"damage"] call fnc_serverUpdateObject;
	}else{PVDZE_send=[_unit,"VehHandleDam",_this];publicVariableServer "PVDZE_send"};
};
_total