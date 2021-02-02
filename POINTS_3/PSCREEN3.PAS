Uses
	Crt,Graph,U_Graph,F_Mouse,B_Math,BButton;
Var
	D,M:Integer;
    Key:Word;
    Ok:TButton;
    OkKeyBd:TKeyBoard;

Procedure P;
Begin
End;

Begin



    D := Detect;
    InitGraph (D,M,'c:\programs\tp7\bgi');
    SetFillStyle(10,1);
    FloodFill(1,1,1);
    Desk(120,70,500,400,3);
	SetTextStyle(4,0,12);
    SetColor(1);
    SetTextJustify(CenterText,CenterText);
    MoveTo(GetMaxX Div 2, 180);
	OutText('Points');
    SetTextStyle(4,0,4);
    MoveTo(GetMaxX Div 2+5,GetMaxY - 210);
	OutText('Version 3.0');
    MoveTo(GetMaxX Div 2,130);
    settextstyle(4,0,3);
    outText('by Belei Sergiy');
    Ok.SetColors(Blue,LightGray);
    Ok.Assign(140,300,300,360,1,Bytes2Word(0,),AnyButton,1,'Single',NOP);
    OkKeyBd.Init;
    OkKeyBd.Ins(Ok);
    Ok.Assign(320,300,480,360,1,Bytes2Word(0,),AnyButton,1,'Multi',NOP);
    OkKeyBd.Ins(Ok);
	ShowMouse;
    Key:=WReadKey;
    OkKeyBd.Run(Key);
    Delay(300);



End.