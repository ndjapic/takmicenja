program gift1;
 var np,i,j: integer;
 s: string:
 names: array [1..10] of string;
 balances: array [1..10] of integer;

 function pin(s: string): integer;
 var i: integer;
 begin
  i:=0;
  repeat
   i:=i+1;
  until names[i]=s;
  pin:=i
 end;
 
begin
 readln(np);
 for i:=1 to np do begin
  readln(names[i]);
  balances[i]:=0;
 end;
 for i:=1 to np do begin
 readln(s);
 end;
 
end.
