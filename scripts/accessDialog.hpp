class DialogBTN: Zupa_RscButtonMenu {ctrlSize(0.08,0.03);};
class AccessBTN: Zupa_RscButtonMenu {x=SX(0.55);ctrlSize(0.18,0.03);};
class AccessList: RscListbox{ctrlSize(0.13,0.3);soundSelect[]={"",0.1,1};colorBackground[]={0.1,0.1,0.1,0.8};};

class AccessManagement {
	idd=7000;
	movingEnabled=true;
	onLoad="uiNamespace setVariable ['AccessManagement',_this select 0]";
	onUnLoad="[] call onAccessUnLoad";
	class controlsBackground {
		class Background:DialogBackground {ctrlBound(0.25,0.25,0.5,0.51);};
		class TitleText:DialogTitle {idc=7003;ctrlBound(0.25,0.25,0.5,0.03);};
		class OwnerText:TitleT {idc = 7010;ctrlPos(0.26,0.285);w=SW(0.48);};
		class NearText:TitleT {text="Ближайшие игроки:";ctrlPos(0.26,0.31);};
		class FriendText:TitleT {text="Имеющие доступ:";ctrlPos(0.4,0.31);};
		class AccessText:TitleT {text="Права игрока:";ctrlPos(0.55,0.31);};
		class InfoText:TitleT {idc=7009;ctrlBound(0.255,0.65,0.275,0.03);};
		class StatusText:StatusT {idc=7011;ctrlBound(0.25,0.73,0.5,0.03);};
	};
	class Controls {
		class NearList: AccessList {idc=7001;ctrlPos(0.255,0.34);onLBSelChanged="[(lbCurSel 7001)] call OnAccessNearChange";};
		class FriendsList: AccessList {idc=7002;ctrlPos(0.4,0.34);onLBSelChanged="[(lbCurSel 7002)] call OnAccessUserChange";};
		class AddBTN: Zupa_RscButtonMenu {idc=7003;text=">>";size=0.03;ctrlBound(0.392,0.42,0.032,0.03);onButtonClick="[(lbCurSel 7001)] call OnAccessAdd";};
		class DelBTN: Zupa_RscButtonMenu {idc=7004;text="<<";size=0.03;ctrlBound(0.392,0.55,0.032,0.03);onButtonClick="[(lbCurSel 7002)] call OnAccessRemove";};	
		class CancelBTN: DialogBTN {idc=7005;text="Закрыть";ctrlPos(0.35,0.69);onButtonClick="((ctrlParent (_this select 0)) closeDisplay 2)";};
		class ResetBTN: AccessBTN {idc=7006;text="Отменить";ctrlPos(0.55,0.50);onButtonClick="[(lbCurSel 7002)] call OnAccessReset";};
		class ResetAllBTN: AccessBTN {idc=7007;text="Отменить у всех";y=SY(0.54);onButtonClick="[] call OnAccessResetAll";};
		class ComBTN: AccessBTN {idc=7030;y=SY(0.64);text="Задать описание";onButtonClick="[AccessTarget] spawn object_CommentDlg";};
		class AplyBTN: AccessBTN {idc=7008;text="Применить";y=SY(0.69);onButtonClick="[] call OnAccessApply";};
	};
};
