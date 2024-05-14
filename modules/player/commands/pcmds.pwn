CMD:me(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");

    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/me <action>");
   
    format(g_str, sizeof(g_str), "%s %s", GetRPName(playerid), params);
    ProxDetector(20.0, playerid, g_str, HEX_ACTION);
    return 1;
}

CMD:ame(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    
    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/ame <action>");
    
    format(g_str, sizeof(g_str), "%s %s", GetRPName(playerid), params);
    ProxDetector(20.0, playerid, g_str, HEX_ACTION);
    SetPlayerChatBubble(playerid, params, HEX_ACTION, 20.0, 5000);
    return 1;
}

CMD:do(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    
    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/do <action>");

    format(g_str, sizeof(g_str), "** %s %s", GetRPName(playerid), params);
    ProxDetector(20.0, playerid, g_str, HEX_ACTION);
    SetPlayerChatBubble(playerid, g_str, HEX_ACTION, 20.0, 5000);
    return 1;
}

CMD:shout(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    
    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/(s)hout <text>");

    format(g_str, sizeof(g_str), "%s shouts: %s!", GetRPName(playerid), params);
    ProxDetector(35.0, playerid, g_str, HEX_WHITE);
    return 1;
}

CMD:s(playerid, params[]) { 
    return cmd_shout(playerid, params);
}

CMD:low(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    
    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/(l)ow <text>");

    format(g_str, sizeof(g_str), "%s whispers: %s", GetRPName(playerid), params);
    ProxDetector(10.0, playerid, g_str, HEX_WHITE);
    return 1;
}

CMD:l(playerid, params[]) { 
    return cmd_low(playerid, params);
}

CMD:whisper(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");

    new text[128], string[128], targetid;
    if(sscanf(params, "us[128]", targetid, text)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/(w)hisper <playerid> <text>");

    if(playerid == targetid) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" You cannot whisper to yourself.");

    if(IsPlayerConnected(targetid)) {
        format(string, sizeof(string), "** Whisper too %s: %s", GetRPName(targetid), params);
        SendClientMessage(playerid, HEX_WHITE, string);
        format(string, sizeof(string), "** Whisper from %s: %s", GetRPName(playerid), params);
        SendClientMessage(targetid, HEX_WHITE, string);

    }
    return 1;
}

CMD:w(playerid, params[]) { 
    return cmd_whisper(playerid, params);
}

CMD:b(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");

    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/b <ooc text>");

    format(g_str, sizeof(g_str), "(( [%i] %s:- %s ))", playerid, MasterInfo[playerid][mName], params);    
    ProxDetector(10.0, playerid, g_str, HEX_FADE);
    return 1;
}


CMD:pm(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");

    new text[128], string[128], targetid;
    if(sscanf(params, "us[128]", targetid, text)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/pm <playerid> <text>");

    if(targetid == playerid) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" You cannot send yourself a private message.");
    SendAdminMessage(-1, "%s is trying to private message themselves...", playerid);
    // Build system for turning off PMs & Blocking individuals
    if(IsPlayerConnected(targetid)) {
        format(string, sizeof(string), "((PM SENT:- [%d] %s: %s))", targetid, MasterInfo[targetid][mName], text);
        SendClientMessage(playerid, HEX_PM, string);
        format(string, sizeof(string), "((PM FROM:- [%d] %s: %s))", playerid, MasterInfo[playerid][mName], text);
        SendClientMessage(targetid,  HEX_PM, string);
        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    }
    return 1;
}

CMD:p(playerid, params[]) { 
    return cmd_pm(playerid, params);
}

// GAMBLING COMMANDS

CMD:dice(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    
    if(CharacterInfo[playerid][cDice] == 1) {
        format(g_str, sizeof(g_str), "* %s rolls a dice which lands on the number %i.", GetRPName(playerid), random(6) + 1);
        ProxDetector(10.0, playerid, g_str, HEX_ACTION);
    } else {
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You do not have a dice to roll.");
    }
    return 1;
}

// Make some CMD to buy dice.

CMD:flipcoin(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");

    if(GetPlayerMoney(playerid) >= 1) {
        format(g_str, sizeof(g_str), "* %s flips a coin which lands on %s.", GetRPName(playerid), (random(2)) ? ("Heads") : ("Tails"));
        ProxDetector(10.0, playerid, g_str, HEX_ACTION);
    }   
    else return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" You need to have money to flip a coin.");

    return 1;
}