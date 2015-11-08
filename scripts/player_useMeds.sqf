/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

private ["_item","_id","_onLadder","_hasmeditem","_config","_text"];
_item = _this;
call gear_ui_init;
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

_hasmeditem = _this in magazines player;

_config = configFile >> "CfgMagazines" >> _item;
_text = getText (_config >> "displayName");

if (!_hasmeditem) exitWith {cutText [format[(localize "str_player_31"),_text,"use"] , "PLAIN DOWN"]};

switch (_item) do {
	case "ItemBandage": {
		_id = [0,0,0,[player]] EXECVM_SCRIPT(bandage.sqf);
	};
	case "ItemMorphine": {
		_id = [0,0,0,[player]] EXECVM_SCRIPT(morphine.sqf);
	};
	case "ItemPainkiller": {
		_id = [0,0,0,[player]] EXECVM_SCRIPT(painkiller.sqf);
	};
	case "ItemAntibiotic": {
		_id = [0,0,0,[player]] EXECVM_SCRIPT(antibiotics.sqf);
	};
	case "ItemBloodbag": {
		_id = [0,0,0,[player]] EXECVM_SCRIPT(player_selfbloodbag.sqf);
	};
	case "ItemHeatPack": {
		_num_removed = ([player,"ItemHeatPack"] call BIS_fnc_invRemove);
		if!(_num_removed == 1) exitWith {cutText ["Ошибка", "PLAIN DOWN"]};
		dayz_temperatur = (dayz_temperatur + 5) min dayz_temperaturmax;
		cutText [localize "str_player_27", "PLAIN DOWN"];
	};
};
