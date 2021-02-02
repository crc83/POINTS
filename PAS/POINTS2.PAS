{$M 16384,240000,655000}
		{ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		 º ’®çª¨  ¢ 2.0   (30.12.1999) ³ Points v 2.0   (30.12.1999)   º
		 ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		 º ¥«¥© ‘¥à£i©                ³ Belei Sergiy                  º
		 º I¢ ­®-”à ­ªi¢áìª            ³ Ivano-Frankivsk               º
		 º “ªà i­                      ³ Ukraine                       º
		 ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼}


Program Points2;



Uses
	Overlay,Rounder1,Rounder2,Crt,Graph,U_Graph,BStack,GrDialog,F_Mouse,B_Math,ForPoint,IniPoint,Screen;

{$O Rounder1}
{$O Rounder2}
{$O GrDialog}
{$O B_Math}
{$O ForPoint}
{$O IniPoint}
{$O Screen}
{$L EgaVga.Obj}
{$L Goth.Obj}
Type



	TWorkProc = Procedure (X,Y:Word);

{---------------------------------------}

	TChouser = Object

		X,Y:Word;
		Color:Byte;

		Constructor Init (PColor:Byte);
		Procedure InitCoo(NewX,NewY:Word);
		Procedure Draw (PColor:Byte);
		Procedure Show;
		Procedure Hide;
		Function CheckRange (NextX,NextY:Word):Boolean;
		Procedure Move(DX,DY:ShortInt);
		Procedure Put;
		Procedure Run;
		Destructor Done;
	End;{PChouser}

{--------------------------------------}


	PSubCoo=^TSubCoo;

	TSubCoo =Record
		X,Y:Word;
	End;{TCoo the record}


	PCoords =^TCoords;

	TCoords =Record
		X,Y:Word;
		RoundedPoints:PPointer;
	End;{TElement the record}



	TCooStack =Object(TStack)

		Procedure Push(XS,YS:Word;SubCoo:PPointer);
		Procedure Pop(Var XS,YS:Word;Var SubCoo:PPointer);
	End;{TStack the object}

	TSubStack =Object(TStack)

		Procedure Push(XS,YS:Word);
		Procedure Pop(Var XS,YS:Word);
	End;




{----------------------------------------}
	PFild = ^TFild;

{==END=============TYPE============END==}

{==================VARIABLES===============}

Var
	D,M:Integer;
	Chouser:TChouser;
	GSScore:Word;
	MoveMaked:Boolean;
	WorkStack,BufStack:TCooStack;
	WorkSubStack,BufSubStack:TSubStack;
	CpuStack:TSubStack;
	EmergyBunner:Boolean;
	QuontityOfPoints:LongInt;
	CpuPlayer:Boolean;
	KeyBar:TKeyBoard;
	Button:TButton;
	InFild:Boolean;


{==END=============VARIABLES=============END==}


{================TCooStack=======================}

Procedure TCooStack.Push;
Var
	NCoords:PCoords;
Begin
	New(NCoords);
	NCoords^.X:=XS;
	NCoords^.Y:=YS;
	NCoords^.RoundedPoints:=SubCoo;
	Put(Addr(NCoords^));
End;{TCooStack.Push}

{---------------------}

Procedure TCooStack.Pop;
Var
	P:Pointer;
	Coords:PCoords;
Begin
	Get(P);
	Coords:=P;
	XS:=Coords^.X;
	YS:=Coords^.Y;
	SubCoo:=Coords^.RoundedPoints;
	Dispose(Coords);
End;{TCooStack.Pop}


{==END==========TCooStack===================END==}


{===============TSUBSTACK======================}


Procedure TSubStack.Push;
Var
	NSubCoo:PSubCoo;
Begin
	New(NSubCoo);
	NSubCoo^.X:=XS;
	NSubCoo^.Y:=YS;
	Put(Addr(NSubCoo^))
End;{TSubStack.Push}

{---------------------}

Procedure TSubStack.Pop;
Var
	P:Pointer;
	SubCoo:PSubCoo;
Begin
	Get(P);
	SubCoo:=P;
	XS:=SubCoo^.X;
	YS:=SubCoo^.Y;
	Dispose(SubCoo);

End;{TSubStack.Pop}



{==END===================TSUBSTACK====================END==}



{==================PROCEDURES============}


Function GetPlNum(Color:Byte):Byte;
Var
	I:Byte;
Begin
	For I:=Low(Players) To High(Players) Do
		Begin
			If Players[I].Color =Color Then
				Begin
					GetPlNum:=I;
					Exit;
				End;
		End;
End;{GetPlNum}

{---------------------------------------------}

Procedure Quit(ID:Word);Far;
Begin
	KeyBar.ClearAll;
	CloseGraph;
	Writeln('(C) Points v 2.0(30.12.1999),Belei Sergiy,Ivano-Frankivsk,Ukraine');
	WorkStack.Done;
	BufStack.Done;
	WorkSubStack.Done;
	BufSubStack.Done;
	CpuStack.Done;
	Halt;
End;{Quit}

{--------------------------------------------------------------------------}

Procedure Shuher(ID:Word);Far;
Var
	S:Pointer;
	Screen : Array [1..50,1..80] of Byte Absolute $B800:0000;
	X,Y:Byte;
	F:File Of Byte;

Begin
	HideMouse;
	SaveColor;
	GetHugeImage(0,0,639,479,S);
	RestoreCrtMode;
	Assign(F,'points2.img');
	{$I-}
	Reset(F);
	{$I+}
	If IOResult = 0 Then
		Begin
			For Y:=1 To 50 Do
				For X:=1 To 80 Do
					Read(F,Screen[Y,X]);
			Close(F);
			GoToXY(5,24);
		End;

	If ReadKey=#27 Then
		Begin
			SetGraphMode(M);
			Quit(0);
		End
	Else
		SetGraphMode(M);
	PutHugeImage(0,0,S);
	RestoreColor;
	ShowMouse;
End;


Procedure RunHelp(ID:Word);Far;
Begin
	Help(20,20,True);
	KeyBar.PutMouseItems;
End;

Procedure ClrScore(N:Word);
Var
	OldColor:Byte;
Begin
	OldColor:=GetColor;
	With Players[N] Do
		Begin
			SetColor(GetPixel(XR-1,YR-1));
			OutTextXY(XR,YR,BinString(Score));
		End;
	SetColor(OldColor);
End;{ClrScore}

{---------------------------------------}

Procedure PutScore(N:Word);
Var
	OldColor:Word;
Begin
	OldColor:=GetColor;
  With Players[N] Do
	Begin
		SetColor(Color);
		OutTextXY(XR,YR,BinString(Score));
	End;
  SetColor(OldColor);
End;{PutScore}

{----------------------------------------------}
Procedure GetGrCoords(XA,YA:Word;Var XG,YG:Word);

	Function AG(X:Word):Word;
	Begin
		AG:=SqrSize+(HalfSize)*X;
	End;{AG}

Begin{GetGrCoords}
	XG:=FBegX+AG(XA);
	YG:=FBegY+AG(YA);
End;{GetGrCoords}

{----------------------------------------------}
Procedure GetEndsCoords(X,Y,XC,YC,HS:Word;Var X1,Y1,X2,Y2:Word);
Begin
	Case Work[X,Y] Of
		HorizLine:Begin
					X1:=XC-HS;
					X2:=XC+HS;
					Y1:=YC;
					Y2:=YC;
				  End;
		VertLine:Begin
					X1:=XC;
					X2:=XC;
					Y1:=YC-HS;
					Y2:=YC+HS;
				  End;
		Slash:Begin
					X1:=XC-HS;
					X2:=XC+HS;
					Y1:=YC+HS;;
					Y2:=YC-HS;;
				End;
		BkSlash:Begin
					X1:=XC-HS;
					X2:=XC+HS;
					Y1:=YC-HS;;
					Y2:=YC+HS;;
				End;
	   End;{Case}
End;{GetEndsCoords}

{----------------------------------------------}


Procedure GetLineCoords(X,Y:Word;Var X1,Y1,X2,Y2:Word);
Var
	XC,YC:Word;
Begin
	GetGrCoords(X,Y,XC,YC);
	GetEndsCoords(X,Y,XC,YC,HalfSize-PointRad-1,X1,Y1,X2,Y2);
End;{GetLineCoords}


{----------------------------------------------}

Function GetLineColor(X,Y:Word):Byte;
Var
	X1,Y1:Word;
Begin
	GetEndsCoords(X,Y,X,Y,1,X1,Y1,X,Y);
    GetLineColor:=Work[X1,Y1];
End;{GetLineColor}

{----------------------------------------------}



Procedure GetArrCoords(XG,YG:Word;Var XA,YA:Word);
Begin
	XA:=Round((XG-FBegX-SqrSize)/HalfSize);
    YA:=Round((YG-FBegY-SqrSize)/HalfSize);
End;{GetArrCoords}


{----------------------------------------------}

Procedure HowManyPoints(X,Y:Word);Far;
Begin
	If Work[X,Y]<>NPlayer Then
    	Inc(GSScore);
End;{HowManyPoints}

{----------------------------------------------}


Procedure PutDn(X,Y:Word);Far;
Begin
	If Work [ X,Y ] <> 0 Then
	  	Begin
           	Original [ X,Y ] := Work [X,Y ];
       		Work [ X,Y ] := 0;
        End;
End;{PutDn}


{-----------------------------------------------}


Procedure DrawLine(X,Y:Word;Color:Byte);
Var
	X1,X2,Y1,Y2:Word;
Begin
	SetColor(Color);
    GetLineCoords(X,Y,X1,Y1,X2,Y2);
	Line(X1,Y1,X2,Y2);
End;{DrawLine}


{-----------------------------------------------}



Procedure HideLine(X,Y:Word);Far;
Var
	Temp:Byte;
Begin
	Temp := Work[X,Y];
	If Odd(X) And Odd(Y) Then
    	Begin
        	Work[X,Y]:=Slash;
            DrawLine(X,Y,Ground);
            Work[X,Y]:=BkSlash;
            DrawLine(X,Y,Ground);
        End
    Else
    	If Odd(X) Then
        	Begin
            	Work[X,Y]:=HorizLine;
                DrawLine(X,Y,DarkGray);
            End
        Else
        	Begin
	        	Work[X,Y]:=VertLine;
				DrawLine(X,Y,DarkGray);
            End;
    Work[X,Y]:=Temp;
End;{HideLine}

{----------------------------------------------}

Procedure PutLine(X,Y:Word);Far;
Begin
	If Work[X,Y] <> 0 Then
    	Begin
	        DrawLine(X,Y,GetLineColor(X,Y));
		End;
End;{PutLine}


{-----------------------------------------------}

Procedure Emergy(X,Y:Word);Far;
Begin
	If Work[X,Y]=0 Then
    	Begin
	    	Original[X,Y]:=EmergyPlase;
            WorkSubStack.Push(X,Y);
        End;
End;{Emergy}

{-----------------------------------------------}



Procedure Refresh(X,Y:Word);Far;
Begin
	Work[X,Y]:=0;
End;{Refresh}


{-----------------------------------------------}


Procedure BetwinPoints(Clear:TWorkProc);
Var
   X,Y:Word;
Begin
     For Y:=0 To 2* VertSize-4 Do
        For X:=0 To 2* HorizSize-4 Do
             If (Odd( X )) Or (Odd( Y )) Then
               	Clear(X,Y);
End;{BetwinPoints}


{----------------------------------------------}



Procedure CopyRoundedPart;
Var
	X,Y:Word;
	Opened,Opened1:Boolean;

	Procedure CopyIf(X,Y:Word);
 	Begin{CopyIf}
     	If Work[X,Y]<>0 Then
      		Opened:=Not(Opened);
    	If Opened Or Opened1 Then
      		Original [X,Y]:=Work [X,Y];
    	If Work [X,Y]<>0 Then
	    	Opened1:=Not(Opened1);
	End;{CopyIf}

Begin{CopyRoundedPart}
	Opened:=False;
	Opened1:=False;
	For Y:=1  To VertSize Do
		For X:=0 To 2*HorizSize Do
    		CopyIf(X,2*Y-1);

	Opened:=False;
	Opened1:=False;
	For X:=1 To HorizSize Do
		For Y:=0 To 2*VertSize Do
    		CopyIf(2*X-1,Y);

End;{CopyRoundedPart}

{--------------------------------------}
Procedure WorkInCapture(WorkingProc:TWorkProc;Nxt:Boolean);Forward;


Function GetScore(PlayerNum:Word):Word;Forward;


Function  VRound:Boolean;
Var
	Bakup:PFild;
    XBeg,YBeg:Word;
	I:Byte;
    X,Y:ShortInt;
    VR:Boolean;
    BakScore:Word;
Begin
	New(Bakup);
    BakScore:=0;
	VR:=False;
    X:=1;
	Y:=1;
    XBeg:=XPot;
    YBeg:=YPot;
    For I:=0 To 8 Do
    	Begin
	        If Look(X,Y) Then
            	If VRound_1(X,Y) Then
                	If (XBeg=XPot) And (YBeg=YPot) Then
		        	   	Begin
    		            	GSScore:=0;
        		        	WorkInCapture(HowManyPoints,On);
            		   	    If GSScore>BakScore Then
                		   		Begin
                   					Bakup^:=Work;
                        		   	BakScore:=GSScore;
									VR:=True;
	                            	Work:=Original;
			   	                End;
    	    	           BetwinPoints(Refresh);
						End;
	        	Prev(X,Y,1,1);
        End;

	If VR Then
    	Begin
        	Work:=Original;
            BakScore:=GetScore(GetPlNum(NPlayer));
			Work:=Bakup^;
            Bakup^:=Original;
            CopyRoundedPart;
            Work:=Original;

            If GetScore(GetPlNum(NPlayer))<=BakScore Then{Num}
            	Begin
                	Original:=Bakup^;
					WorkSubStack.InitHead(Nil);
                    WorkInCapture(Emergy,On);
					If Not(WorkSubStack.Empty) Then
	                    WorkStack.Push(XPot,YPot,WorkSubStack.Head);
                    VR:=False;
                End;
		End;


    VRound:=VR;
    Dispose(Bakup);

End;{VRound}

{--------------------------------}


Function Check (XP,YP:Word;Up:Boolean):Byte;
Var
	Lines : Array [1..3] Of Byte;
	I,C:Byte;
    H:ShortInt;

Begin
	C:=0;
	Lines[2] := VertLine;
    If  Up Then
    	Begin
        	Lines[1] := BkSlash;
            Lines[3] := Slash;
            H:=-1;
        End{If Up}
    Else
		Begin
        	Lines[3] :=BkSlash;
            Lines[1]:=Slash;
            H:=1;
        End;{Else Up}
    For I:=1 To 3 Do
    	If Work[XP-2+I,YP+H] = Lines [I] Then
				Inc(C);

    Check :=  C ;
End;{Check}

{------------------------------------------------------}

Procedure Fill(X,Y:Word);Far;
Begin
	If (Original[X,Y]=0) Or (Original[X,Y] = EmergyPlase) Then
    	Begin
    		Original[X,Y]:=RoundedEmptyPlase;
            Dec(QuontityOfPoints);
	        Work[X,Y]:=RoundedEmptyPlase;
    	End

End;{Fill}

{------------------------------------------}

Procedure WorkInCapture(WorkingProc:TWorkProc;Nxt:Boolean);
Var
	Up,Up1,Down,Down1:Boolean;
	ChkUp,ChkDn,ChkHor:Byte;
    X,Y:Word;
Begin
	Up:=False;
    Down:=False;
    Up1:=False;
    Down1:=False;
	For Y:= 0 To VertSize-2 Do
    	For X:= 0 To HorizSize-2 Do
        	Begin
	          	If Work [2*X,2*Y] = NPlayer Then
                	Begin
                    	ChkUp:=Check (2*X,2*Y,True);
						ChkDn:=Check (2*X,2*Y,False);
	                    If (ChkUp=1) Then
							Up:=Not(Up);
                        If (ChkDn =1) Then
							Down:=Not(Down);
                    End; {If NPlayer}
                If (Up And Down) Or (Up1 And Down1) Then
                	Begin
                    	WorkingProc(2*X,2*Y);

                        If Not(Nxt) Then
							Exit;
                        Up1:=Up;
                        Down1:=Down;
                    End;
            End;
End;{WorkInCapture}
{-------------------------------------------------------------------}


Procedure IncScore(X,Y:Word);Far;
Begin
	If ( Work [X,Y] <> NPlayer ) And (Work [X,Y]<>EmergyPlase) And ( Work[X,Y]<>RoundedEmptyPlase ) And (Work[X,Y]<>0) Then{Num}
    	Inc(GSScore);
End;{IncScore}

{---------------------------------------------------------}

Function GetScore(PlayerNum:Word):Word;
Var
	OldPlayer:Word;
Begin
    OldPlayer:=NPlayer;
    NPlayer:=Players[PlayerNum].Color;
    GSScore:=0;
 	WorkInCapture(IncScore,True);
	NPlayer:=OldPlayer;
    GetScore:=GSScore;
End;{GetScore}


{--------------------------------------------------------}


Procedure RefreshWorkStack;
Var
	X,Y:Word;
    Heap:PPointer;
Begin
	While Not(BufStack.Empty) Do
		Begin{Not BufStack.Empty}
        	BufStack.Pop (X,Y,Heap);
            WorkStack.Push (X,Y,Heap);
        End;{Not BufStack.Empty}
End;{RefreshWorkStack}

{-----------------------------------------------------------}


Procedure RefreshStackInfo;
Var
	X,Y:Word;
    Heap:PPointer;
Begin
	BufStack.Init;

    While Not(WorkStack.Empty) Do
    	Begin
        	WorkStack.Pop(X,Y,Heap);
            If How_Many_Conections(X,Y) = 2 Then
            	Begin
            		WorkSubStack.InitHead(Heap);
					WorkSubStack.Done;
					Continue;
                End;

             BufStack.Push(X,Y,Heap);
		End;
    RefreshWorkStack;
End;{RefreshStackInfo}


{--------------------------------------------------------}

Procedure RunConection;
Var
	I:Byte;
	X,Y:ShortInt;
Begin
	Work:=Original;
 	BetWinPoints(Refresh);

	If VRound Then
    	Begin
			If HideLines Then
	        	BetwinPoints(HideLine);
	        RefreshStackInfo;
            WorkInCapture(Fill,On);
	        CopyRoundedPart;
            Work:=Original;
            BetwinPoints(PutLine);
            For I:=1 To High(Players) Do
            	Begin
              		If Players[I].Playing = Off Then
						Continue;
	                ClrScore(I);
	            	Players[I].Score := GetScore(I);
	                PutScore(I);
              	End;

        End;

End;{RunConection}

{-----------------------------------------------------------}



Procedure EmergyConection;
Var
	X,Y:Word;
    Heap:PPointer;
    XP,YP:Word;
    OldPlayer:Byte;
	OldXPot,OldYPot:Word;
Begin
	BufSubStack.InitHead(Nil);
    BufStack.Init;
	While Not(WorkStack.Empty) Do
    	Begin{Not(WorkStack.Empty)}
        	WorkStack.Pop(X,Y,Heap);
            WorkSubStack.InitHead(Heap);
            While Not(WorkSubStack.Empty) Do
            	Begin{Not(WorkSubStack.Empty)}
                	WorkSubStack.Pop(XP,YP);
                    If (XP=XPot) And (YP=YPot) Then
                    	Begin{If XPot And YPot}
                        	OldPlayer:=NPlayer;
                            NPlayer:=Original[X,Y];
                            OldXPot:=XPot;
        		            OldYPot:=YPot;
		                    XPot:=X;
                        	YPot:=Y;
                		    RunConection;
							XPot:=OldXPot;
		                    YPot:=OldYPot;
                            NPlayer:=OldPlayer;
                            WorkSubStack.Done;
							BufSubStack.Done;
                            RefreshWorkStack;
                            BufStack.Done;
                            Exit;
                        End;{If XPot And YPot}
                    BufSubStack.Push(XP,YP);
                End;{Not WorkSubStack.Empty}
            WorkSubStack.Done;
            WorkSubStack.Init;
            While Not(BufSubStack.Empty) Do
            	Begin{Not BufSubStack.Empty}
                	BufSubStack.Pop(XP,YP);
                    WorkSubStack.Push(XP,YP);
                End;{Not BufSubStack.Empty}
            BufStack.Push(X,Y,WorkSubStack.Head);
        End;{Not WorkStack.Empty}
	RefreshWorkStack;
    BufSubStack.Done;
    BufStack.Done;
    EmergyBunner:=Off;
End;{EmergyConection}






{==================TCHOUSER=====================}

Constructor TChouser.Init;
Var
	I:Byte;
Begin
    Color:=PColor;
    NPlayer:=PColor;
    MoveMaked:=Off;
End;{TChouser.Init}

{---------------------------}
Procedure TChouser.InitCoo;
Begin
	X:=NewX;
    Y:=NewY;
End;{TChouser.InitCoo}

{----------------------------------}

Procedure TChouser.Draw;

	Procedure SubCorn(PX,PY:ShortInt);
    Begin
        Line(X+(D1+1)*PX , Y+D1*PY , X+D2*PX , Y+D1*PY);
        Line(X+D1*PX , Y+(D1+1)*PY , X+D1*PX , Y+D2*PY);
    End;{SubCorn}


Begin
	SetColor(PColor);
	GetGrCoords(X,Y,X,Y);

	SubCorn(-1,-1);
	SubCorn(1,-1);
	SubCorn(-1,1);
	SubCorn(1,1);

  	GetArrCoords(X,Y,X,Y);
End;{PCouser.Draw}

{----------------------------------------------}

Procedure TChouser.Show;
Begin
	Draw(Color);
    ShowMouse;
End;{TChouser.Show}

{-------------------------}

Procedure TChouser.Hide;
Begin
	HideMouse;
	Draw(Ground);
End;{TChouser.Hide}
{---------------------------------------------------------------------}
Function  TChouser.CheckRange;
Begin
	 CheckRange := (NextX >= 0)And (NextX<=(2*(HorizSize-1)-1)) And (NextY >= 0) And (NextY<=(2*(VertSize-1)-1));
End;{TChouser.CheckRange}

{--------------------------------------------------------------------}

Procedure TChouser.Move;
Begin
	If Not(CheckRange(X+DX,Y+DY)) Then
		Exit;
	Hide;
	X:=X+DX;
    Y:=Y+DY;
	Show;
End;{TChouser.Move}

{-----------------------------------------------}

Procedure TChouser.Put;
Begin
	HideMouse;
	If (Original[X,Y]=0) Or (Original[X,Y] =EmergyPlase) Then
    	Begin
        	If (Original[X,Y] =EmergyPlase) Then
            	 EmergyBunner:=On;
		    Original [X,Y]:=NPlayer;
            Dec(QuontityOfPoints);
            XPot:=X;
            YPot:=Y;
            GetGrCoords(X,Y,X,Y);
            SetFillStyle(1,NPlayer);
			FillEllipse(X,Y,PointRad,PointRad);
            GetArrCoords(X,Y,X,Y);
            MoveMaked:=On;
        End;
    ShowMouse;
End;{TChouser.Put}
{-----------------------------------------------}
Procedure CpuPlayerRun;Forward;
{-----------------------------------------------}
Function IWReadKey:Word;
Var
	K:Word;
Begin
	If KeyOrMousePressed Then
    	K:=WReadKey
    Else
    	K:=Bytes2Word(255,255)
End;

{-----------------------------------}

Function Wait:Boolean;
Begin
	While True Do
                		Begin
                        	If MousePressed Then
                            	Begin
                                	Wait:=True;
                                    Exit;
                                End;
                            If KeyPressed Then
                            	Begin
                                	Wait:=False;
                                    Exit;
                                End;
                			If MouseIn(FBegX,FBegY,FEndX,FEndY) Then
								If Not(InFild) Then
                    				Begin
                                		HideMouse;
                    					SetMouseGraphCursor(MouseCursor,8,8);
										InFild:=True;
                                    	ShowMouse;
                        			End
                        		Else
                    		Else
                        		If InFild Then
                    				Begin
                                		HideMouse;
                    					SetMouseGraphCursor(AnotherCursor,1,1);
                            			InFild:=False;
                                    	ShowMouse;
                        			End;

                    	End;
End;{Wait}

{----------------------------------------}

Procedure TChouser.Run;
Var
	Xx,Yx:Integer;
    NewXPot,NewYPot,Key:Word;
    MousePres:Boolean;
Label
	Start;


{II-------------------------}

Procedure Go;
Begin
	Key:=0;
	Key:=WReadKey;
	Case Lo(Key) Of
		32:Put;
		0 :Case Hi(Key) Of
			75:Move(-2,0);{L}
			77:Move(2,0);{R}
			72:Move(0,-2);{U}
			80:Move(0,2);{D}
			Else
				KeyBar.Run(Key);
		   End;
		Else
			KeyBar.Run(Key);
	End;

End;{Go}

{II--------------------------}

Begin
	If EmergyBunner Then
		EmergyConection;
	If CpuPlayer Then
		CpuPlayerRun
	Else
		Begin
			ShowMouse;
			Repeat
				If Wait Then
					If MouseIn(FBegX,FBegY,FEndX,FEndY) Then
						Begin
							MouseWhereXY(Xx,Yx);
							GetArrCoords(Xx,Yx,NewXPot,NewYPot);
							NewXPot:=(NewXPot Div 2)*2;
							NewYPot:=(NewYPot Div 2)*2;
							If CheckRange(NewXPot,NewYPot) Then
								Begin
									XPot:=NewXPot;
									YPot:=NewYPot;
									Hide;
									InitCoo(XPot,YPot);
									Show;
									Put;
								End
							Else
						End
					Else
						Begin
							MouseWhereXY(Xx,Yx);
							If KeyBar.IsIn(Xx,Yx) Then
								Go
						End
				Else
					Go

			Until MoveMaked;
		{	CpuStack.Push(XPot,YPot);   }
		End;
	HideMouse;
	CpuPlayer:=Off;
	RunConection;
	Hide;
End;{Run}

{-----------------------------------------------}

Destructor TChouser.Done;
Begin
	Quit(255);
End;{TChouser.Done}

{==END=============TCHOUSER================END==}

{===============COMPUTER==BRAIN=================}
Procedure CpuPlayerRun;
Begin
End;{CpuPlayerRun}
{==END==========COMPUTER==BRAIN============END==}

Procedure InitScreen ;
Var
	XI,YI:Byte;
Begin
	SetFillStyle(WideDotFill,Blue);
	FloodFill(1,1,Blue);

	Desk(FBegX-2,FBegY-2,FEndX+4,FEndY+4,1);
	SetColor(DarkGray);


	For YI:=1 To VertSize-1 Do
		Begin
		  MoveTo (FBegX+PointRad+1,FBegY+YI*(SqrSize)+1);
		  For XI:= 0 To HorizSize-1 Do
			  Begin
				LineRel (SqrSize-2*PointRad,0);
				MoveRel (2*PointRad,0);
			  End;
		End;


	For XI:=1 To HorizSize-1 Do
		Begin
		  MoveTo (FBegX+XI*(SqrSize)+1,FBegY+PointRad+1);
		  For YI:= 0 To VertSize-1 Do
			  Begin
				LineRel (0,SqrSize-2*PointRad);
				MoveRel (0,2*PointRad);
			  End;
		End;

	Rectangle(FBegX+2,FBegY+2,FEndX,FEndY);


End;{InitScreen}

{----------------------------------------------}


Procedure OutLn(S:String);
Begin
	OutText(S);
	MoveRel(-1*TextWidth(s),TextHeight(S))
End;{OutLn}


{----------------------------------------------}



Procedure InitInfo(Xc,Yc,NPl:Word;Var YRet:Word);
Var
	N:String;
Begin
	With Players[NPl] Do
		Begin
			SetColor(Color);
			MoveTo(Xc+5,Yc+5);
			N:=Name;
			If N='' Then
				Exit;
			Desk(Xc+2,Yc+3,GetMaxX-2,Yc+2*TextHeight('a')+7,2);


			SetTextJustify(BottomText,RightText);
			OutLn('Name: '+N);
			OutText('Score: ');
			XR:=GetX;
			YR:=GetY;
			YRet:=YR+TextHeight(N)+5;
	End;{With}
  Rectangle(Xc+3,Yc+3,GetMaxX-3,YRet-3);
End;

{------------------------}

Procedure EndOfGame;
Begin
	Quit(254);
End;

{---------------------------}

Procedure EgaVga(Var Dr,Md:Integer);External;

{-----------------------------}

Procedure Goth(Var Dr,Md:Integer);External;






Var
	I,J:Byte;
	XA,YA:Word;
	X,Y:Integer;


Begin{MAIN}

	OvrInit(ParamStr(0){'points2.ovr'});

	if OvrResult <> ovrOk then
		begin
			case OvrResult of
				ovrError: Writeln('Program has no overlays.');
				ovrNotFound: Writeln('Overlay file not found.');
			end;
			Halt(1);
		end;
	OvrInitEMS;
	if OvrResult <> ovrOk then
		OvrInit(ParamStr(0){'points2.ovr'});



	WorkStack.Init;
	EmergyBunner:=Off;
	QuontityOfPoints:=(HorizSize-1)*(VertSize-1);
	CpuStack.Init;
	KeyBar.Init;
	For X:=Low(Original) To High(Original) Do
		For Y:=(Low(Original[X])) To High(Original[X]) Do
			Original[X,Y]:= 0;
	D := VGA;
	M := VGAHi;
	If RegisterBGIDriver(@EgaVga)<0 then
		begin
			writeln('®¬¨«ª   ¯à¨ à¥¥áâà æii ¤à ©¢¥à  ');
			halt
		end;
	If RegisterBGIFont(@Goth)<0 then
		begin
			writeln('®¬¨«ª   ¯à¨ à¥¥áâà æii èà¨äâ  ');
			halt
		end;



	InitGraph (D,M,''{c:\programs\tp7\bgi});
	SetPlayers;
	NPlayer:=Players[1].Color;
	InitScreen;
	XA:=FEndX+7;
	For I:=1 To High(Players) Do
		Begin
			InitInfo(XA,YA,I,YA);
			PutScore(I);
		End;
	Chouser.InitCoo(0,0);
	SetMouseGraphCursor(MouseCursor,8,8);
	InFild:=True;
	Button.SetColors(Black,LightGray);
	Button.Assign(FEndX+10,YA+20,630,YA+20+50,1,Bytes2Word(59,0),Anybutton,1,'F1 | „®¯®¬®£ ',RunHelp);
	KeyBar.Ins(Button);
	Button.Assign(FEndX+10,YA+20+70,630,YA+20+50+70,1,Bytes2Word(60,0),Anybutton,2,'F2 | ˜ãå¥à',Shuher);
	KeyBar.Ins(Button);
	Button.Assign(FEndX+10,YA+20+140,630,YA+20+50+140,1,27,Anybutton,3,'Esc | ‚¨å÷¤',Quit);
	KeyBar.Ins(Button);
	Repeat
		For I:=1 To High(Players) Do
			Begin
				If Not(Players[I].Playing) Then
					Continue;
				If Players[I].Name='Computer' Then
					CpuPlayer:=On;
				Chouser.Init(Players[I].Color);
				Chouser.Show;
				Chouser.Run;
				If QuontityOfPoints=0 Then
					EndOfGame;
			End;
	Until False;
End.  POINTS2              R(?ƒ    KEYRUS  COM           %¡+(BƒºX  FOREWORDTXT           A(Hƒ0                                                                                                                                                                                                                                                                                                  V&Tué  &ÿ6V&ÿ6Tšª­±2ƒÄRR+À&£V&£Tƒ>% ué j h=jèƒÄj h=jè	)ƒÄÿ6%èëÎ[jèö[^_ÉËÈ  WVèwƒ>% uéŸ ÿ6%è¢Ï[Àué ‹%€Wué Sè¯Ï[‹øPè.Ï[Àtmj Wšè3ƒÄ‹ğ‰VşĞtY‹Fş;6%u;%t‰6%£%è¬£%‰%è8 Àt0è™+%%Ò|= r‹Fş‰6%£%j j j%è?(ƒÄ^_ÉËVÿ6%è&Ï[‹ğPè¥Î[Àtj Všè3ƒÄ;%u;%t¸ ^Ã3À^ÃÈP  V‹vƒş#uƒ>% tTR&Ç¨  ¸ ^ÉËƒş#uF‹Ô€¿ä  u;SèsÎ[Àt0ÿ6Öè‡Î[Àt"F°Pš†~W[‹Ö€WtF°PSèpƒÄé`ƒş'u¾ ƒş%u‹%€Wt˜èäë“ƒ>% t€>\ ué3ƒşu
Vèrô[é$ÿ6\ÿ6%èEƒÄ‹Æ- |pHéH|Héâ ƒ>% tRÿv
ÿvVèşóƒÄNté1ÿƒ~uƒ~
 t~=uƒ~
 t~Duƒ~
 téÿÇ%  VR&Ç  éôşƒşud~=u]ƒ~
 uWÿ6%èŠÍ[Àué‚ ÿ6Öè)Í[ÀttèişÀtèj h=Vè&ƒÄé¨ş‰6%VR&Ç   ÿv
ÿvVèQóëİÿ6Ôè3Í[Àt.ÿv
ÿvVè5óƒÄ^ÉËÿvèÍ[Àtÿv
ÿvVèóƒÄ3À^ÉË È  ƒ>% t€>\ u2ÿv‹^€WuXR&‹r ‹‡dëXR&‹r ‹‡àPÿvè`ÔÉËÈ  WVh\ÿ6%èÊÌ[‹øPšè3ƒÄ‹ğ‰Vş£%‰%£%‰%Ğu3À¢\ëŠEW*äPÿvşVè£ÔƒÄ^_ÉÃVƒ>% t/ÿ6%èQÌ[Àt!€>\ö÷ŞèŒÿöt€>\ t
ÿ6%èJË[^Ã U‹ìjÿvè ÉË U‹ìj ÿvè ÉË È  WVÿvè&Ì[‰Fò‹F£%‹^€Wté j ÿvòèxƒÄé¡ƒ>% ué3 ƒ~ té* €>\ té éÿ6\ÿ6%èÙƒÄj jè´ñƒÄédÿ6%èºË[‰Fğ‹^ğ€¿
té= ‹^ğŠGW*äPj ÿvğšè3ƒÄRPèÓƒÄ=  té  É˜‹ØÑãƒ¿ té éƒ>% ué‰ ƒ~ ué€ è&ü=  ué èÁşèlş‰Fô€>\ té éÙÿ6\ÿ6%è1ƒÄFøPÿvôh\è'õƒÄ‰Fş‹^ò€¿
té ƒ~ø}é é¡%9Fşté ƒ~ø}é j jèÊğƒÄézèúı‰Fôèfú€>\ té" ÿvòèrÊ[=  ué j j j#è°ûƒÄéCFøPÿvôh\èŸôƒÄ‰Fş‹^ò€¿
té ƒ~ø}é é‹^ş€? ué	 ƒ~ø}é ƒ~øué ‹^ò€¿
té ÿvøh\ÿvèä ƒÄ‹^ş€? ué ƒ~ø}é ‹^ò€¿
té é¸ ƒ~øté ¸ é ¸  £
%‹^‹‡å ‰Fú‹Fú‰FüFú– ‹Fú£\jÿ6\¡\ PèÙîƒÄ=  té	 Ç\ éd ÿ6\ÿvè½ƒÄjÿ6\h\ÿvüè´öƒÄ
Ç\  Ç% ‹Fş£%Ç% ÿvüÿvşèX÷ƒÄ‰FöÇ%  Ç%  ƒ>\ ué èµï^_ÉÃ È  WV‹~ƒÿuÿvÿvè%ƒÄé<‹vVè4É[‹Ø€¿
ué&ÿukÿvFäPè*ƒÄ¿Â(ŠDX*ä ‰FúŠDY*ä ‰Fü‰~ş‹÷‹øXR‹Û&r ‹€? uéÚ FäPFF‹\şÛ&r ÿ7WGÿvúšÊ±2ƒÄëÆƒÿtVè­È[‹Ø€¿
uëxOtéš ÿvFòPè*ƒÄvòë€<.tF€< uõhıAhŠVšÊ±2ƒÄÀuÿvšÆ.3[ëZhıAhVšØÊ±2ƒÄÀthıAh–VšØÊ±2ƒÄÀu2ÿvšT/3ëËXR&‹r ÿ·òŠDY*ä PŠDX*ä PšÊ±2ƒÄ^_ÉÃ È„  WV‹v‹~Ç ŠEX*ä‰DŠEY‰DŠEZ‰DŠE]‰D8e\t8&ÍtÇD
 ëÇD
  ÇDş§ÇD·"h\èÖ3ƒÄÀt%h\†|ÿPèÒ(ƒÄ†|ÿPšKÄ±2ƒÄèÆh\DPèæ(ƒÄ^_ÉÃ V3öÿ6Ôè2Ç[Àuÿ6Öè$Ç[Àt¾ ƒşÉ€áŞÁĞ;6,t‰6,j j j"è+ ƒÄ^ËÈ0  WV‹~WèÇ[‰Fü‹^€? t€?.uéš+À‰Fô‰Fò‰Fğ‰Fî‰Fì‰FêÇFúĞ(ŠEX ‰FşŠEY*ä‹ğƒÆSFĞPè;(ƒÄÆºp\‹^ü*äŠ‡
PŠG^Ph»pš.WƒÄZR&Çª  WšF3[XR&‹r ÿ·RDÿPÿvşš±2ƒÄj j jFæPFâPFŞPFêPFòPFîPÿv