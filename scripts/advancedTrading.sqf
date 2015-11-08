/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_dialog"];

disableSerialization;
if(hasGutsOnHim)exitWith{cutText ["Ну и запах! Я не хочу иметь с тобой никаких дел!", "PLAIN DOWN"];};
if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_103") , "PLAIN DOWN"];};

Z_traderData = (_this select 3); // gets the trader data ( menu_Functionary1 )
Z_Selling = true;
Z_SellingFrom = 2;
Z_SellableArray = [];
Z_SellArray = [];
Z_BuyArray = [];
Z_BuyingArray = [];

if( isNil "Z_traderData" || count (Z_traderData) == 0)exitWith{
	cutText ["Что-то пошло не так.", "PLAIN DOWN"];
};

createDialog "AdvancedTrading";

_dialog = findDisplay 711197;
(_dialog displayCtrl 7432) ctrlSetText " < ";
(_dialog displayCtrl 7433) ctrlSetText " << ";
(_dialog displayCtrl 7442) ctrlSetText " < ";
(_dialog displayCtrl 7443) ctrlSetText " << ";
{ctrlShow [_x,false];} forEach [7441,7436,7404,7422,7421,7436,7440,7442,7443,7404]; // hide	- double hide ( first one didn't work it seems.
call Z_getGearItems;
buyRifle = nil;
buyPistol = nil;
buyBackpack = nil;
bpBuyArray = nil;