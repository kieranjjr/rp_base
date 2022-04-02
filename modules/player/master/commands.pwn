CMD:changepassword(playerid, params[]) {

	Dialog_Show(playerid, DIALOG_PASSWORDCHANGE, DIALOG_STYLE_PASSWORD, "Change your password", "Password Change\nInput the new password you want to have for your account.", "Change", "Close");
	return 1;
}

Dialog:DIALOG_PASSWORDCHANGE(playerid, response, listitem, inputtext[]) {
	if(response) {
		bcrypt_hash(playerid, "OnPasswordChanged", inputtext, 12);
	} else SendClientMessage(playerid, -1, "SERVER:- You cancelled.");
	return 1;
}

forward OnPasswordChanged(playerid);
public OnPasswordChanged(playerid) {

	new hash[BCRYPT_HASH_LENGTH], query[156];

	bcrypt_get_hash(hash);

	mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `master` SET `Password` = '%e' WHERE `Username` = '%e'", hash, GetName(playerid));
	mysql_tquery(SQL_Handle, query);

	SendClientMessage(playerid, -1, "SERVER:- You have successfully changed your password.");
	return 1;
}
