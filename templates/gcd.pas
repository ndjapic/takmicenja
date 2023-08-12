program gcd;

function gcd(a, b: int64): int64;
begin
    if b = 0 then
        gcd := a
    else
        gcd := gcd(a mod b);
end;

function lcm(a, b: int64): int64;
begin
    lcm := a div gcd(a mod b) * b;
end;

begin
end.
