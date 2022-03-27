#include <a_samp>
#include <a_mysql>
#include <samp_bcrypt>
#include <izcmd>
#include <easyDialog>
//#include <Pawn.Regex>
#include <sscanf2>

// Main Server Includes
#include "\modules\server\functions.pwn"
#include "\modules\server\mysql.pwn"
#include "\modules\server\enums.pwn"
#include "\modules\server\bayside.pwn"
//#include "\modules\server\gender.pwn"

// Character Draws
#include "\modules\character\textdraws.pwn"



new
	MySQL: SQL_Handle
;

main() {
	print("Shadow_'s base RP mode");
}

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
	return 1;
}

public OnGameModeExit() {
	mysql_close(SQL_Handle);
	return 1;
}

// Master Account Includes
#include "\modules\master\commands.pwn"
#include "\modules\master\login.pwn"
#include "\modules\master\register.pwn"
#include "\modules\master\save_load.pwn"
#include "\modules\master\camera.pwn"
// Character Account Includes
#include "\modules\character\load.pwn"
#include "\modules\character\character.pwn"

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
	SaveMasterAccount(playerid);
	SaveCharacter(playerid);
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