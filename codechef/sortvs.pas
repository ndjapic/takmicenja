program sortvs;
const
    htsz = 1024 * 1024;
    pqsz = 4096 * 1024;
    colisionfree = 0;
type
    tswap = record
        x, y, t: integer;
    end;
    permutation = array [1 .. 18] of integer;
    unvisited: array [1 .. 153] of boolean;
    vertex = record
        f, g, h, id, hh, prev, next: integer;
        p: permutation;
        s: unvisited;
    end;
var
    tests, n, m, i, j, swaplen, pqlen: integer;
    x, y, t, hh: integer;
    f, g, h, id, nx: integer;
    p: permutation;
    u, v: vertex;
    unv: unvisited;
    time: array [1 .. 18, 1 .. 18] of integer;
    swaps: array [1 .. 153] of tswap;
    ht: array [0 .. htsz] of integer;
    pq: array [1 .. pqsz] of vertex;

function perord(): integer;
var
    i, j, id: integer;
begin
    id := 0;
    for i := 1 to n - 1 do begin
        inc(id, p[i] - 1);
        for j := 1 to i - 1 do
            if p[j] <= p[i] then dec(id);
        id := id * (n - i);
    end;
    perord := id + 1;
end;

function hash(i: integer): integer;
begin
    hash := i mod htsz + 1;
end;

procedure heapup(i: integer, v: vertex);
const
    swloc = 0;
var
    j, prev: integer;
begin
    j := i div 2;
    while (j > 0) and (v.f < pq[j].f) do begin
        prev := ht[pq[j].hh];
        while pq[prev].nx <> j do prev := pq[prev].nx;
        if prev = j then begin
            ht[pq[j].hh] := i;
        end else
        pq[i] := pq[j];
        i := j;
        j := i div 2;
    end;
    reloc();
    pq[i] := v;
end;

function heu(): integer;
var
    cnttime: integer;
    zerocyc: boolean;
    visited: array [1 .. 18] of boolean;

begin
    for i := 1 to n do visited[i] := false;
    cnttime := 0;
    i := 1;
    while i <= n do begin
        zerocyc := true;
        while not visited[i] do begin
            visited[i] := true;
            if time[i, v.p[i]] = 1 then begin
                if zerocyc then
                    zerocyc := false
                else
                    inc(cnttime);
            end;
            i := v.p[i];
        end;
        inc(i);
    end;
    heu := cnttime;
end;

procedure appendvertex(g, si: integer);
var
    v: vertex;
begin
    v.g := g;
    v.h := heu();
    v.f := g + v.h;
    v.id := perord();
    v.hh := hash(v.id);
    v.si := si;
    v.nx := ht[v.hh];
    inc(pqlen);
    ht[hh] := pqlen;
    pq[pqlen] := v;
    heapup(pqlen);
end;

procedure updatevertex(i, g, si: integer);
var
    v: vertex;
begin
    v := pq[i];
    if g < v.g then begin
        v.g := g;
        v.f := g + v.h;
        v.si := si;
        pq[i] := v;
        heapup(i);
    end;
end;

procedure heappush();
var
    i, j: integer;
begin
    v.id := perord();
    v.hh := hash(id);
    i := ht[v.hh];

    if i = colisionfree then begin
        inc(pqlen);
        i := pqlen;
        ht[v.hh] := i;
        v.prev := colisionfree;
        v.next := colisionfree;
    end else begin
        repeat
            v.prev := i;
            i := pq[i].next;
        until (i = colisionfree) or (pq[i].id = id);
        if i = colisionfree then begin
            inc(pqlen);
            i := pqlen;
            pq[v.prev].next := i;
            v.next := colisionfree;
        end else begin
            v := pq[i];
        end;
    end;

    if v.s[si] then begin
        v.s[si] := false;
        v.h := heu();
        v.f := v.g + v.h;
    end;

end;

function notreached(): boolean;
var
    i: integer;
begin
    heappop();
    i := 1;
    while (i <= n) and (p[i] = i) do inc(i);
    notreached := (i <= n);
end;

procedure swapvases(si: integer);
var
    tmp: integer;
    s: tswap;
begin
    s := swaps[si];
    tmp := v.p[s.x];
    v.p[s.x] := v.p[s.y];
    v.p[s.y] := tmp;
    inc(v.g, s.t);
    v.s[si] := false;
end;

procedure init();
var
    x, y, t, si, hh: integer;
begin
    for hh := 1 to htsz do ht[hh] := colisionfree;

    for x := 1 to n do
    for y := 1 to n do
    if x = y then
        time[x, y] := 1
    else
        time[x, y] := 60;

    while m > 0 do begin
        readln(x, y);
        time[x, y] := 1;
        time[y, x] := 1;
        dec(m);
    end;

    si := 0;
    for t := 0 to 1 do
    for x := 1 to n do
    for y := x + 1 to n do
    if time[x, y] = 59 * t + 1 then begin
        inc(si);
        swaps[si].x := x;
        swaps[si].y := y;
        swaps[si].t := time[x, y];
        unv[si] := true;
    end;
    swaplen := si;
    pqlen := 0;
end;

begin
    readln(tests);
    repeat
        readln(n, m);
        for i := 1 to n do read(v.p[i]); readln;
        init();

        u.g := 0;
        u.s := unv;
        heappush();
        si := 0;
        while notreached() do
        for si := 1 to swaplen do
        if u.s[si] then begin
            v := u;
            v.s := unv;
            swapvases(si);
            heappush();
        end;

        writeln(v.g div 60);

        dec(tests);
    until tests = 0;
end.
