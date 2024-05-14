forward LoadCharacters(playerid);
public LoadCharacters(playerid) {
    new query[128];

    mysql_format(SQL_Handle, query, sizeof(query), "SELECT charid, Name, Skin FROM characters WHERE mID = '%d' LIMIT 3", MasterInfo[playerid][mUID]);
    mysql_tquery(SQL_Handle, query, "ShowCharacterMenu", "d", playerid);
    printf("SERVER: %s's characters selected from the database.", GetName(playerid));
    MasterInfo[playerid][mName] = GetName(playerid);
    return 1;

}    

forward ShowCharacterMenu(playerid);
public ShowCharacterMenu(playerid) {
    
    new skinid[3],
        name[3][MAX_PLAYER_NAME]
    ;
    
    new rows = cache_num_rows();

    for(new i; i < rows; i++) {
        cache_get_value_name_int(i, "Skin", skinid[i]);
        cache_get_value_name(i, "Name", name[i]);
        cache_get_value_name_int(i, "charid", CharacterInfo[playerid][cID][i]);
    }
    if(rows == 0) {
        MasterInfo[playerid][mChars] = 0;

        PlayerTextDrawSetPreviewModel(playerid, characterone, 256);
        
        PlayerTextDrawSetString(playerid, charnameone, "Create Character");
        
    } else if(rows == 1) {
        PlayerTextDrawSetPreviewModel(playerid, characterone, skinid[0]);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, 186);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, 186);
        
        PlayerTextDrawSetString(playerid, charnameone, name[0]);
        PlayerTextDrawSetString(playerid, charnametwo, "Create Character");
        PlayerTextDrawSetString(playerid, charnamethree, "Create Character");
    } else if(rows == 2) {
        PlayerTextDrawSetPreviewModel(playerid, characterone, skinid[0]);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, skinid[1]);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, 186);
        
        PlayerTextDrawSetString(playerid, charnameone, name[0]);
        PlayerTextDrawSetString(playerid, charnametwo, name[1]);
        PlayerTextDrawSetString(playerid, charnamethree, "Create Character");
    } else if(rows == 3) {
        PlayerTextDrawSetPreviewModel(playerid, characterone, skinid[0]);
        PlayerTextDrawSetPreviewModel(playerid, charactertwo, skinid[1]);
        PlayerTextDrawSetPreviewModel(playerid, characterthree, skinid[2]);
        
        PlayerTextDrawSetString(playerid, charnameone, name[0]);
        PlayerTextDrawSetString(playerid, charnametwo, name[1]);
        PlayerTextDrawSetString(playerid, charnamethree, name[2]);
    } else return printf("SERVER: Something went wrong with extracting %s's characters", GetName(playerid));
    
    ShowCharacterDraws(playerid);
    SelectTextDraw(playerid, 0xBDBEC6AA);
    return 1;
}