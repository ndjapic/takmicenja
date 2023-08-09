program sort;
const
    maxn = 200 * 1000;
var
    n, i: int32;
    a, p, cp: array [1 .. maxn] of int64;

procedure msort(l, r: int32);
var
    m, i, il, ir: int32;
begin
    if l < r then begin

        m := (l+r) div 2;
        msort(l, m);
        msort(m+1, r);

        il := l;
        ir := m+1;
        for i := l to r do
            if (ir > r) or (il <= m) and (a[p[il]] <= a[p[ir]]) then begin
                cp[i] := p[il];
                inc(il);
            end else begin
                cp[i] := p[ir];
                inc(ir);
            end;

        for i := l to r do p[i] := cp[i];

    end;
end;

function bisectr(x: int64): int32;
var
    l, r, m: int32;
begin
    l := 0;
    r := n+1;
    while r-l > 1 do begin
        m := (l+r) div 2;
        if x < a[m] then (* a[p[m]] *)
            r := m
        else
            l := m;
    end;
    bisectr := r;
end;

function numelm(x: int64): int32;
begin
    numelm := bisectr(x) - bisectr(x-1);
end;

begin
    readln(n);

    for i := 1 to n do begin
        read(a[i]);
        p[i] := i;
    end;
    readln;

    msort(1, n);
end.
