/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
closeDialog 1;
sleep 0.5;

private ["_textBoxxSaveLine"];
_textBoxxSaveLine = " ";
TextBoxxTitle = "Добро пожаловать на PVE сервер GoldKey!";

textBoxx_TEXT_LIST = [
"",
"",
"",
"",
"          На сервере приветствуются взаимовыручка",
"               и уважение к другим игрокам!",      
"              Работает гибкая система доната.",
"",
"",
"                   На сервере запрещено:",  
"",
"                     убийство игроков,",
"         уничтожение и кража чужой собственности,",
"             использование ненормативной лексики.",
"",
"                           * * *", 
"",                
"          Для ознакомления с полным списком правил ",
"        и возможностями сервера вступайте в группу.",
"",   
"     А также можете ознакомится со всем списком правил",
"                      нажав кнопку F7.",
"",
"",
"",
"",
"",
"Группа ВКонтакте: https://vk.com/goldkey_dz",
"Адрес сервера TeamSpeak3: ts3.goldkey-games.ru",
"Администрация GoldKey."

];
textBoxx_TEXT_LIST set [(count textBoxx_TEXT_LIST),_textBoxxSaveLine];
createDialog "DisplaytextBoxx50";