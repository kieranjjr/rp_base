// Business System
new Float:BusinessInteriorPos[][] =
{
    { -25.7114, -187.821, 1003.5469 }, // 24/7 1
    { 6.08, -28.89, 1003.54 }, // 24/7 2
    { -30.98, -89.68, 1003.54 }, // 24/7 3
    { 1330.4513, 1539.5085, 30.0850}, // Custom 24/7
    { 315.24, -140.88, 999.60 }, // Ammunation 1
    { 285.83, -39.01, 1001.51 }, // Ammunation 2
    { 291.76, -80.13, 1001.51 }, // Ammunation 3 - 4
    { 297.14, -109.87, 1001.51 }, // Ammunation 4 - 6
    { 316.50, -167.62, 999.59 }, // Ammunation 5 - 6
    { 504.8672, -2318.2749, 512.7908 }, // Custom Illegal Gunshop
    { -2158.67, 642.09, 1052.37 }, // Betting Shop
    { 830.60, 5.94, 1004.17 }, // Off Track Betting
    { -100.26, -22.93, 1000.71 }, // Sex Shop
    { -2240.10, 136.97, 1035.41 }, // Electronic Shop
    { 207.52, -109.74, 1005.13 }, // Binco
    { 204.16, -165.76, 1000.52 }, // Didier Sachs
    { 961.9308, -51.9071, 1001.1172 }, // Zip Clothing
    { 225.03,   -9.18, 1002.21   }, // Victim
    { 204.11, -46.80, 1001.80   }, // Sub Urban
    { 493.14, -24.26, 1000.67 }, // Club
    { 501.95, -70.56, 998.75 }, // Bar
    { 1461.2657, 1724.5465, 126.1012 }, // Custom Bar
    { -228.4855, 1401.5221, 27.7656 }, // Lil Probe inn
    { 459.6219, -88.8032, 999.5547 }, // Jays Diner
    { 366.02, -73.34, 1001.50 }, // Burger Shot
    { 366.00, -9.43, 1001.85 }, // Cluckin Bell
    { 378.02, -190.51, 1000.637 }, // Dohnut Place
    { 372.55, -131.36, 1001.49 }, // Pizza Shack
    { 407.57, -136.39, 1001.58 }, // Custom Shack
    { 2016.11, 1017.15, 996.87 }, // Four Dragons 10
    { 1133.34, -7.84, 1000.67 }, // Small Casino 12
    { 2233.93, 1711.80, 1011.63 }, // Caligulas Casino 1
    { 770.80, -0.70, 1000.72 }, // Ganton Gym 5
    { 773.88, -47.76, 1000.58 }, // Cobra Gym 6
    { 773.73, -74.69, 1000.65 }, // Below Belt Gym 7
    { 974.01, -9.59, 1001.14 }, // Brothel 1 - 3
    { 961.93, -51.90, 1001.11 }, // Brothel 2 - 3
    { 1212.14, -28.53, 1000.95 }, // Big Spread Ranch - 3
    { 1204.66, -13.54, 1000.92 }, // Pig Pen - 2
    { -2638.82, 1407.33, 906.46 }, // Pleasure Domes 3
    { 963.05, 2159.75, 1011.03 }, // Abatoir - 1
    { 621.3398,-2121.0256,515.2236 }, // Club Interior
    { 331.8281,2895.4165,2499.7476 }, // Gang Interior
    { 412.9000, 157.0969, 1026.6707 }, // Custom Bar
    { -14.2135,100.4411,1101.5211 } // Fightclub TP
};

new BusinessInteriors[][][32] =
{
    { "Convenience Store", 17 },
    { "Convenience Store 2", 10 },
    { "Convenience Store 2", 18 },
    { "Custom Convenience Store", 1 },
    { "Ammunation 1", 7 },
    { "Ammunation 2", 1 },
    { "Ammunation 3", 4 },
    { "Ammunation 4", 6 },
    { "Ammunation 5", 6 },
    { "Illegal Gunshop", 1 },
    { "Betting Shop", 1 } ,
    { "Off Track Betting", 3 },
    { "Sex Shop",  3 },
    { "Electronic Shop", 6 },
    { "Binco",  15 },
    { "Didier Sachs", 14 },
    { "Zip Clothing", 18 },
    { "Victim Clothing", 5 },
    { "Suburban", 1 },
    { "Club", 17 },
    { "Bar", 11 },
    { "Custom Bar", 1 },
    { "Lil Probe Inn", 18 },
    { "Jay's Diner", 4 },
    { "Burger Shot", 10 },
    { "Cluckin' Bell", 9 },
    { "Rusty Browns Donuts", 17 },
    { "Pizza Shack", 5 },
    { "Custom Shack", 1 },
    { "Four Dragons", 10 },
    { "Small Casino", 12 }, 
    { "Caligulas Casino", 1 },
    { "Ganton Gym", 5 },
    { "Cobra Gym", 6 },
    { "Below The Belt Gym", 7 },
    { "Brothel 1", 3 },
    { "Brothel 2", 3 },
    { "Big Spread Ranch", 3 },
    { "The Pig Pen", 2 },
    { "The Pleasure Domes", 3 },
    { "Abatoir", 1 },
    { "Club Interior", 1 },
    { "Gang Interior", 1 },
    { "Custom Bar", 1},
    { "Fightclub", 1 }
};

RetreiveBusinessData() {
    mysql_tquery(SQL_Handle, "SELECT * FROM `businesses` ORDER BY BID ASC", "LoadAllBusinesses");
    return 1;
}

forward RetreiveBusinessSQLID(playerid);
public RetreiveBusinessSQLID(playerid)
{
    CharacterInfo[playerid][cEditingID] = cache_insert_id();
    cBusiness[CharacterInfo[playerid][cEditingID]][bID] = CharacterInfo[playerid][cEditingID];
    return 1;
}

forward LoadAllBusinesses();
public LoadAllBusinesses() {
    if(cache_num_rows()) {
        for(new b = 1; b < cache_num_rows(); b++) {
            cache_get_value_name_int(b, "BID", cBusiness[b][bID]);
            cache_get_value_name(b, "Name", cBusiness[b][bName]);
            cache_get_value_name_int(b, "OwnerCID", cBusiness[b][bOwnerCID]);
            cache_get_value_name_int(b, "Price", cBusiness[b][bPrice]);
            cache_get_value_name_float(b, "ExtX", cBusiness[b][ExtX]);
            cache_get_value_name_float(b, "ExtY", cBusiness[b][ExtY]);
            cache_get_value_name_float(b, "ExtZ", cBusiness[b][ExtZ]);
            cache_get_value_name_float(b, "IntX", cBusiness[b][IntX]);
            cache_get_value_name_float(b, "IntY", cBusiness[b][IntY]);
            cache_get_value_name_float(b, "IntZ", cBusiness[b][IntZ]);
            cache_get_value_name_int(b, "Interior", cBusiness[b][bInterior]);
            cache_get_value_name_int(b, "Locked", cBusiness[b][bLocked]);
            cache_get_value_name_int(b, "Safe", cBusiness[b][bSafe]);

            CreateBusiness(b);
        }
    }
    print("MYSQL: All Businesses Loaded.");
}

ReloadBusiness(b) {
    DestroyDynamic3DTextLabel(cBusiness[b][bLabelID]);
    DestroyDynamicPickup(cBusiness[b][bPickupID]);
    CreateBusiness(b);
    return 1;
}



forward CreateBusiness(BizID);
public CreateBusiness(BizID) {
    new str[128];
    if(cBusiness[BizID][bOwnerCID] == 0) {
        format(str, sizeof(str), ""CSS_BLUE"FOR SALE\n"CSS_WHITE"%s\nPrice: $%d \n", cBusiness[BizID][bName], cBusiness[BizID][bPrice]);
        cBusiness[BizID][bLabelID] = CreateDynamic3DTextLabel(str, HEX_WHITE, cBusiness[BizID][ExtX], cBusiness[BizID][ExtY], cBusiness[BizID][ExtZ]+0.5, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0);
        cBusiness[BizID][bPickupID]  = CreateDynamicPickup(1272, 23, cBusiness[BizID][ExtX], cBusiness[BizID][ExtY], cBusiness[BizID][ExtZ], 0, 0, -1, 250);
    } else if(cBusiness[BizID][bOwnerCID] > 0) {
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "SELECT `Name` FROM characters WHERE charid = %d LIMIT 1", cBusiness[BizID][bOwnerCID]);
        mysql_tquery(SQL_Handle, query, "CreateBusinessOwnerLabel", "i", BizID);
        cBusiness[BizID][bPickupID]  = CreateDynamicPickup(1272, 23, cBusiness[BizID][ExtX], cBusiness[BizID][ExtY], cBusiness[BizID][ExtZ], 0, 0, -1, 250);
    }
    return 1;
}

forward CreateBusinessOwnerLabel(BizID);
public CreateBusinessOwnerLabel(BizID) {
    new str[128], name[MAX_PLAYER_NAME], OwnerName[MAX_PLAYER_NAME];
    cache_get_value_name(0, "Name", OwnerName);
    strmid(name, str_replace('_', ' ', OwnerName), 0, MAX_PLAYER_NAME);
    format(str, sizeof(str), "%s\n"CSS_WHITE"Owner: %s", cBusiness[BizID][bName], name);
    cBusiness[BizID][bLabelID] = CreateDynamic3DTextLabel(str, HEX_WHITE, cBusiness[BizID][ExtX], cBusiness[BizID][ExtY], cBusiness[BizID][ExtZ]+0.5, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0);
    return 1;
}