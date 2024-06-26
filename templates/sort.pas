program sort;
const
    maxn = 200 * 1000;
type
    tarr32 = array [1 .. maxn] of int32;
var
    n, i: int32;
    a, p, merge: tarr32;

function msort(lend, rend: int32; inversions: int64): int64;
var
    i, l, r, m: int32;
begin
    if rend - lend > 1 then begin

        m := (lend + rend) div 2;
        inversions := msort(lend, m, inversions);
        inversions := msort(m, rend, inversions);

        l := lend;
        r := m;
        for i := lend to rend - 1 do
            if (r = rend) or (l < m) and (a[l] <= a[r]) then begin
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
begin
    if rend - lend > 1 then begin

        m := (lend + rend) div 2;
        msorti(indices, priority, lend, m);
        msorti(indices, priority, m, rend);

        l := lend;
        r := m;
        for i := lend to rend - 1 do
            if (r = rend) or (l < m) and (
                (priority[indices[l]] >= priority[indices[r]]) {and (
                    (priority[indices[l]] > priority[indices[r]]) or
                    (indices[l] <= indices[r])
                )}
            ) then begin
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

    for i := 1 to n do begin
        read(a[i]);
        p[i] := i;
    end;
    readln;

    msorti(p, a, 1, n+1);
end.
