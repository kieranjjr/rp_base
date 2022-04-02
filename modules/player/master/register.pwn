Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[]) {
	if(response) {
		bcrypt_hash(playerid, "CreateMaster", inputtext, 12);
		print("registerd");
	} else
		Kick(playerid);
	return 1;
}

forward CreateMaster(playerid);
public CreateMaster(playerid) {

	new hash[61], query[300];

	bcrypt_get_hash(hash);

	mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `master` (`Username`, `Password`, `RegIP`, `Admin`, `VIP` ) VALUES ('%e', '%e', '%e', 0, 0)", GetName(playerid), hash, ReturnIP(playerid));
	mysql_tquery(SQL_Handle, query, "OnMasterCreated", "d", playerid);
	print("master created");
	return 1;
}

forward OnMasterCreated(playerid);
public OnMasterCreated(playerid) {
	SendClientMessage(playerid, -1, "SERVER:- You have sucessfully registered.");
	OnMasterLoad(playerid);
	return 1;	
}