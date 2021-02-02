Unit NetPoin3;
Interface
		 Uses
			 Graph,GrDialog,ForPoin3,Dos,F_Mouse,U_Graph;

		 Procedure ReadGroupFromDisk;
		 Procedure WriteGroupToDisk;
		 Procedure EraseGroupFile;
		 Procedure NetConnection(ID:Word);


		 Procedure ReadMoveFromDisk;
		 Procedure WriteMoveToDisk(Move:TMove);



Const
	mdStatus=1;
	mdRegistred=2;
	mdStarted=3;

	statLock=2;
	statOpen=1;

Implementation
Uses
	IniPoin3;

Const
	GroupFileName:String[8]='$PPlayer';
	StatusFileName:String[8]='$PStatus';
	mdPut=1;
	mdGet=2;

Type
	StatusLine=Array [1..3] Of Byte;


Var
	TempButt:TButton;
	NetConnectionStatus:Boolean;

Function Exist(FName:String):Byte;
{перевўряї чи ўснуї файл}
{0-ўснуї
 1-не ўснуї
 2-помилка}
Var
	F:File;
Begin
	Assign(F,FName);
	{$I-}
	Reset(F);
	{$I+}
	Case IOResult Of
		0,18:
		Begin
			Close(F);
			Exist:=0;
		End;

		2:Exist:=1;

		Else
			Exist:=2;
	End;{Case}

End;{Exist}


{------------------------}







Function MakeName(Name:String):String;
Begin
	MakeName:=NetDisk+Name+'.'+GrNum;
End;{MakeName}


{-----------------------}


Procedure ReadGroupFromDisk;
Var
   FT:File Of TPlayer;
   I,ExistStatus:Byte;
Begin
	 Assign(FT,MakeName(GroupFileName));
	 ExistStatus:=Exist(MakeName(GroupFileName));
	 If ExistStatus=1 Then
		Exit;

	 Reset(FT);
	 For I:=1 To Index-1 Do
		   Begin
				Read(FT,Players[I]);
				With Players[I] Do
					 PutPlayerToList(Name,Color,I,True);

		   End;
	 Close(FT);
End;{ReadGroupFromDisk}


{-----------------------------------------}


Procedure WriteGroupToDisk;
Var
   FT:File Of TPlayer;
   I:Byte;

Begin
	 Assign(FT,MakeName(GroupFileName));
	 I:=1;
	 Rewrite(FT);
	 While I<=Index Do
		   Begin
				Write(FT,Players[I]);
				Inc(I);
		   End;
	 Close(FT);
End;{WriteGroupToDisk}


{------------------------------------------}


Procedure EraseGroupFile;
Var
	FT:File Of TPlayer;
Begin
	Assign(FT,NetDisk+GroupFileName+GrNum);
	{$I-}
	Erase(FT);
	{$I+}
End;{EraseGroupFile}


{------------------------------}


Procedure WorkWithStatus(Mode:Byte;Var Status:StatusLine);
Var
	F:File Of Byte;
	I:Byte;

Begin
	Assign(F,MakeName(StatusFileName));
	Case Mode Of
		mdGet:Reset(F);
		mdPut:Rewrite(F);
	End;{Case}
	For I:=1 To 3 Do
		Case Mode Of
			mdGet:Read(F,Status[I]);
			mdPut:Write(F,Status[I]);
		End;

	Close(F);
End;{WorkWithStatus}


{-----------------------------}


Function GetStatus(What:Byte):Byte;
Var
	A:StatusLine;
Begin
	Case Exist(MakeName(StatusFileName)) Of
		1:GetStatus:=0;
		0:Begin
			WorkWithStatus(mdGet,A);
			GetStatus:=A[What];
		  End;
		Else
			GetStatus:=$FF;
	End;{Case}
End;{GetStatus}


{---------------------}


Procedure PutStatus(What,Info:Byte);
Var
	A:StatusLine;
Begin
	WorkWithStatus(mdGet,A);
	A[What]:=Info;
	WorkWithStatus(mdPut,A);
End;{PutStatus}


{---------------------}


Procedure InitStatusFile;
Const
	A:StatusLine=(0,0,0);
Begin
	WorkWithStatus(mdPut,A);
End;{InitStatusFile}


{-----------------------}
Procedure DoneConection(ID:Word);
Var
	Ok:Boolean;
Begin
	WriteGroupToDisk;
	PutStatus(mdRegistred,Index-1);
	PutStatus(mdStatus,statOpen);
	NetConnectionStatus:=True;
	KB.Del(kbDoneConnect,Ok);
End;


Procedure NetConnection(ID:Word);
{Приїднатись}
Var
	Registered,Started,IsExist:Byte;
	Status:Byte;
	IsF:Boolean;
Begin
	SaveColor;
	SetColor(Black);
	If Index>1 Then
		Begin
			MB.OutMessage('На вшому комп''ютерў вже ї зареїстрованў гравцў.Очистьте список кнопкою "ОЧИСТИТИ" ў спробуйте'+
			' приїднатись ще раз.');
			RestoreColor;
			Exit;
		End;
	IsExist:=Exist(MakeName(StatusFileName));
	If IsExist=2 Then
		Begin
			MB.OutMessage('Помилка при спробў реїстрацў∙,можливо неправильно вказано ўм''я мережевого диска,'+
			'у доступў до файла вўдмовлено або не вистарчаї пам''ятў');
			RestoreColor;
			Exit;
		End;

	If IsExist=1 Then{Не ўснуї}
		Begin
			InitStatusFile;
			PutStatus(mdStatus,statLock);
		End;
	If IsExist=0 Then{Ўснуї}
		Begin
			MB.OutMessage('Чекайте,зарз приїднуїться хтось ўнший.Натиснўть будь-яку клавўшу або кнопку мишў,щоб перервати процес');
			Repeat
				Status:=GetStatus(mdStatus);
				If Status=$FF Then
					Begin
						{Error}
						MB.OutMessage('Помилка при спробў реїстрацў∙,можливо неправильно вказано ўм''я мережевого диска,'+
						'у доступў до файла вўдмовлено або не вистарчаї пам''ятў');
						RestoreColor;
						Exit;
					End;
				If KeyOrMousePressed Then
					Begin
						MB.OutMessage('Процес перервано по бажанню користувача');
						RestoreColor;
						Exit;
					End;
			Until Status=statOpen;
			PutStatus(mdStatus,statLock);
			Index:=GetStatus(mdRegistred)+1;
		End;
	ReadGroupFromDisk;
	MB.OutMessage('ВВедўть ўм''я ў колўр точок гравцўв якў будуть грати на вашому комп''ютерў ў натиснўть "ЗАВЕРШИТИ".'+
	'Якщо ви останнўй натиснўть кнопку "РОЗПОЧЧАТИ".');
	KB.Get(kbConect,False,TempButt,IsF);
	KB.DisAllow(kbMinus,IsF);
	KB.DisAllow(kbPlus,IsF);
	For I:=NOfPlayers To 9 Do
		PlayersIncDec(kbPlus);
	TempButt.Hide;
	TempButt.Name:='F2|Завершити';
	TempButt.WorkProc:=DoneConection;
	TempButt.Draw;
	TempButt.Code:=kbDoneConnect;
	KB.Ins(TempButt);

End;{NetConnection}

















Procedure ReadMoveFromDisk;
Var
   FM:File Of TMove;
   Move:TMove;

{--//-------------//--}
Function AreMovesEqvel(M1,M2:TMove):Boolean;
Var
   MA1:Array [1..31] Of Byte Absolute M1;
   MA2:Array [1..31] Of Byte Absolute M2;
   I:Byte;
Begin
	For I:=1 To 31 Do
		If MA1[I]<>MA2[I] Then
			Begin
				AreMovesEqvel:=False;
				Exit
			End
End;{AreMovesEqvel}
{--\\-------------\\--}

{--//-------------//--}
Procedure PutMoves1To2(M1,M2:TMove);
Var
   MA1:Array [1..31] Of Byte Absolute M1;
   MA2:Array [1..31] Of Byte Absolute M2;
   I:Byte;
Begin
	For I:=1 To 31 Do
		MA2[I]:=MA1[I];
End;{PutMoves1To2}


Begin
	 Assign(FM,NetDisk+'$PMoves.'+GrNum);
	 Reset(FM);
	 Repeat
		   Read(FM,Move);
	 Until AreMovesEqvel(Move,OldMove);
	 PutMoves1To2(Move,OldMove);
End;{ReadMoveFromDisk}


{------------------------------------------}



Procedure WriteMoveToDisk(Move:TMove);
Var
   FM:File Of TMove;
Begin
	 Assign(FM,NetDisk+'$PMoves.'+GrNum);
	 Rewrite(FM);
	 Write(FM,Move);
	 OldMove:=Move;
End;{WriteMoveToDisk}

{------------------------------------------}

End.