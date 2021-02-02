Program Nardy;
(*{$L egavga.obj}  *)
Uses

		WinDos,Crt,Graph,U_Graph;




Type
		Fild = Array [0..25] Of ShortInt;

{---------------------------------------}

		Kubik = Object
				X,Y,Kj,G,Color:Integer;

				Constructor Draw (Xg,Yg,Kk:Integer);
				Procedure Clr;
				Procedure Point(Xa,Ya:word);
				Procedure Point1;
				Procedure Point2;
				Procedure Point3;
				Procedure Point4;
				Procedure Point5;
				Procedure Point6;
				Procedure Point7;
				Procedure Peach(Var Pch:Byte);
		End;{Kubik}

{----------------------------------------}



		TChouser=Object
				Dir,Color,Xg,Yg{,SizeKoef}:Word;


		Function CheckPos(Pos:Integer):Boolean;
		Function GetDirection(Y:Word):Word;
		Function CheckCoo(Dx,Dy:Integer):Boolean;
				Procedure Draw (XGr,YGr,Direction,DrawColor:word);
		{       Procedure Clr;}
				Procedure Show(DrawingColor:Byte;Pos:Byte);
		Procedure ShowAll(Pos,DrawColor:Word);
				Procedure Move(Dx,Dy:Integer);
				Procedure Left;
				Procedure Right;
				Procedure Up;
				Procedure Down;
		End;{TChouser}

{---------------------------------------}

 Fishka = Object
		BkCol:Byte ;
		NumberOfPlayer,Position:Integer;

		{Constructor Init(Number,IPosition:Integer);}
		Procedure Draw(Color:Byte);
		Function Check(Color,Posit:Byte;Var Error:ShortInt):Boolean;
		Procedure Show(col,pos:integer);
		Procedure Circ(x,y,col:word);
		Procedure Hide(col,pos:integer);
		Procedure Select(col,pos:byte;var error:shortint);
		Procedure Change(pl_num,pos:byte;quont:shortint;var err:shortint);
		Procedure Move(n_pl:byte;Var ErrCode:ShortInt) ;

 End;{Fishka}

{==END===========TYPE===========END==}


{=============VARIABLES==============}

Var

		D,M,R:Integer;
		Pch:Array [1..2] Of Byte;
		Kub:Array [1..2] Of Kubik;
		NPlayer:Word;
		Chouser:TChouser;
		Fhk:fishka;
		Plf:Array [1..2] Of fild;
		Hour,Min,Sec,TSec,ChangeMin,ChangeSec,ChangeTSec:Word;
		CanIMessage,ReStart,CompPlayer,Dubl,MoveMaked,
		SomsSelect,MsgClred:Boolean;
		SelectPos:Byte;
		PotPos,t:ShortInt;
		OldTxt,MsgText:String;
		Txt:String[7];

{==END=======VARIABLES==========END==}

{==============CONSTANTS=============}

Const
		{For TChouser Object}
		Ac=5;
		SizeKoef=5;
		Xm=5;
		Ym=433;
		DXm=570;
		DYm=35 ;
		Cm=4;

	{Buttons Coords}
		XButt=462;
		YButt=10;
		DXButt=160;
		DYButt=20;
		CButt=3;
		Cn=5;

		Xf=40;
		Yf=30;
		Cf=5;
		N=360;
		Xk=462;
		Yk=320;
		K=50;
		Ck=5;

		Colors:Array [1..2] Of Byte=(15,0);
		Xp=Xk-Ck*2;
		Yp=3*Ck+Yk+K;
		DXp=125;
		DYp=40;
		Congrat:String[21]='   ВITАЮ!!!'+#13+'вигpали  ';
		Butt:Array [1..3] of String[31]=('Esc │ Вихiд',
										'F3 │ З компмп''ютером','F4 │ Переграти')  ;

{==END===========CONSTANTS===============END==}

Label
		Start;


{===================KUBIK=======================}

Constructor Kubik.Draw (Xg,Yg,Kk:Integer);
Var
        B:Byte;
Begin
        Kj:=Kk;
		X:=Xg;
        Y:=Yg;
        G:=Round(Kk/10);
        SetColor(Yellow);
        Arc(Xg+2*G,Yg+2*g,90 ,180 ,2*G);
        Arc(Xg+Kk-2*G,Yg+2*G,360 ,450 ,2*G);
        Arc(Xg+Kk-2*G,Yg+Kk-2*G,270 ,360 ,2*G);
        Arc(Xg+2*G,Yg+Kk-2*G,180 ,270 ,2*G);
        Line(Xg,Yg+2*G,Xg,Yg+Kk-2*G);
        Line(Xg+2*G,Yg,Xg+Kk-2*G,Yg);
        Line(Xg+Kk,Yg+2*G,Xg+Kk,Yg+Kk-2*G);
        Line(Xg+2*G,Yg+Kk,Xg+Kk-2*G,Yg+Kk);
        Filling(Xg+2*G,Yg+2*G,Yellow);
End;{Kubik.Draw}


{---------------------------------------------}

Procedure Kubik.Clr;
Begin
        Color:=Yellow;
        Point1;
        Point2;
        Point3;
        Point4;
        Point5;
		Point6;
        Point7;
        Color:=Black
End;{Kubik.Clr}


{----------------------------------------------}

Procedure Kubik.Point (xa,ya:word);
Begin
		SetColor(Color);
        Circle(Xa,Ya,G-1);
        Filling(Xa,Ya,Color);
End;{Kubik.Point}

{----------------------------------------------}

Procedure Kubik.Point1;
Begin
        Point(X+3*G,Y+3*G)
End;{Kubik.Point1}

{----------------------------------------------}

Procedure Kubik.Point2;
Begin
		Point(X+3*G,Y+5*G)
End;{Kubik.Point2}

{----------------------------------------------}

Procedure Kubik.Point3;
Begin
        Point(X+3*G,Y+Kj-3*G)
End;{Kubik.Point3}

{---------------------------------------------}

Procedure Kubik.Point4;
Begin
        Point(X+5*G,Y+5*G)
End;{Kubik.Point4}

{---------------------------------------------}

Procedure Kubik.Point5;
Begin
        Point(X+Kj-3*G,Y+3*G)
End;{Kubik.Point5}

{----------------------------------------------}

Procedure Kubik.Point6;
Begin
        Point(X+Kj-3*G,Y+5*G)
End;{Kubik.Point6}

{----------------------------------------------}

Procedure Kubik.Point7;
Begin
        Kubik.Point(X+Kj-3*G,Y+Kj-3*G)
End;{Kubik.Point7}

{----------------------------------------------}

Procedure Kubik.Peach (Var Pch:Byte);
Begin
        Clr;
        Pch:=Random(50)Div 10+1;
		Case Pch Of

                1:Point4;

                2:Begin
                Point3;
                        Point5;
                  End;{2}


        3:Begin
        Point3;
        Point4;
        Point5;
      End;{3}

        4:Begin
        Point1;
                Point3;
        Point5;
		Point7;
	  End;{4}

        5:Begin
        Point1;
        Point3;
        Point4;
        Point5;
        Point7;
      End;{5}

        6:Begin
                Point1;
        Point2;
		Point3;
        Point5;
                Point6;
        Point7;
      End;{6}
        End;{Case}
end;

{==END===============KUBIK================END==}

Procedure GCoo_ArrCoo (pl_num,xh,yh:word;var pos:shortint);Forward;
Procedure ArrCoo_GCoo(Pl_Num,Pos:Byte;Var Xgg,Ygg:word);Forward;



{====================TChouser===================}
Function TChouser.GetDirection(Y:Word):Word;
Begin
	If Y<=(Yf+N/2) Then
		GetDirection:=0
	Else
		GetDirection:=1;
End;{TChouser.GetDirection}

{-----------------------------------------------}

Function TChouser.CheckCoo(Dx,Dy:Integer):Boolean;
Begin
		CheckCoo:=((Xg+Dx)>=(Xf-R))
						And
						((Xg+Dx)<=(Xf+26*R))
						And
						((Yg+Dy)>=(Yf-Ac))
						And ((Yg+Dy)<=(Yf+26*R+Ac))
End;{TChouser.CheckCoo}

{------------------------------------------------}

Function TChouser.CheckPos(Pos:Integer):Boolean;
Begin
		CheckPos := (Pos>=0) And (Pos<=25)
End;{TChouser.CheckPos}

{-----------------------------------------------}



Procedure TChouser.Draw;
Begin
		SetColor(DrawColor);
		YGr:=YGr+10*Direction;
		Line(XGr,YGr,XGr-3*SizeKoef,YGr-5*SizeKoef+10*SizeKoef*Direction);
		Line(XGr,YGr,XGr+3*SizeKoef,YGr-5*SizeKoef+10*SizeKoef*Direction);
		Line(XGr-3*SizeKoef,YGr-5*Sizekoef+10*SizeKoef*Direction,XGr+3*SizeKoef,YGr-5*SizeKoef+10*SizeKoef*Direction);
		Filling (XGr,YGr-3*SizeKoef+6*SizeKoef*Direction,DrawColor);
		YGr:=YGr-10*Direction;
		
End;{TChouser.Draw}

{-----------------------------------------------}

Procedure TChouser.Show;
Var
		X,Y:Word;
Begin
		ArrCoo_GCoo(NPlayer,Pos,X,Y);
		Draw(X,Y,GetDirection(Y),DrawingColor);
End;{TChouser.Show}


{------------------------------------------------}

Procedure TChouser.ShowAll;
Var
		I:Byte;
	CLightGreen,CGreen,CCyan:Word;
Begin
		If DrawColor<>LightGray Then
		Begin
			CLightGreen:=LightGreen;
			CGreen:=Green;
			CCyan:=Cyan;
		End
	Else
		Begin
				CLightGreen:=LightGray;
			CGreen:=LightGray;
			CCyan:=LightGray;
		End;

{???}
		If (Plf[NPlayer,PotPos]>0) Then
		Show(CLightGreen,Pos)
	Else
		Show(CGreen,Pos);
	For I:=1 To 2 Do
		Begin
				If Pch[I]=0 Then
				Continue;


			Show(CCyan,Pos+Pch[I]);
		End;
End;{TChouser.ShowAll}


{-----------------------------------------------}


Procedure TChouser.Move;
Var
        Pos:ShortInt;
Begin
	CheckCoo(Dx,Dy);
        GCoo_ArrCoo(NPlayer,Xg,Yg,Pos);
        ShowAll(Pos,LightGray);
    Xg:=Xg+Dx;
    Yg:=Yg+Dy;
    GCoo_ArrCoo(NPlayer,Xg,Yg,Pos);
    ShowAll(Pos,0);
End;{TChouser.Move}

{----------------------------------------------------}

Procedure TChouser.Left;
Begin
      TChouser.Move((-2)*R,0)
End;{TChouser.Left}

{-----------------------------------------------------}
Procedure TChouser.Right;
Begin
      TChouser.Move(2*R,0)
End;{TChouser.Right}

{------------------------------------------------------}


Procedure TChouser.Up;
Begin
      TChouser.Move(0,(-25)*R)
End;{TChouser.Up}

{--------------------------------------------------------}

Procedure TChouser.Down;
Begin
      TChouser.Move(0,25*R)
End;{TChouser.Down}


{==END=====================TCHOUSER================END==}

{=====================PROCEDURES=======================}
Procedure Beep ;
Begin
      {
      WriteLn(#7);
      }
End;{Beep}

{-------------------------------------------------------}
(*
Procedure VgaDrv(Var Dr,Md:Integer);External;
*)
{-------------------------------------------------------}

Procedure PrintClr ;
Begin

    SetColor (LightGray);
    OutTextXY(Xp+Cn+1,Yp+Cn+1,OldTxt);

End;{PrintClr}

{-------------------------------------------------------}

Procedure Print (T:String );
Begin
      PrintClr;
      SetColor (Blue);
      OutTextXY(Xp+Cn+1,Yp+Cn+1,T);
      OldTxt:=T;
End;{Print}




Function CheckTwelwe:Boolean;
Var
    Quonti,Ic,Jc:Byte;
    N:Byte;
Begin
	  CheckTwelwe:=False;
      For N:=1 To 2 Do
          For Ic:=0 To 12 Do
              Begin
                    Quonti:=0;
                    For Jc:=1 To 12 Do
                        If Plf[N,Ic+Jc]>0 Then
                           Inc(Quonti);

                    If Quonti>=12 Then
                       Begin
                             CheckTwelwe:=True;
                             Exit
                       End;
              End;
End;{CheckTwelve}


{-------------------------------------------------------}

{
procedure add(PlNum,Ind:Byte;Arg:ShortInt);
begin
        Plf[PlNum,Ind]:=Plf[PlNum,Ind]+Arg;
end;
}

{------------------------------------------------------}


Function VirtualChekTwelwe(PlNum,BPos,EPos:Byte):Boolean;
Begin
        Dec(Plf[PlNum,BPos]);
        Inc(Plf[PlNum,EPos]);
        VirtualChekTwelwe:=Not(CheckTwelwe);
        Inc(Plf[PlNum,BPos]);
        Dec(Plf[PlNum,EPos]);
End;{VirtualChekTwelwe}

{---------------------------------------------------------}

Function Translate(Position:Byte):Byte;
Begin
      If (Position>=1) And (Position<=12) Then
         Translate:=Position+12;
      If (Position>12) And (Position<=24) Then
         Translate:=Position-12
End;{Translate}

{---------------------------------------------------------}


procedure MsgClr;
begin
        settextjustify(bottomtext,righttext);
        msgclred:=true;
        setcolor(lightgray);
        outtextxy(xm+cn+10,ym+cn+5,MsgText);
end;


procedure outmessage (s:string);
begin
        if not(msgclred) then
                msgclr;
        If Not(CanIMessage) Then
                Exit;
        beep;
        settextjustify(bottomtext,righttext);


        setcolor(black);
        MsgText:=s;
        outtextXY(xm+cn+10,ym+cn+5,s);
        gettime(hour,changemin,changesec,changetsec);
        msgclred:=false;
end;


procedure error1(var err:shortint);
begin
        outmessage('Ви не м(r)жете взяти не св(r)ю фiшку');
        err:=(-1)
end;

procedure error2(var err:shortint);
begin
        outmessage('Ви не м(r)жете взяти дipку');
        err:=(-2)
end;

procedure GCoo_ArrCoo (pl_num,xh,yh:word;var pos:shortint);
begin
        if (xh<=xf) and (xh>=(xf-2*r)) then
         if (yh<=yf+12*r) then
                if pl_num=1 then
                 begin
                         pos:=25;
                         exit
                 end
				else
                 begin
                         pos:=(-1);
                         exit
                 end
         else
                if pl_num=1 then
                 begin
                         pos:=0;
                         exit
                 end
                else
                 begin
                         pos:=(-1);
                         exit
                 end
        else
         if((xh>=xf+24*r) and(xh<=xf+26*r)) then
                if(yh<=(yf+12*r)) then
                 if pl_num=2 then
						begin
                                pos:=0;
                                exit
                        end
                 else
                        begin
                                pos:=(-1);
                                exit
                        end
         else
                if pl_num=2 then
         begin
         pos:=25;
         exit
         end
        else
         begin
         pos:=(-1);
         exit
         end
 else
        if (yh>=(yf+12*r)) then
         pos:=round((xh-xf+r)/(2*r))
        else
         pos:=24-round((xh-xf+r)/(2*r))+1;

        if pl_num=2 then
         pos:=translate(pos)
end;


{----------------------------------------------------}


Function EndOfGame:boolean;
begin
 endofgame:=false;
 if plf[1,25]=20 then
 begin
         outmessage(congrat+'ч(r)pнi');
		 endofgame:=true
 end
        else
         if plf[2,25]=20 then
         begin
                 outmessage(congrat+' бiлi');
                 endofgame:=true
         end;
end;


{-------------------------------------------------------}

function get(pl_num,ind:byte):shortint;
begin
if pl_num=1 then
get:=plf[1,ind];
if pl_num=2 then
get:=plf[2,ind]
end;




Procedure ArrCoo_GCoo(Pl_Num,Pos:Byte;Var Xgg,Ygg:word);
begin
 if (pl_num=2) and (pos<>0)and(pos<>25) then
 pos:=translate(pos)

        else
        begin


        if (pl_num=2) then
        begin

         if pos=0 then
                ygg:=yf+r
         else
                ygg:=yf+23*r;

         xgg:=xf+25*r

        end


        else
        begin
         if pos=0 then
                ygg:=yf+23*r

         else
                ygg:=yf+r;

         xgg:=xf-r
        end;
        end;

  if ((pos>=1)and (pos<=12)) then
         begin
	ygg:=yf+23*r;
    xgg:=xf+r+2*r*(pos-1)
   end;

        if ((pos>12) and (pos<=24)) then
   begin
    ygg:=yf+r;
    xgg:=xf+23*r-2*r*(pos-13)
   end;
xgg:=xgg+cn;ygg:=ygg+cn
end;{ARR COO_G COO}

function possibility (bpos,epos:byte):boolean;
begin
 possibility:=(((epos-bpos)=pch[1]) or
               ((epos-bpos)=pch[2]) or
               ((epos-bpos)=pch[1]+pch[2]))
end;

function TotalPossibility (pl_num:byte):boolean;
Var
 ix,k:byte;
begin
 TotalPossibility:=false;
for k:=1 to 2 do
 for ix:=0 to 24 do
 begin
        if Plf[pl_num,ix]>0then
        begin
         if (ix+pch[k]<=25) and (pch[k]<>0) then
                if Plf[pl_num,ix+pch[ix]]>=0 then
                        begin
                                TotalPossibility:=true;
                                Exit
                        end;
        end;
 end;
for ix:=0 to 24 do
 if (ix+pch[1]+pch[2])<=25 then
        if Plf[pl_num,(ix+pch[1]+pch[2])]>=0 then
				begin
                 TotalPossibility:=true;
                 Exit
                end;
end;



procedure error3(var err:shortint);
begin
 outmessage('Ви не м(r)жете п(r)х(r)дити бi"ьше  б(r) менше нiж вип "(r) н  кубик х');
 err:=(-3);
end;



procedure error4(var err:shortint);
begin
 outmessage('Не м(r)жн  з крив ти 12 п(r)зицi(c) пiдряд');
 err:=(-4);
end;



procedure error5(var err:shortint);
begin
 outmessage(' м чуж  фiшк ');
 err:=(-3);
end;

{================================FISHKA==============================}
Procedure fishka.draw;
var
 x,y:word;
 Begin
  ArrCoo_GCoo(Color,Position,x,y);
        setcolor(Colors[Color]);
  circle(x,y,r);
  filling(x,y,Colors[Color]);
  setcolor(bkcol);
  circle(x,y,r);
  circle(x,y,r-round(r/5));
  filling(x,y+r-1,bkcol);
        setcolor(black);
        circle(x,y,r)
 end;






procedure fishka.show(col,pos:integer);
var
 quant:byte;
 x,y:word;
 temp:string[2];
begin
 quant:=Plf[col,pos];
 if quant=0 then
		 fishka.hide(Colors[col],pos)
 else
 begin
  fishka.draw (Col);
 if quant>1 then
 begin
  str(quant,temp);
  ArrCoo_GCoo(col,pos,x,y);
  if col=1 then col:=2
  else col:=1;
  setcolor(col);
  settextjustify(centertext,centertext);
  OutTextXY(x,y,temp);
  settextjustify(bottomtext,righttext);

 end

 end

end;


procedure fishka.hide;
var
 x,y:word;
begin
 ArrCoo_GCoo(col,pos,x,y);
 if getpixel(x,y-r-1)=lightgray then
        fishka.circ(x,y,getpixel(x,y+r+1))
 else
        fishka.circ(x,y,getpixel(x,y-r-1))
end;

procedure fishka.circ;
begin
 setcolor(col);
 circle(x,y,r);
 filling(x,y,col)
end;

{--------------------------------------------------------------}

Function Fishka.Check(Color,Posit:Byte;Var Error:ShortInt):Boolean;
Begin
        Check:=False;
        if PlF[Color,Posit]<0 then
                Error1(Error)
        Else
                If PlF[Color,Posit]=0 then
                        Error2(Error)
                Else
                        Check:=True;
End;{Fishka.Check}


{--------------------------------------------------------------}




procedure fishka.select(col,pos:byte;var error:shortint);
begin
 error:=1;
 if not(somsselect) then
        If Check(Col,Pos,Error)Then
         begin
                fishka.hide(col,pos);
                bkcol:=green;
                fishka.show(col,pos);
                bkcol:=lightgray;
                somsselect:=true;
                selectpos:=pos
         end;
end;

procedure Fishka.change(pl_num,pos:byte;quont:shortint ;var err:shortint);
begin
	if get(pl_num,pos)>=0 then
		begin
			fishka.hide(pl_num,pos);
			Inc(Plf[pl_num,pos],quont);
			Dec(Plf[Pl_Num,translate(pos)],quont);
			Fishka.show(pl_num,pos)
		end
	else
		error5(err)
end;



procedure fishka.move;
var
i:shortint;
begin
errcode:=1;
if not(totalpossibility(n_pl)) then
 outmessage ('" в с нем  х(r)ду')
else
if not(somsselect) then
 begin
		fishka.select(n_pl,potpos,errcode);
        if errcode<0 then
         begin

                Exit;
         end;
        exit
 end;
if somsselect then
if potpos=selectpos then
 begin
        somsselect:=false;
        fishka.show(n_pl,potpos);
        exit
 end;
 if VirtualChekTwelwe(n_pl,selectpos,potpos) then
        if possibility (selectpos,potpos) then
        begin
        fishka.change(n_pl,selectpos,(-1),errcode);
        if errcode<0 then
		 begin

                exit
         end;
        fishka.change(n_pl,potpos,1,errcode);
                if errcode<0 then
         begin
         fishka.change(n_pl,selectpos,(-1),errcode);

                exit
         end;


        sound(300);
        delay(80);
        nosound;






        if (potpos-selectpos)=(pch[1]+pch[2]) then

        for i:=1 to 2 do
        begin
         pch[i]:=0 ;
         kub[i].clr;
        end;

        for i:=1 to 2 do
        if (potpos-selectpos)=pch[i] then
        begin
         pch[i]:=0;
         kub[i].clr;
         break
        end;
        if (pch[1]+pch[2])=0 then
        movemaked:=true
         else
         begin
         somsselect:=false;

         exit
         end
 end
 else
        error3(errcode)
else
 error4(errcode);
if errcode<0 then
 Begin
                Exit
 end
end;

{==END===================FISHKA==========================END==}
{=======================procedures==main======================}






procedure formkubs (xk,yk,k,ck:word);
begin
 desk (xk-ck-round(k/10),yk-ck-round(k/10),xk+2*k+round(k/10)+ck*2,yk+ck+round(k/10)+k,ck);
 kub[1].draw (xk,yk,k);
 kub[2].draw (xk+k+round(k/10),yk,k);
end;{FORMKUBS}



procedure formfild (xp,yp,c,n:integer;var ra:integer);
var
i,diam,a,radius,x,y,f1,f2,col:byte;

begin
diam:=round(int(n/12));
radius:=round(diam/2);
ra:=radius;
x:=xp+c;
y:=yp+c;
f1:=round(y+5*diam);
f2:=f1+2*diam;
desk(xp-10-radius-cn*2,yp-1-2*radius,xp+n+2*c+radius*2+cn*2,yp+n+(c+radius)*2+1,c);
setcolor(magenta);
line(x,y+radius,x,n-radius+y);
line(x+n,y+radius,x+n,n-radius+y);

for i:=0 to 11 do
begin
arc (radius+diam*i+x,y+radius,360,540,radius);
arc (radius+diam*i+x,y+n-radius,180,360,radius);
end;
filling(x+radius,y+2*radius,magenta);
a:=1;
for i:=0 to 11 do
begin

setcolor(a);
arc(radius+diam*i+x,y+radius,360,540,radius);
line(x+diam*i,y+radius,x+radius+diam*i,f1);
line(x+diam*(i+1),y+radius,x+radius+diam*i,f1);
filling(x+radius+diam*i,y+radius,a);



if a=1 then a:=12
else a:=1;


setcolor(a);
arc(radius+diam*i+x,y+n-radius,180,360,radius);
line(x+diam*i,y+n-radius,x+radius+diam*i,f2);
line(x+diam*(i+1),y+n-radius,x+radius+diam*i,f2);
filling(x+radius+diam*i,y+n-radius,a);



end;

end;














procedure INSTALL;
var
i:byte;
begin
{	If Restart Then
		Restart:=false
	Else
		Begin
			randomize;
			If RegisterBGIDriver(@VgaDrv)<0 then
						begin
								writeln('Помилка  при реестрацii драйвера ');
								halt
						end;
					End;      }
		   d:=detect;

				initgraph (d,m,'c:\programs\tp7\bgi\');
		clearviewport;

		setfillstyle(8,2);
 floodfill(1,1,6);

formfild (xf,yf,cf,n,r);
 fhk.bkcol:=lightgray;
plf[1,0]:=20;
plf[2,0]:=20;
somsselect:=false;
CanIMessage:=True;
settextjustify(bottomtext,righttext);

for i:=1 to high(butt) do
begin
 desk(xbutt,ybutt+(dybutt+3*cbutt)*i,xbutt+dxbutt,ybutt+(dybutt+3*cbutt)*i+dybutt,cbutt);
 setcolor(black);
 outtextXY(xbutt+cbutt*2,ybutt+(dybutt+3*cbutt)*i+cbutt*2,butt[i]);
end;

 desk (xm,ym,xm+dxm,ym+dym,cm);
for i:=1 to 25 do
 begin
 plf[1,i]:=0;
 plf[2,i]:=0
 end;

desk(xp,yp,xp+dxp,yp+dyp,5);




fhk.show(1,0);
fhk.show(2,0);
formkubs (xk,yk,k,ck);
Chouser.Show(green,0);

end;

Procedure compplay;
begin
compplayer:=true;
restart:=true;
end;

procedure MakeMove(n_pl:byte);
var i:byte;
begin
if n_pl=1 then
txt:='бў"ў'
else
txt:='ч(r)рнў';
print ('Х(r)дять '+txt);
repeat
for i:=1 to 2 do
begin
delay(421);
kub[i].peach(pch[i]);
end;
 dubl:=false;
if pch[1]=pch[2] then
 dubl:=true;

movemaked:=false;
somsselect:=false;
{ if compplayer and (n_pl=2) then compmove
else                                      }
begin
repeat

 gettime(hour,min,sec,tsec) ;
 if((tsec>changetsec+100)  or (sec>changesec)) then
 MsgClr;
 gcoo_arrcoo(n_pl,Chouser.xg,Chouser.yg,potpos);
case readkey of
#27:halt ;
#32:fhk.move(n_pl,t);
#0:case readkey of
		 #72:Chouser.up ;
		 #80:Chouser.down;
		 #75:Chouser.left ;
		 #77:Chouser.right;
		 #61:compplay;
		 #62:restart:=true;
		 else
   end;
else;
end;

if endofgame then halt;
if not(totalpossibility(n_pl)) then movemaked:=true;
if restart then exit;
until  movemaked;
end;
until  not(dubl) ;

end;

{============================MAIN===================================}
begin

start:install;

repeat

  makemove(1)   ;
 if restart then goto start;
 makemove(2);
 if restart then goto start;

until endofgame
end.
