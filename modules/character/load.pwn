forward LoadCharacters(playerid);
public LoadCharacters(playerid) {
    new query[128];

    mysql_format(SQL_Handle, query, sizeof(query), "SELECT charid, name, skin FROM characters WHERE mid = '%d' LIMIT 3", MasterInfo[playerid][mUID]);
    mysql_tquery(SQL_Handle, query, "ShowCharacterMenu", "d", playerid);
    print("-d1");
    return 1;

}

forward ShowCharacterMenu(playerid);
public ShowCharacterMenu(playerid) {
    
    new cSkinOne, cSkinTwo, cSkinThree;
    new cNameOne[MAX_PLAYER_NAME], cNameTwo[MAX_PLAYER_NAME], cNameThree[MAX_PLAYER_NAME];


    if(cache_num_rows() == 1) {
        MasterInfo[playerid][mChars] = 1;
            
        cache_get_value_name(0, "name", cNameOne);
        cache_get_value_name_int(0, "skin", cSkinOne);
        cache_get_value_name_int(0, "charid", CharacterInfo[playerid][cIDOne]);
            
        PlayerTextDrawSetPreviewModel(playerid, characterone, cSkinOne);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, 256);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, 256);
        PlayerTextDrawSetString(playerid, charnameone, cNameOne);
        PlayerTextDrawSetString(playerid, charnametwo, "Create Character");
        PlayerTextDrawSetString(playerid, charnamethree, "Create Character");
        
    } else if(cache_num_rows() == 2) {
        MasterInfo[playerid][mChars] = 2;

        cache_get_value_name(0, "name", cNameOne);
        cache_get_value_name_int(0, "skin", cSkinOne);
        cache_get_value_name_int(0, "charid", CharacterInfo[playerid][cIDOne]);
        cache_get_value_name(1, "name", cNameTwo);
        cache_get_value_name_int(1, "skin", cSkinTwo);
        cache_get_value_name_int(1, "charid", CharacterInfo[playerid][cIDTwo]);

        PlayerTextDrawSetPreviewModel(playerid, characterone, cSkinOne);
        PlayerTextDrawSetString(playerid, charnameone, cNameOne);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, cSkinTwo);
        PlayerTextDrawSetString(playerid, charnametwo, cNameTwo);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, 256);
        PlayerTextDrawSetString(playerid, charnamethree, "Create Character");

    } else if(cache_num_rows() == 3) {
        MasterInfo[playerid][mChars] = 3;

        cache_get_value_name(0, "name", cNameOne);
        cache_get_value_name_int(0, "skin", cSkinOne);
        cache_get_value_name_int(0, "charid", CharacterInfo[playerid][cIDOne]);
        cache_get_value_name(1, "name", cNameTwo);
        cache_get_value_name_int(1, "skin", cSkinTwo);
        cache_get_value_name_int(1, "charid", CharacterInfo[playerid][cIDTwo]);
        cache_get_value_name(2, "name", cNameThree);
        cache_get_value_name_int(2, "skin", cSkinThree);
        cache_get_value_name_int(2, "charid", CharacterInfo[playerid][cIDThree]);

        PlayerTextDrawSetPreviewModel(playerid, characterone, cSkinOne);
        PlayerTextDrawSetString(playerid, charnameone, cNameOne);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, cSkinTwo);
        PlayerTextDrawSetString(playerid, charnametwo, cNameTwo);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, cSkinThree);
        PlayerTextDrawSetString(playerid, charnamethree, cNameThree);

    } else {
        MasterInfo[playerid][mChars] = 0;

        PlayerTextDrawSetPreviewModel(playerid, characterone, 256);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, 256);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, 256);
        PlayerTextDrawSetString(playerid, charnameone, "Create Character");
        PlayerTextDrawSetString(playerid, charnametwo, "Create Character");
        PlayerTextDrawSetString(playerid, charnamethree, "Create Character");
    }
    ShowCharacterDraws(playerid);
    SelectTextDraw(playerid, 10310310308);
    return 1;
}
