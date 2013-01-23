program beads;
var
 arr: array[ 1..100 ]of char;
 ch: char;
 d, i, n, w1, w2, w3, b, r, max: integer;

function rastojanjeDoObojenePerle(): integer;
var i: integer;
begin
 i := 0;
 repeat
  read(f, ch);
  i := i+1
 until not ch='w';
 rastojanjeDoObojenePerle := i
end;

function brojBelihIspredDrugeBoje(ch2: char): integer;
var d2: integer;
begin
 while ch=ch2 do d2 := rastojanjeDoObojenePerle();
 brojBelihIspredDrugeBoje := d2-1
end;

function rastojanjeDoDrugeBoje(ch3: char): integer;
var d3: integer;
begin
 d3 := 0;
 while ch=ch3 do d3 := d3 + rastojanjeDoObojenePerle();
 rastojanjeDoDrugeBoje := d3
end;

begin
 assign(f, 'beads.in');
 reset(f);
 readln(f, n);
 for i := 1 to n do begin
  read(f, arr[i]);
  arr[n+i] := arr[i];
 end;
 close(f);
 reset(f);
 max := 0;
 d := rastojanjeDoObojenePerle();
 w1 := brojBelihIspredDrugeBoje(ch);
 b := rastojanjeDoDrugeBoje(ch);
 r := rastojanjeDoDrugeBoje(ch);
...
 close(f);
 assign(g, 'beads.out');
 rewrite(g);
 writeln(max);
 close(g);
end.
