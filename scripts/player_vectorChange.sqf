private ["_type","_typename"];
_type = _this select 3;
if (typeName _type=="SCALAR")then{
	DZE_curPitch = _type;
};
if (typeName _type == "STRING")exitWith{
	switch(_type) do{
	case "reset":{DZE_memForBack = 0;DZE_memLeftRight = 0;DZE_updateVec = true;};
	case "forward":{DZE_updateVec = true;DZE_memForBack = DZE_memForBack + (DZE_curPitch * -1);};
	case "back":{DZE_updateVec = true;DZE_memForBack = DZE_memForBack + DZE_curPitch;};
	case "left":{DZE_updateVec = true;DZE_memLeftRight = DZE_memLeftRight + (DZE_curPitch * -1);};
	case "right":{DZE_updateVec = true;DZE_memLeftRight = DZE_memLeftRight + DZE_curPitch;};
	case "nord":{DZE_memDir=-DZE_curPitch;DZE_RR=true};
	case "loading":{DZE_Loading=true};
	};
};