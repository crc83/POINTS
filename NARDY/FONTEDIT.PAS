{$X+}
{+----------------------------------------------+
 |    ������� ������� ���⮢ �ଠ� CHR    |
 +----------------------------------------------+
}
Uses CRT,Graph,F_GrText,F_Mouse,F_Anti;
{
  �������� ��।������
}
type
  TChar4 = array [1..4] of Char;
  TFontHead = record            {������� ��������� ����}
  case Byte of
  0:(FontFileID: TChar4);
  1:(B: array [1..128] of byte);
  end;
  TFontPara = record            {���� ��ࠬ��஢ ����}
  case Byte of
  0:(
    ParPrefix : Char;  		{������ "+"}
    CharsCount: Word;  		{������⢮ ᨬ����� � ����}
    Reserv1   : Byte;  		{�� �ᯮ������}
    FirstChar : Byte;  		{��� ��ࢮ�� ᨬ����}
    DataOffset: Word;  		{���饭�� �� ������� ������ ��ࢮ�� ᨬ����}
    FillFlag   : Byte; 		{���� �������}
    UpperMargin: Byte; 		{���� ᨬ�����}
    Reserv2    : Byte; 		{�� �ᯮ������}
    LowerMargin: ShortInt; 	{������ �஬��}
    Reserv3 : array [1..5] of Byte;);
  1:(H2: array [1..16] of Byte)
  end;
  TOffst = array [0..255] of Word;   	{���饭��}
  TWidth = array [0..255] of Byte;   	{��ਭ�}
  TChars = array [0..255] of Pointer;	{�����}
  TLengD = array [0..255] of Word;   	{�����}
  AW = array [1..255] of Word;
  TCooE = record            	        {������ ࠡ�祣� ����}
    X1,Y1,X2,Y2: Integer;
  end;
  TMouseMask = array [0..1,0..15] of Word;
var
  FontHead: TFontHead; 	{��������� 䠩��}
  HeaderSize: Word;    	{���饭�� ����� ��ࠬ��஢}
  FontPara: TFontPara; 	{��ࠬ���� ����}
  FileSize: Word;   	{����� ����㦠���� ��� 䠩��}
  AFileSize: Byte;  	{��������� FileSize}
  Offsets : TOffst; 	{������ ᬥ饭��}
  Widths  : TWidth; 	{������ �ਭ}
  Chars   : TChars; 	{�����⥫� �� �����}
  LengD   : TLengD; 	{����� ������ � �����}
  F       : File;   	{CHR-䠩�}
  FName   : String; 	{��� 䠩��}
  MaxW    : Byte;   	{���ᨬ��쭠� �ਭ� ᨬ����}
  MaxH    : Byte;   	{������ ���� ᨬ����}
  {------------ ����祥 ���� ------------}
  XE      : Integer;	{���� ���孨� 㣮� WE}
  YE      : Integer;
  XE2     : Integer;	{�ࠢ� ������ 㣮� WE}
  YE2     : Integer;
  YB      : Integer;	{�न��� ������� �����}
  WidthX  : Integer;	{�ࠢ�� �࠭�� ᨬ����}
  DXE     : Integer;	{��ਭ� ���⪨ WE}
  DYE     : Integer;	{���� ���⪨ WE}
  NVecE   : Word;   	{������⢮ ����஢ � WE}
  VecE: array [1..250] of TCooE; 	{������ � WE}
  {------------- ���� ����� -------------}
  XR,YR: Integer;   	                {���न���� ���� �����}
  WR: Pointer;      	                {��ࠧ ���⮣� ���� �����}
  {---------- ������ ᨬ����� ------------}
  XT  : Integer;		        {���� ���孨� 㣮� ⠡���� ᨬ�����}
  YT  : Integer;
  DXT : Integer;		        {��ਭ� ���⪨ ⠡���� ᨬ�����}
  DYT : Integer;		        {���� ���⪨}
  {---------------- ���� ------------------}
  dXm,dYm : Integer;	                {�࠭��� ��� � ࠡ�祬 ����}
  CurM: TMouseMask; 	                {�⠭���⭠� ��᪠ 㪠��⥫�}
  CurE: TMouseMask; 	                {��᪠ � ࠡ�祬 ����}
  MouseF  : Boolean;	                {���� ��� 㪠��⥫� ���}
const
  ChangeF: Boolean = False; 	        {���� ��������� ����}
  Head: TChar4 = ('P','K',#8,#8);

PROCEDURE OutChar(X0,Y0: Integer; C: Byte; DX,DY: Real);
  {�뢮��� ᨬ��� � � ������ X,Y � ����⠡�� DX,DY}
var
  PW:^AW;
  k: Integer;
  x,y: Integer;
Procedure Vector(W: Word);
  {����� ��।��� ����� ᨬ����}
var
  xx,yy: Integer;
  op: Word;
begin
  {�뤥�塞 ��� ����樨}
  op := W and $8080;
  if op=0 then
    Exit;
  W := W xor op;
  {�뤥�塞 ���न����}
  yy := W shr 8;
  xx := W and $FF;
  if xx>63 then
    xx := xx-128;
  if yy>63 then
    yy := yy-128;
  {���砥� ���न���� ��ன �窨}
  xx := X0+Round(xx*DX);
  yy := Y0-Round(yy*DY);
  {�믮��塞 ������}
  if op=$8080 then
    Line(X,Y,XX,YY);
  X := XX;
  Y := YY
end;  {Vector}
{---------}
BEGIN  {OutChar}
  if LengD[C]=0 then
    Exit;               {������㥬 �뢮� �� ��।������� ᨬ�����}
  Y0 := Y0-DYT div 4;
  X := X0;        	{��窠 ����� ���न���}
  Y := Y0;
  PW := Chars[C]; 	{����⥫� ᨬ����}
  {����稢��� ᨬ���}
  for k := 1 to LengD[C] div 2 do
    Vector(PW^[k])
END;  {OutCharXY}
{-------------------}
PROCEDURE ClearWinEd;
  {��頥� ࠡ�祥 ����}
var
  X,Y: Integer;
BEGIN
 SetViewPort(XE-dXm,YE-dYm,XE2+dXm,YE2+dYm,True);
 ClearViewPort;
 SetViewPort(0,0,GetMaxX,GetMaxY,True);
 {�뢮��� ���⨪���}
  for X := 0 to MaxW do  			
    for Y := 0 to MaxH do
      PutPixel(XE+X*DXE,YE+Y*DYE,White);
  {�뢮��� ������� �����}
  SetColor(Cyan);
  YB := YE+succ(FontPara.UpperMargin)*DYE;
  Line(XE,YB,XE2,YB);
  {�뢮��� 㪠��⥫� �࠭��� ᨬ����}
  WidthX := XE;
  Line(XE,YE,XE,YE2);
  {������� ࠬ���}
  SetColor(White);
  Rectangle(XE-dXm,YE-dYm,XE2+dXm,YE2+dYm)
END;  {ClearWE}
{-------------------}
PROCEDURE Init;
  {����訢��� � ������ ��� CHR-䠩��,������ ����� �� 
   䠩��,���樨��� ��䨪� � ᮧ���� ��࠭}


Procedure FontRead(var Dest; Size: Word);
  {��⠥� �� 䠩�� F � ��६����� Dest Size���� � ����஫���� १����.
   �� �訡�� ���਩�� �����蠥� �ணࠬ��}
var
  k: Word;
begin
  BlockRead(F,Dest,Size,k);
  if k=Size then
    Exit;
  WriteLn('�訡�� �� �⥭�� ������ �� 䠩��!');
  Halt
end;  {FontRead}
{--------}
Procedure NameInput(var FName: String);
  {������ � �஢���� ��� CHR-䠩��}
label
  Loop,HeadErr;
var
  k: Byte;
begin
  Write('�ணࠬ�� ।���஢���� ������� BGI-���⮢ �ଠ� CHR. ');
  WriteLn('(C) 1993 �.�.��஭��');
  {�஢��塞 ��ࠬ���� ���饭��}
  if ParamCount<>0 then
    FName := ParamStr(1)
  else
    FName := '';
  if FName='' then
    begin
Loop:  {� ������ �� �訡�� � �����}
      Write('������ ��� CHR-䠩�� (*.CHR): ');
      ReadLn(FName);
      if FName = '' then
        begin  				{���⮩ ����}
          Write('C������ ���� ���� (Y/N)? ');
          ReadLn(FName);
          if (FName='') or
             (UpCase(FName[1])<>'Y') then
            Halt;
          FName := '';
          Exit
        end
    end;
  {�஢��塞 ����⢮����� 䠩��}
  if Pos('.',FName)=0 then
    FName := FName+'.CHR';
  {$I-}  		{�⪫�砥� ����஫� IOError}
  Assign(F,FName);
  Reset(F,1);       	{��⠥��� ������ 䠩�}
  {$I+}  		{����⠭�������� ����஫� IOError}
  if IOResult<>0 then
    begin
      WriteLn('���� '+FName+' �� ������');
      Goto Loop
    end;
  {��⠥� ��������� 䠩��}
  FontRead(FontHead,SizeOf(FontHead));
  if FontHead.FontFileID<>Head then
    begin
      WriteLn('�訡�� � ��������� 䠩��!');
      Goto Loop
    end;
  {�饬 ᬥ饭�� ����� ��ࠬ��஢ � ����� 䠩��}
  with FontHead do
    begin
      k := 5;  {��稭��� � ��⮣� ����}
      while (k<SizeOf(FontHead)) and(B[k]<>$1A) do inc(k);
      if B[k]=$1A then
        begin
          HeaderSize := B[k+1]+B[k+2] shl 8;
          FileSize   := B[k+7]+B[k+8] shl 8;
          AFileSize := k+7;
          {��⠥� ���� ��ࠬ��஢}
          Seek(F,HeaderSize);
          FontRead(FontPara,SizeOf(FontPara));
          if FontPara.ParPrefix='+' then
            Exit  		{��ଠ��� ��室}
          else    		{��� ��䨪� ��ࠬ��஢}
            Goto HeadErr
        end
    end;
  {�� ������ �ନ���� CopyrightEnd}
HeadErr:
  Close(F);
  WriteLn('�訡�� � ��������� 䠩��!');
  Goto Loop
end;  {NameInput}

Procedure ReadData;
  {��⠥� ����� �� 䠩��}
var
  k: Integer;
  LastChar: Byte;
begin
  with FontPara do
    begin
      LastChar := FirstChar+CharsCount-1;
      {������塞 ⠡���� ᬥ饭��}
      for k := 0 to 255 do
        if k in [FirstChar..LastChar] then
          FontRead(Offsets[k],2)
        else
          Offsets[k] := 0;
      {������塞 ⠡���� �ਭ}
      MaxW := 0;
      for k := 0 to 255 do
        if k in [FirstChar..LastChar] then
          begin
            FontRead(Widths[k],1);
            if Widths[k]>MaxW then
              MaxW := Widths[k]
          end
        else
          Widths[k] := 0;
      if MaxW<20 then
        MaxW := 20;
      {��⮢�� ������ � ���뢠�� �����}
      for k := 0 to 255 do
        LengD[k] := 0;  {����塞 ⠡���� ����}
      for k := FirstChar to LastChar do
        begin
          if k=LastChar then
          LengD[k] := FileSize-Offsets[k]-FontPara.DataOffset
          else
            LengD[k] := Offsets[k+1]-Offsets[k];
          if LengD[k]<>0 then
            begin
              GetMem(Chars[k],LengD[k]);
              FontRead(Chars[k]^,LengD[k])
            end
        end;
      Close(F);
    end;  {with FontData}
end;  {ReadData}
{--------}
Procedure BuildScreen;
  {��ॢ���� ��ᯫ�� � ����᪨� ०��,
   ������ ����⠭�� � ᮧ���� ��࠭}

Procedure PutCur(var Cur: TMouseMask);
  {�������� ����ࠦ���� � ����� ���孥� 㣫�
   ��࠭� � �ନ��� ���� 㪠��⥫� ���}
var
  x,y: Byte;
  b: Word;
begin
  for y := 0 to 15 do
    begin
      b := 0;
      for x := 0 to 15 do
        if GetPixel(x,y)<>GetBkColor then
           b := b or ($8000 shr x);
      Cur[1,y] := b;
      Cur[0,y] := not b
    end
end;   {PutCur}
{---------}
var
  D,R,E,k,n,X,Y: Integer;
  c: Byte;
  S: String;
  Sz: Word;
  FF: File;
  Font: Pointer;
const
  Txt: array [1..6] of String[10]=(
    '�� ⠡����',
    '� ⠡����',
    '������',
    '��ࠧ��',
    '���࠭���',
    '�����');
  Items: array [1..6] of MouseItemType=(
    (X1:1; Y1:1; X2:13; Y2:2; Butt: LeftButton; Key:1 shl 8),
    (X1:14; Y1:1; X2:25; Y2:2;Butt: LeftButton; Key:2 shl 8),
    (X1:26; Y1:1; X2:37; Y2:2;Butt: LeftButton; Key:3 shl 8),
    (X1:38; Y1:1; X2:49; Y2:2;Butt: LeftButton; Key:4 shl 8),
    (X1:50; Y1:1; X2:61; Y2:2;Butt: LeftButton; Key:5 shl 8),
    (X1:61; Y1:1; X2:80; Y2:2;Butt: LeftButton; Key:6 shl 8));
begin {BuildScreen}
  {���室�� � ��䨪�}
  D := Detect;        		{��⮮�।������ �ࠩ���}
  InitGraph(D,R,'');  		{���樨�㥬 ��䨪�}
  E := GraphResult;   		{�஢��塞 १����}
  if E<>0 then
    begin             		{���� �訡��}
      WriteLn(GraphErrorMsg(E));
      Halt
    end;
  {�롨ࠥ� ���� � ����ᨬ��� �� ࠧ�襭�� ��࠭�}
(*  case GetMaxY of
    199: c := 8;  		{CGA 8x8}
    349: c := 14; 		{EGA 8x14}
    479..1024: c := 19; 	{VGA,SVGA 8x19}
  else
*)	 c := 8   		{��稥 8x8}
(*
 end;
*)
 ; with FontPara do
    MaxH := UpperMargin-LowerMargin+1;
  {��।��塞 �࠭��� ࠡ�祣� ����}
  DYE := succ(GetMaxY) div (5*MaxH div 4);  {���� ���⪨}
  DXE := succ(GetMaxX) div (2*MaxW); 	{��ਭ� ���⪨}
  XE  := DXE div 3;    			{���饭�� ᫥��}
  YE  := 2*c;          			{���饭�� ᢥ���}
  XE2 := XE+MaxW*DXE;    		{�ࠢ� ������ 㣮�}
  YE2 := YE+MaxH*DYE;


  {��।��塞 ࠧ���� 㪠��⥫� ���
   � ࠡ�祬 ���� � �ନ�㥬 ��� ��᪨}
  dXm := XE;
  dYm := DYE div 3;
  {�஢��塞 ����稥 ���}
  if not InitMouse then
    begin   			{��� ��� - �����蠥� ࠡ���}
      CloseGraph;
      WriteLn('��� ��� - �ணࠬ�� �� ����� ࠡ����');
      Halt
    end;
  {��⮢�� �⠭����� 㪠��⥫�}
  ShowMouse;
  MouseGotoXY(0,0);  		{� ���� ���孨� 㣮�}
  PutCur(CurM);      		{������� ��ࠧ}
  HideMouse;
  {�����⥫�-�����⨪ ��� ࠡ�祣� ����}
  Rectangle(0,0,2*dXm,2*dYm);
  PutCur(CurE);      		{������� ��ࠧ}
  {�����稢��� ࠡ�祥 ����}
  ClearWinEd;
  {��⮢�� ���न���� ���� ����७�� ᨬ����}
  XR :=(XE2-XE) div 2;
  YR := GetMaxY-MaxH;
  sz := ImageSize(XR,YR,XR+MaxW,YR+MaxH);
  GetMem(WR,sz);
  GetImage(XR,YR,XR+MaxW,YR+MaxH,WR^);
  {������� ⠡���� ᨬ�����}
  XT := XE+(MaxW+1)*DXE; 	{���� ���孨�}
  YT := YE;			{㣮� ⠡���� ᨬ�����}
  DXT := GetMaxX div 32;  	{��� �� ��ਧ����}
  DYT := GetMaxY div 20;  	{��� �� ���⨪���}
  SetColor(White);        	{���� 梥�}
  for n := 0 to 255 do    	{�뢮��� ᨬ����}
  with FontPara do
    begin
      X := XT+(n mod 16)*DXT;
      Y := YT+(n div 16)*DYT;
      if LengD[n]<>0 then
	begin
	  SetColor(White);
	  OutChar(X,Y+DYT,n,DXT/MaxW,DYT/(MaxH+5))
	end
      else
	begin  			{�뢮��� �������騥 ᨬ����}
	  SetColor(DarkGray);
	  OutTextXY(X,Y+DYT-8,chr(n))
        end
    end;
  {����㦠�� ���� �� 䠩�� 8xH.fnt}
  Str(c,S);
  S := '8x'+S+'.fnt';
  Assign(FF,S);
  {$I-}
  Reset(FF,1);
  {$I+}
  if IOResult<>0 then
    begin
      CloseGraph;
      WriteLn('��� ���⮢��� 䠩�� '+S);
      Halt
    end;
  Sz := System.FileSize(FF);
  GetMem(Font,Sz);
  BlockRead(FF,Font^,Sz,r);
  Close(FF);
  if r<>Sz then
    begin
      CloseGraph;
      WriteLn('�訡�� �⥭�� 䠩�� '+S);
      Halt
    end;
 {��������㥬 ���� � ��७����砥� ����/�뢮�}
  SetFont(Font,8,c);
  GraphWriteOn;
  {�뢮��� ��ப� ����}
  Colors(Black,LightGray);
  for k := 1 to 6 do with Items[k] do
    begin
    SetWindow(X1,Y1,X2,Y2-1,EmptyBorder,
              Txt[k],False,False,False);
    end;
  {���樨�㥬 ����}
  SetMouseItem(6,Items);
  ShowMouse;  		{�����뢠�� 㪠��⥫� ���}
  TextRatioY := c;
end;  {BuildScreen}
{--------}
Procedure NewFile(var FName: String);
  {������� ���� CHR-䠩�}
var
  Name: String;
  HH: ShortInt;
  H,k: Byte;
  Y: String[1];
const
  t1='���ᨬ��쭠� ���� ᨬ����� �� ������� �����: ';
  t2='�����ﭨ� �� ������ �஬�� ᨬ����: ';
  t3='���ᨬ��쭠� �ਭ�: ';
  t4='    font V1.1 Jan 12, 1989';
  t5=#13#10;
  t6='Copyright (c) 1987,1988 Borland International';
begin
  {������ � ������� ��ࠬ���� ����}
  repeat
    Write('������ 4-�㪢����� ��� ����: ':55);
    ReadLn(Name);
    while Length(Name)<4 do
      Name := Name+'0';
    Name[0] := chr(4);
    for k := 1 to 4 do
      Name[k] := UpCase(Name[k]);
    Write(t1:55);
    ReadLn(H);
    H := H and 63;
    Write(t2:55);
    ReadLn(HH);
    if HH>0 then
      HH := -HH;
    Write(t3:55);
    ReadLn(MaxW);
    MaxW := MaxW and 63;
    MaxH := H-HH;
    WriteLn;
    WriteLn('�㤥� ᮧ��� ���� � ������ '+
            Name+' � ᫥���騬� ��ࠬ��ࠬ�:');
    WriteLn(t1:55,H);
    WriteLn(t2:55,HH);
    WriteLn(t3:55,MaxW);
    Write('������� (Y/N, 㬫�.Y)? ');
    ReadLn(Y);
  until (Y<>'') or (UpCase(Y[1])<>'N');
  {��⮢�� ���������}
  for k := 1 to 128 do
    FontHead.B[k] := 0;
  for k := 1 to 16 do
    FontPara.H2[k] := 0;
  FName := Name+'.CHR';
  with FontHead do
    begin
      FontFileID := Head;
      Name := 'BGI '+Name+t4+t5+t6+t5+#0;
      for k := 1 to Length(Name) do
        B[k+4] := ord(Name[k]);
      AFileSize := k+12;
      Name := #$80#0+FName;
      Name[0] := #$1A;  			{CopyrightEnd}
      Name[7] := #0;    			{Lo[FileSize]}
      Name[8] := #0;    			{Hi[FileSize]}
      Name[9] := #1;    			{V1.}
      Name[10] := #0;
      Name[11] := #1;    			{V.1}
      for k := 0 to 11 do
        B[AFileSize-7+k] := ord(Name[k]);
    end;
  {��⮢�� ���� ��ࠬ��஢}
  with FontPara do
    begin
      ParPrefix := '+';
      CharsCount := 0;
      FirstChar := 0;
      DataOffset := 16;
      FillFlag := 0;
      UpperMargin := H;
      LowerMargin := HH
    end;
  {��⮢�� ⠡���� ����}
  for k := 0 to 255 do
    LengD[k] := 0;
  Assign(F,FName)
end;
{---------}
BEGIN  {Init}
  repeat
    NameInput(FName);  	{������ � ����஫��㥬 ��� 䠩��}
    if FName<>'' then
      ReadData        	{��⠥� ����� �� 䠩��}
    else
      NewFile(FName)   	{������� ���� 䠩�}
  until FName<>'';
  BuildScreen {������� ��࠭}
END;  {Init}
{-------------------}
PROCEDURE SaveFont;
  {���࠭�� ���� � 䠩��}
Procedure Alarm;
  {����頥� �� �訡�� �����}
var
  X2,Y2,X1,Y1: Integer;
  Sz: Word;
  P: Pointer;
  C: Char;
begin
  HideMouse;
  Colors(White,Red);
  Window(15,12,65,14);
  GetWindGraphCoo(X1,Y1,X2,Y2);
  Sz := ImageSize(X1,Y1,X2,Y2);
  GetImage(X1,Y1,X2,Y2,P^);
  SetWindow(15,12,65,14,2,' ������ ���� ������� ',True,True,True);
  Write('�訡�� ����㯠 � 䠩��!':37);
  ShowMouse;
  while not KeyPressed or not MousePressed do;
  while KeyPressed do
    C := ReadKey;
  While MousePressed do;
  HideMouse;
  PutImage(X1,Y1,P^,NormalPut);
  ShowMouse;
  FreeMem(P,Sz)
end;  {Alarm}
{---------}
Function WriteFile(var Source; S: Word): Boolean;
  {�����뢠�� � 䠩� S ���� �� ��६�����
   Source � ����஫���� १����}
var
  k: Word;
begin
  BlockWrite(F,Source,S,k);
  WriteFile := S=k;
  if S<>k then
    Alarm
end;
{---------}
var
  k: Integer;
  MinChr,MaxChr: Byte;
  W,Offs,PredO: Word;
BEGIN
  if not ChangeF then
    Exit;
  {��।��塞 ��砫�� ᨬ���}
  MinChr := 0;
  while (MinChr<255) and (LengD[MinChr]=0) do
    inc(MinChr);
  if MinChr=255 then
    Exit;
  {��।��塞 ��᫥���� ᨬ�����}
  MaxChr := MinChr;
  k := MaxChr;
  while k<=255 do
    begin
      if LengD[k]<>0 then
        MaxChr := k;
      inc(k)
    end;
  {���४��㥬 ����� ᨬ���� � ������뢠��
   ����� ����㦠���� ���}
  FileSize := 0;
  for k := MinChr to MaxChr do
    if LengD[k]=0 then
      begin  {���⮩ ᨬ���}
        Widths[k] := Widths[MinChr];
        inc(FileSize,LengD[MinChr])
      end
    else
      inc(FileSize,LengD[k]);
  {��।��塞 ᬥ饭�� � 䠩��}
  Offs := 3*(MaxChr-MinChr+1)+16;
  {���४��㥬 ����⥫� ����}
  with FontPara do
    begin
      FirstChar := MinChr;
      CharsCount:= MaxChr-MinChr+1;
      DataOffset:= Offs;
      FileSize := FileSize+16+3*CharsCount
    end;
  {�����뢠�� ���������}
  With FontHead do
    begin
      B[AFileSize] := Lo(FileSize);
      B[AFileSize+1] := Hi(FileSize)
    end;
  {��⮢�� 䠩�}
  {$I-}
  Rewrite(F,1);
  {$I+}
  if IOResult<>0 then
    begin
      Alarm;
      Exit
    end;
  if not WriteFile(FontHead,SizeOf(FontHead))
    then Exit;
  {�����뢠�� ����⥫�}
  if not WriteFile(FontPara,SizeOf(FontPara))
    then Exit;
  {�����뢠�� ⠡���� ᬥ饭��}
  PredO := Offs;
  for k := MinChr to MaxChr do
    begin
      W := Offs-PredO;
      if LengD[k]<>0 then
        inc(Offs,LengD[k])
      else
        inc(Offs,LengD[MinChr]);
      if not WriteFile(W,2) then
        Exit
    end;
  {�����뢠�� ⠡���� �ਭ}
  for k := MinChr to MaxChr do
    if not WriteFile(Widths[k],1) then
      Exit;
  {�����뢠�� �����}
  for k := MinChr to MaxChr do
    if LengD[k]<>0 then
      if not WriteFile(Chars[k]^,LengD[k]) then
        Exit
      else
    else
      if not WriteFile(Chars[k]^,LengD[MinChr])then Exit;
  Close(F);   {�� � ���浪�}
  ChangeF := False
END;  {SaveFont}
{-------------------}
PROCEDURE Run;
  {�᭮���� ࠡ��: �⥭�� ��� ��� ����������
   � �맮� �㦭�� ��楤��}
var
  BM,XM,YM,B,X,Y: Integer;
  x0g,y0g,x1g,y1g: Integer; 	{���न���� १������ ���}
  MPF: Boolean;   		{���� १������ ���}
  PW:^AW;
  W,op: Word;
Procedure RepChar;
  {������� ᨬ��� � ���� �����}
var
  k: Word;
begin
  {��ࠥ� ��஥ ����ࠦ����}
  PutImage(XR,YR,WR^,NormalPut);
  {��ନ�㥬 �����}
  SetWriteMode(NormalPut);
  SetColor(White);
  for k := 1 to NVecE do
    with VecE[k],FontPara do
      Line(XR+X1 div DXE,YR+MaxH+LowerMargin-
          (YB-Y1) div DYE,XR+X2 div DXE,
          YR+MaxH+LowerMargin-(YB-Y2) div DYE);
end;
{---------}
Function Tabl(var N: Byte): Boolean;
  {�롨ࠥ� ᨬ��� �� ⠡����. �����頥�
   ����� ᨬ���� ��� False ��� �ࠢ�� ������}
var
  X,Y,k,xx,yy,ddx,ddy: Integer;
  NX,NY,NXX,NYY: Byte;
  Sz: Word;
  P: Pointer;
begin
  HideMouse;
  ddx := DXT div 2; 		{�������� �ਭ�}
  ddy := DYT div 2; 		{�������� �����}
  X := XT+ddx;      		{��砫�� ᨬ���}
  Y := YT+ddy;
  NX := 0;          		{����� �⮫��}
  NY := 0;          		{����� ��ப�}
  MouseGotoXY(X,Y);
  MouseWindow(X,Y,X+16*DXT,Y+16*DYT);
  {�뤥�塞 ᨬ���}
  Sz := ImageSize(X-ddx,Y-ddx,X+ddx,Y+ddx);
  GetMem(P,sz);
  GetImage(X-ddx,Y-ddy,X+ddx,Y+ddy,P^);
  PutImage(X-ddx,Y-ddy,P^,NotPut);
  while MousePressed do; 		{����뢠�� ������}
  {��६�頥��� �� ⠡��� �� ������ �� ������ ���}
  while not MousePressed do
    begin
      GetMouseState(k,xx,yy); 	{����饥 ���������}
      NXX := (xx-XT) div DXT;
      NYY := (yy-YT) div DYT;
      if (NX<>NXX) or (NY<>NYY) then
        begin           		{���諨 � ����� �����}
          PutImage(X-ddx,Y-ddy,P^,NormalPut);
          Window(1,1,80,25);
          GotoXY(60,25);
          TextColor(White);
          TextBackGround(LightRed);
          Write(NYY*16+NXX:4,' ');
          NX := NXX;
          NY := NYY;
          X := XT+NX*DXT+ddx;
          Y := YT+NY*DYT+ddy;
          GetImage(X-ddx,Y-ddy,X+ddx,Y+ddy,P^);
          PutImage(X-ddx,Y-ddy,P^,NotPut);
        end
    end;
  {����� ������: ����⠭�������� ��࠭}
  PutImage(X-ddx,Y-ddy,P^,NormalPut);
  FreeMem(P,sz);
  GotoXY(60,25);
  Write('     ');
  GetMouseState(k,xx,yy); 	{k - ������ ������}
  while MousePressed do;  	{���� ���᪠���}
  N := NY*16+NX;
  Tabl := k=LeftButton;
  ShowMouse;
  MouseScreen  			{�᢮������� ����}
end;  {Tabl}
{---------}
Procedure ClearWE;
  {��頥� ࠡ�祥 ����}
begin
  ClearWinEd;
  PutImage(XR,YR,WR^,NormalPut);
  NVecE := 0;
  WidthX := 0
end;
{---------}
Procedure GetChar;
  {���� ᨬ��� �� ⠡����}
var
  k: Integer;
  N: Byte;
  W,op: Word;
  xx,yy: ShortInt;
begin
  if not Tabl(N) then
    Exit;      			{��室 �� �ࠢ�� ������}
  ClearWE;        		{��頥� ࠡ�祥 ����}
  PW := Chars[N]; 		{���� ����⥫��}
  X := 0;         		{��砫�� ���न���� ���}
  Y := 0;
  SetColor(Yellow);
  SetWriteMode(XORPut);
  {���� �� ��������}
  for k := 1 to LengD[N] div 2 do
    begin
      W := PW^[k];       		{��।��� ᫮��}
      op := W and $8080; 		{��� ����樨}
      W := W xor op;
      xx := W and 127;   		{���न��� X}
      yy := W shr 8;     		{���न��� Y}
      if yy>63 then
        yy := yy-128;
      if op=$8080 then
        begin            		{������� �����}
          inc(NVecE);    		{�����.����஢}
          with VecE[NVecE] do
            begin        		{��ନ�㥬 ���� �����}
              X1 := XE+X*DXE;
              Y1 := YB-Y*DYE;
              X2 := XE+xx*DXE;
              Y2 := YB-yy*DYE;
              {���⨬ ����� � ࠡ�祬 ����}
              Line(X1,Y1,X2,Y2)
            end;
        end;
      X := xx;      		{����� ��������� ���}
      Y := yy
    end;
  {���⨬ �ࠢ�� �࠭��� ᨬ����}
  WidthX := XE+Widths[N]*DXE;
  SetColor(Cyan);
  Line(WidthX,YE,WidthX,YE2);
  {�����塞 ᨬ��� � ���� �����}
  RepChar
end;  {GetChar}
{---------}
Procedure SetChar;
  {����頥� ᨬ��� � ⠡����}
var
  k: Integer;
  N: Byte;
  W,op: Word;
  Data: AW;
  X,Y,XX1,YY1,XX2,YY2: ShortInt;
  Xc,Yc: Integer;
begin
  if not Tabl(N) then
    Exit;
  {����塞 ���� ����⥫�}
  if LengD[N]<>0 then
    FreeMem(Chars[N],LengD[N]);
  Widths[N] := (WidthX-XE) div DXE;
  LengD[N] := 0;
  {���� �� ����ࠬ}
  X := 0;
  Y := 0;
  for k := 1 to NVecE do with VecE[k] do
    begin
      XX1 := (X1-XE) div DXE;
      XX2 := (X2-XE) div DXE;
      YY1 := (YB-Y1) div DYE;
      YY2 := (YB-Y2) div DYE;
      if (X<>XX1) or (Y<>YY1) then
        begin {������� ���室�}
          if YY1<0 then
            inc(YY1,128);
          inc(LengD[N]);
          Data[LengD[N]] := YY1 shl 8+XX1 or $80
        end;
      X := XX2;
      Y := YY2;
      if YY2<0 then
        inc(YY2,128);
      inc(LengD[N]);
      Data[LengD[N]] := YY2 shl 8+XX2 or $8080;
    end;
  {��ନ�㥬 ���室 � ����� ᨬ����}
  inc(LengD[N]);
  Data[LengD[N]] := Widths[N] or $80;
  inc(LengD[N]);
  Data[LengD[N]] := 0;  		{����� ������}
  {�����뢠�� � ������}
  LengD[N] := 2*LengD[N];
  GetMem(Chars[N],LengD[N]);
  Move(Data,Chars[N]^,LengD[N]);
  {���⨬ ᨬ��� � ⠡���}
   HideMouse;
   Xc := XT+(N mod 16)*DXT;
   Yc := YT+(N div 16)*DYT;
   SetFillStyle(SolidFill,Black);
   Bar(Xc,Yc,Xc+DXT-1,Yc+DYT-1);
   SetColor(White);
   SetWriteMode(NormalPut);
   OutChar(Xc,Yc+DYT,N,DXT/MaxW,DYT/(MaxH+5));
   SetColor(Yellow);
   SetWriteMode(XORPut);
   ShowMouse;
   ChangeF := True
end;  {SetChar}
{---------}
Function Ned(var x,y: Integer): Boolean;
  {�����頥� TRUE � ���न���� 㧫�,
   �᫨ ���� ������ � ��� ����⭮��}
var
  Is: Boolean;
begin
  Is := False;
  y := YE;
  repeat
    x := XE;
    repeat
      Is := MouseIn(x-dXm,y-dYm,x+dXm,y+dYm);
      if not Is then
        inc(x,DXE)
    until Is or (x>XE2);
    if not Is then
      inc(y,DYE)
  until Is or (y>YE2);
  Ned := Is
end;  {Ned}
{---------}
Procedure MouseInNed;
  {�஢���� �⬥�� ����� 㧫� �⪨}
var
  XN,YN: Integer;
begin
  if not Ned(XN,YN) then
    Exit;    {�� ������ � 㧥�}
  HideMouse;
  while MousePressed do;
  MouseGotoXY(XN,YN);
  if not MPF then
    begin    {���������� 㧥�}
      MPF := True;
      X0g := XN;
      Y0g := YN;
      X1g := X0g;
      Y1g := Y0g;
      SetColor(Yellow);
      SetWriteMode(XORPut);
      MouseWindow(XE,YE,XE2,YE2);
      MouseGraphCursor(CurE,dXm,dYm);
      ShowMouse
    end
  else
    begin  {��ନ�㥬 ���� �����}
      MPF := False;
      if (x0g<>x1g) or (y0g<>y1g) then
        Line(x0g,y0g,x1g,y1g);
      MouseScreen;
      if (X0g<>XN) or (Y0g<>YN) then
        begin {����頥� ��।��� �����}
          inc(NVecE);
          with VecE[NVecE] do
            begin
              X1 := X0g;
              Y1 := Y0g;
              X2 := XN;
              Y2 := YN;
              Line(x1,y1,x2,y2);
              RepChar
            end;
          {�஢��塞 �ਭ� ᨬ����}
          if X0g>XN then
            XN := X0g;
          if XN>WidthX then
            begin  {���頥� �ࠢ�� �࠭���}
              SetColor(Cyan);
              SetWriteMode(XORPut);
              Line(WidthX,YE,WidthX,YE2);
              WidthX := XN+4*DXE;
              if WidthX>XE2 then
                WidthX := XE2;
              Line(WidthX,YE,WidthX,YE2);
              SetColor(Yellow);
            end;
          MouseGraphCursor(CurM,0,0);
          ShowMouse
        end
    end
end;  {MouseInNed}
{---------}
Procedure MouseInLine;
  {�஢���� �⬥�� �����}
var
  x1m,y1m,x2m,y2m,dx,dy,x,y,n: Integer;
  Is,Sign: Boolean;
  k: Word;
  k0,y0: Real;
label
  Loop;
begin
  if MPF then
    begin {����⮦��� १������ ����}
      HideMouse;
      MPF := False;
      if (X0g<>X1g) or (Y0g<>Y1g) then
        Line(X0g,Y0g,X1g,Y1g);
      MouseGraphCursor(CurM,0,0);
      ShowMouse;
      MouseScreen;
      Exit
    end;
  if NVecE=0 then
    Exit;  {���⮥ ࠡ�祥 ����}
Loop:
  GetMouseState(x,x1m,y1m);
  if (not MousePressed) and MouseF then
    begin
      HideMouse;
      MouseGraphCursor(CurM,0,0);
      ShowMouse;
      MouseScreen;
      MouseF := False;
      Exit
    end;
  x2m := x1m+dXm;
  y2m := y1m+dYm;
  x1m := x1m-dXm;
  y1m := y1m-dYm;
  {�஢��塞 �� ������}
  n := 1;
  Is := False;
  repeat
    with VecE[n] do
    if (x1=x2) and (x1>=x1m) and (x1<=x2m) then
      {���⨪���� �����}
      Is := ((y1>=y2m) and (y2<=y1m)) or
            ((y1<=y1m) and (y2>=y2m))
    else
    if (y1=y2) and (y1>=y1m) and (y1<=y2m) then
      {��ਧ��⠫�� �����}
      Is := ((x1>=x1m) and (x2<=x2m)) or
            ((x1<=x2m) and (x2>=x1m))
    else                			{�������� �����}
    if (((y1>=y2m) and (y2<=y1m)) or((y1<=y1m) and 
       (y2>=y2m))) and(((x1>=x1m) and (x2<=x2m)) or 
       ((x1<=x2m) and (x2>=x1m))) then
    begin
      k0 := (y2-y1)/(x2-x1);
      y0 := y1-k0*x1;
      for x := x1m to x2m do if not Is then
        begin
          y := Round(k0*x+y0);
          Is := (y>=y1m) and (y<=y2m);
          if not Is then
            if x=x1m then
              Sign := y<y1m
            else
            Is:= (Sign and (y>y1m)) or (not Sign and (y<y1m))
        end
    end;
    if not Is then
      inc(n)
  until Is or (n>NVecE);
  if Is then
    begin   			{����塞 �����}
      HideMouse;
      SetColor(Yellow);
      SetWriteMode(XORPut);
      with VecE[N] do
        Line(x1,y1,x2,y2);  	{��ࠥ� �����}
      if NVecE>1 then       	{��६�頥� ������}
        for  N := N to NVecE-1 do
          VecE[N] := VecE[N+1];
      dec(NVecE);
      RepChar;
      if NVecE>1 then
        begin
          MouseGraphCursor(CurE,dXm,dYm);
          MouseWindow(XE-dXm,YE-dYm,XE2+dXm,YE2+dYm);
          MouseF := True
        end
      else
        begin
          MouseGraphCursor(CurM,0,0);
          MouseScreen;
          MouseF := False
        end;
      ShowMouse;
      if MouseF then
        Goto Loop
    end
  else if MouseF then
    Goto Loop
  else if (WidthX>=x1m) and (WidthX<=x2m) then
    begin   			{��६�頥� �ࠢ�� �࠭���}
      SetColor(Cyan);
      SetWriteMode(XORPut);
      HideMouse;
      MouseGraphCursor(CurE,dXm,dYm);
      ShowMouse;
      MouseWindow(XE,YE,XE2,YE2);
      while MousePressed do
        begin
          GetMouseState(n,x1m,y1m);
          if XE+DXE*Round((x1m-XE)/DXE)<>WidthX then
            begin
              HideMouse;
              Line(WidthX,YE,WidthX,YE2);
              WidthX := XE+DXE*Round((x1m-XE)/DXE);
              Line(WidthX,YE,WidthX,YE2);
              ShowMouse
            end
        end;
      MouseScreen;
      HideMouse;
      MouseGraphCursor(CurM,0,0);
      ShowMouse
    end
end;
{---------}
Procedure MouseMove;
  {����஫���� ��६�饭�� ���}
begin
  if MPF and ((XM<>X1g) or (YM<>Y1g)) then
    begin  			{��ନ�㥬 १������ ����}
      HideMouse;
      if (X0g<>X1g) or (Y0g<>Y1g) then
      Line(X0g,Y0g,X1g,Y1g); 	{��ࠥ� �����}
      X1g := XM;     		{���� ���न���� ����}
      Y1g := YM;
      if (X0g<>X1g) or (Y0g<>Y1g) then
      Line(X0g,Y0g,X1g,Y1g);
      ShowMouse
    end;
end;  {MouseMove}
{---------}
Procedure Pattern;
  {�롨ࠥ� � ����頥� � ࠡ�祥 ���� ��ࠧ��}
var
 X,Y,xx,yy: Integer;
 k,op,W: Word;
 PW:^AW;
 N: Byte;
begin
  if not Tabl(N) then
    Exit;      			{��室 �� �ࠢ�� ������}
  SetColor(LightGray);
  PW := Chars[N]; 		{���� ����⥫��}
  X := XE;         		{��砫�� ���न���� ���}
  Y := YB;
  {���� �� ��������}
  for k := 1 to LengD[N] div 2 do
    begin
      W := PW^[k];       		{��।��� ᫮��}
      op := W and $8080; 		{��� ����樨}
      W := W xor op;
      xx := W and 127;   		{���न��� X}
      yy := W shr 8;     		{���न��� Y}
      if yy>63 then
        yy := yy-128;
      xx := XE+xx*DXE;
      yy := YB-yy*DYE;
      if op=$8080 then
        Line(X,Y,xx,yy);
      X := xx;      		        {����� ��������� ���}
      Y := yy
    end;
  SetColor(Yellow)
end;
{---------}
BEGIN  {Run}
  SetWriteMode(XORPut);
  NVecE := 0;   			{��� ����஢ � WE}
  MPF := False; 			{���� �� ����������}
  SetColor(Yellow);
  GetMouseState(BM,XM,YM);  	{��砫쭮����ﭨ� ���}
  While True do  	{��᪮���� 横� �� ������� "�����"}
    begin
      {�஢��塞 �롮� ���� � ����������}
      if KeyOrMousePressed then
      case ReadKeyOrMouse of
        #0: case ReadKeyOrMouse of
              #1:GetChar;
              #2:SetChar;
              #3:ClearWE;
              #4:Pattern;
              #5:SaveFont;
              #6: Exit;
            end;
      end;
    {�஢��塞 ⥪�饥 ���ﭨ� ���}
      GetMouseState(B,X,Y);
      if (B<>BM) or (X<>XM) or (Y<>YM) then
        if MousePressed and
           MouseIn(XE,YE,XE2,YE2) then
          case B of  		{����஫��㥬 ������}
            LeftButton :MouseInNed;
            RightButton:MouseInLine;
          end
        else {����஫��㥬 ��६�饭��}
          MouseMove;
      XM := X;
      YM := Y;
      BM := B
    end
END;  {Run}

PROCEDURE Done;
BEGIN
  SaveFont;
  CloseGraph;
END;  {Done}
{-------------------}
BEGIN  {������� �ணࠬ��}
  Init;  	{���樠�� ���� � ��࠭�}
  Run;   	{������஢���� ��� ᮧ����� ᨬ�����}
  Done   	{�����襭�� ࠡ���}
END. 


