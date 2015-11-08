class DoorManagement:AccessManagement {
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
		class PlayerBTN: AccessBTN {idc=7020;y=SY(0.36);onButtonClick="[0] call OnAccessChange";};
		class OpenBTN: AccessBTN {idc=7021;y=SY(0.4);onButtonClick="[1] call OnAccessChange";};
	};
};
