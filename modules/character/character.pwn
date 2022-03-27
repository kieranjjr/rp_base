public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	print("-d11");
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	
	new query[128];
	if(playertextid == characterone) {
		if(CharacterInfo[playerid][cID][0] > 0) {
			CharacterInfo[playerid][cLoggedID] = CharacterInfo[playerid][cID][0];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM characters WHERE charID = '%d' LIMIT 1", CharacterInfo[playerid][cID][0]);
    		mysql_tquery(SQL_Handle, query, "LoadCharacterStats", "d", playerid);
    		printf("%d playerid | %d char id", playerid, CharacterInfo[playerid][cID][0]);
    	} else return CreateCharacter(playerid);
	} else if(playertextid == charactertwo) {
		if(CharacterInfo[playerid][cID][1] > 0) {

			CharacterInfo[playerid][cLoggedID] = CharacterInfo[playerid][cID][1];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM characters WHERE charID = '%d' LIMIT 1", CharacterInfo[playerid][cID][1]);
    		mysql_tquery(SQL_Handle, query, "LoadCharacterStats", "d", playerid);
		} else return CreateCharacter(playerid);
	} else if(playertextid == characterthree) {
		if(CharacterInfo[playerid][cID][2] > 0) {
			CharacterInfo[playerid][cLoggedID] = CharacterInfo[playerid][cID][2];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM characters WHERE charID = '%d' LIMIT 1", CharacterInfo[playerid][cID][2]);
    		mysql_tquery(SQL_Handle, query, "LoadCharacterStats", "d", playerid);
		} else return CreateCharacter(playerid);
	} else {
		SendClientMessage(playerid, -1, "who fucking knows");
	}
	return 1;
}

forward LoadCharacterStats(playerid);
public LoadCharacterStats(playerid) {
	if(MasterInfo[playerid][mLogged]) {

		CharacterInfo[playerid][cLogged] = true;

		new cNameSet[MAX_PLAYER_NAME];
		cache_get_value_name(0, "Name", cNameSet);
		cache_get_value_name_int(0, "Skin", CharacterInfo[playerid][cSkin]);
		cache_get_value_name_float(0, "PosX", CharacterInfo[playerid][cPosX]);
		cache_get_value_name_float(0, "PosY",CharacterInfo[playerid][cPosY]);
		cache_get_value_name_float(0, "PosZ",CharacterInfo[playerid][cPosZ]);
		cache_get_value_name_float(0, "Rot", CharacterInfo[playerid][cRot]);

	
		SetPlayerName(playerid, cNameSet);

		CancelSelectTextDraw(playerid);
		DestroyCharacterDraws(playerid);

		SpawnCharacter(playerid);
		
	} else {
		SendClientMessage(playerid, -1, "SERVER: Something went wrong, please contact an administrator");
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	}
	return 1;
}

CreateCharacter(playerid) {
	if(CharacterInfo[playerid][cID][1] > 0) {
		ShowCharacterDraws(playerid);
		SendClientMessage(playerid, -1, "SERVER:- You've already created three characters.");
	} else {
		CancelSelectTextDraw(playerid);
		HideCharacterDraws(playerid);
		Dialog_Show(playerid, DIALOG_CREATECHARACTER, DIALOG_STYLE_INPUT, "Character Creation", "Please enter your new character name, ensure that its in an RP style (John_Doe).", "Create", "Cancel");
	}
	return 1;
}

Dialog:DIALOG_CREATECHARACTER(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!IsRPName(inputtext)) {
			SendClientMessage(playerid, -1, "SERVER:- Please enter a username that includes atleast one underscore in the Firstname_Lastname format.");
			Dialog_Show(playerid, DIALOG_CREATECHARACTER, DIALOG_STYLE_INPUT, "Character Creation", "Please enter your new character name, ensure that its in an RP style (John_Doe).", "Create", "Cancel");
		} else {
			new query[76];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `characters` WHERE `Name` = '%e'", inputtext);
			mysql_tquery(SQL_Handle, query, "CheckCharacterCreation", "ds", playerid, inputtext);
		}
	} else {
		ShowCharacterDraws(playerid);
		SelectTextDraw(playerid, 2422422420);
		SendClientMessage(playerid, -1, "SERVER:- You cancelled.");
	}
	return 1;
}

forward CheckCharacterCreation(playerid, charname[]);
public CheckCharacterCreation(playerid, charname[]) { 
	if(cache_num_rows()) {
		SendClientMessage(playerid, -1, "SERVER:- That name is already taken.");
		Dialog_Show(playerid, DIALOG_CREATECHARACTER, DIALOG_STYLE_INPUT, "Character Creation", "Please enter your new character name, ensure that its in an RP style (John_Doe).", "Create", "Cancel");
	} else {
		new query[52];

		SetPlayerName(playerid, charname);
		mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `character` (`Name` ) VALUES ('%e')", charname);
		mysql_query(SQL_Handle, query);

		Dialog_Show(playerid, DIALOG_MALEFEMALE, DIALOG_STYLE_LIST, "Please select your appropriate sex", "Androgynous\nAgender\nBigender\nGender dysphoria\nGenderqueer\nIntersex\nNonbinary\nTransgender\nTrans\nTransitioning\nTranssexual\nTrans man\nTrans woman\nMale\nFemale", "Select", "");
		printf("%d | Created character %s.", playerid, charname);
	}
	return 1;
}

CMD:gendertest(playerid, params[]) { 
	Dialog_Show(playerid, DIALOG_MALEFEMALE, DIALOG_STYLE_LIST, "Please select your appropriate sex", "Androgynous\nAgender\nBigender\nGender dysphoria\nGenderqueer\nIntersex\nNonbinary\nTransgender\nTrans\nTransitioning\nTranssexual\nTrans man\nTrans woman\nMale\nFemale", "Select", "");
	return 1;
}

CMD:gmx(playerid, params[]) {
	SetPlayerName(playerid, "kieranjjr");
	SendRconCommand("gmx");
	return 1;
}

Dialog:DIALOG_MALEFEMALE(playerid, response, listitem, inputtext[]) {
	if(response) {
		CharacterInfo[playerid][cGender] = listitem;
		printf("%d | %s | %d Gender", playerid, GetName(playerid), CharacterInfo[playerid][cGender]);
		SendClientMessageEx(playerid, -1, "%s", ReturnGender(playerid));
	}
	return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Please input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
}

Dialog:DIALOG_DOB(playerid, response, listitem, inputtext[]) {
	if(response) {
		new
			day,
			month,
			year;

	    static const
	        arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

	    if(sscanf(inputtext, "p</>ddd", day, month, year)) return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:- Invalid format.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
		else if (year < 1900 || year > 2006) return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:- Invalid Year.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
		else if (month < 1 || month > 12) return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:-Invalid Month.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
		else if (day < 1 || day > arrMonthDays[month - 1])  return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:- Invalid Day.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");

		format(CharacterInfo[playerid][cDOB], 24, inputtext);
		SendClientMessageEx(playerid, -1, "Character Created - %s, %s, %s", GetRPName(playerid), CharacterInfo[playerid][cDOB], ReturnGender(playerid));
		CharacterInfo[playerid][cFirstSpawn] = true;
	}
	return 1;
}

SpawnCharacter(playerid) {

	if(CharacterInfo[playerid][cFirstSpawn] == false) {
		SetSpawnInfo(
			playerid, 0, 
			CharacterInfo[playerid][cSkin], 
			CharacterInfo[playerid][cPosX], 
			CharacterInfo[playerid][cPosY], 
			CharacterInfo[playerid][cPosZ], 
			CharacterInfo[playerid][cRot], 
			0, 0, 0, 0, 0, 0);

		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerSpectating(playerid, 0);
		CharacterInfo[playerid][cSpawned] = true;
	} else {
		SetSpawnInfo(
			playerid, 0, 
			CharacterInfo[playerid][cSkin], 
			CharacterInfo[playerid][cPosX], 
			CharacterInfo[playerid][cPosY], 
			CharacterInfo[playerid][cPosZ], 
			CharacterInfo[playerid][cRot], 
			0, 0, 0, 0, 0, 0);

		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerSpectating(playerid, 0);
		SendClientMessageEx(playerid, -1, "3Master Name %s", MasterInfo[playerid][mName]);
	}
	return 1;
}

SaveCharacter(playerid) {
	GetPlayerPos(playerid, 
		CharacterInfo[playerid][cPosX], 
		CharacterInfo[playerid][cPosY], 
		CharacterInfo[playerid][cPosZ]);
	GetPlayerFacingAngle(playerid, CharacterInfo[playerid][cRot]);

	new query[200];
	mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `characters` SET \
		`Name` = '%s', `Skin` = '%d', `PosX` = %f, `PosY` = %f,`PosZ` = %f, `Rot` = %f, `Gender` %s, `DOB` = %s, WHERE `charID` = '%i'",
		GetName(playerid),
		GetPlayerSkin(playerid),
		CharacterInfo[playerid][cPosX], 
		CharacterInfo[playerid][cPosY], 
		CharacterInfo[playerid][cPosZ],
		CharacterInfo[playerid][cRot],
		CharacterInfo[playerid][cGender],
		CharacterInfo[playerid][cDOB],
		CharacterInfo[playerid][cLoggedID]);
	mysql_query(SQL_Handle, query);
	printf("%d | %s | Character Saved", playerid, GetRPName(playerid));
	return 1;
}

public OnPlayerSpawn(playerid) {
	if(MasterInfo[playerid][mLogged] == false) {
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
		SendClientMessage(playerid, -1, "SERVER:- MasterFailed - Something went wrong, please contact an administrator");
	} else if(CharacterInfo[playerid][cLogged] == false && MasterInfo[playerid][mLogged] == true) {
		CreateCharacterDraws(playerid); // character/textdraws.pwn
		LoadCharacters(playerid);
	} else if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
		SendClientMessage(playerid, -1, "SERVER:- You have sucessfully spawned.");
		SendClientMessageEx(playerid, -1, "2Master Name %s", MasterInfo[playerid][mName]);
	} else {
		SendClientMessage(playerid, -1, "SERVER:- SPAWN- Something went wrong, please contact an administrator");
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	}

	SendClientMessageEx(playerid, -1, "1Master Name %s", MasterInfo[playerid][mName]);
	return 1;
}

ReturnGender(playerid)
{
	new str[18];
	switch(CharacterInfo[playerid][cGender])
	{
		case 0: str = "Androgynous";
		case 1: str = "Agender";
		case 2: str = "Bigender";
		case 3: str = "Gender dysphoria";
		case 4: str = "Genderqueer";
		case 5: str = "Intersex";
		case 6: str = "Nonbinary";
		case 7: str = "Transgender";
		case 8: str = "Trans";
		case 9: str = "Transitioning";
		case 10: str = "Transsexual";
		case 11: str = "Trans man";
		case 12: str = "Trans woman";
		case 13: str =  "Male";
		case 14: str = "Female";
	}
	return str;
}