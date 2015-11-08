private ["_dialog"];
targivemonet = 	_this select 3;
_dialog = createdialog "GivePlayerDialog";
call GivePlayerDialogAmounts;
waitUntil { !dialog };