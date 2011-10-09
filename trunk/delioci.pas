program delioci;
var n,m,m0,b,b0,d: integer;
begin
  m0 := 0; b0 := 0
  readln(n);
  for m := 1 to n do begin
    b := 0
    for d := 1 to m do
      if m mod d = 0 then b := b+1
    if b > b0 then begin
      b0 := b;
      m0 := m
    end
  end
  writeln(m0);
  writeln(b0)
end.
