enum E_MASTER_INFO {
	mUID,
	mChars,
    mName[MAX_PLAYER_NAME],
	bool:mLogged,
    mHours,
	mAdmin,
	mVIP,
    mFirstLogin
};

new MasterInfo[MAX_PLAYERS + 1][E_MASTER_INFO];

enum E_CHARACTER_INFO {
    cID[3],
    cLoggedID,
    bool:cSpawned,
    bool:cFirstSpawn,
    bool:cLogged,
    cName[MAX_PLAYER_NAME],
    cHours,
    cPayday,
    cSkin,
    cGender,
    cDOB[15],
    cEditingID,
    cInsideID,
    cInsideProp,
    Float:cPosX,
    Float:cPosY,
    Float:cPosZ,
    Float:cRot,
    cDice,
    cMoney,
    cBank,
    cSavings,
};

new CharacterInfo[MAX_PLAYERS + 1][E_CHARACTER_INFO];

enum E_HOUSE_INFO {
    hID,
    hName[50],
    hOwnerCID,
    hPrice,
    Text3D:hLabelID,
    hPickupID,
    Float:ExtX,
    Float:ExtY,
    Float:ExtZ,
    Float:IntX,
    Float:IntY,
    Float:IntZ,
    hInterior,
    hWorld, // Same as hID so always unique.
    hLocked,
    hSafe,
};

new cHouse[MAX_HOUSES + 1][E_HOUSE_INFO];

enum E_BUSINESS_INFO {
    bID,
    bName[50],
    bOwnerCID,
    bPrice,
    Text3D:bLabelID,
    bPickupID,
    Float:ExtX,
    Float:ExtY,
    Float:ExtZ,
    Float:IntX,
    Float:IntY,
    Float:IntZ,
    bInterior,
    bWorld, // Same as bID so always unique.
    bLocked,
    bSafe,
};

new cBusiness[MAX_BUSINESS + 1][E_BUSINESS_INFO];

enum E_PROPERTY_INFO {
    pID,
    pName[50],
    pType,
    Text3D:pLabelID,
    pPickupID,
    pPickupType,
    Float:ExtX,
    Float:ExtY,
    Float:ExtZ,
    Float:IntX,
    Float:IntY,
    Float:IntZ,
    pInterior,
    pWorld, // Same as pID so always unique.
    pLocked,
};

new sProperty[MAX_PROPERTY + 1][E_PROPERTY_INFO];

enum E_VEHICLE_DATA {
    vID,
    vSession,
    vModel,
    vName[28],
    vType,
    vOwnerCID,
    vPlate[16],
    vPrice,
    bool:vLock,
    vMod[15],
    vColourOne,
    vColourTwo,
    Text3D:vLabel,
    Float:vX,
    Float:vY,
    Float:vZ,
    Float:vA,

};

new VehicleInfo[MAX_VEHICLES + 1][E_VEHICLE_DATA];

new bool:CreatingMenu[MAX_PLAYERS];
new g_str[145];
new TaxValue = 150;