program counting_fractions_in_a_range;
const
    maxd = 2000 * 1000;
var
    a, d, n, y: int32;
    s: int64;
    pd: array [1 .. maxd] of array of int32;

procedure sieve_prime_divisors();
var
    n, p: int32;
begin
    for n := 1 to maxd do setlength(pd[n], 0);
    for p := 2 to maxd do
        if length(pd[p]) = 0 then begin
            n := p;
            while n <= maxd do begin
                setlength(pd[n], length(pd[n]) + 1);
                pd[n][length(pd[n]) - 1] := p;
                inc(n, p);
            end;
        end;
end;

function num_rel_prime(n, d: int32; i: int8): int32;
var
    p: int32;
begin
    if i < length(pd[n]) then begin
        p := pd[n][i];
        num_rel_prime :=
            num_rel_prime(n, d, i+1) -
            num_rel_prime(n, d div p, i+1);
    end else
        num_rel_prime := d;
end;

begin
    sieve_prime_divisors();
    readln(a, d);

    s := 0;

    n := 1;
    y := a;
    while y <= d do begin
        inc(s, num_rel_prime(n, d, 0) - num_rel_prime(n, y, 0));
        inc(n);
        inc(y, a);
    end;

    n := 1;
    y := a+1;
    while y-1 <= d do begin
        dec(s, num_rel_prime(n, d, 0) - num_rel_prime(n, y-1, 0));
        inc(n);
        inc(y, a+1);
    end;

    writeln(s);
end.
