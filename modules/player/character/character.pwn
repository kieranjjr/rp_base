public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	return 1;
}

new c_MaleSkins[185] = {
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	30, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60,
	61, 62, 66, 68, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102,
	103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
	121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146,
	147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171, 173, 174, 175, 176,
	177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 200, 202, 203, 204, 206,
	208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240,
	241, 242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289,
	290, 291, 292, 293, 294, 295, 296, 297, 299
};

new c_FemaleSkins[77] = {
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88,
	89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178,
	190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219,
	224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298
};

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	
	new query[128];
	if(playertextid == characterone) {
		if(CharacterInfo[playerid][cID][0] > 0) {
			CharacterInfo[playerid][cLoggedID] = CharacterInfo[playerid][cID][0];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM characters WHERE charID = '%d' LIMIT 1", CharacterInfo[playerid][cID][0]);
    		mysql_tquery(SQL_Handle, query, "LoadCharacterStats", "d", playerid);
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
		printf("SERVER: Something has gone wrong with %s's Character selection", GetName(playerid));
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	}
	return 1;
}

forward LoadCharacterStats(playerid);
public LoadCharacterStats(playerid) {
	if(MasterInfo[playerid][mLogged]) {

		CharacterInfo[playerid][cLogged] = true;

		new cNameSet[MAX_PLAYER_NAME];
		cache_get_value_name(0, "Name", cNameSet);
		cache_get_value_name_int(0, "Hours", CharacterInfo[playerid][cHours]);
		cache_get_value_name_int(0, "Skin", CharacterInfo[playerid][cSkin]);
		cache_get_value_name_float(0, "PosX", CharacterInfo[playerid][cPosX]);
		cache_get_value_name_float(0, "PosY",CharacterInfo[playerid][cPosY]);
		cache_get_value_name_float(0, "PosZ",CharacterInfo[playerid][cPosZ]);
		cache_get_value_name_float(0, "Rot", CharacterInfo[playerid][cRot]);
		cache_get_value_name_int(0, "Dice", CharacterInfo[playerid][cDice]);
		cache_get_value_name_int(0, "Money", CharacterInfo[playerid][cMoney]);
		cache_get_value_name_int(0, "Bank", CharacterInfo[playerid][cBank]);
		cache_get_value_name_int(0, "Savings", CharacterInfo[playerid][cSavings]);

		SetPlayerName(playerid, cNameSet);

		CancelSelectTextDraw(playerid);
		DestroyCharacterDraws(playerid);

		SpawnCharacter(playerid);
		new query[78];
		mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `vehicles` WHERE `OwnerCID` = '%d'", CharacterInfo[playerid][cLoggedID]);
    	mysql_tquery(SQL_Handle, query, "LoadPlayerVehicles", "i", playerid);
		
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
			SendClientMessage(playerid, -1, "SERVER: Please enter a username that includes atleast one underscore in the Firstname_Lastname format.");
			Dialog_Show(playerid, DIALOG_CREATECHARACTER, DIALOG_STYLE_INPUT, "Character Creation", "Please enter your new character name, ensure that its in an RP style (John_Doe).", "Create", "Cancel");
		} else {
			new query[76];
			mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `characters` WHERE `Name` = '%e'", inputtext);
			mysql_tquery(SQL_Handle, query, "CheckCharacterCreation", "ds", playerid, inputtext);
		}
	} else {
		ShowCharacterDraws(playerid);
		SelectTextDraw(playerid, 0xBDBEC6AA);
		SendClientMessage(playerid, -1, "SERVER: You cancelled.");
	}
	return 1;
}

forward CheckCharacterCreation(playerid, charname[]);
public CheckCharacterCreation(playerid, charname[]) { 
	if(cache_num_rows()) {
		SendClientMessage(playerid, -1, "SERVER:- That name is already taken.");
		Dialog_Show(playerid, DIALOG_CREATECHARACTER, DIALOG_STYLE_INPUT, "Character Creation", "Please enter your new character name, ensure that its in an RP style (John_Doe).", "Create", "Cancel");
	} else {
		SetPlayerName(playerid, charname);
		Dialog_Show(playerid, DIALOG_MALEFEMALE, DIALOG_STYLE_LIST, "Please select your appropriate sex", "Male\nFemale\nBigender\nGender dysphoria\nGenderqueer\nIntersex\nNonbinary\nTransgender\nTrans\nTransitioning\nTranssexual\nTrans man\nTrans woman\nAndrogynous\nAgender", "Select", "");
	}
	return 1;
}

Dialog:DIALOG_MALEFEMALE(playerid, response, listitem, inputtext[]) {
	if(response) {
		CharacterInfo[playerid][cGender] = listitem;
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
		else if (year < 1900 || year > 2004) return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:- Invalid Year.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
		else if (month < 1 || month > 12) return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:-Invalid Month.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");
		else if (day < 1 || day > arrMonthDays[month - 1])  return Dialog_Show(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Date of Birth", "Error:- Invalid Day.\n\nPlease input your date of birth in the (DD/MM/YYYY) format.", "Submit", "");

		format(CharacterInfo[playerid][cDOB], 24, inputtext);
		SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Character Created - %s, %s, %s", GetRPName(playerid), CharacterInfo[playerid][cDOB], ReturnGender(playerid));	
		Dialog_Show(playerid, DIALOG_SKIN, DIALOG_STYLE_MSGBOX, "Skin Selection", "Please pick either a 'male' or 'female' to have a random skin assigned.", "Male", "Female");
	}
	return 1;
}

Dialog:DIALOG_SKIN(playerid, response, listitem, inputtext[]) {
	if(response) {
		SetPlayerSkin(playerid, c_MaleSkins[random(185)]);
		CharacterInfo[playerid][cSkin] = GetPlayerSkin(playerid);
		FirstCharacterSpawn(playerid);
	} else {
		SetPlayerSkin(playerid, c_FemaleSkins[random(77)]);
		CharacterInfo[playerid][cSkin] = GetPlayerSkin(playerid);
		FirstCharacterSpawn(playerid);
	}
}

FirstCharacterSpawn(playerid) {

	new query[500];
	mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `characters` (`mID`, `Name`, `Skin`, `Gender`, `DOB`) VALUES ('%d', '%s', '%d', '%s', '%s')",
		MasterInfo[playerid][mUID],
		GetName(playerid),
		GetPlayerSkin(playerid),
		ReturnGender(playerid),
		CharacterInfo[playerid][cDOB]);
	mysql_tquery(SQL_Handle, query);

	SetSpawnInfo(
		playerid, 0, 
		CharacterInfo[playerid][cSkin], 
		1731.6465,
		-1911.9752,
		13.5625,
		87.6416,
		WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0);
	
	GiveServerMoney(playerid, 1000);
	CharacterInfo[playerid][cBank] = 14000;
	CharacterInfo[playerid][cSavings] = 5000;
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	TogglePlayerSpectating(playerid, false);
	StopAudioStreamForPlayer(playerid);
	CharacterInfo[playerid][cLogged] = true;
	DestroyCharacterDraws(playerid);
	SaveCharacter(playerid);
	printf("SERVER: %d | %s | %d (skin) | %s | %s | Character Spawned for the First Time.", playerid, GetName(playerid), GetPlayerSkin(playerid), ReturnGender(playerid), CharacterInfo[playerid][cDOB]);
}

SpawnCharacter(playerid) {

	SetSpawnInfo(
		playerid, 0, 
		CharacterInfo[playerid][cSkin], 
		CharacterInfo[playerid][cPosX], 
		CharacterInfo[playerid][cPosY], 
		CharacterInfo[playerid][cPosZ], 
		CharacterInfo[playerid][cRot], 
		WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0);
	
	GiveServerMoney(playerid, CharacterInfo[playerid][cMoney]);
	SetPlayerScore(playerid, CharacterInfo[playerid][cHours]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	TogglePlayerSpectating(playerid, false);
	StopAudioStreamForPlayer(playerid);
	CharacterInfo[playerid][cSpawned] = true;
	CharacterInfo[playerid][cLogged] = true;
	DestroyCharacterDraws(playerid);

	return 1;
}

SaveCharacter(playerid) {
	GetPlayerPos(playerid, 
		CharacterInfo[playerid][cPosX], 
		CharacterInfo[playerid][cPosY], 
		CharacterInfo[playerid][cPosZ]);
	GetPlayerFacingAngle(playerid, CharacterInfo[playerid][cRot]);

	new query[500];
	mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `characters` SET \
		`Hours` = '%d', `Skin` = '%d', `PosX` = '%f', `PosY` = '%f', `PosZ` = '%f', `Rot` = '%f', `Dice` = '%d', `Money` = '%d', `Bank` = '%d', `Savings` = '%d' WHERE `charID` = '%i'",
		CharacterInfo[playerid][cHours],
		GetPlayerSkin(playerid),
		CharacterInfo[playerid][cPosX], 
		CharacterInfo[playerid][cPosY], 
		CharacterInfo[playerid][cPosZ],
		CharacterInfo[playerid][cRot],
		CharacterInfo[playerid][cDice],
		GetServerMoney(playerid),
		CharacterInfo[playerid][cBank],
		CharacterInfo[playerid][cSavings],
		CharacterInfo[playerid][cLoggedID]);
	mysql_tquery(SQL_Handle, query);

	for(new i = 0; i < MAX_VEHICLES; i++) {
        if(VehicleInfo[i][vOwnerCID] == CharacterInfo[playerid][cLoggedID]) {
            //SaveVehicle(i);
            DestroyVehicle(VehicleInfo[i][vSession]);
        }
    }
	printf("SERVER: %s %d | %s | Character Saved", MasterInfo[playerid][mName], playerid, GetRPName(playerid));
	return 1;
}

public OnPlayerSpawn(playerid) {
	if(MasterInfo[playerid][mLogged] == false) {
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
		SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Master Failed - Something went wrong, please contact an administrator");
	} else if(CharacterInfo[playerid][cLogged] == false && MasterInfo[playerid][mLogged] == true) {
		CreateCharacterDraws(playerid); // character/textdraws.pwn
		LoadCharacters(playerid);
	} else if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
		SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have sucessfully spawned.");
	} else {
		SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"SPAWN | Something went wrong, please contact an administrator");
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	}
	return 1;
}

ReturnGender(playerid)
{
	new str[18];
	switch(CharacterInfo[playerid][cGender])
	{
		case 0: str = "Male";
		case 1: str = "Female";
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
		case 13: str = "Androgynous";
		case 14: str = "Agender";	
	}
	return str;
}