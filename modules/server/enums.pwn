enum E_MASTER_INFO {
	mUID,
	mChars,
	bool:mLogged,
	mAdmin,
	mVIP
};

new MasterInfo[MAX_PLAYERS][E_MASTER_INFO];

enum E_CHARACTER_INFO {
    cIDOne,
    cIDTwo,
    cIDThree,
    cLoggedID,
    bool:cSpawned,
    bool:cFirstSpawn,
    bool:cLogged,
    cName[MAX_PLAYER_NAME],
    cSkin,
    cGender,
    cDOB,
    Float:cPosX,
    Float:cPosY,
    Float:cPosZ,
    Float:cRot
};

new CharacterInfo[MAX_PLAYERS][E_CHARACTER_INFO];