program gift1('gift1.in','gift1.out');

 var np, i, j, a, b, q, giver, receiver: integer;
 name: string;
 names: array [1..10] of string;
 balances: array [1..10] of integer;

 function pin(name: string): integer;
 var i: integer;
 begin
  i := 0;
  repeat
   i := i+1
  until names[i]=name;
  pin := i
 end;
 
begin
 readln(np);
 for i := 1 to np do begin
  readln(names[i]);
  balances[i] := 0
 end;
 for i := 1 to np do begin
  readln(name);
  giver := pin(name);
  read(a); readln(b);
  if b>0 then begin
   q := a div b;
   balances[giver] := balances[giver] - b*q;
   for j := 1 to b do begin
    readln(name);
    receiver := pin(name);
    balances[receiver] := balances[receiver] + q
   end
  end
 end;
 for i := 1 to np do begin
  write(names[i]);
  writeln(balances[i])
 end
end.
