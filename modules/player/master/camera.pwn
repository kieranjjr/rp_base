forward mCamera(playerid);
public mCamera(playerid) {
	TogglePlayerSpectating(playerid, true);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 1);
	mCameraOne(playerid);
	return 1;
}

forward cCamera(playerid);
public cCamera(playerid) {
	if(MasterInfo[playerid][mLogged] == true)	{
		InterpolateCameraPos(playerid, -1945.453857, 2239.556884, 17.281091, -2080.764892, 2312.918701, 29.540859, 5000);
		InterpolateCameraLookAt(playerid, -1949.660034, 2242.255371, 17.441219, -2085.493164, 2313.107666, 27.925817, 1500);
	} else {
		SendClientMessage(playerid, -1, "SERVER: Somehow you're here - But not logged in.");
		SetTimerEx("KickTimer", 1000, false, "d", playerid);
	}
	return 1;
}

forward mCameraOne(playerid);
public mCameraOne(playerid) {
	if(MasterInfo[playerid][mLogged] == false)	{
		InterpolateCameraPos(playerid, 1133.997558, -1035.572753, 64.948669, 1345.627685, -864.949707, 76.893707, 8000);
		InterpolateCameraLookAt(playerid, 1137.145507, -1039.043945, 63.204856, 1349.431396, -861.764892, 77.517082, 5000);
		SetTimer("mCameraTwo", 11000, false);	
	}
	return 1;
}

forward mCameraTwo(playerid);
public mCameraTwo(playerid) {
	if(MasterInfo[playerid][mLogged] == false)	{
		InterpolateCameraPos(playerid, 1565.476440, -1565.599609, 19.968915, 1520.465454, -1639.842529, 20.289073, 8000);
		InterpolateCameraLookAt(playerid, 1563.608520, -1570.221435, 19.582582, 1523.997192, -1643.329956, 19.685083, 5000);
		SetTimer("mCameraThree", 11000, false);
	}
	return 1;
}

forward mCameraThree(playerid);
public mCameraThree(playerid) {
	if(MasterInfo[playerid][mLogged] == false)	{
		InterpolateCameraPos(playerid, 1219.601074, -2139.672851, 81.261070, 1167.118408, -2037.006713, 76.108818, 8000);
		InterpolateCameraLookAt(playerid, 1216.074096, -2136.245361, 80.359771, 1162.137451, -2036.870483, 75.695228, 5000);
		SetTimer("mCameraFour", 11000, false);
	}
	return 1;
}

forward mCameraFour(playerid);
public mCameraFour(playerid) {
	if(MasterInfo[playerid][mLogged] == false)	{
		InterpolateCameraPos(playerid, 43.981842, -1986.305175, -34.242313, 317.922149, -2116.457275, 18.238933, 8000);
		InterpolateCameraLookAt(playerid, 48.832225, -1987.482299, -33.945613, 321.096069, -2112.637207, 17.662096, 5000);
		SetTimer("mCameraOne", 11000, false);
	}
	return 1;
}
