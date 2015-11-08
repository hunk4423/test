/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz

	FUNCTION COMPILES
*/
#include "scripts\defines.h"

// usage
// _removed = [player, 5000] call SC_fnc_removeCoins;
// if(_removed = true)then{  GREAT SUCCES  }else{ IT FAILED, not enoguh money};

SC_fnc_removeCoins={
	PVT4(_player,_amount,_wealth,_result);
	PARAMS2(_player,_amount);
	_result=true;
	if(_amount>0)then{
		_wealth=GetCash(_player);
		if (_wealth<_amount)then{
			_result=false;
		}else{
			SetCash(_player,_wealth-_amount);
			SETVARS(_player,moneychanged,1);
			PVDZE_plr_Save=[_player,(magazines _player),true,true];
			publicVariableServer "PVDZE_plr_Save";
			_result=(GetCash(_player)<_wealth);
		};
	};
	_result
};

// _removed = [player, 5000] call SC_fnc_removeBank;
SC_fnc_removeBank={
	PVT4(_player,_amount,_wealth,_result);
	PARAMS2(_player,_amount);
	_result=true;
	if(_amount > 0)then{
		_wealth=GetBank(_player);
		if (_wealth<_amount) then {
			_result = false;
		} else {
			SetBank(_player,_wealth-_amount);
			SETVARS(_player,bankchanged,1);
			PVDZE_plr_Save = [_player,(magazines _player),true,true];
			publicVariableServer "PVDZE_plr_Save";
			_result=(GetBank(_player)<_wealth);
		};
	};
	_result
};

// usage
// _added = [player, 5000] call SC_fnc_addCoins;
// if(_added = true)then{ GREAT SUCCES }else{ IT FAILED, Something went wrong};

SC_fnc_addCoins={
	PVT4(_player,_amount,_wealth,_result);
	PARAMS2(_player,_amount);
	_result = true;
	if (_amount>0)then{
		_wealth=GetCash(_player);
		SetCash(_player,_wealth + _amount);
		SETVARS(_player,moneychanged,1);
		PVDZE_plr_Save = [_player,(magazines _player),true,true];
		publicVariableServer "PVDZE_plr_Save";
		_result=(GetCash(_player)>_wealth);
	};
	_result
};

fnc_Payment = {
	private ["_player","_amount","_credit","_cash","_newcash","_bank","_newbank","_total","_result"];
	PARAMS2(_player,_amount);
	if(CNT(_this)>2)then{_credit=THIS2}else{_credit=false};
	_cash=GetCash(_player);
	_bank=GetBank(_player);
	_total=_cash+_bank;
	if((_total>=_amount)||_credit)then{
		if (_cash>=_amount)then{_newcash=_cash-_amount;_amount=0}else{_newcash=0;_amount=_amount-_cash};
		_newbank=_bank-_amount;
		if (_newcash!=_cash)then{
			SetCash(_player,_newcash);
			SETVARS(_player,moneychanged,1);
		};
		if (_newbank!=_bank)then{
			SetBank(_player,_newbank);
			SETVARS(_player,bankchanged,1);
		};
		PVDZE_plr_Save = [_player,(magazines _player),true,true];
		publicVariableServer "PVDZE_plr_Save";
		_result=[true,_cash-_newcash,_bank-_newbank];
	}else{
		_result=[false,_total,_amount];
	};
	_result
};

fnc_PaymentResultToStr={
	PVT6(_array,_rc,_v1,_v2,_msg,_zpt);
	PARAMS1(_array);
	EXPLODE3(_array,_rc,_v1,_v2);
	_zpt=false;
	if (_rc)then{
		if (_v1>0||_v2>0)then{
			_msg="Списано ";
			if (_v1>0)then{_msg=_msg+format["наличных %1 %2",[_v1] call BIS_fnc_numberText,CurrencyName];_zpt=true};
			if (_v2>0)then{
				if(_zpt)then{_msg=_msg+", "};
				_msg=_msg+format["с банковского счета %1 %2",[_v2] call BIS_fnc_numberText,CurrencyName];
			};
		}else{_msg=""};
	}else{
		_msg=format["Недостаточно средств, всего имеется %1 %3, требуется %2 %3",[_v1] call BIS_fnc_numberText,[_v2] call BIS_fnc_numberText,CurrencyName];
	};
	_msg
};

BIS_fnc_numberDigits = {
	private ["_number","_step","_stepLocal","_result","_numberLocal","_add"];

	_number=[_this,0,0,[0]] call bis_fnc_param;

	if (_number<10)then{
		[_number]
	}else{
		_step=10;
		_stepLocal=_step;
		_result=[0];
		_add=false;

		while {_stepLocal<(_number*_step)}do{
			_numberLocal=_number%_stepLocal;
			{_numberLocal=_numberLocal-_x}foreach _result;
			_numberLocal=floor (_numberLocal/_stepLocal*_step);

			if (_numberLocal<0)then{_numberLocal=9};
			_result=[_numberLocal]+_result;
			_stepLocal=_stepLocal*(_step);
		};
		if ((_result select 0)==0)then{_result=[1]+_result};
		_result resize (count _result-1);
		_result
	};
};

BIS_fnc_numberText = {
	private ["_number","_mod","_digits","_digitsCount","_modBase","_numberText"];

	_number=[_this,0,0,[0,""]] call bis_fnc_param;
	_mod=[_this,1,3,[0]] call bis_fnc_param;

	if(typeName _number == "STRING")then{_number=parseNumber _number};

	_digits=_number call BIS_fnc_numberDigits;
	_digitsCount=count _digits - 1;

	_modBase=_digitsCount % _mod;
	_numberText="";
	{
		_numberText=_numberText+str _x;
		//if ((_foreachindex - _modBase) % (_mod) == 0 && _foreachindex != _digitsCount) then {_numberText = _numberText + ",";};
	} foreach _digits;
	_numberText
};

// Список частей после разбора
// Если частей делать рандомно, то количество в виде массива [n1,n2]
// частей будет от n1 до n2
// [тип,имя,кол-во]
// тип 1-оружие, 2-магазин,3-сумка
fnc_GetItemRemoveParts = {
	PVT2(_object,_result);
	PARAMS1(_object);
	_result=[];

	if (_object isKindOf "Bicycle")then{_result = [[1,"ItemToolbox",1]/*,[2,"PartGeneric",[0,1]]*/]};
	_result
};

Finish_Old_Trade = {
	{player removeAction _x} forEach s_player_parts;s_player_parts = [];
	s_player_parts_crtl = -1;
	DZE_ActionInProgress = false;
	dayzTradeResult = nil;
	PVDZE_plr_Save = [player,[],true,true] ;
	publicVariableServer "PVDZE_plr_Save";
};

fnc_checkPlayerKey = {
	PVT4(_unit,_charID,_keyavailable,_result);
	PARAMS2(_unit,_charID);
	_result=[];
	_keyavailable=false;
	if(_charID!="0")then{
		{
			if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in itemKeyColor)then{
				if (str(getNumber(configFile >> "CfgWeapons" >> _x >> "keyid")) == _charID)then{
					_result=[_x];
					_keyavailable=true;
				};
			};
			if(_keyavailable)exitWith{};
		} count (items _unit);
	};
	_result
};

fnc_isPlayerHaveKey = {
	PARAMS2PVT(_unit,_charID);
	(count ([_unit,_charID] call fnc_checkPlayerKey)) > 0
};

fnc_getPlayerKeys = {
	PVT2(_unit,_result);
	PARAMS1(_unit);
	_result=[];
	{
		if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in itemKeyColor)then{
			_result set[CNT(_result),[getNumber(configFile >> "CfgWeapons" >> _x >> "keyid"),_x]];
		};
	}count (items _unit);
	_result
};

// Вход: 0-"имя",1-[позиция],2-"Текст",3-"тип",4-"Цвет",{5-направление,6-[размер]},{7-Shape,8-Brush}
// Выход: маркер
fnc_CreateMarkerLocal={
	PVT4(_name,_marker,_cnt,_type);
	_name=THIS0;
	deleteMarkerLocal _name;
	_marker=createMarkerLocal [_name,THIS1];
	_marker setMarkerTextLocal (THIS2);
	_type=(THIS3);
	_marker setMarkerTypeLocal _type;
	if(_type=="mil_triangle")then{_marker setMarkerSizeLocal [.6,.6]};
	_marker setMarkerColorLocal (THIS4);
	_cnt=count _this;
	if (_cnt>5)then{
		_marker setMarkerDirLocal (THIS5);
		_marker setMarkerSizeLocal (THIS6);
		if (_cnt>6)then{
			_marker setMarkerShapeLocal (THIS7);
			_marker setMarkerBrushLocal (THIS8);
		};
	};
	_marker
};

fnc_CreateMarker={
	PVT3(_name,_marker,_cnt);
	_name=THIS0;
	deleteMarker _name;
	_marker=createMarker [_name,THIS1];
	_marker setMarkerText (THIS2);
	_marker setMarkerType (THIS3);
	_marker setMarkerColor (THIS4);
	_cnt=count _this;
	if (_cnt>5)then{
		_marker setMarkerDir (THIS5);
		_marker setMarkerSize (THIS6);
		if (_cnt>6)then{
			_marker setMarkerShape (THIS7);
			_marker setMarkerBrush (THIS8);
		};
	};
	_marker
};

fnc_vectRotate2D = {
	PVT6(_x,_y,_dx,_dy,_sin,_cos);
	PARAMS3PVT(_center,_vector,_angle);
	EXPLODE2(_center,_x,_y);

	_dx=_x-(_vector select 0);
	_dy=_y-(_vector select 1);
	_sin=sin(_angle);_cos=cos(_angle);
	[
		_x-((_dx*_cos)-(_dy*_sin)),
		_y-((_dx*_sin)+(_dy*_cos))
	]
};

// На входе:
// [[позиция],зона:[x,y,z],Тип,угол,[ширина,длина]]]
fnc_posInArea={
	private ["_pos","_zPos","_zShape","_zDir","_zSize","_dx","_dy","_zx","_zy","_x1","_y1","_x2","_y2"];
	PARAMS5(_pos,_zPos,_zShape,_zDir,_zSize);

	_zShape=tolower _zShape;
	_pos=[_zPos,_pos,_zDir] call fnc_vectRotate2D;
	EXPLODE2(_zPos,_x1,_y1);
	EXPLODE2(_pos,_x2,_y2);
	EXPLODE2(_zSize,_zx,_zy);
	_dx=_x2-_x1;
	_dy=_y2-_y1;

	switch (_zShape) do {
		case "ellipse" : {((_dx^2)/(_zx^2)+(_dy^2)/(_zy^2))<1};
		case "rectangle" : {(abs _dx<_zx)and(abs _dy<_zy)};
	};
};

fnc_inAreaMarker={
	private ["_zSize","_zDir","_zShape","_zPos","_pos","_zRef","_dx","_dy","_zx","_zy","_x1","_y1","_x2","_y2"];
	PARAMS2(_pos,_zRef);

	_pos = ([_pos] call fnc_getpos);

	switch (typename _zRef) do {
		case "STRING" : {
			_zSize = markerSize _zRef;
			_zDir = markerDir _zRef;
			_zShape = tolower (markerShape _zRef);
			_zPos = getMarkerPos _zRef;
		};
		case "OBJECT" : {
			_zSize = triggerArea _zRef;
			_zDir = _zSize select 2;
			_zShape = if (_zSize select 3) then {"rectangle"} else {"ellipse"};
			_zPos = getpos _zRef;
		};
	};

	if (isnil "_zSize") exitwith {false};

	_pos = [_zPos,_pos,_zDir] call fnc_vectRotate2D;
	EXPLODE2(_zpos,_x1,_y1);
	EXPLODE2(_pos,_x2,_y2);
	EXPLODE2(_zsize,_zx,_zy);
	_dx=_x2-_x1;
	_dy=_y2-_y1;

	switch (_zShape) do {
		case "ellipse" : { ((_dx^2)/(_zx^2)+(_dy^2)/(_zy^2)) < 1 };
		case "rectangle" : { (abs _dx < _zx)and(abs _dy < _zy) };
	};
};

// Запрос информации по скину по имени базового скина или инвентарному имени.
// На выходе информация по скину (имя,имя конф, список моделей) или пустой массив если нет.
fnc_GetSkinInfoByName = {
	PVT2(_skinName,_result);
	_skinName=_this;
	_result=[];
	{
		if (_skinName==SEL0(_x) || _skinName==SEL1(_x))exitWith{_result=_x;};
	}forEach Clothings;
	_result
};

// Запрос информации по скину по имени модели.
// На выходе информация по скину (имя,имя конф, список моделей) или пустой массив если нет.
fnc_GetSkinInfoByModel = {
	PVT2(_skinName,_result);
	_skinName=_this;
	_result=[];
	{
		if (_skinName in SEL2(_x))exitWith{_result=_x;};
	}forEach Clothings;
	_result
};

fnc_GenerateVehicleKey={
	private ["_color","_key","_keyColor","_finalID","_keyNumber"];
	_color=_this select 0;
	_finalID=0;
	_key="";
	if (!(_color=="Random" || _color in keyColor))then{_color="Random";};
	while{true}do{
		if (_color=="Random")then{_keyColor=keyColor call BIS_fnc_selectRandom}else{_keyColor=_color};
		switch(_keyColor)do{
			case "Green":{_finalID=0;};
			case "Red":{_finalID=2500;};
			case "Blue":{_finalID=5000;};
			case "Yellow":{_finalID=7500;};
			case "Black":{_finalID=10000;};
		};
		if (_finalID==0)then{
			_keyNumber = (floor(random 1500)) + 1001;
		}else{
			_keyNumber = (floor(random 2500))+1;
		};
		_key = format[("ItemKey%1%2"),_keyColor,_keyNumber];
		_finalID=_finalID+_keyNumber;
		{
			if ((parseNumber (_x getVariable ["CharacterID","0"]))==_finalID)exitWith{_finalID=0};
		} forEach vehicles;
		if (_finalID!=0)then{
			if([[[player,_finalID,_key],"checkkey"],10] call fnc_GarageResultWait)then{if (PVDZE_GarageResult!="ok")then{_finalID=0}}else{_finalID=0};
		};
		if (_finalID!=0)exitWith{};
	};
	if (!isClass(configFile >> "CfgWeapons" >> _key))then{_key=""};
	_key
};

//Вычисление цены техники на продажу
Sell_Veh_Price = {
	private ["_skip","_obj","_price","_hitpoints","_array","_hit","_selection","_dam","_proc","_pribavka","_result"];
	_obj = _this select 0;
	_price = _this select 1;

	_hitpoints = _obj call vehicle_getHitpoints;
	_array = [];
	_skip = ["HitLMWheel","HitRMWheel","HitLF2Wheel","HitRF2Wheel"];
	{
		if !(_x in _skip) then {
			_hit = [_obj,_x] call object_getHit;
			_selection = getText (configFile >> "CfgVehicles" >> (typeOf _obj) >> "HitPoints" >> _x >> "name");
			if (_hit > 0) then {_array set [count _array,[_selection,_hit]]};
			_obj setHit ["_selection", _hit];
		};
	} count _hitpoints;
	_dam = 0;
	{
		_dam = _dam + (_x select 1);
	} count _array;

	_proc = 0.25 - (_dam * 0.05);
	if (_proc < -0.25) then {_proc = -0.25};

	_pribavka = _price * _proc;
	if (_pribavka > 2000) then {_pribavka = 2000;};
	_result = floor(_price + _pribavka);
	_result
};

// [pos,range]
fnc_getNearPosPlayers = {
	PVT2(_inRange,_players);
	_players=[];
	_inRange = THIS0 nearEntities ["CAManBase",THIS1];
	{
		if(isPlayer _x) then {_players set [count _players,_x];};
	} count _inRange;
	_players
};

fnc_checkPlayerInVehicle = {
	PVT(_result);
	_result=false;
	{
		if (isPlayer _x)exitWith{_result=true;};
	} forEach (crew THIS0);
	_result
};

ON_fnc_convertUID = {
	PVT5(_number_string,_string_array,_result,_number,_playertemp);
	_playertemp=THIS0;
	_number_string=getPlayerUIDOld _playertemp ;
	_string_array=toArray _number_string;
	_result = ""; 
	for "_i" from 0 to ((count _string_array) - 1) step 1 do {
		_number = ((_string_array select _i) - 48);
		if (_number > 9) then {
			_number = 9;
		};
		_result = _result + str(_number);
	};
	_result
};

fnc_inSafeZone = {
	PVT3(_object,_r,_result);
	PARAMS1(_object);
	_result=false;
	{
		if (CNT(_x)>7)then{
			_r = SEL0(SEL7(_x));
			if (_r>0)then{
				if (_object distance SEL1(_x)<_r)then{_result=true};
			};
		};
		if (_result)exitWith{};
	}count StaticMarkers;
	_result
};

if (!isDedicated) then {
	"filmic" setToneMappingParams [0.07, 0.31, 0.23, 0.37, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";
	
	FillSkinList		= COMPILE_SCRIPT_FILE(skins_getList.sqf);
	ApplySkinList		= COMPILE_SCRIPT_FILE(changeClothes.sqf);
	player_wearClothes	= COMPILE_SCRIPT_FILE(player_wearClothes.sqf);
	player_switchModel	= COMPILE_SCRIPT_FILE(player_switchModel.sqf);

	BIS_Effects_Burn = 				COMPILE_FILE(\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf);
	player_zombieCheck = 			COMPILE_CODE_FILE(player_zombieCheck.sqf);	//Run on a players computer, checks if the player is near a zombie
	//player_zombieAttack =			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\player_zombieAttack.sqf";	//Run on a players computer, causes a nearby zombie to attack them
	fnc_usec_damageActions =		COMPILE_SCRIPT_FILE(fn_damageActions.sqf);		//Checks which actions for nearby casualty
	fnc_inAngleSector =				COMPILE_CODE_FILE(fn_inAngleSector.sqf);		//Checks which actions for nearby casualty
	fnc_usec_selfActions =			COMPILE_SCRIPT_FILE(fn_selfActions.sqf);		//Checks which actions for self
	//fnc_usec_unconscious =			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\fn_unconscious.sqf";
	player_temp_calculation	=		COMPILE_SCRIPT_FILE(fn_temperatur.sqf);		//Temperatur System	//TeeChange
	player_weaponFiredNear =		COMPILE_CODE_FILE(player_weaponFiredNear.sqf);
	player_animalCheck =			COMPILE_CODE_FILE(player_animalCheck.sqf);
	player_spawnCheck = 			COMPILE_CODE_FILE(player_spawnCheck.sqf);
	player_dumpBackpack = 			COMPILE_CODE_FILE(player_dumpBackpack.sqf);
	building_spawnLoot =			COMPILE_CODE_FILE(building_spawnLoot.sqf);
	building_spawnZombies =			COMPILE_CODE_FILE(building_spawnZombies.sqf);
	dayz_spaceInterrupt =			COMPILE_SCRIPT_FILE(dayz_spaceInterrupt.sqf);
	player_fired =					COMPILE_SCRIPT_FILE(player_fired.sqf);	//Runs when player fires. Alerts nearby Zeds depending on calibre && audial rating
	player_harvest =				COMPILE_CODE_FILE(player_harvest.sqf);
	//player_packTent =				COMPILE_CODE_FILE(player_packTent.sqf);
	//player_packVault =				COMPILE_CODE_FILE(player_packVault.sqf);

	//player_removeObject =			COMPILE_ACTION_FILE(remove.sqf);
	player_removeNearby =			COMPILE_SCRIPT_FILE(object_removeNearby.sqf);

	player_removeTankTrap = {
		//Object Array, Range, Error Message (@Skaronator)
		[["Hedgehog_DZ"], 1,"STR_EPOCH_ACTIONS_14"] call player_removeNearby;
	};
	player_removeNet = {
		[["ForestCamoNet_DZ","DesertLargeCamoNet_DZ","ForestLargeCamoNet_DZ","Land_covering_hut_EP1","Land_covering_hut_big_EP1","Land_Market_shelter_EP1","Land_sunshade_EP1","MAP_Camo_Box","MAP_CamoNet_EAST","MAP_CamoNet_EAST_var1","MAP_CamoNetB_EAST","MAP_CamoNet_NATO","MAP_CamoNet_NATO_var1","MAP_CamoNetB_NATO","MAP_Pristresek","MAP_stanek_3","MAP_stanek_3B","MAP_stanek_3_d"], 5,"str_epoch_player_8"] call player_removeNearby;
	};
	player_removeTrees = {
		[["MAP_P_WindowHall","Land_Blankets_EP1","Land_Carpet_2_EP1","Land_Carpet_EP1","Land_Carpet_rack_EP1","Land_Pillow_EP1","MAP_b_betulaHumilis","MAP_b_canina2s","MAP_b_corylus","MAP_b_corylus2s","MAP_b_craet1","MAP_b_craet2","MAP_b_pmugo","MAP_b_prunus","MAP_b_salix2s","MAP_b_sambucus","MAP_c_autumn_flowers","MAP_c_blueBerry","MAP_c_caluna","MAP_c_fern","MAP_c_fernTall","MAP_c_GrassCrookedForest","MAP_c_GrassCrookedGreen","MAP_c_GrassDryLong","MAP_c_GrassTall","MAP_c_leaves","MAP_c_MushroomBabka","MAP_c_MushroomHorcak","MAP_c_MushroomMuchomurka","MAP_c_MushroomPrasivky","MAP_c_picea","MAP_c_PlantsAutumnForest","MAP_c_raspBerry","MAP_C_SmallLeafPlant","MAP_c_wideLeafPlant","MAP_flower_01","MAP_flower_02","MAP_p_articum","MAP_p_carduus","MAP_p_Helianthus","MAP_p_heracleum","MAP_p_Phragmites","MAP_p_urtica","MAP_pumpkin","MAP_pumpkin2","MAP_t_alnus2s","MAP_t_betula1f","MAP_t_betula2s","MAP_t_betula2w","MAP_t_fagus2s","MAP_t_fagus2W","MAP_t_fraxinus2W","MAP_t_malus1s","MAP_t_picea1s","MAP_t_pinusN1s","MAP_t_pyrus2s","MAP_t_salix2s","MAP_t_sorbus2s","MAP_t_acer2s","MAP_t_betula2f","MAP_t_carpinus2s","MAP_t_fagus2f","MAP_t_fraxinus2s","MAP_t_larix3f","MAP_t_larix3s","MAP_t_picea2s","MAP_t_picea3f","MAP_t_pinusN2s","MAP_t_pinusS2f","MAP_t_populus3s","MAP_t_quercus2f","MAP_t_quercus3s"], 20] call player_removeNearby;
	};
	
	fnc_getMissingMessage={
		PVT4(_removed,_msg,_n,_c);
		PARAMS1(_removed);
		_msg="Требуется иметь в инвентаре: ";
		{
			if (typeName _x == "ARRAY")then{EXPLODE2(_x,_n,_c)}else{_n=_x;_c=1};
			_n=getText (configFile >> "cfgMagazines" >> _n >> "displayName");
			if (_n=="")then{_n=_x};
			if (_forEachIndex>0)then{_msg=_msg+format[", %1 x %2",_c,_n]}else{_msg=_msg+format["%1 x %2",_c,_n]};
		}forEach _removed;
		_msg
	};

	player_login = {
		PARAMS2PVT(_unit,_detail);
		if(_unit == getPlayerUID player) then {
			player setVariable["publish",_detail];
		};
	};

	//Список игроков [UIND,Name] в радиусе
	// [range]
	fnc_getNearPlayersList={
		PVT2(_close,_players);
		_players=[];
		_close = player nearEntities ["CAManBase", THIS0];
		{
			if (isPlayer _x && player != _x) then {
				_players set [(count _players),[getPlayerUID _x,name _x,_x]];
			};
		} count _close;
		_players;
	};

	//Количество игроков в радиусе
	// [range]
	fnc_getNearPlayersCount={
		{isPlayer _x && _x != player} count (THIS0 nearEntities ['CAManBase', THIS1])
	};

	fnc_getNearPowers = {
		PVT5(_unit,_mode,_items,_result,_on);
		PARAMS2(_unit,_mode);
		_result=[];
		_items=nearestObjects [_unit,["Generator_DZ"],30] + nearestObjects [_unit,["MAP_PowerGenerator"],60];
		{
			if (alive _x)then{
				if (_mode==-1)exitWith{_result set [CNT(_result), _x];};
				_on=GETVAR(_x,GeneratorRunning,false);
				switch (_mode) do {
				case 0: {if (!_on)then{_result set [CNT(_result), _x];};};
				case 1: {if (_on)then{_result set [CNT(_result), _x];};};
				case 2: {if (_on && GETVAR(_x,PowerCable,false))then{_result set [CNT(_result), _x];};};
				case 3: {if (_on && GETVAR(_x,LightCable,false))then{_result set [CNT(_result), _x];};};
				};
			};
		} count _items;
		_result
	};

	//[listid,[[uid,name]]]
	fnc_updatePlayersList={
		PARAMS2PVT(_id,_list);
		lbClear _id;
		{lbAdd [_id,SEL1(_x)]}forEach _list;
	};
	
	// Получить список UID имещих какой либо доступ
	fnc_getAccessUIDs={
		PVT3(_object,_allowed,_friends);
		PARAMS1(_object);
		_allowed=[GETOVAR(ownerPUID,"0")];
		if(CurrAdminLevel>0)then{_allowed=_allowed set [CNT(_allowed),dayz_playerUID]};
		_friends=GETOVAR(friends,[]);
		{
			_allowed set [CNT(_allowed),SEL0(_x)];
		}count _friends;
		_allowed
	};

	// Система проверки доступа
	// uid,object,[default]
	// uid,objects,[default]
	// Формат строки friends [UID,Name,AccessLevel]
	// AccessLevel строка вида доступа "full","ro",...,"none"
	fnc_GetAccessLevel = {
		PVT5(_uid,_objects,_levels,_friends,_level);
		PARAMS2(_uid,_objects);
		if (CNT(_this)>2)then{_levels=THIS2}else{_levels=[]};
		if (CurrAdminLevel>0 && _uid==dayz_playerUID)then{_levels = ["full"]};
		if (typeName _objects == "OBJECT") then {
			if (!isNull _objects)then{_objects=[_objects]}else{_objects=[]};
		};
		{
			if(_uid == GetOwnerUID(_x))exitWith{_levels=["full"]};
			_friends=_x getVariable["friends",[]];
			{
				if (_uid==SEL0(_x))exitWith{
					_level=SEL2(_x);
					{if !(_x in _levels) then {_levels set [count _levels,_x]}}forEach _level;
				};
			}forEach _friends;
		}forEach _objects;
		_levels
	};

	// Проверить доступ в списке доступа
	//["remove",_accessLevels]
	//[["add","remove"],_accessLevels]
	fnc_checkAccess = {
		PARAMS2PVT(_access,_levels);
		if ("full" in _levels)exitWith{true};
		if (typeName _access == "STRING")then{_access=[_access]};
		({_x in _levels}count _access)>0
	};

	// Проверить доступ для объектов
	//playerUID,"remove",_object,[default]
	//playerUID,"remove",_objects,[default]
	fnc_checkObjectsAccess = {
		PVT4(_uid,_access,_objects,_levels);
		PARAMS3(_uid,_access,_objects);
		if (CNT(_this)>3)then{_levels=THIS3}else{_levels=[]};
		([_access,([_uid,_objects,_levels] call fnc_GetAccessLevel)] call fnc_checkAccess)
	};

	player_updateGui =			COMPILE_SCRIPT_FILE(player_updateGui.sqf);
	player_crossbowBolt =		COMPILE_CODE_FILE(player_crossbowBolt.sqf);
	player_music = 				COMPILE_CODE_FILE(player_music.sqf);			//Used to generate ambient music
	player_death =				COMPILE_SCRIPT_FILE(player_death.sqf);
	player_deathSafeMsg =		COMPILE_SCRIPT_FILE(player_deathSafe.sqf);

	//player_switchModel =		compile preprocessFileLineNumbers "scripts\player_switchModel.sqf";
	player_checkStealth =		COMPILE_CODE_FILE(player_checkStealth.sqf);
	world_sunRise =				COMPILE_CODE_FILE(fn_sunRise.sqf);
	world_surfaceNoise =		COMPILE_CODE_FILE(fn_surfaceNoise.sqf);
	player_humanityMorph =		COMPILE_CODE_FILE(player_humanityMorph.sqf);
	player_throwObject = 		COMPILE_CODE_FILE(player_throwObject.sqf);
	player_alertZombies = 		COMPILE_CODE_FILE(player_alertZombies.sqf);
	player_fireMonitor = 		compile preprocessFileLineNumbers "\z\addons\dayz_code\system\fire_monitor.sqf";
	fn_gearMenuChecks =			COMPILE_SCRIPT_FILE(fn_gearMenuChecks.sqf);

	//Objects
	object_roadFlare = 			COMPILE_CODE_FILE(object_roadFlare.sqf);
	object_setpitchbank	=		COMPILE_CODE_FILE(fn_setpitchbank.sqf);
	object_monitorGear =		COMPILE_SCRIPT_FILE(object_monitorGear.sqf);

	local_roadDebris =			COMPILE_CODE_FILE(local_roadDebris.sqf);

	//Zombies
	//zombie_findTargetAgent = 	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\zombie_findTargetAgent.sqf";
	zombie_loiter = 			COMPILE_CODE_FILE(zombie_loiter.sqf);			//Server compile, used for loiter behaviour
	//zombie_generate = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\zombie_generate.sqf";			//Server compile, used for loiter behaviour
	//wild_spawnZombies = 		compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\wild_spawnZombies.sqf";			//Server compile, used for loiter behaviour

	pz_attack = 				compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\pzombie\pz_attack.sqf";

	dog_findTargetAgent = 		COMPILE_CODE_FILE(dog_findTargetAgent.sqf);

	//actions
	player_countmagazines =		COMPILE_ACTION_FILE(player_countmagazines.sqf);
	player_addToolbelt =		COMPILE_ACTION_FILE(player_addToolbelt.sqf);
	player_copyKey =			COMPILE_ACTION_FILE(player_copyKey.sqf);
	player_reloadMag =			COMPILE_ACTION_FILE(player_reloadMags.sqf);
	player_loadCrate =			COMPILE_ACTION_FILE(player_loadCrate.sqf);
	player_craftItem =			COMPILE_ACTION_FILE(player_craftItem.sqf);
	//player_tentPitch =		compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\tent_pitch.sqf";
	//player_vaultPitch =		compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\vault_pitch.sqf";
	player_drink =				COMPILE_SCRIPT_FILE(player_drink.sqf);
	player_eat =				COMPILE_SCRIPT_FILE(player_eat.sqf);
	player_useMeds =			COMPILE_SCRIPT_FILE(player_useMeds.sqf);
	player_fillWater = 			COMPILE_SCRIPT_FILE(water_fill.sqf);
	player_makeFire =			COMPILE_ACTION_FILE(player_makefire.sqf);
	player_harvestPlant =		COMPILE_ACTION_FILE(player_harvestPlant.sqf);
	player_goFishing =			COMPILE_ACTION_FILE(player_goFishing.sqf);
	//player_wearClothes =		compile preprocessFileLineNumbers "scripts\player_wearClothes.sqf";
	object_pickup = 			COMPILE_ACTION_FILE(object_pickup.sqf);
	player_flipvehicle = 		COMPILE_ACTION_FILE(player_flipvehicle.sqf);
	player_sleep = 				COMPILE_ACTION_FILE(player_sleep.sqf);
	player_antiWall =			COMPILE_CODE_FILE(player_antiWall.sqf);
	player_deathBoard =			COMPILE_ACTION_FILE(list_playerDeathsAlt.sqf);

	player_plotPreview = 		COMPILE_CODE_FILE(object_showPlotRadius.sqf);
	plotPreview = 				COMPILE_SCRIPT_FILE(plotToggleMarkers.sqf);
	player_upgradeVehicle =		COMPILE_CODE_FILE(player_upgradeVehicle.sqf);

	//ui
	player_selectSlot =			COMPILE_SCRIPT_FILE(ui_selectSlot.sqf);
	player_gearSync	=			COMPILE_CODE_FILE(player_gearSync.sqf);
	player_gearSet	=			COMPILE_CODE_FILE(player_gearSet.sqf);
	ui_changeDisplay = 			COMPILE_CODE_FILE(ui_changeDisplay.sqf);
	ui_gear_sound =				COMPILE_CODE_FILE(ui_gear_sound.sqf);

	//System
	player_monitor =			COMPILE_SCRIPT_FILE(player_monitor.sqf);
	player_spawn_1 =			compile preprocessFileLineNumbers "\z\addons\dayz_code\system\player_spawn_1.sqf";
	player_spawn_2 =			COMPILE_SCRIPT_FILE(player_spawn_2.sqf);
	onPreloadStarted 			"dayz_preloadFinished = false;";
	onPreloadFinished 			"dayz_preloadFinished = true;";

	// helper functions
	player_hasTools =			COMPILE_CODE_FILE(fn_hasTools.sqf);
	player_checkItems =			COMPILE_CODE_FILE(fn_checkItems.sqf);
	player_removeItems =		COMPILE_CODE_FILE(fn_removeItems.sqf);
	//Trader ["Trader City Name",false,"enter"] - Trader City Name | Show Message | "enter" || "leave"
	player_traderCity = 		COMPILE_SCRIPT_FILE(player_traderCity.sqf);
	player_giftVehicle =		COMPILE_SCRIPT_FILE(giftVehicle.sqf);
	garage_dialog =				COMPILE_SCRIPT_FILE(garage_dialog.sqf);
	garage_management =			COMPILE_SCRIPT_FILE(garageManagement.sqf);
	garage_padSetup =			COMPILE_SCRIPT_FILE(garage_pad.sqf);
	
	// combination of check && remove items
	player_checkAndRemoveItems = {
		PVT2(_items,_b);
		_items=_this;
		_b=_items call player_checkItems;
		if (_b)then{_b=_items call player_removeItems};
		_b
	};

	dayz_HungerThirst = {
		dayz_hunger=dayz_hunger+THIS0;
		dayz_thirst=dayz_thirst+THIS1;
	};

	epoch_totalCurrency = {
		PVT3(_total_currency,_part,_worth);
		// total currency
		_total_currency=0;
		{
			_part=(configFile >> "CfgMagazines" >> _x);
			_worth=(_part >> "worth");
			if isNumber (_worth)then{
				_total_currency=_total_currency+getNumber(_worth);
			};
		} count (magazines player);
		_total_currency
	};

	epoch_itemCost = {
		PVT3(_trade_total,_part_in_configClass,_part_inWorth);
		_trade_total=0;
		{
			_part_in_configClass=configFile >> "CfgMagazines" >> (_x select 0);
			if (isClass (_part_in_configClass))then{
				_part_inWorth = (_part_in_configClass >> "worth");
				if isNumber (_part_inWorth)then{
					_trade_total=_trade_total+(getNumber(_part_inWorth)*(_x select 1));
				};
			};
		} count _this;
		//diag_log format["DEBUG TRADER ITEMCOST: %1", _this];
		_trade_total
	};

	epoch_returnChange = COMPILE_CODE_FILE(epoch_returnChange.sqf);
	// usage [["partinclassname",4]] call epoch_returnChange;

	dayz_losChance = {
		PVT6(_agent,_maxDis,_dis,_val,_maxExp,_myExp);
		PARAMS3(_agent,_dis,_maxDis);
		_val=(_maxDis-_dis) max 0;
		_maxExp=((exp 2)*_maxDis);
		_myExp=((exp 2)*(_val))/_maxExp;
		_myExp=_myExp*0.7;
		_myExp
	};

	ui_initDisplay = {
		private["_control","_ctrlBleed","_display","_ctrlFracture","_ctrlDogFood","_ctrlDogWater","_ctrlDogWaterBorder","_ctrlDogFoodBorder"];
		disableSerialization;
		_display=uiNamespace getVariable 'DAYZ_GUI_display';
		_control=_display CONTROL 1204;
		_control ctrlShow false;
		if (!r_player_injured)then{
			_ctrlBleed = _display CONTROL 1303;
			_ctrlBleed ctrlShow false;
		};
		if (!r_fracture_legs && !r_fracture_arms)then{
			_ctrlFracture=_display CONTROL 1203;
			_ctrlFracture ctrlShow false;
		};
		_ctrlDogFoodBorder=_display CONTROL 1501;
		_ctrlDogFoodBorder ctrlShow false;
		_ctrlDogFood=_display CONTROL 1701;
		_ctrlDogFood ctrlShow false;

		_ctrlDogWaterBorder=_display CONTROL 1502;
		_ctrlDogWaterBorder ctrlShow false;
		_ctrlDogWater=_display CONTROL 1702;
		_ctrlDogWater ctrlShow false
	};

	dayz_losCheck = {
		PVT5(_target,_agent,_cantSee,_tPos,_zPos);
		PARAMS2(_target,_agent);// PUT THE PLAYER IN FIRST ARGUMENT!!!!
		_cantSee=true;
		if (!isNull _target) then {
			_tPos = visiblePositionASL _target;
			_zPos = visiblePositionASL _agent;

			_tPos set [2,(_tPos select 2)+1];
			_zPos set [2,(_zPos select 2)+1];

			if ((count _tPos > 0) && (count _zPos > 0)) then {
				_cantSee = terrainIntersectASL [_tPos, _zPos];
				if (!_cantSee) then {
					_cantSee = lineIntersects [_tPos, _zPos, _agent, vehicle _target];
				};
			};
		};
		_cantSee
	};

	dayz_equipCheck = {
		PVT5(_config,_empty,_needed,_diff,_success);
		_config=_this;
		_empty=[player] call BIS_fnc_invSlotsEmpty;
		_needed=[_config] call BIS_fnc_invSlotType;
		_diff=[_empty,_needed] call BIS_fnc_vectorDiff;

		_success=true;
		{if(_x>0)exitWith{_success=false}} count _diff;
		hint format["Config: %5\nEmpty: %1\nNeeded: %2\nDiff: %3\nSuccess: %4",_empty,_needed,_diff,_success,_config];
		_success
	};

	vehicle_gear_count = {
		PVT(_counter);
		_counter=0;
		{_counter=_counter+_x} count _this;
		_counter
	};
	
	player_tagFriendlyMsg = {
		if(player==THIS0)then{cutText[(localize "str_epoch_player_2"),"PLAIN DOWN"]};
	};

	player_serverModelChange = {
		PARAMS2PVT(_object,_model);
		if (_object==player)then{
			_model call player_switchModel;
		};
	};

	player_guiControlFlash = {
		PVT(_control);
		_control=_this;
		if (ctrlShown _control)then{
			_control ctrlShow false;
		} else {
			_control ctrlShow true;
		};
	};

	gearDialog_create = {
		PVT2(_i,_dialog);
		if (!isNull (findDisplay 106)) then {
			(findDisplay 106) closeDisplay 0;
		};
		openMap false;
		closeDialog 0;
		if (gear_done) then {sleep 0.001;};
		player action ["Gear", player];
		if (gear_done) then {sleep 0.001;};
		_dialog = findDisplay 106;
		_i = 0;
		while {isNull _dialog} do {//DO NOT CHANGE TO A FOR LOOP!
			_i = _i + 1;
			_dialog = findDisplay 106;
			if (gear_done) then {sleep 0.001;};
			if (_i in [100,200,299]) then {
				closeDialog 0;
				player action ["Gear", player];
			};
			if (_i > 300) exitWith {};
		};
		if (gear_done) then {sleep 0.001;};
		_dialog = findDisplay 106;
		if ((parseNumber(THIS0)) != 0) then {
			ctrlActivate (_dialog CONTROL 157);
			if (gear_done) then {
				waitUntil {ctrlShown (_dialog CONTROL 159)};
				sleep 0.001;
			};
		};
		_dialog
	};

	gear_ui_offMenu = {
		PVT4(_control,_parent,_menu,_grpPos);
		disableSerialization;
		_control=THIS0;
		_parent=findDisplay 106;
		if (!(THIS3)) then {
			for "_i" from 0 to 9 do {
				_menu = _parent CONTROL (1600 + _i);
				_menu ctrlShow false;
			};
			_grpPos = ctrlPosition _control;
			_grpPos set [3,0];
			_control ctrlSetPosition _grpPos;
			_control ctrlShow false;
			_control ctrlCommit 0;
		};
	};

	dze_surrender_off = {
		SETPVARS(DZE_Surrendered,false);
		DZE_Surrender = false;
	};

	gear_ui_init = {
		PVT5(_control,_parent,_menu,_dspl,_grpPos);
		disableSerialization;
		_parent = findDisplay 106;
		_control = _parent CONTROL 6902;
		for "_i" from 0 to 9 do {
			_menu = _parent CONTROL (1600 + _i);
			_menu ctrlShow false;
		};
		_grpPos = ctrlPosition _control;
		_grpPos set [3,0];
		_control ctrlSetPosition _grpPos;
		_control ctrlShow false;
		_control ctrlCommit 0;
	};

	dayz_eyeDir = {
		PVT2(_vval,_vdir);
		_vval=(eyeDirection _this);
		_vdir=(_vval select 0) atan2 (_vval select 1);
		if (_vdir < 0)then{_vdir=360+_vdir};
		_vdir
	};

	DZE_getModelName = {
		PVT4(_objInfo,_lenInfo,_objName,_i);
		_objInfo=toArray(str(_this));
		_lenInfo=count _objInfo - 1;
		_objName=[];
		_i=0;
		// determine where the object name starts
		{
			if (58 == _objInfo select _i) exitWith {};
			_i = _i + 1;
		} count _objInfo;
		_i = _i + 2; // skip the ": " part
		for "_k" from _i to _lenInfo do {
			_objName set [(count _objName), (_objInfo select _k)];
		};
		_objName = toLower(toString(_objName));
		_objName
	};

	dze_isnearest_player = {
		PVT5(_notClosest,_playerDistance,_nearPlayers,_obj,_playerNear);
		if(!isNull _this)then{
			_nearPlayers=_this nearEntities ["CAManBase", 12];
			_playerNear=({isPlayer _x} count _nearPlayers) > 1;
			_notClosest=false;
			if (_playerNear)then{
				// check if another player is closer
				_playerDistance=player distance _this;
				{
					if (_playerDistance>(_x distance _this))exitWith{_notClosest=true};
				} count _nearPlayers;
			};
		} else {
			_notClosest=false;
		};
		_notClosest
	};
	/*
	// trader menu code
	if (DZE_ConfigTrader) then {
		call compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\player_traderMenuConfig.sqf";
	}else{
		call compile preprocessFileLineNumbers "scripts\player_traderMenuHive.sqf";
	};
	// recent murders menu code
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\player_murderMenu.sqf";
	*/
	
	//This is still needed but the fsm should terminate if any errors pop up.
	[] spawn {
		PVT4(_timeOut,_display,_control1,_control2);
		disableSerialization;
		_timeOut = 0;
		dayz_loadScreenMsg = "";
		diag_log "DEBUG: loadscreen guard started.";
		_display = uiNameSpace getVariable "BIS_loadingScreen";
		if (!isNil "_display") then {
			_control1 = _display CONTROL 8400;
			_control2 = _display CONTROL 102;
		};
		if (!isNil "dayz_DisplayGenderSelect") then {
			waitUntil {!dayz_DisplayGenderSelect};
		};

		// 120 sec timeout (12000 * 0.01)
		while { _timeOut < 12000 } do {
			if (dayz_clientPreload && dayz_authed) exitWith { diag_log "PLOGIN: Login loop completed!"; endLoadingScreen;};
			if (!isNil "_display") then {
				if ( isNull _display ) then {
					waitUntil { !dialog; };
					startLoadingScreen ["","RscDisplayLoadCustom"];
					_display = uiNameSpace getVariable "BIS_loadingScreen";
					_control1 = _display CONTROL 8400;
					_control2 = _display CONTROL 102;
				};

				if ( dayz_loadScreenMsg != "" ) then {
					_control1 ctrlSetText dayz_loadScreenMsg;
					dayz_loadScreenMsg = "";
				};

				_control2 ctrlSetText format["%1",round(_timeOut*0.01)];
			};

			_timeOut = _timeOut + 1;

			if (_timeOut >= 12000) then {
				1 cutText [localize "str_player_login_timeout", "PLAIN DOWN"];
				sleep 10;
				endLoadingScreen;
				endMission "END1";
			};
			sleep 0.01;
		};
	};

	dayz_meleeMagazineCheck = {
		PVT2(_meleeNum,_magType);
		_magType = ([] + getArray (configFile >> "CfgWeapons" >> _wpnType >> "magazines")) select 0;
		_meleeNum = ({_x == _magType} count magazines player);
		if (_meleeNum < 1) then {
			player addMagazine _magType;
		};
	};

	fnc_alertSound = {
		PARAMS4PVT(_object,_sound,_rangeS,_rangeZ);
		[_object,_sound,0,false,_rangeS] call dayz_zombieSpeak;
		[_object, _rangeZ, true, (getPosATL _object)] call player_alertZombies;
	};

	fnc_alertSoundRE = {
		PVT5(_object,_sound,_rangeS,_rangeZ,_local);
		PARAMS4(_object,_sound,_rangeS,_rangeZ);
		_local = ({isPlayer _x} count (_object nearEntities ["AllVehicles",_rangeS]) < 2);
		if ({isPlayer _x} count (_object nearEntities ["AllVehicles",_rangeS]) < 2)then{
			_object say [_sound, _rangeS];
		} else {
			[nil,_object,rSAY,[_sound, _rangeS]] call RE;
		};
		[_object, _rangeZ, true, (getPosATL _object)] call player_alertZombies;
	};

	dayz_originalPlayer=player;
};

fnc_get_rndRadiusPos = {
	private ["_center","_centerX","_centerY","_size","_dir","_posX","_posY","_rand"];
	PARAMS2(_center,_size);
	EXPLODE2(_center,_centerX,_centerY);

	_dir=random 360;
	_rand=sqrt random 1;
	_posX=(_size*(cos _dir))*_rand;
	_posY=(_size*(sin _dir))*_rand;

	_posX=_centerX+_posX;
	_posY=_centerY+_posY;

	[_posX,_posY,0]
};

fnc_get_rndRectPos = {
	private ["_center","_centerX","_centerY","_size","_sizeX","_sizeY","_posX","_posY"];
	PARAMS2(_center,_size);
	EXPLODE2(_center,_centerX,_centerY);
	EXPLODE2(_size,_sizeX,_sizeY);

	_posX=_centerX-_sizeX/2+(random _sizeX);
	_posY=_centerY-_sizeY/2+(random _sizeY);

	[_posX,_posY,0]
};


//Both
BIS_fnc_selectRandom =		compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\BIS_fnc\fn_selectRandom.sqf";
BIS_fnc_vectorAdd =			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\BIS_fnc\fn_vectorAdd.sqf";
BIS_fnc_halo =				COMPILE_SCRIPT_FILE(fn_halo.sqf);
BIS_fnc_findNestedElement =	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\BIS_fnc\fn_findNestedElement.sqf";
BIS_fnc_param = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\BIS_fnc\fn_param.sqf";

fnc_buildWeightedArray = 	COMPILE_CODE_FILE(fn_buildWeightedArray.sqf);		//Checks which actions for nearby casualty
fnc_usec_damageVehicle =	COMPILE_CODE_FILE(fn_damageHandlerVehicle.sqf);		//Event handler run on damage

// object_vehicleKilled =	COMPILE_CODE_FILE(object_vehicleKilled.sqf);		//Event handler run on damage
object_setHitServer =		COMPILE_CODE_FILE(object_setHitServer.sqf);	//process the hit as a NORMAL damage (useful for persistent vehicles)
object_setFixServer =		COMPILE_CODE_FILE(object_setFixServer.sqf);	//process the hit as a NORMAL damage (useful for persistent vehicles)
object_getHit =				COMPILE_CODE_FILE(object_getHit.sqf);			//gets the hit value for a HitPoint (i.e. HitLegs) against the selection (i.e. "legs"), returns the value
object_setHit =				COMPILE_CODE_FILE(object_setHit.sqf);			//process the hit as a NORMAL damage (useful for persistent vehicles)
object_processHit =			COMPILE_CODE_FILE(object_processHit.sqf);		//process the hit in the REVO damage system (records && sets hit)
object_delLocal =			COMPILE_CODE_FILE(object_delLocal.sqf);
// object_cargoCheck =		COMPILE_CODE_FILE(object_cargoCheck.sqf);		//Run by the player || server to monitor changes in cargo contents
//fnc_usec_damageHandler =	COMPILE_CODE_FILE(fn_damageHandler.sqf);		//Event handler run on damage
fnc_veh_ResetEH = 			COMPILE_SCRIPT_FILE(veh_ResetEH.sqf);			//Initialize vehicle
// Vehicle damage fix
vehicle_handleDamage =		COMPILE_SCRIPT_FILE(vehicle_handleDamage.sqf);
vehicle_handleKilled =		COMPILE_CODE_FILE(vehicle_handleKilled.sqf);
//fnc_vehicleEventHandler =		compile preprocessFileLineNumbers "\z\addons\dayz_code\init\vehicle_init.sqf";			//Initialize vehicle
fnc_inString =				COMPILE_CODE_FILE(fn_inString.sqf);
fnc_isInsideBuilding =		COMPILE_SCRIPT_FILE(fn_isInsideBuilding.sqf);//_isInside = [_unit] call fnc_isInsideBuilding;
fnc_isInsideBuilding2 =		COMPILE_CODE_FILE(fn_isInsideBuilding2.sqf);	//_isInside = [_unit,_building] call fnc_isInsideBuilding2;
fnc_isInsideBuilding3 =		COMPILE_CODE_FILE(fn_isInsideBuilding3.sqf);	//_isInside = [_unit,_building] call fnc_isInsideBuilding3;
dayz_zombieSpeak =			COMPILE_CODE_FILE(object_speak.sqf);			//Used to generate random speech for a unit
vehicle_getHitpoints =		COMPILE_CODE_FILE(vehicle_getHitpoints.sqf);
local_gutObject =			COMPILE_CODE_FILE(local_gutObject.sqf);		//Generated on the server (|| local to unit) when gutting an object
local_lockUnlock = 			COMPILE_SCRIPT_FILE(local_lockUnlock.sqf);
local_gutObjectZ =			COMPILE_CODE_FILE(local_gutObjectZ.sqf);		//Generated on the server (|| local to unit) when gutting an object
local_zombieDamage =		COMPILE_SCRIPT_FILE(fn_damageHandlerZ.sqf);
local_eventKill =			COMPILE_SCRIPT_FILE(local_eventKill.sqf);		//Generated when something is killed
//player_weaponCheck =			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\player_weaponCheck.sqf";	//Run by the player || server to monitor whether they have picked up a new weapon
curTimeStr =				COMPILE_CODE_FILE(fn_curTimeStr.sqf);
player_medBandage =			compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\publicEH\medBandaged.sqf";
player_medInject =			compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\publicEH\medInject.sqf";
player_medEpi =				COMPILE_SCRIPT_FILE(medEpi.sqf);
player_medTransfuse =		compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\publicEH\medTransfuse.sqf";
//player_medMorphine =		COMPILE_SCRIPT_FILE(medMorphine.sqf);
player_breaklegs =			compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\publicEH\medBreakLegs.sqf";
player_medPainkiller =		COMPILE_SCRIPT_FILE(medPainkiller.sqf);
world_isDay = 				{if ((daytime < (24 - dayz_sunRise)) && (daytime > dayz_sunRise)) then {true} else {false}};
player_humanityChange =		COMPILE_CODE_FILE(player_humanityChange.sqf);
spawn_loot =				COMPILE_CODE_FILE(spawn_loot.sqf);
spawn_loot_small =			COMPILE_CODE_FILE(spawn_loot_small.sqf);
// player_projectileNear =		compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\player_projectileNear.sqf";
evac_handleDamage = 		COMPILE_SCRIPT_FILE(evac_handleDamage.sqf);

#include "scripts\objectFunction.sqf"

FNC_GetSetPos = { //DO NOT USE IF YOU NEED ANGLE COMPENSATION!!!!
	PVT2(_pos,_thingy);
	PARAMS1(_thingy);
	_pos=getPosASL _thingy;
	if (surfaceIsWater _pos) then{
		_thingy setPosASL _pos;
	} else {
		_thingy setPosATL (ASLToATL _pos);
	};
};
FNC_GetPos = {
	PVT2(_pos,_thingy);
	PARAMS1(_thingy);
	if (isNil {THIS0})exitWith{[0,0,0]};
	_pos=getPosASL _thingy;
	if !(surfaceIsWater _pos)then{
		_pos=ASLToATL _pos;
	};
	_pos
};
local_setFuel = {
	PARAMS2PVT(_vehicle,_qty);
	_vehicle setFuel _qty;
};
zombie_initialize = {
	PVT2(_unit,_position);
	PARAMS1(_unit);
	if (isServer) then {
		_unit addEventHandler ["local",{_this call zombie_findOwner}];
	};
	_unit addeventhandler["HandleDamage",{_this call local_zombieDamage}];
	_unit addeventhandler["Killed",{[_this,"zombieKills"] call local_eventKill}];
};

dayz_EjectPlayer = {
	// check if player in vehicle
	PVT(_vehicle);
	_vehicle = vehicle player;
	if(_vehicle!=player)then{
		if (((_vehicle emptyPositions "driver") > 0) && (speed _vehicle)!=0)then{
			player action ["eject",_vehicle];
		};
	};
};

player_sumMedical = {
	PVT5(_character,_wounds,_legs,_arms,_medical);
	_character=_this;
	_wounds=[];
	if (GETCVAR(USEC_injured,false))then{
		{if(_character getVariable[_x,false])then{_wounds set [count _wounds,_x]}} count USEC_typeOfWounds;
	};
	_legs=GETCVAR(hit_legs,0);
	_arms=GETCVAR(hit_arms,0);
	_medical=[
		GETCVAR(USEC_isDead,false),
		GETCVAR(NORRN_unconscious,false),
		GETCVAR(USEC_infected,false),
		GETCVAR(USEC_injured,false),
		GETCVAR(USEC_inPain,false),
		GETCVAR(USEC_isCardiac,false),
		GETCVAR(USEC_lowBlood,false),
		GETCVAR(USEC_BloodQty,12000),
		_wounds,
		[_legs,_arms],
		GETCVAR(unconsciousTime,0),
		GETCVAR(messing,([0,0]))
	];
	_medical
};

//Server Only
if (isServer)then{
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\init\server_functions.sqf";
	DZE_GarageHiding=createVehicle ["Sign_sphere10cm_EP1",[849,1236,2000],[],0,"CAN_COLLIDE"];
} else {
	eh_localCleanup={};
};
call COMPILE_SCRIPT_FILE(player_traderMenu.sqf);

if (!isDedicated)then{

	player_build = COMPILE_SCRIPT_FILE(player_build.sqf);
	snap_build = COMPILE_SCRIPT_FILE(snap_build.sqf);
	player_lockVault = COMPILE_SCRIPT_FILE(player_lockVault.sqf);
	player_unlockVault = COMPILE_SCRIPT_FILE(player_unlockVault.sqf);
	player_packTent = COMPILE_SCRIPT_FILE(player_packTent.sqf);
	player_packVault = COMPILE_SCRIPT_FILE(player_packVault.sqf);
	player_removeObject = COMPILE_SCRIPT_FILE(remove.sqf);
	player_tentPitch = COMPILE_SCRIPT_FILE(tent_pitch.sqf);
	player_vaultPitch = COMPILE_SCRIPT_FILE(vault_pitch.sqf);
	
	mv22_pack = compile preprocessFileLineNumbers "\ca\air2\mv22\scripts\pack.sqf";
	uh1y_pack = compile preprocessFileLineNumbers "\ca\air2\UH1Y\Scripts\fold.sqf";
	ah1z_pack = compile preprocessFileLineNumbers "\ca\air\Scripts\AH1Z_fold.sqf";
	mv22_anim = COMPILE_SCRIPT_FILE(mv22_anim.sqf);
	c130_anim = COMPILE_SCRIPT_FILE(c130_anim.sqf);
	
	wild_spawnZombies = COMPILE_SCRIPT_FILE(wild_spawnZombies.sqf);
	zombie_generate = COMPILE_SCRIPT_FILE(zombie_generate.sqf);
	player_zombieAttack = COMPILE_SCRIPT_FILE(player_zombieAttack.sqf);	//in AH
	zombie_findTargetAgent = COMPILE_SCRIPT_FILE(zombie_findTargetAgent.sqf);
	fnc_usec_unconscious = COMPILE_SCRIPT_FILE(fn_unconscious.sqf);
	
	VehicleColourPaint = COMPILE_SCRIPT_FILE(vehicleColourPaint.sqf);
	VehicleColourDefalt = COMPILE_SCRIPT_FILE(vehicleColourPaintDefalt.sqf);
	VehicleColourPreview = COMPILE_SCRIPT_FILE(VehicleColourPreview.sqf);
	VehicleColourUpdate = COMPILE_SCRIPT_FILE(VehicleColourUpdate.sqf);
	VehicleColourUpdate2 = COMPILE_SCRIPT_FILE(VehicleColourUpdate2.sqf);

	DoorAddFriend		= COMPILE_SCRIPT_FILE(doorAddFriend.sqf);
	DoorRemoveFriend	= COMPILE_SCRIPT_FILE(doorRemoveFriend.sqf);
	
	player_unlockDoor		= COMPILE_SCRIPT_FILE(player_unlockDoor.sqf);
	player_unlockDoorCode	= COMPILE_SCRIPT_FILE(player_unlockDoorCode.sqf);
	player_manageDoor		= COMPILE_SCRIPT_FILE(initDoorManagement.sqf);
	player_enterCode		= COMPILE_SCRIPT_FILE(player_enterCode.sqf);
	player_changeCombo =	COMPILE_SCRIPT_FILE(player_changeCombo.sqf); 
	
	nopvp_send = COMPILE_SCRIPT_FILE(nopvp_send.sqf);

	player_getVehicle = COMPILE_SCRIPT_FILE(getvehicle.sqf);
	player_storeVehicle = COMPILE_SCRIPT_FILE(player_storeVehicle.sqf);
	vehicle_info = COMPILE_SCRIPT_FILE(vehicle_info.sqf);

	player_msgEMS = COMPILE_SCRIPT_FILE(msgEMS.sqf);
	LowGearOn = COMPILE_SCRIPT_FILE(LowGearOn.sqf);
	player_takeClothes = COMPILE_SCRIPT_FILE(player_takeClothes.sqf);
	fnc_Preview = COMPILE_SCRIPT_FILE(player_fnc_Preview.sqf);
	
	#ifdef _ORIGINS
	fnc_veh_FillSkinList =		COMPILE_SCRIPT_FILE(vehicle_FillSkinList.sqf);
	fnc_veh_ApplySkin =			COMPILE_SCRIPT_FILE(vehicle_ApplySkin.sqf);	
	#endif
};

fnc_usec_damageHandler =	COMPILE_SCRIPT_FILE(fn_damageHandler.sqf);	//in AH //in safezone
player_nopvp =				COMPILE_SCRIPT_FILE(player_nopvp.sqf);
player_nopvpmsg =			COMPILE_SCRIPT_FILE(player_nopvpmsg.sqf);
player_nopvpforgive =		COMPILE_SCRIPT_FILE(player_nopvpforgive.sqf);

#ifdef _ORIGINS
fnc_veh_getSkinFiles =		COMPILE_SCRIPT_FILE(vehicle_getSkinFiles.sqf);
#endif

#include "localcomp.sqf"

initialized = true;