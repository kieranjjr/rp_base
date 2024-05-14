SaveMasterAccount(playerid) {
	
	new query[200];
	mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `master` SET `Hours` = '%i', `Admin` = '%i', `VIP` = '%i' WHERE `UID` = '%i'", MasterInfo[playerid][mHours], MasterInfo[playerid][mAdmin], MasterInfo[playerid][mVIP], MasterInfo[playerid][mUID]);
	mysql_query(SQL_Handle, query);
	printf("SERVER: %s | mID %d  - Has been saved.", GetName(playerid), MasterInfo[playerid][mUID]);
	return 1;
}

forward OnMasterLoad(playerid);
public OnMasterLoad(playerid) {

	cache_get_value_name_int(0, "UID", MasterInfo[playerid][mUID]);
	cache_get_value_name_int(0, "Hours", MasterInfo[playerid][mHours]);
	cache_get_value_name_int(0, "Admin", MasterInfo[playerid][mAdmin]);
	cache_get_value_name_int(0, "VIP", MasterInfo[playerid][mVIP]);

	printf("SERVER: mID %d, Admin %d, VIP %d | %s has sucessfully loaded master.", MasterInfo[playerid][mUID], MasterInfo[playerid][mAdmin], MasterInfo[playerid][mVIP], GetName(playerid));

	MasterInfo[playerid][mLogged] = true;

	SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Hello %s, Welcome back to Urban-Gaming Roleplay.", GetName(playerid));
	cCamera(playerid);
	CreateCharacterDraws(playerid);// character/textdraws.pwn
	LoadCharacters(playerid); // character/load.pwn
	return 1;
}