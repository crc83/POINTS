{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,10000}

Unit U_Graph;

Interface
	Uses
		Graph,F_Mouse,BStack;

    Procedure SaveColor;
	Procedure RestoreColor;
    Procedure SaveTextSettings;
    Procedure RestoreTextSettings;
	Procedure SetTextSettings(Settings:TextSettingsType);
	Procedure Filling (x,y:integer;fill:word);
	Procedure Desk (xb,yb,xe,ye,bord:integer);
    Procedure DeskC(xb,yb,xe,ye,bord,color:integer);
	Procedure NormalMargins (xb,yb,xe,ye,bord:integer);
	Procedure InversedMargins(xb,yb,xe,ye,bord:integer);
    Procedure SetGrMouseCur(FName:String;X,Y:Byte);

Implementation
Type

    PByte=^Byte;

	TColorStack=Object(TStack)
    	Procedure Push(B:Byte);
		Procedure Pop(Var B:Byte);
    End;{TColorStack The Object}


Var
    Colors:TColorStack;
    SavedTextSettings:TextSettingsType;


{===========TCOLORSTACK===============}


Procedure TColorStack.Push;
Var
   	PB:PByte;
Begin
   	New(PB);
	PB^:=B;
   	Put(Addr(PB^));
End;{TColorStack.Push}

{----------------------------}

Procedure TColorStack.Pop;
Var
   	P:Pointer;
	PB:PByte;
Begin
	Get(P);
	PB := P;
    B:=PB^;
    Dispose(PB);
End;{TColorStack.Pop}


{----------------------------}


Procedure SaveColor;
Begin
    Colors.Push(GetColor)
End;{SaveColor}

{-----------------}

Procedure RestoreColor;
Var
	SavedColor:Byte;
Begin
	If Colors.Empty Then
    	Exit;
	Colors.Pop(SavedColor);
	SetColor(SavedColor);
End;{RestoreColor}

{------------------}

Procedure SetTextSettings(Settings:TextSettingsType);
Begin
	With Settings Do
    Begin
		SetTextStyle(Font,Direction,CharSize);
    	SetTextJustify(Horiz,Vert);
    End;{With}
End;{SetTextSettings}

{--------------------------}

Procedure SaveTextSettings;
Begin
	GetTextSettings(SavedTextSettings);
End;{SaveTextSettings}

{-------------------------}

Procedure RestoreTextSettings;
Begin
	SetTextSettings(SavedTextSettings);
End;{RestoreTextSettings}

{------------------------}

Procedure Filling (x,y:integer;fill:word);
Begin{Filling}
	setfillstyle (1,fill);
	floodfill (x,y,fill)
End;{Filling}

{------------------------------------------}

Procedure UpLeftBorder (xb,yb,xe,ye,bord:integer;Color:Word);
Begin
    SetColor (Color);
	Line (xb-Bord,yb-Bord,xb-Bord,ye+Bord);
	Line (xb,yb,xb,ye);
	line (xb,ye,xb-Bord,ye+Bord);
	Line (xb-Bord,yb-Bord,xe+Bord,yb-Bord);
	Line (xb,yb,xe,yb);
	Line (xe+Bord,yb-Bord,xe,yb);
	Filling(xb-bord Div 2,yb+(ye-yb)Div 2,Color);
End;{UpLeftBorder}

{---------------------------------------------}

Procedure DownRightBorder(xb,yb,xe,ye,bord:integer;Color:Word);
Begin
    SetColor (Color);
	Line (xb-Bord,ye+Bord,xe+Bord,ye+Bord);
	Line (xb-Bord,ye+Bord,xb,ye);
	Line (xb,ye,xe,ye);
	Line (xe+Bord,yb-Bord,xe+Bord,ye+Bord);
	Line (xe,ye,xe,yb);
	Line (xe+Bord,yb-Bord,xe,yb);
	Filling (xb-Bord+(xe-xb)Div 2,ye+bord Div 2,Color);
End;{DownRightBorder}

{----------------------------------------------}


Procedure InversedMargins;
Begin
	SaveColor;
    UpLeftBorder (xb,yb,xe,ye,bord,DarkGray);
	DownRightBorder(xb,yb,xe,ye,bord,White);
   	SetColor(7);
	Line(xe+Bord,ye+Bord,xe,ye);
	Line(xb-Bord,yb-Bord,xb,yb);
	RestoreColor;
end;{InversedMargins}

{--------------------------------------}

Procedure NormalMargins;
Begin
	SaveColor;
    UpLeftBorder (xb,yb,xe,ye,bord,White);
	DownRightBorder(xb,yb,xe,ye,bord,DarkGray);
   	SetColor(7);
	Line(xe+Bord,ye+Bord,xe,ye);
	Line(xb-Bord,yb-Bord,xb,yb);
	RestoreColor;
End;{NormalMargins}

{------------------------------------------}

Procedure DeskC;
Begin
    SaveColor;
    SetFillStyle(1,Color);
	Bar(xb,yb,xe,ye);
    RestoreColor;
   	NormalMargins(xb,yb,xe,ye,bord);
End;{DeskC}

{------------------------------}

Procedure Desk;
Begin
	DeskC(Xb,Yb,Xe,Ye,Bord,LightGray);
End;{Desk}

{-------------------------------}

Procedure SetGrMouseCur(FName:String;X,Y:Byte);
Var
	F:File Of Byte;
    Ar:Array[1..64] Of Byte;
    I:Byte;
Begin
	Assign(