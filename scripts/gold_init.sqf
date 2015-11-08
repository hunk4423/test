BankDialogTransferAmount 		= 13000;
BankDialogPlayerBalance 		= 13001;
BankDialogBankBalance 			= 13002;

SCTraderDialogCatList 			= 32000;
SCTraderDialogItemList 			= 32001;
SCTraderDialogBuyPrice 			= 32002;
SCTraderDialogSellPrice 		= 32003;

GivePlayerDialogTransferAmount 	= 14000;
GivePlayerDialogPlayerBalance 	= 14001;


BankDialogUpdateAmounts = {
	ctrlSetText [BankDialogPlayerBalance, format["%1 %2", [(player getVariable ['headShots', 0])] call BIS_fnc_numberText, CurrencyName]];
	ctrlSetText [BankDialogBankBalance, format["%1 %2", [(player getVariable ['bank', 0])] call BIS_fnc_numberText, CurrencyName]];
};

GivePlayerDialogAmounts = {
	ctrlSetText [GivePlayerDialogPlayerBalance, format["%1 %2", [(player getVariable ['headShots', 0])] call BIS_fnc_numberText, CurrencyName]];
	ctrlSetText [14003, format["%1", (name targivemonet)]];
};

BankDialogWithdrawAmount = {
	if(DZE_ActionInProgress) exitWith { titleText ["Я занят.", "PLAIN DOWN", 0.5];};
	DZE_ActionInProgress = true;
	private ["_amount","_bank","_wealth"];
	_amount = parseNumber (_this select 0);	
	_bank = player getVariable ["bank", 0];
	_wealth = player getVariable["headShots",0];
	if (isNil "_wealth")  exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};
	if (typeName _wealth != "SCALAR") exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};

	if (_amount < 1 or _amount > _bank) exitWith {
		DZE_ActionInProgress = false;
		cutText ["Не достаточно средств.", "PLAIN DOWN"];
	};
	player setVariable["headShots",(_wealth + _amount),true];
	player setVariable["bank",(_bank - _amount),true];
	player setVariable ["bankchanged",1,true];
	player setVariable ["moneychanged",1,true];	
	PVDZE_plr_Save = [player,(magazines player),true,true] ;
	publicVariableServer "PVDZE_plr_Save";

	cutText [format["С Вашего счета снято %1 руб.", [_amount] call BIS_fnc_numberText], "PLAIN DOWN"];
	DZE_ActionInProgress = false;
};

BankDialogDepositAmount = {
	if(DZE_ActionInProgress) exitWith { titleText ["Я занят.", "PLAIN DOWN", 0.5];};
	DZE_ActionInProgress = true;
	private ["_amount","_bank","_wealth"];
	_wealth = player getVariable["headShots",0];
	if(_this select 1)then{
		_amount=_wealth;
	}else{
		_amount=parseNumber (_this select 0);
	};
	_bank = player getVariable ["bank", 0];
	if (isNil "_wealth")  exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};
	if (typeName _wealth != "SCALAR") exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};
	if (_amount < 1 or _amount > _wealth) exitWith {
		DZE_ActionInProgress = false;
		cutText ["Не достаточно средств.", "PLAIN DOWN"];
	};

	if(   LimitOnBank  && ((_bank + _amount ) >  MaxBankMoney)) then{
	
		if(   (getPlayerUID player in DonatorListZupa )  && ((_bank + _amount ) <  MaxDonatorBankMoney)) then{ 
	
			player setVariable["headShots",(_wealth - _amount),true];
			player setVariable["bank",(_bank + _amount),true];
			player setVariable ["bankchanged",1,true];
			player setVariable ["moneychanged",1,true];	
			PVDZE_plr_Save = [player,(magazines player),true,true] ;
			publicVariableServer "PVDZE_plr_Save";				
			cutText [format["Ваш счет пополнен на сумму %1 руб.", [_amount] call BIS_fnc_numberText], "PLAIN DOWN"];			
		}else{
			cutText [format["You can only have a max of %1 %3, donators %2", [MaxBankMoney] call BIS_fnc_numberText,[MaxDonatorBankMoney] call BIS_fnc_numberText,CurrencyName], "PLAIN DOWN"];
		};
	}else{	
	player setVariable["headShots",(_wealth - _amount),true];
	player setVariable["bank",(_bank + _amount),true];
	player setVariable ["bankchanged",1,true];
	player setVariable ["moneychanged",1,true];	
	PVDZE_plr_Save = [player,(magazines player),true,true] ;
	publicVariableServer "PVDZE_plr_Save";	
	cutText [format["Ваш счет пополнен на сумму %1 руб.", [_amount] call BIS_fnc_numberText], "PLAIN DOWN"];
	};
	DZE_ActionInProgress = false;
};

GivePlayerAmount = {
	if(DZE_ActionInProgress) exitWith { titleText ["Я занят.", "PLAIN DOWN", 0.5];};
	DZE_ActionInProgress = true;
	private ["_amount","_target","_wealth"];
	_amount = parseNumber (_this select 0);
	_target = targivemonet;
	_wealth = player getVariable["headShots",0];
	if (isNil "_wealth")  exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};
	if (_target == player) exitWith {cutText ["Ошибка","PLAIN DOWN"];};
	if (typeName _wealth != "SCALAR") exitWith {cutText ["Наличных не найдено","PLAIN DOWN"];};
	
	_twealth = _target getVariable["headShots",0];
	if (_amount < 1 or _amount > _wealth) exitWith {
		cutText ["Недостаточно средств.", "PLAIN DOWN"];
		DZE_ActionInProgress = false;
	};
	
	player setVariable["headShots",_wealth - _amount, true];
	_target setVariable["headShots",_twealth + _amount, true];
	
	PVDZE_plr_Save = [player,(magazines player),true,true] ;
	publicVariableServer "PVDZE_plr_Save";
	PVDZE_plr_Save = [_target,(magazines _target),true,true] ;
	publicVariableServer "PVDZE_plr_Save";
	
	player setVariable ["moneychanged",1,true];	
	cutText [format["Вы перевели %1 руб", [_amount] call BIS_fnc_numberText], "PLAIN DOWN"];
	[nil,_target,"loc", rTITLETEXT, format["Ваш счет пополнен на %1р. от игрока %2",[_amount] call BIS_fnc_numberText,name player], "PLAIN", 0] call RE;
	DZE_ActionInProgress = false;
};