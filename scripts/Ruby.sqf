disableSerialization;
{ctrlShow [_x,false];} forEach [1105,4903,4904,4905,4906,4907,4908,4909];
_comboBox = 3900; 
ctrlSetText [1001,"Ruby"];
GlobalCraftingVariable = 1;
GlobalComboboxVariable = 99;
ComboBoxResult="";

{_index = lbAdd [_comboBox, _x]; } 
forEach [
"Кровати",
"Скамейки",
"Шкафы",
"Стулья",
"Столы",
"Лампочки",
"Фонарные столбы",
"Свет. Разное"
]; 

while {GlobalCraftingVariable==1} do {

switch(GlobalComboboxVariable) do
{
case 0:
{
ComboBoxResult="Beds";
call fnc_Load_Items;
};
case 1:
{
ComboBoxResult="Benches";
call fnc_Load_Items;
};
case 2:
{
ComboBoxResult="Cabinets";
call fnc_Load_Items;
};
case 3:
{
ComboBoxResult="Chairs";
call fnc_Load_Items;
};
case 4:
{
ComboBoxResult="Desks";
call fnc_Load_Items;
};
case 5:
{
ComboBoxResult="Lightbulbs";
call fnc_Load_Items;
};
case 6:
{
ComboBoxResult="LightPoles";
call fnc_Load_Items;
};
case 7:
{
ComboBoxResult="Fixtures";
call fnc_Load_Items;
};


default { };
};

};

closeDialog 0;