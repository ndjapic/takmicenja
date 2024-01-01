program gcd;

function gcd(a, b: int64): int64;
begin
    if b = 0 then
        gcd := a
    else
        gcd := gcd(b, a mod b);
end;

function bin_gcd(a, b: int64): int64;
var
    c: int64;
    e: int8;
begin
    c := a or b;
    e := 0;
    while not odd(c) do begin
        c := c shr 1;
        inc(e);
    end;

    a := a shr e;
    b := b shr e;
    while (a > 0) and (b > 0) do
        if not odd(a) then
            a := a shr 1
        else if not odd(b) then
            b := b shr 1
        else if a > b then
            dec(a, b)
        else
            dec(b, a);

    bin_gcd := (a+b) shl e;
end;

function lcm(a, b: int64): int64;
begin
    lcm := a div gcd(a, b) * b;
end;

begin
end.
