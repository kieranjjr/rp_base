new PlayerText:characterone,
	PlayerText:charactertwo,
	PlayerText:characterthree,
	PlayerText:charnameone,
	PlayerText:charnametwo,
	PlayerText:charnamethree,
	PlayerText:stringtitle,
	Text:toptitlebar,
	Text:bottomtitlebar,
	Text:selecttitle,
	bool:CharDrawsCreated[MAX_PLAYERS]
; 

CreateMainTextDraws() {
	toptitlebar = TextDrawCreate(132.000000, 106.000000, "TextDraw");
	TextDrawFont(toptitlebar, TEXT_DRAW_FONT_MODEL_PREVIEW);
	TextDrawLetterSize(toptitlebar, 0.600000, 2.000000);
	TextDrawTextSize(toptitlebar, 360.000000, 63.500000);
	TextDrawSetOutline(toptitlebar, 1);
	TextDrawSetShadow(toptitlebar, 0);
	TextDrawAlignment(toptitlebar, TEXT_DRAW_ALIGN_LEFT);
	TextDrawColour(toptitlebar, -1);
	TextDrawBackgroundColour(toptitlebar, 45);
	TextDrawBoxColour(toptitlebar, 30);
	TextDrawUseBox(toptitlebar, true);
	TextDrawSetProportional(toptitlebar, true);
	TextDrawSetSelectable(toptitlebar, false);
	TextDrawSetPreviewModel(toptitlebar, 19625);
	TextDrawSetPreviewRot(toptitlebar, -10.000000, 79.000000, -14.000000, 15.000000);
	//TextDrawSetPreviewVehicleColours(toptitlebar, 1, 1);

	bottomtitlebar = TextDrawCreate(132.000000, 326.000000, "TextDraw");
	TextDrawFont(bottomtitlebar, TEXT_DRAW_FONT_MODEL_PREVIEW);
	TextDrawLetterSize(bottomtitlebar, 0.600000, 2.000000);
	TextDrawTextSize(bottomtitlebar, 360.000000, 63.500000);
	TextDrawSetOutline(bottomtitlebar, 1);
	TextDrawSetShadow(bottomtitlebar, 0);
	TextDrawAlignment(bottomtitlebar, TEXT_DRAW_ALIGN_LEFT);
	TextDrawColour(bottomtitlebar, -1);
	TextDrawBackgroundColour(bottomtitlebar, 45);
	TextDrawBoxColour(bottomtitlebar, 30);
	TextDrawUseBox(bottomtitlebar, true);
	TextDrawSetProportional(bottomtitlebar, true);
	TextDrawSetSelectable(bottomtitlebar, false);
	TextDrawSetPreviewModel(bottomtitlebar, 19625);
	TextDrawSetPreviewRot(bottomtitlebar, -10.000000, 79.000000, -14.000000, 15.000000);
	//TextDrawSetPreviewVehicleColours(bottomtitlebar, 1, 1);

	selecttitle = TextDrawCreate(240.000000, 130.000000, "Please select a character.");
	TextDrawFont(selecttitle, TEXT_DRAW_FONT_1);
	TextDrawLetterSize(selecttitle, 0.329165, 3.349997);
	TextDrawTextSize(selecttitle, 400.000000, 17.000000);
	TextDrawSetOutline(selecttitle, 2);
	TextDrawSetShadow(selecttitle, 0);
	TextDrawAlignment(selecttitle, TEXT_DRAW_ALIGN_LEFT);
	TextDrawColour(selecttitle, -1);
	TextDrawBackgroundColour(selecttitle, 255);
	TextDrawBoxColour(selecttitle, 50);
	TextDrawUseBox(selecttitle, false);
	TextDrawSetProportional(selecttitle, true);
	TextDrawSetSelectable(selecttitle, false);

	print("SERVER: Character Background Draws created.");
	return 1;
}


CreateCharacterDraws(playerid) {

	new wString[40];
    format(wString, sizeof(wString), "Welcome back, %s", GetName(playerid));
	
	stringtitle = CreatePlayerTextDraw(playerid,150.000000, 105.000000, wString);
	PlayerTextDrawFont(playerid, stringtitle, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, stringtitle, 0.329165, 3.349997);
	PlayerTextDrawTextSize(playerid, stringtitle, 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, stringtitle, 2);
	PlayerTextDrawSetShadow(playerid, stringtitle, 0);
	PlayerTextDrawAlignment(playerid, stringtitle, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, stringtitle, -1);
	PlayerTextDrawBackgroundColour(playerid, stringtitle, 255);
	PlayerTextDrawBoxColour(playerid, stringtitle, 50);
	PlayerTextDrawUseBox(playerid, stringtitle, false);
	PlayerTextDrawSetProportional(playerid, stringtitle, true);
	PlayerTextDrawSetSelectable(playerid, stringtitle, false);

	characterone = CreatePlayerTextDraw(playerid, 132.000000, 169.000000, "TextDraw");
	PlayerTextDrawFont(playerid, characterone, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid, characterone, 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, characterone, 120.000000, 157.000000);
	PlayerTextDrawSetOutline(playerid, characterone, 1);
	PlayerTextDrawSetShadow(playerid, characterone, 0);
	PlayerTextDrawAlignment(playerid, characterone, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, characterone, -1);
	PlayerTextDrawBackgroundColour(playerid, characterone, 45);
	PlayerTextDrawBoxColour(playerid, characterone, 30);
	PlayerTextDrawUseBox(playerid, characterone, true);
	PlayerTextDrawSetProportional(playerid, characterone, true);
	PlayerTextDrawSetSelectable(playerid, characterone, true);
	PlayerTextDrawSetPreviewModel(playerid, characterone, 0);
	PlayerTextDrawSetPreviewRot(playerid, characterone, -10.000000, 0.000000, -20.000000, 1.149999);
	PlayerTextDrawSetPreviewVehicleColours(playerid, characterone, 1, 1);
	//PlayerTextDrawSetPreviewVehicleColours(playerid, PlayerText:textid, colour1, colour2)

	charactertwo = CreatePlayerTextDraw(playerid, 252.000000, 169.000000, "TextDraw");
	PlayerTextDrawFont(playerid, charactertwo, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid, charactertwo, 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, charactertwo, 120.000000, 157.000000);
	PlayerTextDrawSetOutline(playerid, charactertwo, 1);
	PlayerTextDrawSetShadow(playerid, charactertwo, 0);
	PlayerTextDrawAlignment(playerid, charactertwo, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, charactertwo, -1);
	PlayerTextDrawBackgroundColour(playerid, charactertwo, 45);
	PlayerTextDrawBoxColour(playerid, charactertwo, 30);
	PlayerTextDrawUseBox(playerid, charactertwo, true);
	PlayerTextDrawSetProportional(playerid, charactertwo, true);
	PlayerTextDrawSetSelectable(playerid, charactertwo, true);
	PlayerTextDrawSetPreviewModel(playerid, charactertwo, 0);
	PlayerTextDrawSetPreviewRot(playerid, charactertwo, -10.000000, 0.000000, -20.000000, 1.149999);
	PlayerTextDrawSetPreviewVehicleColours(playerid, charactertwo, 1, 1);

	characterthree = CreatePlayerTextDraw(playerid, 372.000000, 169.000000, "TextDraw");
	PlayerTextDrawFont(playerid, characterthree, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid, characterthree, 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, characterthree, 120.000000, 157.000000);
	PlayerTextDrawSetOutline(playerid, characterthree, 1);
	PlayerTextDrawSetShadow(playerid, characterthree, 0);
	PlayerTextDrawAlignment(playerid, characterthree, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, characterthree, -1);
	PlayerTextDrawBackgroundColour(playerid, characterthree, 45);
	PlayerTextDrawBoxColour(playerid, characterthree, 30);
	PlayerTextDrawUseBox(playerid, characterthree, true);
	PlayerTextDrawSetProportional(playerid, characterthree, true);
	PlayerTextDrawSetSelectable(playerid, characterthree, true);
	PlayerTextDrawSetPreviewModel(playerid, characterthree, 0);
	PlayerTextDrawSetPreviewRot(playerid, characterthree, -10.000000, 0.000000, -20.000000, 1.149999);
	PlayerTextDrawSetPreviewVehicleColours(playerid, characterthree, 1, 1);

	charnameone = CreatePlayerTextDraw(playerid, 150.000000, 337.000000, "");
	PlayerTextDrawFont(playerid, charnameone, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, charnameone, 0.283331, 2.399996);
	PlayerTextDrawTextSize(playerid, charnameone, 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, charnameone, 1);
	PlayerTextDrawSetShadow(playerid, charnameone, 0);
	PlayerTextDrawAlignment(playerid, charnameone, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, charnameone, -1);
	PlayerTextDrawBackgroundColour(playerid, charnameone, 255);
	PlayerTextDrawBoxColour(playerid, charnameone, 50);
	PlayerTextDrawUseBox(playerid, charnameone, false);
	PlayerTextDrawSetProportional(playerid, charnameone, true);

	charnametwo = CreatePlayerTextDraw(playerid, 275.000000, 337.000000, "");
	PlayerTextDrawFont(playerid, charnametwo, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, charnametwo, 0.283331, 2.399996);
	PlayerTextDrawTextSize(playerid, charnametwo, 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, charnametwo, 1);
	PlayerTextDrawSetShadow(playerid, charnametwo, 0);
	PlayerTextDrawAlignment(playerid, charnametwo, TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColour(playerid, charnametwo, -1);
	PlayerTextDrawBackgroundColour(playerid, charnametwo, 255);
	PlayerTextDrawBoxColour(playerid, charnametwo, 50);
	PlayerTextDrawUseBox(playerid, charnametwo, false);
	PlayerTextDrawSetProportional(playerid, charnametwo, true);

	charnamethree = CreatePlayerTextDraw(playerid, 460.000000, 336.000000, "");
	PlayerTextDrawFont(playerid, charnamethree, TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, charnamethree, 0.283331, 2.399996);
	PlayerTextDrawTextSize(playerid, charnamethree, 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, charnamethree, 1);
	PlayerTextDrawSetShadow(playerid, charnamethree, 0);
	PlayerTextDrawAlignment(playerid, charnamethree, TEXT_DRAW_ALIGN_RIGHT);
	PlayerTextDrawColour(playerid, charnamethree, -1);
	PlayerTextDrawBackgroundColour(playerid, charnamethree, 255);
	PlayerTextDrawBoxColour(playerid, charnamethree, 50);
	PlayerTextDrawUseBox(playerid, charnamethree, false);
	PlayerTextDrawSetProportional(playerid, charnamethree, true);

	CharDrawsCreated[playerid] = true;
	return 1;
}

DestroyCharacterDraws(playerid) {
	PlayerTextDrawDestroy(playerid, characterone);
	PlayerTextDrawDestroy(playerid, charactertwo);
	PlayerTextDrawDestroy(playerid, characterthree);
	PlayerTextDrawDestroy(playerid, charnameone);
	PlayerTextDrawDestroy(playerid, charnametwo);
	PlayerTextDrawDestroy(playerid, charnamethree);
	PlayerTextDrawDestroy(playerid, stringtitle);

	TextDrawHideForPlayer(playerid, toptitlebar);
	TextDrawHideForPlayer(playerid, bottomtitlebar);
	TextDrawHideForPlayer(playerid, selecttitle);

	CharDrawsCreated[playerid] = false;
	return 1;
}


ShowCharacterDraws(playerid) {
	TextDrawShowForPlayer(playerid, toptitlebar);
   	TextDrawShowForPlayer(playerid, bottomtitlebar);
  	TextDrawShowForPlayer(playerid, selecttitle);

  	PlayerTextDrawSetSelectable(playerid, characterone, true);
   	PlayerTextDrawSetSelectable(playerid, charactertwo, true);
   	PlayerTextDrawSetSelectable(playerid, characterthree, true);
   	
  	PlayerTextDrawShow(playerid, characterone);
  	PlayerTextDrawShow(playerid, charactertwo);
  	PlayerTextDrawShow(playerid, characterthree);

  	PlayerTextDrawShow(playerid, stringtitle);

  	PlayerTextDrawShow(playerid, charnameone);
  	PlayerTextDrawShow(playerid, charnametwo);
  	PlayerTextDrawShow(playerid, charnamethree);
  	return 1;
}

HideCharacterDraws(playerid) {
	TextDrawHideForPlayer(playerid, toptitlebar);
	TextDrawHideForPlayer(playerid, bottomtitlebar);
	TextDrawHideForPlayer(playerid, selecttitle);

  	PlayerTextDrawSetSelectable(playerid, characterone, true);
   	PlayerTextDrawSetSelectable(playerid, charactertwo, true);
   	PlayerTextDrawSetSelectable(playerid, characterthree, true);
   	
  	PlayerTextDrawHide(playerid, characterone);
  	PlayerTextDrawHide(playerid, charactertwo);
  	PlayerTextDrawHide(playerid, characterthree);

  	PlayerTextDrawHide(playerid, stringtitle);

  	PlayerTextDrawHide(playerid, charnameone);
  	PlayerTextDrawHide(playerid, charnametwo);
  	PlayerTextDrawHide(playerid, charnamethree);
  	return 1;
}