/*-----------------------------*/
// Created by Raymix
// Last update - August 21 2014
/*-----------------------------*/


class SnapBuilding {
	//Barriers whitelist
	class Barrier {
		snapTo[] = {
			"Land_HBarrier5_DZ",
			"Land_HBarrier3_DZ",
			"Land_HBarrier1_DZ",
			"Sandbag1_DZ",
			"BagFenceRound_DZ",
			"Fort_RazorWire"
		};
		radius = 5;
	};
	//snap points
	class Land_HBarrier5Preview: Barrier{ //fix for broken offsets in ghost
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.75,0.1,"Задняя"},
		{0,0.75,0.1,"Передняя"},
		{-2.85,0,0.1,"Левая"},
		{2.85,0,0.1,"Правая"},
		{0,0,0.9,"Верхняя"}
		};
	};
	class Land_HBarrier5_DZ: Land_HBarrier5Preview {
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.75,0,"Задняя"},
		{0,0.75,0,"Передняя"},
		{-2.85,0,0,"Левая"},
		{2.85,0,0,"Правая"},
		{0,0,0.9,"Верхняя"}
		};
	}; 
	
	class Land_HBarrier3ePreview: Barrier { //whitelist inheritance
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.75,0,"Задняя"},
		{0,0.75,0,"Передняя"},
		{-1.7,0,0,"Левая"},
		{1.7,0,0,"Правая"},
		{0,0,0.9,"Верхняя"}
		};
	};
	class Land_HBarrier3_DZ: Land_HBarrier3ePreview{}; //point inheritance

	class Land_HBarrier1Preview: Barrier {
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.75,0,"Задняя"},
		{0,0.75,0,"Передняя"},
		{-0.6,0,0,"Левая"},
		{0.6,0,0,"Правая"},
		{0,0,0.9,"Верхняя"}
		};
	};
	class Land_HBarrier1_DZ: Land_HBarrier1Preview{};
		
	class Fort_RazorWirePreview: Barrier {
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.95,-0.3,"Задняя"},
		{0,0.95,-0.3,"Передняя"},
		{-4.1,0,-0.3,"Левая"},
		{4.1,0,-0.3,"Правая"},
		{0,0,1,"Верхняя"}
		};
	};
	class Fort_RazorWire: Fort_RazorWirePreview {};
	
	class Sandbag1_DZ: Barrier {
		points[] = {
		{0,0,0,"Нижняя"},
		{-1.5,0,0,"Левая"},
		{1.5,0,0,"Правая"},
		{0,0,0.4,"Верхняя"}
		};
	};
	
	class BagFenceRound_DZ: Barrier {
		points[] = {
		{0,0,0,"Нижняя"},
		{-1.295,0.38,0,"Левая"},
		{1.295,0.38,0,"Правая"},
		{0,0,0.4,"Верхняя"}
		};
	};
	
	//Snapping whitelists for Floors, walls and stairs
	class FloorsWallsStairs {
		snapTo[] = {
			"WoodFloorQuarter_DZ",
			"WoodFloorHalf_DZ",
			"WoodFloor_DZ",
			"WoodStairs_DZ",
			"WoodStairsSans_DZ",
			"WoodSmallWallDoor_DZ",
			"WoodSmallWall_DZ",
			"WoodSmallWallWin_DZ",
			"Land_DZE_WoodDoor",
			"Land_DZE_WoodDoorLocked",
			"WoodLargeWall_DZ",
			"Land_DZE_LargeWoodDoor",
			"WoodLargeWallWin_DZ",
			"WoodLargeWallDoor_DZ",
			"Land_DZE_GarageWoodDoor",
			"Land_DZE_GarageWoodDoorLocked",
			"Land_DZE_LargeWoodDoorLocked",
			"WoodSmallWallThird_DZ",
			"CinderWall_DZ",
			"CinderWallDoorway_DZ",
			"CinderWallDoorLocked_DZ",
			"CinderWallDoor_DZ",
			"CinderWallSmallDoorway_DZ",
			"CinderWallDoorSmallLocked_DZ",
			"CinderWallHalf_DZ",
			"CinderWallDoorSmall_DZ",
			"MetalFloor_DZ"
		};
		radius = 7;
	};
	
	class WoodFloorQuarter_Preview_DZ: FloorsWallsStairs { //fix for broken offsets in ghost
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-1.23,0,"Задняя"},
		{0,1.23,0,"Передняя"},
		{-1.24,0,0,"Левая"},
		{1.24,0,0,"Правая"}
		};
	};
	
	class WoodFloorQuarter_DZ: FloorsWallsStairs { 
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-1.23,0.137726,"Задняя"},
		{0,1.23,0.137726,"Передняя"},
		{-1.24,0,0.137726,"Левая"},
		{1.24,0,0.137726,"Правая"}
		};
	};
	
	class WoodFloorHalf_Preview_DZ: FloorsWallsStairs { //fix for broken offsets in ghost
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-2.34,0,"Задняя"},
		{0,2.34,0,"Передняя"},
		{-1.25,0,0,"Левая"},
		{1.25,0,0,"Правая"}
		};
	};
	class WoodFloorHalf_DZ: FloorsWallsStairs{
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-2.34,0.1407,"Задняя"},
		{0,2.34,0.1407,"Передняя"},
		{-1.25,0,0.1407,"Левая"},
		{1.25,0,0.1407,"Правая"}
		};
	};
	
	class WoodFloor_Preview_DZ: FloorsWallsStairs {
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-2.33,0.130,"Задняя"},
		{0,2.33,0.130,"Передняя"},
		{-2.495,0,0.130,"Левая"},
		{2.495,0,0.130,"Правая"}
		};
		radius = 10;
	};
	class WoodFloor_DZ: WoodFloor_Preview_DZ{};
	
	class Stairs_DZE: FloorsWallsStairs {
		points[] = {
		{0,0,0,"Нижняя"},
		{1.56055,-0.78,1.5,"Задняя"},
		{1.56055,0.78,1.5,"Передняя"},
		{1.73926,0.05,2.9,"Верхняя"},
		{-1.73926,0.05,0,"Нижняя2"}
		};
	};
	class WoodStairs_DZ: Stairs_DZE {};
	class WoodStairs_Preview_DZ: Stairs_DZE {};
	class WoodStairsSans_Preview_DZ: Stairs_DZE {};
	class WoodStairsSans_DZ: Stairs_DZE {};

	class WoodSmall_DZE: FloorsWallsStairs { // Small wood walls
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.285, 0, 1.5,"Левая"},
		{2.285, 0, 1.5,"Правая"},
		{0, 0, 3,"Верхняя"}
		};
	};
	class WoodSmallWallDoor_Preview_DZ: WoodSmall_DZE {};
	class WoodSmallWall_Preview_DZ: WoodSmall_DZE {};
	class WoodSmallWallWin_Preview_DZ: WoodSmall_DZE {};
	class WoodSmallWallDoor_DZ: WoodSmall_DZE {};
	class WoodSmallWall_DZ: WoodSmall_DZE {};
	class WoodSmallWallWin_DZ: WoodSmall_DZE {};
	class Land_DZE_WoodDoor: WoodSmall_DZE {};
	class Land_DZE_WoodDoorLocked: WoodSmall_DZE {};
	class WoodDoor_Preview_DZ: WoodSmall_DZE{};
	
	class WoodLarge_DZE: FloorsWallsStairs { //Large wood walls
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.45, 0, 1.5,"Левая"},
		{2.45, 0, 1.5,"Правая"},
		{0, 0, 3,"Верхняя"}
		};
	};
	class WoodLargeWall_Preview_DZ: WoodLarge_DZE {};
	class WoodLargeWallWin_Preview_DZ: WoodLarge_DZE {};
	class WoodLargeWallDoor_Preview_DZ: WoodLarge_DZE {};
	class WoodSmallWallThird_Preview_DZ: WoodLarge_DZE {
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.445, 0, 1.5,"Левая"},
		{2.445, 0, 1.5,"Правая"},
		{0, 0, 1.17,"Верхняя"}
		};
	};
	class WoodSmallWallThird_DZ: WoodSmallWallThird_Preview_DZ{};
	class WoodLargeWall_DZ: WoodLarge_DZE {};
	class Land_DZE_LargeWoodDoor: WoodLarge_DZE {};
	class WoodLargeWallWin_DZ: WoodLarge_DZE {};
	class WoodLargeWallDoor_DZ: WoodLarge_DZE {};
	class Land_DZE_GarageWoodDoor: WoodLarge_DZE {};
	class GarageWoodDoor_Preview_DZ: WoodLarge_DZE {};
	class Land_DZE_GarageWoodDoorLocked: WoodLarge_DZE {};
	class Land_DZE_LargeWoodDoorLocked: WoodLarge_DZE {};
	class LargeWoodDoor_Preview_DZ: WoodLarge_DZE {};
	
	class Cinder_DZE: FloorsWallsStairs { //All cinder walls and doors
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.752, 0, 1.5,"Левая"},
		{2.752, 0, 1.5,"Правая"},
		{0, 0, 3.37042,"Верхняя"}
		};
		radius = 10;
	};
	class CinderWall_Preview_DZ: Cinder_DZE {};
	class CinderWallDoorway_Preview_DZ: Cinder_DZE {};
	class CinderWallSmallDoorway_Preview_DZ: Cinder_DZE {}; 
	class CinderWallHalf_Preview_DZ: Cinder_DZE {
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.752, 0, 1.5,"Левая"},
		{2.752, 0, 1.5,"Правая"},
		{0, 0, 1.5,"Верхняя"}
		};
	};
	class CinderWall_DZ: Cinder_DZE {};
	class CinderWallDoorway_DZ: Cinder_DZE {};
	class CinderWallDoorLocked_DZ: Cinder_DZE {};
	class CinderWallDoor_DZ: Cinder_DZE {};
	class CinderWallSmallDoorway_DZ: Cinder_DZE {};
	class CinderWallDoorSmallLocked_DZ: Cinder_DZE {};
	class CinderWallHalf_DZ: Cinder_DZE {
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.752, 0, 1.5,"Левая"},
		{2.752, 0, 1.5,"Правая"},
		{0, 0, 1.5,"Верхняя"}
		};
	};
	class CinderWallDoorSmall_DZ: Cinder_DZE {};
	
	class MetalFloor_Preview_DZ: FloorsWallsStairs { //fix for broken offsets in ghost
		points[] = {
		{0,0,0.011,"Нижняя"},
		{0, -2.64, 0.009,"Задняя"},
		{0, 2.64, 0.009,"Передняя"},
		{-2.64, 0, 0.009,"Левая"},
		{2.64, 0, 0.009,"Правая"}
		};
		radius = 12;
	};
	class MetalFloor_DZ: FloorsWallsStairs{
		points[] = {
		{0,0,0,"Нижняя"},
		{0, -2.64, 0.15,"Задняя"},
		{0, 2.64, 0.15,"Передняя"},
		{-2.64, 0, 0.15,"Левая"},
		{2.64, 0, 0.15,"Правая"}
		};
		radius = 12;
	};
	
	
	//Non essential Items that only snap to themselves, do whitelist inheritance if you want these to snap
	class WoodCrate_DZ {
		snapTo[] = {
			"WoodCrate_DZ"
		};
		radius = 5;
		points[] = {
		{0,0,0,"Нижняя"},
		{0,-0.47,0,"Задняя"},
		{0,0.47,0,"Передняя"},
		{-0.47,0,0,"Левая"},
		{0.47,0,0,"Правая"},
		{0,0,0.47,"Верхняя"}
		};
	};
		
	class MetalPanel_DZ {
		snapTo[] = {
			"MetalPanel_DZ"
		};
		radius = 5;
		points[] = {
		{0,0,0,"Нижняя"},
		{-1.5,0,0,"Левая"},
		{1.5,0,0,"Правая"}
		};
	};
	
		class MetalGate_DZ {
		snapTo[] = {
			"MetalGate_DZ"
		};
		radius = 5;
		points[] = {
		{0,0,0,"Нижняя"},
		{-4.1,0,0,"Левая"}
		};
	};
	
	class StickFence_DZ {
		snapTo[] = {
			"StickFence_DZ"
		};
		radius = 10;
		points[] = {
		{0,0,0,"Нижняя"},
		{-2.95,0,0.3,"Левая"},
		{2.95,0,0.3,"Правая"}
		};
	};
	
	class Fence_corrugated_DZ {
		snapTo[] = {
			"Fence_corrugated_DZ"
		};
		radius = 10;
		points[] = {
		{0,0,0,"Нижняя"},
		{-1.95,0,0.88,"Левая"},
		{1.95,0,0.88,"Правая"}
		};
	};
	
	class WoodRamp_Preview_DZ {
		snapTo[] = {
			"WoodRamp_DZ"
		};
		radius = 7;
		points[] = {
		{0,0,0,"Нижняя"},
		{0.65,-1.7,1.2,"Задняя"},
		{0.65,1.5,1.2,"Передняя"},
		{3.34,-0.115,2.82,"Верхняя"}
		};
	};
	class WoodRamp_DZ: WoodRamp_Preview_DZ{};
	
	class WoodLadder_Preview_DZ {
		snapTo[] = {
			"WoodLadder_DZ"
		};
		radius = 5;
		points[] = {
		{0,0,0,"Нижняя"},
		{-0.4,0,1.725,"Левая"},
		{0.4,0,1.725,"Правая"}
		};
	};
	class WoodLadder_DZ: WoodLadder_Preview_DZ{};
	
	class VaultStorageLocked {
		snapTo[] = {
			"VaultStorageLocked",
			"VaultStorage"
		};
		radius = 5;
		points[] = {
		{0,0,0,"Нижняя"},
		{0,0.284,0.615,"Задняя"},
		{0,0,1.23,"Верхняя"},
		{-0.362,0,0.615,"Левая"},
		{0.362,0,0.615,"Правая"}
		};
		
	};
	class VaultStorage: VaultStorageLocked {};
};