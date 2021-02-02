{Written 25.08.1999 for Points v 2.0
by Belei Sergiy}

Procedure RoundingMuzik;
const
	a=10;
Var
	I:Byte;
Begin
	For I:=1 To 3 Do
    	Sounding(142*I-a,150);
    Sounding(142*4-a,200);
    DelayS(100);
    For I:=1 To 2 Do
    	Sounding(100+234*I-a,200);
End.