program sortvs;
const
    htsz = 1024 * 1024;
    pqsz = 4096 * 1024;
type
    tswap = record
        x, y, t: integer;
    end;
    permutation = array [1 .. 18] of integer;
var
    tests, n, m, i, j, swaplen, pqlen: integer;
    x, y, t, mintime, minswaps: integer;
    f, g, h, id, nx: integer;
    p: permutation;
    time: array [1 .. 18, 1 .. 18] of integer;
    swaps: array [1 .. 153] of tswap;
    ht: array [0 .. htsz] of integer;
    pq: array [1 .. pqsz] of record
        f, g, h, id, nx: integer;
        p: permutation;
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
            if time[i, p[i]] = 1 then begin
                if zerocyc then
                    zerocyc := false
                else
                    inc(cnttime);
            end;
            i := p[i];
        end;
        inc(i);
    end;
    heu := cnttime;
end;

function perord(): integer;
var
    i, j, id: integer;
begin
    id := p[1] - 1;
    for i := 2 to n - 1 do begin
        id := id * (n - i + 1);
        inc(id, p[i] - 1);
        for j := 1 to i - 1 do
            if p[j] < p[i] then dec(id);
    end;
    order := id;
end;

procedure heappush();
var
    i: integer;
begin
    id := perord();
    i := ht[id mod sz];
    while (i <> 0) and (pq[i].id <> id) do i := pq[i].nx;
    if i = 0 then begin
        inc(pqlen);
        i := pqlen;
        pq[i].p := p;
        pq[i].h := h;
        pq[i].g := g;
        pq[i].f := g + h;
        pq[i].si := j;
        heapup(i);
    end else if g < pq[i].g then begin
        pq[i].g := g;
        pq[i].f := g + h;
        pq[i].si := j;
        heapup(i);
    end;
end;

function isreached(): boolean;
var
    i: integer;
begin
    heappop();
    i := 1;
    while (i <= n) and (p[i] = i) do inc(i);
    isreached := (i > n);
end;

procedure doswap(s: tswap, takeback: boolean);
var
    swap: integer;
begin
    swap := p[s.x];
    p[s.x] := p[s.y];
    p[s.y] := swap;
    if s.t <> 0 then begin
        if takeback then
            dec(g, s.t)
        else begin
            inc(g, s.t);
            h := heu();
            f := g + h;
        end;
    end;
end;

begin
    readln(tests);
    repeat
        for i := 1 to htsz do ht[i] := 0;
        readln(n, m);
        for i := 1 to n do read(p[i]); readln;

        for x := 1 to n do
            for y := 1 to n do
                if x = y then
                   time[x, y] := 0
                else
                   time[x, y] := 1;

        while m > 0 do begin
            readln(x, y);
            time[x, y] := 0;
            time[y, x] := 0;
            dec(m);
        end;

        j := 0;
        for t := 0 to 1 do
        for x := 1 to n do
        for y := x + 1 to n do
        if time[x, y] = t then begin
            inc(j);
            swaps[j].x := x;
            swaps[j].y := y;
            swaps[j].t := t;
        end;
        swaplen := j;

        pqlen := 0;
        g := 0;
        h := heu();
        f := g + h;
        heappush();
        while not isreached() do
            for j := 1 to swaplen do begin
                doswap(swaps[j], false);
                heappush();
                doswap(swaps[j], true);
            end;

        writeln(g);

        dec(tests);
    until tests = 0;
end.
