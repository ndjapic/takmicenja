program prt2;
const
    vmax = 300 * 1000;
var
    tcases, n, k, i, r, u, v, uv: integer;
    minbranch, minpath: integer;
    a: array [1 .. vmax] of integer;
    nodes: array [1 .. vmax] of record
        parent, first, branch, path: integer;
    end;
    edges: array [1 .. 2 * vmax] of record
        destination, next: integer;
    end;

procedure dfs(u: integer);
var
    uv, mp, mb1, mb2: integer;
begin
    nodes[u].branch := 1;
    mp := n;
    mb1 := n;
    mb2 := n;
    uv := nodes[u].first;

    while uv <> 0 do begin
        v := edges[uv].destination;

        if v <> nodes[u].parent then begin
            nodes[v].parent := u;

            dfs(v); (* RECURSION *)

            if nodes[v].branch <= mb1 then begin
                mb2 := mb1;
                mb1 := nodes[v].branch;
            end;
            mp := min(mp, nodes[v].path);
        end;

        uv := edges[uv].next;
    end;

    nodes[u].branch := mb1 + 1;
    nodes[u].path := min(mp, mb1 + 1 + mb2);
end;

begin
    readln(tcases);
    repeat

        readln(n, k);
        for u := 1 to n do begin
            read(a[u]);
            nodes[u].first := 0;
        end;
        readln;

        for uv := 1 to n - 1 do begin
            readln(u, v);

            edges[2 * uv].destination := v;
            edges[2 * uv].next := nodes[u].first;
            nodes[u].first := 2 * uv;

            edges[2 * uv + 1].destination := u;
            edges[2 * uv + 1].next := nodes[v].first;
            nodes[v].first := 2 * uv + 1;
        end;

        dfs(1);

        dec(tcases);
    until tcases = 0;
end.
