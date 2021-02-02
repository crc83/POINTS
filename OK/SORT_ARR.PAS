Program sort_array;

 Const

  m=1;
  n=5;

 Var
  a:array [m..n] of integer;
  B,E,K,F:Byte;
  P,I:Integer;
  Swapp:boolean;

BEGIN { M A I N }
	B:=Low(A);
	E:=High(A);
	F:=B;


{||||||||||||||||||||||||||||}

	for i:=m to n do
		readln (a[i]);
	writeln ('____________');

{|||||||||||||||||||||||||||||}
Repeat
	Swapp:=False;
	While F<E Do
		Begin
			K:=Succ(F);
			If A[F]<A[K] Then
				Begin
					P:=A[F];
					A[F]:=A[K];
					A[K]:=P;
					Swapp:=True;
				End;
			Inc(F);
		End;
	F:=B;
Until Not(Swapp);

{\\\\\\\\\\\\\\\\\\\\\}


for i:=m to n do
   writeln (a[i]);

WriteLn('=======================');
 END { M A I N }.











 