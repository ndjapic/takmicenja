program sort;
const
    maxn = 200 * 1000;
type
    tarr32 = array [1 .. maxn] of int32;
var
    n, i: int32;
    a, p, merge: tarr32;

function msort(l, r: int32; inversions: int64): int64;
var
    m, i, j, k: int32;
begin
    if r-l > 1 then begin

        m := (l+r) div 2;
        inversions := msort(l, m, inversions);
        inversions := msort(m, r, inversions);

        j := l;
        k := m;
        for i := l to r-1 do
            if (k = r) or (j < m) and (a[j] <= a[k]) then begin
                merge[i] := a[j];
                inc(j);
            end else begin
                merge[i] := a[k];
                inc(inversions, m-j);
                inc(k);
            end;

        for i := l to r-1 do a[i] := merge[i];

    end;
    msort := inversions;
end;

procedure msorti(var indices, priority: tarr32; l, r: int32);
var
    m, i, j, k: int32;
begin
    if r-l > 1 then begin

        m := (l+r) div 2;
        msorti(indices, priority, l, m);
        msorti(indices, priority, m, r);

        j := l;
        k := m;
        for i := l to r-1 do
            if (k = r) or (j < m) and (
                (priority[indices[j]] >= priority[indices[k]]) {and (
                    (priority[indices[j]] > priority[indices[k]]) or
                    (indices[j] <= indices[k])
                )}
            ) then begin
                merge[i] := indices[j];
                inc(j);
            end else begin
                merge[i] := indices[k];
                inc(k);
            end;

        for i := l to r-1 do indices[i] := merge[i];

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

    msorti(p, a, 1, n);
end.
