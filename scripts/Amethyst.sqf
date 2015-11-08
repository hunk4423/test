disableSerialization;
{ctrlShow [_x,false];} forEach [1105,4903,4904,4905,4906,4907,4908,4909];
_comboBox = 3900; 
ctrlSetText [1001,"Amethyst"];
GlobalCraftingVariable = 1;
GlobalComboboxVariable = 99;
ComboBoxResult="";


{_index = lbAdd [_comboBox, _x]; } 
forEach [
"Билборды",
"Доски",
"Знаки",
"Дорожные знаки",
"Дорожные знаки2", 
"Дорожные знаки3"
]; 

while {GlobalCraftingVariable==1} do {

switch(GlobalComboboxVariable) do
{
case 0:
{
ComboBoxResult="Billboards";
call fnc_Load_Items;
};
case 1:
{
ComboBoxResult="Boards";
call fnc_Load_Items;
};
case 2:
{
ComboBoxResult="Informational";
call fnc_Load_Items;
};
case 3:
{
ComboBoxResult="RoadsMisc";
call fnc_Load_Items;
};
case 4:
{
ComboBoxResult="SignsMisc";
call fnc_Load_Items;
};
case 5:
{
ComboBoxResult="TrafficSigns";
call fnc_Load_Items;
};

default { };
};

};

closeDialog 0;