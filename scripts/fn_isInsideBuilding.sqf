#include "defines.h"
private["_unit","_building","_relPos","_boundingBox","_min","_max","_myX","_myY","_myZ","_inside"];
_unit=THIS0;
_building=nearestObject [_unit,"HouseBase"];
_relPos=_building worldToModel (getPosATL _unit);
_boundingBox=boundingBox _building;
EXPLODE2(_boundingBox,_min,_max);
EXPLODE3(_relPos,_myX,_myY,_myZ);

_inside=false;
if ((_myX>SEL0(_min))&&(_myX<SEL0(_max)))then{
	if ((_myY>SEL1(_min))&&(_myY<SEL1(_max)))then{
		if ((_myZ>SEL2(_min))&&(_myZ<SEL2(_max)))then{
			_inside=true;
		};
	};
};
_inside