{$O+,X+}
{$M 65520,0,0}
Unit Rounder2;
Interface
	Uses
		ForPoint;

	Function VRound_1(X,Y:ShortInt):Boolean;

Implementation
	Uses
		Rounder1;
{--------------------------------------------}

Function VRound_1(X,Y:ShortInt):Boolean;
Var
	I:Byte;
Begin
	VRound_1:=True;
	GHMC:=How_Many_Conections(XPot,YPot);
	If Not(GHMC=2) Then
		For I:=1 To 8 Do
			Begin
				If Conect(X,Y) Then
					Exit;
				Prev(X,Y,1,1);
			End;


	GHMC := How_Many_Conections(XPot,YPot);
	If GHMC < 2 Then
		DelPoint;
	If GHMC <> 2 Then
		VRound_1 := False;
End;{VRound_1}

{----------------------------------------}
End.{Unit}