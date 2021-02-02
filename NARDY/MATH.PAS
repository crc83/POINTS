Unit math;
Interface
 Function fac (y:integer):integer;
 function st (a,n:real):real;
 function stt(a,n:real):real;
 function arccos(a:real):real;
Implementation
function fac(y:integer):integer;
 var f,z:integer;
 begin;
  f:=1           ;
   for z:=1 to y do f:=f*z;
  fac:=f
end;
function st(a,n:real):real;
 var s:real;
 begin
  s:=exp(n*ln(a));
  st:=s;
 end;
function stt(a,n:real):real;
 var p:real;
 begin
  p:=exp((1/n)*ln(a));
  stt:=p
 end;
function arccos(a:real):real;
 var b:real    ;
 begin
  if (a=-1) then b:=2*pi
  else b:=2*arctan(sqrt((1-a)/(1+a)));
  arccos:=b;
 end;
End.
