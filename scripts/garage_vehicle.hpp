#define LBHY	0.14 // Y для заголовка списка
#define LBY		0.18 // Y для списка
#define UX		0.12 // Х для игроков
#define UW		0.14 // W для игроков
#define UH		0.65 // W для игроков
#define Border	0.02
#define VX		0.28 // X для машин
#define VW		0.45  // W для машин
#define VH		0.46
#define TIHY	0.65
#define TIY		0.68 // Y для информации
#define TIH		0.17
#define BTNY	0.86

class ToolBtn:Zupa_RscButtonMenu{ctrlSize(0.12,0.03);size=0.026;};

class GarageVehicles {
	idd=IDD_GARAGE_LIST;
	name="GarageVehicles";
	movingEnabled=true;
	enableSimulation=1;
	onLoad="_this call onGarageVehiclesLoad";
	onUnLoad="call onGarageVehiclesUnLoad";

	class controlsBackground {
		class Background: DialogBackground {ctrlBound(0.1,0.1,0.8,0.83);};
		class Title: DialogTitle {idc=2801;ctrlBound(0.1,0.1,0.8,0.03);text="Гараж";};
		class PlayerHeader: HeaderT {text="Владельцы";ctrlBound(UX,LBHY,UW,0.03);};
		class VehicleHeader: HeaderT {idc=2817;text="Транспорт в гараже";ctrlBound(VX,LBHY,VW,0.03);};
		class VehicleInfoHeader: HeaderT {idc=2802;text="Информация о выбранном транспорте";ctrlBound(VX,TIHY,VW,0.03);};
		class KeyFrame:GkFrame{idc=2818;text="Оставить ключ на поясе";ctrlBound(0.735,LBHY,0.15,0.09);};
		class Key2Frame:GkFrame{idc=2819;text="Забрать ключ с пояса";ctrlBound(0.735,LBHY+0.1,0.15,0.09);};
		class RestFrame:GkFrame{text="Уничтоженная техника";ctrlBound(0.735,LBHY+0.2,0.15,0.09);};
		class AdmFrame:GkFrame{idc=2840;text="Администрирование";ctrlBound(0.735,0.6,0.15,0.25);};
		class FindT:Life_RscText{idc=2841;sizeex=0.026;text="R поиска (м)";ctrlBound(0.735,0.63,0.093,0.03);};
		class LifeT:Life_RscText{idc=2842;sizeex=0.026;text="Восстановлений";ctrlBound(0.735,0.67,0.093,0.03);};
		class DonateT:Life_RscText{idc=2843;sizeex=0.026;text="Донат(1-нет,2-да)";ctrlBound(0.735,0.705,0.093,0.03);};
		class RepairT:Life_RscText{idc=2844;sizeex=0.026;text="Вост.за.игр.вал.(1-было)";ctrlBound(0.735,0.74,0.093,0.03);};
		class StatusText: StatusT {idc=2812;ctrlBound(0.1,0.9,0.8,0.03);};
	};

	class controls {
		class UserList:ListBox{
			idc=2806;ctrlBound(UX,LBY,UW,UH);
			onLBSelChanged="[(lbCurSel 2806)] call onGarageUserClick;ctrlSetText[2812,'']";
		};
		class GarageList:ListBox{
			idc=2807;ctrlBound(VX,LBY,VW,VH);
			onLBSelChanged = "[(lbCurSel 2807)] call onGarageVehicleClick;ctrlSetText[2812,'']";
		};
		class vehicleInfomation:Life_RscStructuredText{idc=2808;text="";sizeEx=0.035;ctrlBound(VX,TIY,VW,TIH);};
		class RentCar:ToolBtn{
			idc=2804;ctrlPos(0.75,LBHY+0.04);
			onButtonClick="[(lbCurSel 2807),false] call OnGarageGetClick";
		};
		class RentKeyCar:ToolBtn{
			idc=2805;ctrlPos(0.75,LBHY+0.14);
			onButtonClick="[(lbCurSel 2807),true] call OnGarageGetClick";
		};
		class RestoreBtn:ToolBtn{
			idc=2814;text="Восстановить";ctrlPos(0.75,LBHY+0.24);
			onButtonClick="[(lbCurSel 2807)] spawn onVehRestore";
		};
		class FindR:TextEdit{idc=2856;ctrlBound(0.829,0.63,0.05,0.03);};
		class LifeCnt:TextEdit{idc=2850;ctrlBound(0.829,0.67,0.025,0.03);};
		class LifeBtn : ToolBtn {
			idc=2851;text="Set";ctrlBound(0.856,0.67,0.025,0.03);
			onButtonClick="[(lbCurSel 2807),'p1',ctrlText 2850] spawn onGarageSetVehicle";
		};
		class DonateCnt:TextEdit{idc=2852;ctrlBound(0.829,0.705,0.025,0.03);};
		class DonateBtn : ToolBtn {
			idc=2853;text="Set";ctrlBound(0.856,0.705,0.025,0.03);
			onButtonClick="[(lbCurSel 2807),'p2',ctrlText 2852] spawn onGarageSetVehicle";
		};
		class RepairCnt:TextEdit{idc=2854;ctrlBound(0.829,0.74,0.025,0.03);};
		class RepairBtn : ToolBtn {
			idc=2855;text="Set";ctrlBound(0.856,0.74,0.025,0.03);
			onButtonClick="[(lbCurSel 2807),'p3',ctrlText 2854] spawn onGarageSetVehicle";
		};
		class TPCar:ToolBtn{
			idc=2857;ctrlPos(0.75,0.78);text="ТП к объекту";
			onButtonClick="[lbCurSel 2807] call onGarageGotoVehicle";
		};
		class ModeBtn : Zupa_RscButtonMenu {
			idc=2815;ctrlBound(0.11,BTNY,0.15,0.03);text="";
			onButtonClick="garageDialogModeGet=!garageDialogModeGet;[] spawn OnGarageModeChange";
		};
		class ManagerBtn : Zupa_RscButtonMenu {
			idc=2809;text="Управление доступом";ctrlBound(0.27,BTNY,0.15,0.03);
			onButtonClick="call onManagerClick";
		};
		class PadBtn : Zupa_RscButtonMenu {
			idc=2816;text="Настройка площадок";ctrlBound(0.43,BTNY,0.15,0.03);
			onButtonClick="call onPadmenuClick";
		};
		class RefreshBtn : Zupa_RscButtonMenu {
			idc=2813;text="Обновить";ctrlBound(0.63,BTNY,0.12,0.03);
			onButtonClick="ctrlSetText[2812,''];[] spawn onGarageUpdate";
		};
		class CloseBtn : Zupa_RscButtonMenu {idc=2803;text="Закрыть";ctrlBound(0.76,BTNY,0.12,0.03);onButtonClick="closeDialog 0;";};
		class MainBackgroundHider : Life_RscText {idc=2810;colorBackground[]={0,0,0,1};ctrlBound(0.1,0.13,0.8,0.8);};
		class MainHideText : Life_RscText {idc=2811;text="Поиск транспорта ...";sizeEx=0.06;ctrlBound(0.4,0.45,0.6,0.1);};
	};
};

class GaragePad {
	idd=IDD_GARAGE_PAD;
	name="GaragePad";
	movingEnabled=true;
	enableSimulation=1;
	onLoad="uiNamespace setVariable ['GaragePad',_this select 0]";
	onUnLoad="call onGaragePadUnLoad";
	class controlsBackground {
		class Background: DialogBackground {ctrlBound(0.35,0.25,0.3,0.53);};
		class Title: DialogTitle {text="Настройка площадки";ctrlBound(0.35,0.25,0.3,0.03);};
		class Head1: Life_RscText {idc=-1;text="Параметры";ctrlBound(0.36,0.29,0.20,0.03);};
		class Head2 : Life_RscText {idc=-1;text="Поиск пола";ctrlBound(0.57,0.29,0.12,0.03);};
		class StatusText: StatusT {idc=2901;ctrlBound(0.35,0.75,0.3,0.03);};
	};
	class controls {
		class Btn1 : Zupa_RscButtonMenu {
			idc=2902;text="";ctrlBound(0.36,0.33,0.20,0.03);
			onButtonClick="[0,0] call OnPadChange";
		};
		class Btn2 : Zupa_RscButtonMenu {
			idc=2903;text="";ctrlBound(0.36,0.37,0.20,0.03);
			onButtonClick="[1,0] call OnPadChange";
		};
		class Btn3 : Zupa_RscButtonMenu {
			idc=2904;text="";ctrlBound(0.36,0.41,0.20,0.03);
			onButtonClick="[2,0] call OnPadChange";
		};
		class Btn4 : Zupa_RscButtonMenu {
			idc=2905;text="";ctrlBound(0.36,0.45,0.20,0.03);
			onButtonClick="[3,0] call OnPadChange";
		};
		class Btn5 : Zupa_RscButtonMenu {
			idc=2906;text="";ctrlBound(0.36,0.49,0.20,0.03);
			onButtonClick="[4,0] call OnPadChange";
		};
		class Btn6 : Zupa_RscButtonMenu {
			idc=2907;text="";ctrlBound(0.36,0.53,0.20,0.03);
			onButtonClick="[5,0] call OnPadChange";
		};
		class Btn7 : Zupa_RscButtonMenu {
			idc=2908;text="";ctrlBound(0.36,0.57,0.20,0.03);
			onButtonClick="[6,0] call OnPadChange";
		};
		class Btn8 : Zupa_RscButtonMenu {
			idc=2909;text="";ctrlBound(0.36,0.61,0.20,0.03);
			onButtonClick="[7,0] call OnPadChange";
		};
		class Btn01 : Zupa_RscButtonMenu {
			idc=2922;text="";ctrlBound(0.57,0.33,0.07,0.03);
			onButtonClick="[0,1] call OnPadChange";
		};
		class Btn02 : Zupa_RscButtonMenu {
			idc=2923;text="";ctrlBound(0.57,0.37,0.07,0.03);
			onButtonClick="[1,1] call OnPadChange";
		};
		class Btn03 : Zupa_RscButtonMenu {
			idc=2924;text="";ctrlBound(0.57,0.41,0.07,0.03);
			onButtonClick="[2,1] call OnPadChange";
		};
		class Btn04 : Zupa_RscButtonMenu {
			idc=2925;text="";ctrlBound(0.57,0.45,0.07,0.03);
			onButtonClick="[3,1] call OnPadChange";
		};
		class Btn05 : Zupa_RscButtonMenu {
			idc=2926;text="";ctrlBound(0.57,0.49,0.07,0.03);
			onButtonClick="[4,1] call OnPadChange";
		};
		class Btn06 : Zupa_RscButtonMenu {
			idc=2927;text="";ctrlBound(0.57,0.53,0.07,0.03);
			onButtonClick="[5,1] call OnPadChange";
		};
		class Btn07 : Zupa_RscButtonMenu {
			idc=2928;text="";ctrlBound(0.57,0.57,0.07,0.03);
			onButtonClick="[6,1] call OnPadChange";
		};
		class Btn08 : Zupa_RscButtonMenu {
			idc=2929;text="";ctrlBound(0.57,0.61,0.07,0.03);
			onButtonClick="[7,1] call OnPadChange";
		};
		class CloseBtn : Zupa_RscButtonMenu {text="Закрыть";ctrlBound(0.44,0.71,0.12,0.03);onButtonClick="closeDialog 0";};
	};
};
