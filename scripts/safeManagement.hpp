class SafeManagement:AccessManagement {
	class controlsBackground : controlsBackground {
		class Background:Background{};
		class TitleText:TitleText{};
		class OwnerText:OwnerText{};
		class NearText:NearText{};
		class FriendText:FriendText{};
		class AccessText:AccessText{};
		class InfoText:InfoText{};
		class StatusText:StatusText{};
	};
	class Controls : Controls {
		class NearList:NearList{};
		class FriendsList:FriendsList{};
		class AddBTN:AddBTN{};
		class DelBTN:DelBTN{};
		class CancelBTN:CancelBTN{};
		class ResetBTN:ResetBTN{};
		class ResetAllBTN:ResetAllBTN{};
		class ComBTN:ComBTN{};
		class AplyBTN:AplyBTN{};
		class FullBTN: AccessBTN {idc=7020;y=SY(0.36);onButtonClick="[0] call OnAccessChange";};
		class PlayerBTN: AccessBTN {idc=7021;y=SY(0.4);onButtonClick="[1] call OnAccessChange";};
		class OpenBTN: AccessBTN {idc=7022;y=SY(0.44);onButtonClick="[2] call OnAccessChange";};
		class PackBTN: AccessBTN {idc=7023;y=SY(0.6);text="Упаковать";onButtonClick="[2] call OnPackBtn";};
	};
};