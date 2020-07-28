program sortvs;
const
    htsz = 1024 * 1024;
    pqsz = 4096 * 1024;
type
    tswap = record
        x, y, t: integer;
    end;
    permutation = array [1 .. 18] of integer;
    tvisited = array [1 .. 18] of boolean;
    unfreed = array [0 .. 153] of boolean;
    vertex = record
        f, g, h, id, hh, prev, next: integer;
        p: permutation;
        s: unfreed;
    end;
var
    tests, n, m, i, swaplen, pqlen: integer;
    x, y, t, hh: integer;
    si: integer;
    u, v: vertex;
    unfr: unfreed;
    time: array [1 .. 18, 1 .. 18] of integer;
    swaps: array [1 .. 153] of tswap;
    ht: array [0 .. htsz] of integer;
    pq: array [1 .. pqsz] of vertex;
    visfalse: tvisited;

function perord(): integer;
var
    i, j, id: integer;
begin
    id := 0;
    for i := 1 to n - 1 do begin
        inc(id, v.p[i] - 1);
        for j := 1 to i - 1 do
            if v.p[j] <= v.p[i] then dec(id);
        id := id * (n - i);
    end;
    perord := id;
end;

function hash(i: integer): integer;
begin
    hash := i mod htsz;
end;

function heu(): integer;
var
    cnttime: integer;
    zerocyc: boolean;
    visited: tvisited;

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

procedure heapmove(source, destination: integer);
var
    v: vertex;
begin
    v := pq[source];
    if v.prev = 0 then
        ht[v.hh] := destination
    else
        pq[v.prev].next := destination;
    v.next := pq[source].next;
    if v.next <> 0 then pq[v.next].prev := destination;
    pq[destination] := v;
end;

function heapup(spot, priority: integer): integer;
var
    pa: integer;
begin
    pa := spot div 2;
    while (pa > 0) and (pq[pa].f > priority) do begin
        heapmove(pa, spot);
        spot := pa;
        pa := spot div 2;
    end;
    heapup := spot;
end;

function heapdn(spot: integer): integer;
var
    ch, ri: integer;
begin
    ch := 2 * spot;
    while ch <= pqlen do begin
        ri := ch + 1;
        if (ri <= pqlen) and (pq[ri].f < pq[ch].f) then ch := ri;
        heapmove(ch, spot);
        spot := ch;
        ch := 2 * spot;
    end;
    heapdn := spot;
end;

procedure heappush();
var
    i: integer;

begin
    v.f := - 1;
    v.prev := 0;
    v.next := 0;
    v.s := unfr;
    v.id := perord();
    v.hh := hash(v.id);
    i := ht[v.hh];

    if i = 0 then begin
        inc(pqlen);
        i := pqlen;
        {ht[v.hh] := i;}
        v.h := heu();
    end else begin
        while (i <> 0) and (pq[i].id <> v.id) do begin
            v.prev := i;
            i := pq[i].next;
        end;
        if i = 0 then begin
            inc(pqlen);
            i := pqlen;
            {pq[v.prev].next := i;}
            v.h := heu();
        end else if v.g < pq[i].g then begin
            pq[i].g := v.g;
            v := pq[i];
            v.f := - 1;
        end else begin
            pq[i].s[si] := false;
        end;
    end;

    if v.f = - 1 then begin
        v.s[si] := false;
        v.f := n * v.g + v.h;
        pq[i] := v;
        heapmove(i, pqlen + 1);
        heapmove( pqlen + 1, heapup(i, v.f) );
    end;

end;

function heappop(): boolean;
begin
    u := pq[1];
    if u.prev = 0 then
        ht[u.hh] := u.next
    else
        pq[u.prev].next := u.next;
    if u.next <> 0 then pq[u.next].prev := u.prev;
    dec(pqlen);
    if pqlen > 0 then
        heapmove( pqlen + 1, heapup( heapdn(1), pq[pqlen + 1].f ) );
    heappop := (u.id <> 0);
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
end;

procedure init();
var
    i, x, y, t, si, hh: integer;
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

        v.g := 0;
        si := 0;
        heappush();
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
