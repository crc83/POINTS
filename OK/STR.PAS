program str;
var
ibeg,iend,endw:byte;
s,subs,s2:string;
begin
readln(s);

repeat
ibeg:=1;
 endw:=pos('.',s);
iend:= pos(' ',s);
subs:=copy(s,ibeg,(iend-ibeg));
delete(s,ibeg,iend-ibeg+1);
writeln(subs);
insert (subs+' ',s2,1);
until endw=1







;writeln (s2  )
end.