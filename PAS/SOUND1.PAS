{浜様様様様様様様様様様様様様様様様様融
 �           Unit Sound1              �
 把陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳超
 �  (c) 1.07.1999  Ukraine,           �
 �		   Ivano-Frankivsk,   �
 �		   Belei Sergiy       �
 藩様様様様様様様様様様様様様様様様様夕 }



Unit Sound1;


Interface
	Uses
		CRT;
	Procedure Sound(Hz:Word);
    Procedure SoundOn;
	Procedure SoundOff;
    Procedure SoundChange;
    Function  SoundCheck:Boolean;
	Procedure DelayS(MS:Word);
	Procedure Sounding(Hz,MS:Word);


Implementation
Var
 CanISound:Boolean;


Procedure Sound(Hz:Word);
Begin
	If CanISound Then
    	Crt.Sound(Hz);
End;{Sound}

{-----------------------}

Procedure SoundOn;
Begin
	CanISound := True;
End;{SoundOn}

{-----------------------}

Procedure SoundOff;
Begin
	CanISound := False;
End;{SoundOff}

{-----------------------}

Procedure SoundChange;
Begin
	CanISound := Succ(CanISound);
End;{SoundChange}

{-----------------------}

Function SoundCheck;
Begin
	SoundCheck :=CanISound;
End;{SoundCheck}

{-----------------------}

Procedure DelayS(MS:Word);
Begin
	If CanISound Then
    	Crt.Delay(MS);
End;{DelayS}

{-----------------------}

Procedure Sounding(Hz,MS:Word);
Begin
	If Not(CanISound) Then
    	Exit;
    Crt.Sound(Hz);
    Crt.Delay(MS);
    Crt.NoSound;
End;{Sounding}

{-----------------------}

End.