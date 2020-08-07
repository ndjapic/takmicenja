program prt2;
const
    nodesize = 300 * 1000;
    edgesize = 600 * 1000;
    debug = false;
var
    tcases, n, k, i, root, u, v, uv: integer;
    hlen, qot, rem, path, ans: integer;
    a: array [1 .. nodesize + 1] of integer;
    nodes: array [1 .. nodesize] of record
        parent, first, branch, branch2, path: integer;
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
    {if debug then writeln('at prioch ri = ', ri);}
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
    {if debug then writeln('at heapify hlen = ', hlen);}
    for pa := hlen div 2 downto 1 do siftdown(pa);
end;

procedure heapop();
begin
    if debug then writeln('at pop hlen = ', hlen);
    swap(1, hlen);
    dec(hlen);
    siftdown(1);
end;

procedure dfs(u: integer);
var
    uv: integer;
begin
    nodes[u].path := n;
    nodes[u].branch := n;
    nodes[u].branch2 := n;
    uv := nodes[u].first;

    while uv <> 0 do begin
        v := edges[uv].destination;
        if v <> nodes[u].parent then begin
            nodes[v].parent := u;

            if debug then writeln('bef uv = ', uv);
            dfs(v); (* RECURSION *)
            if debug then writeln('aft uv = ', uv);

            if nodes[v].branch <= nodes[u].branch then begin
                nodes[u].branch2 := nodes[u].branch;
                nodes[u].branch := nodes[v].branch;
            end;
            nodes[u].path := min(nodes[u].path, nodes[v].path);
        end;
        uv := edges[uv].next;
    end;

    nodes[u].path := min(
        nodes[u].path,
        nodes[u].branch + 1 +
        nodes[u].branch2
    );

    if nodes[u].branch < n then
        inc(nodes[u].branch)
    else
        nodes[u].branch := 1;

    if debug then
        writeln(
            'u = ', u,
            ', branch = ', nodes[u].branch,
            ', branch2 = ', nodes[u].branch2,
            ', path = ', nodes[u].path
        );
end;

begin
    randomize;
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

        for u := 1 to n do begin
            uv := nodes[u].first;
            if debug then
                write('u = ', u);
            repeat
                if debug then
                    write(', uv = ', uv,
                        '->', edges[uv].destination);
                uv := edges[uv].next;
            until uv = 0;
            if debug then
                writeln;
        end;

        if n = 2 then
            path := 2
        else begin
            root := 1 + random(n);
            {if debug then
                writeln('root = ', root);}
            uv := nodes[root].first;
            if edges[uv].next = 0 then
                root := edges[uv].destination;
            {if debug then
                writeln('root = ', root);}
            nodes[root].parent := 0;
            dfs(root);
            path := nodes[root].path;
        end;

        hlen := n;
        heapify();
        a[n+1] := 0;
        for i := n downto n+1 - path do begin
            heapop();
            inc(a[i], a[i+1]);
        end;

        if debug then writeln('path = ', path);
        qot := k div (2 * path);
        rem := k mod (2 * path);
        if rem = 2 then
            ans := a[n+1 - 2]
        else
            ans := a[n+1 - (rem+1) div 2] +
            a[n+1 - rem div 2];
        inc(ans, 
            a[n+1 - path] * 2 * qot);
        writeln(ans);

        dec(tcases);
    until tcases = 0;
end.
