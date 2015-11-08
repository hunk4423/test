private ["_txt","_coins","_vehicle"];
VehicleToPaint = _this select 3;
ColourPrice = 30000;
_vehicle = getText(configFile >> "cfgVehicles" >> (typeOf VehicleToPaint) >> "displayName");
createdialog "VehicleColourDialog";
_txt = format ["<t>Цена покраски:<br/>30,000 рублей</t>"];
((uiNamespace getVariable "VehicleColourDialog") displayCtrl 5703) ctrlSetStructuredText parseText _txt;

_txt1 = format ["<t>Стандартный цвет:<br/>10,000 рублей</t>"];
((uiNamespace getVariable "VehicleColourDialog") displayCtrl 5705) ctrlSetStructuredText parseText _txt1;

