program gift1;

 var p, g, np, ng, amount, gift: integer;
  name: string;
  names: array [1..10] of string;
  balances: array [1..10] of integer;
  f: text;

 function pin(name: string): integer;
 var p: integer;
 begin
  p := 1;
  while not names[p]=name do p := p+1;
  pin := p
 end;

 procedure advancebalance(idnum: integer; money: integer);
 begin
  balances[idnum] := balances[idnum] + money
 end;

begin
 assign(f, 'gift1.in');
 {$I-}   { disable i/o error checking }
 reset(f);
 {$I+}   { enable again i/o error checking - important }
 readln(f, np);
 for p := 1 to np do begin
  readln(f, names[p]);
  balances[p] := 0
 end;
 for p := 1 to np do begin
  readln(f, name);
  read(f, amount); readln(f, ng);
  if ng>0 then begin
   gift := amount div ng;
   advancebalance(pin(name), -ng*gift);
   for g := 1 to ng do begin
    readln(f, name);
    advancebalance(pin(name), gift);
   end
  end
 end;
 close(f);
 assign(f, 'gift1.out');
 rewrite(f);
 for p := 1 to np do begin
  write(f, names[p]); write(f, ' '); writeln(f, balances[p])
 end;
 close(f)
end.
