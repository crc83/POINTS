Procedure RoundedPointsMakeZero(X,Y:Word);Far;
Begin
	If (Work[X,Y]<>NPlayer) And (Work[X,Y]<>EmergyPlase) Then
    	Work[X,Y]:=0;
End;{RoundedPointsMakeZero}


{----------------------------------}

Procedure FillColor(X,Y:Word);Far;
Begin
	If Original [X,Y]=0 Then
		Work [X,Y]:=NPlayer;
End;{FillColor}


{----------------------------------}


Procedure OnPoints(WorkProc:TWorkProc);
Var
	X,Y:Word;
Begin
    For X:=0 To HorizSize-1 Do
    	For Y:=0 To VertSize-1 Do
        	WorkProc(2*X,2*Y);
End;{OnPoints}

{----------------------------------------------}



Procedure PrepareWorkArray;
Begin
	Work:=Original;
    OnPoints(FillColor);
    WorkInCapture(RoundedPointsMakeZero,On);
    BetwinPoints(Refresh);

End;{PrepareWorkArray}

{---------------------------------------}
Function RoundSmallest:Boolean;
Var
	BakScore:Word;
    XBeg,YBeg:Word;
    X,Y:ShortInt;
    I:Byte;
    Bakup:PFild;
Begin
	New(Bakup);
	PrepareWorkArray;
    BakScore:=0;
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
            		   	    If (GSScore<BakScore) And (GSScore>0) Then
                		   		Begin
                   					Bakup^:=Work;
                        		   	BakScore:=GSScore;
	                            	Work:=Original;
			   	                End;
                            PrepareWorkArray;
	   	    	           	BetwinPoints(Refresh);
						End;
	        	Prev(X,Y,1);
        End;

    RoundSmallest:=(BakScore>0);

End;{RoundSmallest}


{------------------------------------------------------}
Procedure Perymeter(X,Y:Word);Far;
Begin
    If Work[X,Y]=NPlayer Then
	    If How_Many_Conections(X,Y)<>0 Then
			Inc(GSScore);
End;{Perymeter}

{------------------------------------------------------}
Procedure DelMaded(X,Y:Word);Far;
Begin
	If Original[X,Y]=NPlayer Then
    	Work[X,Y]:=0;
End;{DelMaded}

{-------------------------------------------------------}

Function AlarmInfo (Var Res:TCoords;Var NeededMoves:Word;Var MyAttakFild:PFild):Boolean;
Var
	MaxPlayer:Byte;
	AllMoves,MadedMoves:Word;
    OldXPot,OldYPot:Word;
	OldNPlayer:Byte;
    PrevMadedMoves,PrevAllMoves:Word;
	Bakup:PFild;

Begin
	New(Bakup);
    New(MyAttakFild);
    OldXPot:=XPot;
    OldYPot:=YPot;
    OldNPlayer:=NPlayer;
	PrevMadedMoves:=0;
    PrevAllMoves:=1;
    MaxPlayer:=255;
    BufSubStack.Init(Nil);
    While Not(CpuStack.Empty) Do
    	Begin
		    CpuStack.Pop(XPot,YPot);
            NPlayer:=Original[XPot,YPot];
            RoundSmallest;
            GSScore:=0;
			OnPoints (Perymeter);
            AllMoves:=GSScore;
            OnPoints (DelMaded);
            GSScore:=0;
            OnPoints (Perymeter);
            MadedMoves:=AllMoves-GSScore;
            If NPlayer=OldNPlayer Then
            	Begin
	            	BufSubStack.Push(XPot,YPot);
					MyAttakFild^:=Work;
                End;

            If MaxPlayer=255 Then
            	Begin
	            	MaxPlayer:=NPlayer;
                    Res.X:=XPot;
                    Res.Y:=YPot;
                End;
            If AllMoves<>0 Then
	            If (PrevMadedMoves/PrevAllMoves)<(MadedMoves/AllMoves) Then
    	        	Begin
        	        	PrevMadedMoves:=MadedMoves;
            	        PrevAllMoves:=AllMoves;
                        BakUp^:=Work;
                        MaxPlayer:=NPlayer;
	                    Res.X:=XPot;
    	                Res.Y:=YPot;
                	End
				Else
    	        	If (PrevMadedMoves/PrevAllMoves)<>0 Then
        	        	If (PrevMadedMoves/PrevAllMoves)=(MadedMoves/AllMoves) Then
                        	If Players[GetPlNum(NPlayer)].Score>=Players[MaxPlayer].Score Then
                               	Begin
            				        PrevAllMoves:=AllMoves;
                                    BakUp^:=Work;
                                    MaxPlayer:=NPlayer;
				                    Res.X:=XPot;
                				    Res.Y:=YPot;
			                	End;
        End;{While}
        AlarmInfo:=Off;
        If ((PrevMadedMoves/PrevAllMoves)>=0.75) Then
        	Begin
	        	AlarmInfo:=On;
                Work:=BakUp^;
			End;

		XPot:=OldXPot;
        YPot:=OldYPot;
        NPlayer:=OldNPlayer;
        Dispose(Bakup);
        NeededMoves:=PrevAllMoves-PrevMakedMoves;


End;{AlarmInfo}





{---------------------------------------}
Procedure DelUnUsed(X,Y:Word);Far;
Begin
	If Work[X,Y]=NPlayer Then
		If How_Many_Conections(X,Y)=0 Then
			Work[X,Y]:=0;
End;{DelUnUsed}

{---------------------------------------}

Procedure PointsList(X,Y:Word);Far;
Begin
	If Work[X,Y]=NPlayer Then
		WorkSubStack.Push(X,Y);
End;{EnemyPointsList}


{----------------------------------------}


Procedure Find(X,Y:Word);Far;
Begin
	If Work[X,Y]=NPlayer Then
		Begin
			XPot:=X;
			YPot:=Y;
		End;
End;{Find}

{-----------------------------------------}

Procedure RoundedPointsList(X,Y:Word);Far;
Begin
	If Work[X,Y]<>NPlayer Then
		WorkSubStack.Push(X,Y);
End;{RoundedPointsList}

{---------------------------------------}


Procedure GetRoundingPoints(PPlayer:Byte);
Var
	OldPlayer:Byte;
Begin
	OldPlayer:=NPlayer;
	NPlayer:=PPlayer;
	PrepareWorkArray;
	RoundSmallest;
	OnPoints(DelUnUsed);
	NPlayer:=OldPlayer;
End;{GetRoundingPoints}


{---------------------------------------}


Procedure GoToStart(Var X,Y:Word;XD,YD:ShortInt);
Begin
	For I:=1 To 8 Do
		Begin
			Prev(XD,YD,2,2);
			If Work[X+XD,Y+YD]=NPlayer Then
				Begin
					Inc(X,XD);
					Inc(Y,YD);
					GoToStart(X,Y,(-1)*XD,(-1)*YD);
				End;
		End;
End;{GoToStart}


{---------------------------------------}

Procedure FindAllVectors(Xb,Yb:Word;Var HVStack:TStack);

	{//////////////////////////////////////////////////}
	Procedure FindVectors(X,Y:Word;Xd,Yd:ShortInt);
	Var
		Xd1,Yd1,Xd2,Yd2:ShortInt;
		HVSubStack:TSubStack;
		I,K,J:Byte;{Лўчильники циклўв}
		QOfVectors,QOfHoocedVectors:Word;
	Begin
		{/Перегляд наступних точок/}
		For I:=1 To 8 Do
			Begin
				Prev(Xd,Yd,2,2);
				If Original[X+Xd,Y+Yd]=NPlayer Then
					FindVectors(X+Xd,Y+Yd,(-1)*Xd,(-1)*Yd)
			End;
		{/Перегляд точок через одну/}
		Xd:=Xd*2;
		Yd:=Yd*2;
		For I:=1 To 16 Do
			Begin
				Prev(Xd,Yd,4,2);
				If Original[X+Xd,Y+Yd]=NPlayer Then
					{//Пошук можливих векторўв перехоплення//}
					Begin
						QOfVectors:=0;
						QOfHoocedVectors:=0;
						Xd1:=2;
						Yd1:=2;
						HVSubStack.InitHead(Nil);
						For K:=1 To 8 Do
							Begin
								Xd2:=2;
								Yd2:=2;
								Prev(Xd1,Yd1,2,2);
								For J:=1 To 8 Do
									Begin
										Prev(Xd2,Yd2,2,2);
										If ((X+Xd1)=(X+Xd+Xd2)) And ((Y+Yd1)=(Y+Yd+Yd2)) Then
											Begin
												HVSubStack.Push(X+Xd1,Y+Yd1);
												QOfVectors:=1+QOfVectors;
												If Original[X,Y]<>0 Then
													QOfHoocedVectors:=1+QOfHoocedVectors;
											End;
									End;
							End;
						If Not(HVSubStack.Empty) Then
							HVStack.Push(QOfVectors,QOfHoocedVectors,HVSubStack.Head);
					End;
	End;{FindVectors}

	{////////////////////////////////////////////////////////////////////////////////////////////////}

Begin{FindAllVectors}
	HVStack.Init;
	FindVectors(Xb,Yb,2,2);
End;{FindAllVectors}

{--------------------------------------------}


Procedure CpuPlayerRun;

Var
	OldNPlayer:Byte;
	OldPot,Position,EnemyPos,CompPos,CompLastPos:TCoords;
	Bakup,CompAttakFild:PFild;
	NeededMoves:Word;
	EnemyPoints:TSubStack;
	VectStack:TStack;
	VectPackage:TSubStack;
	QOfVects,QOfHVects:Word;



	Procedure TryContrAttac;
	Begin
		If (NeededMoves>=1) And (GSScore>=1) And (GSScore<=2) Then
			While Not(EnemyPoints.Empty) Do
			- 	Begin{#}
					EnemyPoints.Pop(EnemyPos.X,EnemyPos.Y);
						While Not(WorkSubStack.Empty) Do
							Begin{##}
								WorkSubStack.Pop(CompPos.X,CompPos.Y);
								If (EnemyPos=CompPos) Then{ Ї точки якў можна оточити}
									If NeededMoves=1 Then{ Супернику для оточення потрўбен один хўд}
										If GSScore=1 Then
											Begin{##### Здўйснюю перехоплення }
												OldPot.X:=XPot;
												OldPot.Y:=YPot;
												OnPoints(Find);
												Chouser.InitCoo(XPot,YPot);
												Chouser.Put;
												Exit;
											End{#####}
										Else
											Exit{Перехоплення неможливе}
									Else
										If GSScore=2 Then
											Begin{#### Спробуй DubbleStepp}
												{....}
											End{####}
										Else
											Exit{Перехоплення неможливе}

							End{##}
					End{#}

	End;{TryContrAttak}


Begin
	If AlarmInfo(Position,NeededMoves,CompAttakFild) Then
		Begin{/ КОНТРАТАКА /}
			New(Bakup);
			Bakup^:=Work;
			GetRoundingPoints(Original[Position.X,Position.Y]);
			WorkSubStack.init(Nil);
			OldPlayer:=NPlayer;
			OnPoints(PointsList);
			NPlayer:=NPlayer;
			EnemyPoints.Init(WorkSubStack.Head);
			GetRoundingPoints(NPlayer);
			WorkInCapture(RoundedPointsList);
			OnPoints(DelMaded);
			GSScore:=0;
			OnPoints(Perymeter);
			TryContrAttac;
			If MoveMaked Then
				Exit;
			{/ ПЕРЕХОПЛЕННЯ /}
			GetRoundingPoints(Original[ Position.X,Position.Y ]);
			GoToStart(Position.X,Position.Y,2,2);
			FindAllVectors(Poistion.X,Position.Y,VectStack);
			{У VectStack повернуто координати внутрўшнўх векторўв атаки
			по пакетах типу TSubStack

			В основних комўрках X==Кўлькостў векторўв в пакетў
								Y==Кўлькостў перехоплених}

			Work:=Original;
			While Not(VectStack.Empty) Do
				Begin
					VectStack.Pop(QOfVects,QOfHVects,VectPackage.Head);
















		End;
End;{CpuPlayerRun}

 