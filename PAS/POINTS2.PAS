{$M 16384,240000,655000}
		{浜様様様様様様様様様様様様様様冤様様様様様様様様様様様様様様様�
		 � ��腦�  � 2.0   (30.12.1999) � Points v 2.0   (30.12.1999)   �
		 把陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
		 � �カォ �ム�i�                � Belei Sergiy                  �
		 � I����-�����i≡讓            � Ivano-Frankivsk               �
		 � ����i��                     � Ukraine                       �
		 藩様様様様様様様様様様様様様様詫様様様様様様様様様様様様様様様�}


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
			writeln('���┼��  �爬 爛メ矗��ii む��▲�� ');
			halt
		end;
	If RegisterBGIFont(@Goth)<0 then
		begin
			writeln('���┼��  �爬 爛メ矗��ii 葯�籵� ');
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
	Button.Assign(FEndX+10,YA+20,630,YA+20+50,1,Bytes2Word(59,0),Anybutton,1,'F1 | ��������',RunHelp);
	KeyBar.Ins(Button);
	Button.Assign(FEndX+10,YA+20+70,630,YA+20+50+70,1,Bytes2Word(60,0),Anybutton,2,'F2 | �竇ム',Shuher);
	KeyBar.Ins(Button);
	Button.Assign(FEndX+10,YA+20+140,630,YA+20+50+140,1,27,Anybutton,3,'Esc | ��纓�',Quit);
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
End.  POINTS2              �R(?�    KEYRUS  COM           %�+(B��X  FOREWORDTXT           A(H�0                                                                                                                                                                                                                                                                                                  V&Tu�  &�6V&�6T����2���RR+�&�V&�T�>% u� j h=j����j h=j��	)���6%�蓚�[j���[^_彬�  WV��w�>% u�� �6%�茴�[�u�� �%�Wu�� S�莚�[��P��.�[�tmj W��3�����V��tY�F�;6%u;%t�6%�%�茗�%�%�8 �t0���+%%�|= r�F��6%�%j j j%��?(��^_彬V�6%��&�[��P�茱�[�tj V��3��;%u;%t� ^�3�^暖P  V�v��#u�>% t�TR&��  � ^彬��#uF���推  u;S��s�[�t0�6�����[�t"�F�P��~W[���Wt�F�PS�p���`��'u� ��%u�%�Wt�葢���>% t�>\ u�3��u
V��r�[�$�6\�6%�E����- |pH�H|H蛯 �>% tR�v
�vV�蕈���Nt�1��~u�~
 t�~=u�~
 t�~Du�~
 t���%  �VR&�  蜚���ud�~=u]�~
 uW�6%����[�u�� �6���)�[�tt�i��t�j h=V���&��薑��6%�VR&�   �v
�vV��Q鼡��6���3�[�t.�v
�vV��5���^彬�v���[�t�v
�vV�����3�^彬 �  �>% t�>\ u2�v�^�Wu�XR&�r ��d��XR&�r ���P�v��`塢鉾  WVh\�6%�菠�[��P��3�����V��%�%�%�%�u3摺\��EW*�P�v�V�茖���^_秒V�>% t/�6%��Q�[�t!�>\��滓���t�>\ t
�6%��J�[^� U��j�v� 彬 U��j �v� 彬 �  WV�v��&�[�F��F�%�^�Wt� j �v���x��蕁�>% u�3 �~ t�* �>\ t� ���6\�6%葫��j j�茣����d�6%�荳�[�F��^���
t�= �^��GW*�Pj �v���3��RP������=  t� ����慫��� t� ��>% u�� �~ u�� �&�=  u� 菫��l��F��>\ t� 蛉�6\�6%�1���F�P�v�h\��'����F��^���
t� �~�}� ���%9F�t� �~�}� j j�菠����z蓼��F���f��>\ t�" �v���r�[=  u� j j j#�莪����C�F�P�v�h\�������F��^���
t� �~�}� ��^��? u�	 �~�}� �~�u� �^���
t� �v�h\�v葢 ���^��? u� �~�}� �^���
t� 藐 �~�t� � � �  �
%�^��� �F��F��F��F�� �F��\j�6\�\ P葫���=  t�	 �\ �d �6\�v莉��j�6\h\�v��茣���
�\  �% �F��%�% �v��v���X����F��%  �%  �>\ u� 莎�^_秒 �  WV�~��u�v�v�%���<�vV��4�[����
u�&�uk�v�F�P���*��紳(�DX*� �F��DY*� �F��~������XR��&r ��? u蠣 �F�PFF�\��&r �7WG�v����2��詁��tV�茘�[����
u�xOt�� �v�F�P��*���v鳬�<.tF�< u�h�Ah�V�扮2���u�v��.3[�Zh�Ah�V�慂�2���th�Ah�V�慂�2���u2�v�T/3詼�XR&�r �健�DY*� P�DX*� P���2��^_秒 ��  WV�v�~� �EX*��D�EY�D�EZ�D�E]�D8e\t8&�t�D
 ��D
  �D���D�"h\�蕚3���t%h\��|�P�菻(����|�P�K脹2�����h\�DP�蒿(��^_秒 V3��6���2�[�u�6���$�[�t� ����痾�双;6,t�6,j j j"��+ ��^鉾0  WV�~W���[�F��^�? t�?.u��+��F��F��F��F��F��F蠻F��(�EX �F��EY*�����S�F�P��;(����p\�^�*���
P�G^Ph�p�.W���ZR&��  W�F3[�XR&�r ��R�D�P�v���2��j j j�F�P�F�P�F�P�F�P�F�P�F�P�v