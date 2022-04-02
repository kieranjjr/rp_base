#include <a_samp>
#include <fixes>
#include <a_mysql>
#include <samp_bcrypt>
#include <eSelection>
#include <izcmd>
#include <easyDialog>
#include <sscanf2>


// Main Server Includes
#include "\modules\main\functions.pwn"
#include "\modules\main\mysql.pwn"
#include "\modules\main\enums.pwn"
#include "\modules\main\bayside.pwn"
// Character Draws
#include "\modules\player\character\textdraws.pwn"

new
	MySQL: SQL_Handle
;

main() { }

public OnGameModeInit() {
	
	SetGameModeText(MODEVERSION);
	CreateMainTextDraws();
	CreateObjects();
	
	SQL_Handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
	if(mysql_errno() != 0) {
		print("SQL ERROR: Could not connect to SQL.");
		SendRconCommand("exit");
		return 1;
    }
	print("SERVER: MySQL Connection was successful.");

	ClearConsole();
	return 1;
}

public OnGameModeExit() {
	mysql_close(SQL_Handle);
	return 1;
}

// Master Account Includes
#include "\modules\player\master\commands.pwn"
#include "\modules\player\master\login.pwn"
#include "\modules\player\master\register.pwn"
#include "\modules\player\master\save_load.pwn"
#include "\modules\player\master\camera.pwn"
// Character Account Includes
#include "\modules\player\character\load.pwn"
#include "\modules\player\character\character.pwn"

public OnPlayerConnect(playerid) {
	
  	//CharacterInfo[playerid] = CharacterInfo[playerid];
  	//E_MASTER_INFO[playerid] = E_MASTER_INFO[playerid];
  	SetPlayerColor(playerid, -1);
  	RemoveBuildings(playerid);

	if(IsRPName(GetName(playerid))) 
	{
		SendClientMessage(playerid, -1, "** We use a character system on this server, please relog with a more appropriate nickname.");
		SendClientMessageEx(playerid, -1, "** Once you have registered, you will then be able to create your characters name EG: %s", GetRPName(playerid));
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	} 
	else 
	{
		new query[76];
		mCamera(playerid);
		mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `master` WHERE `Username` = '%e'", GetName(playerid));
		mysql_tquery(SQL_Handle, query, "CheckMasterAccount", "d", playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason) 
{
	if(MasterInfo[playerid][mLogged] == true) {
		SaveMasterAccount(playerid);
	} else if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
		SaveCharacter(playerid);
		SaveMasterAccount(playerid);
	} else return printf("%d - %s | Who the fuck is this guy? | %s", playerid, GetName(playerid), reason);

	return 1;
}

public OnPlayerText(playerid, text[]) 
{
	if(CharacterInfo[playerid][cSpawned] == false) 
	{
		SendClientMessage(playerid, -1, "SERVER:- You need to be spawned first.");
		return 0;
	}
	return 1;
}