program sort;
{$mode objfpc}{$h+}{$j-}
const
    maxn = 200 * 1000;
type
    tarr32 = array of int32;
var
    n, i: int32;
    a, p, merge: tarr32;

function msort(lend, rend: int32; inversions: int64): int64;
var
    i, l, r, m: int32;

    function LessOrEqual(l, r: int32): boolean;
    begin
        {result := (a[l] <= a[r]) and ((a[l] < a[r]) or (l <= r));}
        result := a[l] <= a[r];
    end;

begin
    i := lend + 1;
    while (i < rend) and LessOrEqual(i-1, i) do inc(i);

    if i < rend then begin

        m := (lend + rend) div 2;
        if i < m then inversions := msort(lend, m, inversions);
        inversions := msort(m, rend, inversions);

        l := lend;
        r := m;
        for i := lend to rend - 1 do
            if (r = rend) or (l < m) and LessOrEqual(l, r) then begin
                merge[i] := a[l];
                inc(l);
            end else begin
                merge[i] := a[r];
                inc(inversions, m-l);
                inc(r);
            end;

        for i := lend to rend - 1 do a[i] := merge[i];

    end;
    msort := inversions;
end;

procedure msorti(var indices, priority: tarr32; lend, rend: int32);
var
    i, l, r, m: int32;

    function LessOrEqual(l, r: int32): boolean;
    begin
        result := (priority[l] <= priority[r]) and ((priority[l] < priority[r]) or (l <= r));
        {result := priority[l] <= priority[r];}
    end;

begin
    i := lend + 1;
    while (i < rend) and LessOrEqual(indices[i-1], indices[i]) do inc(i);

    if i < rend then begin

        m := (lend + rend) div 2;
        if i < m then msorti(indices, priority, lend, m);
        msorti(indices, priority, m, rend);

        l := lend;
        r := m;
        for i := lend to rend - 1 do
            if (r = rend) or (l < m) and LessOrEqual(indices[l], indices[r]) then begin
                merge[i] := indices[l];
                inc(l);
            end else begin
                merge[i] := indices[r];
                inc(r);
            end;

        for i := lend to rend - 1 do indices[i] := merge[i];

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
    setlength(a, n);
    setlength(merge, n);
    setlength(p, n);

    for i := 0 to n-1 do begin
        read(a[i]);
        p[i] := i;
    end;
    readln;

    msorti(p, a, 0, n);

    for i := 0 to n-2 do write(a[p[i]], ' '); writeln(a[p[n-1]]);
end.

(*
12
16 32 64 27 81 16 64 25 36 49 64 81
*)
