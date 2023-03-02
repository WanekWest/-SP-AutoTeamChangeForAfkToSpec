#pragma semicolon 1
#pragma newdecls required
#include <sdkhooks>
#include <sdktools>

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = 
{
	name = "Team changer for Surf",
	author = "WanekWest",
	version 	= PLUGIN_VERSION,
	description = "Move afk player to spec after N sec.",
};

float TimeDelay = 10.0; //Через сколько секунд проверить игрока
Handle ClientTimer[MAXPLAYERS+1];

public void OnPluginStart()
{
    AddCommandListener(ClientSelectedTeam, "jointeam");
}

public void OnClientPostAdminCheck(int iClient)
{
    ClientTimer[iClient] = CreateTimer(TimeDelay, CheckClientTeam, iClient, TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientDisconnect(int iClient)
{
    if (iClient && ClientTimer[iClient] != null)
        delete ClientTimer[iClient];
}

Action CheckClientTeam(Handle hTimer, int iClient)
{
    if(IsClientConnected(iClient) && IsClientInGame(iClient) && ClientTimer[iClient] != null)
    {
        ChangeClientTeam(iClient, 1);
        ClientTimer[iClient] = null;
    }

    return Plugin_Continue;
}

public Action ClientSelectedTeam(int iClient, char[] command, int args)
{
    char team[2];
    GetCmdArg(1, team, sizeof(team));
    int currentClientTeam = StringToInt(team);

    if (iClient && args && ClientTimer[iClient] != null && (currentClientTeam > 0 || currentClientTeam < 4))
        delete ClientTimer[iClient];

    return Plugin_Continue;
}