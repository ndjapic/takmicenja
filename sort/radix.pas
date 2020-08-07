program tsort;
const
    ten6 = 1000 * 1000;
    base = 1001;
type
    integer = longint;
var
    t, n, i, j, r: integer;
    a, b, c, next: array [1 .. ten6] of integer;
    top: array [0 .. base] of integer;

begin
    for r := 0 to base do top[r] := 0;
    readln(t);

    for i := 1 to t do begin
        readln(n);
        a[i] := n;
        r := n mod base;
        next[i] := top[r];
        top[r] := i;
    end;

    r := base - 1;
    for j := t downto 1 do begin
        while top[r] = 0 do dec(r);
        i := top[r];
        top[r] := next[i];
        b[j] := a[i];
    end;

    for i := 1 to t do begin
        r := b[i] div base;
        next[i] := top[r];
        top[r] := i;
    end;

    r := base - 1;
    for j := t downto 1 do begin
        while top[r] = 0 do dec(r);
        i := top[r];
        top[r] := next[i];
        c[j] := b[i];
    end;

    for i := 1 to t do writeln(c[i]);
end.
