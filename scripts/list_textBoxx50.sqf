/*
textBoxx by piggd
Email: dayzpiggd@gmail.com
Website: http://dayzpiggd.enjin.com
Donations Accepted via paypal to danpigg@yahoo.com
*/
#include "definitions.hpp"
disableSerialization;
_TextBoxxTitle = TextBoxxTitle;

_display = findDisplay TEXTBOXX50_DIALOG ;
_unitlist = _display displayCtrl TEXTBOXX50_UNITLIST;
_titlelist = _display displayCtrl TEXTBOXX50_TITLE;
_titlelist ctrlSetText format["%1",_TextBoxxTitle];

_textliststring = "";
{
	_textliststring = format["%1",_x];
	_unitlist lbAdd _textliststring;
} foreach textBoxx_TEXT_LIST;