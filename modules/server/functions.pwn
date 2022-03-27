forward KickTimer(playerid);
public KickTimer(playerid) {
	Kick(playerid);
	return 1;
}

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

// stock isRPName
IsRPName(const name[], max_underscores = 2) {
	new underscores = 0;
	
	if (name[0] < 'A' || name[0] > 'Z') return false;
	
	for(new i = 1; i < strlen(name); i++) {
		
		if(name[i] != '_' && (name[i] < 'A' || name[i] > 'Z') && (name[i] < 'a' || name[i] > 'z')) return false;

		if( (name[i] >= 'A' && name[i] <= 'Z') && (name[i - 1] != '_') ) return false;
		
		if(name[i] == '_') {
			underscores++;
			
			if(underscores > max_underscores || i == strlen(name)) return false;
			
			if(name[i + 1] < 'A' || name[i + 1] > 'Z') return false;
		}
	}
	if (underscores == 0) return false;
	
	return true;
}

//stock str_replace
str_replace(sSearch, sReplace, const sSubject[], &iCount = 0)
{
	#pragma unused iCount
	new sReturn[128];
	format(sReturn, sizeof(sReturn), sSubject);
	for(new i = 0; i < sizeof(sReturn); i++)
	{
		if(sReturn[i] == sSearch)
		{
			sReturn[i] = sReplace;
		}
	}
	return sReturn;
}

SendClientMessageEx(playerid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while(--args >= 3)
		{
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

ClearChat(playerid, lines)
{
	if (lines > 20 || lines < 1)
		return 0;
		
	for (new i = 0; i < lines; i++)
	{
		SendClientMessage(playerid, -1, " ");
	}
	return 1;
}

stock RandomNumberPlateString()
{
	new str[9];
	for(new c; c < 8; c++)
	{
		if(c<4)str[c] = 'A' + random(26);
		else if(c>4)str[c] = '0' + random(10);
		str[4] = ' ';
	}
	return str;
}

CMD:setname(playerid, params[]) {
	SetPlayerName(playerid, params);
	return 1;
}

/*
IsValidDOB(const dob[]) {
	static Regex:regex;
	if (!regex) regex = Regex_New("^[0-3]?[0-9]/[0-3]?[0-9]/(?:[0-9]{2})?[0-9]{2}$");

	return Regex_Check(dob, regex);
}*/