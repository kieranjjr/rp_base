Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[]) {
	if(response) {
		bcrypt_hash(playerid, "CreateMaster", inputtext, 12);
		printf("SERVER: %s sucessfully registered.", GetName(playerid));
	} else {
		Kick(playerid);
		printf("SERVER: %s was kicked during registration.", GetName(playerid));
	}
	return 1;
}

forward CreateMaster(playerid);
public CreateMaster(playerid) {

	new hash[61], query[300];

	bcrypt_get_hash(hash);

	mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `master` (`Username`, `Password`, `RegIP`, `Admin`, `VIP` ) VALUES ('%e', '%e', '%e', '0', '0')", GetName(playerid), hash, ReturnIP(playerid));
	mysql_tquery(SQL_Handle, query, "OnMasterCreated", "d", playerid);
	printf("SERVER: %s sucessfully created a master account.", GetName(playerid) );
	return 1;
}

forward OnMasterCreated(playerid);
public OnMasterCreated(playerid) {
	SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have sucessfully registered.");
	MasterInfo[playerid][mFirstLogin] = 1;
	LoadMasterAccount(playerid, true);
	return 1;	
}