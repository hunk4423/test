/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
scriptName "Functions\misc\fn_selfActions.sqf";
/***********************************************************
	ADD ACTIONS FOR SELF
	- Function
	- [] call fnc_usec_selfActions;
************************************************************/
private ["_isInternetShop","_buyArmored","_gMenu","_displayName","_can_SelectForTrade","_objCommentCtrl","_PlayerIsOwner","_isPowerStation","_isFuelPump","_plDistance","_clothesTaken","_isInflamed","_HaveCharID","_notDamage","_isPlayer","_isBike","_temp_keys","_magazinesPlayer","_isPZombie","_vehicle","_inVehicle","_hasRawMeat","_onLadder","_nearLight","_canPickLight","_canDo","_text","_isHarvested","_isVehicle","_isMan","_ownerID","_hasOwner","_isAnimal","_isZombie","_isTent","_isFuel","_isAlive","_buy","_allowedDistance","_menu","_humanity_logic","_low_high","_cancel","_traderMenu","_isWreck","_isDisallowRepair","_humanity","_isAir","_isShip","_findNearestGen","_IsNearRunningGen","_Ct","_isnewstorage","_itemsPlayer","_ownerKeyId","_typeOfCt","_hasKey","_combi","_player_lockUnlock_crtl","_take_owner_ctrl","_gift_ctrl","_ownerKeyName","_temp_keys_names","_characterID","_IsNearFuel","_vkc_claim_crtl","_cargo_ctrl","_temp_keys_items","_comment"];

if (DZE_ActionInProgress) exitWith {}; // Do not allow if any script is running.

_vehicle = vehicle player;
_isPZombie = player isKindOf "PZombie_VB";
_inVehicle = (_vehicle != player);
_Ct = cursorTarget;
_typeOfCt = typeOf _Ct;
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf && !r_player_unconscious && !_onLadder);
_isVehicle=false;
if (!isNull _Ct)then{_isVehicle = [_Ct,true] call vehicle_isVehicle};
_plDistance = player distance _Ct;

_nearLight = nearestObject [player,"LitObject"];
_canPickLight = false;
if (!isNull _nearLight) then {
	if (_nearLight distance player < 4) then {
		_canPickLight = isNull (_nearLight getVariable ["owner",objNull]);
	};
};

//Grab Flare
if (_canPickLight && !dayz_hasLight && !_isPZombie) then {
	if (s_player_grabflare < 0) then {
		_text = getText (configFile >> "CfgAmmo" >> (typeOf _nearLight) >> "displayName");
		s_player_grabflare = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLight, 1, false, true, "", ""];
		s_player_removeflare = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLight, 1, false, true, "", ""];
	};
} else {
	player removeAction s_player_grabflare;
	player removeAction s_player_removeflare;
	s_player_grabflare = -1;
	s_player_removeflare = -1;
};


// Increase distance only if AIR || SHIP
_allowedDistance = 4;
_isAir = _Ct isKindOf "Air";
_isShip = _Ct isKindOf "Ship";
if(_isAir || _isShip) then {
	_allowedDistance = 8;
}else{
	if (_typeOfCt in BmpTunguska) then {
		_allowedDistance=7;
	};
};

_resetAllEvents = {
	player removeAction s_player_plotManagement;s_player_plotManagement = -1;
	if (s_player_repair_crtl>-1)then{
		{dayz_myCursorTarget removeAction _x} count s_player_repairActions;s_player_repairActions = [];
		s_player_repair_crtl = -1;
	};
	if (s_player_GK_actions_ctrl)then{
		{player removeAction _x} count s_player_GK_actions;s_player_GK_actions = [];
		s_player_GK_actions_ctrl = false;
	};
	{player removeAction _x} count s_player_combi;s_player_combi = [];s_player_unlockvault=-1;
	{player removeAction _x} count s_player_parts;s_player_parts = [];s_player_parts_crtl = -1;
	{player removeAction _x} count s_player_lockunlock;s_player_lockunlock = [];s_player_lockUnlock_crtl = -1;
	player removeAction s_player_checkGear;s_player_checkGear = -1;
	player removeAction s_player_forceSave;s_player_forceSave = -1;	
	player removeAction s_player_SeaFox;s_player_SeaFox = -1;	
#ifdef _ORIGINS
	player removeAction s_player_removeUpg;s_player_removeUpg = -1;	
#endif
#ifdef _OVERPOCH
	player removeAction s_player_DonRepair;s_player_DonRepair = -1;
#endif	
	player removeAction flip_veh_act_id;flip_veh_act_id = -1;
	player removeAction s_player_hasOwner;s_player_hasOwner = -1;
	player removeAction s_player_sleep;s_player_sleep = -1;
	player removeAction s_player_deleteWreck;s_player_deleteWreck = -1;
	player removeAction s_player_deleteVeins;s_player_deleteVeins = -1;
	player removeAction s_player_butcher;s_player_butcher = -1;
	player removeAction s_player_cook;s_player_cook = -1;
	player removeAction s_player_boil;s_player_boil = -1;
	player removeAction s_player_fireout;s_player_fireout = -1;
	player removeAction s_player_packtent;s_player_packtent = -1;
	player removeAction s_player_fillfuel;s_player_fillfuel = -1;
	player removeAction s_player_studybody;s_player_studybody = -1;
    player removeAction s_player_manageDoor;s_player_manageDoor = -1;
	player removeAction s_player_deleteBuild;s_player_deleteBuild = -1;
	player removeAction s_player_unlockvault;s_player_unlockvault = -1;
	player removeAction s_player_packvault;s_player_packvault = -1;
	player removeAction s_player_safeManagement;s_player_safeManagement=-1;
	player removeAction s_player_lockvault;s_player_lockvault = -1;
	player removeAction s_player_information;s_player_information = -1;
	player removeAction s_player_fillgen;s_player_fillgen = -1;
	player removeAction s_power_onoff;s_power_onoff=-1;
	player removeAction s_player_upgrade_build;s_player_upgrade_build = -1;
	player removeAction s_player_maint_build;s_player_maint_build = -1;
	player removeAction s_player_downgrade_build;s_player_downgrade_build = -1;
	player removeAction s_player_towing;s_player_towing = -1;
	player removeAction s_player_fuelauto;s_player_fuelauto = -1;
	player removeAction s_player_fuelauto2;s_player_fuelauto2 = -1;
	player removeAction s_can_get_money;s_can_get_money = -1;	
	player removeAction s_player_select_veh;s_player_select_veh = -1;
	player removeAction s_givemoney_dialog;s_givemoney_dialog = -1;
	player removeAction s_bank_dialog;s_bank_dialog = -1;
	player removeAction s_bank_dialog2;s_bank_dialog2 = -1;
	player removeAction s_player_packItem;s_player_packItem = -1;
	player removeAction s_player_packVeh;s_player_packVeh = -1;
	player removeAction s_player_dance;s_player_dance = -1;
	player removeAction s_player_sport;s_player_sport = -1;
	player removeAction s_player_needbankir;s_player_needbankir = -1;
	player removeAction s_player_delTrashVeh;s_player_delTrashVeh = -1;
	player removeAction s_player_clothes;s_player_clothes = -1;
	player removeAction s_player_changeKey;s_player_changeKey = -1;
	player removeAction s_player_claimKey;s_player_claimKey = -1;
	player removeAction s_garage_dialog;s_garage_dialog = -1;
	player removeAction s_obj_comment;s_obj_comment=-1;
	player removeAction s_info_Comment;s_info_Comment=-1;
	player removeAction s_player_move_build;s_player_move_build = -1;
	player removeAction s_cargo;s_cargo=-1;
	s_event_reset=true;
};

if (!isNull _Ct && !_inVehicle && !_isPZombie && (_plDistance < _allowedDistance) && _canDo) then {	//Has some kind of target
	if (!isNull s_player_lastTarget)then{
		if (s_player_lastTarget != _Ct && !s_event_reset)then{[] call _resetAllEvents;dayz_myCursorTarget=objNull};
	};
	s_player_lastTarget = _Ct;
	// hintsilent _typeOfCt;
	_isnewstorage = _typeOfCt in DZE_isNewStorage;
	
	// get items && magazines only once
	_magazinesPlayer=magazines player;
	_itemsPlayer=items player;

	_temp_keys=[];
	_temp_keys_names=[];
	_temp_keys_items=[];
	// find available keys
	{
		if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in itemKeyColor) then {
			_ownerKeyId = getNumber(configFile >> "CfgWeapons" >> _x >> "keyid");
			_ownerKeyName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
			_temp_keys_names set [_ownerKeyId,_ownerKeyName];
			_temp_keys set [count _temp_keys,str(_ownerKeyId)];
			_temp_keys_items set [_ownerKeyId, _x];
		};
	} count _itemsPlayer;

	_isMan = _Ct isKindOf "Man";
	_isInternetShop=_typeOfCt=="MAP_notebook";
	_ownerID = _Ct getVariable ["OwnerPUID","0"];
	_PlayerIsOwner = _ownerID == dayz_playerUID;
	_hasOwner=_ownerID!="0";
	_characterID = _Ct getVariable ["CharacterID","0"];
	_isAnimal = _Ct isKindOf "Animal";
	_isZombie = _Ct isKindOf "zZombie_base";
	_isWreck = _typeOfCt in DZE_isWreck;
	_isFuelPump = _typeOfCt in dayz_fuelpumparray;
	_isPowerStation = _typeOfCt in dayz_powerarray;
	_isDisallowRepair = _typeOfCt in ["M240Nest_DZ"];
	_isPlayer = isPlayer _Ct;
	_isTent = _Ct isKindOf "TentStorage";
	_isAlive = alive _Ct;
	_comment=GetComment(_Ct);
	_text=[_Ct,true] call object_getNameWithComment;
	_displayName=getText (configFile >> "CfgVehicles" >> _typeOfCt >> "displayName");

	_HaveCharID = _characterID != "0";
	_isInflamed = inflamed _Ct;
	_lockedCt = locked _Ct;
	_isBike = _Ct isKindOf "Bicycle";
	_notDamage = damage _Ct < 1;
	
	_showRepair = false;
	_hasKey = false;

	// logic vars
	_player_lockUnlock_crtl = false;
	_vkc_claim_crtl = false;
	_take_owner_ctrl = false;
	_gift_ctrl = false;
	_objCommentCtrl=false;
	_cargo_ctrl=false;

	if(!_isVehicle && s_info_Comment<0)then{
		if (_comment!="")then{
			s_event_reset=false;
			s_info_Comment = player addAction [format["<t color='#FFFA00'>%1</t>",_comment], "",[], 190, false, true, "",""];
		};
	};

	// CURSOR TARGET ALIVE
	if(_isAlive) then {
		//Разбор мусора и черного ящика
		if(_isWreck || (_typeOfCt == "Land_ammo_supply_wreck")) then {
			if (s_player_deleteWreck < 0) then {
				s_player_deleteWreck = player addAction [format[localize "str_actions_delete",_displayName], SCRIPT_FILE(remove.sqf),_Ct, -20, true, true, "", ""];
				s_event_reset=false;
			};
		};

		//_isVehicle
		if (_isVehicle && !(_Ct getVariable["taxi",false]))then{
			s_event_reset=false;
			if(!_isBike && _notDamage) then {
				_hasKey = _characterID in _temp_keys;
				if !(_lockedCt) then {_showRepair = true;_cargo_ctrl=true};
				if (_HaveCharID)then{
					_player_lockUnlock_crtl = true;
					if (!_hasOwner && !_lockedCt)then{
						_take_owner_ctrl=true;
					};
				};
				if (CurrAdminLevel>0) then {
					_vkc_claim_crtl = true;
				};
				if (_PlayerIsOwner)then{_objCommentCtrl=true;_gift_ctrl=true};
			};
			//Fuel Pump on truck
			if(_typeOfCt in DZE_fueltruckarray) then {
				if (s_player_fuelauto2 < 0) then {
					// show that fuel truck pump needs power.
					if(isEngineOn _Ct) then {
						s_player_fuelauto2 = player addAction [localize "STR_EPOCH_ACTIONS_FILLVEH", "\z\addons\dayz_code\actions\fill_nearestVehicle.sqf",_Ct, -3, false, true, "",""];
					} else {
						s_player_fuelauto2 = player addAction [format["<t color='#ff0000'>%1</t>",localize "STR_EPOCH_ACTIONS_NEEDPOWER"], "",[], -3, false, true, "",""];
					};
				};
			};
		};
	};
	
	if(((CurrAdminLevel>0)||vkc_claimKey)&&((count _temp_keys) > 1)&&(_isVehicle || (_typeOfCt in DZE_DoorsLocked)))then{
		if (s_player_changeKey < 0) then {// сменить ключ
			s_player_changeKey = player addAction ["<t color='#5882FA'>Изменить ключ</t>",SCRIPT_FILE(VehicleKeyChanger.sqf),[_Ct, _temp_keys, _characterID, _temp_keys_names,(_temp_keys_items select (parseNumber _characterID))],-1002,false,false,"",""];
		};
	};

	if (_vkc_claim_crtl) then {
		if (s_player_claimKey < 0) then {// создать ключ для машины
			s_player_claimKey = player addAction ["<t color='#5882FA'>Создать ключ</t>",SCRIPT_FILE(VehicleKeyChanger.sqf),[_Ct, _temp_keys, "0", _temp_keys_names,"0"],-1002,false,false,"",""];
		};
	};
	
	if(_cargo_ctrl)then{
		if(s_cargo<0)then{
			if(count (_Ct getVariable["Cargo",[]])>0)then{
				s_cargo=player addAction ["<t color='#5882FA'>Разгрузить</t>",SCRIPT_FILE(cargoUnload.sqf),_Ct,-1,false,false,"",""];
			};
		};
	};

	// Allow Owner to lock && unlock vehicle  
	if(_player_lockUnlock_crtl) then {
		
		if (s_player_lockUnlock_crtl>0)then{
			if ((_lockedCt && s_player_lockUnlock_crtl==2)||(!_lockedCt && s_player_lockUnlock_crtl==1))then{call _resetAllEvents};
		};
		if (s_player_lockUnlock_crtl < 0) then {
			if (_hasKey)then{
				player removeAction s_player_hasOwner;
				s_player_hasOwner = -1;
			}else{
				if (s_player_hasOwner < 0) then {
					s_player_hasOwner = player addAction [format["<t color='#FF0000'>ТЕХНИКА ПРИНАДЛЕЖИТ ИГРОКУ %1</t>",GetOwnerName(_Ct)], "",[], 200, false, true, "",""];
				};
			};
			if(_lockedCt) then {
				if(_hasKey) then {
					_menu = player addAction [format[("<t color='#228B22'>")+ localize "STR_EPOCH_ACTIONS_UNLOCK" +("</t>"),_text],SCRIPT_FILE(lockunlock_veh.sqf),[_Ct,false,(_temp_keys_names select (parseNumber _characterID))], 200, true, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_menu];
				} else {
					if(_PlayerIsOwner)then{
						_menu = player addAction ["<t color='#5882FA'>Создать новый ключ (10,000руб.)</t>",SCRIPT_FILE(restore_key.sqf),[_Ct,"new"], -21, true, true, "", ""];
						s_player_lockunlock set [count s_player_lockunlock,_menu];
						_menu = player addAction ["<t color='#5882FA'>Восстановить ключ (10,000руб.)</t>",SCRIPT_FILE(restore_key.sqf),[_Ct,"old"], -22, true, true, "", ""];
						s_player_lockunlock set [count s_player_lockunlock,_menu];
					};
					_menu = player addAction [format["<t color='#ff0000'>%1</t>",localize "STR_EPOCH_ACTIONS_VEHLOCKED"], "",_Ct, 2, true, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_menu];
				};
				s_player_lockUnlock_crtl = 1;
			} else {
				if (_take_owner_ctrl)then{
					_menu=player addAction ["<t color='#FF0000'>Стать владельцем</t>",SCRIPT_FILE(takeOwner.sqf),_Ct,199,false,false,"",""];
					s_player_lockunlock set [count s_player_lockunlock,_menu];
				};				
				if(_hasKey) then {
					_objCommentCtrl=true;
					
					_menu = player addAction [format[("<t color='#228B22'>")+ localize "STR_EPOCH_ACTIONS_LOCK" +("</t>"),_text],SCRIPT_FILE(lockunlock_veh.sqf),[_Ct,true], 1, false, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_menu];

					if(!(_Ct isKindOf "Air")&&!(_Ct isKindOf "Ship")&&((GETVAR(_Ct,TurboInstalled,"0"))=="0"))then{
						_menu = player addAction ["<t color='#5882FA'>Установить турбину</t>",SCRIPT_FILE(TurboInstall.sqf),_Ct, -19, true, true, "", ""];
						s_player_lockunlock set [count s_player_lockunlock,_menu];
					};
					if (!(_Ct isKindOf "Volha_TK_CIV_Base_EP1") && !(_typeOfCt in ColourVehicles) && !(_Ct isKindOf "StaticWeapon") && !(_Ct isKindOf "SUV_Base_EP1")) then {
						_menu = player addAction ["<t color='#5882FA'>Перекрасить</t>",SCRIPT_FILE(player_paint.sqf),_Ct, -21, true, true, "", ""];
						s_player_lockunlock set [count s_player_lockunlock,_menu];
					};
					#ifdef _ORIGINS
					s_player_lockunlock set [count s_player_lockunlock,player addAction ["<t color='#5882FA'>Расширенная покраска</t>",SCRIPT_FILE(objectAction.sqf),[_Ct,"ChengeSkin"], -20, false, true, "",""]];
					#endif
					
					//Эвакуационный вертолет
					if(_isAir && (_typeOfCt in evac_AllowedChoppers))then{
						if(playerHasEvacField)then{
							if((_ct distance playersEvacField) <= 10)then{
								_menu = player addAction ["<t color='#5882FA'>Удалить зону взлета</t>",SCRIPT_FILE(ClearEvacChopper.sqf),_Ct, -300, true, true, "", ""];
								s_player_lockunlock set [count s_player_lockunlock,_menu];
							};
						}else{
							_menu = player addAction ["<t color='#5882FA'>Установить зону взлета</t>",SCRIPT_FILE(SetEvacChopper.sqf),_Ct, -300, true, true, "", ""];
							s_player_lockunlock set [count s_player_lockunlock,_menu];
						};
					};
					if (_gift_ctrl)then{
						_menu=player addAction [format["<t color='#5882FA'>Подарить %1</t>",_text],SCRIPT_FILE(objectAction.sqf),[_Ct,"gift",10,format["Подарить %1",_text]],-249,false,false,"",""];
						s_player_lockunlock set [count s_player_lockunlock,_menu];
					};
				};
				s_player_lockUnlock_crtl=2;
			};
		};
	};
	
	//--Ремонт сохранение буксировка
	if (_showRepair) then {
#ifdef _ORIGINS
		if(_typeOfCt in OriUpgVeh) then {
			if (s_player_removeUpg < 0) then {
				s_player_removeUpg = player addAction ["<t color='#5882FA'>Снять армирование</t>",SCRIPT_FILE(downgrade_menu.sqf),_Ct, -50, true, true, "", ""];
			};
		};
#endif
		if (GETVAR(_vehicle,Mission,"0")!="1")then{
			if (s_player_forceSave < 0) then {
				s_player_forceSave = player addAction ["<t color='#228B22'>Сохранить технику</t>", "\z\addons\dayz_code\actions\forcesave.sqf",_Ct, 1, true, true, "", ""];
			};
		};

		if (!canmove _ct && (_Ct isKindOf "LandVehicle"))then{
			if (flip_veh_act_id < 0) then {
				flip_veh_act_id = player addaction ["<t color='#5882FA'>Перевернуть автомобиль на колеса</t>",SCRIPT_FILE(flip_veh.sqf),_Ct,-201,true,true,"",""];
			};
		}else{
			player removeAction flip_veh_act_id;
			flip_veh_act_id = -1;
		};
		
		// Add the action to the players scroll wheel menu if the cursor target is a vehicle which can tow.
		if (!_isAir) then {
			if (s_player_towing < 0) then {
				if !(GetTow(_Ct)) then {
					if !(GetInTow(_Ct)) then {
						s_player_towing = player addAction ["<t color='#dddd00'>Буксировать ближайшую технику...</t>",SCRIPT_FILE(tow_AttachTow.sqf), _Ct, -250, false, true, "",""];
					};
				} else {
					s_player_towing = player addAction ["<t color='#dddd00'>Убрать сцепку...</t>",SCRIPT_FILE(tow_DetachTow.sqf), _Ct, -250, false, true, "",""];	
				};
			};
		};
		
		//Разобрать технику на запчасти
		if(!_HaveCharID) then {
			if (s_player_packVeh < 0) then {
				s_player_packVeh = player addaction["<t color='#5882FA'>Разобрать на запчасти</t>",SCRIPT_FILE(bike_pack.sqf),_Ct,-15,false,true,"", ""];
			};
		};
		
		//Repairing Vehicles
		if ((dayz_myCursorTarget != _Ct) && !_isDisallowRepair) then {
			if (s_player_repair_crtl < 0) then {
				dayz_myCursorTarget = _Ct;
				_menu = dayz_myCursorTarget addAction [localize "STR_EPOCH_PLAYER_REPAIRV", SCRIPT_FILE(repair_vehicle.sqf),_Ct, -2, true, false, "",""];
				s_player_repairActions set [count s_player_repairActions,_menu];
				_menu = dayz_myCursorTarget addAction [localize "STR_EPOCH_PLAYER_SALVAGEV", SCRIPT_FILE(salvage_vehicle.sqf),_Ct, -2, true, false, "",""];
				s_player_repairActions set [count s_player_repairActions,_menu];
				s_player_repair_crtl = 1;
			};
		};
		
		//погрузить SeaFox
		if(_typeOfCt in SeaFoxList)then{
			if (s_player_SeaFox < 0) then {
				s_player_SeaFox = player addAction ["<t color='#5882FA'>Погрузить</t>", SCRIPT_FILE(objectAction.sqf),[_Ct,"SeaFox"], -1, true, true, "", ""];
			};
		};

#ifdef _OVERPOCH		
		//Донат скин
		if((typeOf player)in DonateSkins)then{
			if (s_player_DonRepair<0)then{
				s_player_DonRepair=player addaction["<t color='#5882FA'>Починить</t>",SCRIPT_FILE(service_point_repair.sqf),[507,_Ct],-14,false,true,"", ""];
			};
		};
#endif
	};

	//--Курсортаргет для мертвых
	if (!_isAlive) then {
		// Gut animal/zed
		s_event_reset=false;
		if((_isAnimal || _isZombie) && ("ItemKnife" in _itemsPlayer)) then {
			_isHarvested = _Ct getVariable["meatHarvested",false];
			if (!_isHarvested) then {
				if (s_player_butcher < 0) then {
					if(_isZombie) then {
						s_player_butcher = player addAction [localize "STR_EPOCH_ACTIONS_GUTZOM", "\z\addons\dayz_code\actions\gather_zparts.sqf",_Ct, -4, true, true, "", ""];
					} else {
						s_player_butcher = player addAction [localize "str_actions_self_04", "\z\addons\dayz_code\actions\gather_meat.sqf",_Ct, 5, true, true, "", ""];
					};
				};
			} else {
				player removeAction s_player_butcher;
				s_player_butcher = -1;
			};
		};
		
		// Study Body
		if (_isMan && !_isZombie && !_isAnimal) then {
			if (s_player_studybody < 0) then {
				s_player_studybody = player addAction [localize "str_action_studybody", SCRIPT_FILE(study_body.sqf),_Ct, 0, false, true, "",""];
			};
		} else {
			player removeAction s_player_studybody;
			s_player_studybody = -1;
		};

		//Снять одежду
		if (!_isAnimal && !_isZombie && !_isVehicle) then {
			_clothesTaken = _Ct getVariable["clothesTaken",false];
			if !(_clothesTaken) then {
				if (s_player_clothes < 0) then {
					s_player_clothes = player addAction ["<t color='#5882FA'>Снять одежду</t>",SCRIPT_FILE(objectAction.sqf),[_Ct,"takeClothes"], -10, false, true, "",""];
				};
			};
		} else {
			player removeAction s_player_clothes;
			s_player_clothes = -1;
		};
	};
	
	//Проверить наличные
	if((!_isAlive||(_typeOfCt=="GraveDZE"))&&(GetCash(_Ct)>0)&&!_isAnimal)then{
		if(s_can_get_money < 0)then{
			s_can_get_money = player addAction ["<t color='#5882FA'>Проверить наличные</t>",SCRIPT_FILE(check_wallet.sqf),_Ct, -9, false, true, "",""];
		};
	}else{
		player removeAction s_can_get_money;
		s_can_get_money = -1;
	};
	
	//Курсортаргет горит
	if (_isInflamed) then {
		s_event_reset=false;
		_hasRawMeat = false;
		{if(_x in _magazinesPlayer)exitWith{_hasRawMeat=true}} count meatraw; 
		if (_hasRawMeat) then {
			if (s_player_cook < 0) then {
				s_player_cook = player addAction [localize "str_actions_self_05", "\z\addons\dayz_code\actions\cook.sqf",_Ct, 3, true, true, "", ""];
			};
		} else {
			player removeAction s_player_cook;
			s_player_cook = -1;
		};

		// Boil water
		if ("ItemWaterbottle" in _magazinesPlayer) then {
			if (s_player_boil < 0) then {
				s_player_boil = player addAction [localize "str_actions_boilwater",SCRIPT_FILE(boil.sqf),_Ct, 3, true, true, "", ""];
			};
		} else {
			player removeAction s_player_boil;
			s_player_boil = -1;
		};

		//Танцы/кунгфу
		if (s_player_dance < 0) then {
			s_player_dance = player addAction ["<t color='#5882FA'>Отжигать!</t>",SCRIPT_FILE(dance.sqf),"",-10,false,true,"", ""];
			s_player_sport = player addAction ["<t color='#5882FA'>Кунг-фу!</t>",SCRIPT_FILE(kungfu.sqf),"",-10,false,true,"", ""];
		};
	} else {
		player removeAction s_player_dance;
		s_player_dance = -1;
		player removeAction s_player_sport;
		s_player_sport = -1;
	};

	//РУДА
	if(_typeOfCt in CustomVeins) then {
		if (s_player_deleteVeins < 0) then {
			s_event_reset=false;
			s_player_deleteVeins = player addAction [format[localize "str_actions_delete",_displayName], SCRIPT_FILE(remove.sqf),_Ct, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteVeins;
		s_player_deleteVeins = -1;
	};

	//GoldKey Bank
	if(_typeOfCt == "MAP_satelitePhone") then {
		if (s_bank_dialog2 < 0) then {
			s_event_reset=false;
			s_bank_dialog2 = player addAction ["<t color='#5882FA'>GoldKey Bank</t>", SCRIPT_FILE(bank_dialog.sqf),_Ct, 5, true, true, "", ""];
		};
	};

	if(_Ct == dayz_hasFire) then {
		if ((s_player_fireout < 0) && !_isInflamed) then {
			s_event_reset=false;
			s_player_fireout = player addAction [localize "str_actions_self_06", "\z\addons\dayz_code\actions\fire_pack.sqf",_Ct, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_fireout;
		s_player_fireout = -1;
	};

	if((_typeOfCt in DZE_LockableStorage) && _HaveCharID) then {
		if (s_player_unlockvault < 0) then {
			if(_typeOfCt in DZE_LockedStorage) then {
				_combi = player addAction [format[localize "STR_EPOCH_ACTIONS_OPEN",_displayName], "\z\addons\dayz_code\actions\vault_unlock.sqf",_Ct, 5, false, true, "",""];
				s_player_combi set [count s_player_combi,_combi];
				if(_characterID != dayz_combination && !_PlayerIsOwner) then {
					_combi = player addAction [format["Вести код для %1",_displayName], "\z\addons\dayz_code\actions\vault_combination_1.sqf",_Ct, 4, false, true, "",""];
					s_player_combi set [count s_player_combi,_combi];
				};
				s_player_unlockvault = 1;
			}else{
				if(_characterID != dayz_combination && !_PlayerIsOwner) then {
					_combi = player addAction [localize "STR_EPOCH_ACTIONS_RECOMBO", "\z\addons\dayz_code\actions\vault_combination_1.sqf",_Ct, -5, false, true, "",""];
					s_player_combi set [count s_player_combi,_combi];
					s_player_unlockvault = 1;
				};
			};
		};
		if (s_player_safeManagement<0)then{
			s_player_safeManagement = player addAction ["<t color='#5882FA'>Менеджер сейфа</t>",SCRIPT_FILE(openSafeManagement.sqf),_Ct,-20,false];
		};
		s_event_reset=false;
	};

	//Allow owner to pack vault
	if(_typeOfCt in DZE_UnLockedStorage) then {
		s_event_reset=false;
		if (s_bank_dialog < 0) then {
			s_bank_dialog = player addAction ["<t color='#5882FA'>GoldKey Bank</t>",SCRIPT_FILE(bank_dialog.sqf),_Ct, -4, true, true, "", ""];
		};
		if (_HaveCharID) then {
			if (s_player_lockvault < 0) then {
				s_player_lockvault = player addAction [format["<t color='#228B22'>%1</t>",(format[localize "STR_EPOCH_ACTIONS_LOCK",_displayName])], SCRIPT_FILE(vault_lock.sqf),_Ct, 0, false, true, "",""];
			};
		};
		if (s_player_safeManagement<0)then{
			s_player_safeManagement = player addAction ["<t color='#5882FA'>Менеджер сейфа</t>",SCRIPT_FILE(openSafeManagement.sqf),_Ct,-20,false];
		};
		s_event_reset=false;
	};

	//--Курсортаргет _isMan
	if ((_isInternetShop||_isMan) && !_isZombie && !_isAnimal && _isAlive) then {
		// All Traders
		if (!_isPlayer&&((_typeOfCt in serverTraders)||_isInternetShop)) then {
			if (s_player_parts_crtl < 0) then {
				s_event_reset=false;
				if(_isInternetShop)exitWith{
					_status=_Ct getVariable["InternetShop",[0,0,0,0]];
					s_player_parts set [count s_player_parts,player addAction [format["<t color='#FFFA00'>Интернет-магазин GoldKey</t>"],"",[], 0, false, true, "",""]];
					if((_status select 0)==1)then{
						s_player_parts set [count s_player_parts,player addAction ["<t color='#5882FA'>Универсальная торговля оружием</t>", SCRIPT_FILE(advancedTrading.sqf),menu_US_Soldier_AMG_EP1 select 0, -2, true, false,"",""]];					
						s_player_parts set [count s_player_parts,player addAction ["Торговля оружием", SCRIPT_FILE(show_dialog.sqf),menu_US_Soldier_AMG_EP1 select 0, -3, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#86A5FB'>GoldKey Bank</t>", SCRIPT_FILE(bank_dialog.sqf),_Ct, -14, true, true, "", ""]];
					};				
					if((_status select 1)==1)then{
						s_player_parts set [count s_player_parts,player addAction ["<t color='#5882FA'>Универсальная торговля разным</t>", SCRIPT_FILE(advancedTrading.sqf),menu_UN_CDF_Soldier_Guard_EP1 select 0, -4, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["Торговля разным", SCRIPT_FILE(show_dialog.sqf),menu_UN_CDF_Soldier_Guard_EP1 select 0, -5, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#86A5FB'>Показать используемые патроны</t>",SCRIPT_FILE(name_ammo.sqf),"", -10, true, true,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#86A5FB'>Купить патроны</t>",SCRIPT_FILE(buy_ammo.sqf),"", -11, true, true,"",""]];
					};		
					if((_status select 2)==1)then{
						s_player_parts set [count s_player_parts,player addAction ["<t color='#5882FA'>Универсальная торговля медициной</t>", SCRIPT_FILE(advancedTrading.sqf),menu_Doctor select 0, -6, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["Торговля медициной", SCRIPT_FILE(show_dialog.sqf),menu_Doctor select 0, -7, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#86A5FB'>Медицинская помощь</t>",SCRIPT_FILE(player_TraderHeal.sqf),"free", -12, true, true,"", ""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#86A5FB'>Комплексный обед</t>", SCRIPT_FILE(player_TraderFeed.sqf),"free", -13, true, true,"", ""]];
					};		
					if((_status select 3)==1)then{
						s_player_parts set [count s_player_parts,player addAction ["Торговля техникой", SCRIPT_FILE(show_dialog.sqf),menu_RU_Commander select 0, -8, true, false,"",""]];
						s_player_parts set [count s_player_parts,player addAction ["<t color='#5882FA'>Серьезная техника</t>", SCRIPT_FILE(show_dialog.sqf),menu_armor_veh, -9, true, false,"",""]];
					};
					s_player_parts_crtl = 1;
				};
				
				_humanity = player getVariable ["humanity",0];
				_traderMenu = call compile format["menu_%1;",_typeOfCt];
				_humanity_logic=false;
				switch(_traderMenu select 2)do{
					case "hero2":{
						_low_high="40,000";	_humanity_logic=(_humanity < 40000);
						if(!_humanity_logic)then{
							_sell_humanity = player addAction ["<t color='#5882FA'>Продать хуманити</t>", SCRIPT_FILE(sell_humanity.sqf),_Ct, -30, false, true, "",""];
							s_player_parts set [count s_player_parts,_sell_humanity];
						};
					};
					case "hero":{_low_high="10,000";_humanity_logic=(_humanity<10000);};
					case "black":{_low_high="5,000";_humanity_logic=(_humanity < 5000);};
				};

				if(_humanity_logic) then {
					_cancel = player addAction [format["Ваша хуманити слишком низкая. Минимум %1",_low_high], "\z\addons\dayz_code\actions\trade_cancel.sqf",["na"], 0, true, false, "",""];
					s_player_parts set [count s_player_parts,_cancel];
				} else {
					_buyV = player addAction ["<t color='#5882FA'>Универсальная торговля</t>", SCRIPT_FILE(advancedTrading.sqf),(_traderMenu select 0), 999, true, false, "",""];
					s_player_parts set [count s_player_parts,_buyV];
					
					_buy = player addAction [localize "STR_EPOCH_PLAYER_289", SCRIPT_FILE(show_dialog.sqf),(_traderMenu select 0), 998, true, false, "",""];
					s_player_parts set [count s_player_parts,_buy];
					if(_typeOfCt in VehicleTraders)then{
						_buyArmored = player addAction ["<t color='#5882FA'>Серьезная техника</t>", SCRIPT_FILE(show_dialog.sqf),menu_armor_veh, 997, true, false, "",""];
						s_player_parts set [count s_player_parts,_buyArmored];						
					};
				};
				s_player_parts_crtl = 1;
			};
		} else {
			{player removeAction _x} count s_player_parts;s_player_parts = [];
			s_player_parts_crtl = -1;
		};

		
		//Перевод денег
		if (_isPlayer) then {
			if (s_givemoney_dialog < 0) then {
				s_event_reset=false;
				s_givemoney_dialog = player addaction [format["<t color='#5882FA'>Перевод денег для </t>%1",(name _Ct)],SCRIPT_FILE(give_player_dialog.sqf),_Ct, -7,false,true,"",""];
			};
		} else {
			player removeAction s_givemoney_dialog;
			s_givemoney_dialog = -1;
		};
	};

	if ((_typeOfCt in GK_actions) && !_isPlayer && _isAlive && !s_player_GK_actions_ctrl) then {
		//Медицинская помощь
		if(_typeOfCt in Doctors) then {
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Медицинская помощь (200р.)</t>",SCRIPT_FILE(player_TraderHeal.sqf),"", -8, true, true, "", ""]];
		};

		//Комплексный обед
		if(_typeOfCt in FeedTraders) then {
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Комплексный обед (100р.)</t>", SCRIPT_FILE(player_TraderFeed.sqf),"", -8, true, true, "", ""]];
		};
		//донат торговец
		if(_typeOfCt=="Doctor")then{
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Медицинская помощь</t>",SCRIPT_FILE(player_TraderHeal.sqf),"free", -7, true, true, "", ""]];
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Комплексный обед</t>", SCRIPT_FILE(player_TraderFeed.sqf),"free", -8, true, true, "", ""]];
		};

		//Инфо/покупка патронов
		if (_typeOfCt in AmmoTraders) then {
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Показать используемые патроны</t>",SCRIPT_FILE(name_ammo.sqf),"", -20, true, true, "", ""]];
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Купить патроны</t>",SCRIPT_FILE(buy_ammo.sqf),"", -21, true, true, "", ""]];
		};

		//Удалить торговца
		if(_typeOfCt in DelTraders)then{
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Спасибо! До свидания!</t>",SCRIPT_FILE(call_trader_del.sqf),_Ct, -8, true, true, "", ""]];
		};

		//Облегчится
		if(_typeOfCt in isToilet)then{
			s_player_GK_actions set [count s_player_GK_actions,player addAction ["<t color='#5882FA'>Облегчиться</t>",SCRIPT_FILE(shit.sqf),_Ct, -20, true, true, "", ""]];
		};

		 //Player Deaths
		if(_typeOfCt=="Info_Board_EP1")then{
			if (s_player_information<0)then{
				s_event_reset=false;
				s_player_information=player addAction [localize "STR_EPOCH_ACTIONS_MURDERS", "\z\addons\dayz_code\actions\list_playerDeaths.sqf",[], 7, false, true, "",""];
			};
		} else {
			player removeAction s_player_information;
			s_player_information = -1;
		};
		if(count s_player_GK_actions > 0)then{
			s_player_GK_actions_ctrl=true;
			s_event_reset=false;
		};
	};

	//Обслуживание вещей построенное игроком, если игрок добавлен в плот
	if (_hasOwner)then{
		if((_typeOfCt in dayz_allowedObjects) && !(_typeOfCt in DZE_LockableStorage) && !GETVAR(_Ct,InCargo,false))then{
			if ([dayz_playerUID,BUILD_ACCESS,getNearPlots(player,PLOT_RADIUS)] call fnc_checkObjectsAccess)then{
				s_event_reset=false;
				//Улучшение построек
				if ((_Ct isKindOf "ModularItems")||(_Ct isKindOf "Land_DZE_WoodDoor_Base") || (_Ct isKindOf "CinderWallDoor_DZ_Base"))then{
					if (s_player_upgrade_build<0)then{
						s_player_upgrade_build=player addAction [format[localize "STR_EPOCH_ACTIONS_UPGRADE",_displayName], SCRIPT_FILE(player_upgrade.sqf),_Ct,-19,false,true,"",""];
					};
				}else{
					player removeAction s_player_upgrade_build;
					s_player_upgrade_build = -1;
				};

				if(_isTent)then{
				//Упаковать палатку
					if(s_player_packtent<0)then{
						s_player_packtent=player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\tent_pack.sqf",_Ct,-22,false,true,"",""];
					};
				}else{
					//Разобрать постройки
					if(s_player_deleteBuild<0)then{
						s_player_deleteBuild=player addAction [format[localize "str_actions_delete",_displayName],SCRIPT_FILE(remove.sqf),_Ct,-20,false,true,"",""];
					};
				};

				//Снять замок + Панель доступа
				if(_Ct isKindOf "Land_DZE_WoodDoorLocked_Base" || _Ct isKindOf "CinderWallDoorLocked_DZ_Base") then {
					if(s_player_downgrade_build<0)then{
						s_player_downgrade_build=player addAction [format[localize "STR_EPOCH_ACTIONS_REMLOCK",_text], SCRIPT_FILE(player_buildingDowngrade.sqf),_Ct, -21, false, true, "",""];
						s_player_manageDoor = player addAction ["<t color='#5882FA'>Панель доступа</t>",SCRIPT_FILE(initDoorManagement.sqf), _Ct, -100, false];
					};
				}else{
					player removeAction s_player_downgrade_build;s_player_downgrade_build = -1;
					player removeAction s_player_manageDoor;s_player_manageDoor = -1;
				};	
				if(s_player_move_build<0)then{
						s_player_move_build = player addAction [format["<t color='#5882FA'>Передвинуть </t>%1",_displayName], SCRIPT_FILE(buildAction.sqf),_Ct, -22, false, true, "", ""];
				};					
				if(_isTent || _isnewstorage)then{_objCommentCtrl=true};
			};	
		};
		
		//Спать в палатке
		if(_isTent||(_typeOfCt in DZE_Beds)) then {
			if (s_player_sleep < 0) then {
				s_event_reset=false;
				s_player_sleep = player addAction ["<t color='#5882FA'>Поспать</t>", SCRIPT_FILE(player_sleep.sqf),_Ct, 0,false,true,"",""];
			};
		};
	};
	//Плот менеджер
	if (_typeOfCt == "Plastic_Pole_EP1_DZ") then {
		if (s_player_plotManagement<0)then{
			s_event_reset=false;
			s_player_plotManagement = player addAction ["<t color='#5882FA'>Плот менеджер</t>",SCRIPT_FILE(initPlotManagement.sqf),_Ct,30,false];
		};
	}else{
		player removeAction s_player_plotManagement;
		s_player_plotManagement = -1;
	};

	if(_objCommentCtrl)then{
		if (s_obj_comment<0)then{
			s_event_reset=false;
			s_obj_comment=player addAction ["<t color='#5882FA'>Задать описание</t>",SCRIPT_FILE(objComment.sqf),_Ct,-23,true,true,"",""];
		};
	};

	//Start Generator
	if(_isPowerStation)then{
		if(_typeOfCt=="Generator_DZ") then {
			if (s_player_fillgen < 0) then {
				s_event_reset=false;
				// check if not running 
				if((_Ct getVariable ["GeneratorRunning", false])) then {
					s_player_fillgen = player addAction [localize "STR_EPOCH_ACTIONS_GENERATOR1", "\z\addons\dayz_code\actions\stopGenerator.sqf",_Ct, 0, false, true, "",""];
				} else {
				// check if not filled && player has jerry.
					if((_Ct getVariable ["GeneratorFilled", false])) then {
						s_player_fillgen = player addAction [localize "STR_EPOCH_ACTIONS_GENERATOR2", "\z\addons\dayz_code\actions\fill_startGenerator.sqf",_Ct, 0, false, true, "",""];
					} else {
						if("ItemJerrycan" in _magazinesPlayer) then {
							s_player_fillgen = player addAction [localize "STR_EPOCH_ACTIONS_GENERATOR3", "\z\addons\dayz_code\actions\fill_startGenerator.sqf",_Ct, 0, false, true, "",""];
						};
					};
				};
			};
		} else {
			player removeAction s_player_fillgen;
			s_player_fillgen = -1;
		};

		if(_typeOfCt=="MAP_PowerGenerator") then {
			if (s_power_onoff<0) then {
				s_event_reset=false;
				if (_Ct getVariable ["GeneratorRunning", false]) then {
					s_power_onoff=player addAction [localize "STR_EPOCH_ACTIONS_GENERATOR1",SCRIPT_FILE(powergen.sqf),[_Ct,0], 0, false, true, "",""];
				}else{
					s_power_onoff=player addAction [localize "STR_EPOCH_ACTIONS_GENERATOR2",SCRIPT_FILE(powergen.sqf),[_Ct,1], 0, false, true, "",""];
				};
			};
		}else{
			player removeAction s_power_onoff;
			s_power_onoff=-1;
		};
	};

	//Разобрать велосипед
	if(_isBike) then {
		if (s_player_packItem < 0) then {
			s_event_reset=false;
			s_player_packItem = player addaction["<t color='#5882FA'>Разобрать на запчасти</t>",SCRIPT_FILE(bike_pack.sqf),_Ct,-15,false,true,"", ""];
		};
	} else {
		player removeAction s_player_packItem;
		s_player_packItem = -1;
	};	

	//Удалить технику
	if ((_typeOfCt in TrashVeh) && !(_lockedCt)) then {
		if (s_player_delTrashVeh < 0) then {
			s_event_reset=false;
			s_player_delTrashVeh = player addAction ["<t color='#5882FA'>Удалить технику</t>",SCRIPT_FILE(delete_veh.sqf),_Ct, -20, true, true, "", ""];
		};
	} else {
		player removeAction s_player_delTrashVeh;
		s_player_delTrashVeh = -1;
	};

	//Проверить груз
	if((_isVehicle || _isTent || _isnewstorage) && _isAlive && !_isMan && !_lockedCt && !_isBike) then {
		if (s_player_checkGear < 0) then {
			s_event_reset=false;
			s_player_checkGear=player addAction [localize "STR_EPOCH_PLAYER_CARGO", SCRIPT_FILE(cargocheck.sqf),_Ct, -1, true, true, "", ""];
		};

		//Выбрать для торговли
		if(dayz_playerUID in PremiumList_trade)then{
			_can_SelectForTrade=false;
			if (_isVehicle)then{
				if(_hasKey || !_HaveCharID)then{
					_can_SelectForTrade = true;
				};
			}else{
				_can_SelectForTrade = _typeOfCt!="VaultStorage";
			};
			if(_can_SelectForTrade)then{
				if (s_player_select_veh < 0) then {
					s_player_select_veh = player addAction ["<t color='#5882FA'>Выбрать для торговли</t>", SCRIPT_FILE(select_vehicle.sqf),_Ct, -999, true, true, "", ""];
				};
			};
		};
	} else {
		player removeAction s_player_checkGear;s_player_checkGear = -1;
		player removeAction s_player_select_veh;s_player_select_veh = -1;
	};

	//Allow player to fill jerrycan
	if(("ItemJerrycanEmpty" in _magazinesPlayer)||("ItemFuelBarrelEmpty" in _magazinesPlayer)) then {
		if (s_player_fillfuel < 0)then{
			_isFuel = false;
			{if(_Ct isKindOf _x)exitWith{_isFuel=true}} count dayz_fuelsources;
			if (_isFuel)then{
				s_event_reset=false;
				s_player_fillfuel = player addAction [localize "str_actions_self_10", "\z\addons\dayz_code\actions\jerry_fill.sqf",[], -4, false, true, "", ""];
			};
		};
	} else {
		player removeAction s_player_fillfuel;
		s_player_fillfuel = -1;
	};

	//Fuel Pump
	if(_isFuelPump) then {
		if (s_player_fuelauto < 0) then {
			s_event_reset=false;
			// check if Generator is running
			_findNearestGen = [_Ct,1] call fnc_getNearPowers;
			_IsNearRunningGen = count (_findNearestGen);
			if (_typeOfCt == "FuelPump_DZ")then{
				_IsNearFuel = count (nearestObjects [_Ct,dayz_fuelsources,FUEL_RANGE]);
			}else{
				_IsNearFuel=1;
			};

			// show that pump needs power if no generator nearby.
			if(_IsNearRunningGen > 0 && _IsNearFuel > 0) then {
				s_player_fuelauto = player addAction [localize "STR_EPOCH_ACTIONS_FILLVEH", SCRIPT_FILE(objectAction.sqf),[_Ct,"fillnearfuel"], -4, false, true, "",""];
			} else {
				if (_IsNearFuel==0)then{
					s_player_fuelauto = player addAction [format["<t color='#ff0000'>Требуется источник топлива в радиусе %1 метров.</t>",FUEL_RANGE], "",[], -4, false, true, "",""];
				}else{
					s_player_fuelauto = player addAction [format["<t color='#ff0000'>%1</t>",localize "STR_EPOCH_ACTIONS_NEEDPOWER"], "",[], -4, false, true, "",""];
				};
			};
		};
	} else {
		player removeAction s_player_fuelauto;s_player_fuelauto=-1;
	};

	// Garage		
	if(_typeOfCt in DZE_Garage && _hasOwner) then {
		switch(true)do{
			case (GETVAR(_Ct,parking,false)):{_gMenu="Открыть общественный гараж";};
			case ((GetObjID(_Ct))=="10014"):{_gMenu="Штрафстоянка";};
			default {_gMenu="Открыть гараж";};
		};
		if (s_garage_dialog < 0) then {
			s_event_reset=false;
			s_garage_dialog = player addAction ["<t color='#5882FA'>"+_gMenu+"</t>", SCRIPT_FILE(garageAction.sqf),[_Ct,"store"], 180, true, true, "", ""];
		};
	};

} else {
	if (!s_event_reset)then{
		[] call _resetAllEvents;
	};
	s_player_lastTarget = objNull;
	dayz_myCursorTarget = objNull;
};
