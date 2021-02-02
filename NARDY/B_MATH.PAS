unit b_math;
interface
function minim(a,b:byte):byte;
implementation
function minim(a,b:byte):byte;
begin
 if a>b then
  minim:=b
 else
  minim:=a
end;
end.