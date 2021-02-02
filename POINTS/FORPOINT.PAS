{$O+,X+}
{$M 16384,0,600000}
Unit ForPoint;
Interface
Uses
	U_Graph,Crt,F_Mouse,Graph,Screen,GrDialog,BStack;

Const

{
	Колiр фону
}
		Ground=LightGray;

{
	Kонстанти для запису в масив лiнiй
	що з'еднують точки
}
	HorizLine = 40;
	VertLine  = 100 - HorizLine;
	Slash     = 30;
	BkSlash   = 100 - Slash;


{
	Розмiри поля в клiтинках
}
	HorizSize = 30;
	VertSize  = 28;

{
	Розмiр клiтинки i точки в пiкселах
}
		HalfSize = 8;
		SqrSize = 2 * HalfSize;
		PointRad = 3;

{
	Координати поля
}
	FBegX = 5;
	FBegY = 5;
	FEndX = FBegX + ((HorizSize ) * (SqrSize ));
	FEndY = FBegY + ((VertSize ) * (SqrSize ));


	On = True;
	Off = False;

	D1=PointRad;
	D2=HalfSize;


	RoundedEmptyPlase:Byte=255;
	EmergyPlase:Byte=254;

{==END================CONST================END==}



Type
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




		TPlayer = Record
			Color:Byte;
			Score:Word;
			Playing:Boolean;
			Name:String [12];
			XR,YR:Word;
		End;{PPlayer}

	TFild = Array [-2..(2 * HorizSize + 2),-2..(2 * VertSize + 2)] Of Byte;

	TCooStack =Object(TStack)

		Procedure Push(XS,YS:Word;SubCoo:PPointer);
		Procedure Pop(Var XS,YS:Word;Var SubCoo:PPointer);
	End;{TStack the object}

	TSubStack =Object(TStack)

		Procedure Push(XS,YS:Word);
		Procedure Pop(Var XS,YS:Word);
	End;




Var
	Players:Array [1..10] Of TPlayer;
	MouseCursor,AnotherCursor:Array[1..64] Of Byte;
	NetDisk:String;
	ErrorCfg,HideLines:Boolean;
	Original,Work:TFild;
	XPot,YPot,GrNum:Word;
	NPlayer:Byte;
	GHMC:Word;
	KeyBar:TKeyBoard;
	WorkStack,BufStack:TCooStack;
	WorkSubStack,BufSubStack:TSubStack;
	CpuStack:TSubStack;
	D,Md:Integer;




	Procedure SetMouseGraphCursor(Var Mask;X,Y:Byte);
	Procedure Help(X,Y:Word;WaitFor:Boolean);
	Procedure Shuher(ID:Word);
	Procedure Quit(ID:Word);Far;



Implementation
Var
	HelpMB:TMessageBox;


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





	Procedure SetMouseGraphCursor;
	Begin
		If ErrorCfg Then
			Exit;
		MouseGraphCursor(Mask,X,Y)
	End;{SetMouseGraphCursor}

{----------------------}

Procedure Quit(ID:Word);
Begin
	KeyBar.ClearAll;
	CloseGraph;
	If ID<>0 Then
		Writeln('(C) Points v 2.1(17.02.2000),Belei Sergiy,Ivano-Frankivsk,Ukraine');
	WorkStack.Done;
	BufStack.Done;
	WorkSubStack.Done;
	BufSubStack.Done;
	CpuStack.Done;
	Halt;
End;{Quit}

{---------------------------}

Procedure Shuher(ID:Word);
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
			SetGraphMode(Md);
			Quit(0);
		End
	Else
		SetGraphMode(Md);
	PutHugeImage(0,0,S);
	RestoreColor;

{	ClearDevice;
	HideMouse;  }
End;


	Procedure Help;
	Var
		YPlus,B:Byte;
		F:Text;
		A:String;
		P:Pointer;
		KB:TKeyBoard;
		Butt:TButton;
		Key:Word;
	Begin
			HideMouse;
			If WaitFor Then
				Begin
					YPlus:=100;
					GetHugeImage(X-3,Y-3,X+490+3,Y+315+YPlus+6,P);
				End
			Else
				YPlus:=0;

			SaveColor;
			SetColor(Black);


			HelpMB.Init(X,Y,X+490,Y+315+YPlus,5,5,5,5,1,3,3,'Правила');
			If WaitFor Then
				Begin
					KB.Init;
					Butt.SetColors(Black,LightGray);
					Butt.Assign(X+150,Y+315,X+350,Y+315+70,1,13,AnyButton,1,'Ok | Enter',NOP);
					KB.Ins(Butt);
				End;
			HelpMB.AllowMessages;
			Assign(f,'Points_u.Hlp');
			{$I-}
			Reset(F);
			{$I+}
			If IOResult<>0 Then
				HelpMB.OutMessage('Допомога недоступна (Файл Points_u.Hlp не знайдено)')
			Else
				Begin
					B:=0;
					Repeat
						ReadLn(F,A);
						setcolor(black);
						HelpMB.Print(B,A);
						B:=B+1;
					Until EOF(F);
					Close(F);
				End;

			If WaitFor Then
				Begin
					ShowMouse;
					Key:=WReadKey;
					KB.Run(Key);
					KB.ClearAll;
					HideMouse;
					PutHugeImage(X-3,Y-3,P);
					ShowMouse;
				End;
			RestoreColor;
		End;
End.{UNIT}