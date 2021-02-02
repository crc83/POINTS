{Version 3.0}



{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,600000}
Unit ForPoin3;
Interface
Uses
        GrDialog,F_Mouse,Graph;

Const

{
        Колiр фону ў лўнўй
}
                Ground=LightGray;
                FildLines=DarkGray;

{
        Kонстанти для запису в масив лiнiй
        що з'еднують точки
}
        HorizLine = 40;
        VertLine  = 100 - HorizLine;
        Slash     = 30;
        BkSlash   = 100 - Slash;


{
        Розмiри поля в клiтинках
}
        HorizSize = 30;
        VertSize  = 28;

{
        Розмiр клiтинки i точки в пiкселах
}
                HalfSize = 8;
                SqrSize = 2 * HalfSize;
                PointRad = 3;

{
        Координати поля
}
        FBegX = 5;
        FBegY = 5;
        FEndX = FBegX + ((HorizSize ) * (SqrSize ));
        FEndY = FBegY + ((VertSize ) * (SqrSize ));


        On = True;
        Off = False;

        D1=PointRad;
        D2=HalfSize;


        RoundedEmptyPlase:Byte=255;
        EmergyPlase:Byte=254;

{Чи ведеться гра по мережў
 REM пўсля вўдладки перенести в Var}

        NetGame:Boolean=True;



{==END================CONST================END==}



Type
                TPlayer = Record
                                Color:Byte;
                                Score:Word;
                                Playing:Boolean;
                                Name:String [12];
                                XR,YR:Word;
                End;{PPlayer}

                TFild = Array [-2..(2 * HorizSize + 2),-2..(2 * VertSize + 2)] Of Byte;


                TMove = Record
                          X,Y:Word;
                          Number:Byte;
                          Message:String[24];
                          Addres:Byte
                End;


Var
        Players:Array [1..10] Of TPlayer;
        MouseCursor,AnotherCursor:Array[1..64] Of Byte;
        NetDisk:String;
        ErrorCfg,HideLines:Boolean;
        Original,Work:TFild;
        XPot,YPot:Word;
        NPlayer:Byte;
        GHMC:Word;

        OurPlayers:Set Of Byte;
        GrNum:String[3];
        OldMove:TMove;



        Procedure SetMouseGraphCursor(Var Mask;X,Y:Byte);
        Procedure InitHelp(X,Y:Word;WaitFor:Boolean);

Implementation
Var
        HelpMB:TMessageBox;



        Procedure SetMouseGraphCursor;
        Begin
                If ErrorCfg Then
                        Exit;
                MouseGraphCursor(Mask,X,Y)
        End;{SetMouseGraphCursor}

{----------------------}

        Procedure InitHelp;
        Var
                YPlus,B:Byte;
                F:Text;
                A:String;
                P:Pointer;
                Size:LongInt;
        Begin
                        YPlus:=0;
                        If WaitFor Then
                                Begin
                                        YPlus:=100;
                                        ;
                                End;
                        HelpMB.Init(X,Y,X+490,Y+315+YPlus,5,5,5,5,3,3,3,'Правила');
                        HelpMB.AllowMessages;
                        Assign(f,'Points_u.Hlp');
                        {$I-}
                        Reset(F);
                        {$I+}
                        If IOResult<>0 Then
                                HelpMB.OutMessage('Допомога недоступна (Файл Points_u.Hlp не знайдено)')
                        Else
                                Begin
                                        B:=0;
                                        Repeat
                                                ReadLn(F,A);
                                                HelpMB.Print(B,A);
                                                B:=B+1;
                                        Until EOF(F);
                                        Close(F);
                        End;

        End;
End.{UNIT}