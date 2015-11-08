for "_x" from 3 to 1 step -1 do {
	(findDisplay 106) closeDisplay 1;
	uiSleep 1;

	if (isNil "EscBlock") then {
		systemchat "<Анти-дюп>: Снаряжение заблокировано на 5 секунд.";
		EscBlock = true;
		EscBlock = true;
	};
};
EscBlock = nil;