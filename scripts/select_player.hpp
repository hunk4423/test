class PlayerSelector
{
	idd = 4800;
	onLoad = "uiNamespace setVariable ['PlayerSelectorDlg', _this select 0]";
	class controlsBackground {
		class Background: DialogBackground {ctrlBound(0.4,0.3,0.2,0.5);};
		class Title: DialogTitle {idc=4801;text="";ctrlBound(0.4,0.3,0.2,0.03);};
		class Header: TitleT {text="Ближайшие игроки:";ctrlBound(0.41,0.34,0.18,0.03);};	
	};
	class Controls {
		class Players: ListBox {idc=4802;ctrlBound(0.41,0.38,0.18,0.3);};
		class Info: Life_RscStructuredText {idc=4803;text="";sizeEx=0.026;size=0.026;ctrlBound(0.405,0.695,0.19,0.052);};
		class OkBtn: Zupa_RscButtonMenu {text="Выбрать";ctrlBound(0.41,0.75,0.08,0.03);onButtonClick="[(lbCurSel 4802)] call OnSelectPlayerClick;";};
		class CancelBtn: Zupa_RscButtonMenu {text="Отмена";ctrlBound(0.51,0.75,0.08,0.03);onButtonClick="((ctrlParent (_this select 0)) closeDisplay 1);";};
	};
};
