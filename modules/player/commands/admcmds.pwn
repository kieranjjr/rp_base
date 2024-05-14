CMD:adminhelp(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Admin Command.");
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Admin Help", "/(a)dmin - Administrator Chat\n/goto - Goto Player or Location\n/(un)freeze - Freeze a player\n/vc <vehicle id> <colour 1> <colour 2>\n/fixcar - fixes your vehicle.\n/destroycar - destroys your vehicle.", "Close", "");
    return 1;
}

CMD:ahelp(playerid, params[]) {
    return cmd_adminhelp(playerid, params);
}

CMD:admins(playerid, params[]) {
    SendClientMessage(playerid, HEX_ADMINYELLOW, "_____________________________________________________");
    SendClientMessage(playerid, HEX_ADMINYELLOW, "                  Urban Gaming Administrator Team              ");

    foreach(new i : Player) {
        if(MasterInfo[i][mAdmin] != 0) {

            switch(MasterInfo[i][mAdmin]) {
                case 1: format(g_str, sizeof(g_str), "Moderator %s", MasterInfo[i][mName]);
                case 2: format(g_str, sizeof(g_str), "Junior Admin %s", MasterInfo[i][mName]);
                case 3: format(g_str, sizeof(g_str), "Administrator %s", MasterInfo[i][mName]);
                case 4: format(g_str, sizeof(g_str), "Senior Administrator %s", MasterInfo[i][mName]);
                case 5: format(g_str, sizeof(g_str), "Lead Administrator %s", MasterInfo[i][mName]);
                case 6: format(g_str, sizeof(g_str), "Community Developer %s", MasterInfo[i][mName]);

            }
            SendClientMessage(playerid, -1, g_str);
        }
    }

    SendClientMessage(playerid, HEX_ADMINYELLOW, "_____________________________________________________");
    return 1;
}


CMD:admin(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Admin Command.");

    if(isnull(params)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/(a)dmin <text>");

    if(MasterInfo[playerid][mAdmin] >= 1) {
        SendAdminMessage(HEX_ADMINYELLOW, "(( ** [%d] %s: %s ))", playerid, MasterInfo[playerid][mName], params);
    } 
    return 1;
}

CMD:a(playerid, params[]) {
    return cmd_admin(playerid, params);
}

CMD:freeze(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Admin Command.");

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/freeze <playerid>");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is no longer connected.");
    if(targetid == playerid) return SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s tried to freeze themselves.", MasterInfo[playerid][mName]);
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is either not logged in or spawned.");

    TogglePlayerControllable(targetid, false);
    SendAdminMessage(HEX_ADMIN, "ADMIN: %s has just froze %s", MasterInfo[playerid][mName], MasterInfo[targetid][mName]);
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"ADMIN: "CSS_WHITE"You have been frozen by %s", MasterInfo[playerid][mName]);
    return 1;
}

CMD:unfreeze(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Admin Command.");

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/unfreeze <playerid>");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is either not logged in or spawned.");

    TogglePlayerControllable(targetid, true);
    SendAdminMessage(HEX_ADMIN, "ADMIN: %s has just unfrozen %s", MasterInfo[playerid][mName], MasterInfo[targetid][mName]);
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"ADMIN: "CSS_WHITE"You have been unfrozen by %s", MasterInfo[playerid][mName]);
    return 1;
}

CMD:goto(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Admin Command.");

    new targetid;

    if(MasterInfo[playerid][mAdmin] >= 1) {
        if(sscanf(params, "u", targetid)) {
            SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/goto <playerid/location>");
            SendClientMessage(playerid, -1, ""CSS_SERVER"LOCATIONS: "CSS_WHITE"AJAIL, Trucking, LS/SF/LV, LSFD, Grove, Idlewood, Unity, Jefferson, Market");
            SendClientMessage(playerid, -1, ""CSS_SERVER"LOCATIONS: "CSS_WHITE"Airport, Bank, Dealership, VIP, Paintball, DMV, Casino");
            return 1;
        }
        if(!strcmp(params, "ajail", true)) {
            SetPlayerPosEx(playerid, 2380.9456, -2714.7192, 31.9793, 90.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Admin Jail.");
        } else if(!strcmp(params, "trucking", true)) {
            SetPlayerPosEx(playerid, 596.2825, 1654.1227, 6.9922, 196.2719, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Trucking Depot.");
        } else if(!strcmp(params, "ls", true)) {
            SetPlayerPosEx(playerid, 1544.4407, -1675.5522, 13.5584, 90.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Los Santos.");
        } else if(!strcmp(params, "sf", true)) {
            SetPlayerPosEx(playerid, -1421.5629, -288.9972, 14.1484, 135.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to San Fierro.");
        } else if(!strcmp(params, "lv", true)) {
            SetPlayerPosEx(playerid, 1670.6908, 1423.5240, 10.7811, 270.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Las Venturas.");
        } else if(!strcmp(params, "lsfd", true)) {
            SetPlayerPosEx(playerid, 1244.3274, -1270.9114, 13.5469, 270.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to LSFD.");
        } else if(!strcmp(params, "grove", true)) {
            SetPlayerPosEx(playerid, 2497.8274, -1668.9033, 13.3438, 90.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Grove Street.");
        } else if(!strcmp(params, "idlewood", true)) {
            SetPlayerPosEx(playerid, 2090.0664, -1816.9071, 13.3904, 90.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Idlewood.");
        } else if(!strcmp(params, "unity", true)) {
            SetPlayerPosEx(playerid, 1782.2683, -1865.5726, 13.5725, 0.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Unity Station.");
        } else if(!strcmp(params, "jefferson", true)) {
            SetPlayerPosEx(playerid, 2222.3438, -1164.5013, 25.7331, 0.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Jefferson Motel.");
        } else if(!strcmp(params, "market", true)) {
            SetPlayerPosEx(playerid, 818.1782, -1349.2217, 13.5260, 0.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Market.");
        } else if(!strcmp(params, "airport", true)) {
            SetPlayerPosEx(playerid, 1938.7185, -2370.6375, 13.5469, 0.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to LS airport.");
        } else if(!strcmp(params, "bank", true)) {
            SetPlayerPosEx(playerid, 1463.8929, -1026.6189, 23.8281, 180.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Mulholland bank.");
        } else if(!strcmp(params, "dealership", true)) {
            SetPlayerPosEx(playerid, 553.4741, -1289.3657, 17.2483, 178.7886, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Grotti dealership.");
        } else if(!strcmp(params, "vip", true)) {
            SetPlayerPosEx(playerid, 1024.2438, -1553.4551, 13.5691, 90.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to VIP lounge.");
        } else if(!strcmp(params, "paintball", true)) {
            SetPlayerPosEx(playerid, 1738.7400, -1269.8062, 13.5433, 315.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Paintball.");
        } else if(!strcmp(params, "dmv", true)) {
            SetPlayerPosEx(playerid, 1224.1537, -1824.5253, 13.5900, 180.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to DMV.");
        } else if(!strcmp(params, "casino", true)) {
            SetPlayerPosEx(playerid, 1022.5992, -1122.8069, 23.8710, 180.0000, 0, 0);
            SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You've been teleported to Casino.");
        } else {
            if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is no longer connected.");
            if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"The specified player is either not logged in or spawned.");
            if(targetid == playerid) return SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s tried to teleport to themselves.", MasterInfo[playerid][mName]);
            
            new Float:X, Float:Y, Float:Z;
            GetPlayerPos(targetid, X, Y, Z);
            SetPlayerPos(playerid, X+3, Y, Z);
            SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s teleported to %s's position", MasterInfo[playerid][mName], MasterInfo[targetid][mName]);
        }
    }
    return 1;
}

CMD:interiordialog(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    Dialog_Show(playerid, ADMININTERIOR, DIALOG_STYLE_LIST, "Interiors", "Business Interiors\nHouse Interiors\nProperty Interiors", "Select", "Close");
    return 1;
}

Dialog:ADMININTERIOR(playerid, response, listitem, inputtext[]) {

    new str[128], interiordialog[600];
    if(response) {
        switch(listitem) {
            case 0: {
                for (new i = 0; i < sizeof(BusinessInteriors); ++i) {
                    format(str, sizeof(str), "%s\n", BusinessInteriors[i][0]);
                    strcat(interiordialog, str, sizeof(interiordialog));
                }
                Dialog_Show(playerid, ADMININTB, DIALOG_STYLE_LIST, "Business Interiors", interiordialog, "Select", "Back");
            }
            case 1: {
                for (new i = 0; i < sizeof(HouseInteriorID); ++i) {
                    format(str, sizeof(str), "%s\n", HouseInteriorID[i][0]);
                    strcat(interiordialog, str, sizeof(interiordialog));
                }
                Dialog_Show(playerid, ADMININTH, DIALOG_STYLE_LIST, "House Interiors", interiordialog, "Select", "Back");
            }
            case 2: {
                for (new i = 0; i < sizeof(PropertyInteriors); ++i) {
                    format(str, sizeof(str), "%s\n", PropertyInteriors[i][0]);
                    strcat(interiordialog, str, sizeof(interiordialog));
                }
                Dialog_Show(playerid, ADMININTP, DIALOG_STYLE_LIST, "Property Interiors", interiordialog, "Select", "Back");
            }

        }
    } else return 0;
    return 1;
}

Dialog:ADMININTB(playerid, response, listitem, inputtext[]) {
    if(response) {
        SetPlayerPosEx(playerid, BusinessInteriorPos[listitem][0], BusinessInteriorPos[listitem][1], BusinessInteriorPos[listitem][2], 0.0, BusinessInteriors[listitem][1][0], 0);
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have teleported to %s", BusinessInteriors[listitem][0][0]);
    } else return Dialog_Show(playerid, ADMININTERIOR, DIALOG_STYLE_LIST, "Interiors", "Business Interiors\nHouse Interiors\nProperty Interiors", "Select", "Close");
    return 1;
}

Dialog:ADMININTH(playerid, response, listitem, inputtext[]) {
    if(response) {
        SetPlayerPosEx(playerid, HouseInteriors[listitem][0], HouseInteriors[listitem][1], HouseInteriors[listitem][2], 0.0, HouseInteriorID[listitem][1][0], 0);
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have teleported to %s", HouseInteriorID[listitem][0][0]);
    } else return Dialog_Show(playerid, ADMININTERIOR, DIALOG_STYLE_LIST, "Interiors", "Business Interiors\nHouse Interiors\nProperty Interiors", "Select", "Close");
    return 1;
}

Dialog:ADMININTP(playerid, response, listitem, inputtext[]) {
    if(response) {
        SetPlayerPosEx(playerid, PropertyInteriorPos[listitem][0], PropertyInteriorPos[listitem][1], PropertyInteriorPos[listitem][2], 0.0, PropertyInteriors[listitem][1][0], 0);
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have teleported to %s", PropertyInteriors[listitem][0][0]);
    } else return Dialog_Show(playerid, ADMININTERIOR, DIALOG_STYLE_LIST, "Interiors", "Business Interiors\nHouse Interiors\nProperty Interiors", "Select", "Close");
    return 1;
}

CMD:gotoxyz(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    new Float:X, Float:Y, Float:Z, int;
    if(sscanf(params, "fffd", X, Y, Z, int)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE" /gotoxyz <X> <Y> <Z> <Interior>");

    SetPlayerPosEx(playerid, X, Y, Z, 0.0, int, 0);
    return 1;
}

CMD:vc(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    new cv[3];
    if(sscanf(params, "ddd", cv[0], cv[1], cv[2])) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE" /vc <vehicleid> <colour1> <colour2>");

    SpawnVehicleInfrontOfPlayer(playerid, cv[0], cv[1], cv[2]);
    return 1;
}

CMD:fixcar(playerid, params[]) return cmd_fixveh(playerid, params);

CMD:fixveh(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    new veh = GetPlayerVehicleID(playerid);
    if(veh) RepairVehicle(veh);
    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Vehicle Repaired.");

    return 1;
}

CMD:destroycar(playerid, params[]) return cmd_fixveh(playerid, params);

CMD:destroyveh(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    new veh = GetPlayerVehicleID(playerid);
    if(veh) DestroyVehicle(veh);
    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Vehicle Removed.");

    return 1;
}

CMD:forcepayday(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    foreach(new i : Player) {
        CharacterInfo[i][cPayday] = 61;
        Payday(i);
        SendClientMessageEx(i, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just forced everyones payday.", MasterInfo[playerid][mName]);
    }
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just forced everyones payday.", MasterInfo[playerid][mName]);
    return 1;
}

CMD:jetpack(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Developer Admin Command.");

    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Jetpack spawned.");
    return 1;
}

CMD:gmx(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Developer Admin Command.");

    foreach(new i : Player)
    {
        if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == false) {
            SaveMasterAccount(playerid);
            SetPlayerName(i, MasterInfo[i][mName]);
        } else if(MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
            SaveCharacter(playerid);
            SaveMasterAccount(playerid);
            SetPlayerName(i, MasterInfo[i][mName]);
        }
    }
    SendClientMessageToAll(-1, ""CSS_ERROR"SERVER: "CSS_WHITE"Server is restarting. Please do not disconnect, your Master & Character stats have been saved.");
    SendRconCommand("gmx");
    return 1;
}


CMD:givemoney(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Lead Admin Command.");

    new targetid, amount;
    if(sscanf(params, "dd", targetid, amount)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/givemoney <targetid> <amount>");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"That player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please allow player to login / spawn first.");


    GiveServerMoney(playerid, amount);
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just given you $%d", MasterInfo[playerid][mName], amount);
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just given %s $%d", MasterInfo[playerid][mName], GetRPName(targetid), amount);

    return 1;
}

CMD:setmoney(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Lead Admin Command.");

    new targetid, amount;
    if(sscanf(params, "dd", targetid, amount)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/setmoney <targetid> <amount>");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"That player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please allow player to login / spawn first.");


    SetServerMoney(playerid, amount);
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just set your money to $%d", MasterInfo[playerid][mName], amount);
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just set %s's money to $%d", MasterInfo[playerid][mName], GetRPName(targetid), amount);

    return 1;
}

CMD:givebank(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Lead Admin Command.");

    new targetid, amount;
    if(sscanf(params, "dd", targetid, amount)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/givebank <targetid> <amount>");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"That player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please allow player to login / spawn first.");


    CharacterInfo[targetid][cBank] += amount;
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just given you $%d in the bank.", MasterInfo[playerid][mName], amount);
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just given %s $%d in the bank.", MasterInfo[playerid][mName], GetRPName(targetid), amount);

    return 1;
}

CMD:setbank(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Lead Admin Command.");

    new targetid, amount;
    if(sscanf(params, "dd", targetid, amount)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/setbank <targetid> <amount>");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"That player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please allow player to login / spawn first.");


    CharacterInfo[targetid][cBank] = amount;
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just set your bank to $%d ", MasterInfo[playerid][mName], amount);
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just set %s's bank to $%d", MasterInfo[playerid][mName], GetRPName(targetid), amount);

    return 1;
}

CMD:propertystats(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Lead Admin Command.");

    new id = IsPlayerInRangeOfHouse(playerid);
    new bid = IsPlayerInRangeOfBusiness(playerid);
    if(id > 0) {
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %d House ID | %s | %d Owner CID", cHouse[id][hID], cHouse[id][hName], cHouse[id][hOwnerCID]);
    }
    if(bid > 0) {
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %d House ID | %s | %d Owner CID", cHouse[id][hID], cHouse[id][hName], cHouse[id][hOwnerCID]);
    } else return SendClientMessageEx(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You are not near a property.");
    return 1;
}

CMD:makeadmin(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 5) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Server Developer Command.");

    new targetid, level;
    if(sscanf(params, "dd", targetid, level)) return SendClientMessage(playerid, -1, ""CSS_SERVER"USAGE: "CSS_WHITE"/makeadmin <targetid> <level 1 - 6>");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"That player is no longer connected.");
    if(CharacterInfo[targetid][cLogged] == false && CharacterInfo[targetid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please allow player to login / spawn first.");

    MasterInfo[targetid][mAdmin] = level;
    SendClientMessageEx(targetid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE" %s has just set your admin level to %d", MasterInfo[playerid][mName], level);
    SendAdminMessage(HEX_ADMIN, "ADMIN MSG: %s has just set %s's admin level to %d", MasterInfo[playerid][mName], GetRPName(targetid), level);
    return 1;
}