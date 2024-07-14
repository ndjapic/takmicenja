program dijkstra;
(*
* https://codeforces.com/problemset/problem/20/C
* It is possible that the graph has loops
* and multiple edges between pair of vertices.
*)
{$mode objfpc}
uses
    classes;
const
    nn = 100 * 1000;
    inf = 1000 * 1000 * 1000 * 1000 * 1000 * 1000;

type
    generic TPrioQueue<T> = class
    public
        a: array of T;
        n: int32;
        constructor Create();
        function prior(l, r: T): boolean;
        procedure pqset(v: int32; x: T);
        procedure swim(v: int32; x: T);
        procedure enqueue(x: T);
        procedure sink(u: int32; x: T);
        procedure dequeue(u: int32);
    end;
    {TPrioQueue32 = specialize TPrioQueue<int32>;}

var
    n, m, i, u, v, s, t, k: int32;
    adj, par, wei, pos, rev: array [1 .. nn] of int32;
    d: array [1 .. nn] of int64;
    sib, tar: array [-nn .. nn] of int32;
    {pq: TPrioQueue32;}
    pq: specialize TPrioQueue<int32>;

constructor TPrioQueue.Create();
begin
    setlength(a, 1);
    n := 0;
end;

function TPrioQueue.prior(l, r: T): boolean;
begin
    prior := d[l] < d[r];
end;

procedure TPrioQueue.pqset(v: int32; x: T);
begin
    a[v] := x;
    pos[x] := v;
end;

procedure TPrioQueue.swim(v: int32; x: T);
var
    u: int32;
begin
    u := v div 2;
    while (v > 1) and prior(x, a[u]) do begin
        pqset(v, a[u]);
        v := u;
        u := v div 2;
    end;
    pqset(v, x);
end;

procedure TPrioQueue.enqueue(x: T);
begin
    inc(n);
    if length(a) <= pq.n then setlength(a, 2*n);
    swim(n, x);
end;

procedure TPrioQueue.sink(u: int32; x: T);
var
    v: int32;
begin
    v := u * 2;
    if (v+1 <= n) and prior(a[v+1], a[v]) then inc(v);
    while (v <= n) and prior(a[v], x) do begin
        pqset(u, a[v]);
        u := v;
        v := u * 2;
        if (v+1 <= n) and prior(a[v+1], a[v]) then inc(v);
    end;
    pqset(u, x);
end;

procedure TPrioQueue.dequeue(u: int32);
begin
    dec(pq.n);
    sink(u, a[pq.n + 1]);
end;

procedure addarrow(u, v, i: int32);
begin
    sib[i] := adj[u];
    adj[u] := i;
    tar[i] := v;
end;

procedure readedges(n, m: int32);
var
    u, v, i: int32;
begin
    for v := 1 to n do adj[v] := 0;

    for i := 1 to m do begin
        readln(u, v, wei[i]);
        addarrow(u, v, i);
        addarrow(v, u, -i);
    end;
end;

begin
    readln(n, m);
    readedges(n, m);

	for v := 1 to n do d[v] := inf;
	s := 1;
	d[s] := 0;
    pq := TPrioQueue32.Create();
    for v := 1 to n do pq.enqueue(v);

	while pq.n > 0 do begin

		u := pq.a[1];
		pq.dequeue(1);

		i := adj[u];
		while i <> 0 do begin
			v := tar[i];
			if d[v] > d[u] + wei[abs(i)] then begin
                par[v] := u;
				d[v] := d[u] + wei[abs(i)];
				pq.swim(pos[v], v);
			end;
			i := sib[i];
		end;

	end;

    t := n;
	k := 1;
	if d[t] < inf then begin
		rev[k] := t;
		while rev[k] <> s do begin
			inc(k);
			rev[k] := par[rev[k-1]];
		end;
		for i := k downto 2 do write(rev[i], ' ');
	end else
		rev[1] := -1;

	writeln(rev[1]);
end.
