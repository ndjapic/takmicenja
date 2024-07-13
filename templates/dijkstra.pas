program dijkstra;
(*
* https://codeforces.com/problemset/problem/20/C
* It is possible that the graph has loops
* and multiple edges between pair of vertices.
*)
const
    nn = 100 * 1000;
    inf = 1000 * 1000 * 1000 * 1000 * 1000 * 1000;
type
    tpq = int32;
var
    n, m, i, u, v, s, t, k: int32;
    adj, par, wei, pos, rev: array [1 .. nn] of int32;
    d: array [1 .. nn] of int64;
    sib, tar: array [-nn .. nn] of int32;
    pq: record
        a: array of int32;
        n: int32;
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

function prior(l, r: tpq): boolean;
begin
    prior := d[l] < d[r];
end;

procedure pqset(v: int32; x: tpq);
begin
    pq.a[v] := x;
    pos[x] := v;
end;

procedure pqswim(v: int32; x: tpq);
var
    u: int32;
begin
    u := v div 2;
    while (v > 1) and prior(x, pq.a[u]) do begin
        pqset(v, pq.a[u]);
        v := u;
        u := v div 2;
    end;
    pqset(v, x);
end;

procedure pqins(x: tpq);
begin
    inc(pq.n);
	if length(pq.a) <= pq.n then setlength(pq.a, 2 * pq.n);
    pqswim(pq.n, x);
end;

procedure pqsink(u: int32, x: tpq);
var
    v: int32;
begin
    v := u * 2;
    if (v+1 <= pq.n) and prior(pq.a[v+1], pq.a[v]) then inc(v);
    while (v <= pq.n) and prior(pq.a[v], x) do begin
        pqset(u, pq.a[v]);
        u := v;
        v := u * 2;
        if (v+1 <= pq.n) and prior(pq.a[v+1], pq.a[v]) then inc(v);
    end;
    pqset(u, x);
end;

procedure pqdel(u: int32);
begin
    dec(pq.n);
    pqsink(u, pq.a[pq.n + 1]);
end;

begin
    readln(n, m);
    readedges(n, m);

	setlength(pq.a, 1);
	for v := 1 to n do d[v] := inf;
	s := 1;
	d[s] := 0;
    pq.n := 0;
    for v := 1 to n do pqins(v);

	while pq.n > 0 do begin

		u := pq.a[1];
		pqdel(1);

		i := adj[u];
		while i <> 0 do begin
			v := tar[i];
			if d[v] > d[u] + wei[abs(i)] then begin
                par[v] := u;
				d[v] := d[u] + wei[abs(i)];
				pqswim(pos[v], v);
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
