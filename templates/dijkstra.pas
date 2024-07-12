program dijkstra;
(*
* https://codeforces.com/problemset/problem/20/C
* It is possible that the graph has loops
* and multiple edges between pair of vertices.
*)
const
    nn = 100 * 1000;
    inf = 1000 * 1000 * 1000 * 1000 * 1000 * 1000;
var
    n, m, i, u, v, s, t, k: int32;
    adj, par, wei, p, ans: array [1 .. nn] of int32;
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

function prior(l, r: int32): boolean;
begin
    prior := d[l] < d[r];
end;

procedure pqins(v: int32; x: int32);
(* Usage: pqins(pq.n+1, x); *)
var
    u: int32;
begin
    u := v div 2;
    if (v > 1) and prior(x, pq.a[u]) then begin
        pq.a[v] := pq.a[u];
        p[pq.a[v]] := v;
        pqins(u, x);
    end else begin
		if length(pq.a) <= v then setlength(pq.a, 2*v);
        pq.a[v] := x;
        p[x] := v;
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
        p[pq.a[u]] := u;
        pqdel(v);
    end else begin
        pq.a[u] := pq.a[pq.n];
        p[pq.a[u]] := u;
        dec(pq.n);
    end;
end;

begin
    readln(n, m);
    readedges(n, m);

	setlength(pq.a, 1);
	for v := 1 to n do d[v] := inf;
	s := 1;
	d[s] := 0;
    pq.n := 0;
    for v := 1 to n do pqins(1 + pq.n, v);

	while pq.n > 0 do begin

		u := pq.a[1];
		pqdel(1);

		i := adj[u];
		while i <> 0 do begin
			v := tar[i];
			if d[v] > d[u] + wei[abs(i)] then begin
                par[v] := u;
				d[v] := d[u] + wei[abs(i)];
				pqins(p[v], v);
                dec(pq.n);
			end;
			i := sib[i];
		end;

	end;

    t := n;
	k := 1;
	if d[t] < inf then begin
		ans[k] := t;
		while ans[k] <> s do begin
			inc(k);
			ans[k] := par[ans[k-1]];
		end;
		for i := k downto 2 do write(ans[i], ' ');
	end else
		ans[1] := -1;

	writeln(ans[1]);
end.
