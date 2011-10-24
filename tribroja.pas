var a,b,c,x,y,z: longint; s: string;
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
  ...
end.