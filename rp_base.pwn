#include <open.mp>
#include <a_mysql>
#include <samp_bcrypt>
#include <izcmd>
#include <easyDialog>
#include <sscanf2>
#include <foreach>
#include <streamer>
#include <YSI_Coding\y_hooks>

// Main Server Includes

#include "/modules/server/mysql.pwn"
#include "/modules/server/defines.pwn"
#include "/modules/server/maps.pwn"
// Character Draws
#include "/modules/player/character/textdraws.pwn"
#include "/modules/player/main/enums.pwn"
#include "/modules/server/functions.pwn"
// Server Systems


#define MODEVERSION	"0.0.12"


new
	MySQL: SQL_Handle;

main() {
	print("------------------------------------------------------------------------------");
	print("                         kieranjjr's roleplay								 ");
	printf("				          V - %s 										     ", MODEVERSION);
	print("------------------------------------------------------------------------------");
}

public OnGameModeInit() {
	
	SetGameModeText(MODEVERSION);
	CreateMainTextDraws();

	DisableInteriorEnterExits();
	//ManualVehicleEngineAndLights();
	
	SQL_Handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
	if(mysql_errno() != 0) {
		print("SQL ERROR: Could not connect to SQL.");
		SendRconCommand("exit");
		return 1;  
    }
	print("SERVER: MySQL Connection was successful.");

	RetreiveHouseData();
	RetreiveBusinessData();
	RetreiveVehicleData();
	RetreivePropertyData();

	return 1;
}

public OnGameModeExit() {
	
	for(new i = 0; i < MAX_VEHICLES; i++) {
		if(VehicleInfo[i][vOwnerCID] == 0) {
			SaveVehicle(i);
            DestroyVehicle(VehicleInfo[i][vSession]);
            DestroyDynamic3DTextLabel(Text3D:VehicleInfo[i][vLabel]);
        }
    }



    mysql_close(SQL_Handle);
	return 1;
}

public OnPlayerConnect(playerid) {
	
	new rand = random(sizeof(MusicStations));
	PlayAudioStreamForPlayer(playerid, MusicStations[rand][0]);

   	memcpy(MasterInfo[playerid][E_MASTER_INFO:0], MasterInfo[playerid][E_MASTER_INFO:0], 0, sizeof(MasterInfo[])*4, sizeof(MasterInfo[]));
	memcpy(CharacterInfo[playerid][E_CHARACTER_INFO:0], CharacterInfo[playerid][E_CHARACTER_INFO:0], 0, sizeof(CharacterInfo[])*4, sizeof(CharacterInfo[]));
	CreatingMenu[playerid] = false;

   	SetPlayerColor(playerid, -1);

	if(IsRPName(GetName(playerid))) {
		SendClientMessage(playerid, -1, "** We use a character system on this server, please relog with a more appropriate nickname.");
		SendClientMessageEx(playerid, -1, "** Once you've registered, you will then be able to create your characters name EG: %s", GetRPName(playerid));
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	} else {
		new query[76];
		mCamera(playerid);
		mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `master` WHERE `Username` = '%e'", GetName(playerid));
		mysql_tquery(SQL_Handle, query, "CheckMasterAccount", "d", playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == false) {
		SaveMasterAccount(playerid);
	} else if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
		SaveCharacter(playerid);
		SaveMasterAccount(playerid);
	} else return printf("%d - %s | Left without logging in / registering | %s", playerid, GetName(playerid), reason);

	return 1;
}

public OnPlayerText(playerid, text[]) {
	if(CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You must login & spawn before talking.");

	new str[145];
	format(str, sizeof(str), "%s says %s", GetRPName(playerid), text);
	ProxDetector(20.0, playerid, str, HEX_WHITE);
	return 0;
}

// Master Account Includes
#include "/modules/player/master/commands.pwn"
#include "/modules/player/master/login.pwn"
#include "/modules/player/master/register.pwn"
#include "/modules/player/master/save_load.pwn"
#include "/modules/player/master/camera.pwn"
// Character Account Includes
#include "/modules/player/character/load.pwn"
#include "/modules/player/character/character.pwn"
// Server Systems
#include "/modules/systems/player.pwn"
#include "/modules/systems/houses.pwn"
#include "/modules/systems/businesses.pwn"
#include "/modules/systems/vehicles.pwn"
#include "/modules/systems/properties.pwn"
// Player Commands
#include "/modules/player/commands/pcmds.pwn"
#include "/modules/player/commands/admcmds.pwn"
#include "/modules/player/commands/syscmds.pwn"