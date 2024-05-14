CMD:changepassword(playerid, params[]) {

	Dialog_Show(playerid, DIALOG_PASSWORDCHANGE, DIALOG_STYLE_PASSWORD, "Change your password", "Password Change\nInput the new password you want to have for your account.", "Change", "Close");
	return 1;
}

Dialog:DIALOG_PASSWORDCHANGE(playerid, response, listitem, inputtext[]) {
	if(response) {
		bcrypt_hash(playerid, "OnPasswordChanged", inputtext, 12);
	} else SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have cancelled the password change.");
	return 1;
}

forward OnPasswordChanged(playerid);
public OnPasswordChanged(playerid) {

	new hash[BCRYPT_HASH_LENGTH], query[156];

	bcrypt_get_hash(hash);

	mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `master` SET `Password` = '%e' WHERE `UID` = '%i'", hash, MasterInfo[playerid][mUID]);
	mysql_tquery(SQL_Handle, query);
	printf("%s | mID %d - Has sucessfully changed their password", GetName(playerid), MasterInfo[playerid][mUID]);

	SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have successfully changed your password.");
	return 1;
}

CMD:changemastername(playerid, params[]) { 
	Dialog_Show(playerid, DIALOG_CHANGENAME, DIALOG_STYLE_INPUT, "Change your Master Account Name", "Master Account Name Change\n Please input a new name for your account.", "Change", "Cancel");
	return 1;
}

Dialog:DIALOG_CHANGENAME(playerid, response, listitem, inputtext[]) {
	if(response) {
		ExistingNameCheck(playerid, inputtext);
	} else return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have cancelled changing your Master Account name.");
	return 1;
}

ExistingNameCheck(playerid, inputtext[]) {
	new query [156];
	mysql_format(SQL_Handle, query, sizeof(query), "SELECT COUNT(*) AS name_count FROM `master` WHERE `Username` = '%e'", inputtext);
	mysql_tquery(SQL_Handle, query, "ChangeMasterName", "ds", playerid, inputtext);
	return 1;
}

forward ChangeMasterName(playerid, inputtext[]);
public ChangeMasterName(playerid, inputtext[]) {
	new query [156];
	if(cache_num_rows()) {
		SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Unfortnately that name is already taken.");
		Dialog_Show(playerid, DIALOG_CHANGENAME, DIALOG_STYLE_INPUT, "Change your Master Account Name", "Master Account Name Change\n Please input a new name for your account.", "Change", "Cancel");
	} else {
		mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `master` SET `Username` = '%e' WHERE `UID` = '%i'", inputtext, MasterInfo[playerid][mUID]); 
		mysql_query(SQL_Handle, query);
		SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Master Account name sucessfully updated to %s", MasterInfo[playerid][mName]);
		SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has changed their Master Account name to %s", MasterInfo[playerid][mName], inputtext);
		//Kick Maybe?
	}
	return 1;
}