//Zero Remorse, big thanks to their scripter for this!
private ["_speed","_density","_model","_thePlot","_center","_radius","_angle","_count","_axis","_obj","_idx","_a","_b","_mng","_ctrl"];
_speed = 4;			// multiplier for speed of sphere rotation/wobble
_density = 3;		// density of markers per ring
_model = "Sign_sphere100cm_EP1";	// marker model to use on rings
// Possible ones to use ::	Sign_sphere10cm_EP1  Sign_sphere25cm_EP1  Sign_sphere100cm_EP1 
_thePlot = (nearestObjects [player, ["Plastic_Pole_EP1_DZ"],15]) select 0;
_center = getPosASL _thePlot;_radius = DZE_PlotPole select 0;
_obj = false;	_tmp = -1;
disableSerialization;
_mng = uiNamespace getVariable ["AccessManagement",ObjNull];
if (!isNull _mng)then{_ctrl=_mng displayCtrl 7011}else{_ctrl=ObjNull};

if (!isNil "PP_Marks") then {
	if (((PP_Marks select 0) distance _thePlot) < 10) then {  _obj = true; };
	_tmp = (PP_Marks select 0) distance _thePlot;
	{ deleteVehicle _x; } count PP_Marks;	PP_Marks = nil;
	_a="Отображение зоны плота - Выключено";
	if (isNull _ctrl)then{systemchat _a}else{_ctrl ctrlSetText _a};
};
if ((isNil "PP_Marks") && (!_obj)) then {
	PP_Marks = [];_count = round((2 * pi * _radius) / _density);
	_obj = "Sign_sphere10cm_EP1" createVehicleLocal [0,0,0];	//	PARENT marker on pole
	_obj setPosASL [_center select 0, _center select 1, _center select 2];
	_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];	_axis = _obj;
	_obj setVectorUp [0, 0, 0];		PP_Marks set [count PP_Marks, _obj];
	_angle = 0;	
	for "_idx" from 0 to _count do	{
		_a = (_center select 0) + (sin(_angle)*_radius);
		_b = (_center select 1) + (cos(_angle)*_radius);
		_obj = _model createVehicleLocal [0,0,0];
		_obj setPosASL [_a, _b, _center select 2];
		_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];
		_obj attachTo [_axis];			PP_Marks set [count PP_Marks, _obj];
		_a = (_center select 0) + (sin(_angle)*_radius);
		_b = (_center select 2) + (cos(_angle)*_radius);
		_obj = _model createVehicleLocal [0,0,0];
		_obj setPosASL [_a, _center select 1, _b];
		_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];
		_obj attachTo [_axis];			PP_Marks set [count PP_Marks, _obj];
		_angle = _angle + (360/_count);
	};
	_angle = (360/_count);
	for "_idx" from 0 to (_count - 2) do	{
		_a = (_center select 1) + (sin(_angle)*_radius);
		_b = (_center select 2) + (cos(_angle)*_radius);
		_obj = _model createVehicleLocal [0,0,0];
		_obj setPosASL [_center select 0, _a, _b];
		_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];
		_obj attachTo [_axis];			PP_Marks set [count PP_Marks, _obj];
		_angle = _angle + (360/_count);
	};
	_angle = (360/_count);		_axis setDir 45;
	for "_idx" from 0 to (_count - 2) do	{
		_a = (_center select 0) + (sin(_angle)*_radius);
		_b = (_center select 2) + (cos(_angle)*_radius);
		_obj = _model createVehicleLocal [0,0,0];
		_obj setPosASL [_a, _center select 1, _b];
		_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];
		_obj attachTo [_axis];			PP_Marks set [count PP_Marks, _obj];

		_a = (_center select 1) + (sin(_angle)*_radius);
		_b = (_center select 2) + (cos(_angle)*_radius);
		_obj = _model createVehicleLocal [0,0,0];
		_obj setPosASL [_center select 0, _a, _b];
		_obj setObjectTexture [0, "#(argb,16,16,1)color(0,1,0,0.4)"];
		_obj attachTo [_axis];			PP_Marks set [count PP_Marks, _obj];
		_angle = _angle + (360/_count);
	};
	_a="Отображение зоны плота - Включено";
	if (isNull _ctrl)then{systemchat _a}else{_ctrl ctrlSetText _a};
};