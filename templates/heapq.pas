program heapq;
const
    maxn = 200 * 1000;
var
    pq: record
        a: array [1 .. maxn] of int32;
        n: int32;
    end;

function prior(x, y: int32): boolean;
begin
    pqlt := x < y;
end;

procedure pqins(v, x: int32);
(* Usage: pqins(pq.n+1, x); *)
var
    u: int32;
begin
    u := v div 2;
    if (v > 1) and prior(x, pq.a[u]) then begin
        pq.a[v] := pq.a[u];
        pqins(u, x);
    end else begin
        pq.a[v] := x;
        inc(pq.n);
    end;
end;

procedure pqdel(u: int32);
(* Usage: pqdel(1); *)
var
    v: int32;
begin
    v := u * 2;
    if (v+1 <= pq.n-1) and prior(pq.a[v+1], pq.a[v]) then inc(v);
    if (v <= pq.n-1) and prior(pq.a[v], pq.a[pq.n]) then begin
        pq.a[u] := pq.a[v];
        pqdel(v);
    end else begin
        pq.a[u] := pq.a[pq.n];
        dec(pq.n);
    end;
end;

begin
    pq.n := 0;
    pqins(1 + pq.n, 4);
    pqins(1 + pq.n, 8);
    pqins(1 + pq.n, 16);
    pqins(1 + pq.n, 9);
    pqins(1 + pq.n, 27);
    pqins(1 + pq.n, 5);
    pqins(1 + pq.n, 25);

    while pq.n > 1 do begin
        write(pq.a[1], ' ');
        pqdel(1);
    end;

    writeln(pq.a[1]);
    pqdel(1);
end.
