var
  a,b,c,x,y,z: longint;
  s: string;
begin
  readln(x,y,z);
  if x<y then begin
    if y<z then begin
      a:=x; b:=y; c:=z
    end else if x<z then begin
      a:=x; b:=z; c:=y
    end else begin
      a:=z; b:=x; c:=y
    end
  end else if x<z then begin
      a:=y; b:=x; c:=z
  end else if y<z then begin
      a:=y; b:=z; c:=x
  end else begin
      a:=z; b:=y; c:=x
  end;
  readln(s);
  if s='abc' then writeln(a,b,c) else
    if s='acb' then writeln(a,c,b) else
      if s='bac' then writeln(b,a,c) else
        if s='bca' then writeln(b,c,a) else
          if s='cab' then writeln(c,a,b) else
            if s='cba' then writeln(c,b,a)
end.