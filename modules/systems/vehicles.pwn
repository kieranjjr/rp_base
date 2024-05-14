// Vehicle System

new VehicleNames[212][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus","Voodoo", "Pony",
    "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
    "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
    "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad",
    "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
    "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa",
    "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust",
    "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet",
    "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
    "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
    "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor", "Wayfarer", "Euros",
    "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger",
    "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};

GetVehicleName(modelid) {
    new string[20];
    format(string, sizeof(string), "%s", VehicleNames[modelid - 400]);
    return string;
}


RetreiveVehicleData() {
     mysql_tquery(SQL_Handle, "SELECT * FROM `vehicles` WHERE `OwnerCID` = '0'", "LoadServerVehicles", "");
     return 1;
}

forward LoadServerVehicles();
public LoadServerVehicles() {

    if(cache_num_rows()) {
        for(new id = 1; id < cache_num_rows(); id++) {
            
            cache_get_value_name_int(id, "Model", VehicleInfo[id][vModel]);
            cache_get_value_name(id, "Name", VehicleInfo[id][vName]);
            cache_get_value_name_int(id, "Type", VehicleInfo[id][vType]);
            cache_get_value_name(id, "Plate", VehicleInfo[id][vPlate]);
            cache_get_value_name_int(id, "Price", VehicleInfo[id][vPrice]);
            cache_get_value_name_int(id, "ColourOne", VehicleInfo[id][vColourOne]);
            cache_get_value_name_int(id, "ColourTwo", VehicleInfo[id][vColourTwo]);
            cache_get_value_name_float(id, "X", VehicleInfo[id][vX]);
            cache_get_value_name_float(id, "Y", VehicleInfo[id][vY]);
            cache_get_value_name_float(id, "Z", VehicleInfo[id][vZ]);
            cache_get_value_name_float(id, "A", VehicleInfo[id][vA]);

            VehicleInfo[id][vSession] = CreateVehicle(VehicleInfo[id][vModel], VehicleInfo[id][vX], VehicleInfo[id][vY], VehicleInfo[id][vZ], VehicleInfo[id][vA], VehicleInfo[id][vColourOne], VehicleInfo[id][vColourTwo], -1);

            cache_get_value_name_int(id, "VID", VehicleInfo[id][vID]);

            SetVehicleToRespawn(VehicleInfo[id][vSession]);
            SetVehicleParamsEx(VehicleInfo[id][vSession], false, false, false, false, false, false, false);
            SetVehicleNumberPlate(VehicleInfo[id][vSession], RandomNumberPlate());
        }
    }
    return 1;
}

forward LoadCharacterVehicles(playerid);
public LoadCharacterVehicles(playerid) {

    if(cache_num_rows()) {
        for(new id = 1; id < cache_num_rows(); id++) {

            cache_get_value_name_int(id, "Model", VehicleInfo[id][vModel]);
            cache_get_value_name(id, "Name", VehicleInfo[id][vName]);
            cache_get_value_name(id, "Plate", VehicleInfo[id][vPlate]);
            cache_get_value_name_int(id, "Type", VehicleInfo[id][vType]);
            cache_get_value_name_int(id, "Price", VehicleInfo[id][vPrice]);
            cache_get_value_name_int(id, "Lock", VehicleInfo[id][vLock]);
            cache_get_value_name_int(id, "ColourOne", VehicleInfo[id][vColourOne]);
            cache_get_value_name_int(id, "ColourTwo", VehicleInfo[id][vColourTwo]);
            cache_get_value_name_int(id, "Mod_1", VehicleInfo[id][vMod][0]);
            cache_get_value_name_int(id, "Mod_2", VehicleInfo[id][vMod][1]);
            cache_get_value_name_int(id, "Mod_3", VehicleInfo[id][vMod][2]);
            cache_get_value_name_int(id, "Mod_4", VehicleInfo[id][vMod][3]);
            cache_get_value_name_int(id, "Mod_5", VehicleInfo[id][vMod][4]);
            cache_get_value_name_int(id, "Mod_6", VehicleInfo[id][vMod][5]);
            cache_get_value_name_int(id, "Mod_7", VehicleInfo[id][vMod][6]);
            cache_get_value_name_int(id, "Mod_8", VehicleInfo[id][vMod][7]);
            cache_get_value_name_int(id, "Mod_9", VehicleInfo[id][vMod][8]);
            cache_get_value_name_int(id, "Mod_10", VehicleInfo[id][vMod][9]);
            cache_get_value_name_int(id, "Mod_11", VehicleInfo[id][vMod][10]);
            cache_get_value_name_int(id, "Mod_12", VehicleInfo[id][vMod][11]);
            cache_get_value_name_int(id, "Mod_13", VehicleInfo[id][vMod][12]);
            cache_get_value_name_int(id, "Mod_14", VehicleInfo[id][vMod][13]);
            cache_get_value_name_float(id, "X", VehicleInfo[id][vX]);
            cache_get_value_name_float(id, "Y", VehicleInfo[id][vY]);
            cache_get_value_name_float(id, "Z", VehicleInfo[id][vZ]);
            cache_get_value_name_float(id, "A", VehicleInfo[id][vA]);

            VehicleInfo[id][vSession] = CreateVehicle(VehicleInfo[id][vModel], VehicleInfo[id][vX], VehicleInfo[id][vY], VehicleInfo[id][vZ], VehicleInfo[id][vA], VehicleInfo[id][vColourOne], VehicleInfo[id][vColourTwo], -1);

            cache_get_value_name_int(id, "vehID", VehicleInfo[id][vID]);

            format(VehicleInfo[id][vName], MAX_PLAYER_NAME, GetVehicleName(VehicleInfo[id][vModel]));
            format(VehicleInfo[id][vPlate], 16, VehicleInfo[id][vPlate]);

            SetVehicleToRespawn(VehicleInfo[id][vSession]);
            SetVehicleParamsEx(VehicleInfo[id][vSession], false, false, false, VehicleInfo[id][vLock], false, false, false);
            SetVehicleNumberPlate(VehicleInfo[id][vSession], VehicleInfo[id][vPlate]);
            for(new x = 0; x < 14; x++) if(VehicleInfo[id][vMod][x] > 0) AddVehicleComponent(VehicleInfo[id][vSession], VehicleInfo[id][vMod][x]);
        }
    }
    return 1;
}

SaveVehicle(vehicleid) {

    format(VehicleInfo[vehicleid][vName], 16, GetVehicleName(VehicleInfo[vehicleid][vModel]));
    GetVehiclePos(VehicleInfo[vehicleid][vSession], VehicleInfo[vehicleid][vX], VehicleInfo[vehicleid][vY], VehicleInfo[vehicleid][vZ]);
    GetVehicleZAngle(VehicleInfo[vehicleid][vSession], VehicleInfo[vehicleid][vA]);

    new query[500];
    mysql_format(SQL_Handle, query, sizeof(query), "UPDATE `Vehicles` SET `Name` = '%e', `Lock` = %i, `Model` = %i,\
    `Plate` = '%e', `Mod_1` = %i, `Mod_2` = %i, `Mod_3` = %i, `Mod_4` = %i, `Mod_5` = %i, `Mod_6` = %i, `Mod_7` = %i,\
    `Mod_8` = %i, `Mod_9` = %i, `Mod_10` = %i, `Mod_11` = %i, `Mod_12` = %i, `Mod_13` = %i, `Mod_14` = %i, `ColourOne` = %i,\
    `ColourTwo` = %i, `X` = %f, `Y` = %f, `Z` = %f, `A` = %f WHERE `VID` = %d", VehicleInfo[vehicleid][vName], VehicleInfo[vehicleid][vLock], VehicleInfo[vehicleid][vModel], 
    VehicleInfo[vehicleid][vPlate], VehicleInfo[vehicleid][vMod][0], VehicleInfo[vehicleid][vMod][1], VehicleInfo[vehicleid][vMod][2], VehicleInfo[vehicleid][vMod][3], VehicleInfo[vehicleid][vMod][4], 
    VehicleInfo[vehicleid][vMod][5], VehicleInfo[vehicleid][vMod][6], VehicleInfo[vehicleid][vMod][7], VehicleInfo[vehicleid][vMod][8], VehicleInfo[vehicleid][vMod][9], VehicleInfo[vehicleid][vMod][10], 
    VehicleInfo[vehicleid][vMod][11], VehicleInfo[vehicleid][vMod][12], VehicleInfo[vehicleid][vMod][13], VehicleInfo[vehicleid][vColourOne], VehicleInfo[vehicleid][vColourTwo],
    VehicleInfo[vehicleid][vX], VehicleInfo[vehicleid][vY], VehicleInfo[vehicleid][vZ], VehicleInfo[vehicleid][vA], VehicleInfo[vehicleid][vID]);
    mysql_tquery(SQL_Handle, query);
    return 1;
}

ResetVehicle(vehicleid) {
    format(VehicleInfo[vehicleid][vPlate], 16, RandomNumberPlate());
    VehicleInfo[vehicleid][vModel] = -1; 
    VehicleInfo[vehicleid][vLock] = false;
    VehicleInfo[vehicleid][vPrice] = 0;
    VehicleInfo[vehicleid][vColourOne] = -1;
    VehicleInfo[vehicleid][vColourTwo] = -1;

    for(new i = 0; i < 14; i++) {
        if(VehicleInfo[vehicleid][vMod][i] > 0) {
            RemoveVehicleComponent(VehicleInfo[vehicleid][vSession], VehicleInfo[vehicleid][vMod][i]);
            VehicleInfo[vehicleid][vMod][i] = 0;
        }
    }

    if(IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][vLabel])) DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][vLabel]);
    DestroyVehicle(VehicleInfo[vehicleid][vSession]);
    return 1;
}

public OnVehicleSpawn(vehicleid) {

    foreach(new playerid : Player) {
        for(new i = 0; i < MAX_VEHICLES; ++i) {
            for(new x = 0; x < 14; x++) {
                if(VehicleInfo[i][vOwnerCID] == CharacterInfo[playerid][cLoggedID]) {
                    if(VehicleInfo[i][vMod][x] > 0) AddVehicleComponent(VehicleInfo[i][vSession], VehicleInfo[i][vMod][x]);
                }
            }
        }
    }
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid) {

    for(new i = 0; i < MAX_VEHICLES; ++i) {
        if(IsPlayerInVehicle(playerid, VehicleInfo[i][vSession])) {
            if(VehicleInfo[i][vOwnerCID] == CharacterInfo[playerid][cLoggedID]) {
                for(new x; x < 14; x++) {
                    if(GetVehicleComponentType(componentid) == x) {
                        VehicleInfo[i][vMod][x] = componentid;
                    }
                }
                SaveVehicle(i);
            }
        }
    }
    return 1;
}