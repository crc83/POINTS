{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 65520,0,0}
Unit Rounder;
Interface
	Uses ForPoin3;

	Procedure Prev(Var X,Y:ShortInt;Radius,Step:Byte);
    Function  GetLineDirect (Xld,Yld:ShortInt):Byte;
	Function Look_For_Conection(XPot,YPot:Word;X,Y:ShortInt) :Boolean;
	Function How_Many_Conections(XPot,YPot:Word):Byte;
	Procedure Unconect(X,Y:ShortInt);
	Function Look(X,Y:ShortInt):Boolean;
	Function Conect(X,Y:ShortInt):Boolean;
	Procedure DelPoint;
	Function VRound_1(X,Y:ShortInt):Boolean;
Implementation


Procedure Prev(Var X,Y:ShortInt;Radius,Step:Byte);
Begin
	If (X = Radius) Then
      	If (Y > (-1)*Radius) Then
   	    Begin
		     Dec(Y,Step);
             Exit;
        End;
 	If (Y = Radius) Then
       	If (X < Radius) Then
        	Begin
                 Inc(X,Step);
			     Exit;
		    End;
 	If (X = (-1)*Radius) Then
	   	If ( Y < Radius) Then
    		Begin
	       		Inc(Y,Step);
    		    Exit;
		    End;
	If (Y = (-1)*Radius) Then
   		If (X >(-1)*Radius) Then
			Dec(X,Step);

End;{Prev}

{--------------------------------------------------}

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



Function Look_For_Conection(XPot,YPot:Word;X,Y:ShortInt) :Boolean;
Begin
   Look_For_Conection := (Work [XPot + X,YPot + Y] = GetLineDirect( X,Y ) )
End;{Look_For_Conections}


{----------------------------------------}

Function How_Many_Conections(XPot,YPot:Word):Byte;
Var
	X,Y:ShortInt;
	HMC:Byte;
Begin
	HMC:=0 ;
	For X := (-1) To 1 Do
		For Y := (-1) To 1 Do
        	If Look_For_Conection(XPot,YPot,X,Y) Then
				Inc( HMC ) ;
	How_Many_Conections := HMC ;
End;{How_Many_Conections}


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