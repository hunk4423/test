class ObjectComment {
	idd=3100;
	name="ObjectComment";
	movingEnabled=true;
	enableSimulation=1;
	class controlsBackground {
		class Background: DialogBackground {ctrlBound(0.4,0.42,0.2,0.15);};
		class Title: DialogTitle {idc=3101;text="Описание объекта";ctrlBound(0.4,0.42,0.2,0.03);};
	};
	class Controls {
		class Comment: TextEdit {idc=3102;ctrlBound(0.42,0.47,0.16,0.03);};
		class OkBtn : Zupa_RscButtonMenu {text="Сохранить";ctrlBound(0.42,0.53,0.08,0.03);onButtonClick="[selectedObject,(ctrlText 3102)] spawn object_setComment; (ctrlParent (_this select 0)) closeDisplay 0;";};
		class CloseBtn : Zupa_RscButtonMenu {text="Закрыть";ctrlBound(0.51,0.53,0.08,0.03);onButtonClick="(ctrlParent (_this select 0)) closeDisplay 1;";};
	};
};