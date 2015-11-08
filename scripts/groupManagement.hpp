class GroupManagement {

	idd = 55510;
	movingEnable = true;
	enableSimulation = true;
	
	class ControlsBackground {
		
		class MainBG : W_RscPicture {
			idc = -1;
			text = "\ca\ui\data\ui_background_controlers_ca.paa";		
			moving = true;
			x = .0; y = .1;
			w = 1.0; h = .65;
		};
		
		class MainTitle : W_RscText {
			idc = -1;
			text = "Управление группой";
			sizeEx = .04;
			shadow = 2;		
			x = .260; y = .112;
			w = .3; h = .05;
		};

		class InviteTitleText : W_RscText {
			idc = -1;
			text = "Игроки:";
			sizeEx = .025;
			shadow = 2;		
			x = .0875; y = .155;
			w = .3; h = .050;
		};

		class GroupTitleText : W_RscText {
			idc = -1;
			text = "Ваша группа:";
			sizeEx = .025;
			shadow = 2;		
			x = .5575; y = .155;
			w = .3; h = .050;
		};

		class InviteText: W_RscStructuredText
		{
			idc = 55520;
			text = "";
			size = .025;
			x = .255; y = .500;
			w = .235; h = .075;
		};
	};
	
	class controls {

		class PlayerListBox : W_RscList {
			idc = 55511;
			onLBSelChanged = "call playerSelectChange;";
			x = 0.020; y = 0.200;
			w = 0.235; h = 0.380;
		};
		
		class RefreshButton : W_RscButton {
			idc = -1;
			text = "Обновить";
			onButtonClick = "call updatePlayerList;";
			x = 0.08; y = 0.59;
			w = 0.125; h = 0.045 * safezoneH;
			color[] = {0.1,0.95,0.1,1};
		};
		
		class GroupListBox : W_RscList {
			idc = 55512;
			x = .490; y = .200;
			w = .235; h = .425;
		};

		class CloseButton : W_RscButton {
			idc = -1;
			text = "Закрыть";
			onButtonClick = "closeDialog 0;groupManagmentActive = false;";
			x = 0.02; y = 0.68;
			w = 0.125; h = 0.045 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class InviteButton : W_RscButton {
			idc = 55514;
			text = "Пригласить";
			onButtonClick = "call inviteToGroup;";
			x = 0.3075; y = 0.200;
			w = 0.147; h = 0.045 * safezoneH;
			color[] = {0.1,0.95,0.1,1};
		};

		class KickButton : W_RscButton {
			idc = 55515;
			text = "Исключить";
			onButtonClick = "call kickFromGroup;";
			x = 0.3075; y = 0.250;
			w = 0.147; h = 0.045 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class DisbandButton : W_RscButton {
			idc = 55516;
			text = "Расформировать";
			onButtonClick = "call disbandGroup;";
			x = 0.3075; y = 0.300;
			w = 0.147; h = 0.045 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class LeaveButton : W_RscButton {
			idc = 55517;
			text = "Покинуть группу";
			onButtonClick = "call leaveGroup;";
			x = 0.3075; y = 0.400;
			w = 0.147; h = 0.045 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class AcceptInviteButton : W_RscButton {
			idc = 55518;
			text = "Принять";
			onButtonClick = "call acceptGroupInvite;";
			x = 0.275; y = 0.625 - 0.0255 * safezoneH;
			w = 0.100; h = 0.045 * safezoneH;
			color[] = {0.1,0.95,0.1,1};
		};

		class DeclineInviteButton : W_RscButton {
			idc = 55519;
			text = "Отказаться";
			onButtonClick = "call declineGroupInvite;";
			x = 0.375; y = 0.625 - 0.0255 * safezoneH;
			w = 0.100; h = 0.045 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};
	};
};