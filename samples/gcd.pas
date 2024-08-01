program gcd;
const
    maxn = 200 * 1000;
var
    ntc, tci: int32;
    n, g, i: int32;
    a: array [1 .. maxn] of int32;

function gcd(a, b: int32): int32;
begin
    if b = 0 then
        gcd := a
    else
        gcd := gcd(b, a mod b);
end;

function lcm(a, b: int64): int64;
begin
    lcm := int64(a) div gcd(a, b) * b;
end;

begin
    readln(ntc);
    for tci := 1 to ntc do begin

        readln(n);

        g := 0;
        for tci := 1 to n do begin
            read(a[i]);
            g := gcd(g, a[i]);
        end;
        readln;

        writeln(g);

    end;
end.
