class BankDialog
{
	idd=-1;
	movingenable=0;
	enableSimulation=true;
	movingEnabled=true;

	class controlsBackground {
		class Life_RscTitleBackground:Life_RscText {
			idc=-1;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};	
			x=0.35;y=0.2;w=0.3;h=0.04;
		};
		class MainBackground:DialogTitle {
			colorBackground[]={0,0,0,0.7};
			idc=-1;
			x=0.35;y=0.2+(11/250);w=0.3;h=0.6-(22/250);
		};
	};
	class Controls {
		class CashTitle : Life_RscStructuredText {
			idc=2701;
			text="Банк:";
			colorText[]={0.8784,0.8471,0.651,1};
			x=0.36;y=0.26;w=0.3;h=0.2;
		};
		class RscTextT_1005 : RscTextT {
			idc=13002;text="";
			colorText[]={1,1,1,1};
			x=0.49;y=0.18.3;w=0.3;h=0.2;
		};		
		
		class CashTitle3 : Life_RscStructuredText{
			idc=2703;text="Наличные:";colorText[]={0.8784,0.8471,0.651,1};
			x=0.36;y=0.30.5;w=0.3;h=0.2;
		};
		class RscTextT_1004 : RscTextT{
			idc=13001;text="";colorText[]={1,1,1,1};
			x=0.49;y=0.22.8;w=0.3;h=0.2;
		};		
		class Vvedite_summu : Life_RscStructuredText {
			idc=2704;
			text="Введите сумму:";
			colorText[]={0.8784,0.8471,0.651,1};
			x=0.4;y=0.40;w=0.3;h=0.2;
		};		
		class moneyEdit : TextEdit {
			idc=2702;
			text="";
			x=0.4;y=0.45;w=0.2;h=0.03;
		};
		class Title : Life_RscTitle {
			colorBackground[]={0,0,0,0};
			idc=-1;text="GoldKey Bank";
			colorText[]={1,1,1,1};
			x=0.35;y=0.2;w=0.6;h=0.04;
		};
		class WithdrawButton : Zupa_RscButtonMenu {
			idc=-1;text = "Снять";
			onButtonClick="[(ctrlText 2702)] spawn BankDialogWithdrawAmount; ((ctrlParent (_this select 0)) closeDisplay 9000);";
			x=0.405;y=0.500;w=0.19;h=0.04;
		};
		class DepositButton : Zupa_RscButtonMenu {
			idc=-1;text="Положить деньги";
			onButtonClick="[(ctrlText 2702),false] spawn BankDialogDepositAmount; ((ctrlParent (_this select 0)) closeDisplay 9000);";
			x=0.405;y=0.552;w=0.19;h=0.04;
		};		
		class DepositAllButton : Zupa_RscButtonMenu {
			idc=-1;text="Положить все";			
			onButtonClick="[0,true] spawn BankDialogDepositAmount; ((ctrlParent (_this select 0)) closeDisplay 9000);";
			x=0.405;y=0.604;w=0.19;h=0.04;
		};
		class CloseButtonKey : Zupa_RscButtonMenu {
			idc=-1;text="Закрыть";
			onButtonClick="((ctrlParent (_this select 0)) closeDisplay 9000);";
			x=0.405;y=0.690;w=0.19;h=0.04;
		};
	};
};