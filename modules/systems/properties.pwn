// Properties
new Float:PropertyInteriorPos[][] =
{
    { 411.97,-51.92,1001.89 }, // Barber 1
    { 414.29,-18.80,1001.80 }, // Barber 2
    { 418.46,-80.45,1001.80 }, // Barber 3
    { -201.22,-43.24,1002.27 }, // Tattoo
    { 1568.8512, -1679.2280, 2113.0349 }, // Custom LSPD First Floor
    { 1565.5836, -1693.0845, 62.1910 }, // Custom LSPD Second Floor
    { 246.5752, 63.0245, 1003.6406 }, // LSPD
    { 322.3930, 302.8665, 999.1484 }, // Small PD
    { 246.2128, 108.1887, 1003.2188 }, // SFPD
    { 288.4313, 167.8623, 1007.1719 }, // LVPD
    { -2031.11, -115.82, 1035.17 }, // Driving School
    { 1306.4430, 3.3189, 1001.0270 }, // Warehouse 1
    { 1416.7596, 4.1261, 1000.9219 }, // Warehouse 2
    { 1893.07,1017.89,31.88 }, // Janitors Office
    { 2217.28,-1150.53,1025.79 }, // Jefferson Motel
    { -944.24,1886.15,5.00 }, // Sherman Dam
    { 1727.28,-1642.94,20.22 }, // Atrium
    { 2306.38,-15.23,26.74 }, // Bank
    { 1470.1064,-1013.9631,38.1769 }, // Custom Bank
    { 1288.1755,1544.8130,334.2287 }, //Apartment 1
    { 2210.6499,1865.5934,-68.6355 }, // Apartment 2
    { 2220.26, -1148.01, 1025.80 }, // Jefferson Motel
    { 1520.4611,-1639.8770,1124.5045 }, // Small Garage
    { 1520.5280,-1640.0831,1374.5045 }, // Medium Garage
    { 1660.4203,-2366.7515,1535.4829 }, // Large Garage
    { -942.0429, 1847.6116, 5.0051 } // Sherman Damm

};

new PropertyInteriors[][][32] =
{
    { "Barber Shop 1", 12 },
    { "Barber Shop 2", 2 },
    { "Barber Shop 3", 3 },
    { "Tattoo Parlour", 3 },
    { "Custom LSPD Floor 1", 1 },
    { "Custom LSPD Floor 2", 1 },
    { "LSPD", 6 },
    { "Small Police Dept.", 5 },
    { "SFPD", 10 },
    { "LVPD", 3 },
    { "Driving School",  3 },
    { "Warehouse 1", 18 },
    { "Warehouse 2", 1},
    { "Janitors Office", 10 },
    { "Jefferson Motel", 15 },
    { "Sherman Dam", 17 },
    { "Rosenbergs Office", 2 },
    { "Atrium", 18 },
    { "Palamino Bank", 0 },
    { "Custom Bank", 0 },
    { "Apartment Block 1", 0 },
    { "Apartment Block 2", 0 },
    { "Jefferson Motel", 15 },
    { "Custom Small Garage", 0 },
    { "Custom Medium Garage", 0 },
    { "Custom Large Garage", 0 },
    { "Shermann Dam", 14 }
};

RetreivePropertyData() {
    mysql_tquery(SQL_Handle, "SELECT * FROM `properties` ORDER BY PID ASC", "LoadAllProperties");
    return 1;
}

forward RetreivePropertySQLID(playerid);
public RetreivePropertySQLID(playerid)
{
    CharacterInfo[playerid][cEditingID] = cache_insert_id();
    sProperty[CharacterInfo[playerid][cEditingID]][pID] = CharacterInfo[playerid][cEditingID];
    return 1;
}

forward LoadAllProperties();
public LoadAllProperties() {
    if(cache_num_rows()) {
        for(new id = 1; id < cache_num_rows(); id++) {
            cache_get_value_name_int(id, "PID", sProperty[id][pID]);
            cache_get_value_name(id, "Name", sProperty[id][pName]);
            cache_get_value_name_int(id, "Type", sProperty[id][pType]);
            cache_get_value_name_int(id, "PickupID", sProperty[id][pPickupType]);
            cache_get_value_name_float(id, "ExtX", sProperty[id][ExtX]);
            cache_get_value_name_float(id, "ExtY", sProperty[id][ExtY]);
            cache_get_value_name_float(id, "ExtZ", sProperty[id][ExtZ]);
            cache_get_value_name_float(id, "IntX", sProperty[id][IntX]);
            cache_get_value_name_float(id, "IntY", sProperty[id][IntY]);
            cache_get_value_name_float(id, "IntZ", sProperty[id][IntZ]);
            cache_get_value_name_int(id, "Interior", sProperty[id][pInterior]);
            cache_get_value_name_int(id, "Locked", sProperty[id][pLocked]);

            CreateProperty(id);
        }
    } else print("MYSQL: No Properties ?");
    print("MYSQL: All Properties Loaded.");
}

ReloadProperty(id) {
    DestroyDynamic3DTextLabel(sProperty[id][pLabelID]);
    DestroyDynamicPickup(sProperty[id][pPickupID]);
    CreateProperty(id);
    return 1;
}

forward CreateProperty(id);
public CreateProperty(id) {

    new str[128];
    format(str, sizeof(str), ""CSS_WHITE"%s", sProperty[id][pName]);
    sProperty[id][pPickupID] = CreateDynamicPickup(sProperty[id][pPickupType], 23, sProperty[id][ExtX], sProperty[id][ExtY], sProperty[id][ExtZ], 0, 0, -1, 250);
    sProperty[id][pLabelID] = CreateDynamic3DTextLabel(str, HEX_WHITE, sProperty[id][ExtX], sProperty[id][ExtY], sProperty[id][ExtZ]+0.5, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 20.0);
    return 1;
}

