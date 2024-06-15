program mod;
const
    prime = 1000 * 1000 * 1000 + 7;
    maxn = 100 * 1000;
var
    n: int32;
    fact, invf: array [0 .. maxn] of int32;

function modmul(a, b: int32): int32;
begin
    modmul := int64(a) * b mod prime;
end;

function modpow(b, e: int32): int32;
begin
    if e = 0 then
        modpow := 1
    else if odd(e) then
        modpow := modmul(b, modpow(b, e-1))
    else
        modpow := modpow(modmul(b, b), e div 2);
end;

function ncr(n, r: int32): int32;
begin
    ncr := modmul(modmul(invf[r], invf[n-r]), fact[n]);
end;

procedure modinc(var a: int32; b: int32);
begin
    inc(a, b);
    if a >= prime then dec(a, prime);
end;

procedure moddec(var a: int32; b: int32);
begin
    dec(a, b);
    if a < 0 then inc(a, prime);
end;

begin
    fact[0] := 1;
    for n := 1 to maxn do fact[n] := modmul(n, fact[n-1]);
    invf[maxn] := modpow(fact[maxn], prime - 2);
    for n := maxn downto 1 do invf[n-1] := modmul(n, invf[n]);

end.
