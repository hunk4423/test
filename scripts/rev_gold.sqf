 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //


private ["_num_removed","_isNear"];

if (r_player_unconscious) exitWith {titleText ["Действие отменено.", "PLAIN DOWN", 0.5];};
_isNear = {inflamed _x} count (getPosATL player nearObjects 3);
if(_isNear == 0) exitWith  {cutText [format["Нужен огонь в пределах 3-х метров."], "PLAIN DOWN"]};

if (vehicle player != player) exitWith {cutText [format["Нельзя крафтить в технике!"], "PLAIN DOWN"]};
if (dayz_combat == 1) exitwith { cutText [format["В бою нельзя крафтить!"], "PLAIN DOWN"]};

if !("revolver_gold_EP1" in weapons player) exitWith {cutText [format["Нужен золотой револьвер"], "PLAIN DOWN"]};
if !("ItemToolbox" in weapons player) exitWith {cutText [format["Нужны инструменты"], "PLAIN DOWN"]};
if !("ItemCrowbar" in weapons player) exitWith {cutText [format["Нужен ломик"], "PLAIN DOWN"]};
if !("TrashTinCan" in magazines player) exitWith {cutText [format["Нужна консервная банка"], "PLAIN DOWN"]};

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_63") , "PLAIN DOWN"]; };
DZE_ActionInProgress = true;

		_num_removed = ([player,"revolver_gold_EP1"] call BIS_fnc_invRemove);
		if!(_num_removed == 1) exitWith {cutText ["Ошибка", "PLAIN DOWN"];DZE_ActionInProgress = false;};
		player playActionNow "Medic";
		[player,"repair",0,false,10] call dayz_zombieSpeak;
	    [player,10,true,(getPosATL player)] spawn player_alertZombies;
		sleep 7;
		player addmagazine "ItemGoldBar5oz";
		titleText ["Переплавил Револьвер... эх жалко...","PLAIN DOWN"];
		
DZE_ActionInProgress = false;

 //               F507DMT //***// GoldKey 					//
//http://goldkey-games.ru/  //***// https://vk.com/goldkey_dz //
