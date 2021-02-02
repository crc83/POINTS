{$A-,B+,D+,E-,F+,G-,I+,L+,N+,O+,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,600000}
Unit BStack;
Interface

Type
    PPointer =^TPointer;

	TPointer =Record
    	Info:Pointer;
        Next:PPointer;
    End;


    TStack =Object
    	Head:PPointer;

        Constructor Init;
        Procedure InitHead(H:Pointer);
        Procedure Del;
        Procedure Put(Inf:Pointer);
        Procedure Get(Var Inf:Pointer);
        Function Empty:Boolean;
        Destructor Done;
    End;{TStack the object}



Implementation

{================TSTACK=======================}

Function HeapFunc(Size: Word): Integer; far;
Begin
	HeapFunc := 1;
End;{HeapFunc}


{----------------------------}


Constructor TStack.Init;
Begin
	Head:=Nil;
End;{TStack.Init}

{---------------------}

Procedure TStack.InitHead;
Begin
	Head:=H;
End;{TStack.InitHead}

{----------------------}

Procedure TStack.Del;
Var
	Prev:PPointer;
Begin
	Prev:=Head;
    Head:=Head^.Next;
 	Dispose(Prev);
End;{TStack.Del}

{--------------------}
Function TStack.Empty:Boolean;
Begin
	Empty:= (Head = Nil) ;
End;{TStack.Empty}
{--------------------}

Procedure TStack.Put;
Var
	NPointer:PPointer;
Begin
	 If MemAvail<SizeOf(TPointer) Then
    	Begin
        	Writeln('It''s not enaught memory');
            Exit;
        End;
	New(NPointer);
    NPointer^.Info:=Inf;
    NPointer^.Next:=Head;
    Head:=NPointer;
End;{TStack.Put}

{---------------------}

Procedure TStack.Get;
Begin
    If Empty Then
    	Exit;
	Inf:=Head^.Info;
    Del;
End;{TStack.Get}

{----------------------}

Destructor TStack.Done;
Begin
	While Not(Empty) Do
    	Del;
End;{TStack.Done}

{--------------------}

Begin{Main}
	HeapError:=@HeapFunc;
End.{Unit}
