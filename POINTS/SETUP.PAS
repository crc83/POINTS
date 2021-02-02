Program SetUp;
Uses
	Crt,Graph,U_Graph,B_Math,BButton,F_Mouse,GrMesBox;
Const
	kbF1=1;
    kbF2=2;
    kbF3=3;
    kbOk=4;
    kbEsc=5;

Var
	D,M:Integer;
    InsButt:TButton;
    SKB:TKeyBoard;
    SMB:TMessageBox;
    Key:Word;


Procedure General(ID:Word);
Begin
	SMB.OutMessage('Загальнў настройки');
End;


Procedure Mouse(ID:Word);Far;
Begin
	SMB.OutMessage('Виберўть вид   вказўвника мишўў ∙∙ чутливўсть');

End;

Procedure Net(ID:Word);Far;
Begin
	SMB.OutMessage('Вкажўть ўмя ме-режевого диска який доступний вам ў вашому   супернику (су- перникам)');
End;

Procedure Save(ID:Word);Far;
Begin
	Halt;
End;

Procedure Quit(ID:Word);Far;
Begin
	Halt;
End;


Begin
	D:=Detect;

	InitGraph(D,M,'C:\programs\tp7\bgi');
    SetColor(Black);
	SMB.Init(100,10,400,300,15,140,10,170,2,3,15,'SetUp for Points v 2.0');
    SMB.AllowMessages;
    SMB.OutMessage('Настройте гру. Для збереження настройок ў    продовження гринатиснўть  "En-ter"."Esc"- ви-хўд без'+
	' збере- ження поточних настройок.');
    InitMouse;
    SetGrMouseCur('Rhand.Cur',1,1);
    HideMouse;
    SKB.Init;
    InsButt.SetColors(Black,LightGray);
    InsButt.Assign(240,50,390,100,1,Bytes2Word(59,0),AnyButton,kbF1,'F1 | Загальнў',General);
    SKB.Add(InsButt);
    InsButt.Assign(240,110,390,160,1,Bytes2Word(60,0),AnyButton,kbF2,'F2 | Мишка',Mouse);
    SKB.Add(InsButt);
    InsButt.Assign(240,170,390,220,1,Bytes2Word(61,0),AnyButton,kbF3,'F3 | Мережа',Net);
    SKB.Add(InsButt);
    InsButt.Assign(240,250,340,285,1,13,AnyButton,kbOk,'Enter | Ok',Save);
    SKB.Add(InsButt);
    InsButt.Assign(130,250,230,285,1,27,AnyButton,kbEsc,'Esc | Вихўд',Quit);
    SKB.Add(InsButt);
    ShowMouse;
    Repeat
    	Key:=WReadKey;
        SKB.Run(Key);
    Until False;

End.