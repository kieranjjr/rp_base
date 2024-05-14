#include <YSI_Coding\y_hooks>

hook OnGameModeInit() {
    SetTimerEx("MinuteTimer", 60000, true);
    return 1;
}

forward MinuteTimer();
public MinuteTimer() {

    foreach(new i : Player) {
        CharacterInfo[i][cPayday] += 1;
        Payday(i);
    }
    return 1;
}

forward Payday(playerid);
public Payday(playerid) {
    new bank = CharacterInfo[playerid][cBank];
    new tax = 0, total = 3500;

    if(IsPlayerConnected(playerid) && MasterInfo[playerid][mLogged] == true && CharacterInfo[playerid][cLogged] == true) {
        if(CharacterInfo[playerid][cPayday] >= 60) {
            
            if(bank >= 0 && bank <= 12500) tax = TaxValue;
            if(bank >= 12500 && bank <= 49999) tax = TaxValue*2;
            if(bank >= 50000 && bank <= 109999) tax = TaxValue*3;
            if(bank >= 109999 && bank <= 149999) tax = TaxValue*4;
            if(bank >= 149999 && bank <= 199999) tax = TaxValue*5;
            if(bank >= 200000) tax = TaxValue*10;

            

            SendClientMessage(playerid, -1, "|_________________________ Paycheck _________________________|");
            SendClientMessage(playerid, -1, "Pay Statement;");
            format(g_str, sizeof(g_str), "Paycheck: $%d", total);
            SendClientMessage(playerid, -1, g_str);

            total -= tax;

            format(g_str, sizeof(g_str), "Tax: "CSS_SERVER"$%d", tax);
            SendClientMessage(playerid, -1, g_str);

            total -= 150;
            SendClientMessage(playerid, -1, "Insurance: "CSS_SERVER"$150");
            format(g_str, sizeof(g_str), "Subtotal: $%d", total);
            SendClientMessage(playerid, -1, g_str);
            SendClientMessage(playerid, -1, "Your cheque has been direct deposited into your bank account.");
            SendClientMessage(playerid, -1, "|___________________________________________________________|");
            CharacterInfo[playerid][cBank] += total;
            CharacterInfo[playerid][cPayday] = 0;
            CharacterInfo[playerid][cHours] += 1;
            MasterInfo[playerid][mHours] += 1;
            SetPlayerScore(playerid, CharacterInfo[playerid][cHours]);
        }
    }
    return 1;
}

CMD:stats(playerid, params[]) {
    SendClientMessageEx(playerid, -1, "Character Stats", "Master Hours - %d | Character Hours - %d\nMoney - %d | Bank - %d | Savings - %d", MasterInfo[playerid][mHours], CharacterInfo[playerid][cHours], CharacterInfo[playerid][cMoney], CharacterInfo[playerid][cBank], CharacterInfo[playerid][cSavings]);
    return 1;
}