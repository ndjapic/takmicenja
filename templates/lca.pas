program lca;
const
    maxn = 100 * 1000;
    lg2maxn = 16;
var
    n, m, i, u, v, time: int32;
    adj, par, time1, time2: array [1 .. maxn] of int32;
    sib, tar: array [-maxn .. maxn] of int32;
    tour: array [1 .. 2*maxn] of int32;
    anc: array [1 .. maxn] of array [0 .. lg2maxn] of int32;

procedure addarrow(u, v, i: int32);
begin
    sib[i] := adj[u];
    adj[u] := i;
    tar[i] := v;
end;

procedure dfs(u: int32);
var
    i, v: int32;
    e: int8;
begin
    anc[u][0] := par[u];
    for e := 0 to lg2maxn-1 do anc[u][e+1] := anc[anc[u][e]][e];

    inc(time);
    tour[time] := u;
    time1[u] := time;

    i := adj[u];
    while i <> 0 do begin
        v := tar[i];
        if par[u] <> v then begin
            par[v] := u;
            dfs(v);
        end;
        i := sib[i];
    end;

    inc(time);
    tour[time] := u;
    time2[u] := time;
end;

function is_anc(u, v: int32): boolean;
begin
    is_anc := (time1[u] <= time1[v]) and (time2[v] <= time2[u]);
end;

function lca(u, v: int32): int32;
var
    e: int8;
begin
    if not is_anc(u, v) then begin
        for e := lg2maxn downto 0 do
            if not is_anc(anc[u][e], v) then
                u := anc[u][e];
        u := anc[u][0];
    end;
    lca := u;
end;

begin
    readln(n, m); (* m := n-1; (tree) *)

    for v := 1 to n do adj[v] := 0;

    for i := 1 to m do begin
        readln(u, v);
        addarrow(u, v, i);
        addarrow(v, u, -i);
    end;

    time := 0;
    par[1] := 1;
    dfs(1);
end.
