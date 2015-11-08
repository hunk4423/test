class RscTxtT
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0.8784,0.8471,0.651,1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0;
	shadow = 2;
	font = "Zeppelin32";
	SizeEx = 0.03921;
};

class RscButton_Spawn
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {0.8784,0.8471,0.651,1};
	colorDisabled[] = {0.4,0.4,0.4,1};
	colorBackground[] = {1,1,1,0.4};
	colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
	colorBackgroundActive[] = {1,1,1,0.8};
	colorFocused[] = {1,1,1,0.9};
	colorShadow[] = {0.023529,0,0.0313725,1};
	colorBorder[] = {0.023529,0,0.0313725,1};
	soundEnter[] = {"\ca\ui\data\sound\onover",0.09,1};
	soundPush[] = {"\ca\ui\data\sound\new1",0,0};
	soundClick[] = {"\ca\ui\data\sound\onclick",0.07,1};
	soundEscape[] = {"\ca\ui\data\sound\onescape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "Zeppelin32";
	sizeEx = 0.03;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};

class E_RscButton_Spawn
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {0.8784,0.8471,0.651,1};
	colorDisabled[] = {0.4,0.4,0.4,1};
	colorBackground[] = {1,0.537,0,0.5};
	colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
	colorBackgroundActive[] = {1,0.537,0,1};
	colorFocused[] = {1,0.537,0,1};
	colorShadow[] = {0.023529,0,0.0313725,1};
	colorBorder[] = {0.023529,0,0.0313725,1};
	soundEnter[] = {"\ca\ui\data\sound\onover",0.09,1};
	soundPush[] = {"\ca\ui\data\sound\new1",0,0};
	soundClick[] = {"\ca\ui\data\sound\onclick",0.07,1};
	soundEscape[] = {"\ca\ui\data\sound\onescape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "Bitstream";
	sizeEx = 0.03921;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};
class DRN_DIALOG_Y {
	idd=-1;
	movingenable=true;
	class Controls
	{
			class mapTavi: RscPicture
		{
			idc = 1200;
			text = "scripts\mapTavi.paa";
			x = 0.23 * safezoneW + safezoneX;
			y = 0.14125 * safezoneH + safezoneY;
			w = 0.536 * safezoneW;
			h = 0.68 * safezoneH;
		};
		class btnKraz: RscButton_Spawn
		{
			idc = 1612;
			text = "Красно";
			x = 0.461088 * safezoneW + safezoneX;
			y = 0.541875 * safezoneH + safezoneY;
			w = 0.039 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 0;";
		};
		class btnByelov: RscButton_Spawn
		{
			idc = 1600;
			text = "Белов";
			x = 0.580252 * safezoneW + safezoneX;
			y = 0.59375 * safezoneH + safezoneY;
			w = 0.037 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 1;";
		};
		class btnEtan: RscButton_Spawn
		{
			idc = 1602;
			text = "Дориянов";
			x = 0.51 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.0475 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 2;";
		};
		class btnLypo: RscButton_Spawn
		{
			idc = 1603;
			text = "Кленивник";
			x = 0.44 * safezoneW + safezoneX;
			y = 0.47 * safezoneH + safezoneY;
			w = 0.052 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 3;";
		};
		class btnKilim: RscButton_Spawn
		{
			idc = 1603;
			text = "Два острова";
			x = 0.38 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 4;";
		};
		class btnMartin: RscButton_Spawn
		{
			idc = 1604;
			text = "Мартин";
			x = 0.565 * safezoneW + safezoneX;
			y = 0.418125 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 5;";
		};
		class btnKam: RscButton_Spawn
		{
			idc = 1607;
			text = "Камени";
			x = 0.46 * safezoneW + safezoneX;
			y = 0.234375 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 7;";
		};
		class btnSev: RscButton_Spawn
		{
			idc = 1608;
			text = "АЭС";
			x = 0.48 * safezoneW + safezoneX;
			y = 0.65 * safezoneH + safezoneY;
			w = 0.029 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 8;";
		};
		class btnBran: RscButton_Spawn
		{
			idc = 1609;
			text = "Бранибор";
			x = 0.411785 * safezoneW + safezoneX;
			y = 0.641875 * safezoneH + safezoneY;
			w = 0.048142 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 9;";
		};
		class btnShta: RscButton_Spawn
		{
			idc = 1610;
			text = "Штанград";
			x = 0.317552 * safezoneW + safezoneX;
			y = 0.57 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.020 * safezoneH;
			action = "closeDialog 0;spawnSelect = 10;";
		};

		class btnRand: RscButton_Spawn
		{
			idc = 1613;
			text = "Случайно";
			x = 0.28 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.0608304 * safezoneW;
			h = 0.020 * safezoneH;
			action = "closeDialog 0;spawnSelect = 11;";
		};
	};
};

class DRN_DIALOG_N {
	idd=-1;
	movingenable=true;
	class Controls
	{
		class mapTavi: RscPicture
		{
			idc = 1200;
			text = "scripts\mapTavi.paa";
			x = 0.23 * safezoneW + safezoneX;
			y = 0.14125 * safezoneH + safezoneY;
			w = 0.536 * safezoneW;
			h = 0.68 * safezoneH;
		};
		class btnKraz: RscButton_Spawn
		{
			idc = 1612;
			text = "Красно";
			x = 0.461088 * safezoneW + safezoneX;
			y = 0.541875 * safezoneH + safezoneY;
			w = 0.039 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 0;";
		};
		class btnByelov: RscButton_Spawn
		{
			idc = 1600;
			text = "Белов";
			x = 0.580252 * safezoneW + safezoneX;
			y = 0.59375 * safezoneH + safezoneY;
			w = 0.037 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 1;";
		};
		class btnLypo: RscButton_Spawn
		{
			idc = 1603;
			text = "Кленивник";
			x = 0.44 * safezoneW + safezoneX;
			y = 0.47 * safezoneH + safezoneY;
			w = 0.052 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 3;";
		};
		class btnMartin: RscButton_Spawn
		{
			idc = 1604;
			text = "Мартин";
			x = 0.565 * safezoneW + safezoneX;
			y = 0.418125 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 5;";
		};
		class btnDaln: RscButton_Spawn
		{
			idc = 1605;
			text = "Дальногорск";
			x = 0.545 * safezoneW + safezoneX;
			y = 0.304375 * safezoneH + safezoneY;
			w = 0.066 * safezoneW;
			h = 0.020 * safezoneH;
			action = "closeDialog 0;spawnSelect = 6;";
		};
		class btnKam: RscButton_Spawn
		{
			idc = 1607;
			text = "Камени";
			x = 0.46 * safezoneW + safezoneX;
			y = 0.234375 * safezoneH + safezoneY;
			w = 0.042 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 7;";
		};
		class btnSev: RscButton_Spawn
		{
			idc = 1608;
			text = "АЭС";
			x = 0.48 * safezoneW + safezoneX;
			y = 0.65 * safezoneH + safezoneY;
			w = 0.029 * safezoneW;
			h = 0.02 * safezoneH;
			action = "closeDialog 0;spawnSelect = 8;";
		};
		class btnShta: RscButton_Spawn
		{
			idc = 1610;
			text = "Штанград";
			x = 0.317552 * safezoneW + safezoneX;
			y = 0.57 * safezoneH + safezoneY;
			w = 0.05 * safezoneW;
			h = 0.020 * safezoneH;
			action = "closeDialog 0;spawnSelect = 10;";
		};

		class btnRand: RscButton_Spawn
		{
			idc = 1613;
			text = "Случайно";
			x = 0.28 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.0608304 * safezoneW;
			h = 0.020 * safezoneH;
			action = "closeDialog 0;spawnSelect = 11;";
		};
		class lbltxt1: RscText
		{
			idc = 1000;
			text = "Для открытия новых точек спавна";
			x = 0.53 * safezoneW + safezoneX;
			y = 0.60 * safezoneH + safezoneY;
			w = 0.3 * safezoneW;
			h = 0.2 * safezoneH;
			tooltip = "";
		};
		class lbltxt2: RscText
		{
			idc = 1000;
			text = "наберите 5000 хуманити";
			x = 0.56 * safezoneW + safezoneX;
			y = 0.631 * safezoneH + safezoneY;
			w = 0.3 * safezoneW;
			h = 0.2 * safezoneH;
			tooltip = "";
		};
	};
};

class E_Halo_Dialog
{
	idd = -1;
	movingenable = true;
	class Controls
	{
		class E_Halo_ButtonGround: E_RscButton_Spawn
		{
			idc = -1;
			text = "ЗЕМЛЯ";
			colorText[] = {1,1,1,.9};
			colorDisabled[] = {0.4,0.4,0.4,0};
			colorBackground[] = {0.75,0.75,0.75,0.8};
			colorBackgroundDisabled[] = {0,0.0,0};
			colorBackgroundActive[] = {0.75,0.75,0.75,1};
			colorFocused[] = {0.75,0.75,0.75,.5};
			font = "Bitstream";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.528704 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0540741 * safezoneH;
			action = "closeDialog 0;haloSelect = 0";
		};
		class E_Halo_ButtonAir15: E_RscButton_Spawn
		{
			idc = -1;
			text = "1500м";
			colorText[] = {1,1,1,.9};
			colorDisabled[] = {0.4,0.4,0.4,0};
			colorBackground[] = {0.75,0.75,0.75,0.8};
			colorBackgroundDisabled[] = {0,0.0,0};
			colorBackgroundActive[] = {0.75,0.75,0.75,1};
			colorFocused[] = {0.75,0.75,0.75,.5};
			x = 0.47 * safezoneW + safezoneX;
			y = 0.528704 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0540741 * safezoneH;
			action = "closeDialog 0;haloSelect = 1";
		};
		class E_Halo_ButtonAir3: E_RscButton_Spawn
		{
			idc = -1;
			text = "3000м";
			colorText[] = {1,1,1,.9};
			colorDisabled[] = {0.4,0.4,0.4,0};
			colorBackground[] = {0.75,0.75,0.75,0.8};
			colorBackgroundDisabled[] = {0,0.0,0};
			colorBackgroundActive[] = {0.75,0.75,0.75,1};
			colorFocused[] = {0.75,0.75,0.75,.5};
			x = 0.57 * safezoneW + safezoneX;
			y = 0.528704 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0540741 * safezoneH;
			action = "closeDialog 0;haloSelect = 2";
		};
		class E_Halo_PicGround: RscPicture
		{
			idc = -1;
			style = 0x30;
			font = "Bitstream";
			fixedWidth = 0;
			shadow = 0;
			text = "\ca\warfare2\Images\con_barracks.paa";
			x = 0.37 * safezoneW + safezoneX;
			y = 0.425 * safezoneH + safezoneY;
			w = 0.0615625 * safezoneW;
			h = 0.0753703 * safezoneH;
		};
		class E_Halo_PicHalo: RscPicture
		{
			idc = -1;
			style = 0x30;
			font = "Bitstream";
			fixedWidth = 0;
			shadow = 0;
			text = "\ca\air\Data\Ico\para_ca.paa";
			x = 0.47 * safezoneW + safezoneX;
			y = 0.419445 * safezoneH + safezoneY;
			w = 0.0620833 * safezoneW;
			h = 0.0781481 * safezoneH;
		};		
		class E_Halo_PicHalo2: RscPicture
		{
			idc = -1;
			style = 0x30;
			font = "Bitstream";
			fixedWidth = 0;
			shadow = 0;
			text = "\ca\air\Data\Ico\para_ca.paa";
			x = 0.57 * safezoneW + safezoneX;
			y = 0.419445 * safezoneH + safezoneY;
			w = 0.0620833 * safezoneW;
			h = 0.0781481 * safezoneH;
		};
		class HALOText1:RscTxtT
		{
			idc=-1;
			text= "2000р.";
			x = 0.48 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0540741 * safezoneH;
		};		
		class HALOText2:RscTxtT
		{
			idc=-1;
			text= "5000р.";
			x = 0.58 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.0641667 * safezoneW;
			h = 0.0540741 * safezoneH;
		};
		
	};
};

class vip_spawn_Dialog
{
	idd = -1;
	movingenable = true;
	class Controls
	{
		class SpawnBase_Button: E_RscButton_Spawn
		{
			idc = -1;
			text = "БАЗА";
			colorText[] = {1,1,1,.9};
			colorDisabled[] = {0.4,0.4,0.4,0};
			colorBackground[] = {0.75,0.75,0.75,0.8};
			colorBackgroundDisabled[] = {0,0.0,0};
			colorBackgroundActive[] = {0.75,0.75,0.75,1};
			colorFocused[] = {0.75,0.75,0.75,.5};
			font = "Bitstream";
			x = 0.409766 * safezoneW + safezoneX;
			y = 0.528704 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.0540741 * safezoneH;
			action = "closeDialog 0;VipSpawnSelect = 0";
		};
		class SpawnSatdart_Button: E_RscButton_Spawn
		{
			idc = -1;
			text = "ПРОДОЛЖИТЬ";
			colorText[] = {1,1,1,.9};
			colorDisabled[] = {0.4,0.4,0.4,0};
			colorBackground[] = {0.75,0.75,0.75,0.8};
			colorBackgroundDisabled[] = {0,0.0,0};
			colorBackgroundActive[] = {0.75,0.75,0.75,1};
			colorFocused[] = {0.75,0.75,0.75,.5};
			x = 0.525781 * safezoneW + safezoneX;
			y = 0.528704 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.0540741 * safezoneH;
			action = "closeDialog 0;VipSpawnSelect = 1";
		};
	};
};