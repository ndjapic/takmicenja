program F_Rotation_Puzzle;
uses
    math;
const
    maxq = 2048 * 2048 div 3 + 1; (* dont need +1 ? *)
var
    h, w, hw, i, j, k, x, y, c, dif: int8;
    d: int32;
    l, r: array [1 .. 2] of int32;
    bfs: array [1 .. 2, 1 .. maxq] of record
        s: array [1 .. 64] of int8;
        d: int32;
    end;
    p: array [1 .. 2, 1 .. maxq] of int32;
    merge: array [1 .. maxq] of int32;

function ij(i, j: int8): int8;
begin
    ij := (i-1)*w+j;
end;

function leq(c: int8; i, j: int32): boolean;
var
    k: int8;
begin
    k := 1;
    while (k <= hw) and (bfs[c, i].s[k] = bfs[c, j].s[k]) do inc(k);
    leq := (k > hw) or (bfs[c, i].s[k] <= bfs[c, j].s[k]);
end;

procedure msort(c: int8; l, r: int32);
var
    m, i, j, k: int32;
begin
    if r-l > 1 then begin

        m := (l+r) div 2;
        msort(c, l, m);
        msort(c, m, r);

        j := l;
        k := m;
        for i := l to r-1 do
            if (k = r) or (j < m) and leq(c, p[c, j], p[c, k]) then begin
                merge[i] := p[c, j];
                inc(j);
            end else begin
                merge[i] := p[c, k];
                inc(k);
            end;

        for i := l to r-1 do p[c, i] := merge[i];

    end;
end;

function cmp(c1, c2: int8; i1, i2: int32): int8;
var
    k: int8;
begin
    k := 1;
    while (k <= hw) and (bfs[c1, p[c1, i1]].s[k] = bfs[c2, p[c2, i2]].s[k]) do inc(k);
    if k <= hw then
        cmp := bfs[c1, p[c1, i1]].s[k] - bfs[c2, p[c2, i2]].s[k]
    else
        cmp := 0;
end;

begin
    readln(h, w);
    hw := h*w;

    for k := 1 to hw do bfs[1, 1].s[k] := k;

    for i := 1 to h do begin
        for j := 1 to w do read(bfs[2, 1].s[ij(i, j)]);
        readln;
    end;

    for c := 1 to 2 do begin

        l[c] := 1;
        r[c] := 1;
        bfs[c, 1].d := 0;

        while l[c] <= r[c] do begin
            if bfs[c, l[c]].d < 10 then
                for x := 0 to 1 do
                    for y := 0 to 1 do begin

                        inc(r[c]);
                        bfs[c, r[c]].d := bfs[c, l[c]].d + 1;
                        for k := 1 to hw do bfs[c, r[c]].s[k] := bfs[c, l[c]].s[k];

                        for i := 1 to h-1 do
                            for j := 1 to w-1 do
                                bfs[c, r[c]].s[ij(i+x, j+y)] := bfs[c, l[c]].s[ij(h-i+x, w-j+y)];

                    end;
            p[c, l[c]] := l[c];
            inc(l[c]);
        end;

        msort(c, 1, r[c]+1);

    end;

    d := 21;
    l[1] := 1;
    l[2] := 1;

    while (l[1] <= r[1]) and (l[2] <= r[2]) do begin
        dif := cmp(1, 2, l[1], l[2]);
        if dif = 0 then d := min(d, bfs[1, p[1, l[1]]].d + bfs[2, p[2, l[2]]].d);
        if dif <= 0 then inc(l[1]);
        if dif >= 0 then inc(l[2]);
    end;

    if d > 20 then d := -1;
    writeln(d);
end.
