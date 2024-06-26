Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[]) {
	if(response) {
		new query[81], hash[BCRYPT_HASH_LENGTH];

		mysql_format(SQL_Handle, query, sizeof(query), "SELECT `Password` FROM `master` WHERE `Username` = '%e'", GetName(playerid));
		mysql_query(SQL_Handle, query);

		cache_get_value_name(0, "Password", hash, 61);
		bcrypt_verify(playerid, "LoadMasterAccount", inputtext, hash);
    } else
		Kick(playerid);
	return 1;
}

forward LoadMasterAccount(playerid, bool:success);
public LoadMasterAccount(playerid, bool:success) {
	if(success) {
		new query[80];

		mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `master` WHERE `Username` = '%e'", GetName(playerid));
		mysql_tquery(SQL_Handle, query, "OnMasterLoad", "d", playerid); // save_load
	} else {
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FFFFFF}Login Panel", "Welcome back to Urban-Gaming Roleplay\nIncorrect Password\nPlease input your password below to login.", "Login", "Quit");
		printf("%s inputted an incorrect password", GetName(playerid));
	}
	return 1;
}

forward CheckMasterAccount(playerid);
public CheckMasterAccount(playerid) {
	
	new string[128];
	ClearChat(playerid, 20);
	if(cache_num_rows()) {
		format(string, sizeof(string), "{FFFFFF}Welcome back to Urban-Gaming Roleplay {00D084}%s{FFFFFF}. Please input your password below to login.", GetName(playerid));
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FFFFFF}Login Panel", string, "Login", "Quit");
	} else {
		format(string, sizeof(string), "{FFFFFF}Welcome to Urban-Gaming Roleplay, {00D084}%s{FFFFFF}. Please type a strong password below to continue.", GetName(playerid));
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{FFFFFF}Register Panel", string, "Register", "Quit");
	}
	return 1;
}