program sortvs;
const
    htsz = 1024 * 1024;
    pqsz = 4096 * 1024;
    bottime = 1;
    humtime = 60;
type
    tswap = record
        x, y, t: integer;
    end;
    permutation = array [1 .. 18] of integer;
    tvisited = array [1 .. 18] of boolean;
    unfreed = array [1 .. 153] of boolean;
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

procedure assert(errcode: integer; condition: boolean);
begin
    if not condition then begin
        write('Error ', errcode, ': ');
        case errcode of
            1001: write('v.prev = 0');
            1002: write('heap overflow');
            1003: write('source not positive');
            1004: write('source overflow');
            1005: write('destination not positive');
            1006: write('destination overflow');
        end;
        writeln('.');
    end {else
        writeln(errcode, ' OK')};
end;

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

function hash(id: integer): integer;
begin
    hash := id mod htsz;
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
            if time[i, v.p[i]] = humtime then begin
                if zerocyc then
                    zerocyc := false
                else
                    inc(cnttime);
            end;
            i := v.p[i];
        end;
        inc(i);
    end;
    heu := cnttime * humtime;
end;

procedure heapget(source: integer);
begin
    assert(1003, source > 0);
    assert(1004, source <= pqsz);
    v := pq[source];
end;

procedure heapset(destination: integer);
begin
    assert(1005, destination > 0);
    assert(1006, destination < pqsz);
    pq[destination] := v;
end;

procedure heapmove(source, destination: integer);
begin
    v := pq[source];
    if v.prev = 0 then
        ht[v.hh] := destination
    else
        pq[v.prev].next := destination;
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
    i, source: integer;
begin
    assert(1002, pqsz - pqlen > 3);
    {for i := 1 to n do write(v.p[i], ' '); writeln('pushed');}
    v.id := perord();
    v.hh := hash(v.id);
    i := ht[v.hh];
    v.prev := 0;

    if i <> 0 then begin
        while (i <> 0) and (pq[i].id <> v.id) do begin
            v.prev := i;
            i := pq[i].next;
        end;
        if i <> 0 then begin
            if v.g < pq[i].g then begin
                pq[i].g := v.g;
                {heapget(i);}
                v := pq[i];
                v.s[si] := false;
                v.f := - 1;
            end else begin
                pq[i].s[si] := false;
                v.f := pq[i].f;
            end;
        end;
    end;

    if i = 0 then begin
        inc(pqlen);
        i := pqlen;
        v.next := 0;
        v.h := heu();
        v.f := - 1;
    end;

    if v.f = - 1 then begin
        source := pqlen + 1;
        if v.prev = 0 then
            ht[v.hh] := source
        else
            pq[v.prev].next := source;
        if v.next <> 0 then pq[v.next].prev := source;
        {v.f := v.id;}
        v.f := v.g + v.h;
        {writeln('heapset ', source);
        heapset(source);}
        pq[source] := v;
        heapmove( source, heapup(i, v.f) );
    end;

end;

function heappop(): boolean;
var
    leaf, f: integer;
begin
    u := pq[1];
    {for i := 1 to n do write(u.p[i], ' '); writeln('poped');}
    if u.prev = 0 then
        ht[u.hh] := u.next
    else
        pq[u.prev].next := u.next;
    if u.next <> 0 then pq[u.next].prev := u.prev;
    f := pq[pqlen].f;
    leaf := heapdn(1);
    dec(pqlen);
    if leaf <= pqlen then begin
        heapmove( pqlen + 1, heapup( leaf, f ) );
    end;
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
    v.s := unfr;
    v.s[si] := false;
    inc(v.g, s.t);
end;

procedure init();
var
    i, x, y, t, si, hh: integer;
begin
    for hh := 0 to htsz do ht[hh] := 0;
    for i := 1 to n do visfalse[i] := false;

    for x := 1 to n do
    for y := x + 1 to n do
        time[x, y] := humtime;

    while m > 0 do begin
        readln(x, y);
        if x < y then
            time[x, y] := bottime
        else if y < x then
            time[y, x] := bottime;
        dec(m);
    end;

    si := 0;
    for t := 0 to 1 do
    for x := 1 to n do
    for y := x + 1 to n do
    if time[x, y] = humtime * t + bottime * (1 - t) then begin
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
        v.s := unfr;
        heappush();
        while heappop() do
        for si := 1 to swaplen do
        if u.s[si] then begin
            v := u;
            swapvases(si);
            heappush();
        end;

        writeln(v.g div humtime);

        dec(tests);
    until tests = 0;
end.
