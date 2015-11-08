class CfgSounds
{
	sounds[] = {
		lock,brokeclothes,unlock,introsong,pda,radio_shum,gdrazatvor,gdrazatvor2,eat_chips,LowGear,q_lock,q_unlock
#include "localSoundItems.h"
	};
	class lock
	{
		name = "lock";
		sound[] = {\scripts\sounds\lock.ogg,0.8,1};
		titles[] = {};
	};

	class unlock
	{
		name = "unlock";
		sound[] = {\scripts\sounds\unlock.ogg,0.8,1};
		titles[] = {};
	};

	class brokeclothes
	{
		name="brokeclothes";
		sound[]={\scripts\sounds\brokeclothes.ogg,1,1};
		titles[] = {};
	};

	class introSong
	{
		name="introSong";
		sound[]={\scripts\sounds\introSong.ogg,0.9,1};
		titles[] = {};
	};

	class pda
	{
		name="pda";
		sound[]={\scripts\sounds\pda.ogg,0.9,1};
		titles[] = {};
	};

	class epipans
	{
		name="epipans";
		sound[]={\scripts\sounds\epipens.ogg,0.9,1};
		titles[] = {};
	};

	class paink_use
	{
		name="paink_use";
		sound[]={\scripts\sounds\painkiller.ogg,0.9,1};
		titles[] = {};
	};

	class gdrazatvor
	{
		name="gdrazatvor";
		sound[]={\scripts\sounds\gdrazatvor.ogg,0.5,1};
		titles[] = {};
	};

	class gdrazatvor2
	{
		name="gdrazatvor2";
		sound[]={\scripts\sounds\gdrazatvor2.ogg,0.5,1};
		titles[] = {};
	};

	class radio_shum
	{
		name="radio_shum";
		sound[]={\scripts\sounds\radio_shum.ogg,0.9,1};
		titles[] = {};
	};

	class eat_chips
	{
		name="eat_chips";
		sound[]={\scripts\sounds\eat_chips.ogg,0.9,1};
		titles[] = {};
	};

	class LowGear
	{
		name="LowGear.ogg";
		sound[]={\scripts\sounds\LowGear.ogg,0.9,1};
		titles[] = {};
	};
	class q_lock
	{
		name="q_lock";
		sound[]={\scripts\sounds\q_lock.ogg,0.1,1};
		titles[] = {};
	};

	class q_unlock
	{
		name="q_unlock";
		sound[]={\scripts\sounds\q_unlock.ogg,0.1,1};
		titles[] = {};
	};
#include "localSoundClass.h"
};
