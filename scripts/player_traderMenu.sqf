TraderDialogCatList = 12000;
TraderDialogItemList = 12001;
TraderDialogBuyPrice = 12002;
TraderDialogSellPrice = 12003;
TraderDialogBuyBtn = 12004;
TraderDialogSellBtn = 12005;
TraderDialogCurrency = 12006;

TraderCurrentCatIndex = -1;
TraderCatList = [];
TraderItemList = [];

TraderDialogLoadItemList = {
	private ["_trader_id","_item","_buy","_sell","_afile","_type","_textPart","_file","_count","_index","_image","_item_list"];

	TraderItemList = [];
	_index = _this select 0;
	LastTraderSelectCategory=_index;

	if (_index < 0 or TraderCurrentCatIndex == _index) exitWith {};
	TraderCurrentCatIndex = _index;

	_trader_id = TraderCatList select _index;

	lbClear TraderDialogItemList;
	ctrlSetText [TraderDialogBuyPrice, ""];
	ctrlSetText [TraderDialogSellPrice, ""];

	lbAdd [TraderDialogItemList, "Загрузка... Ждите!!!"];

	TradeMenuResult = call compile format["category_%1;",_trader_id];
	
	lbClear TraderDialogItemList;
	_item_list = [];
	{
		//"Skin_GUE_Commander_DZ",20000,100,"trade_items"]
		_item = _x select 0; // Skin_GUE_Commander_DZ
		_buy = _x select 1; // 20000
		_sell = _x select 2; // 100
		_afile = _x select 3; // "trade_items"
		_type = '';
		
		switch (true) do {
			case (_afile == "trade_items"):
			{
				_textPart = getText (configFile >> 'CfgMagazines' >> _item >> 'displayName');
				_type = 'CfgMagazines';
			};
			case (_afile == "trade_weapons"):
			{
				_textPart = getText (configFile >> 'CfgWeapons' >> _item >> 'displayName');
				_type = 'CfgWeapons';
			};
			case (_afile == "trade_backpacks" || _afile == "trade_any_vehicle"):
			{
				_textPart = getText (configFile >> 'CfgVehicles' >> _item >> 'displayName');
				_type = 'CfgVehicles';
			};
		};		
	
		_file = "scripts\" + _afile + ".sqf";
			
		_count = 0;
		if(_type == "CfgVehicles") then {
			if (_afile == "trade_backpacks") then {
				if(_item == typeOf (unitBackpack player)) then {
					_count = 1;
				};
			} else {
				if (isClass(configFile >> "CfgVehicles" >> _item)) then {
					_count = {(typeOf _x) == _item} count (nearestObjects [player, [_item], 40]);
				};
			};
		};


		if(_type == "CfgMagazines") then {
			_count = {_x == _item} count magazines player;
		};

		if(_type == "CfgWeapons") then {
			_count = {_x == _item} count weapons player;
		};

		_index = lbAdd [TraderDialogItemList, format["%1 (%2)", _textPart, _item]];

		if (_count > 0) then {
			lbSetColor [TraderDialogItemList, _index, [0, 1, 0, 1]];
		};

		_image = getText(configFile >> _type >> _item >> "picture");
		lbSetPicture [TraderDialogItemList, _index, _image];

		_item_list set [count _item_list, [
			_item,
			_buy,
			_sell,
			_afile,
			_textPart,
			_file
		]];
	} forEach TradeMenuResult;
	TraderItemList = _item_list;
};

TraderDialogShowPrices = {
	private ["_index", "_item", "_sell", "_handled"];
	_index = _this select 0;
	if (_index < 0) exitWith {};
	LastTraderSelectItem=_index;
	

	_item = TraderItemList select _index;
	_sell = _item select 2;
	

	if (_item select 3 == "trade_any_vehicle") then {
		_veh = (nearestObjects [player, [_item select 0], 40]) select 0;
		if (isNil "_veh") exitWith {};
		_sell = [_veh,_sell] call Sell_Veh_Price;
	};
	
	ctrlSetText [TraderDialogBuyPrice, format["%1 %2", [_item select 1] call BIS_fnc_numberText, CurrencyName]];
	ctrlEnable [TraderDialogBuyBtn, true];
	ctrlSetText [TraderDialogSellPrice, format["%1 %2", [_sell] call BIS_fnc_numberText, CurrencyName]];


	if (!isNil "VehiclePreviewHotkey") then {
		PreviewListCfg=nil;
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", VehiclePreviewHotkey];
		VehiclePreviewHotkey = nil;
	};

	if (["trade_any_",_item select 3] call fnc_inString) then {
		PreviewListCfg=[_item select 0,"vehicle",[LastTraderSelectCategory,LastTraderSelectItem]];
		VehiclePreviewHotkey = (findDisplay 46) displayAddEventHandler ["KeyDown", "
			_handled = false;
			if ((_this select 1)==0x3F)then{
				PreviewListCfg spawn fnc_Preview;
				_handled = true;
			};
			_handled
		"];

		taskHint ['Для предварительного просмотра техники нажмите F5', [0,0.4,1,1], 'taskNew'];

		[] spawn {
			waitUntil {sleep 0.1;!dialog};
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", VehiclePreviewHotkey];
			VehiclePreviewHotkey = nil;
		};
	};

	if (!isNil "SkinPreviewHotkey") then {
		PreviewListCfg=nil;
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", SkinPreviewHotkey];
		SkinPreviewHotkey = nil;
	};
	if (((_item select 5)=="scripts\trade_items.sqf")&&(["Skin_",(_item select 0)] call fnc_inString)) then {
		PreviewListCfg=[_item select 0,"itemSkins",[LastTraderSelectCategory,LastTraderSelectItem]];
		SkinPreviewHotkey = (findDisplay 46) displayAddEventHandler ["KeyDown", "
			_handled = false;
			if ((_this select 1)==0x3F) then {
				PreviewListCfg spawn fnc_Preview;
				_handled = true;
			};
			_handled
		"];
		
		taskHint ['Для предварительного просмотра скина нажмите F5', [0,0.4,1,1], 'taskNew'];
		[] spawn {
			waitUntil {sleep 0.1;!dialog};
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", SkinPreviewHotkey];
			SkinPreviewHotkey = nil;
		};
	};	
};

TraderDialogBuy = {
	private ["_index", "_item", "_data"];
	_index = _this select 0;
	if (_index < 0) exitWith {cutText [(localize "str_epoch_player_6"), "PLAIN DOWN"];};
	if!(count TraderItemList > 0)exitWith{};
	
	//["SVD",2500,300,"trade_weapons","СВД","scripts\trade_weapons.sqf"]
	_item = TraderItemList select _index;
	
	if((_item select 1)==0)exitWith{cutText["Это редкий товар. Его нельзя купить у торговца.", "PLAIN DOWN"];};
	
	//["SVD",2500,"СВД","buy"]
	_data = [_item select 0, _item select 1, _item select 4, "buy"];
	_data execVM (_item select 5);
	
	TraderItemList = [];
};

TraderDialogSell = {
	private ["_index", "_item", "_data"];
	_index = _this select 0;
	if (_index < 0) exitWith {cutText [(localize "str_epoch_player_6"), "PLAIN DOWN"];};
	if!(count TraderItemList > 0)exitWith{};
	
	//["SVD",2500,300,"trade_weapons","СВД","scripts\trade_weapons.sqf"]
	_item = TraderItemList select _index;
	
	//["SVD",300,"СВД","sell"]
	_data = [_item select 0, _item select 2, _item select 4, "sell"];
	_data execVM (_item select 5);

	TraderItemList = [];
};