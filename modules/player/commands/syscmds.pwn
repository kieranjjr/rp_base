CMD:enter(playerid, params[]) {
    new id = IsPlayerInRangeOfHouse(playerid);
    new bid = IsPlayerInRangeOfBusiness(playerid);
    new pid = IsPlayerInRangeOfProperty(playerid);

    if(GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You cannot enter a property while inside a vehicle.");

    if(bid > 0) {
        if(cBusiness[bid][bLocked] == 0) {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, cBusiness[bid][ExtX], cBusiness[bid][ExtY], cBusiness[bid][ExtZ])) {
                SetPlayerPosEx(playerid, cBusiness[bid][IntX], cBusiness[bid][IntY], cBusiness[bid][IntZ], 0.0, cBusiness[bid][bInterior], bid);
                CharacterInfo[playerid][cInsideID] = bid;
                SendClientMessageEx(playerid, -1, ""CSS_BLUE"BUSINESS: "CSS_WHITE"Welcome to %s", cBusiness[bid][bName]);
            }
        } else {
           format(g_str, sizeof(g_str), "** %s attempts to push open the door.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);

           format(g_str, sizeof(g_str), "** %s fails to open the door, due to it being locked.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);
        }
    } 

    if(pid > 0) {
        if(sProperty[pid][pLocked] == 0) {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, sProperty[pid][ExtX], sProperty[pid][ExtY], sProperty[pid][ExtZ])) {
                SetPlayerPosEx(playerid, sProperty[pid][IntX], sProperty[pid][IntY], sProperty[pid][IntZ], 0.0, sProperty[pid][pInterior], pid);
                CharacterInfo[playerid][cInsideProp] = pid;
                SendClientMessageEx(playerid, -1, ""CSS_BLUE"PROPERTY: "CSS_WHITE"Welcome to %s", sProperty[pid][pName]);
            }
        } else {
           format(g_str, sizeof(g_str), "** %s attempts to push open the door.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);

           format(g_str, sizeof(g_str), "** %s fails to open the door, due to it being locked.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);
        }
    } 

    if(id > 0) {
        if(cHouse[id][hLocked] == 0) {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, cHouse[id][ExtX], cHouse[id][ExtY], cHouse[id][ExtZ])) {
                SetPlayerPosEx(playerid, cHouse[id][IntX], cHouse[id][IntY], cHouse[id][IntZ], 0.0, cHouse[id][hInterior], id);
                CharacterInfo[playerid][cInsideID] = id;
            }
        } else {
           format(g_str, sizeof(g_str), "** %s turns the handle to open the door.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);

           format(g_str, sizeof(g_str), "** %s fails to open the door, due to it being locked.", GetRPName(playerid));
           ProxDetector(20.0, playerid, g_str, HEX_ACTION);
        }
    }
    return 1;
}

CMD:exit(playerid, params[]) {
    new id = CharacterInfo[playerid][cInsideID];
    new pid = CharacterInfo[playerid][cInsideProp];

    if(IsPlayerInRangeOfPoint(playerid, 5.0, cHouse[id][IntX], cHouse[id][IntY], cHouse[id][IntZ]) && GetPlayerVirtualWorld(playerid) == id) {
        if(pid > 0) {
            SetPlayerPosEx(playerid, cHouse[id][ExtX], cHouse[id][ExtY], cHouse[id][ExtZ], 0.0, 0, pid);
            CharacterInfo[playerid][cInsideID] = 0;
        } else {
            SetPlayerPosEx(playerid, cHouse[id][ExtX], cHouse[id][ExtY], cHouse[id][ExtZ], 0.0, 0, 0);
            CharacterInfo[playerid][cInsideID] = 0;
        }
    }

    if(IsPlayerInRangeOfPoint(playerid, 5.0, cBusiness[id][IntX], cBusiness[id][IntY], cBusiness[id][IntZ]) && GetPlayerVirtualWorld(playerid) == id) {
        if(pid > 0) {
            SetPlayerPosEx(playerid, cBusiness[id][ExtX], cBusiness[id][ExtY], cBusiness[id][ExtZ], 0.0, 0, pid);
            CharacterInfo[playerid][cInsideID] = 0;
        } else {
            SetPlayerPosEx(playerid, cBusiness[id][ExtX], cBusiness[id][ExtY], cBusiness[id][ExtZ], 0.0, 0, 0);
            CharacterInfo[playerid][cInsideID] = 0; 
        }
    }

    if(IsPlayerInRangeOfPoint(playerid, 5.0, sProperty[pid][IntX], sProperty[pid][IntY], sProperty[pid][IntZ]) && GetPlayerVirtualWorld(playerid) == pid) {
        SetPlayerPosEx(playerid, sProperty[pid][ExtX], sProperty[pid][ExtY], sProperty[pid][ExtZ], 0.0, 0, 0);
        CharacterInfo[playerid][cInsideProp] = 0;
    }
    return 1;
}

CMD:insideid(playerid, params[]) {
    SendClientMessageEx(playerid, -1, "%d Inside ID - %d Inside Prop", CharacterInfo[playerid][cInsideID], CharacterInfo[playerid][cInsideProp]);
    return 1;
}

CMD:buyhouse(playerid, params[]) {
    new id = IsPlayerInRangeOfHouse(playerid);

    if(id == 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You are not near a house.");
    if(cHouse[id][hOwnerCID] != 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"This property has already been purchased.");
    if(cHouse[id][hPrice] > CharacterInfo[playerid][cMoney]) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You do not have enough money to purchase this property.");

    SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have purchased %s", cHouse[id][hName]);
    GivePlayerMoney(playerid, -cHouse[id][hPrice]);
    CharacterInfo[playerid][cMoney] -= cHouse[id][hPrice];
    cHouse[id][hOwnerCID] = CharacterInfo[playerid][cLoggedID];

    new query[128];
    mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET `OwnerCID` = '%d' WHERE `HID` = '%d'", CharacterInfo[playerid][cLoggedID], cHouse[id][hID]);           
    mysql_tquery(SQL_Handle, query);

    ReloadHouse(id);

    return 1;
}

CMD:sellhouse(playerid, params[]) {
    new id = IsPlayerInRangeOfHouse(playerid);

    if(id == 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You are not near a house.");
    if(CharacterInfo[playerid][cLoggedID] == cHouse[id][hOwnerCID]) {
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have sold %s", cHouse[id][hName]);
        GivePlayerMoney(playerid, cHouse[id][hPrice]);
        CharacterInfo[playerid][cMoney] += cHouse[id][hPrice];
        cHouse[id][hOwnerCID] = 0;

        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET `OwnerCID` = '0' WHERE `HID` = '%d'", cHouse[id][hID]);           
        mysql_tquery(SQL_Handle, query);

        ReloadHouse(id);

    } else return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You do not own this property.");
    return 1;
}

CMD:buybusiness(playerid, params[]) {
    new id = IsPlayerInRangeOfBusiness(playerid);

    if(id == 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You are not near a business.");
    if(cBusiness[id][bOwnerCID] != 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"This property has already been purchased.");
    if(cBusiness[id][bPrice] > CharacterInfo[playerid][cMoney]) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You do not have enough money to purchase this property.");

    SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have purchased %s", cBusiness[id][bName]);
    GivePlayerMoney(playerid, -cBusiness[id][bPrice]);
    CharacterInfo[playerid][cMoney] -= cBusiness[id][bPrice];
    cBusiness[id][bOwnerCID] = CharacterInfo[playerid][cLoggedID];

    new query[128];
    mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET `OwnerCID` = '%d' WHERE `BID` = '%d'", CharacterInfo[playerid][cLoggedID], cBusiness[id][bID]);           
    mysql_tquery(SQL_Handle, query);

    ReloadBusiness(id);

    return 1;
}

CMD:sellbusiness(playerid, params[]) {
    new id = IsPlayerInRangeOfBusiness(playerid);

    if(id == 0) return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You are not near a business.");
    if(CharacterInfo[playerid][cLoggedID] == cBusiness[id][bOwnerCID]) {
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have sold %s", cBusiness[id][bName]);
        GivePlayerMoney(playerid, cBusiness[id][bPrice]);
        CharacterInfo[playerid][cMoney] += cBusiness[id][bPrice];
        cBusiness[id][bOwnerCID] = 0;

        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET `OwnerCID` = '0' WHERE `BID` = '%d'", cBusiness[id][bID]);           
        mysql_tquery(SQL_Handle, query);

        ReloadBusiness(id);
    } else return SendClientMessage(playerid, -1, ""CSS_ERROR"ERROR: "CSS_WHITE"You do not own this property.");
    return 1;
}

CMD:systemhelp(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "System Help", "No help right now.", "Close", "");
    return 1;
}

CMD:shelp(playerid, params[]) {
    return cmd_systemhelp(playerid, params);
}

CMD:manager(playerid, params[]) {
    if(CharacterInfo[playerid][cLogged] == false && CharacterInfo[playerid][cSpawned] == false) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Please login before performing commands.");
    if(MasterInfo[playerid][mAdmin] <= 4) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"Senior Admin Command.");

    Dialog_Show(playerid, SYSTEMMENU, DIALOG_STYLE_LIST, "System Management", "Houses\nBusinesses\nProperties\nVehicles", "Select","Close");
    
    return 1;
}

Dialog:SYSTEMMENU(playerid, response, listitem, inputtext[]) {
    if(!response) return SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have closed the system menu");

    if(response) {
        switch(listitem) {
            case 0: { // Houses
                Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
            }
            case 1: { // Business
                Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
            }
            case 2: { // Properties 
                Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
                SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"System is not yet finished.");
            }
            case 3: { // Vehicle Management
                Dialog_Show(playerid, VEHICLEMENU, DIALOG_STYLE_LIST, "Server Vehicle Management", "Create Vehicle\nVehicle Type\nVehicle Location\nChange Model\nDelete Vehicle", "Select", "Back");
                SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"System is not yet finished.");
            }
        }
    }
    return 1;
}

Dialog:VEHICLEMENU(playerid, response, listitem, inputtext[]) {
    if(!response) return Dialog_Show(playerid, SYSTEMMENU, DIALOG_STYLE_LIST, "System Management", "Houses\nBusinesses\nProperties\nVehicles", "Select","Close");

    if(response) {
        switch(listitem) {
            case 0 : { // Create Vehicle

            }
            case 1: { // Vehicle Type - 

            }
            case 2: { // Vehicle Location

            }
            case 3: { // Vehicle Model

            }
            case 4: { // Delete Vehicle
            }
        }
    }
    return 1;
}

Dialog:PROPERTYMENU(playerid, response, listitem, inputtext[]) {
    if(!response) return Dialog_Show(playerid, SYSTEMMENU, DIALOG_STYLE_LIST, "System Management", "Houses\nBusinesses\nProperties\nVehicles", "Select","Close");

    CharacterInfo[playerid][cEditingID] = IsPlayerInRangeOfProperty(playerid);

    if(response) {
        switch(listitem) {
            case 0: {
                Dialog_Show(playerid, CREATEPROPERTY, DIALOG_STYLE_MSGBOX, "Property Management - Create","You have created a Property\nPlease continue to set the name/address", "Continue","Back");
            }
            case 1: { // Name Property
                Dialog_Show(playerid, PROPERTYNAME, DIALOG_STYLE_INPUT, "Property Managerment - Name", "Please input the desired name for this property.", "Continue", "Back");
            }
            case 2: { // Property Type
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, PROPERTYTYPE, DIALOG_STYLE_LIST, "Property Management", "Public Building\nBank\nFaction Building", "Select", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a property.");
                }
            }
            case 3: { // Change Interior
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    new str[128], interiordialog[600];
                    for (new i = 0; i < sizeof(PropertyInteriors); ++i) {
                        format(str, sizeof(str), "%s\n", PropertyInteriors[i][0]);
                        strcat(interiordialog, str, sizeof(interiordialog));
                    }
                    Dialog_Show(playerid, PROPERTYINTERIOR, DIALOG_STYLE_LIST, "Property Interiors", interiordialog, "Select","Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a property.");
                }
            }
            case 4: { // Pickup Type
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, PICKUPTYPE, DIALOG_STYLE_LIST, "Property Management", "Infomation Icon\nDollar Sign\n\nYellow Marker\nRed Marker\nGreen Marker\nRed House\nOrange House\nYellow House", "Select", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a property.");
                }
            }
            case 5: { // Delete Property
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, DELETEPROPERTY, DIALOG_STYLE_MSGBOX, "Property Management - Delete", "Are you sure you want to delete this property?", "Delete", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a property.");
                }

            }
        }
    }
    return 1;
}

Dialog:HOUSEMENU(playerid, response, listitem, inputtext[]) {
    if(!response) return Dialog_Show(playerid, SYSTEMMENU, DIALOG_STYLE_LIST, "System Management", "Houses\nBusinesses\nProperties\nVehicles", "Select","Close");

    CharacterInfo[playerid][cEditingID] = IsPlayerInRangeOfHouse(playerid);

    if(response) {
        switch(listitem) {
            case 0: { //Create House
                Dialog_Show(playerid, CREATEHOUSE, DIALOG_STYLE_MSGBOX, "House Management - Create","You have created a house.","Continue","Back");
            }
            case 1: { // Name House
                Dialog_Show(playerid, HOUSENAME, DIALOG_STYLE_INPUT, "House Managerment - Name", "Please input the desired name/address for this house.", "Continue", "Back");
            }
            case 2: { // Delete House
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, DELETEHOUSE, DIALOG_STYLE_MSGBOX, "House Management - Delete", "Are you sure you want to delete this house?", "Delete", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a house.");
                }

            }
            case 3: { // Change Interior
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    new str[128], interiordialog[600];
                    for (new i = 0; i < sizeof(HouseInteriorID); ++i) {
                        format(str, sizeof(str), "%s\n", HouseInteriorID[i][0]);
                        strcat(interiordialog, str, sizeof(interiordialog));
                    }
                    Dialog_Show(playerid, HOUSEINTERIOR, DIALOG_STYLE_LIST, "House Interiors", interiordialog, "Select","Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a house.");
                }
            }
            case 4: {
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, HOUSEPRICE, DIALOG_STYLE_INPUT, "House Management", "Please input the price of the house", "Select", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a house.");
                }
            } 
        }
    }
    return 1;
}

Dialog:BUSINESSMENU(playerid, response, listitem, inputtext[])
{
    if(!response) return Dialog_Show(playerid, SYSTEMMENU, DIALOG_STYLE_LIST, "System Management", "Houses\nBusinesses\nProperties\nVehicles", "Select","Close");

    CharacterInfo[playerid][cEditingID] = IsPlayerInRangeOfBusiness(playerid);

    if(response) {
        switch(listitem) {
            case 0: { //Create Business
                Dialog_Show(playerid, CREATEBUSINESS, DIALOG_STYLE_MSGBOX, "Business Management - Create","You have created a business\nPlease continue to set the name/address", "Continue","Back");
            }
            case 1: { // Name Business
                Dialog_Show(playerid, BUSINESSNAME, DIALOG_STYLE_INPUT, "Business Managerment - Name", "Please input the desired name for this business", "Continue", "Back");
            }
            case 2: { // Delete Business
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, DELETEBUSINESS, DIALOG_STYLE_MSGBOX, "Business Management - Delete", "Are you sure you want to delete this business?", "Delete", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a business.");
                }

            }
            case 3: { // Change Interior
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    new str[128], interiordialog[600];
                    for (new i = 0; i < sizeof(BusinessInteriors); ++i) {
                        format(str, sizeof(str), "%s\n", BusinessInteriors[i][0]);
                        strcat(interiordialog, str, sizeof(interiordialog));
                    }
                    Dialog_Show(playerid, BUSINESSINTERIOR, DIALOG_STYLE_LIST, "Business Interiors", interiordialog, "Select","Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a business.");
                }
            }
            case 4: {
                if(CharacterInfo[playerid][cEditingID] > 0) {
                    Dialog_Show(playerid, BUSINESSPRICE, DIALOG_STYLE_INPUT, "Business Management", "Please input the price of the business", "Select", "Back");
                } else {
                    SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You are not near a business.");
                }
            }
        }
    }
    return 1;
}

Dialog:CREATEHOUSE(playerid, response, listitem, inputtext[]) {
    if(response) {

        new query[198], Float:LocX, Float:LocY, Float:LocZ;
        
        GetPlayerPos(playerid, LocX, LocY, LocZ);
        CreatingMenu[playerid] = true;

        mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `houses` (Name, ExtX, ExtY, ExtZ) VALUES ('%e', %f, %f, %f)", inputtext, LocX, LocY, LocZ);           
        mysql_tquery(SQL_Handle, query, "RetreiveHouseSQLID");

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have created a new house at %s", inputtext);
        Dialog_Show(playerid, HOUSENAME, DIALOG_STYLE_INPUT, "House Managerment", "Please input the desired name/address for this house.", "Continue", "Back");
    } else return Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    return 1;
}

Dialog:HOUSENAME(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    new str[50];
    format(str, sizeof(str), "%s", inputtext);

    if(response && CreatingMenu[playerid] == true) {
        cHouse[editid][hName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET `Name` = '%s' WHERE `HID` = '%d' LIMIT 1", str, cHouse[editid][hID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the house %s.", str);
        Dialog_Show(playerid, HOUSEPRICE, DIALOG_STYLE_INPUT, "House Management", "Please input the price of the house.", "Select", "Back");
    } else if(response && CreatingMenu[playerid] == false) {
        cHouse[editid][hName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET `Name` = '%s' WHERE `HID` = '%d' LIMIT 1", str, cHouse[editid][hID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the house %s.", str);
        Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a house name/address.");
        Dialog_Show(playerid, HOUSENAME, DIALOG_STYLE_INPUT, "House Managerment", "Please input the desired name/address for this house.", "Continue", "Back");
    } else return Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    return 1;
}

Dialog:HOUSEPRICE(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        if(strval(inputtext) >= 0) {
            cHouse[editid][hPrice] = strval(inputtext);

            new query[128];
            mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET Price = %d WHERE HID = %d LIMIT 1", cHouse[editid][hPrice], cHouse[editid][hID]);           
            mysql_tquery(SQL_Handle, query);

            new str[128], interiordialog[600];
            for (new i = 0; i < sizeof(HouseInteriorID); ++i) {
                format(str, sizeof(str), "%s\n", HouseInteriorID[i][0]);
                strcat(interiordialog, str, sizeof(interiordialog));
            }
            Dialog_Show(playerid, HOUSEINTERIOR, DIALOG_STYLE_LIST, "House Interiors", interiordialog, "Select","Back");
            SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the price of house ID %d to $%d", CharacterInfo[playerid][cEditingID], strval(inputtext));
        }
    } else if(response && CreatingMenu[playerid] == false) {
        if(strval(inputtext) >= 0) {
            cHouse[editid][hPrice] = strval(inputtext);

            new query[128];
            mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET Price = %d WHERE HID = %d LIMIT 1", cHouse[editid][hPrice], cHouse[editid][hID]);           
            mysql_tquery(SQL_Handle, query);

            ReloadHouse(editid);

            SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the price of house ID %d to $%d", CharacterInfo[playerid][cEditingID], strval(inputtext));
            Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
        }
    } else if(!response && CreatingMenu[playerid] == true) {
        Dialog_Show(playerid, HOUSEPRICE, DIALOG_STYLE_INPUT, "House Management", "Please input the price of the house", "Select", "Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a new house price.");
    } else return Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    return 1;
}

Dialog:HOUSEINTERIOR(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        
        cHouse[editid][IntX] = HouseInteriors[listitem][0];
        cHouse[editid][IntY] = HouseInteriors[listitem][1];
        cHouse[editid][IntZ] = HouseInteriors[listitem][2];
        cHouse[editid][hInterior] = HouseInteriorID[listitem][1][0];
        
        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(playerid, X, Y, Z);
        cHouse[editid][ExtX] = X;
        cHouse[editid][ExtY] = Y;
        cHouse[editid][ExtZ] = Z;
        cHouse[editid][hWorld] = editid;
        cHouse[editid][hOwnerCID] = 0;
        cHouse[editid][hLocked] = 0;
        cHouse[editid][hSafe] = 0;


        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE HID = %d LIMIT 1", cHouse[editid][IntX], cHouse[editid][IntY], cHouse[editid][IntZ], cHouse[editid][hInterior], cHouse[editid][hID]);
        mysql_tquery(SQL_Handle, query);

        CreateHouse(editid);

        CreatingMenu[playerid] = false;

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have changed the interior of house ID %d", editid);
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have finished creating house ID %d", editid);
        
    } else if(response && CreatingMenu[playerid] == false) {

        cHouse[editid][IntX] = HouseInteriors[listitem][0];
        cHouse[editid][IntY] = HouseInteriors[listitem][1];
        cHouse[editid][IntZ] = HouseInteriors[listitem][2];
        cHouse[editid][hInterior] = HouseInteriorID[listitem][1][0];
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `houses` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE HID = %d LIMIT 1", cHouse[editid][IntX], cHouse[editid][IntY], cHouse[editid][IntZ], cHouse[editid][hInterior], cHouse[editid][hID]);
        mysql_tquery(SQL_Handle, query);

        ReloadHouse(editid);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have changed the interior of house ID %d", editid);
        Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        
        new str[128], interiordialog[600];
        for (new i = 0; i < sizeof(HouseInteriorID); ++i) {
            format(str, sizeof(str), "%s\n", HouseInteriorID[i][0]);
            strcat(interiordialog, str, sizeof(interiordialog));
        }
        Dialog_Show(playerid, HOUSEINTERIOR, DIALOG_STYLE_LIST, "House Interiors", interiordialog, "Select","Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a house interior.");
    }
    return 1;
}

Dialog:DELETEHOUSE(playerid, response, listitem, inputtext[]) {
    if(response) {

        new editid = CharacterInfo[playerid][cEditingID];

        DestroyDynamic3DTextLabel(cHouse[editid][hLabelID]);
        DestroyDynamicPickup(cHouse[editid][hPickupID]);

        new query[50];
        mysql_format(SQL_Handle, query, sizeof(query), "DELETE FROM `houses` WHERE HID = %d LIMIT 1", editid);
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have deleted house ID %d", editid);
        Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");

    } else return Dialog_Show(playerid, HOUSEMENU, DIALOG_STYLE_LIST, "House Management", "Create House\nName House\nChange Interior\nChange Price\nDelete House", "Select", "Back");
    return 1;
}

// Business System

Dialog:CREATEBUSINESS(playerid, response, listitem, inputtext[]) {
    if(response) {

        new query[198], Float:LocX, Float:LocY, Float:LocZ;
        
        GetPlayerPos(playerid, LocX, LocY, LocZ);
        CreatingMenu[playerid] = true;

        mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `businesses` (ExtX, ExtY, ExtZ) VALUES (%f, %f, %f)", LocX, LocY, LocZ);           
        mysql_tquery(SQL_Handle, query, "RetreiveBusinessSQLID");

        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have created a new business.");
        Dialog_Show(playerid, BUSINESSNAME, DIALOG_STYLE_INPUT, "Business Managerment - Name", "Please input the desired name for this business", "Continue", "Back");
    } else return Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    return 1;
}

Dialog:BUSINESSNAME(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    new str[50];
    format(str, sizeof(str), "%s", inputtext);

    if(response && CreatingMenu[playerid] == true) {
        cBusiness[editid][bName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET `Name` = '%s' WHERE `BID` = '%d' LIMIT 1", str, cBusiness[editid][bID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the business %s.", str);
        Dialog_Show(playerid, BUSINESSPRICE, DIALOG_STYLE_INPUT, "Business Management", "Please input the price of the business", "Select", "Back");
    } else if(response && CreatingMenu[playerid] == false) {
        cBusiness[editid][bName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET `Name` = '%s' WHERE `BID` = '%d' LIMIT 1", str, cBusiness[editid][bID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the business %s.", str);
        Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a business name.");
        Dialog_Show(playerid, BUSINESSNAME, DIALOG_STYLE_INPUT, "Business Managerment - Name", "Please input the desired name for this business", "Continue", "Back");
    } else return Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    return 1;
}

Dialog:BUSINESSPRICE(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        if(strval(inputtext) >= 0) {
            cBusiness[editid][bPrice] = strval(inputtext);

            new query[128];
            mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET Price = %d WHERE BID = %d LIMIT 1", cBusiness[editid][bPrice], cBusiness[editid][bID]);           
            mysql_tquery(SQL_Handle, query);

            new str[128], interiordialog[600];
            for (new i = 0; i < sizeof(BusinessInteriors); ++i) {
                format(str, sizeof(str), "%s\n", BusinessInteriors[i][0]);
                strcat(interiordialog, str, sizeof(interiordialog));
            }
            Dialog_Show(playerid, BUSINESSINTERIOR, DIALOG_STYLE_LIST, "Business Interiors", interiordialog, "Select","Back");
            SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the price of business ID %d to $%d", CharacterInfo[playerid][cEditingID], strval(inputtext));
        }
    } else if(response && CreatingMenu[playerid] == false) {
        if(strval(inputtext) >= 0) {
            cBusiness[editid][bPrice] = strval(inputtext);

            new query[128];
            mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET Price = %d WHERE BID = %d LIMIT 1", cBusiness[editid][bPrice], cBusiness[editid][bID]);           
            mysql_tquery(SQL_Handle, query);

            ReloadBusiness(editid);

            SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the price of business ID %d to $%d", CharacterInfo[playerid][cEditingID], strval(inputtext));
            Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
        }
    } else if(!response && CreatingMenu[playerid] == true) {
        Dialog_Show(playerid, BUSINESSPRICE, DIALOG_STYLE_INPUT, "Business Management", "Please input the price of the business", "Select", "Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a new busines price.");
    } else return Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    return 1;
}

Dialog:DELETEBUSINESS(playerid, response, listitem, inputtext[]) {
    if(response) {

        new editid = CharacterInfo[playerid][cEditingID];

        DestroyDynamic3DTextLabel(cBusiness[editid][bLabelID]);
        DestroyDynamicPickup(cBusiness[editid][bPickupID]);

        new query[50];
        mysql_format(SQL_Handle, query, sizeof(query), "DELETE FROM `businesses` WHERE BID = %d LIMIT 1", editid);
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have deleted business ID %d", editid);
        Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");

    } else return Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    return 1;
}


Dialog:BUSINESSINTERIOR(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        
        cBusiness[editid][IntX] = BusinessInteriorPos[listitem][0];
        cBusiness[editid][IntY] = BusinessInteriorPos[listitem][1];
        cBusiness[editid][IntZ] = BusinessInteriorPos[listitem][2];
        cBusiness[editid][bInterior] = BusinessInteriors[listitem][1][0];

        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(playerid, X, Y, Z);
        cBusiness[editid][ExtX] = X;
        cBusiness[editid][ExtY] = Y;
        cBusiness[editid][ExtZ] = Z;
        cBusiness[editid][bWorld] = editid;
        cBusiness[editid][bOwnerCID] = 0;
        cBusiness[editid][bLocked] = 0;
        cBusiness[editid][bSafe] = 0;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE BID = %d LIMIT 1", cBusiness[editid][IntX], cBusiness[editid][IntY], cBusiness[editid][IntZ], cBusiness[editid][bInterior], cBusiness[editid][bID]);
        mysql_tquery(SQL_Handle, query);

        CreateBusiness(editid);

        CreatingMenu[playerid] = false;

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have changed the interior of business ID %d", editid);
        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have finished creating business ID %d", editid);
        
    } else if(response && CreatingMenu[playerid] == false) {

        cBusiness[editid][IntX] = BusinessInteriorPos[listitem][0];
        cBusiness[editid][IntY] = BusinessInteriorPos[listitem][1];
        cBusiness[editid][IntZ] = BusinessInteriorPos[listitem][2];
        cBusiness[editid][bInterior] = BusinessInteriors[listitem][1][0];
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `businesses` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE BID = %d LIMIT 1", cBusiness[editid][IntX], cBusiness[editid][IntY], cBusiness[editid][IntZ], cBusiness[editid][bInterior], cBusiness[editid][bID]);
        mysql_tquery(SQL_Handle, query);

        ReloadBusiness(editid);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have changed the interior of business ID %d", editid);
        Dialog_Show(playerid, BUSINESSMENU, DIALOG_STYLE_LIST, "Business Management", "Create Business\nName Business\nChange Interior\nChange Price\nDelete Business", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        
        new str[128], interiordialog[600];
        for (new i = 0; i < sizeof(BusinessInteriors); ++i) {
            format(str, sizeof(str), "%s\n", BusinessInteriors[i][0]);
            strcat(interiordialog, str, sizeof(interiordialog));
        }
        Dialog_Show(playerid, BUSINESSINTERIOR, DIALOG_STYLE_LIST, "Business Interiors", interiordialog, "Select","Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a business interior.");
    }
    return 1;
}

// Property System

Dialog:CREATEPROPERTY(playerid, response, listitem, inputtext[]) {
    if(response) {

        new query[198], Float:LocX, Float:LocY, Float:LocZ;
        
        GetPlayerPos(playerid, LocX, LocY, LocZ);
        CreatingMenu[playerid] = true;

        mysql_format(SQL_Handle, query, sizeof(query), "INSERT INTO `properties` (ExtX, ExtY, ExtZ) VALUES (%f, %f, %f)", LocX, LocY, LocZ);           
        mysql_tquery(SQL_Handle, query, "RetreivePropertySQLID");

        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have created a new property.");
        Dialog_Show(playerid, PROPERTYNAME, DIALOG_STYLE_INPUT, "Property Managerment - Name", "Please input the desired name for this property", "Continue", "Back");
    } else return Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    return 1;
}

Dialog:PROPERTYNAME(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    new str[50];

    if(response && CreatingMenu[playerid] == true) {
        format(str, sizeof(str), "%s", inputtext);
        sProperty[editid][pName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET `Name` = '%s' WHERE `PID` = '%d' LIMIT 1", str, sProperty[editid][pID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the Property %s.", str);
        Dialog_Show(playerid, PROPERTYTYPE, DIALOG_STYLE_LIST, "Property Management", "Public Building\nBank\nFaction Building", "Select", "Back");
    } else if(response && CreatingMenu[playerid] == false) {
        format(str, sizeof(str), "%s", inputtext);
        sProperty[editid][pName] = str;
        
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET `Name` = '%s' WHERE `PID` = '%d' LIMIT 1", str, sProperty[editid][pID]);           
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have named the property %s.", str);
        ReloadProperty(editid);

        Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a Property name.");
        Dialog_Show(playerid, PropertyNAME, DIALOG_STYLE_INPUT, "Property Managerment - Name", "Please input the desired name for this Property", "Continue", "Back");
    } else return Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    return 1;
}

Dialog:PROPERTYTYPE(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        switch(listitem) {
            case 0 : { // Public Building
                sProperty[editid][pType] = 1;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Public Building", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
            case 1: { // Bank
                sProperty[editid][pType] = 2;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Bank", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
            case 2: { // Faction Building
                sProperty[editid][pType] = 3;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Faction Building", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
        }
        new str[128], interiordialog[600];
        for (new i = 0; i < sizeof(PropertyInteriors); ++i) {
            format(str, sizeof(str), "%s\n", PropertyInteriors[i][0]);
            strcat(interiordialog, str, sizeof(interiordialog));
        }
        Dialog_Show(playerid, PROPERTYINTERIOR, DIALOG_STYLE_LIST, "Property Interiors", interiordialog, "Select","Back");
    }
    else if(response && CreatingMenu[playerid] == false) {
        switch(listitem) {
            case 0 : { // Public Building
                sProperty[editid][pType] = 1;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Public Building", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
            case 1: { // Bank
                sProperty[editid][pType] = 2;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Bank", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
            case 2: { // Faction Building
                sProperty[editid][pType] = 3;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the type of Property ID %d to a Faction Building", CharacterInfo[playerid][cEditingID]);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET Type = %d WHERE PID = %d LIMIT 1", sProperty[editid][pType], sProperty[editid][pID]);           
                mysql_tquery(SQL_Handle, query);
            }
        }
        ReloadProperty(editid);
        Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    }
    else if(!response && CreatingMenu[playerid] == true) {
        Dialog_Show(playerid, PROPERTYTYPE, DIALOG_STYLE_LIST, "Property Management", "Public Building\nBank\nFaction Building", "Select", "Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a new busines type.");
    } else return Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    return 1;
}

Dialog:PROPERTYINTERIOR(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        
        sProperty[editid][IntX] = PropertyInteriorPos[listitem][0];
        sProperty[editid][IntY] = PropertyInteriorPos[listitem][1];
        sProperty[editid][IntZ] = PropertyInteriorPos[listitem][2];
        sProperty[editid][pInterior] = PropertyInteriors[listitem][1][0];

        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(playerid, X, Y, Z);
        sProperty[editid][ExtX] = X;
        sProperty[editid][ExtY] = Y;
        sProperty[editid][ExtZ] = Z;
        sProperty[editid][pWorld] = editid;
        sProperty[editid][pLocked] = 0;

        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE PID = %d LIMIT 1", sProperty[editid][IntX], sProperty[editid][IntY], sProperty[editid][IntZ], sProperty[editid][pInterior], sProperty[editid][pID]);
        mysql_tquery(SQL_Handle, query);

        Dialog_Show(playerid, PICKUPTYPE, DIALOG_STYLE_LIST, "Property Management", "Infomation Icon\nDollar Sign\nYellow Marker\nRed Marker\nGreen Marker\nRed House\nOrange House\nYellow House", "Select", "Back");

    } else if(response && CreatingMenu[playerid] == false) {
        sProperty[editid][IntX] = PropertyInteriorPos[listitem][0];
        sProperty[editid][IntY] = PropertyInteriorPos[listitem][1];
        sProperty[editid][IntZ] = PropertyInteriorPos[listitem][2];
        sProperty[editid][pInterior] = PropertyInteriors[listitem][1][0];

        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET IntX = %f, IntY = %f, IntZ = %f, Interior = %d WHERE PID = %d LIMIT 1", sProperty[editid][IntX], sProperty[editid][IntY], sProperty[editid][IntZ], sProperty[editid][pInterior], sProperty[editid][pID]);
        mysql_tquery(SQL_Handle, query);

        ReloadProperty(editid);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have changed the interior of Property ID %d", editid);
        Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        new str[128], interiordialog[600];
        for (new i = 0; i < sizeof(PropertyInteriors); ++i) {
            format(str, sizeof(str), "%s\n", PropertyInteriors[i][0]);
            strcat(interiordialog, str, sizeof(interiordialog));
        }
        Dialog_Show(playerid, PROPERTYINTERIOR, DIALOG_STYLE_LIST, "Property Interiors", interiordialog, "Select","Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a Property interior.");
    }
    return 1;
}

Dialog:PICKUPTYPE(playerid, response, listitem, inputtext[]) {
    new editid = CharacterInfo[playerid][cEditingID];

    if(response && CreatingMenu[playerid] == true) {
        switch(listitem) { // Infomation Icon\nDollar Sign\n\nYellow Marker\nRed Marker\nGreen Marker\nRed House\nOrange House\nYellow House
            case 0: { // 1239
                sProperty[editid][pPickupType] = 1239;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Information Icon'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 1: { // 1274
                sProperty[editid][pPickupType] = 1274;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Dollar Sign'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 2: { // 19198
                sProperty[editid][pPickupType] = 19198;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Yellow Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);

            }
            case 3: { // 19605
                sProperty[editid][pPickupType] = 19605;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Red Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);

            }
            case 4: { // 19606
                sProperty[editid][pPickupType] = 19606;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Green Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 5: { // 19522
                sProperty[editid][pPickupType] = 19522;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Red House''", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 6: { // 19523
                sProperty[editid][pPickupType] = 19523;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Green House'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 7: { // 19524
                sProperty[editid][pPickupType] = 19524;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Orange House'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
        }
        CreateProperty(editid);

        CreatingMenu[playerid] = false;

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have finished creating Property ID %d", editid);

    } else if(response && CreatingMenu[playerid] == false) {
        switch(listitem) { // Infomation Icon\nDollar Sign\n\nYellow Marker\nRed Marker\nGreen Marker\nRed House\nOrange House\nYellow House
            case 0: { // 1239
                sProperty[editid][pPickupType] = 1239;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Information Icon'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 1: { // 1274
                sProperty[editid][pPickupType] = 1274;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Dollar Sign'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 2: { // 19198
                sProperty[editid][pPickupType] = 19198;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Yellow Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);

            }
            case 3: { // 19605
                sProperty[editid][pPickupType] = 19605;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Red Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);

            }
            case 4: { // 19606
                sProperty[editid][pPickupType] = 19606;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Green Marker'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 5: { // 19522
                sProperty[editid][pPickupType] = 19522;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Red House''", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 6: { // 19523
                sProperty[editid][pPickupType] = 19523;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Green House'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
            case 7: { // 19524
                sProperty[editid][pPickupType] = 19524;
                SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have set the pickup type of Property ID %d to 'Orange House'", editid);
                new query[128];
                mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `properties` SET PickupID = %d WHERE PID = %d LIMIT 1", sProperty[editid][pPickupType], sProperty[editid][pID]);
                mysql_tquery(SQL_Handle, query);
            }
        }
        ReloadProperty(editid);
        Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    } else if(!response && CreatingMenu[playerid] == true) {
        Dialog_Show(playerid, PICKUPTYPE, DIALOG_STYLE_LIST, "Property Management", "Infomation Icon\nDollar Sign\n\nYellow Marker\nRed Marker\nGreen Marker\nRed House\nOrange House\nYellow House", "Select", "Back");
        SendClientMessage(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You must set a Property Pickup Type.");
    }
    else return Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    return 1;
}

Dialog:DELETEPROPERTY(playerid, response, listitem, inputtext[]) {
    if(response) {

        new editid = CharacterInfo[playerid][cEditingID];

        DestroyDynamic3DTextLabel(sProperty[editid][pLabelID]);
        DestroyDynamicPickup(sProperty[editid][pPickupID]);

        new query[50];
        mysql_format(SQL_Handle, query, sizeof(query), "DELETE FROM `properties` WHERE PID = %d LIMIT 1", editid);
        mysql_tquery(SQL_Handle, query);

        SendClientMessageEx(playerid, -1, ""CSS_ERROR"SERVER: "CSS_WHITE"You have deleted Property ID %d", editid);
        Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");

    } else return Dialog_Show(playerid, PROPERTYMENU, DIALOG_STYLE_LIST, "Property Management", "Create Property\nName Property\nChange Type\nChange Interior\nChange Pickup Type\nDelete Property", "Select", "Back");
    return 1;
}
