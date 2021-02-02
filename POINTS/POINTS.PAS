    {ษอออออออออออออออออออออออออออออออออออัอออออออออออออออออออออออออออออออป}
    {บ ’ฎ็ชจ  ข 1.0   (9 แฅเฏญ๏ 1999 เ.) ณ Points v 1.0   (1999 Aug 9)   บ}
    {วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ}
    {บ ฅซฅฉ ‘ฅเฃiฉ                      ณ Belei Sergiy                  บ}
    {บ Iข ญฎ-”เ ญชiขแ์ช                  ณ Ivano-Frankivsk               บ}
    {บ “ชเ iญ                            ณ Ukraine                       บ}
    {ศอออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออผ}


Program Points;

{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 65520,0,100000}


Uses
	Crt,Graph;



Const


{
	Kฎญแโ ญโจ คซ๏ ง ฏจแใ ข ฌ แจข ซiญiฉ
	้ฎ ง'ฅคญใ๎โ์ โฎ็ชจ
}
	HorizLine = 40;
	VertLine  = 100 - HorizLine;
	Slash     = 30;
	BkSlash   = 100 - Slash;


{
	ฎงฌiเจ ฏฎซ๏ ข ชซiโจญช ๅ
}
	HorizSize = 15;
	VertSize  = 16;

{
	ฎงฌiเ ชซiโจญชจ i โฎ็ชจ ข ฏiชแฅซ ๅ
}
    HalfSize = 6;
    SqrSize = 2 * HalfSize;
    PointRad = 2;

{
	ฎฎเคจญ โจ ฏฎซ๏
}
    FBegX = 1;
    FBegY = 1;
    FEndX = FBegX + ((HorizSize ) * (SqrSize )-PointRad);
    FEndY = FBegY + ((VertSize ) * (SqrSize )-PointRad);


	On = True;
	Off = False;

  	D1=PointRad;
    D2=HalfSize;


    RoundedEmptyPlase:Byte=255;
    EmergyPlase:Byte=254;
{==END================CONST================END==}

Type

	PWorkProc = Procedure (X,Y:Word);
	Fild = Array [-2..(2 * HorizSize + 2),-2..(2 * VertSize + 2)] Of Byte;


{---------------------------------------}
	PPlayer = Record

		Color:Byte;
		Score:Word;
		Playing:Boolean;
		Name:String [18];
        XR,YR:Word;
    End;{PPlayer}

{---------------------------------------}

	PChouser = Object

    	X,Y:Word;{Position}
        Color:Byte;

{+}	    Constructor Init (PColor:Byte);
{+}		Procedure InitCoo(PX,PY:Word);
{+}     Procedure Draw (PColor:Byte);
{+}    	Procedure Show;
{+}	    Procedure Hide;
{+}		Function CheckRange (XD,YD:LongInt):Boolean;
{+}    	Procedure Move(DX,DY:ShortInt);
{+}	    Procedure Put;
{+}		Procedure Run;
{+}		Destructor Done;
    End;{PChouser}

{--------------------------------------}

	PSubCoo=^TSubCoo;

    TSubCoo =Record
    	XT:Word;
		YT:Word;
        Next:PSubCoo;
    End;{TSubCoo the record}

{----------------------------------------}
   	PCoords =^TCoords;

    TCoords =Record
    	X,Y:Word;
        RoundedPoints:PSubCoo;
        Next:PCoords;
    End;{TCoords the record}

{----------------------------------------}

    TStack =Object
    	Head:PCoords;

        Constructor Init;
        Procedure Del;
        Procedure Push(XS,YS:Word;SubCoo:PSubCoo);
        Procedure Pop(Var XS,YS:Word;Var SubCoo:PSubCoo);
        Function Empty:Boolean;
        Destructor Done;
    End;{TStack the object}

{----------------------------------------}

	TSubStack =Object
    	Head:PSubCoo;

        Constructor Init(Heap:PSubCoo);
        Procedure Del;
        Procedure Push(XS,YS:Word);
        Procedure Pop(Var X,Y:Word);
        Function Empty:Boolean;
        Function GetHead:PSubCoo;
        Destructor Done;
    End;{TSubStack the object}





{==END=============TYPE============END==}

{==================VARIABLES===============}

Var
	D,M:Integer;
    Original,Work,Bakup:Fild;
    Chouser:PChouser;
    Players:Array [1..2] Of PPlayer;
    XPot,YPot:Word;
    NPlayer:Byte;
    GSScore:Word;
    MoveMaked:Boolean;
    GHMC:Word;
    WorkStack,BufStack:TStack;
    WorkSubStack,BufSubStack:TSubStack;
    EmergyBunner:Boolean;
    QuontityOfPoints:LongInt;
{==END=============VARIABLES=============END==}


{================TSTACK=======================}
Constructor TStack.Init;
Begin
	Head:=Nil;
End;{TStack.Init}

{---------------------}
Procedure TStack.Del;
Var
	Prev:PCoords;
Begin
	Prev:=Head;
    Head:=Head^.Next;
    Dispose(Prev);
End;{TStack.Del}

{--------------------}
Function TStack.Empty:Boolean;
Begin
	Empty:= (Head = Nil);
End;{TStack.Empty}
{--------------------}

Procedure TStack.Push;
Var
	NCoords:PCoords;
Begin
	New(NCoords);
    NCoords^.X:=XS;
    NCoords^.Y:=YS;
    NCoords^.RoundedPoints:=SubCoo;
    NCoords^.Next:=Head;
    Head:=NCoords;
End;{TStack.Push}

{---------------------}

Procedure TStack.Pop;
Begin
	If Empty Then
		Exit;
	XS:=Head^.X;
    YS:=Head^.Y;
    SubCoo:=Head^.RoundedPoints;
    Del;
End;{TStack.Pop}

{----------------------}

Destructor TStack.Done;
Begin
	While Head <> Nil Do
    	Del;
End;{TStack.Done}


{==END==========TSTACK===================END==}



{===============TSUBSTACK======================}

Constructor TSubStack.Init;
Begin
	Head:=Heap;
End;{TSubStack.Init}

{---------------------}
Procedure TSubStack.Del;
Var
	Prev:PSubCoo;
Begin
    If Empty Then
    	Exit;
	Prev:=Head;
    Head:=Head^.Next;
	Dispose(Prev);
End;{TSubStack.Del}

{--------------------}
Function TSubStack.Empty:Boolean;
Begin
	Empty:= (Head = Nil);
End;{TSubStack.Empty}
{--------------------}

Procedure TSubStack.Push;
Var
	NSubCoo:PSubCoo;
Begin
	New(NSubCoo);
    NSubCoo^.XT:=XS;
    NSubCoo^.YT:=YS;
    NSubCoo^.Next:=Head;
    Head:=NSubCoo;
End;{TSubStack.Push}

{---------------------}

Procedure TSubStack.Pop(Var X,Y:Word);
Begin
	If Empty Then
    	Exit;
	X:= Head^.XT;
    Y:= Head^.YT;
    Del;
End;{TSubStack.Pop}

{----------------------}

Function TSubStack.GetHead;
Begin
	GetHead:=Head;
End;{TSubStack.GetHead}

{-----------------------}

Destructor TSubStack.Done;
Begin
	While Head <> Nil Do
    	Del;
End;{TSubStack.Done}


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

Procedure Quit;
Begin
	CloseGraph;
    Writeln('ษอออออออออออออออออออออออออออออออออออัอออออออออออออออออออออออออออออออป');
    Writeln('บ ’ฎ็ชจ  ข 1.0   (25 ซจฏญ๏ 1999 เ.) ณ Points v 1.0   (1999 Jul 25)  บ');
    Writeln('วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ');
    Writeln('บ ฅซฅฉ ‘ฅเฃiฉ                      ณ Belei Sergiy                  บ');
    Writeln('บ Iข ญฎ-”เ ญชiขแ์ช                  ณ Ivano-Frankivsk               บ');
    Writeln('บ “ชเ iญ                            ณ Ukraine                       บ');
    Writeln('ศอออออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออผ');
    WorkStack.Done;
    BufStack.Done;
    WorkSubStack.Done;
    BufSubStack.Done;
    Halt;
End;{Quit}

{--------------------------------------------------------------------------}


Procedure Prev(Var X,Y:ShortInt);
Begin
	If (X = 1) Then
  	If (Y > (-1)) Then
    	Begin
				Dec(Y);
        Exit;
      End;
 	If (Y = 1) Then
   	If (X < 1) Then
    	Begin
      	Inc(X);
        Exit;
      End;
 	If (X = (-1)) Then
   	If ( Y < 1) Then
    	Begin
       	Inc(Y);
        Exit;
      End;
  If (Y = (-1)) Then
   	If (X >(-1)) Then
			Dec(X);

End;{Prev}

{--------------------------------------------------}

Function BinString(X:Word):String;
Var
	S:String;
Begin
   	Str(X,S);
    BinString:=S;
End;{BinString}

{--------------------------------------------------}

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

{---------------------------------------------------------}

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

Function  GetLineDirect (Xld,Yld:ShortInt):Byte;
Begin

	Case Xld Of
		0: GetLineDirect := VertLine;
		1: Case Yld Of
			0: GetLineDirect := HorizLine;
	        1: GetLineDirect := BkSlash;
    	   -1: GetLineDirect := Slash;

       	   End;{Case Yld 1 }
   		-1: Case Yld Of
			 0: GetLineDirect := HorizLine;
          	 1: GetLineDirect := Slash;
	         -1: GetLineDirect := BkSlash;
			End;{Case Yld -1}
	End;{Case Xld}

End;{GetLineDirect}

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
	GetEndsCoords(X,Y,XC,YC,HalfSize,X1,Y1,X2,Y2);
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

Procedure PutLine(X,Y:Word);Far;
Var
	X1,X2,Y1,Y2:Word;
Begin
	If Work[X,Y] <> 0 Then
    	Begin
			GetLineCoords(X,Y,X1,Y1,X2,Y2);
            SetColor(GetLineColor(X,Y));
			Line(X1,Y1,X2,Y2);
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


Procedure BetwinPoints(Clear:PWorkProc);
Var
   X,Y:Word;
Begin
     For Y:=0 To 2* HorizSize-2 Do
        For X:=0 To 2* VertSize-2 Do
             If (Odd( X )) Or (Odd( Y )) Then
               	Clear(X,Y);
End;{BetwinPoints}


{----------------------------------------------}



Function Look_For_Conection(X,Y:ShortInt) :Boolean;
Begin
   Look_For_Conection := (Work [XPot + X,YPot + Y] = GetLineDirect( X,Y ) )
End;{Look_For_Conections}


{----------------------------------------}

Function How_Many_Conections:Byte;
Var
	X,Y:ShortInt;
	HMC:Byte;
Begin
	HMC:=0 ;
	For X := (-1) To 1 Do
		For Y := (-1) To 1 Do
        	If Look_For_Conection(X,Y) Then
				Inc( HMC ) ;
	How_Many_Conections := HMC ;
End;{How_Many_Conections}


{----------------------------------------------}


Function VRound_1(X,Y:ShortInt):Boolean;Forward;


{-----------------------------------------------}


Procedure Unconect(X,Y:ShortInt);
Begin
	Work[XPot+X,YPot+Y]:= 0;
    XPot:=XPot+2*X;
	YPot:=YPot+2*Y;
End;{Unconect}


{----------------------------------------------}
Function Look(X,Y:ShortInt):Boolean;
Begin
	Look:=False;

   	If Work[XPot+2*X,YPot+2*Y]=NPlayer Then
    	If (Original[XPot+X,YPot+Y]<> 100- GetLineDirect(X,Y)) Then
			If Work[XPot+X,YPot+Y]<> GetLineDirect(X,Y) Then
				Look:=True;
End;{Look}


{----------------------------------------------}

Function Conect(X,Y:ShortInt):Boolean;
Begin
	Conect:=False;
    	If Look(X,Y) Then
		      	Begin
    				Work[XPot+X,YPot+Y]:= GetLineDirect(X,Y);
					XPot:=XPot+2*X;
					YPot:=YPot+2*Y;
		            If VRound_1((-1)*X,(-1)*Y) Then
               			Conect:=True
	            	Else
    	           		Unconect((-1)*X,(-1)*Y);
				End;
End;{Conect}

{----------------------------------------------}
Procedure DelPoint;
Begin
	Work[XPot,YPot]:=0;
End;

{--------------------------------------------}

Function VRound_1(X,Y:ShortInt):Boolean;
Var
	I:Byte;
Begin
	VRound_1:=True;
    GHMC:=How_Many_Conections;
	If Not(GHMC=2) Then
  		For I:=1 To 8 Do
		    Begin
        		If Conect(X,Y) Then
	        		Exit;
    		    Prev(X,Y);
		    End;


    GHMC := How_Many_Conections;
    If GHMC < 2 Then
		DelPoint;
    If GHMC <> 2 Then
	 	VRound_1 := False;
End;{VRound_1}

{----------------------------------------}


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
Procedure WorkInCapture(WorkingProc:PWorkProc;Nxt:Boolean);Forward;

{I D:\Projects\Points\Smv.Pas}
Function GetScore(PlayerNum:Word):Word;Forward;


Function  VRound:Boolean;
Var
    XBeg,YBeg:Word;
	I:Byte;
    X,Y:ShortInt;
    VR:Boolean;
    BakScore:Word;
Begin
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
                   					Bakup:=Work;
                        		   	BakScore:=GSScore;
	                        		VR:=True;
	                            	Work:=Original;
			   	                End;
    	    	           BetwinPoints(Refresh);
						End;
	        	Prev(X,Y);
        End;

	If VR Then
    	Begin
        	Work:=Original;
            BakScore:=GetScore(GetPlNum(NPlayer));
			Work:=Bakup;
            Bakup:=Original;
            CopyRoundedPart;
            Work:=Original;

            If GetScore(GetPlNum(NPlayer))<=BakScore Then{Num}
            	Begin
                	Original:=Bakup;
                    WorkSubStack.Init(Nil);
                    WorkInCapture(Emergy,On);
					If Not(WorkSubStack.Empty) Then
	                    WorkStack.Push(XPot,YPot,WorkSubStack.Head);
                    VR:=False;
                End;
		End;


    VRound:=VR;

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

Procedure WorkInCapture(WorkingProc:PWorkProc;Nxt:Boolean);
Var
	Up,Up1,Down,Down1:Boolean;
	ChkUp,ChkDn,ChkHor:Byte;
    X,Y:Word;
Begin
	Up:=False;
    Down:=False;
    Up1:=False;
    Down1:=False;
	For Y:= 0 To VertSize-1 Do
    	For X:= 0 To HorizSize-1 Do
        	Begin
            	If Work [2*X,2*Y] = NPlayer Then{Num}
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
    Heap:PSubCoo;
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
	X,Y,OldXPot,OldYPot:Word;
    Heap:PSubCoo;
Begin
	BufStack.Init;
    OldXPot:=XPot;
    OldYPot:=YPot;

    While Not(WorkStack.Empty) Do
    	Begin
        	WorkStack.Pop(X,Y,Heap);
            XPot:=X;
            YPot:=Y;
            If How_Many_Conections = 2 Then
            	Begin
            		WorkSubStack.Init(Heap);
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
        	BetwinPoints(PutLine);
            RefreshStackInfo;
            WorkInCapture(Fill,On);
	        CopyRoundedPart;
            Work:=Original;
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
    Heap:PSubCoo;
    XP,YP:Word;
    OldPlayer:Byte;
    OldXPot,OldYPot:Word;
Begin
	BufSubStack.Init(Nil);
    BufStack.Init;
	While Not(WorkStack.Empty) Do
    	Begin{Not(WorkStack.Empty)}
        	WorkStack.Pop(X,Y,Heap);
            WorkSubStack.Init(Heap);
            While Not(WorkSubStack.Empty) Do
            	Begin{Not(WorkSubStack.Empty)}
                	WorkSubStack.Pop(XP,YP);
                    If (XP=XPot) And (YP=YPot) Then
                    	Begin{If XPot And YPot}
                        	OldPlayer:=NPlayer;
                            NPlayer:=Original[X,Y];
                            If OldPlayer=NPlayer Then
                            	Begin
                		            OldXPot:=XPot;
        		                    OldYPot:=YPot;
		                            XPot:=X;
                        		    YPot:=Y;
                		            RunConection;
        		                    XPot:=OldXPot;
		                            YPot:=OldYPot;
                            	End;
                            NPlayer:=OldPlayer;
                            WorkSubStack.Done;
							BufSubStack.Done;
                            RefreshWorkStack;
                            BufStack.Done;
                            Exit;
                        End;{If XPot And YPot}
                    BufSubStack.Push(XP,YP);
                End;{Not WorkSubStack.Empty}
            While Not(BufSubStack.Empty) Do
            	Begin{Not BufSubStack.Empty}
                	BufSubStack.Pop(XP,YP);
                    WorkSubStack.Push(XP,YP);
                End;{Not BufSubStack.Empty}
            BufStack.Push(X,Y,Heap);
        End;{Not WorkStack.Empty}
    RefreshWorkStack;
    BufSubStack.Done;
    BufStack.Done;
End;{EmergyConection}






{==================PCHOUSER=====================}

Constructor PChouser.Init;
Var
	I:Byte;
Begin
    Color:=PColor;
    NPlayer:=PColor;
    MoveMaked:=Off;
End;{PChouser.Init}

{---------------------------}
Procedure PChouser.InitCoo(PX,PY:Word);
Begin
	X:=PX;
	Y:=PY;
End;{PChouser.InitCoo}

{----------------------------------}

Procedure PChouser.Draw;

	Procedure SubCorn(PX,PY:ShortInt);
    Begin
        Line(X+(D1+1)*PX,Y+D1*PY,X+D2*PX,Y+D1*PY);
        Line(X+D1*PX,Y+(D1+1)*PY,X+D1*PX,Y+D2*PY);
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

Procedure PChouser.Show;
Begin
	Draw(Color);
End;{PChouser.Show}

{-------------------------}

Procedure PChouser.Hide;
Begin
	Draw(0);
End;{PChouser.Hide}
{---------------------------------------------------------------------}
Function  PChouser.CheckRange(XD,YD:LongInt):Boolean;
Begin
	 CheckRange := (XD >= 0)And (XD<=(2*(HorizSize-1)-1)) And (YD >= 0) And (YD<=(2*(VertSize-1)-1));
End;{PChouser.CheckRange}

{--------------------------------------------------------------------}

Procedure PChouser.Move;
Begin
	If Not(CheckRange(X+DX,Y+DY)) Then
		Exit;
	Hide;
  X:=X+DX;
  Y:=Y+DY;
  Show;
End;{Move}

{-----------------------------------------------}

Procedure PChouser.Put;
Begin
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
End;
{-----------------------------------------------}

Procedure PChouser.Run;
Begin
	If EmergyBunner Then
    	EmergyConection;
    Repeat
            Case ReadKey Of
                 #27:Done;
                 #32:Put;
		         #0 :Case ReadKey Of
        	   		    #75:Move(-2,0);{L}
            	        #77:Move(2,0);{R}
                	    #72:Move(0,-2);{U}
                    	#80:Move(0,2);{D}
			     End;
		    End;
	Until MoveMaked;

	RunConection;
	Hide;
End;{Run}

{-----------------------------------------------}

Destructor PChouser.Done;
Begin
	Quit;
End;
{==END=============PCHOUSER================END==}



Procedure InitScreen ;
Var
	XI,YI:Byte;
Begin


	For YI:=1 To VertSize-1 Do
		Begin
          MoveTo (FBegX+PointRad,FBegY+YI*(SqrSize));
		  For XI:= 0 To HorizSize-1 Do
		      Begin
				LineRel (SqrSize-2*PointRad,0);
                MoveRel (2*PointRad,0);
		      End;
        End;


    For XI:=1 To HorizSize-1 Do
		Begin
          MoveTo (FBegX+XI*(SqrSize),FBegY+PointRad);
		  For YI:= 0 To VertSize-1 Do
		      Begin
				LineRel (0,SqrSize-2*PointRad);
                MoveRel (0,2*PointRad);
		      End;
        End;


	Rectangle (FBegX+PointRad,FBegY+PointRad,FEndX,FEndY);
End;





Procedure OutLn(S:String);
	Begin
		OutText(S);
		MoveRel(-1*TextWidth(s),TextHeight(S))
	End;



Procedure SetPlayers;
Var
	I:Byte;
	ColorSet:Set Of Byte;
Begin




	SetTextStyle(4,0,9);
    SetColor(2);
    SetTextJustify(CenterText,CenterText);
    MoveTo(GetMaxX Div 2, 45);
	OutText('Points');
    SetTextStyle(4,0,4);
    MoveTo(GetMaxX Div 2+5,GetMaxY - 80);
	OutText('Version 1.0');


    MoveTo(0,GetMaxY -10);
    SetTextJustify(0,2);
    SetTextStyle(0,0,1);
    SetColor(3);
    OutText('Press any key ...');
	ReadKey;
ClearViewPort;
    SetTextJustify(BottomText,RightText);
    MoveTo(0,0);

    SetTextStyle(5,0,1);
	OutLn('Enter the name and color of players');

    OutLn('If player haven''t play now press');
	OutLn('            "Enter"');
    OutLn('The color can be one of them:');
    ColorSet:=[ ];
    For I:=1 To 2 Do
    	Begin
        	SetColor(I);
            OutLn(BinString(I));
            Include(ColorSet,I);
        End;
    SetColor(2);
    OutLn('Press any key to continue');
    ReadKey;
    ClearDevice;
    SetColor(3);
    RestoreCrtMode;

    For I:=1 To 2 Do
    	Begin
        	WriteLn('Player ü '+BinString(I));
            With Players [i] Do
            Begin
            	Write('Name:');
                ReadLn(Name);
                Score:=0;
                If Name='' Then
                	Begin
                    	Playing:=False;
                        Break;
                    End;
                Playing:=True;
                Repeat
	    			Write('Color:');
	                ReadLn(Color);
    			Until (Color In ColorSet);
                Exclude(ColorSet,Color);
            End;
        End;
    SetGraphMode(M);
End;{SetPlayers}




Procedure InitInfo(Xc,Yc,NPl:Word;Var YRet:Word);
Var
	N:String;
Begin
  With Players[NPl] Do
  	Begin
		SetColor(Color);
		MoveTo(Xc+2,Yc+2);
		SetTextJustify(BottomText,RightText);

	    N:=Name;
		If N='' Then N:='Not Playing';
		  OutLn('Name: '+N);
		  OutText('Score: ');

		  XR:=GetX;
		  YR:=GetY;
	      YRet:=YR+TextHeight(N)+2;
    End;{With}
  Rectangle(Xc,Yc,GetMaxX-1,YRet-1);

End;

Procedure EndOfGame;
Begin
Quit
End;

Var
	I,J:Byte;
  XA,YA:Word;
  X,Y:Integer;

Begin{MAIN}

    WorkStack.Init;
    EmergyBunner:=Off;
    QuontityOfPoints:=(HorizSize-1)*(VertSize-1);

	For X:=Low(Original) To High(Original) Do
  		For Y:=(Low(Original[X])) To High(Original[X]) Do
    		Original[X,Y]:= 0;


	D := CGA;
    M := CGAc1;
    InitGraph (D,M,'c:\programs\bgi');
    SetPlayers;
    NPlayer:=Players[1].Color;

    For I:= 1 To High(Players) Do
     	If Players[I].Playing Then Inc(J);
    If J<2 Then
		Begin
        	Outln('It''s not enough players to play  !!!');
            OutLn('');
            OutLn('Press any key ...');
            ReadKey;
    	  	Quit;
	    End;
    InitScreen;
    XA:=FEndX+2;
    For I:=1 To High(Players) Do
    	Begin
    		InitInfo(XA,YA,I,YA);
            PutScore(I);
        End;

    Chouser.InitCoo(0,0);

    Repeat
    	For I:=1 To High(Players) Do
        	Begin
            	If Not(Players[I].Playing) Then
					Continue;
            	Chouser.Init(Players[I].Color);
                Chouser.Show;
                Chouser.Run;
                If QuontityOfPoints=0 Then
                	EndOfGame;
            End;
    Until False;
End.