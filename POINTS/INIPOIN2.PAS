{$O+,X+}
Unit IniPoin2;
Interface
Uses
		Crt,Graph,U_Graph,F_Mouse,B_Math,ForPoint,GrDialog;


		Procedure SetPlayers;

Implementation
Type
	ByteFile=File Of Byte;

Const
	kbMinus=100;
	kbPlus=102;
	kbName=103;
	kbDone=204;
	kbEsc=105;


{---------------------------------------}

Var
	Ok:TButton;
	OkKeyBd:TKeyBoard;
	Ch:Boolean;
	A:String;
	AllowedColors:Set Of Byte;
	F:Text;
	MB,HelpMB,PlayersMB,QOfPlayersMB,PlayerList,InpPlayerMB:TMessageBox;
	KB:TKeyBoard;
	IB:TInputBox;
	InsedColor:Word;
	InsButt:TButton;
	Name:String[18];
	D,M:Integer;
	XI,YI,XSize,YSize,XDist,YDist,XBeg,YBeg,XU,YU,Key,Num:Word;
	B,Col:Byte;
	NOfPlayers,Index:Byte;


Procedure Open(Var F:ByteFile);
Begin
	{$I-}
	Reset(F);
	{$I+}
	If IOResult<>0 Then
		ErrorCfg:=True;
End;{Open}

{-----------------------}


Procedure ColorIns(ID:Word);Far;
Begin
	SaveColor;
	InsedColor:=ID;
	SetColor(InsedColor);
	Circle(260,40,3);
	Line(250,50,270,70);
	Filling(260,40,InsedColor);
	Rectangle(250,75,270,95);
	Filling(260,90,InsedColor);
	RestoreColor;
End;

Procedure InsName(ID:Word);Far;
Begin
		Name:=IB.Read;
End;

Procedure Choused(ID:Word);Far;
Var
		Ok:Boolean;
	T:Byte;
Begin
	Ch:=True;
	If Index >NOfPlayers Then
		Exit;
	IB.Clear;
	Players[Index].Playing:=True;
	If Name='' Then Name:='Incognito';
	Players[Index].Name:=Name;
	Players[Index].Color:=Lo(InsedColor);
	KB.DisAllow(InsedColor,Ok);
	Exclude(AllowedColors,InsedColor);
	SetColor(InsedColor);
	HideMouse;
	PlayerList.Print(Index,BinString(Index)+':'+Name);
	ShowMouse;
	For T:=0 To 16 Do
		If (T In AllowedColors) Then
				Begin
								ColorIns(T);
				Break
			End;
	Name:='';
	Index:=Index+1;
	SaveColor;
	SetColor(Black);
	InpPlayerMB.OutMessage(BinString(Index));
	RestoreColor;
End;


Procedure Exited(ID:Word);Far;
Begin
		Halt;
End;

Procedure PlayersIncDec(ID:Word);Far;
Begin
	SaveColor;
	SetColor(Black);
		If ID=kbMinus Then
		If NOfPlayers=2 Then
			PlayersMB.OutMessage(' Одного гравця замало')
		Else
			If NOfPlayers < Index Then
				PlayersMB.OutMessage('Менше нўж введено не зробиш')
			Else
				Dec(NOfPlayers)
	Else
		If NOfPlayers=10 Then
			PlayersMB.OutMessage('А не за жирно')
		Else
			Inc(NOfPlayers);
	QOfPlayersMB.OutMessage(BinString(NOfPlayers));
	RestoreColor;
End;

Procedure SetPlayers;
Var
	F:Text;
	FoB,AFoB:ByteFile;
	FName,FHandName,HideLinesChar:String;
	HLChar:Char;
	I:Byte;
Begin
	ErrorCfg:=False;
	Assign(F,'Points.cfg');
	{$I-}
	Reset(F);
	{$I+}
	If IOResult<>0 Then
		ErrorCfg:=True
	Else
		Begin
			{$I-}
			ReadLn(F,HidelinesChar);
			ReadLn(F,FName);
			ReadLn(F,FHandName);
			ReadLn(F,NetDisk);
			Close(F);
			{$I+}
			If NetDisk=''  Then
				ErrorCfg:=True;
			Assign(FoB,FName);
			Assign(AFoB,FHandName);
			Open(FoB);
			Open(AFoB);
			If Not(ErrorCfg) Then
				Begin
					For I:=1 To 64 Do
						Begin
							Read(FoB,MouseCursor[I]);
							Read(AFoB,AnotherCursor[I]);
						End;
					Close(FoB);
					Close(AFoB);
				End;
		End;


	HLChar:=HideLinesChar[1];
	Case HLChar Of
		'Y','y':HideLines:=True;
		'N','n',' ':HideLines:=False;
	End;


	InitMouse;
	SetMouseGraphCursor(AnotherCursor,1,1);
	SetColor(Blue);
	SetFillStyle(WideDotFill,Blue);
	FloodFill(1,1,Blue);

	Desk(120,70,500,400,3);
	SetTextStyle(4,0,12);
	SetColor(1);
	SetTextJustify(CenterText,CenterText);
	MoveTo(GetMaxX Div 2, 180);
	OutText('Points');
	SetTextStyle(4,0,4);
	MoveTo(GetMaxX Div 2+5,GetMaxY - 210);
	OutText('Version 2.0');
	MoveTo(GetMaxX Div 2,130);
	SetTextStyle(4,0,3);
	OutText('by Belei Sergiy');
	Ok.SetColors(Blue,LightGray);
	Ok.Assign(270,320,340,360,1,Bytes2Word(0,255),AnyButton,1,'Ok',NOP);
	OkKeyBd.Init;
	OkKeyBd.Ins(Ok);
	ShowMouse;
	Key:=WReadKey;
	OkKeyBd.Run(Key);
	OkKeyBd.ClearAll;
	HideMouse;
	ClearViewPort;


	SetFillStyle(WideDotFill,Blue);
	FloodFill(1,1,Blue);
	SetTextStyle(0,0,1);
	SetTextJustify(BottomText,RightText);
	Help(10,130,False);
	PlayerList.Init(510,225,637,445,5,5,1,1,2,3,2,'Гравцў');
	PlayerList.AllowMessages;
	KB.Init;
	MB.Init(10,10,635,120,5,3,10,410,2,3,5,'Точки v2.0');
	MB.AllowMessages;
	MB.OutMessage('Введўть сої ўм''я ў вибе- рўть колўр сво∙х точок');
	Desk(245,30,275,100,2);
	ColorIns(1);
	XBeg:=285;
	YBeg:=30;
	XSize:=60;
	YSize:=30;
	XDist:=10;
	YDist:=10;
	D:=0;
	PlayersMB.Init(510,130,637,210,3,3,3,3,3,3,40,'К-сть гравцўв');
	PlayersMB.AllowMessages;
	SetColor(Black);
	SetTextJustify(CenterText,CenterText);
	QOfPlayersMB.Init(550,150,594,175,12,2,21,0,1,1,2,'');
	SetTextJustify(CenterText,CenterText);
	InpPlayerMB.Init(150,50,210,80,5,5,30,1,1,3,5,'Гравець');
	InpPlayerMB.AllowMessages;
	InpPlayerMB.OutMessage('1');
	QOfPlayersMB.AllowMessages;
	InsButt.SetColors(Black,LightGray);
	NOfPlayers:=10;
	QOfPlayersMB.OutMessage(BinString(NOfPlayers));
	InsButt.Assign(519,150,544,175,1,45,AnyButton,kbMinus,'-',PlayersIncDec);
	KB.Ins(InsButt);
	InsButt.Assign(600,150,625,175,1,43,AnyButton,kbPlus,'+',PlayersIncDec);
	KB.Ins(InsButt);
	IB.Init(30,70,12,LightGreen,Black,1);

	For YI:=0 To 1 Do
		For XI:=0 To 4 Do
				Begin
				Col:=White;
				XU:=XBeg+(XSize+XDist)*XI;
				YU:=YBeg+(YSize+YDist)*YI;
				While Num In [0,2,3,7,8] Do
						Num:=Num+1;
				If Num In [11,10,14] Then
						Col:=Black;
				InsButt.SetColors(Col,Num);
				Include(AllowedColors,Num);
				InsButt.Assign(XU,YU,XU+XSize,YU+YSize,2,Num+97,AnyButton,Num,Chr(Num+97)+'|Колўр',ColorIns);
				KB.Ins(InsButt);
				Num:=Num+1;
			 End;
		InsButt.SetColors(Black,LightGray);
		InsButt.Assign(30,50,110,65,1,Bytes2Word(82,0),AnyButton,kbName,'Ins|Ўм''я',InsName);
		KB.Ins(InsButt);
		InsButt.Assign(40,90,120,110,1,27,AnyButton,kbEsc,'Esc|Вихўд',Exited);
		KB.Ins(InsButt);
		InsButt.Assign(130,90,220,110,1,13,AnyButton,kbDone,'Enter|Ввўд',Choused);
		KB.Ins(InsButt);
		Index:=1;
		ShowMouse;
		Repeat
			Ch:=False;
			Repeat
				Key:=WReadKey;
				KB.Run(Key);
			Until Ch;
		Until Index>NOfPlayers;
		For Index:=Index+1 To 10 Do
				Players[Index].Playing:=False;
		HideMouse;
		KB.ClearAll;
		ClearDevice;

End;

End.

