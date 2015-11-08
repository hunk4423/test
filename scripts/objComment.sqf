/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"
private ["_object"];
player removeAction s_obj_comment;s_obj_comment=-1;
_object=THIS3;
if (isNull _object)exitWith{cutText ["Объект не найден!","PLAIN DOWN"]};
[_object] call object_CommentDlg;