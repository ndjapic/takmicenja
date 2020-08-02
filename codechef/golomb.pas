program golomb;
const
    ten5 = 1000 * 100;
    ten9 = 1000 * 1000 * 1000;
    ten10 = sqr(ten5);
    bigprime = ten9 + 7;
    igsz = 100 * 100;
    debug = false;
var
    tcases, n, i, l, r, iglen: integer;
    g, ig, sg, s2g: array [1 .. igsz] of integer;

function moddif(a, b: integer): integer;
begin
    if a < b then
        moddif := a - b + bigprime
    else
        moddif := a - b;
end;

function modmul(a, b: integer): integer;
begin
    modmul := a * b mod bigprime;
end;

function sumsqr(n: integer): integer;
var
    n1, n2: integer;
begin
    n1 := n * (n + 1) div 2;
    n2 := 2 * n + 1;

    if n1 mod 3 = 0 then
        n1 := n1 div 3
    else
        n2 := n2 div 3;

    sumsqr := modmul(n1, n2);
end;

function iginv(n: integer): integer;
var
    k, lo, hi: integer;
begin
    lo := 1;
    hi := iglen;
    while lo < hi do begin
        k := (lo + hi) div 2;
        if n > ig[k] then
            lo := k + 1
        else
            hi := k;
    end;
    iginv := lo;
end;

function gfun(n, k: integer): integer;
begin
    gfun := sg[k] - (ig[k] - n) div k;
end;

function s2gfun(n: integer): integer;
var
    k, val, r: integer;
begin
    k := iginv(n);
    val := gfun(n, k);
    r := (ig[k] - n) mod k;
    s2gfun := moddif(
        s2g[k],
        moddif(
            modmul(sumsqr(sg[k]), k),
            moddif(
                modmul(sumsqr(val), k),
                modmul(sqr(val), r)
            )
        )
    );
end;

procedure init();
var
    i: integer;
begin
    g[1] := 1;
    ig[1] := 1;
    sg[1] := 1;
    s2g[1] := 1;

    i := 1;
    while (i < igsz) and (ig[i] < ten10) do begin
        inc(i);
        g[i] := 1 + g[ i - g[g[i-1]] ];
        ig[i] := ig[i-1] + i * g[i];
        sg[i] := sg[i-1] + g[i];
        s2g[i] := (
            s2g[i-1] + i * moddif(
                sumsqr(sg[i]),
                sumsqr(sg[i-1])
            )
        ) mod bigprime;
    end;
    iglen := i;

    if debug then begin
        dec(i); writeln('ig[ ', i, ' ] = ', ig[i]);
        inc(i); writeln('ig[ ', i, ' ] = ', ig[i]);

        for i := 1 to 9 do begin
            write('s2g( ', i, ' ) = ', s2gfun(i));
            writeln('  ***  s2g[ ', i, ' ] = ', s2g[i]);
        end;

        i := 1;
        while i < ten10 do begin
            i := i * 10;
            writeln( 'g( ', i, ' ) = ', gfun(i, iginv(i)) );
        end;
    end;
end;

begin
    init();
    readln(tcases);
    repeat
        readln(l, r);
        if l = 1 then
            writeln( s2gfun(r) )
        else
            writeln( moddif( s2gfun(r), s2gfun(l-1) ) );
        dec(tcases);
    until tcases = 0;
end.
