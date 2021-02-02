Var
	F:File Of Byte;
Begin
	Assign(F,'C:\Work\Points_3\netpoin3.pas');
	{$I-}
	Reset(F);
	{$I+}
	Writeln(IOResult);
End.
