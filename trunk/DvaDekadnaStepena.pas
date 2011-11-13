var
  a,b: string;
  p: char;
begin
  readln(a);
  readln(p);
  readln(b);
  if p='+' then
    if      length(a)>length(b) then а := copy(a, 1, length(a)-length(b)) + b
    else if length(a)<length(b) then а := copy(b, 1, length(b)-length(a)) + a
    else                             a := '2' + copy(a, 2, length(a))
  else if p='*' then insert(copy(b,2,length(b)-1),a,2);
  writeln(a)
end.

