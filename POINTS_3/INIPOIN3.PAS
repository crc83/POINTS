{Version 3.0}

Unit IniPoin3;
Interface
Uses
		mysumb,Crt,Graph,U_Graph,GrDialog,F_Mouse,B_Math,ForPoin3,NetPoin3;

		Type
			NameString = String[12];


		Procedure SetPlayers;
		Procedure PutPlayerToList(IName:NameString;Col,IInd:Word;ShowIt:Boolean);
		Procedure PlayersIncDec(ID:Word);Far;


Var
	Ok:TButton;
	OkKeyBd:TKeyBoard;
	Started:Boolean;
	A:String;
	AllowedColors:Set Of Byte;
	F:Text;
	MB,ColorMB,PlayersMB,QOfPlayersMB,PlayerList,InpPlayerMB:TMessageBox;
	KB:TKeyBoard;
	IB:TInputBox;
	InsedColor:Word;
	InsButt:TButton;
	Name:NameString;
	D,M:Integer;
	XI,YI,XSize,YSize,XDist,YDist,XBeg,YBeg,XU,YU,Key,Num:Word;
	B,Col,I:Byte;
	NOfPlayers,Index:Byte;

Const
	kbMinus=100;
	kbPlus=102;
	kbName=103;
	kbDone=204;
	kbEsc=105;
	kbClear=106;
	kbConect=107;
	kbDoneConnect=108;
	kbStart=109;


Implementation

Type
	ByteFile=File Of Byte;


{---------------------------------------}


Procedure Open(Var F:ByteFile);
Begin
	{$I-}
	Reset(F);
	{$I+}
	If IOResult<>0 Then
		ErrorCfg:=True;
End;{Open}









Procedure ColorIns(ID:Word);Far;
Var
	X,Y:Word;
Begin
	HideMouse;
	SaveColor;
	InsedColor:=ID;
	SetColor(InsedColor);
	X:=82;
	Y:=375;
	Rectangle(235+X,45+Y,305+X,75+Y);
	Circle(245+X,60+Y,4);
	Line(250+X,50+Y,270+X,70+Y);
	Filling(245+X,60+Y,InsedColor);
	Rectangle(280+X,50+Y,300+X,70+Y);
	Filling(281+X,51+Y,InsedColor);
	RestoreColor;
	ShowMouse;
End;{ColorIns}


{-----------------------}
Procedure ClearList(ID:Word);Far;
Var
	I:Byte;
	Ok:Boolean;
Begin
	If Not(Players[1].Playing) Then
		Exit;
	ColorIns(Players[1].Color);
	SaveColor;
	SetColor(LightGray);
	For I:=1 To Index-1 Do
		Begin
			PlayerList.Print(I,BinString(I)+':'+Players[I].Name);
			Players[I].Playing:=False;
			KB.Allow(Players[I].Color,Ok);
			Include(AllowedColors,Players[I].Color);
		End;
	Index:=1;
	RestoreColor;
End;{ClearList}

{-----------------------}


{--------------------------}

Procedure PutPlayerToList;
Var
   Ok:Boolean;
   T,Ind:Byte;
Begin
	Ind:=Lo(IInd);
	Players[Ind].Playing:=True;
	If IName='' Then IName:='Incognito';
	Players[Ind].Name:=IName;
	Players[Ind].Color:=Lo(Col);
	KB.DisAllow(Col,Ok);
	Exclude(AllowedColors,Col);
	SetColor(Col);
	If ShowIt Then
		Begin
			HideMouse;
			PlayerList.Print(Ind,BinString(Ind)+':'+Players[Ind].Name);
			ShowMouse;
		End;
	For T:=0 To 16 Do
		If (T In AllowedColors) Then
		   Begin
				ColorIns(T);
				Break
		   End;
End;{PutPlayerToList}


{---------------------------}


Procedure InsName(ID:Word);Far;
Begin
		Name:=IB.Read;
End;{InsName}


{-------------------------}

Procedure Choused(ID:Word);Far;
Var
   Ok:Boolean;
   T:Byte;
Begin
	{Ch:=True;}
	If Index >NOfPlayers Then
		Exit;
	IB.Clear;
	PutPlayerToList(Name,InsedColor,Index,True);
	Name:='';
	Index:=Index+1;
	SaveColor;
	SetColor(Black);
	InpPlayerMB.OutMessage(BinString(Index));
	RestoreColor;
End;{Choused}

{--------------------------}


Procedure Exited(ID:Word);Far;
Begin
  {		EraseGroupFile;}
		Halt;
End;{Exited}

{-----------------------}

Procedure PlayersIncDec(ID:Word);
Begin
	SaveColor;
	SetColor(Black);
		If ID=kbMinus Then
		If NOfPlayers=2 Then
			PlayersMB.OutMessage('Не менше двох'{ Одного гравця замало'})
		Else
			If NOfPlayers < Index Then
				PlayersMB.OutMessage('Менше нўж введено не зробиш')
			Else
				Dec(NOfPlayers)
	Else
		If NOfPlayers=10 Then
			PlayersMB.OutMessage('Не бўльше деся-ти')
		Else
			Inc(NOfPlayers);
	QOfPlayersMB.OutMessage(BinString(NOfPlayers));
	RestoreColor;
End;{PlayersIncDec}

{--------------------------------}


Procedure WaitFor(ID:Word);Far;
Begin
{Чекати поки не знищать файл реїстрацў∙ групи}
End;


{--------------------------------}

Procedure Start(ID:Word);Far;
Begin
{Знищити файл групи ў почати гру}
End;




Procedure SetPlayers;
Var
	F:Text;
	FoB,AFoB:ByteFile;
	FName,FHandName,HideLinesChar:String;
	HLChar:Char;
	I:Byte;
	Paus:Word;
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
			ReadLn(F,GrNum);
			ReadLn(F,Paus);
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
					Pause:=Paus;
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













	SetColor(Black);
	SetTextStyle(0,0,1);
	SetTextJustify(BottomText,RightText);
	KB.Init;
	MB.Init(10,10,635,475,5,3,10,310,2,3,5,'Точки v2.1');
	MB.AllowMessages;
	MB.OutMessage('Введўть свої ўм''я виберўть колўр сво∙х точок.');
	PlayerList.Init(155,323,285,460,5,5,3,1,0,3,2,'Гравцў');
	ColorMB.Init(420,395,630,470,40,5,5,5,0,2,0,'');
	ColorMB.OutMessage('(C) Points v 3.0,        by Belei Sergiy,         Ivano-Frankivsk,Ukraine.');
	Sumb(465,400,1,1);
	XBeg:=420;
	YBeg:=30;
	XSize:=100;
	YSize:=63;
	XDist:=10;
	YDist:=10;
	D:=0;
	PlayersMB.Init(155,240,285,313,3,3,3,3,0,3,40,'К-сть гравцўв');
	PlayersMB.AllowMessages;
	SetColor(Black);
	SetTextJustify(CenterText,CenterText);
	QOfPlayersMB.Init(198,260,242,285,12,2,21,0,0,1,2,'');
	SetTextJustify(CenterText,CenterText);
	InpPlayerMB.Init(295,395,410,458,5,5,55,1,0,3,5,'Гравець');
	InpPlayerMB.AllowMessages;
	InpPlayerMB.OutMessage('1');
	ColorIns(1);
	InsButt.SetColors(Black,LightGray);
	NOfPlayers:=10;
	QOfPlayersMB.OutMessage(BinString(NOfPlayers));
	InsButt.Assign(167,260,192,285,0,45,AnyButton,kbMinus,'-',PlayersIncDec);
	KB.Ins(InsButt);
	InsButt.Assign(247,260,273,285,0,43,AnyButton,kbPlus,'+',PlayersIncDec);
	KB.Ins(InsButt);

	I:=0;
	For XI:=0 To 1 Do
		For YI:=0 To 4 Do
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
				InsButt.Assign(XU,YU,XU+XSize,YU+YSize,0,I+48,AnyButton,Num,Chr(I+48)+'|Колўр',ColorIns);
				Inc(I);
				KB.Ins(InsButt);
				Num:=Num+1;
			 End;
		InsButt.SetColors(Black,LightGray);
		InsButt.Assign(30,85,145,157,0,Bytes2Word(59,0),AnyButton,kbClear,'F1|Очистити',ClearList);
		KB.Ins(InsButt);
		InsButt.Assign(30,167,145,230,0,Bytes2Word(60,0),AnyButton,kbConect,'F2|Приїднатись',NetConnection);
		KB.Ins(InsButt);
		InsButt.Assign(30,240,145,312,0,Bytes2Word(82,0),AnyButton,kbName,'Ins|Ўм''я',InsName);
		KB.Ins(InsButt);
		InsButt.Assign(30,395,145,458,0,27,AnyButton,kbEsc,'Esc|Вихўд',Exited);
		KB.Ins(InsButt);
		InsButt.Assign(30,322,145,385,0,13,AnyButton,kbDone,'Enter|Ввўд',Choused);
		KB.Ins(InsButt);
		InsButt.Assign(155,167,285,230,0,Bytes2Word(61,0),AnyButton,kbStart,'F3|Розпочати',NOP);
		KB.Ins(InsButt);
		IB.Init(34,285,12,DarkGray,LightGray,0);

		Index:=1;
		ShowMouse;
		Repeat
			Key:=WReadKey;
			KB.Run(Key);
		Until Index>NOfPlayers;


		For Index:=Index+1 To 10 Do
				Players[Index].Playing:=False;
		HideMouse;
		KB.ClearAll;
		ClearDevice;

End;

End.

