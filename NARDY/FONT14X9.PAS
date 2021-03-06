Uses Graph, CRT, DOS;
const
  fontwith=15;
type
  FontType   = array [0..255, 0..FontWith] of byte;
  ReadKType  = (LeftK, RightK, UpK, DownK, F1K, F2K, F3K, F4K, F5K,
                AltF4, AltF5, F6K, F7K, F8K, EnterK, ESCK, Err);
const
  wdw  = 10;                     {�ਭ� ���⪨ ࠡ. ����}
  htw  = 8;                      {���� ���⪨ ࠡ. ����}
  wdt  = 15;                     {�ਭ� ���⪨ ⠡����}
  htt  = 20;                     {���� ���⪨ ⠡����}
  xw   = wdw;                    {����� �࠭�� ࠡ. ����}
  F1f : Boolean = false;         {䫠� ०��� F1}
  F2f : Boolean = false;         {䫠� ०��� F2}
  iw  : byte = 0;                {��ਧ.����.���ᥫ� � ࠡ.����}
  jw  : byte = 0;                {���⨪. ����. ���ᥫ�}
  iF1 : byte = 4;                {��ਧ. ����. ०��� F1}
  jF1 : byte = 1;                {���⨪. ����.}
  iF2 : byte = 8;                {��ਧ. ����. ०��� F2}
  jF2 : byte = 0;                {���⨪. ����.}
  Cng : Boolean = false;         {䫠� ��������� ����}
  FlagFont : Boolean = false;    {䫠� ��⠭���� ����}
  InpName = '14x9.FON';          {��� �室���� 䠩��}
  OutName = '14X9.NEW';          {��� ��室���� 䠩��}
var
  f    : file of FontType;
  Font : FontType;               {⠡��� ������������}
  FntC : array [-4..100] of byte; {��ࠧ ��।���� ᨬ����:
                         ���� 4 ���� - �㦥���, ᮡ�⢥���
                         ��ࠧ ��稭����� � ���� � ����஬ 0}
  yw   : integer;                {������ �࠭�� ࠡ.����}
  xt   : integer;                {����� �࠭�� ⠡����}
  yt   : integer;                {������ �࠭�� ⠡����}
  brdr : pointer;                {�-�� �� ࠬ�� ��� ࠡ.����}
  pw   : pointer;                {�-�� �� ����� ��� ࠡ.����}
  pw0  : pointer;
  pc   : pointer;                {�-�� �� ᨬ���}
  pt   : pointer;                {�-�� �� ����� ⠡����}
  i, j : integer;                {ࠡ�稥 ��६����}
  x, y : integer;
  FontB : array [0..FontWith, 0..7] of Boolean; {���ᨢ �ਧ�����
                                          ᢥ������ ���ᥫ��}
(*
procedure write(c:char);
var
  r:registers;
begin
  with r do
    begin
      ah:=10;
      ah:=ord(c);
      bh:=0;
      cx:=1;
      intr($10,r)
    end
end;
*)
{---------------------------------------------------------------}
PROCEDURE Build;
{
 ���ᯥ稢��� ���� � ��⠫��� � �⥭�� ���� �� 䠩�� � ������
"8x8.fnt" (��楤��  ReadFont),  �ନ஢���� ࠡ�祣� ����
(��楤��  BuildWork)  �  �����⮢�� � �ନ஢���� ⠡����
(��楤��  BuildTable).  �뢮��� ������ ��ப�-���᪠���.
}
{---------------------------------------------------------------}
  PROCEDURE ReadFont;
  {
    ��⠥� ����� �� 䠩��  "8x8.fnt"  � ��६�����  Font.
    �᫨ 䠩� �� �����㦥�, ������ ��� ��६�����.
  }
  BEGIN  {��砫� ��楤���  READFONT}
    for i := 0 to 255 do
      for j := 0 to FontWith do  Font[i, j] := 0;
    assign (f, InpName);
    {$I-}  reset (f);  {$I+}
    if IOResult = 0 then
      begin
        read (f, Font);
        Close (f);
        FlagFont := true
      end;
  END    {����� ��楤���  READFONT};
{---------------------------------------------------------------}
  PROCEDURE BuildWork;
  {
    �����⠢������ ࠡ�祥 ���� � ����� ��� ��࠭�:
    ����稢��� ���� 8x8 � ��⮢�� ��ࠧ ���⮩
    ���⪨ (㪠��⥫�  pw0) � ������ ��� ������� (pw).
  }
  BEGIN  {��砫� ��楤���  BUILDWORK}
    yw := (GetMaxY - htw*(FontWith+1) - 9) div 2;
    for i := 0 to FontWith+1 do
      begin
        Line (xw, yw+i*htw, xw+wdw*8, yw+i*htw);
        if i<=8 then Line (xw+i*wdw, yw, xw+i*wdw, yw+htw*(FontWith+1))
      end;
    GetMem (pw, ImageSize (xw+1, yw+1, xw+wdw, yw+htw));
    GetMem (pw0, ImageSize (xw+1, yw+1, xw+wdw, yw+htw));
    GetImage (xw+1, yw+1, xw+wdw, yw+htw, pw0^)
  END    {����� ��楤���  BUILDWORK};
{---------------------------------------------------------------}
  PROCEDURE BuildTable;
  {
    ��।���� ���न���� � ����稢��� ����  16x16  ���
    ⠡���� ������������.  ��⠥� �⠭����� ���� ��
    ��ࢮ� ��������  ASCII-�o�o� � ����頥� ��� � �����
    ���� ⠡����.  �᫨ �� ��⠭ 䠩�  "8x8.fnt" (�ਧ���
    � ��६�����  FlagFont), � �ନ����� � �ࠢ�� ��������
    ⠡����. B 㪠��⥫�  pc^  ��࠭���� ������ ��� ��७��
    ᨬ����� �� ⠡���� � ࠡ�祥 ���� � ���⭮.  B 㪠��⥫�
    pt^  १�ࢨ����� ������ ��� �뤥����� ���⪨ ⠡����.
  }
  var
    is, k : integer;
    l,m:byte;
  BEGIN  {��砫� ��楤��� BUILDTABLE}
    xt := GetMaxX - 16*wdt - xw - 1;
    yt := (GetMaxY - 16*htt - 8) div 2 + 8;
    for i := 0 to 16 do
      begin
        Line (xt, yt+i*htt, xt+16*wdt, yt+i*htt);
        Line (xt+i*wdt, yt, xt+i*wdt, yt+16*htt)
      end;
    Rectangle (xt-1, yt-1, xt+8*wdt-1, yt+16*htt+1);
    RectAngle (xt+8*wdt+1, yt-1, xt+16*wdt+1,yt+16*htt+1);
    is := ImageSize (0, 0, 7, FontWith);
    GetImage (0, 0, 7, FontWith, FntC);{�o�o��� �㦥��� ����� � FntC}
    GetMem (pc, is);
{
  ���� �����⮢�� ᨬ�����: ᭠砫� ����� ᨬ��� �뢮����� �
  ���� ���孨� 㣮� ��࠭�, ��⥬ ��७����� �� �㦭�� ����
  � ⠡���.  ������� 7, 8, 10 � 13 �뢮����� ��楤�ன
  OUTTEXT, �.�. ��楤��  WRITE  ��ࠡ��뢠�� �� �ᮡ� ��ࠧ��.
}
    HighVideo;
    for i := 0 to {8*succ(ord(FlagFont))-}15 do
      for j := 0 to 15 do
        begin
          k := i*16 + j;
          GotoXY(1,1);
          case k of
          7,8,10,13: OutTextXY(0,0,chr(k));
          else write(chr(k));
          end;

          for l:=0 to FontWith do                   {���⨪���}
            begin
              Font[k,l]:=0;
              for m:=0 to 7 do                        {��ਧ��⠫�}
                if GetPixel(m,l)<>black then
                  Font[k,l]:=Font[k,l] xor (128 shr m)
            end;
          GetImage (0, 0, 7, FontWith, pc^);
          PutImage (0, 0, pc^, XORPut);
          PutImage (xt+i*wdt+(wdt-8) div 2 +1,
                    yt+j*htt+(htt-FontWith-1) div 2 +1, pc^, NormalPut);
        end;
    GetMem (pt, ImageSize (0, 0, wdt, htt))
  END    {����� ��楤���  BUILDTABLE};

{---------------------------------------------------------------}
const
  tx = 'F1 - Get char;   F2 - Put char;   F3 - Quit';
BEGIN   {��砫� ��楤���  BUILD}
  ReadFont;
  BuildWork;
  BuildTable;
  GotoXY ((80 - TextWidth(tx) div 8) div 2 + 1, 1);
  system.write (tx);
  Rectangle(0, 16, GetMaxX, GetMaxY)
END     {����� ��楤���  BUILD};
{---------------------------------------------------------------}
PROCEDURE Work;
{
  ��⮢�� �ᯮ����⥫�� ���ᨢ-�ਧ��� ���ᥫ��  FontB,
  ��⥬ � ��᪮��筮� 横�� �⠥� ���������� � ��।���
  �ࠢ����� ᮮ⢥�����饩 ��楤��.
}
{---------------------------------------------------------------}
  FUNCTION RedK : ReadKType;
  {
    ���ᯥ稢��� ������� ���⪨ ࠡ.���� ��� �뤥������� ᨬ����
    �� �� ���, ���� �� �㤥� ����� ��।��� ������.  �८�-
    ࠧ�� ��� ������ � ⨯  ReadKType.
  }
  const
    ReadKTable : array [0..13] of byte =
                       (75, 77, 72, 80, 59, 60, 61, 62, 63,
                       107, 108, 64, 65, 66);
    Temp = 5;                  {���� �������}
  var
    p      : pointer;        {��ࠧ �������}
    c1, c2 : char;
    RK     : ReadKType;
  BEGIN  {��砫� �㭪樨  REDK}
  { �����⮢��� �  x, y - ���न����, a �  p^ - ��ࠧ
    ��� �������:}
    if not (F1f or F2f) then
      begin
        x := xw + iw*wdw + 3;
        y := yw + jw*htw + 2;
        p := pw;
        GetImage (x, y, x+wdw-7, y+htw-4, p^)
      end
    else
      begin
        if F1f then
          begin
            x := xt + iF1*wdt;
            y := yt + jF1*htt
          end
        else
          begin
            x := xt + iF2*wdt;
            y := yt + jF2*htt
          end;
        p := pt;
        GetImage (x, y, x+wdt, y+htt, p^)
      end;
{  横� ᪠��஢���� ���������� }
    repeat
      while not KeyPressed do
        begin
          PutImage (x, y, p^, NotPut);
          for i := 1 to 50 do
            if not KeyPressed then delay (Temp);
          PutImage (x, y, p^, NormalPut);
          if not KeyPressed then
            for i := 1 to 50 do
              if not KeyPressed then delay (Temp)
        end;
{  �������� ������� � ᮮ⢥��⢨� c ⨯��  ReadKType}
      RK := Err;
      c1 := ReadKey;
      if ord(c1) = 0 then c2 := ReadKey else c2 := chr(0);
      if ord(c1) = 13 then RK := EnterK
      else if ord(c1) = 27 then RK := ESCK
      else if ord(c1) = 0 then
        for i := 0 to 13 do
          if ord(c2) = ReadKTable[i] then RK := ReadKType(i);

{ �த������ ᪠��஢����, �᫨ ������ �� ᮮ⢥�����
   ⨯�  ReadKType}
    until RK <> Err;
    RedK := RK
  END    {����� �㭪樨  REDK};
{---------------------------------------------------------------}
  PROCEDURE MoveXY (x : integer);
  {
    ��ॢ���� 㪠��⥫� � ࠡ�祬 ���� ��� ⠡���:
      1 - ������;  2 - ���ࠢ�;  3 - �����;  4 - ����.
  }
{---------------------------------------------------------------}
    PROCEDURE Left  (var i : byte; a, b : byte);
    begin
      if i = a then i := b else dec (i)
    end;
{---------------------------------------------------------------}
    PROCEDURE Right (var i : byte; a, b : byte);
    begin
      if i = b then i := a else inc (i)
    end;
{---------------------------------------------------------------}
    PROCEDURE Up    (var i : byte; a : byte);
    begin
      if i = 0 then i := a else dec (i)
    end;
{---------------------------------------------------------------}
    PROCEDURE Down  (var i : byte; a : byte);
    begin
      if i = a then i := 0 else inc (i)
    end;
{---------------------------------------------------------------}
  BEGIN  {��砫� ��楤���  MOVEXY}
    if F1f then
      begin
        case x of
          1 : Left  (iF1, 0, 15);
          2 : Right (iF1, 0, 15);
          3 : Up    (jF1, 15);
          4 : Down  (jF1, 15)
        end;
        GotoXY (76, 1); system.write (iF1*16 + jF1 : 3)
      end
    else if F2f then
      begin
        case x of
          1 : Left  (iF2, 0, 15);
          2 : Right (iF2, 0, 15);
          3 : Up    (jF2, 15);
          4 : Down  (jF2, 15)
        end;
        GotoXY (76, 1); system.write (iF2*16 + jF2 : 3)
      end
    else
      begin
        case x of
          1 : Left  (iw, 0, 7);
          2 : Right (iw, 0, 7);
          3 : Up    (jw, FontWith);
          4 : Down  (jw, FontWith)
        end
      end
  END    {����� ��楤���  MOVEXY};
{---------------------------------------------------------------}
  PROCEDURE CopyChar;
  {
    ������� ᨬ��� � ���� ������ 3x3 ����� � 業�� ��࠭�.
  }
  BEGIN  {��砫� ��楤���  COPYCHAR}
    x := xw + 8*wdw + 1;
    x := x + (xt - x - 24) div 2;
    y := (GetMaxY - 3*(FontWith+1)) div 2;
    for i:=0 to FontWith do
      for j:=0 to 7 do
        if FontB[i,j] then PutPixel(x+j,y+i,white)
        else PutPixel(x+j,y+i,black);
    GetImage(x,y,x+7,y+FontWith,Fntc);
    for i := 0 to 2 do
      for j := 0 to 2 do
        PutImage (x + 8*j, y + (FontWith+1)*i, FntC, NormalPut);
{    Rectangle (x-1, y-1, x+25, y+3*(FontWith+1)+1)}
  END    {����� ��楤���  COPYCHAR};



{---------------------------------------------------------------}
  PROCEDURE Enter;
  {
    B ०��� ।���஢���� ��������� ���ᥫ�,
    � ०��� F1 ��७��� ��࠭�� ᨬ��� � ࠡ�祥 ����,
    � ०��� F2 ��७��� ᨬ��� � ⠡����.
  }
{---------------------------------------------------------------}
    PROCEDURE GetChar;
    {
      ��७��� ��࠭�� � ⠡��� ᨬ��� � ࠡ�祥 ����.
    }
    BEGIN  {��砫� ��楤���  GETCHAR}
      x := xt + iF1*wdt + (wdt - 8) div 2 + 1;
      y := yt + jF1*htt + (htt - FontWith-1) div 2+1 ;
      GetImage (x, y, x+7, y+FontWith, FntC);
{ �஢���� ��ࠧ ��-��⭮ � ��ନ஢��� ����ࠦ���� �
  ࠡ�祬 ����}
      for i := 0 to FontWith do
        for j := 0 to 7 do
           if GetPixel(x+j,y+i)<>black then
            begin
              PutImage (xw+j*wdw+1, yw+i*htw+1, pw0^, NOTPut);
              FontB[i, j] := true
            end
          else
            begin
              PutImage (xw+j*wdw+1, yw+i*htw+1, pw0^, NormalPut);
              FontB[i, j] := false
            end;
      CopyChar;
      GotoXY (76, 1);  system.write ('   ');
      F1f := false
    END    {����� ��楤���  GETCHAR};
{---------------------------------------------------------------}
    PROCEDURE PutChar;
    {
      ����頥� ��।���஢���� ᨬ��� � ⠡����.
    }
var k:byte;
    BEGIN  {��砫� ��楤���  PUTCHAR}
      x := xt + iF2*wdt + (wdt - 8) div 2 + 1;
      y := yt + jF2*htt + (htt - FontWith-1) div 2 + 1;
      PutImage (x, y, FntC, NormalPut);
{  ᪮��஢��� ᨬ��� � �᭮���� ⠡����  Font }
      i := iF2*16 + jF2 ;
      for j := 0 to FontWith do
        begin
          Font[i, j] := 0;
          for k:=0 to 7 do
            if FontB[j,k] then Font[i,j]:=Font[i,j] or (128 shr k)
        end;
{ ������ ࠡ�祥 ���� }
      for i := 0 to FontWith do
        begin
          FntC[i] := 0;
          for j := 0 to 7 do
            begin
              PutImage (xw+j*wdw+1, yw+i*htw+1, pw0^, NormalPut);
              FontB[i, j] := false
            end;
        end;
      Cng := true;
      CopyChar;
      GotoXY (76, 1); system.write('   ');
      F2f := false
    END    {����� ��楤���  PUTCHAR};
{---------------------------------------------------------------}
  BEGIN  {��砫� ��楤���  ENTER}
    if F1f then GetChar
    else if F2f then PutChar
    else
      begin
        if FontB[jw, iw] then
          begin
            PutImage (xw+iw*wdw+1, yw+jw*htw+1, pw0^, NormalPut);
            FontB[jw, iw] := false
          end
        else
          begin
            PutImage (xw+iw*wdw+1, yw+jw*htw+1, pw0^, NOTPut);
            FontB[jw, iw] := true
          end;
        FntC[jw] := FntC[jw] xor (128 shr iw);
        CopyChar
      end
  END    {����� ��楤���  ENTER};
{---------------------------------------------------------------}
  PROCEDURE Quit;
  {
    �����蠥� ࠡ��� �ணࠬ��.
  }
  BEGIN
    if Cng then
      begin
        assign (f, OutName);
        rewrite (f);
        system.write (f, Font);
        Close (f)
      end;
    CloseGraph;
    Halt
  END;
{---------------------------------------------------------------}
var
  buf1,buf2 : array [1..16,0..FontWith] of byte;
  ib,jb,jjb,m,l:integer;
  name:string;
  c:char;
BEGIN  {��砫� ��楤���  WORK}
  for i := 0 to FontWith do
    for j := 0 to 7 do
      FontB[i, j] := false;
  while true do
    case RedK of
      LeftK  : MoveXY (1);
      RightK : MoveXY (2);
      UpK    : MoveXY (3);
      DownK  : MoveXY (4);
      F1K    : begin
                 F1f := true; F2f := false
               end;
      F2K    : begin
                 F1f := false; F2f := true
               end;
      F3K    : Quit;
      F4K    : begin      {����஢���� ���⨪��쭮�� �鸞 iF1 � ���� 1}
                 for ib:=1 to 16 do
                   for jb:=0 to FontWith do
                     buf1[ib,jb]:=Font[if1*16+ib-1,jb]
               end;
      F5K    : begin      {����஢���� iF1 � ���� 2}
                 for ib:=1 to 16 do
                   for jb:=0 to FontWith do
                     buf2[ib,jb]:=Font[if1*16+ib-1,jb]
               end;
      AltF4  : begin      {����஢���� �� ���� 1 � �� if2}
                 for ib:=1 to 16 do
                   begin
                     for jb:=0 to FontWith do
                       begin
                         Font[if2*16+ib-1,jb]:=buf1[ib,jb];
                         for jjb:=0 to 7 do
                           if (buf1[ib,jb] and (128 shr jjb))<>0 then
                           PutPixel(jjb,jb,white)
                       end;
                     GetImage(0,0,7,FontWith,FntC);
                     PutImage(0,0,FntC,XORPut);
                     x := xt + iF2*wdt + (wdt - 8) div 2 + 1;
                     y := yt + (ib-1)*htt + (htt - FontWith-1) div 2 + 1;
                     PutImage (x, y, FntC, NormalPut);
                   end
               end;
      AltF5  : begin      {����஢���� �� ���� 2 � �� if2}
                 for ib:=1 to 16 do
                   begin
                     for jb:=0 to FontWith do
                       begin
                         Font[if2*16+ib-1,jb]:=buf2[ib,jb];
                         for jjb:=0 to 7 do
                           if (buf2[ib,jb] and (128 shr jjb))<>0 then
                           PutPixel(jjb,jb,white)
                       end;
                     GetImage(0,0,7,FontWith,FntC);
                     PutImage(0,0,FntC,XORPut);
                     x := xt + iF2*wdt + (wdt - 8) div 2 + 1;
                     y := yt + (ib-1)*htt + (htt - FontWith-1) div 2 + 1;
                     PutImage (x, y, FntC, NormalPut);
                   end
               end;
      F6K    : begin      {�⥭�� �� 䠩��}
                 GotoXY(5,24); write('��� �室���� 䠩��= ');
                 readln(name);
                 GotoXY(5,24); write('                                   ');
                 assign(f,name);
                 reset(f);
                 read(f,font);
                 close(f);
                 for i:=0 to 15 do
                   for j:=0 to 15 do
                     for m:=0 to FontWith do
                       for l:=0 to 7 do
                         if (font[i*16+j,m] and (128 shr l))<>0 then
                           PutPixel(xt+i*wdt+(wdt-8) div 2 +1+l,
                                    yt+j*htt+(htt-FontWith-1) div 2+1+m,white)
                         else
                           PutPixel(xt+i*wdt+(wdt-8) div 2 +1+l,
                                    yt+j*htt+(htt-FontWith-1) div 2+1+m,black);
               end;
      F7K    : begin      {������ � 䠩�}
                 GotoXY(5,24); write('��� ��室���� 䠩��= ');
                 readln(name);
                 GotoXY(5,24); write('                                   ');
                 assign(f,name);
                 rewrite(f);
                 write(f,font);
                 close(f)
               end;
      f8K    : begin
                 GotoXY(1,1);
                 write('  - ᨬ���');
                 GotoXY(1,1);
                 readln(c);
                 GetImage(0,0,7,FontWith,FntC);
                 for i:=0 to FontWith do
                   for j:=0 to 7 do
                     begin
                       FontB[i,j]:=GetPixel(j,i)<>black;
                       PutImage (xw+j*wdw+1, yw+i*htw+1, pw0^, 4*ord(FontB[i,j]));
                     end;
                 copychar;
                 GotoXY(1,1);
                 write('          ');
               end;

      EnterK : Enter;
      ESCK   : begin
                 F1f := false; F2f := false
               end
    end  {case}
END    {����� ��楤���  WORK};
{---------------------------------------------------------------}
var
  d, r, e : integer;
BEGIN   {��砫� �᭮���� �ணࠬ��}
  d := 0;  r := CGAHi;             { ��⠭���� ��䨪� ��᮪���
                                        ࠧ�襭�� CGA-������ }
  InitGraph (d, r, 'd:\turbo\pascal');
  e := GraphResult;
  if e <> grOk then
    writeln (GraphErrorMSG (e))
  else
    begin
      DirectVideo := false;
      Build;
      Work
    end
{============} END   {����� �᭮���� �ணࠬ��}. {==============}

