/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
disableSerialization;

Z_vehicle = objNull;
Z_VehicleDistance = 150;
Z_MoneyVariable = "headShots";

Z_filleTradeTitle = {
	_text = _this select 0;
	ctrlSetText [7408, _text];
};

Z_clearLists = {
	lbClear 7401;
	lbClear 7402;
};

Z_clearBuyList = {
  lbClear 7421;
};

Z_clearBuyingList = {
  lbClear 7422;
};

Z_getContainer = {
	private ["_dialog","_pUID","_lbIndex","_humanity","_vehicleName","_ctrltext","_canBuyInVehicle"];
	_dialog = findDisplay 711197;
	(_dialog displayCtrl 7404) ctrlSetText format["Свободные слоты: 0/0/0"];
	call Z_clearBuyingList;
	call Z_clearLists;
	Z_SellableArray = [];
	Z_SellArray = [];
	Z_BuyingArray = [];
	buyRifle = nil;
	buyPistol = nil;
	buyBackpack = nil;
	bpBuyArray = nil;
	_pUID = getPlayerUID player;
	
	_lbIndex= _this select 0;
	
	if(Z_Selling)then{
		switch (_lbIndex) do {
			case 0: {
				//Проверка на хуманити
				_humanity = player getVariable["humanity",0];
				if (_humanity <= 5000) exitWith {systemChat "Торговля из рюкзака доступна только после 5000 хуманити.";};
				
				["Продажа из рюкзака."] call Z_filleTradeTitle;
				Z_SellingFrom = 0;
				call Z_getBackpackItems; 
			};
			case 1: {
				//Проверка на премиум
				if !(_pUID in PremiumList_trade) exitWith {systemChat "Торговля из техники доступна только за донат.";};

				if (!isNil "Z_vehicle") then {						
					["Продажа из техники."] call Z_filleTradeTitle;
				} else {
					_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf Z_vehicle >> "displayName");
					[format["Продажа из %1.", _vehicleName]] call Z_filleTradeTitle;
				};
				Z_SellingFrom = 1;
				call Z_getVehicleItems;
			};
			case 2: { 
				["Продажа из инвентаря."] call Z_filleTradeTitle;
				Z_SellingFrom = 2;
				call Z_getGearItems; 
			};
		};
	}else{
		_ctrltext = format[" "];
		ctrlSetText [7413, _ctrltext];
		
		_ctrltext = "";
		ctrlSetText [7412, _ctrltext];
		switch (_lbIndex) do {
		
			case 0: { 
				//Проверка на хуманити
				_humanity = player getVariable["humanity",0];
				if (_humanity <= 5000) exitWith {systemChat "Торговля из рюкзака доступна только после 5000 хуманити.";};
				
				Z_SellingFrom = 0;
				["Покупка в рюкзак."] call Z_filleTradeTitle;
				call Z_calculateFreeSpace;
			};
			case 1: {
				//Проверка на премиум
				if !(_pUID in PremiumList_trade) exitWith {systemChat "Торговля из техники доступна только за донат.";};
				
				Z_SellingFrom = 1;
				["Покупка в технику."] call Z_filleTradeTitle;
				_canBuyInVehicle = call Z_CheckCloseVehicle;
				if(_canBuyInVehicle)then{
					call Z_calculateFreeSpace; 
				}else{
					systemChat format["Сначала выберите технику для торговли."];						
					(_dialog displayCtrl 7404) ctrlSetText format["Свободные слоты: %1/%2/%3",0,0,0];
				};
			};
			case 2: {
				Z_SellingFrom = 2;				
				["Покупка в инвентарь."] call Z_filleTradeTitle;
				call Z_calculateFreeSpace;
			};
		};
	};
};

Z_getBackpackItems = {
	private ["_backpack","_mags","_weaps","_normalMags","_normalWeaps","_kinds","_ammmounts","_counter","_kinds2","_ammmounts2","_ctrltext"];
	call Z_clearLists;
	Z_SellableArray = [];
	Z_SellArray = [];
	_backpack = unitBackpack player;
	if!(isNull _backpack)then{   				
		_mags = getMagazineCargo _backpack;
		_weaps = getWeaponCargo _backpack;		
		_normalMags = [];
		_normalWeaps = [];			
		_kinds = _mags select 0;
		_ammmounts = _mags select 1;
		{
			_counter = 0 ;
			while{	_counter < ( 	_ammmounts select _forEachIndex)}do{
			_normalMags set [count(_normalMags),_x];
			_counter = _counter + 1;
			};
		}forEach _kinds;
		
		_kinds2 = _weaps select 0;
		_ammmounts2 = _weaps select 1;
		{
			_counter = 0 ;
			while{	_counter < ( 	_ammmounts2 select _forEachIndex)}do{
			_normalWeaps set [count(_normalWeaps),_x];
			_counter = _counter + 1;
			};
		}forEach _kinds2;
	
		[_normalMags,_normalWeaps,[], typeOf _backpack] call Z_checkArrayInConfig;	
	}else{
		_ctrltext = format["I'm not stupid."];
		ctrlSetText [7413, _ctrltext];
		
		_ctrltext = format["You are not wearing a backpack."];
		ctrlSetText [7412, _ctrltext];
	};
};

Z_getVehicleItems = {
	private ["_check","_vehicle","_vehicleName","_mags","_weaps","_bp","_normalMags","_normalWeaps","_normalBP","_kinds","_ammmounts","_counter","_kinds2","_ammmounts2","_kinds3","_ammmounts3","_ctrltext","_owner"];
	call Z_clearLists;
	Z_SellableArray = [];
	Z_SellArray = [];
	_vehicle = objNull;
	
	_check = call Z_CheckVehicle;
	if !(_check) then {
		_vehicle = Z_vehicle;
		_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf Z_vehicle >> "displayName");
		systemChat format["%1 выбран(а) для торговли.", _vehicleName];
	};
	
	if(!isNull _vehicle)then{
		_mags = getMagazineCargo _vehicle;
		_weaps = getWeaponCargo _vehicle;
		_bp = getBackpackCargo _vehicle;
		
		
		_normalMags = [];
		_normalWeaps = [];
		_normalBP = [];
		
		_kinds = _mags select 0;
		_ammmounts = _mags select 1;
		{
			_counter = 0 ;
			while{	_counter < ( 	_ammmounts select _forEachIndex)}do{
			_normalMags set [count(_normalMags),_x];
					_counter = _counter + 1;
			};
		}forEach _kinds;
		
		_kinds2 = _weaps select 0;
		_ammmounts2 = _weaps select 1;
		{
			_counter = 0 ;
			while{	_counter < ( 	_ammmounts2 select _forEachIndex)}do{
				_normalWeaps set [count(_normalWeaps),_x];
				_counter = _counter + 1;
			};
		}forEach _kinds2;
		
		_kinds3 = _bp select 0;
		_ammmounts3 = _bp select 1;
		{
			_counter = 0 ;
			while{	_counter < ( 	_ammmounts3 select _forEachIndex)}do{
				_normalBP set [count(_normalBP),_x];
				_counter = _counter + 1;
			};
		}forEach _kinds3;
		[_normalWeaps,_normalMags,_normalBP, typeOf _vehicle] call Z_checkArrayInConfig;
	}else{
		_ctrltext = format["Сначала выберите технику для торговли."];
		ctrlSetText [7413, _ctrltext];
		
		_ctrltext = format["Техника не обнаружена."];
		ctrlSetText [7412, _ctrltext];
	};	
};


Z_getGearItems = {
	private ["_mags","_weaps","_bag"];
	call Z_clearLists;
	Z_SellArray = [];
	Z_SellableArray = [];
	 _mags = magazines player;
	 _weaps = weapons player;
	 _bag = typeof (unitBackpack player);
	[_weaps,_mags,[_bag],"your gear"] call Z_checkArrayInConfig;			
};

Z_checkArrayInConfig = {
	private ["_abort","_weaps","_mags","_bag","_extraText","_all","_total","_arrayOfTraderCat","_totalPrice","_cat","_sell","_type","_pic ","_text","_backUpText","_ctrltext"];
	_weaps = _this select 0;
	_mags = _this select 1;
	_bag = _this select 2;
	_extraText = _this select 3;
	_all = _weaps + _mags + _bag;
	_total = count(_all);
	_arrayOfTraderCat = Z_traderData;
	_totalPrice = 0;
	_abort=false;

	if(_total > 0)then{
		{
			_y = _x;
			_abort=false;			
			{
				if(_abort)exitWith{};
				_cat = call compile format["category_%1",(_arrayOfTraderCat select _forEachIndex select 1)];
				{
					if (_y == (_x select 0)) exitWith {
						_sell = _x select 2;
						_type = _x select 3;
													
						_pic = "";
						_text = "";						
						switch (true) do {
							case (_type == "trade_items") :
							{
								_pic = getText (configFile >> 'CfgMagazines' >> _y >> 'picture');
								_text = getText (configFile >> 'CfgMagazines' >> _y >> 'displayName');
							};
							case (_type == "trade_weapons") :
							{
								_pic = getText (configFile >> 'CfgWeapons' >> _y >> 'picture');
								_text = getText (configFile >> 'CfgWeapons' >> _y >> 'displayName');
							};
							case (_type == "trade_backpacks") :
							{
								_pic = getText (configFile >> 'CfgVehicles' >> _y >> 'picture');
								_text = getText (configFile >> 'CfgVehicles' >> _y >> 'displayName'); 
							};
						};
						
						if( isNil '_text')then{_text = _y;};
						Z_SellableArray set [count(Z_SellableArray) , [_y,_type,_sell,_text,_pic]];
						_totalPrice = _totalPrice + _sell;
						_abort=true;
					};
				}forEach _cat;					
			}forEach _arrayOfTraderCat;				
		}count _all;	
				
		_backUpText = _extraText;
		if(Z_SellingFrom != 2)then{
			_extraText = getText (configFile >> 'CfgVehicles' >> _extraText >> 'displayName');
		};
		if (isNil '_extraText')then{_extraText = _backUpText;};
		
		_ctrltext = format["Общая стоимость: %1 %2", _totalPrice,CurrencyName];
		ctrlSetText [7412, _ctrltext];		
		_ctrltext = "";
		ctrlSetText [7413, _ctrltext];	
		call Z_fillSellList;
	};		
};

Z_calcPrice = {
private ["_sellPrice","_count_all","_ctrltext"];
	_sellPrice = 0;
	_count_all = 0;
	if(Z_Selling) then {	
		_count_all = count Z_SellArray;
		{  		
			_sellPrice = _sellPrice +  (_x select 2);
		} count Z_SellArray;
	}else{
		{
			_sellPrice = _sellPrice +  ((_x select 2) * (_x select 5));
			_count_all = _count_all + (_x select 5);
		} count Z_BuyingArray;	
	};
	_ctrltext = format["%1 %2 %3 шт.", [_sellPrice] call BIS_fnc_numberText , CurrencyName, _count_all];
	ctrlSetText [7410, _ctrltext];  
};

Z_fillSellList = {
private ["_index"];
	{
		_index = lbAdd [7401,  _x select 3];
		lbSetPicture [7401, _index, _x select 4 ];
	}count Z_SellableArray;
};

Z_fillSellingList = {
private ["_index"];
	{  		
		_index = lbAdd [7402, _x select 3];
		lbSetPicture [7402, _index,  _x select 4];
	}count Z_SellArray;
};

Z_pushItemToList = {
private ["_index","_temp","_index2"];
	_index = _this select 0;
	if(!isNil"_index" && _index > -1)then {
		lbDelete [7401, _index];
		_temp = Z_SellableArray select _index;
		Z_SellArray set [count(Z_SellArray),_temp];
		Z_SellableArray set [_index,"deleted"];
		Z_SellableArray = Z_SellableArray - ["deleted"];
		_index2 = lbAdd [7402, _temp select 3];
		lbSetPicture [7402, _index2, _temp select 4];
		call Z_calcPrice;
	};
};

Z_removeItemFromList = {
private ["_index","_temp","_item"];
	_index = _this select 0;
	if(!isNil"_index" && _index > -1)then {
		lbDelete [7402, _index];
		_temp = Z_SellArray select _index;
		_item = [_temp select 0,_temp select 1 ,_temp select 2,_temp select 3, _temp select 4  ];
		Z_SellableArray set [count(Z_SellableArray),_item];
		Z_SellArray set [_index,"deleted"];
		Z_SellArray = Z_SellArray - ["deleted"];
		_index2 = lbAdd [7401,  _item select 3];
		lbSetPicture [7401, _index2, _item select 4];
		call Z_calcPrice;	
	};
};

Z_pushAllToList = {
	Z_SellArray = Z_SellArray + Z_SellableArray;
	Z_SellableArray = [];
	call Z_clearLists;
	call Z_fillSellList;
	call Z_fillSellingList;
	call Z_calcPrice;
};

Z_removeAllToList = {
	Z_SellableArray = Z_SellableArray + Z_SellArray;
	Z_SellArray = [];
	call Z_clearLists;
	call Z_fillSellList;
	call Z_fillSellingList;
	call Z_calcPrice;
};

Z_SellItems = {
private ["_check","_index","_tempArray","_outcome","_weaponsArray","_itemsArray","_bpArray","_bpCheckArray","_weaponsCheckArray","_itemsCheckArray","_bk_price","_type","_name","_wA","_mA","_localResult","_money","_owner"];
	_index = count (Z_SellArray) - 1;	
	_tempArray = Z_SellArray;
	if(_index > -1)then{
		closeDialog 2;
		_outcome = [];
		_weaponsArray = [];
		_itemsArray = [];	
		_bpArray = [];	
		_bpCheckArray = [];
		_weaponsCheckArray = [];
		_itemsCheckArray = [];
		_bk_price = 0;
		_check = false;
		
		{		
			_type = _x select 1;
			_name = _x select 0;						

			switch (true) do {
				case (_type == "trade_items") :
				{
					_itemsArray set [count(_itemsArray),_name];
					_itemsCheckArray set [count(_itemsCheckArray),_x select 2];									
				};
				case (_type == "trade_weapons") :
				{
					_weaponsArray set [count(_weaponsArray),_name];
					_weaponsCheckArray set [count(_weaponsCheckArray),_x select 2];
				};
				case (_type == "trade_backpacks") :
				{
					_bpArray set [count(_bpArray),_name];
					_bpCheckArray set [count(_bpCheckArray),_x select 2];
				};
			};
		}count Z_SellArray;
		
		closeDialog 2;
				
		if(Z_SellingFrom == 0)then{//backpack
			_outcome = [unitBackpack player,_itemsArray,_weaponsArray,[]] call ZUPA_fnc_removeWeaponsAndMagazinesCargo;
		};
		if(Z_SellingFrom == 1)then{//vehicle
			_check = call Z_CheckVehicle;
			if (_check) exitWith {systemChat format["Сначала выберите технику для торговли."];};				
			_outcome = [Z_vehicle,_itemsArray,_weaponsArray,_bpArray] call ZUPA_fnc_removeWeaponsAndMagazinesCargo;	
		};
							
		if(Z_SellingFrom == 2)then{//gear
			_wA = [];
			_mA = [];
			{
				_type = _x select 1;
				
				if (_type == "trade_backpacks") then {
					if((typeOf (unitBackpack player)) == _x select 0) then {
						removeBackpack player;
						_bk_price = _x select 2;
					};
				} else {				
					_localResult = [player,(_x select 0),1] call BIS_fnc_invRemove; 
					if( _localResult != 1)then{
						if(_type == "trade_items")then{
							_mA set [count(_mA),0];
						}else{
							_wA set [count(_wA),0];
						};
					}else{
						if(_type == "trade_items")then{
							_mA set [count(_mA),1];
						}else{
							_wA set [count(_wA),1];
						};
					};
				};
			}count Z_SellArray;
				
			_outcome set [0,_mA];	
			_outcome set [1,_wA];
			_outcome set [2,[]];					
		};
		
		if (_check) exitWith {};
		
		_money = 0;
		{
			_money = _money + ( ((_itemsCheckArray select _forEachIndex)) * _x) ;			
		}forEach (_outcome select 0);
		{
			_money = _money + ( ((_weaponsCheckArray select _forEachIndex)) * _x) ;				
		}forEach (_outcome select 1);		
		{
			_money = _money + ( ( (_bpCheckArray select _forEachIndex) ) * _x) ;	
		}forEach (_outcome select 2);
		
		//Продажа сумки с рук, считаю отдельно
		_money = _money + _bk_price;

		if(typeName _money  == "SCALAR")then{
			[player,_money] call SC_fnc_addCoins;	
			systemChat format["Продано за %1 %2", [_money] call BIS_fnc_numberText , CurrencyName];
			
			//сохраняем лут
			PVDZE_plr_Save = [player,[],true,true];
			publicVariableServer "PVDZE_plr_Save";
			
			//временный перезапуск диалогового окна
			_nil = [0,0,0,Z_traderData] execVM "scripts\advancedTrading.sqf";				
		}else{
			systemChat format["Что-то пошло не так."];			
		};									
	}else{
		systemChat format["Не выбран предмет для продажи."];
	};						
};

Z_BuyItems = {
private ["_magazinesToBuy","_weaponsToBuy","_backpacksToBuy","_priceToBuy","_canBuy","_myMoney","_bk","_count","_vehicleName","_check"];
	_magazinesToBuy = 0;
	_weaponsToBuy = 0;
	_backpacksToBuy = 0;
	_priceToBuy = 0;
	
	{
		if( _x select 1 == "trade_weapons")then{
			_weaponsToBuy = _weaponsToBuy + (_x select 5) ;
			_priceToBuy	= _priceToBuy + ((_x select 5)*(_x select 2));			
		};
		if( _x select 1 == "trade_items")then{
			_magazinesToBuy = _magazinesToBuy + (_x select 5) ;
			_priceToBuy	= _priceToBuy + ((_x select 2)*(_x select 5));
		};
		if( _x select 1 == "trade_backpacks")then{
			_backpacksToBuy = _backpacksToBuy + (_x select 5) ;
			_priceToBuy	= _priceToBuy + ((_x select 2)*(_x select 5));
		};	
	} count Z_BuyingArray;

	//recheck if there is enough space -> not that some douche put extra stuff in.	
	_check = call Z_CheckVehicle;
	if (_check && (Z_SellingFrom == 1)) exitWith {systemChat format["Ошибка. Выберите технику для торговли."];};		
	_canBuy = [_weaponsToBuy,_magazinesToBuy,_backpacksToBuy] call Z_allowBuying;		
	_myMoney = player getVariable[Z_MoneyVariable,0];
	
	if(_myMoney >= _priceToBuy)then{
		if(_canBuy)then{
			closeDialog 2;
			if(Z_SellingFrom == 0)then{//backpack
				if (count (Z_BuyingArray) > 0) then {
					systemChat format["Предметы добавлены в ваш рюкзак.",count (Z_BuyingArray)];
				};
				_bk = unitBackpack player;
				{
					if( _x select 1 == "trade_weapons")then{
						_bk addWeaponCargoGlobal [_x select 0, _x select 5];							
					};
					if( _x select 1 == "trade_items")then{
						_bk addMagazineCargoGlobal  [_x select 0, _x select 5];	
					};					
				} count Z_BuyingArray;			
			};
			
			if(Z_SellingFrom == 1)then{//vehicle
				{
					if (count (Z_BuyingArray) > 0) then {
						_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf Z_vehicle >> "displayName");
						systemChat format["Предметы добавлены в вашу технику: %1",_vehicleName];
					};
					if( _x select 1 == "trade_weapons")then{
						Z_vehicle addWeaponCargoGlobal [_x select 0, _x select 5];								
					};
					if( _x select 1 == "trade_items")then{
						Z_vehicle addMagazineCargoGlobal [_x select 0, _x select 5];			
					};	
					if( _x select 1 == "trade_backpacks")then{
						Z_vehicle addBackpackCargoGlobal [_x select 0, _x select 5];	
					};	
				} count Z_BuyingArray;
				
				//сохраняем лут
				PVDZE_veh_Update = [Z_vehicle, "all"];
				publicVariableServer "PVDZE_veh_Update";
			};
			
			if(Z_SellingFrom == 2)then{//gear	
				if (count (Z_BuyingArray) > 0) then {
					systemChat "Предметы добавлены в ваш инвентарь.";
				};
				
				{
					if( _x select 1 == "trade_weapons")then{
						_count = 0;
					while{_count < _x select 5}do{
							player addWeapon (_x select 0);	
							_count = _count + 1;
						};							 
					};
					if( _x select 1 == "trade_items")then{
						_count = 0;						
						 while{_count < _x select 5}do{
							player addMagazine (_x select 0);
							_count = _count + 1;
						};	
					};	
					if( _x select 1 == "trade_backpacks")then{
						removeBackpack player;
						player addBackpack (_x select 0);	
					};							
				} count Z_BuyingArray;	
				
				//сохраняем лут
				PVDZE_plr_Save = [player,[],true,true] ;
				publicVariableServer "PVDZE_plr_Save";					
			};
			
			//Забираем деньги
			[player,_priceToBuy] call SC_fnc_removeCoins;
			if (_priceToBuy > 0) then {
				systemChat format["Куплено за %1 %2",[_priceToBuy] call BIS_fnc_numberText,CurrencyName];
			
				buyRifle = nil;
				buyPistol = nil;
				buyBackpack = nil;
				bpBuyArray = nil;
			} else {
				systemChat format["Не выбран предмет для покупки."];
			};
		};			
	}else{
		systemChat format["Вам нужно еще %1 %2 для покупки всех предметов.",(_priceToBuy - _myMoney),CurrencyName];
	};
};

/* ----------------------------------------------------------------------------
Examples:
   _result = [_backpack, ["SmokeShell","M16_AMMO"],["M16","M16","M240"]] call ZUPA_fnc_removeWeaponsAndMagazinesCargo; 
   _result == [[1,0,0,1,1,1,0],[1,0,0,1],[1,0]]; // 1 = success, 0 = fail ->( item was not in cargo)
   
Author:
   Zupa 2014-09-30
---------------------------------------------------------------------------- */
ZUPA_fnc_removeWeaponsAndMagazinesCargo = {
private ["_unit","_items","_weaps","_bags","_normalItems","_normalWeaps","_normalBags","_unit_allItems","_unit_allItems_types","_unit_allItems_count","_unit_allWeaps","_unit_allWeaps_types","_unit_allWeaps_count","_unit_allBags","_unit_allBags_types","_unit_allBags_count","_counter","_returnVar","_returnMag","_returnWeap","_returnBag","_inCargo"];
	_unit = _this select 0;
	_items = _this select 1; 
	_weaps = _this select 2; 
	_bags = _this select 3; 
			
	_normalItems = [];
	_normalWeaps = [];
	_normalBags = [];
	
	_unit_allItems = getMagazineCargo _unit; //  [[type1, typeN, ...],[count1, countN, ...]]
	_unit_allItems_types = _unit_allItems select 0;
	_unit_allItems_count = _unit_allItems select 1;	
	
	_unit_allWeaps = getWeaponCargo _unit; 
	_unit_allWeaps_types = _unit_allWeaps select 0;
	_unit_allWeaps_count = _unit_allWeaps select 1;	
	
	_unit_allBags = getBackpackCargo _unit; 
	_unit_allBags_types = _unit_allBags select 0;
	_unit_allBags_count = _unit_allBags select 1;	
	
	clearMagazineCargoGlobal _unit;	
	clearWeaponCargoGlobal _unit;
	clearBackpackCargoGlobal  _unit;
	
	{
		_counter = 0 ;
		while{	_counter < ( _unit_allItems_count select _forEachIndex)}do{
		_normalItems set [count(_normalItems),_x];
				_counter = _counter + 1;
		};
	}forEach _unit_allItems_types;				
	{
		_counter = 0 ;
		while{	_counter < ( _unit_allWeaps_count select _forEachIndex)}do{
		_normalWeaps set [count(_normalWeaps),_x];
				_counter = _counter + 1;
		};
	}forEach _unit_allWeaps_types;	
	{
		_counter = 0 ;
		while{	_counter < ( _unit_allBags_count select _forEachIndex)}do{
		_normalBags set [count(_normalBags),_x];
				_counter = _counter + 1;
		};
	}forEach _unit_allBags_types;	
	
	_returnVar = [];	
	_returnMag = [];	
	_returnWeap = [];
	_returnBag = [];
	{		
		_inCargo = _normalItems find _x;
		if(_inCargo > -1)then{
			_normalItems set [_inCargo, "soldItem"];
			_returnMag set [count(_returnMag),1];
		}else{
			_returnMag set [count(_returnMag),0];	
		};
	}count _items;	
	_normalItems = _normalItems - ["soldItem"];
	{				
		_unit addMagazineCargoGlobal [_x, 1];				
	}count _normalItems;	
	
	{		
		_inCargo = _normalWeaps find _x;
		if(_inCargo > -1)then{
			_normalWeaps set [_inCargo, "soldItem"];
			_returnWeap set [count(_returnWeap),1];
		}else{
			_returnWeap set [count(_returnWeap),0];	
		};
	}count _weaps;	
	_normalWeaps = _normalWeaps - ["soldItem"];
	{				
		_unit addWeaponCargoGlobal [_x, 1];				
	}count _normalWeaps;
	
	{		
		_inCargo = _normalBags find _x;
		if(_inCargo > -1)then{
			_normalBags set [_inCargo, "soldItem"];
			_returnBag set [count(_returnBag),1];
		}else{
			_returnBag set [count(_returnBag),0];	
		};
	}count _bags;	
	_normalBags = _normalBags - ["soldItem"];
	{				
		_unit addBackpackCargoGlobal [_x, 1];				
	}count _normalBags;
	
	//Сохраняем если техника
	if (_unit == Z_vehicle) then {
		PVDZE_veh_Update = [_unit, "all"];
		publicVariableServer "PVDZE_veh_Update";
	};
	
	_returnVar set [0,_returnMag];
	_returnVar set [1,_returnWeap];
	_returnVar set [2,_returnBag];
	_returnVar;
};

Z_ChangeBuySell = {	
private ["_dialog"];
	_dialog = findDisplay 711197;		
	Z_Selling = !Z_Selling;	
	if(Z_Selling)then{	
		ctrlSetText [7410, ""];
		(_dialog displayCtrl 7416) ctrlSetText "Покупка";
		(_dialog displayCtrl 7409) ctrlSetText "Продажа";
		{ctrlShow [_x,true];} forEach [7401,7402,7435,7430,7431,7432,7433]; // show
		{ctrlShow [_x,false];} forEach [7421,7422,7436,7440,7441,7442,7443,7404]; // hide											
	}else{
		buyRifle = nil;
		buyPistol = nil;
		buyBackpack = nil;
		bpBuyArray = nil;
		ctrlSetText [7410, ""];
		(_dialog displayCtrl 7416) ctrlSetText "Продажа";
		(_dialog displayCtrl 7409) ctrlSetText "Покупка";
		{ctrlShow [_x,true];} forEach [7421,7422,7436,7440,7441,7442,7443,7404]; // show
		{ctrlShow [_x,false];} forEach [7401,7402,7435,7430,7431,7432,7433]; // hide	
		call Z_fillBuyList;
	};	
	[2] call Z_getContainer; // default gear
};

Z_removeAllFromBuyingList = {
	call Z_clearBuyingList;
	Z_BuyingArray = [];
	buyRifle = nil;
	buyPistol = nil;
	buyBackpack = nil;
	bpBuyArray = nil;
};

Z_removeItemFromBuyingList = {
private ["_index","_nameitem","_config","_wepType","_type","_count","_buyingweap","_buyingwemag"];
	_index = _this select 0;
	if(!isNil"_index" && _index > -1)then {
		
		if (Z_SellingFrom == 2) then {
			_nameitem = (Z_BuyingArray select _index) select 0;						
			_config = (configFile >> "CfgWeapons" >> _nameitem);
			_wepType = getNumber(_config >> "Type");
			switch (_wepType) do {
				case 1 : {buyRifle = nil;};
				case 2 : {buyPistol = nil;};
			};
			if (((Z_BuyingArray select _index) select 1) == "trade_backpacks") then {buyBackpack = nil;};
		};	
		
		if (Z_SellingFrom == 0) then {
			_type = (Z_BuyingArray select _index) select 1;
			_count = (Z_BuyingArray select _index) select 5;
			_buyingweap = bpBuyArray select 0;
			_buyingwemag = bpBuyArray select 1;
			switch (_type) do {
				case "trade_weapons" : {
					bpBuyArray set [0,_buyingweap - _count];
					bpBuyArray set [1,_buyingwemag - (_count * 10)];					
				};
				case "trade_items" : {
					bpBuyArray set [1,_buyingwemag - _count];
					bpBuyArray set [0,floor((bpBuyArray select 1) /10)];						
				};
			};
		};
		
		lbDelete [7422, _index];
		Z_BuyingArray set [_index,"deleted"];
		Z_BuyingArray = Z_BuyingArray - ["deleted"];		
		call Z_calcPrice;	
		
	};
};

Z_toBuyingList = {
	private ["_index","_amount","_wp","_abort","_type","_nameitem","_config","_wepType","_isToolBelt","_isBinocs","_secondaryWeapon","_text","_toBuyWeaps","_toBuyMags","_buyingweap","_buyingwemag","_typeofBP","_allowedWeapons","_allowedMags","_weapcont","_magcont","_check1","_check2","_temp","_index2"];		
	_index = _this select 0;
	_amount = parseNumber(_this select 1);
	_wp = weapons player;
	
	if(!isNil"_index" && _index > -1 && (typeName _amount == "SCALAR") && _amount > 0)then {
		_temp = Z_BuyArray select _index;
		if((_temp select 2)!=0)then{	
			_type = ((Z_BuyArray select _index) select 1);
			if (Z_SellingFrom == 2) then {//gear
				if (_type == "trade_backpacks") then {
					if (!isNull (unitBackpack player)) exitWith {systemChat "Слот для рюкзака занят.";_abort = true;};					
					if (_amount > 1) exitWith {systemChat "Нельзя покупать одинаковые предметы.";_abort = true;};
					if (buyBackpack) exitWith {systemChat "Возможно купить только один рюкзак.";_abort = true;};
					if (isNil "buyBackpack") then {buyBackpack = false;};
					buyBackpack = true;					
				};

				if ((_type == "trade_weapons") or (_type == "trade_items"))	then {
					if (isNil "buyRifle") then {buyRifle = false;};
					if (isNil "buyPistol") then {buyPistol = false;};
					
					_nameitem = (Z_BuyArray select _index) select 0;						
					_config = (configFile >> "CfgWeapons" >> _nameitem);
					_wepType = getNumber(_config >> "Type");
					_isToolBelt = false;
					_isBinocs = false;				
	 
					switch (_wepType) do {
						case 1 : {
							if (_amount > 1) exitWith {systemChat "Нельзя покупать одинаковые предметы.";_abort = true;};
							if (buyRifle) exitWith {systemChat "Возможно купить только одно основное оружие.";_abort = true;};
							_abort = ((primaryWeapon player) != "");
							if (_abort) then {
								systemChat "Невозможно совершить сделку. Оружейный слот занят."; 
							} else {
								buyRifle = true;
							};	
						};
						case 2 : {
							if (_amount > 1) exitWith {systemChat "Нельзя покупать одинаковые предметы.";_abort = true;};
							if (buyPistol) exitWith {systemChat "Возможно купить только один пистолет.";_abort = true;};
							_secondaryWeapon = "";
							{
								if ((getNumber (configFile >> "CfgWeapons" >> _x >> "Type")) == 2) exitWith {
									_secondaryWeapon = _x;
								};
							} forEach _wp;
							_abort = (_secondaryWeapon != "");
							if (_abort) then {
								systemChat "Невозможно совершить сделку. Оружейный слот занят."; 
							} else {
								buyPistol = true;
							};
						};
						case 131072 : {_isToolBelt = true;};
						case 4096 : {_isBinocs = true;};
					};
					

					if(_isToolBelt or _isBinocs) then {
						if (_amount > 1) exitWith {systemChat "Нельзя покупать одинаковые предметы.";_abort = true;};
						_abort = _nameitem in _wp;
						if (_abort) then {
							_text = getText (configFile >> 'CfgWeapons' >> _nameitem >> 'displayName');
							systemChat format ["Невозможно совершить сделку. %1 у вас уже есть.",_text];
						};
						
						{
							if (_nameitem == (_x select 0)) exitWith {
								systemChat "Нельзя покупать одинаковые предметы.";
								_abort = true;  
							};
						} forEach Z_BuyingArray
					}; 					
				}; 					
			};
			
			if (Z_SellingFrom == 0) then {//backpack		
				if (_type == "trade_backpacks") exitWith {systemChat "Невозможно купить рюкзак в рюкзак."; _abort = true;};
				_backpack = unitBackpack player;
				if (isNil "_backpack") exitWith {systemChat "Рюкзак не обнаружен."; _abort = true;};
				
				_type = ((Z_BuyArray select _index) select 1);
				_toBuyWeaps = 0;
				_toBuyMags = 0;
				if(isNil "bpBuyArray") then {bpBuyArray = [0,0]};
				_buyingweap = bpBuyArray select 0;
				_buyingwemag = bpBuyArray select 1;
				if (_type == "trade_weapons") then {_toBuyWeaps = _amount;};
				if (_type == "trade_items")	then {_toBuyMags = _amount;};	

				_typeofBP = typeOf _backpack;
				_allowedWeapons = getNumber (configFile >> 'CfgVehicles' >> _typeofBP >> 'transportMaxWeapons');
				_allowedMags = getNumber (configFile >> 'CfgVehicles' >> _typeofBP >> 'transportMaxMagazines');
				
				_weapcont = (((getWeaponCargo _backpack) select 1)) call vehicle_gear_count;
				_magcont = (((getMagazineCargo _backpack) select 1)) call vehicle_gear_count;
				if(isNil "_weapcont") then {_weapcont = 0};
				if(isNil "_magcont") then {_magcont = 0};
				
				_allowedWeapons = _allowedWeapons - _weapcont - _buyingweap - floor(_magcont/10);
				_allowedMags = _allowedMags - _magcont - _buyingwemag - (_weapcont*10);
				
				_check1 = false;
				_check2 = false;

				if((_allowedWeapons >= _toBuyWeaps) && (_toBuyWeaps > 0)) then {
					_check1 = true;
					bpBuyArray set [0,_buyingweap + _toBuyWeaps];
					bpBuyArray set [1,_buyingwemag + (_toBuyWeaps * 10)];
				};
				if(( _allowedMags >= _toBuyMags) && (_toBuyMags > 0))then{
					_check2 = true;
					bpBuyArray set [1,_buyingwemag + _toBuyMags];
					bpBuyArray set [0,floor((bpBuyArray select 1) /10)];
				};
				if(!_check1 && (_toBuyWeaps > 0)) then {systemChat "Недостаточно места для покупки.";};
				if(!_check2 && (_toBuyMags > 0)) then {systemChat "Недостаточно места для покупки.";};
				
				if(!_check1 && !_check2)then{
					_abort = true;			
				};
				if (count Z_BuyingArray == 0) then {systemChat "Покупка в сумку работает нестабильно! Рекомендуем покупать предметы, только в пустую сумку!";};
			};
			if (_abort) exitWith {};


			_item = [_temp select 0,_temp select 1 ,_temp select 2,_temp select 3, _temp select 4, (ceil _amount) ];
			Z_BuyingArray set [count(Z_BuyingArray),_item];		
			_index2 = lbAdd [7422, format["%1x: %2",_item select 5,_item select 3]];
			lbSetPicture [7422, _index2, _item select 4];
			call Z_calcPrice;
		}else{
			systemChat "Это редкий товар. Его нельзя купить у торговца.";
		};
	};	
};

Z_fillBuyList = {
private ["_arrayOfTraderCat","_array","_y","_type","_buy","_pic","_text"];
		call Z_clearBuyList;
		call Z_clearBuyingList;
		Z_BuyArray = [];
		Z_BuyingArray = [];
		_arrayOfTraderCat = Z_traderData;	
		_counter = 0;
		{	
					_cat = call compile format["Category_%1",(_arrayOfTraderCat select _forEachIndex select 1)];
					for "_i" from 0 to (count _cat)-1 do
					{		
						_array = _cat select _i;
						_y  = _array select 0;								
						_type = _array select 3;
						_buy = _array select 1;
						_pic = "";
						_text = "";	
						if(_type == "trade_items")then{
							_pic = getText (configFile >> 'CfgMagazines' >> _y >> 'picture');
							_text = getText (configFile >> 'CfgMagazines' >> _y >> 'displayName');
							Z_BuyArray set [count(Z_BuyArray) , [_y,_type,_buy,_text,_pic]];
							_totalPrice = _totalPrice + _buy;																				
						};
						if(_type == "trade_weapons")then{
							_pic = getText (configFile >> 'CfgWeapons' >> _y >> 'picture');
							_text = getText (configFile >> 'CfgWeapons' >> _y >> 'displayName');
							Z_BuyArray set [count(Z_BuyArray) , [_y,_type,_buy,_text,_pic]];
							_totalPrice = _totalPrice + _buy;	
						};
						if(_type == "trade_backpacks")then{
							_pic = getText (configFile >> 'CfgVehicles' >> _y >> 'picture');
							_text = getText (configFile >> 'CfgVehicles' >> _y >> 'displayName');
							Z_BuyArray set [count(Z_BuyArray) , [_y,_type,_buy,_text,_pic]];
							_totalPrice = _totalPrice + _buy;	
						}; 
					};																	
		}forEach _arrayOfTraderCat;	
		call Z_fillBuylList;
		call Z_calcPrice;
};

Z_fillBuylList = {
private ["_index"];
	{
		_index = lbAdd [7421,  _x select 3];
		lbSetPicture [7421, _index, _x select 4 ];
	}count Z_BuyArray;
};

Z_fillBuyingList = {
private ["_index"];
	{  		
		_index = lbAdd [7422, _x select 3];
		lbSetPicture [7422, _index,  _x select 4];
	}count Z_BuyingArray;
};


Z_calculateFreeSpace = {
private ["_selection","_returnArray","_emptySlots","_allowedMags","_allowedWeapons","_allowedBackpacks","_returnArray","_typeVeh","_maxWeapons","_maxMagazines","_maxBackpacks","_weaponsCount_raw","_magazineCount_raw","_backpackCount_raw","_backpack","_dialog","_check1","_check2","_check3"];
	_selection = Z_SellingFrom;
	_returnArray = [0,0,0];
	if(_selection == 2) then{ //gear
		_emptySlots = [player] call BIS_fnc_invSlotsEmpty;
		_allowedMags = _emptySlots select 4;
		_allowedWeapons = 0;
		_allowedBackpacks = 0;		
		_returnArray = [_allowedMags,_allowedWeapons,_allowedBackpacks];
	};		
	if(_selection == 1) then{ //vehicle
		_allowedMags = 0;
		_allowedWeapons = 0;
		_allowedBackpacks = 0;
		if (!isNull Z_vehicle) then {  
			_typeVeh = typeOf Z_vehicle;
			_maxWeapons =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportMaxWeapons");
			_maxMagazines =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportMaxMagazines");
			_maxBackpacks =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportmaxbackpacks");
			
			_weaponsCount_raw = getWeaponCargo Z_vehicle;
			_magazineCount_raw = getMagazineCargo Z_vehicle;
			_backpackCount_raw = getBackpackCargo Z_vehicle;	
			
			_allowedWeapons = _maxWeapons - ((_weaponsCount_raw select 1) call vehicle_gear_count);
			_allowedMags = _maxMagazines - ((_magazineCount_raw select 1) call vehicle_gear_count);
			_allowedBackpacks = _maxBackpacks -  ((_backpackCount_raw select 1) call vehicle_gear_count);
		};									
		_returnArray = [_allowedMags,_allowedWeapons,_allowedBackpacks];
	};		
	if(_selection == 0) then{ //backpack
		_allowedWeapons = 0;
		_allowedMags = 0;
		_allowedBackpacks = 0;
		_backpack = unitBackpack player;
		if!(isNull _backpack)then{
			_typeOfbp = typeOf _backpack;			
			if (isNil "bpBuyArray") then {bpBuyArray = [0,0]}; 
			_allowedWeapons = getNumber (configFile >> 'CfgVehicles' >> _typeOfbp >> 'transportMaxWeapons');
			_allowedMags = getNumber (configFile >> 'CfgVehicles' >> _typeOfbp >> 'transportMaxMagazines');
			_weapcont = ((getWeaponCargo _backpack) select 1) call vehicle_gear_count;
			_magcont = ((getMagazineCargo _backpack) select 1) call vehicle_gear_count;
			_allowedWeapons = _allowedWeapons - (bpBuyArray select 0) - _weapcont - floor(_magcont/10);
			_allowedMags = _allowedMags - (bpBuyArray select 1) - _magcont - (_weapcont*10);
		};		
		_returnArray = [_allowedMags,_allowedWeapons,_allowedBackpacks];
	};			
	_dialog = findDisplay 711197;
	(_dialog displayCtrl 7404) ctrlSetText format["Свободные слоты: %1/%2/%3",_returnArray select 1,_returnArray select 0,_returnArray select 2];
};

Z_CheckCloseVehicle = {
private ["_check","_vehicle","_vehicleType","_vehicleName","_result"];
	_vehicle = objNull;
	_result = false;
	
	_check = call Z_CheckVehicle;
	if !(_check) then {		
		_vehicle = Z_vehicle;
		_result = true;
		_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
		[format["Покупка в %1.", _vehicleName]] call Z_filleTradeTitle;				
	};						
	_result
};

Z_CheckVehicle = {
	private ["_abort","_owner"];
	_abort = true;
	if(!isNull Z_vehicle && alive Z_vehicle && ((player distance Z_vehicle) < Z_VehicleDistance)) then {
		_owner = Z_vehicle getVariable["Premium_Trade",""];
		if (_owner == name player) then {
			_abort = false;
		};
	};
	if (_abort) then {Z_vehicle = objNull;};
	_abort;
};

Z_allowBuying = {
private ["_selection","_return","_toBuyWeaps","_toBuyMags","_toBuyBags","_emptySlots","_allowedMags","_allowedWeapons","_allowedBackpacks","_mags","_weaps","_bags","_typeVeh","_normalMags","_normalWeaps","_normalBags","_kinds","_ammmounts","_counter","_kinds2","_ammmounts2","_kinds3","_ammmounts3","_maxWeapons","_maxMagazines","_maxBackpacks","_weaponsCount_raw","_magazineCount_raw","_backpackCount_raw","_typeOfbp"];
	_selection = Z_SellingFrom;
	_return = false;
	_toBuyWeaps = _this select 0;
	_toBuyMags = _this select 1;
	_toBuyBags = _this select 2;
	if(_selection == 2) then{//gear
		_emptySlots = [player] call BIS_fnc_invSlotsEmpty;
		_allowedMags = _emptySlots select 4;

		if( _allowedMags >= _toBuyMags)then{
			_return = true;
		}else{
			systemChat format["Свободных слотов всего %1. Выберите меньшее количество.",_allowedMags];
		};
	};		
	if(_selection == 1) then{ //vehicle
		_allowedMags = 0;
		_allowedWeapons = 0;
		_allowedBackpacks = 0;
		if (!isNull Z_vehicle) then {   
		
			_mags = getMagazineCargo Z_vehicle;
			_weaps = getWeaponCargo Z_vehicle;
			_bags = getBackpackCargo Z_vehicle;
			_typeVeh = typeOf Z_vehicle;
			_normalMags = [];
			_normalWeaps = [];
			_normalBags = [];
			
			_kinds = _mags select 0;
			_ammmounts = _mags select 1;
			{
				_counter = 0 ;
				while{	_counter < ( 	_ammmounts select _forEachIndex)}do{
				_normalMags set [count(_normalMags),_x];
						_counter = _counter + 1;
				};
			}forEach _kinds;
			
			_kinds2 = _weaps select 0;
			_ammmounts2 = _weaps select 1;
			{
				_counter = 0 ;
				while{	_counter < ( 	_ammmounts2 select _forEachIndex)}do{
					_normalWeaps set [count(_normalWeaps),_x];
					_counter = _counter + 1;
				};
			}forEach _kinds2;
			
			_kinds3 = _bags select 0;
			_ammmounts3 = _bags select 1;
			{
				_counter = 0 ;
				while{	_counter < ( 	_ammmounts3 select _forEachIndex)}do{
					_normalBags set [count(_normalBags),_x];
					_counter = _counter + 1;
				};
			}forEach _kinds3;
			
			_maxWeapons =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportMaxWeapons");
			_maxMagazines =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportMaxMagazines");
			_maxBackpacks =	getNumber (configFile >> "CfgVehicles" >> _typeVeh >> "transportmaxbackpacks");
			
			_weaponsCount_raw = getWeaponCargo Z_vehicle;
			_magazineCount_raw = getMagazineCargo Z_vehicle;
			_backpackCount_raw = getBackpackCargo Z_vehicle;	
			
			_allowedWeapons = _maxWeapons - ((_weaponsCount_raw select 1) call vehicle_gear_count);
			_allowedMags = _maxMagazines - ((_magazineCount_raw select 1) call vehicle_gear_count);
			_allowedBackpacks = _maxBackpacks -  ((_backpackCount_raw select 1) call vehicle_gear_count);				
		}else{
			systemChat format["%1", typeName "Z_vehicle"];
		};	
		
		_check1 = false;
		_check2 = false;
		_check3 = false;

		if( _allowedWeapons >= _toBuyWeaps)then{
			_check1 = true;
		}else{
			systemChat format["Вы можете купить только %1 оружие(-я) в вашу технику.",_allowedWeapons];
		};
		if( _allowedMags >= _toBuyMags)then{
			_check2 = true;
		}else{
			systemChat format["Свободных слотов всего %1. Выберите меньшее количество.",_allowedMags];
		};	

		if( _allowedBackpacks >= _toBuyBags)then{
			_check3 = true;
		}else{
			systemChat format["Вы можете купить только %1 рюкзак(ов) в вашу технику.",_allowedBackpacks];
		};

		if(_check1 && _check2 && _check3)then{
			_return = true;
		};					
	};		
	if(_selection == 0) then{ //backpack
		_allowedWeapons = 0;
		_allowedMags = 0;
		_allowedBackpacks = 0;
		_backpack = unitBackpack player;
		if!(isNull _backpack)then{
			_typeOfbp = typeOf _backpack;
			_allowedWeapons = getNumber (configFile >> 'CfgVehicles' >> _typeOfbp >> 'transportMaxWeapons');
			_allowedMags = getNumber (configFile >> 'CfgVehicles' >> _typeOfbp >> 'transportMaxMagazines');
		};		
		
		_check1 = false;
		_check2 = false;
		_check3 = false;

		if( _allowedWeapons >= _toBuyWeaps)then{
			_check1 = true;
		};
		if( _allowedMags >= _toBuyMags)then{
			_check2 = true;
		};			
		if( _allowedBackpacks >= _toBuyBags)then{
			_check3 = true;
		} else {
			systemChat "Невозможно купить рюкзак в рюкзак.";
		};
		if(_check1 && _check2 && _check3)then{
			_return = true;			
		};	
	};

	_return
};
