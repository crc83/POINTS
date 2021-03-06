{$O+,X+}
Unit BButton;
Interface
Uses
	Graph,U_Graph,F_Mouse,B_Math,GrMesBox,BStack;
Type

	TButtWorkProc =Procedure (ID:Word);

    {---------------}

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
    Procedure NOP(ID:Word);Far;


Implementation

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
	DeskC(XBeg,YBeg,XBeg+XSize,YBeg+YSize,Margin,BkColor);
    GetTextSettings(TextSettings);
    DrawName;
End;{TButton.Draw}

{-------------------------------------------------}

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

End.{Unit}NDEL  HEX           �h3(�   CANDLE  HEX           C�R(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ֫�W�V�W�V�W�V�W�V�W�V�W�V�W�V�W�V�W�V�W�V�WW�WW�WW�WWX'W	X4WX@WX@WX@W!X@W'X@W-X@W3XLW9XLW?XLWEXLWIXWW JX^W   ^W      Commander compression PKZIP 1.x/2.x ARJ ARC PAK ZOO LHARC                                                                       Q� � � � � � � � � � � � � � � � � � � � � � �                                             �~&�u8�v��v�&�}<W���$�~W����= Mu	jU�6��= Kuj�U�(����~
&�= t��&�E=
 t�W�~W�*��~&�E8&�}<&;E|�����W����W����W�~&�u8&�}<W���$RP