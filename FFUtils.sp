#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo = {
	name = "FFUtils",
	author = "OPGman",
	description = "Utility for managing Freak Fortress rounds.",
	version = "2.0",
	url = "https://github.com/LambdaGaming/FFUtils"
};

static bool ModeOverride = false;

public void OnPluginStart()
{
	RegServerCmd( "ff_toggle", FFToggle );
	PrintToServer( "[FFUtils] Successfully loaded." );
}

public Action:FFToggle( int args )
{
	if ( IsFreakMap() )
	{
		SetRandomMap();
		ModeOverride = true;
		PrintToChatAll( "Freak Fortress has been disabled. Normal gameplay will resume on the next map change." );
	}
	else
	{
		SetFreakMap();
		ModeOverride = true;
		PrintToChatAll( "Freak Fortress has been enabled and will activate on the next map change." );
	}
}

public void OnMapEnd()
{
	if ( ModeOverride )
	{
		ModeOverride = false;
		return;
	}

	if ( IsFreakMap() )
	{
		SetFreakMap();
	}
	else
	{
		int rand = GetRandomInt( 1, 10 );
		if ( rand <= 10 )
			SetFreakMap();
		else
			SetRandomMap();
	}
}

public void OnClientPutInServer( int client )
{
	if ( IsFreakMap() )
		PrintToChat( client, "Freak Fortress is currently active. If you need the content, see the #links channel on our Discord: https://discord.gg/9RGdUS2" );
}

static bool IsFreakMap()
{
	char buffer[64];
	GetCurrentMap( buffer, sizeof( buffer ) );
	bool freakmap = StrContains( buffer, "arena", false ) >= 0 || StrContains( buffer, "vsh", false ) >= 0;
	return freakmap;
}

static void SetFreakMap()
{
	char MapList[][] = {
		"arena_badlands", "arena_byre", "arena_granary",
		"arena_lumberyard", "arena_lumberyard_event", "arena_nucleus",
		"arena_offblast_final", "arena_ravine", "arena_sawmill",
		"arena_watchtower", "arena_well", "vsh_shipment_v1a",
		"vsh_scp_3008_final3", "vsh_distillery", "vsh_nucleus",
		"vsh_skirmish", "vsh_tinyrock", "arena_perks", "vsh_maul",
		"vsh_outburst", "arena_afterlife"
	};
	
	int rand = GetRandomInt( 0, sizeof( MapList ) - 1 );
	SetNextMap( MapList[rand] );
}

static void SetRandomMap()
{
	char MapList[][] = {
		"cp_5gorge", "cp_badlands", "cp_coldfront", "cp_dustbowl",
		"cp_fastlane", "cp_foundry", "cp_gravelpit", "cp_granary",
		"cp_powerhouse", "cp_process_final", "cp_snakewater_final1",
		"cp_standin_final", "cp_yukon_final", "cp_well", "ctf_2fort",
		"ctf_2fort_invasion", "ctf_foundry", "ctf_gorge", "ctf_sawmill",
		"ctf_thundermountain", "ctf_turbine", "ctf_well"
	};
	
	int rand = GetRandomInt( 0, sizeof( MapList ) - 1 );
	SetNextMap( MapList[rand] );
}
