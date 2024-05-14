forward KickTimer(playerid);
public KickTimer(playerid) {
	Kick(playerid);
	return 1;
}

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

GetName(playerid) {
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

GetRPName(playerid) {
	new name[MAX_PLAYER_NAME];
	strmid(name, str_replace('_', ' ', GetName(playerid)), 0, MAX_PLAYER_NAME);
	return name;
}

ReturnIP(playerid) {
	new PlayerIP[17];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	return PlayerIP;
}

str_replace(sSearch, sReplace, const sSubject[], &iCount = 0) {
	#pragma unused iCount
	new sReturn[128];
	format(sReturn, sizeof(sReturn), sSubject);
	for(new i = 0; i < sizeof(sReturn); i++) {
		if(sReturn[i] == sSearch) {
			sReturn[i] = sReplace;
		}
	}
	return sReturn;
}

stock debugmsg(const text[], {Float,_}:...) {
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3) {
	    foreach(new i : Player) {
	    	if(MasterInfo[i][mAdmin] >= 6) {
	    		SendClientMessage(i, -1, text);
	    	}
	    }
	    print(text);
	} else {
		while(--args >= 3) {
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		foreach(new i : Player) {
	    	if(MasterInfo[i][mAdmin] >= 6) {
	    		SendClientMessage(i, -1, text);
	    	}
	    }
		printf(str);

		#emit RETN
	}
	return 1;
}

SendClientMessageEx(playerid, color, const text[], {Float,_}:...) {
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3) {
	    SendClientMessage(playerid, color, text);
	} else {
		while(--args >= 3) {
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}
// From original The Godfather

SendAdminMessage(color, const text[], {Float,_}:...) {
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
	        if(MasterInfo[i][mLogged] == true && MasterInfo[i][mAdmin] > 0)
	        {
	    		SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
	        if(MasterInfo[i][mLogged] == true && MasterInfo[i][mAdmin] > 0)
	        {
	    		SendClientMessage(i, color, str);
			}
		}
		#emit RETN
	}
	return 1;
}

forward ProxDetector(Float:radi, playerid, string[], colour); public ProxDetector(Float:radi, playerid, string[], colour) {
    new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx, posy, posz);

   	foreach(new i : Player) {
        if(IsPlayerConnected(i)) {
		    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
		        if(IsPlayerInRangeOfPoint(i, radi, posx, posy, posz)) {
		            SendClientMessage(i, colour, string);
		        }
		    }
        }
    }
}

stock SpawnVehicleInfrontOfPlayer(playerid, vehiclemodel, color1, color2)
{
    new Float:x,Float:y,Float:z;
    new Float:facing;
    new Float:distance;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, facing);

    new Float:size_x,Float:size_y,Float:size_z;
    GetVehicleModelInfo(vehiclemodel, VEHICLE_MODEL_INFO_SIZE, size_x, size_y, size_z);

    distance = size_x + 0.5;

    x += (distance * floatsin(-facing, degrees));
    y += (distance * floatcos(-facing, degrees));

    facing += 90.0;
    if(facing > 360.0) facing -= 360.0;

    return CreateVehicle(vehiclemodel, x, y, z + (size_z * 0.25), facing, color1, color2, -1);
}


stock ClearChat(playerid, lines) {
	if (lines > 50 || lines < 1)
		return 0;
		
	for (new i = 0; i < lines; i++) {
		SendClientMessage(playerid, -1, " ");
	}
	return 1;
}

stock ClearConsole(lines = 25) {
	for(new i = 0, j = lines; i < j; ++i) {
		print(" ");
	}
}

stock RandomNumberPlate() {
	new str[9];
	for(new c; c < 8; c++) {
		if( c < 4) str[c] = 'A' + random(26);
		else if( c > 4) str[c] = '0' + random(10);
		str[4] = ' ';
	}
	return str;
}


stock IsPlayerInRangeOfHouse(playerid)
{
	for(new id = 0; id < MAX_HOUSES; id++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 3.0, cHouse[id][ExtX], cHouse[id][ExtY], cHouse[id][ExtZ]))
		{
			return id;
		}
	}
    return 0;
}

stock IsPlayerInRangeOfBusiness(playerid)
{
	for(new id = 0; id < MAX_BUSINESS; id++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 3.0, cBusiness[id][ExtX], cBusiness[id][ExtY], cBusiness[id][ExtZ]))
		{
			return id;
		}
	}
    return 0;
}

stock IsPlayerInRangeOfProperty(playerid)
{
	for(new id = 0; id < MAX_PROPERTY; id++)
	{
    	if(IsPlayerInRangeOfPoint(playerid, 3.0, sProperty[id][ExtX], sProperty[id][ExtY], sProperty[id][ExtZ]))
		{
			return id;
		}
	}
    return 0;
}

stock SetPlayerPosEx(playerid, Float:X, Float:Y, Float:Z, Float:R, interiorid, virtualworld) {
	//new Float:X, Float:Y, FLoat:Z, Float:R, interiorid, virtualworld;
	SetPlayerPos(playerid, X, Y, Z);
	SetPlayerFacingAngle(playerid, R);
	SetPlayerInterior(playerid, interiorid);
	SetPlayerVirtualWorld(playerid, virtualworld);
	TogglePlayerControllable(playerid, false);
	SetTimerEx("Unfreeze", 2000, false, "i", playerid);
	return 1;
}

forward Unfreeze(playerid);
public Unfreeze(playerid) {
	TogglePlayerControllable(playerid, true);
	return 1;
}

// Serverside Money

stock GiveServerMoney(playerid, money){
    CharacterInfo[playerid][cMoney] += money;
	GivePlayerMoney(playerid, money);
	return CharacterInfo[playerid][cMoney];
}

stock SetServerMoney(playerid, money) {
	CharacterInfo[playerid][cMoney] = money;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, CharacterInfo[playerid][cMoney]);
	return CharacterInfo[playerid][cMoney];
}

stock ResetServerMoney(playerid) {
    CharacterInfo[playerid][cMoney] = 0;
	ResetPlayerMoney(playerid);
	return CharacterInfo[playerid][cMoney];
}

stock GetServerMoney(playerid)
	return CharacterInfo[playerid][cMoney];

cNumber(integer, const separator[] = ",") { 

    new string[16]; 
    format(string, sizeof(string), "%i", integer);

    if(integer >= 1000) { 

        for(new i = (strlen(string) - 3); i > 0; i -= 3) { 

            strins(string, separator, i); 
        } 
    } 
    return string; 
}

ReturnVehicleModelID(Name[]) {

    for(new i; i != 211; i++) if(strfind(VehicleNames[i], Name, true) != -1) return i + 400;
    return INVALID_VEHICLE_ID;
}

new MusicStations[][] = 
{
	//{"http://live.powerhitz.com/hot108?aw_0_req.gdpr=true", "Hot 108 Jamz (hip hop)"},
	"http://live.powerhitz.com/hot108?aw_0_req.gdpr=true",			// Hot 108 Jamz (hip hop)
	"http://live.powerhitz.com/1power?aw_0_req.gdpr=true",			// 1Power (top 40/hip hop)	
	"http://live.powerhitz.com/officemix?aw_0_req.gdpr=true",		// Office Mix (soft pop)
	"http://live.powerhitz.com/hitlist?aw_0_req.gdpr=true",			// 	Hitlist (top 40)
	"http://live.powerhitz.com/realrnb?aw_0_req.gdpr=true",			// 	Real RnB (r&b hits)
	"http://live.powerhitz.com/bumpin?aw_0_req.gdpr=true",			//  Bumpin Classic Soul		
	"http://live.powerhitz.com/pureclassicrock?aw_0_req.gdpr=true", // 	Pure Classic Rock
	"http://live.powerhitz.com/timeblender?aw_0_req.gdpr=true", 	// 	Timeblender (classic hits)	
	"http://live.powerhitz.com/planet?aw_0_req.gdpr=true", 			// 	The Planet (alternative rock)	
	"http://live.powerhitz.com/70s?aw_0_req.gdpr=true", 			// 	Sensational 70's
	"http://live.powerhitz.com/ultimate80s?aw_0_req.gdpr=true", 	// 	Ultimate 80's
	"http://live.powerhitz.com/90sarea?aw_0_req.gdpr=true", 		// 	90's Area	
	"http://live.powerhitz.com/00s?aw_0_req.gdpr=true", 			// 	Double 00's (2000-2009)	
	"http://live.powerhitz.com/backbounce?aw_0_req.gdpr=true", 		// 	BackBounce (Old School)	
	"http://live.powerhitz.com/country?aw_0_req.gdpr=true", 		//  Total Country		
	"http://live.powerhitz.com/lovesongs?aw_0_req.gdpr=true", 		// 	The Heart (Love Songs)	
	"http://live.powerhitz.com/smoothjazz?aw_0_req.gdpr=true",		// 	Smoov (Smooth Jazz)	
	"http://live.powerhitz.com/gospel?aw_0_req.gdpr=true", 			// 	Glory 107 (Gospel)
	"http://live.powerhitz.com/xmas?aw_0_req.gdpr=true", 			// 	Christmas Hits
	"http://live.powerhitz.com/wild?aw_0_req.gdpr=true" 			// Wild 99 (Hispanic Rhythm)
};