{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,600000}
Unit GrMesBox;
Interface
Uses
        Graph,U_Graph;
Type
	TMarginRecord = Record
    	Left,Right,Up,Down:Word;
    End;{TMarginRecord the Record}

{--------------------------}

	TMessageBox = Object
        	XB,YB,XSize,YSize,BorderSize:Word;
            Margin:TMarginRecord;
            Header:String;
            OldText:String;
            CharColor,BkColor:Byte;
            OldStyle:TextSettingsType;
            IsHeader:Boolean;
            IsMessagesAllowed,Cleared:Boolean;
            UpperMargin,XCharSize,YCharSize,YDistanse,HeaderDistanse:Word;

        Constructor Init(XBeg,YBeg,XEnd,YEnd,UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist:Word;HeaderText:String);
        Procedure InitCoo (XBeg,YBeg,XEnd,YEnd:Word;HeaderText:String);
        Procedure InitMargins(UpMargin,DownMargin,LeftMargin,RightMargin,Border,Dist,HeaderDist:Word);
        Procedure GetSizeInChar;
        Procedure Draw;
        Procedure AllowMessages;
        Procedure DisAllowMessages;
        Procedure Print(Var I:Byte;Message:String);
        Procedure OutMessage(Message:String);
        Procedure Clear;

     End;{TMessageBox The Object}

Implementation
{--------------------------------------------}

Constructor TMessageBox.Init(XBeg,YBeg,XEnd,YEnd,UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist:Word;HeaderText:String);
Begin
        InitCoo(XBeg,YBeg,XEnd,YEnd,HeaderText);
        InitMargins(UMarg,DMarg,LMarg,RMarg,Bord,Dist,HeaderDist);
        GetSizeInChar;
        GetTextSettings(OldStyle);

        OldText:='';
        AllowMessages;
        Cleared:=True;
        Draw;
End;{TMessageBox.Init}

{---------------------------------------------}



Procedure TMessageBox.InitCoo (XBeg,YBeg,XEnd,YEnd:Word;HeaderText:String);
Begin
      XB:=XBeg;
      YB:=YBeg;
      {If XEnd<XBeg Or YEnd<YBeg Then /Error in borders diffention/}
      XSize:=XEnd-XBeg;
      YSize:=YEnd-YBeg;
      Header:=HeaderText;
      IsHeader:=(Header<>'');
End;{TMessageBox.InitCoo}


{----------------------------------------------}

Procedure TMessageBox.InitMargins(UpMargin,DownMargin,LeftMargin,RightMargin,Border,Dist,HeaderDist:Word);
Begin
      HeaderDistanse:=HeaderDist;
      BorderSize:=Border;
      YDistanse:=Dist;
      With Margin Do
        Begin
                Up:=UpMargin;
            Down:=DownMargin;
            Left:=LeftMargin;
            Right:=RightMargin;
        End;{With}
End;{TMargin.InitMargins}

{--------------------------------------------}

Procedure TMessageBox.GetSizeInChar;
Begin
      XCharSize:=(XSize-Margin.Left-Margin.Right) Div TextWidth('a');
      YCharSize:=(YSize-Margin.Up-Margin.Down) Div TextHeight('a');
End;{TMessageBox.GetSizeInChar}

{--------------------------------------------}

Procedure TMessageBox.Draw;
Var
        X,Y:Word;
Begin
        Desk(XB,YB,XB+XSize,YB+YSize,BorderSize);
    If IsHeader Then
    	Begin
        	SetTextJustify(CenterText,CenterText);
            Y:=TextHeight(Header) Div 2+Margin.Up+YB;
            X:=XB+XSize Div 2;
            UpperMargin:=TextHeight(Header);
            OutTextXY(X,Y,Header);
        End;{If}
    UpperMargin:=UpperMargin+Margin.Up;
    SetTextSettings(OldStyle);
End;{TMessageBox.Draw}

{-----------------------------------------------}

Procedure TMessageBox.AllowMessages;
Begin
    IsMessagesAllowed:=True;
End;{TMessageBox.AllowMessages}

{----------------------------------------------}

Procedure TMessageBox.DisAllowMessages;
Begin
    IsMessagesAllowed:=False;
End;{TMessageBox.DisAllowMessages}

{----------------------------------------------}

Procedure TMessageBox.Print;
Var
        BPos,CountOfLines:Word;
        G:Byte;
    LineToOut:String;
Begin
	SaveTextSettings;
    SetTextSettings(OldStyle);
	BPos:=1;
    CountOfLines:= Length(Message)Div XCharSize +1;
    If CountOfLines>YCharSize Then
        CountOfLines:=YCharSize;

    For G:=I To CountOfLines-1+