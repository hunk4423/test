/*
	GoldKey

	F507DMT aka Левин Д.Ю. 
	BlackGoga aka Федотов В.В.

	http://goldkey-games.ru 
	https://vk.com/goldkey_dz
*/
#ifdef _BLOWOUT

class RscTextNS {
	idc = -1;
	type = 0;
	style = 2;
	LineSpacing = 1.0;
	h = 0.04;
	ColorBackground[] = {1,1,1,0.2};
	ColorText[] = {0.1,0.1,0.1,1};
	font = "BitStream";
	SizeEx = 0.025;
};
#endif

class RscTitles 
{
#ifdef _BLOWOUT

	class RscAPSI_h1 {
		idd = -1;
		duration = 4;
		fadein = 0;
		movingEnable = 0;
		enableSimulation = 0;
		enableDisplay = 0;
		class controls {
			class APSILog: RscTextNS {
				x = 0.5;
				y = 0.99;
				w = 0.5;
				h = 0.03;
				text = "Внимание! Приближается выброс! Пси-защита активирована!";
				colorBackground[] = {0.5,0.5,0.5,0.4};
				ColorText[] = {1.0,0.2,0.1,1};
			};
		};
	};

	class RscAPSI_h6: RscAPSI_h1 {
		class controls {
			class APSILog: RscTextNS {
				x = 0.5;
				y = 0.99;
				w = 0.4;
				h = 0.03;
				text = "Выброс кончился. Защита выключена.";
				colorBackground[] = {0.5,0.5,0.5,0.4};
				ColorText[] = {0.0,1.0,0.2,1};
			};
		};
	};
#endif
	class wm_disp {
		idd = -1;
		onLoad = "uiNamespace setVariable ['wm_disp', _this select 0]";
		fadein = 0;
		fadeout = 0;
		duration = 10e10;
		controlsBackground[] = {};
		objects[] = {};
		class controls {
			class wm_text2 {
				idc = 1;
				x = safeZoneX+0.027;//safeZoneW*0.01;
				y = safeZoneY+safeZoneH-0.16;
				w = 0.149*safeZoneH;
				h = 0.057*safeZoneH;
				shadow = 2;
				class Attributes {
					font = "EtelkaNarrowMediumPro";
					color = "#24FFFFFF";
					align = "left"; // put "center" here if you want some background
					valign = "middle";
					shadow = 2;
				};
				colorBackground[] = { 1, 0.3, 0, 0 };  // uncomment and increase 4th number to have a background
				font = "EtelkaNarrowMediumPro";
				size = 0.06*safeZoneH;
				type = 13;
				style = 0;
				text="";
			};
		};
	};

	class BTC_Hud {
		idd = 1000;
		movingEnable=0;
		duration=1e+011;
		name = "BTC_Hud_Name";
		onLoad = "uiNamespace setVariable ['HUD', _this select 0];";
		controlsBackground[] = {};
		objects[] = {};
		class controls 
		{
			class Radar
			{
				type = 0;
				idc = 1001;
				style = 48;
				x = (SafeZoneW+2*SafeZoneX) - 0.1;//safezonex + 0.1;//0.9
				y = (SafeZoneH+2*SafeZoneY) - 0.15;//safezoney + 0.1;//0.85
				w = 0.3;
				h = 0.4;
				font = "Zeppelin32";
				sizeEx = 0.03;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				text = "\ca\ui\data\igui_radar_air_ca.paa";
			};
			class Img_Obj
			{
				type = 0;
				idc = 1002;
				style = 48;
				x = (SafeZoneW+2*SafeZoneX) + 0.045;
				y = (SafeZoneH+2*SafeZoneY) + 0.045;
				w = 0.01;
				h = 0.01;
				font = "Zeppelin32";
				sizeEx = 0.04;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				text = "scripts\radar.paa";
			};
			class Pic_Obj
			{
				type = 0;
				idc = 1003;
				style = 48;
				x = (SafeZoneW+2*SafeZoneX) - 0.125;
				y = (SafeZoneH+2*SafeZoneY) - 0.23;
				w = 0.1;
				h = 0.1;
				font = "Zeppelin32";
				sizeEx = 0.03;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				text = "";
			};
			class Arrow
			{
				type = 0;
				idc = 1004;
				style = 48;
				x = (SafeZoneW+2*SafeZoneX) + 0.15;
				y = (SafeZoneH+2*SafeZoneY) - 0.15;
				w = 0.05;
				h = 0.05;
				font = "Zeppelin32";
				sizeEx = 0.03;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				text = "";
			};
			class Type_Obj
			{
				type = 0;
				idc = 1005;
				style = 0x00;
				x = (SafeZoneW+2*SafeZoneX) - 0.03;
				y = (SafeZoneH+2*SafeZoneY) - 0.335;
				w = 0.3;
				h = 0.3;
				font = "Zeppelin32";
				sizeEx = 0.03;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				text = "";
			};
		};   
	};
	class ExampleTitle {     
		idd = -1; 
		duration = 10; //show for 10 seconds 
		class controls 
		{ 
			class ExampleControl 
			{
				idc = -1; 
				type = 0; 
				style = 2; //centre text 
				x = safeZoneX + safeZoneW - 0.6 * 3 / 4;  
				y = safeZoneY + safeZoneH - 0.6; 
				h = 0.6; 
				w = 0.6 * 3 / 4; //w == h 
				font = "EtelkaNarrowMediumPro"; 
				sizeEx = 0.03; 
				colorBackground[] = {1,1,0,1}; //yellow background 
				colorText[] = {0,0,1,1}; //blue text 
				text = "Bottom Right Corner Square Box"; 
			};
		};
	};

	class playerStatusGUI {
        idd = 6900;
        movingEnable = 0;
        duration = 100000;
        name = "statusBorder";
        onLoad = "uiNamespace setVariable ['DAYZ_GUI_display', _this select 0];";
        class ControlsBackground {
            class RscPicture_1900: RscPictureGUI
            {
                idc = 1900;
                text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.875313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };
			class RscPicture_1901: RscPictureGUI
            {
                idc = 1901;
                text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.905313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;//2
                w = 0.075;
                h = 0.10;
            };
			class RscPicture_1902: RscPictureGUI
            {
                idc = 1902;
                text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.942313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //1
                w = 0.075;
                h = 0.10;
            };
			class RscPicture_1908: RscPictureGUI
            {
                idc = 1908;
                text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.845313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };
			class RscPicture_1910: RscPictureGUI
            {
                idc = 1910;
                text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.815313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1201: RscPictureGUI
            {
                idc = 1201;
                text = "\z\addons\dayz_code\gui\status\status_food_border_ca.paa";
                x = 0.875313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;//2
                w = 0.075;
                h = 0.10;
            };

            class RscPicture_1200: RscPictureGUI
            {
                idc = 1200;
                //text = "\z\addons\dayz_code\gui\status\status_blood_border_ca.paa";
                x = 0.845313 * safezoneW + safezoneX;
                y = 0.93* safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };

            class RscPicture_1202: RscPictureGUI
            {
                idc = 1202;
                text = "\z\addons\dayz_code\gui\status\status_thirst_border_ca.paa";
                x = 0.905313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //1
                w = 0.075;
                h = 0.10;
            };

			class RscPicture_1307: RscPictureGUI
            {
                idc = 1307;
                text = "scripts\combat_strix.paa";
                x = 0.942313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1208: RscPictureGUI
            {
                idc = 1208;
                text = "\z\addons\dayz_code\gui\status\status_temp_outside_ca.paa";
                x = 0.815313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //3
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1203: RscPictureGUI
            {
                idc = 1203;
                text = "\z\addons\dayz_code\gui\status\status_effect_brokenleg.paa";
                x = 0.955313 * safezoneW + safezoneX;
                y = 0.66 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
                colorText[] = {1,1,1,1};
            };
            class RscPicture_1204: RscPictureGUI
            {
                idc = 1204;
                text = "\z\addons\dayz_code\gui\status\status_connection_ca.paa";
                x = 0.955313 * safezoneW + safezoneX;
                y = 0.51 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
                colorText[] = {1,1,1,1};
            };
			class RscPicture_1206: RscPictureGUI
            {
                idc = 1206;
                text = "scripts\combat.paa";
                x = 0.942313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY; //1
                w = 0.075;
                h = 0.10;
            };
            /*--------------------------------------------*/
        };
        class Controls {
            class RscPicture_1301: RscPictureGUI
            {
                idc = 1301;
                //text = "\z\addons\dayz_code\gui\status\status_food_inside_ca.paa";
                x = 0.875313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1300: RscPictureGUI
            {
                idc = 1300;
                //text = "\z\addons\dayz_code\gui\status\status_blood_inside_ca.paa";
                x = 0.845313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1302: RscPictureGUI
            {
                idc = 1302;
                //text = "\z\addons\dayz_code\gui\status\status_thirst_inside_ca.paa";
                x = 0.905313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1306: RscPictureGUI
            {
                idc = 1306;
                //text = "\z\addons\dayz_code\gui\status\status_temp_ca.paa";
                x = 0.815313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
            };
            class RscPicture_1303: RscPictureGUI
            {
                idc = 1303;
                text = "scripts\status_bleeding_ca.paa";
                x = 0.845313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.075;
                h = 0.10;
                colorText[] = {1,1,1,0.5};
            };



            class RscPicture_1313: RscPictureGUI
            {
                idc = 1313;
                //text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.959313 * safezoneW + safezoneX;
                y = 0.23 * safezoneH + safezoneY;
                w = 0.068;
                h = 0.083;
                colorText[] = {0.96,0.8, 0.2,0.3};
            };

            class RscText_1322: RscPictureGUI
            {
                idc = 1322;
                //text = "\z\addons\dayz_code\gui\status\status_bg.paa";
                x = 0.965313 * safezoneW + safezoneX;
                y = 0.93 * safezoneH + safezoneY;
                w = 0.037 * safezoneW;
                h = 0.047 * safezoneH;
                colorText[] = {1,1,1,0.0};
            };
        };
    };
	#include "dzgm_icons.hpp"
};
