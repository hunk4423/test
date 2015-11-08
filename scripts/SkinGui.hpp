class MenClothing
{
	idd = 20001;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['MenClothing', _this select 0];";
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
			text = "Переодеться";
			x = 0.305 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "[(lbCurSel 20014)]  call ApplySkinList;";
		};	
		class RscShortcutButton_9006: Zupa_RscButtonMenu
		{
			idc = 20006;
			text = "Отмена";
			x = 0.405 * safezoneW + safezoneX;
			y = 0.72 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "CloseDialog 0;";
		};	
		class RscShortcutButton_9009: Zupa_RscButtonMenu
		{
			idc = 20006;
			text = "Предпросмотр";
			x = 0.355 * safezoneW + safezoneX;
			y = 0.76 * safezoneH + safezoneY;
			w = 0.10 * safezoneW;
			h = 0.03 * safezoneH;
			onButtonClick = "['','skin',[(lbCurSel 20014)]]spawn fnc_Preview;";
		};			
		class RscText_9007: RscTextT
		{
			idc = 20007;
			text = "Выберите скин:";
			x = 0.30 * safezoneW + safezoneX;
			y = 0.30 * safezoneH + safezoneY;
			w = 0.20 * safezoneW;
			h = 0.05 * safezoneH;		
			colorBackground[] = {0,0,0,0.8};	
			colorText[] = {1,1,1,1};			
		};

	};
};