var
 a,b: string;
 p: char;
begin
 readln(a);
 readln(p);
 readln(b);
 if p='+' then
  if length(a)>length(b) then begin
   delete(a,2,1);
   insert('1',a,length(a)-length(b)+2)
  end else if length(a)<length(b) then begin
   delete(b,2,1);
   insert('1',b,length(b)-length(a)+2);
   a:=b
  end else begin
   a:='2'+copy(a,2,length(a))
  end
 else if p='*' then insert(copy(b,2,length(b)-1),a,2);
 writeln(a)
end.

