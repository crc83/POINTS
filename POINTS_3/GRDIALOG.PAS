{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,600000}

Unit GrDialog;
Interface
Uses
		Crt,Graph,U_Graph,B_Math,BStack,F_Mouse;

Type

	TMarginRecord = Record
		Left,Right,Up,Down:Word;
	End;{TMarginRecord the Record}

	TMessageBox = Object
			XB,YB,XSize,YSize,BorderSize:Word;
			Margin:TMarginRecord;
			Header:String;
			OldText:String;
			CharColor,BkColor:Byte;
			OldStyle:TextSettingsType;
			IsHeader:Boolean;
			IsMessagesAllowed,Cleared:Boolean;
			UpperMargin,XCharSize,YCharSize,YDistanse,HeaderDistanse:Word;

		Constructor Init(XBeg,YBeg,XEnd,YEnd,UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist:Word;HeaderText:String);
		Procedure InitCoo (XBeg,YBeg,XEnd,YEnd:Word;HeaderText:String);
		Procedure InitMargins(UpMargin,DownMargin,LeftMargin,RightMargin,Border,Dist,HeaderDist:Word);
		Procedure GetSizeInChar;
		Procedure Draw;
		Procedure AllowMessages;
		Procedure DisAllowMessages;
		Procedure Print(Var I:Byte;Message:String);
		Procedure OutMessage(Message:String);
		Procedure Clear;

	 End;{TMessageBox The Object}



{--------------------------}

	TCursor = Object

			S:String;
			Position:Word;
			Ins:Boolean;
			X,Y,Leng:Word;
			TextColor:Byte;
            OldColor:Byte;
        	Color:Byte;
        	BkColor:Byte;
        	Plase:Pointer;
        	XSize,YSize:Byte;
        	Size:LongInt;

        Constructor Init(XI,YI:Word;L,IColor,IBkColor,TxtColor:Byte);
        Function GetXCoo:Word;
        Procedure Draw(DColor:Byte);
        Procedure Show;
        Procedure Hide;
        Procedure Del;
        Procedure Clear;
        Procedure DrawEndOfLine(DColor:Byte);
		Procedure HideEndOfLine;
		Procedure ShowEndOfLine;
		Procedure Move(DX,DY:Integer);
		Procedure MoveTo(Pos:Word);
		Procedure ChangeIns;
		Procedure Run;
		Destructor Done;
	End;


	TInputBox=Object
		Cursor:TCursor;

		Constructor Init(XB,YB,Lengt:Word;Color,BkColor,Margin:Byte);
		Procedure Clear;
		Function Read:String;
		Destructor Done;
	End;





	TButtWorkProc =Procedure (ID:Word);


	TButton = Object
		XBeg,YBeg,XSize,YSize,Margin:Word;
		Name:String;
		Color:Word;
		BkColor:Byte;
		Code:Word;
		Aviable:Boolean;
		ScanCode,MouseButton:Word;
		WorkProc:TButtWorkProc;
		TextSettings:TextSettingsType;

		Constructor Init;
		Procedure PutMouseItem;
		Procedure SetColors(Col,BkCol:Byte);
		Procedure Assign(XB,YB,XE,YE,MarginSize,ScnCode,MousButt,ICode:Word;NameOfButton:String;WProc:TButtWorkProc);
		Procedure Draw;
		Procedure DrawName;
		Procedure Push;
		Procedure UnPush; 
		Procedure Allow;
		Procedure DisAllow;
		Procedure Run;   
		Procedure Hide;
		Procedure PutFrom(Butt:TButton);
		Destructor Done;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
	End;{TButton The Object}

{-------------------------------------------}
	PButton = ^TButton;

{-------------------------------------------}


	TStackOfButtons = Object(TStack)
		Procedure Push(Var Button:TButton);
		Procedure Pop(Var Button:TButton);
	End;{TStackOfButtons The Object}


{-----------------------------------------}

	TKeyBoard = Object
		Buttons:TStackOfButtons;

		Constructor Init;
	Private
		Procedure Add(Button:TButton);
	Public
		Procedure Ins(Button:TButton);
		Procedure Get(ButtonCode:Word;IsItScanCode:Boolean;Var FoundedButton:TButton;Var IsFounded:Boolean);
		Procedure PutMouseItems;
		Procedure Del(Code:Word;Var Ok:Boolean);
		Procedure ClearAll;
		Procedure Allow(Code:Word;Var Ok:Boolean);
		Procedure DisAllow(Code:Word;Var Ok:Boolean);
		Function IsIn(X,Y:Word):Boolean;
		Procedure Run(Var ScanCode:Word);
	End;{TKeyBoard The Object}

{-----------------------------------------}

	Function WReadKey:Word;
	Procedure NOP(ID:Word);

{-----------------------------------------}


Var
	Pause:Word;


Implementation

{--------------------------}
Procedure NOP(ID:Word);
Begin
End;{NOP}

{---------------}

Function WReadKey:Word;
Var
	Higer,Lower:Byte;
Begin
	Lower:=Ord(ReadkeyOrMouse);
	If Lower=0 Then
		Higer:=Ord(ReadKeyOrMouse)
	Else
		Higer:=0;
	WReadKey:=Bytes2Word(Higer,Lower)
End;{WReadKey}


{------------------------}

{==========TSTACKOFBUTTONS=============}

Procedure TStackOfButtons.Push;
Var
	NewButton:PButton;
Begin
	New(NewButton,Init);
	NewButton^:=Button;
	Put(Addr(NewButton^));
End;{TStackOfButtons.Push}

{---------------------}

Procedure TStackofButtons.Pop;
Var
	P:Pointer;
	OldButton:PButton;
Begin
	If Empty Then
		Exit;
	Get(P);
	OldButton:=P;
	Button:=OldButton^;
	Dispose(OldButton,Done);
End;{TStackOfButtons.Pop}


{==END======TSTACKOFBUTTONS========END==}


{=============TBUTTON===================}

Constructor TButton.Init;
Begin
	SetColors(0,0);
	Assign(0,0,0,0,0,0,0,0,'',nil)
End;{TButton.Init}

{------------------------}

Procedure TButton.SetColors;
Begin
	Color:=Col;
	BkColor:=BkCol;
End;

{--------------------------}
Procedure TButton.Assign;

Begin
	XBeg:=XB;
	YBeg:=YB;
	XSize:=XE-XB;
	YSize:=YE-YB;
	Margin:=MarginSize;
	Name:=NameOfButton;
	Aviable:=True;
	ScanCode:=ScnCode;
	MouseButton:=MousButt;
	WorkProc:=WProc;
	Code:=ICode;
	Draw;
End;{TButton.Assign}

{----------------------}

Procedure TButton.PutMouseItem;
Var
	AddedItem:MouseItemType;
Begin
   If IsMouse Then
		Begin
			With AddedItem Do
				Begin
					X1:=MouseTextCooX(XBeg);
					Y1:=MouseTextCooY(YBeg);
					X2:=MouseTextCooX(XBeg+XSize);
					Y2:=MouseTextCooY(YBeg+YSize);
					Butt:=MouseButton;
					Key:=ScanCode;
				End;
			AddMouseItem(AddedItem);
		End;
End;{TButton.PutMouseItem}

{----------------------------}

Procedure TButton.Draw;
Begin
	HideMouse;
	DeskC(XBeg,YBeg,XBeg+XSize,YBeg+YSize,Margin,BkColor);
	GetTextSettings(TextSettings);
	DrawName;
	ShowMouse;
End;{TButton.Draw}


{-------------------------------------------------}


Procedure TButton.PutFrom;
Begin
		XBeg:=Butt.XBeg;
		YBeg:=Butt.YBeg;
		XSize:=Butt.XSize;
		YSize:=Butt.YSize;
		Margin:=Butt.Margin;
		Name:=Butt.Name;
		Color:=Butt.Color;
		BkColor:=Butt.BkColor;
		Code:=Butt.Code;
		Aviable:=Butt.Aviable;
		ScanCode:=Butt.ScanCode;
		MouseButton:=Butt.MouseButton;
		WorkProc:=Butt.WorkProc;
		TextSettings:=Butt.TextSettings;

End;{TButton.PutFrom}


{-----------------------------------}


Procedure TButton.DrawName;
Var
	QOfChars:Word;
Begin
	QOfChars:=XSize Div TextHeight('a');
	Name:=Copy(Name,1,QOfChars);
	SaveTextSettings;
	SaveColor;
	SetTextSettings(TextSettings);
	SetTextJustify(CenterText,CenterText);
	If Aviable Then
		SetColor(Color)
	Else
		SetColor(DarkGray);
	OutTextXY(XBeg+XSize Div 2,YBeg+YSize Div 2 -1,Name);
	RestoreColor;
	RestoreTextSettings;
End;{TButton.DrawName}


{---------------------}


Procedure TButton.Allow;
Begin
	Aviable:=True;
	DrawName;
End;{TButton.Allow}

{--------------------}

Procedure TButton.DisAllow;
Begin
	Aviable:=False;
	DrawName;
End;{TButton.DisAllow}


{--------------------}


Procedure TButton.Push;
Begin
	HideMouse;
	InversedMargins(XBeg,YBeg,XBeg+XSize,YBeg+YSize,Margin);
	ShowMouse;
End;{TButton.Push}

{--------------------}

Procedure TButton.UnPush;
Begin
	HideMouse;
	NormalMargins(XBeg,YBeg,XBeg+XSize,YBeg+YSize,Margin);
	ShowMouse;
End;{TButton.UnPush}

{-------------------}

Procedure TButton.Run;
Begin
	If Aviable Then
		Begin
			Push;
			WorkProc(Code);
			Delay(Pause);
			UnPush;
		End;
End;{TButton.Run}

{-------------------------}

Procedure TButton.Hide;
Begin
	SetFillStyle(1,LightGray);
	Bar(XBeg-Margin,YBeg-Margin,XBeg+XSize+Margin,YBeg+YSize+Margin);
End;{TButton.Hide}

{--------------------------}

Destructor TButton.Done;
Begin
End;{TButton.Done}

{==END=========TBUTTON==============END==}

{==============TKEYBOARD=================}


Constructor TKeyBoard.Init;
Begin
	Buttons.Init;
End;{TKeyBoard.Init}

{------------------------}

Procedure TKeyBoard.Add;
Begin
	Buttons.Push(Button);
End;{TKeyBoard.Add}

{------------------------}

Procedure TKeyBoard.Ins;
Begin
	Add(Button);
	Button.PutMouseItem;
End;{TKeyBoard.Ins}

{------------------------}

Procedure TKeyBoard.Get;
Var
	TempButtonStack:TStackOfButtons;
	TempButton:TButton;
Begin
	TempButtonStack.Init;
	IsFounded:=False;
	FoundedButton.Init;
	TempButton.Init;
	While  Not(Buttons.Empty Or IsFounded) Do
		Begin
			Buttons.Pop(FoundedButton);
		   If (IsItScanCode And ((FoundedButton.ScanCode=ButtonCode)Or (FoundedButton.ScanCode=Bytes2Word(0,255))))
				Or ((Not(IsItScanCode)) And (FoundedButton.Code=ButtonCode))
			Then
				IsFounded:=True
			Else
				TempButtonStack.Push(FoundedButton);
		End;
	While Not(TempButtonStack.Empty) Do
		Begin
			TempButtonStack.Pop(TempButton);
			Buttons.Push(TempButton);
		End;
	TempButtonStack.Done;
End;{TKeyBoard.Get}

{-----------------------------}

Procedure TKeyBoard.PutMouseItems;
Var
	Button:TButton;
	TempButtons:TStackOfButtons;
Begin
	TempButtons.Init;
	Button.Init;
	While Not(Buttons.Empty) Do
		Begin
			Buttons.Pop(Button);
			Button.PutMouseItem;
			TempButtons.Push(Button);
		End;

   Buttons.InitHead(TempButtons.Head);
End;{TKeyBoard.PutMouseItems}


{------------------------------}


Procedure TKeyBoard.Del;
Var
	Button:TButton;
Begin
	Button.Init;
	Get(Code,False,Button,Ok);
	If Ok Then
		Begin
			ClearMouseItems;
			Button.Hide;
			PutMouseItems;
		End;
End;{TKeyBoard.Del}

{-----------------------}

Procedure TKeyBoard.ClearAll;
Var
	Button:TButton;
Begin
	Button.Init;
	ClearMouseItems;
	While Not(Buttons.Empty) Do
		Begin
			Buttons.Pop(Button);
			Button.Done;
		End;
	Buttons.Done;
End;{TKeyBoard.ClearAll}

{---------------------------}

Procedure TKeyBoard.Allow;
Var
	Button:TButton;
Begin
	Button.Init;
	Get(Code,False,Button,Ok);
	If Ok Then
		Begin
			Button.Allow;
			Add(Button);
		End;
End;{TKeyBoard.Allow}


{---------------------------}

Procedure TKeyBoard.DisAllow;
Var
	Button:TButton;
Begin
	Button.Init;
	Get(Code,False,Button,Ok);
	If Ok Then
		Begin
			Button.DisAllow;
			Add(Button);
		End;
End;{TKeyBoard.DisAllow}

{----------------------------}

Function TKeyBoard.IsIn;
Var
	TempButt:TButton;
	TempStack:TStackOfButtons;
	IsInFlag:Boolean;
Begin
	TempStack.Init;
	TempButt.Init;
	IsInFlag:=False;
	While Not(Buttons.Empty) Do
		Begin
			Buttons.Pop(TempButt);
			If TempButt.Aviable Then
				If (X>=TempButt.XBeg) And (Y>=TempButt.YBeg)
					And (X<=(TempButt.XBeg+TempButt.XSize)) And (Y<=(TempButt.YBeg+TempButt.YSize)) Then
					IsInFlag:=True;
			TempStack.Push(TempButt);
		End;

	Buttons.InitHead(TempStack.Head);
	TempButt.Done;
	IsIn:=IsInFlag;
End;{TKeyBoard.IsIn}

{------------------------------------}

Procedure TKeyBoard.Run;
Var
	Button:TButton;
	Ok:Boolean;
Begin
	Button.Init;
	Get(ScanCode,True,Button,Ok);
	Add(Button);
	If Ok Then
		Begin
			Button.Run;
			ScanCode:=0;
		End;
End;{TKeyBoard.Run}

{==END=========TKEYBOARD============END==}

Constructor TMessageBox.Init(XBeg,YBeg,XEnd,YEnd,UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist:Word;HeaderText:String);
Begin
		InitCoo(XBeg,YBeg,XEnd,YEnd,HeaderText);
		InitMargins(UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist);
		GetSizeInChar;
		GetTextSettings(OldStyle);

		OldText:='';
		AllowMessages;
		Cleared:=True;
		Draw;
End;{TMessageBox.Init}

{---------------------------------------------}



Procedure TMessageBox.InitCoo (XBeg,YBeg,XEnd,YEnd:Word;HeaderText:String);
Begin
	  XB:=XBeg;
	  YB:=YBeg;
	  {If XEnd<XBeg Or YEnd<YBeg Then /Error in borders diffention/}
	  XSize:=XEnd-XBeg;
	  YSize:=YEnd-YBeg;
	  Header:=HeaderText;
	  IsHeader:=(Header<>'');
End;{TMessageBox.InitCoo}


{----------------------------------------------}

Procedure TMessageBox.InitMargins(UpMargin,DownMargin,LeftMargin,RightMargin,Border,Dist,HeaderDist:Word);
Begin
	  HeaderDistanse:=HeaderDist;
	  BorderSize:=Border;
	  YDistanse:=Dist;
	  With Margin Do
		Begin
				Up:=UpMargin;
			Down:=DownMargin;
			Left:=LeftMargin;
			Right:=RightMargin;
		End;{With}
End;{TMargin.InitMargins}

{--------------------------------------------}

Procedure TMessageBox.GetSizeInChar;
Begin
	  XCharSize:=(XSize-Margin.Left-Margin.Right) Div TextWidth('a');
	  YCharSize:=(YSize-Margin.Up-Margin.Down) Div TextHeight('a');
End;{TMessageBox.GetSizeInChar}

{--------------------------------------------}

Procedure TMessageBox.Draw;
Var
		X,Y:Word;
Begin
		Desk(XB,YB,XB+XSize,YB+YSize,BorderSize);
	If IsHeader Then
		Begin
			SetTextJustify(CenterText,CenterText);
			Y:=TextHeight(Header) Div 2+Margin.Up+YB;
			X:=XB+XSize Div 2;
			UpperMargin:=TextHeight(Header);
			OutTextXY(X,Y,Header);
		End;{If}
	UpperMargin:=UpperMargin+Margin.Up;
	SetTextSettings(OldStyle);
End;{TMessageBox.Draw}

{-----------------------------------------------}

Procedure TMessageBox.AllowMessages;
Begin
	IsMessagesAllowed:=True;
End;{TMessageBox.AllowMessages}

{----------------------------------------------}

Procedure TMessageBox.DisAllowMessages;
Begin
	IsMessagesAllowed:=False;
End;{TMessageBox.DisAllowMessages}

{----------------------------------------------}

Procedure TMessageBox.Print;
Var
		BPos,CountOfLines:Word;
		G:Byte;
	LineToOut:String;
Begin
	SaveTextSettings;
	SetTextSettings(OldStyle);
	BPos:=1;
	CountOfLines:= Length(Message)Div XCharSize +1;
	If CountOfLines>YCharSize Then
		CountOfLines:=YCharSize;

	For G:=I To CountOfLines-1+I Do
		Begin
			LineToOut:=Copy(Message,BPos,XCharSize);
			OutTextXY(XB+Margin.Left,YB+UpperMargin+G*TextHeight(Message)+G*YDistanse+HeaderDistanse,LineToOut);
			BPos:=BPos+XCharSize;
		End;
	I:=G;
	RestoreTextSettings;

End;{TMessageBox.Print}

{-------------------------------------------}
Procedure TMessageBox.OutMessage(Message:String);
Var
	K:Byte;
Begin
		If IsMessagesAllowed Then
		Begin
			If Not(Cleared) Then
				Clear;
			OldText:=Message;
			K:=0;
			Print(K,Message);
			Cleared:=False;
		End;
End;{TMessageBox.OutMessage}

{----------------------------------------------}

Procedure TMessageBox.Clear;
Var
		K:Byte;
Begin
	SaveColor;
	SetColor(LightGray);
	K:=0;
	Print(K,OldText);
	RestoreColor;
	Cleared:=True;
End;{TMessageBox.Clear}




Constructor TCursor.Init(XI,YI:Word;L,IColor,IBkColor,TxtColor:Byte);
Begin
	OldColor:=GetColor;
	S:='';
	Position:=1;
	Leng:=L;
	X:=XI;
	Y:=YI;
	Color:=IColor;
	BkColor:=IBkColor;
	TextColor:=TxtColor;
End;{TCursor.Assign}



{------------------------}

Destructor TCursor.Done;
Begin
End;{TCursor.Done}

{-----------------------}

Function TCursor.GetXCoo:Word;
Begin
	GetXCoo:=X+Position*TextWidth('A');
End;{TCursor.GetCoo}

{---------------------------}



Procedure TCursor.Draw;
Var
	XOld:Word;
Begin
	SetWriteMode(NormalPut);
	XOld:=X;
	X:=GetXCoo;
	SaveColor;
	SetColor(DColor);
	YSize:=TextHeight('A');
	XSize:=TextWidth('A');

	If Ins Then
		Begin
			Rectangle(X,Y,X+XSize-1,Y+YSize);
			Filling(X+1,Y+1,DColor);
		End
	Else
		Begin
			Rectangle(X,Y+YSize,X+XSize,Y+YSize+1);
			Filling(X+1,Y+YSize,DColor);
		End;
	RestoreColor;
	X:=XOld;

End;{TCursor.Draw}

{-------------------------}

Procedure TCursor.DrawEndOfLine;
Var
	TempString:String;
Begin
	TempString:=Copy(S,Position,Length(S)-Position+1);
	SaveColor;
	SetColor(DColor);
	OutTextXY(GetXCoo,Y,TempString);
	RestoreColor;
End;{TCursor.DrawEndOfLine}


{--------------------------}

Procedure TCursor.ShowEndOfLine;
Begin
	DrawEndOfLine(TextColor);
End;{TCursor.ShowEndOfLine}

{------------------------}

Procedure TCursor.HideEndOfLine;
Begin
	DrawEndOfLine(BkColor);
End;{TCursor.HideEndOfLine}

{-----------------------}

Procedure TCursor.Del;
Begin
	HideEndOfLine;
	Delete(S,Position,1);
	ShowEndOfLine;
End;{TCursor.Del}

{----------------------}

Procedure TCursor.Show;
Begin
	Draw(Color);
	SaveColor;
	If Ins Then
		SetColor(Not(Color));
	If Position <= Length(S) Then
		OutTextXY(GetXCoo,Y,S[Position]);
	RestoreColor;
End;{TCursor.Show}

{------------------------------}

Procedure TCursor.Hide;
Var
		OldIns:Boolean;
Begin
	OldIns:=Ins;
	Ins:=True;
	Draw(BkColor);
	Ins:=False;
	Draw(BkColor);
	If Position <=Length(S) Then
		OutTextXY(GetXCoo,Y,S[Position]);
	Ins:=OldIns;
End;{TCursor.Hide}

{---------------------------}

Procedure TCursor.Move(DX,DY:Integer);
Begin
	Hide;
	X:=X+DX*TextWidth('A');
	Y:=Y+DY*TextHeight('A');
	Show;
End;{TCursor.Move}

{----------------------------}

Procedure TCursor.MoveTo(Pos:Word);
Var
	I:Byte;
Begin
	If Pos<1 Then
		Pos:=1;
{	If Pos>Length(S) Then
		For I:=Length(S) To Position-1 Do
			S:=Copy('/',1,1);
 }
	If (Pos>Leng) Then
		Pos:=Leng;
	Position:=Pos;
End;{TCursor.MoveTo}

{-----------------------}

Procedure TCursor.Clear;
Begin
	Position:=1;
	HideEndOfLine;
	S:='';
End;{TCursor.Clear}

{------------------------}

Procedure TCursor.ChangeIns;
Begin
	Hide;
	Ins:=Not(Ins);
	Show;
End;{TCursor.ChangeIns;}


{------------------------------}


Procedure TCursor.Run;
Var
		CKey:Char;
Begin
	SetColor(TextColor);
	SetTextJustify(BottomText,RightText);
	Repeat
		Show;
		CKey:=ReadKey;
		Hide;
		Case CKey Of
		#8 {BackSpase}   :If Position>1 Then
							Begin
								Position:=Position-1;
								Del;
								Position:=Position+1;
								MoveTo(Position-1) ;
							End;
		#13{Enter}       :Break;
		#27{Esc}         :Clear;
		#32..#239{Letter}:If Length(S)<Leng Then
							Begin
								HideEndOfLine;
								If Ins Then
									Delete(S,Position,1);
								Insert(CKey,S,Position);
								ShowEndOfLine;
								OutTextXY(X+Position*TextWidth('A'),Y,CKey);
								MoveTo(Position+1);
							End;
		#0:Case ReadKey Of
			#71{Home}:MoveTo(0);
			#72{Up}: ;
			#75{Left}:MoveTo(Position-1);
			#77{Right}:MoveTo(Position+1);
			#79{End}:MoveTo(Length(S));
			#80{Down}: ;
			#82{Ins}:ChangeIns;
			#83{Del}:Del;
			Else;
		End;
		Else;
	End;
	Until False;
	SetColor(OldColor);
End;{TCursor.Run}

{------------------------}

Constructor TInputBox.Init;
Begin
	DeskC(XB,YB,(Lengt+1)*TextWidth('A')+XB+4,YB+TextHeight('A')+4,Margin,BkColor);
	InversedMargins(XB,YB,(Lengt+1)*TextWidth('A')+XB+4,YB+TextHeight('A')+4,Margin);
	Cursor.Init(XB+2,YB+2,Lengt,Color,GetPixel(XB+1,YB+1),Color);
End;{TInputBox.Init}

{-----------------------}

Procedure TInputBox.Clear;
Begin
	Cursor.Clear;
End;{TInputBox.Clear}

{------------------------}

Function TInputBox.Read;
Begin
	HideMouse;
	Cursor.Run;
	Read:=Cursor.S;
	ShowMouse;
End;{TInputBox.Read}

{-----------------------}

Destructor TInputBox.Done;
Begin
	Cursor.Done;
End;{TInputBox.Done}



Begin
	Pause:=0;
End.{Unit}