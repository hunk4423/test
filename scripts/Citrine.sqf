disableSerialization;
{ctrlShow [_x,false];} forEach [1105,4903,4904,4905,4906,4907,4908,4909];
_comboBox = 3900; 
ctrlSetText [1001,"Citrine"];
GlobalCraftingVariable = 1;
GlobalComboboxVariable = 99;
ComboBoxResult="";


{_index = lbAdd [_comboBox, _x]; } 
forEach [
"Окна",
"Бытовые приборы",
"Ванная",
"Магазин",
"Ковры",
"Интерьер"

]; 

while {GlobalCraftingVariable==1} do {

switch(GlobalComboboxVariable) do
{
case 0:
{
ComboBoxResult="Windows";
call fnc_Load_Items;
};
case 1:
{
ComboBoxResult="Appliances";
call fnc_Load_Items;
};
case 2:
{
ComboBoxResult="Bathroom";
call fnc_Load_Items;
};
case 3:
{
ComboBoxResult="Commercial";
call fnc_Load_Items;
};
case 4:
{
ComboBoxResult="FloorCoverings";
call fnc_Load_Items;
};
case 5:
{
ComboBoxResult="MiscInterior";
call fnc_Load_Items;
};


default { };
};

};

 closeDialog 0;