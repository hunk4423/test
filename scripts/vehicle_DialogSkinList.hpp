class vehicle_ChengeSkin
{
	idd = 20001;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['vehicle_ChengeSkin', _this select 0];";
	class Controls {
		class RscText_9000: RscTextT
		{
			idc = 20002;
			x = 0.30 * safezoneW + safezoneX;
			y = 0.30 * safezoneH + safezoneY;
			w = 0.20 * safezoneW;
			h = 0.5 * safezoneH;
			colorBackground[] = {0,0,0,0.8};
		};	
		class RscListbox_9001: RscListbox
		{
			idc = 20014;
			x = 0.31* safezoneW + safezoneX;
			y = 0.37 * safezoneH + safezoneY;
			w = 0.18 * safezoneW;
			h = 0.31 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};		
		class RscShortcutButton_9004: Zupa_RscButtonMenu
		{
			idc = 20005;
			text = "Предпросмотр";
			size=0.037;
			x = 0.305 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "['','OriVehSkins',[(lbCurSel 20014)]]spawn fnc_Preview;";			
		};	
		class RscShortcutButton_9006: Zupa_RscButtonMenu
		{
			idc = 20006;
			text = "Отмена";
			size=0.037;
			x = 0.405 * safezoneW + safezoneX;
			y = 0.76 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "CloseDialog 0;";
		};	
		class RscShortcutButton_9009: Zupa_RscButtonMenu
		{
			idc = 20006;
			text = "Перекрасить";
			size=0.037;
			x = 0.305 * safezoneW + safezoneX;
			y = 0.76 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "[(lbCurSel 20014)]  call fnc_veh_ApplySkin;";
		};			
		class RscShortcutButton_9010: Zupa_RscButtonMenu
		{
			idc = 20006;
			text = "Стандарт";
			size=0.037;
			x = 0.405 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "[506]  call fnc_veh_ApplySkin;";
		};			
		class RscText_9007: RscTextT
		{
			idc = 20007;
			text = "Выберите расширенную покраску:";
			size=0.037;
			x = 0.30 * safezoneW + safezoneX;
			y = 0.30 * safezoneH + safezoneY;
			w = 0.20 * safezoneW;
			h = 0.05 * safezoneH;		
			colorBackground[] = {0,0,0,0.8};	
			colorText[] = {1,1,1,1};			
		};
		class Info: Life_RscStructuredText {idc=4803;text="Цена покраски: 5,000 рублей.";sizeEx=0.035;size=0.026;ctrlBound(0.335,0.695,0.19,0.052);};

	};
};