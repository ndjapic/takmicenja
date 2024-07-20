program heapq;
{$mode objfpc}{$h+}
const
    nn = 100 * 1000;

type
    generic TPrioQueue<T> = class
    public
        items: array of T;
        n: int32;
        constructor Create();
        function prio(l, r: T): boolean;
        procedure setItem(v: int32; x: T);
        procedure swim(v: int32; x: T);
        procedure enqueue(x: T);
        function prioChild(u: int32): int32;
        procedure sink(u: int32; x: T);
        procedure dequeue(u: int32);
    end;
    iPrioQueue = specialize TPrioQueue<int32>;

var
    n, i: int32;
    a: array [1 .. nn] of int32;
    pq: iPrioQueue;

constructor TPrioQueue.Create();
begin
    setlength(items, 1);
    n := 0;
end;

function TPrioQueue.prio(l, r: T): boolean;
begin
    result := l < r;
end;

procedure TPrioQueue.setItem(v: int32; x: T);
begin
    items[v] := x;
end;

procedure TPrioQueue.swim(v: int32; x: T);
var
    u: int32;
begin
    u := v div 2;
    while (v > 1) and prio(x, items[u]) do begin
        setItem(v, items[u]);
        v := u;
        u := v div 2;
    end;
    setItem(v, x);
end;

procedure TPrioQueue.enqueue(x: T);
begin
    inc(n);
    if length(items) <= n then setlength(items, 2*n);
    swim(n, x);
end;

function TPrioQueue.prioChild(u: int32): int32;
var
    v: int32;
begin
    v := u * 2;
    if (v+1 <= n) and prio(items[v+1], items[v]) then inc(v);
    result := v;
end;

procedure TPrioQueue.sink(u: int32; x: T);
var
    v: int32;
begin
    v := prioChild(u);
    while (v <= n) and prio(items[v], x) do begin
        setItem(u, items[v]);
        u := v;
        v := prioChild(u);
    end;
    setItem(u, x);
end;

procedure TPrioQueue.dequeue(u: int32);
begin
    if length(items) >= 4*n then setlength(items, 2*n);
    dec(n);
    sink(u, items[n+1]);
end;

begin
    readln(n);
    pq := iPrioQueue.Create();

    for i := 1 to n do begin
        read(a[i]);
        pq.enqueue(a[i]);
        write(' ', a[i]);
    end;
    readln;
    writeln;

    for i := 1 to n do begin
        a[i] := pq.items[1];
        pq.dequeue(1);
        write(' ', a[i]);
    end;
    writeln;
end.

(*
10
2 8 32 128 512 1024 256 64 16 4
*)
