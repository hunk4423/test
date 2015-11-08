/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
private ["_earth","_vx","_vy","_vz","_coef","_this","_ShakeMe"];


_earth = {
//playsound "eq";
for "_i" from 0 to 140 do {
_vx = vectorup _this select 0;
_vy = vectorup _this select 1;
_vz = vectorup _this select 2;
_coef = 0.01 - (0.0001 * _i);
_this setvectorup [
_vx+(-_coef+random (3*_coef)),
_vy+(-_coef+random (3*_coef)),
_vz+(-_coef+random (3*_coef))
];
uiSleep (0.01 + random 0.01);
};

};
_ShakeMe = 5;
while {_ShakeMe > 0} do {
player spawn _earth;
uiSleep 3;
_ShakeMe = _ShakeMe - 1;
};
