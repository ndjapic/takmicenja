program gcd;
const
    small_num = 8000;
var
    x, y: int32;
    gcd_memo: array [0 .. small_num, 0 .. small_num] of int32;

function gcd(a, b: int32): int32;
begin
    if a < b then
        gcd := gcd(b, a)
    else if a <= small_num then
        gcd := gcd_memo[a, b]
    else if not odd(a) then begin
        if not odd(b) then
            gcd := gcd(a shr 1, b shr 1) shl 1
        else
            gcd := gcd(a shr 1, b);
    end else if not odd(b) then
        gcd := gcd(a, b shr 1)
    else if a > b then
        gcd := gcd(a-b, b)
    else
        gcd := gcd(a, b-a);
end;

function lcm(a, b: int64): int64;
begin
    lcm := a div gcd(a, b) * b;
end;

begin
    for x := 1 to small_num do begin
        gcd_memo[x, 0] := x;
        for y := 1 to x do
            gcd_memo[x, y] := gcd_memo[y, x mod y];
    end;
end.
