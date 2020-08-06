program prt2;
const
    nodesize = 300 * 1000;
    edgesize = 600 * 1000;
var
    tcases, n, k, i, root, u, v, uv: integer;
    hlen, q, r, mp: integer;
    a: array [1 .. nodesize] of integer;
    nodes: array [1 .. nodesize] of record
        parent, first, branch, path: integer;
    end;
    edges: array [1 .. edgesize] of record
        destination, next: integer;
    end;

procedure swap(i, j: integer);
var
    tmp: integer;
begin
    tmp := a[i];
    a[i] := a[j];
    a[j] := tmp;
end;

function prioch(pa: integer): integer;
var
    le, ri: integer;
begin
    le := pa * 2;
    ri := le + 1;
    if (ri <= hlen) and (a[ri] > a[le]) then
        prioch := ri
    else
        prioch := le;
end;

procedure siftdown(pa: integer);
var
    ch: integer;
begin
    ch := prioch(pa);
    while (ch <= hlen) and (a[ch] > a[pa]) do begin
        swap(pa, ch);
        pa := ch;
        ch := prioch(pa);
    end;
end;

procedure heapify();
var
    pa: integer;
begin
    for pa := hlen div 2 downto 1 do
        siftdown(pa);
end;

procedure heapop();
begin
    swap(1, hlen);
    dec(hlen);
    siftdown(1);
end;

procedure dfs(u: integer);
var
    uv, mp, mb1, mb2: integer;
begin
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

    if mb1 < n then
        nodes[u].branch := mb1 + 1
    else
        nodes[u].branch := 1;
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

        if n = 2 then
            mp := 2
        else begin
            root := 1 + random(n);
            uv := nodes[root].first;
            if edges[uv].next = 0 then
                root := edges[uv].destination;
            dfs(root);
            mp := nodes[root].path;
        end;

        heapify();
        a[n+1] := 0;
        for i := n downto n - mp + 1 do begin
            heapop();
            inc(a[i], a[i+1]);
        end;

        q := k div (2 * mp);
        r := k mod (2 * mp);
        writeln(q * a[n+1 - mp] + a[n+1 - r div 2] + a[n+1 - (r+1) div 2]);

        dec(tcases);
    until tcases = 0;
end.
