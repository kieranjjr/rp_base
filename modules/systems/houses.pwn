// Housing System
new Float:HouseInteriors[][] =
{
    { 243.9681,-1851.0673,3333.9329 }, // House Int
    { 2260.268798, -1136.082885, 1050.632812 },
    { 2269.389404, -1210.436767, 1047.562500 },
    { 2365.161865,-1135.018554,1050.875 },
    { 2237.725097,-1080.449096,1049.023437 },
    { 2308.842529,-1211.722167,1049.023437 },
    { 2283.092529,-1139.795166,1050.898437 },
    { 2317.780273,-1025.810302,1050.217773 },
    { 244.125152,304.773101,999.148437 },
    { 2324.419921,-1145.568359,1050.710083 },
    { 1298.597900, -796.083007, 1084.0 },
    { 2332.923828, -1076.169433, 1049.023437 },
    { 385.8040,1471.7699,1080.1875 },
    { 375.9720,1417.2699,1081.3281 },
    { 328.0446,1478.8771,1084.4375 },
    { 446.8716,1397.5302,1084.3047 },
    { 227.7230,1114.3899,1080.9922 },
    { 261.1731,1285.9613,1080.2578 },
    { 140.3826,1368.5656,1083.8632 },
    { -42.3809,1407.2510,1084.4297 },
    { 83.2081,1323.7213,1083.8594 },
    { 260.9420,1238.5099,1084.2578 },
    { 1.7468, -3.0922, 999.4284 }
};

new HouseInteriorID[][][32] =
{
    { "Custom House", 1 },
    { "House 1", 10},
    { "House 2", 10},
    { "House 3", 8},
    { "House 4", 2},
    { "House 5", 6},
    { "House 6", 11},
    { "House 7", 9},
    { "House 8", 1},
    { "House 9", 12},
    { "House 10 (Maddogg Mansion)", 5},
    { "House 11", 6},
    { "House 19", 15},
    { "House 20", 15},
    { "House 21", 15},
    { "House 22", 2},
    { "House 23", 5},
    { "House 24", 4},
    { "House 25", 5},
    { "House 26", 8},
    { "House 27", 9},
    { "House 28", 9},
    { "Trailer Interior", 2}
};


RetreiveHouseData() {
    mysql_tquery(SQL_Handle, "SELECT * FROM `houses` ORDER BY HID ASC", "LoadAllHouses");
    return 1;
}

forward RetreiveHouseSQLID(playerid);
public RetreiveHouseSQLID(playerid)
{
    CharacterInfo[playerid][cEditingID] = cache_insert_id();
    cHouse[CharacterInfo[playerid][cEditingID]][hID] = CharacterInfo[playerid][cEditingID];
    return 1;
}

forward LoadAllHouses();
public LoadAllHouses() {
    if(cache_num_rows()) {
        for(new h = 1; h < cache_num_rows(); h++) {
            cache_get_value_name_int(h, "HID", cHouse[h][hID]);
            cache_get_value_name(h, "Name", cHouse[h][hName]);
            cache_get_value_name_int(h, "OwnerCID", cHouse[h][hOwnerCID]);
            cache_get_value_name_int(h, "Price", cHouse[h][hPrice]);
            cache_get_value_name_float(h, "ExtX", cHouse[h][ExtX]);
            cache_get_value_name_float(h, "ExtY", cHouse[h][ExtY]);
            cache_get_value_name_float(h, "ExtZ", cHouse[h][ExtZ]);
            cache_get_value_name_float(h, "IntX", cHouse[h][IntX]);
            cache_get_value_name_float(h, "IntY", cHouse[h][IntY]);
            cache_get_value_name_float(h, "IntZ", cHouse[h][IntZ]);
            cache_get_value_name_int(h, "Interior", cHouse[h][hInterior]);
            cache_get_value_name_int(h, "Locked", cHouse[h][hLocked]);
            cache_get_value_name_int(h, "Safe", cHouse[h][hSafe]);

            CreateHouse(h);
        }
    }
    print("MYSQL: All Houses Loaded.");
}

ReloadHouse(h) {
    DestroyDynamic3DTextLabel(cHouse[h][hLabelID]);
    DestroyDynamicPickup(cHouse[h][hPickupID]);
    CreateHouse(h);
    return 1;
}

/*FindHouse(h) {
    new query[128];
    mysql_format(SQL_Handle, query, sizeof(query), "SELECT * FROM `houses` WHERE HID = %d LIMIT 1", cHouse[h][hID]);
    mysql_tquery(SQL_Handle, query, "ReloadingHouse", "d", h);
    return 1;
}

forward ReloadingHouse(h);
public ReloadingHouse(h) {
    if(cache_num_rows()) {
        cache_get_value_name_int(h, "HID", cHouse[h][hID]);
        cache_get_value_name(h, "Name", cHouse[h][hName]);
        cache_get_value_name_int(h, "OwnerCID", cHouse[h][hOwnerCID]);
        cache_get_value_name_int(h, "Price", cHouse[h][hPrice]);
        cache_get_value_name_float(h, "ExtX", cHouse[h][ExtX]);
        cache_get_value_name_float(h, "ExtY", cHouse[h][ExtY]);
        cache_get_value_name_float(h, "ExtZ", cHouse[h][ExtZ]);
        cache_get_value_name_float(h, "IntX", cHouse[h][IntX]);
        cache_get_value_name_float(h, "IntY", cHouse[h][IntY]);
        cache_get_value_name_float(h, "IntZ", cHouse[h][IntZ]);
        cache_get_value_name_int(h, "Interior", cHouse[h][hInterior]);
        cache_get_value_name_int(h, "World", cHouse[h][hWorld]);
        cache_get_value_name_int(h, "Locked", cHouse[h][hLocked]);
        cache_get_value_name_int(h, "Safe", cHouse[h][hSafe]);

        CreateHouse(h);
        printf("MYSQL: %d House ID reloaded.", cHouse[h][hID]);
    } else print("MYSQL: No house found.");   
}*/

forward CreateHouse(HouseID);
public CreateHouse(HouseID) {
    new str[128];
    if(cHouse[HouseID][hOwnerCID] == 0) {
        format(str, sizeof(str), ""CSS_RED"FOR SALE\n"CSS_WHITE"%s\nPrice: $%d \n", cHouse[HouseID][hName], cHouse[HouseID][hPrice]);
        cHouse[HouseID][hLabelID] = CreateDynamic3DTextLabel(str, HEX_WHITE, cHouse[HouseID][ExtX], cHouse[HouseID][ExtY], cHouse[HouseID][ExtZ]+0.5, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0);
        cHouse[HouseID][hPickupID]  = CreateDynamicPickup(1273, 23, cHouse[HouseID][ExtX], cHouse[HouseID][ExtY], cHouse[HouseID][ExtZ], 0, 0, -1, 250);
    } else if(cHouse[HouseID][hOwnerCID] > 0) {
        new query[128];
        mysql_format(SQL_Handle, query, sizeof(query), "SELECT `Name` FROM characters WHERE charid = %d LIMIT 1", cHouse[HouseID][hOwnerCID]);
        mysql_tquery(SQL_Handle, query, "CreateOwnerLabel", "i", HouseID);
        cHouse[HouseID][hPickupID]  = CreateDynamicPickup(1273, 23, cHouse[HouseID][ExtX], cHouse[HouseID][ExtY], cHouse[HouseID][ExtZ], 0, 0, -1, 250);
    }
    return 1;
}

forward CreateOwnerLabel(HouseID);
public CreateOwnerLabel(HouseID) {
    new str[128], name[MAX_PLAYER_NAME], OwnerName[MAX_PLAYER_NAME];
    cache_get_value_name(0, "Name", OwnerName);
    strmid(name, str_replace('_', ' ', OwnerName), 0, MAX_PLAYER_NAME);
    format(str, sizeof(str), "%s\n"CSS_WHITE"Owner: %s", cHouse[HouseID][hName], name);
    cHouse[HouseID][hLabelID] = CreateDynamic3DTextLabel(str, HEX_WHITE, cHouse[HouseID][ExtX], cHouse[HouseID][ExtY], cHouse[HouseID][ExtZ]+0.5, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0);
    return 1;
}