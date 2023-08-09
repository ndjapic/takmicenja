program dsu;
var
    n, v: int32;
    dsu, size: array [1 .. maxn] of int32;

function find(v: int32): int32;
begin
    if dsu[dsu[v]] <> dsu[v] then dsu[v] := find(dsu[v]);
    find := dsu[v];
end;

procedure union2(u, v: int32);
begin
    dsu[v] := u;
    inc(size[u], size[v]);
end;

procedure union1(u, v: int32);
begin
    u := find(u);
    v := find(v);
    if u = v then
    else if size[u] > size[v] then
        union2(u, v)
    else
        union2(v, u);
end;

begin
    readln(n);

    for v := 1 to n do begin
        dsu[v] := v;
        size[v] := 1;
    end;
end.
