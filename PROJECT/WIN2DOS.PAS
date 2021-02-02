Uses
	Dos;
Var
	IFile,OFile:File of Byte;
	B:Byte;
    S,Dir,Name,Ext:string;
Begin
	S:=paramstr(1);
    S:=fExpand(S);
	assign(IFile,S);
    Reset(IFile);

    fSplit(S,Dir,Name,Ext);
    Assign(Ofile,dir+Name+'.txt');
    Rewrite(OFile);
	While Not(Eof(IFile)) Do
		Begin
			Read(IFile,B);
			If B>191 Then
				If B<240 Then
					B:=B-64
				Else
					B:=B-16;
			If B=180 Then B:=245;
			If B=182 Then B:=247;
			If B=185 Then B:=249;

			Write(OFile,B);
            Write(':');
		End;
	Close(OFile);
	Close(IFile);
End.
