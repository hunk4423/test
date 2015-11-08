/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#include "defines.h"

build_checkNoBuldZone={
	PVT5(_location,_size,_marker,_done,_rc);
	PARAMS1(_location);
	_rc=[true,"Ok"];
	_done=true;
	{
		if (CNT(_x)>5)then{
			_size=_x select 7;
			if (CNT(_size)>2)then{
				_marker=_x;
				_size=SEL2(_size);
				if ([_location,SEL1(_x),SEL5(_x),SEL6(_x),_size] call fnc_posInArea)exitWith{
					_rc=[false,format ["Стройка запрещена. Слишком близко %1. Минимум %2м.",SEL2(_marker),SEL0(_size)]];
					_done=false;
				};
			};
		};
		if (!_done)exitWith{};
	}count StaticMarkers;
	_rc
};

build_checkCanBuild={
	private ["_rc","_msg","_done","_type","_location","_okshow","_plots","_requireplot"];
	PARAMS3(_type,_location,_okshow);
	_done=true;
	call {
		if (CurrAdminLevel>0)exitWith{};
		_rc=[_location] call build_checkNoBuldZone;
		EXPLODE2(_rc,_done,_msg);
		if (!_done)exitWith{};
		if(_type=="Plastic_Pole_EP1_DZ" || _type=="30m_plot_kit")exitWith{
			// Здания
			if({{(_x getVariable ["ownerPUID","0"])=="0"}count (_location nearObjects [_x, PLOT_MIN_DIST])>0}count forbidenBuildings >0)exitWith{
				_msg="Стройка запрещена. Нельзя застраивать казармы, стройки, больницы, замки!";
				_done=false;
			};
			_plots=getNearPlots(_location,PLOT_MIN_DIST);
			if (CNT(_plots)>0)then{
				if !([dayz_playerUID,PLOT_FULL_ACCESS,_plots] call fnc_checkObjectsAccess)exitWith{
					_msg=format["Вы не имеете прав ставить плот рядом с чужим плотом!\nНеобходимо отойти на %1 метров от чужого плота или\nиметь полный доступ к чужому плоту.",PLOT_MIN_DIST];
					_done=false;
				};
			};
			if (_done&&_okshow)then{
				[
					"<t size='0.70' color='#EE0000' align='right'>ВНИМАНИЕ!<br /></t><t size='0.50' color='#7EC0EE' align='right'>ЗАПРЕЩЕНО занимать здание ОДНОМУ игроку!<br />Занимая здание, прочтите правила и посоветуйтесь с администрацией, можно ли здесь строить.<br />",
					[safezoneX+safezoneW-0.8,0.50],[safezoneY+safezoneH-0.8,0.7],15,0.5
				] spawn BIS_fnc_dynamicText;
				systemChat "Стройка разрешена.";
			};
		};
		if (_type=="Land_Fire_DZ")exitWith{
			if (player getVariable["inSafeZone",false])then{_msg="Нельзя создать костер в зоне рынка!";_done=false};
		};

		_plots=getNearPlots(_location,PLOT_RADIUS);
		if (CNT(_plots)>0)then{
			if !([dayz_playerUID,BUILD_ACCESS,_plots] call fnc_checkObjectsAccess)then{
				_msg="Вы не имеете прав строить в зоне чужого плота!\nТребуются права 'Стройка' или 'Полные права'";
				_done=false;
			};
		}else{
			_requireplot=DZE_requireplot;
			if(isNumber (configFile >> "CfgVehicles" >> _type >> "requireplot")) then {_requireplot=getNumber(configFile >> "CfgVehicles" >> _type >> "requireplot")};
			if (_type=="FuelPump_DZ")then{_requireplot=DZE_requireplot};
			if (_requireplot>0)then{_msg=format[(localize "STR_EPOCH_PLAYER_135"),"Плот",PLOT_RADIUS];_done=false};
		};
		
		if(surfaceIsWater _location)then{_location=ATLToASL _location};
		if((_location select 2)>40)then{_msg="Запрещена постройка сооружений выше 40 метров.";_done=false};
	};
	if (!_done)then{
		taskHint ['!!! ВНИМАНИЕ !!!',[1,0,0.1,1],'taskFailed'];
		cutText [_msg,"PLAIN DOWN"];
		systemChat "Отойдите на разрешённое расстояние и попробуйте еще раз.";
	};
	_done
};

build_setPitchBankYaw={
	private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY","_dirZ","_upX","_upY","_upZ","_dirXTemp","_upXTemp","_rc","_cos","_sin"];
	PARAMS2(_object,_rotations);
	EXPLODE2(_rotations,_aroundX,_aroundY);
	_aroundZ=(360-(SEL2(_rotations)))-360;
	_dirX=0;_dirY=1;_dirZ=0;
	_upX=0;_upY=0;_upZ=1;
	if (_aroundX!=0)then{
		_dirY=cos _aroundX;_dirZ=sin _aroundX;
		_upY=-_dirZ;_upZ=_dirY;
	}; 
	if (_aroundY!=0)then{
		_cos=cos _aroundY;_sin=sin _aroundY;
		_dirX=_dirZ*_sin;_dirZ=_dirZ*_cos;
		_upX=_upZ*_sin;_upZ=_upZ*_cos;
	};
	if (_aroundZ!=0)then{
		_cos=cos _aroundZ;_sin=sin _aroundZ;
		_dirXTemp=_dirX;
		_dirX=(_dirXTemp*_cos)-(_dirY*_sin);
		_dirY=(_dirY *_cos)+(_dirXTemp*_sin);
		_upXTemp=_upX;
		_upX=(_upXTemp*_cos)-(_upY*_sin);
		_upY=(_upY*_cos)+(_upXTemp*_sin);
	};
	_rc=[[_dirX,_dirY,_dirZ],[_upX,_upY,_upZ]];
	_object setVectorDirAndUp _rc;
	_rc
};

build_checkRequreItems={
	PVT3(_done,_missing,_items);
	_items=weapons player;
	_done=true;
	{
		if !(_x in _items)exitWith{
			_missing=getText (configFile >> "cfgWeapons" >> _x >> "displayName");
			cutText [format[localize "str_epoch_player_137",_missing],"PLAIN DOWN"];_done=false;
		};
	} count _this;
	_done
};