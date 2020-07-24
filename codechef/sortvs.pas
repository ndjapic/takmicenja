program sortvs;
const
    htsz = 1024 * 1024;
    pqsz = 4096 * 1024;
type
    tswap = record
        x, y, t: integer;
    end;
    permutation = array [1 .. 18] of integer;
    unfreed: array [1 .. 153] of boolean;
    vertex = record
        f, g, h, id, hh, prev, next: integer;
        p: permutation;
        s: unfreed;
    end;
var
    tests, n, m, i, j, swaplen, pqlen: integer;
    x, y, t, hh: integer;
    si: integer;
    p: permutation;
    u, v: vertex;
    unfr: unfreed;
    time: array [1 .. 18, 1 .. 18] of integer;
    swaps: array [1 .. 153] of tswap;
    ht: array [0 .. htsz] of integer;
    pq: array [1 .. pqsz] of vertex;
    visfalse: array [1 .. 18] of boolean;

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

function heu(): integer;
var
    cnttime: integer;
    zerocyc: boolean;
    visited: array [1 .. 18] of boolean;

begin
    visited := visfalse;
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

procedure heapup(i: integer);
var
    pa: integer;

begin
        pa := i div 2;
        while (pa > 0) and (v.f < pq[pa].f) do begin
            prev := pq[pa].prev;
            if prev = 0 then
                ht[pq[pa].hh] := i
            else
                pq[prev].next := i;
            next := pq[pa].next;
            if next <> 0 then pq[next].prev := i;
            pq[i] := pq[pa];
            i := pa;
            pa := i div 2;
        end;
        if v.prev = 0 then
            ht[v.hh] := i
        else
            pq[v.prev].next := i;
        if v.next <> 0 then pq[v.next].prev := i;
        pq[i] := v;
end;

procedure heapdn(i: integer);
var
    ch, ri: integer;
    w: vertex;

begin
    ch := 2 * i;
    while ch <= pqlen do begin
        ri := ch + 1;
        if (ri <= pqlen) and (pq[ri].f < pq[ch].f) then ch := ri;
        w := pq[ch];
        if w.prev = 0 then
            ht[w.hh] := i
        else
            pq[w.prev].next := i;
        if w.next <> 0 then pq[w.next].prev := i;
        pq[i] := w;
        i := ch;
        ch := 2 * i;
    end;
    heapup(i);
end;

procedure heappush();
var
    i, pa, prev, next: integer;

begin
    v.id := perord();
    v.hh := hash(id);
    i := ht[v.hh];

    if i = 0 then begin
        inc(pqlen);
        i := pqlen;
        ht[v.hh] := i;
        v.prev := 0;
        v.next := 0;
        v.s := unfr;
        v.s[si] := false;
    end else begin
        repeat
            v.prev := i;
            i := pq[i].next;
        until (i = 0) or (pq[i].id = v.id);
        if i = 0 then begin
            inc(pqlen);
            i := pqlen;
            pq[v.prev].next := i;
            v.next := 0;
            v.s := unfr;
            v.s[si] := false;
        end else if v.g < pq[i].g then begin
            pq[i].g := v.g;
            v := pq[i];
            v.s[si] := false;
        end else begin
            v := pq[i];
        end;
    end;

    if v.s[si] then begin
        pq[i].s[si] := false;
    end else begin
        v.h := heu();
        v.f := v.g + v.h;
        heapup(i);
    end;

end;

function heappop(): boolean;
var
    i: integer;

begin
    u := pq[1];
    if u.prev = 0 then
        ht[u.hh] := u.next
    else
        pq[u.prev].next := u.next;
    if u.next <> 0 then pq[u.next].prev := u.prev;

    v := pq[pqlen];
    dec(pqlen);
    heapdn(1);

    i := 1;
    while (i <= n) and (u.p[i] = i) do inc(i);
    heappop := (i <= n);
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
    for hh := 1 to htsz do ht[hh] := 0;
    for i := 1 to n do visfalse[i] := false;

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
        unfr[si] := true;
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
        u.s := unfr;
        heappush();
        si := 0;
        while heappop() do
        for si := 1 to swaplen do
        if u.s[si] then begin
            v := u;
            swapvases(si);
            heappush();
        end;

        writeln(v.g div 60);

        dec(tests);
    until tests = 0;
end.
