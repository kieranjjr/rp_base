enum E_MASTER_INFO {
	mUID,
	mChars,
    mName[MAX_PLAYER_NAME],
	bool:mLogged,
	mAdmin,
	mVIP
};

new MasterInfo[MAX_PLAYERS][E_MASTER_INFO];

enum E_CHARACTER_INFO {
    cID[3],
    cLoggedID,
    bool:cSpawned,
    bool:cFirstSpawn,
    bool:cLogged,
    cName[MAX_PLAYER_NAME],
    cSkin,
    cGender,
    cDOB[15],
    Float:cPosX,
    Float:cPosY,
    Float:cPosZ,
    Float:cRot
};

new CharacterInfo[MAX_PLAYERS][E_CHARACTER_INFO];