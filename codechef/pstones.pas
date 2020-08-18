program pstones;
{$assertions-} {$R-}
(*  *)
uses
    math;
const
    maxv = 100;
    maxe = 99;
    maxk = 12;
    maxj = 4095;
    maxlge = 14;
    maxlgn = 16384;
    maxbt = 4 * 1024 * 1024;
    maxht = 64 * 1024 * 1024;
type
    {integer = longint;
    shortint = integer;}
    mask = array [0 .. 1] of int64;
    tfreq = packed array [1 .. maxk] of shortint;
    tnode = record
        leaves: mask;
        ch: array [boolean] of longint;
    end;
    graph = record
        v: array [1 .. maxv] of record
            v, uv: shortint;
        end;
        uv: array [-maxe .. maxe] of record
            v, uv, c: shortint;
        end;
    end;
    crown = record
        leaves: mask;
        active: packed array [1 .. maxv] of boolean;
        freq: tfreq;
        deg: packed array [1 .. maxv] of shortint;
        j: integer;
    end;
var
    testcase: integer;
    n, k, i, u, uv, v, c: shortint;
    j1: integer;
    t: graph;
    cr: crown;
    bt: record
        a: array [1 .. maxbt] of tnode;
        len: longint;
    end;
    colset: array [0 .. maxv, 0 .. maxj] of char;
    lgt: array [0 .. maxlgn] of shortint;
    pow2cm1: array [1 .. maxk] of integer;
    htx: real;
    hte: shortint;
    htm, htlen: longint;
    ht: array [0 .. maxht] of record
        leaves: mask;
        first, next: longint;
    end;

function lgf(x: int64): shortint;
var
    lg: shortint;
begin
    lg := 0;
    if x shr 30 > 0 then begin
        x := x shr 30;
        inc(lg, 30);
    end;
    if x shr 15 > 0 then begin
        x := x shr 15;
        inc(lg, 15);
    end;
    lgf := lg + lgt[x];
end;

procedure appendarrow(u, uv, v, c: shortint);
begin
    inc(cr.deg[u]);
    t.uv[uv].c := c;
    t.uv[uv].v := v;
    t.uv[uv].uv := t.v[u].uv;
    t.v[u].uv := uv;
end;

procedure switchleaf(u: shortint);
var
    di, mo: shortint;
begin
    {divmod(u-1, 50, di, mo);}
    if u > 50 then begin
        di := 1; mo := u - 51;
    end else begin
        di := 0; mo := u - 1;
    end;
    cr.leaves[di] := cr.leaves[di] xor (int64(1) shl mo);
end;

function isleaf(u: shortint): boolean;
var
    di, mo: shortint;
begin
    {divmod(u-1, 50, di, mo);}
    if u > 50 then begin
        di := 1; mo := u - 51;
    end else begin
        di := 0; mo := u - 1;
    end;
    isleaf := (cr.leaves[di] and (int64(1) shl mo)) > 0;
end;

function cmpleaves(m1, m2: mask): int64;
begin
    if m1[1] <> m2[1] then
        cmpleaves := m1[1] - m2[1]
    else
        cmpleaves := m1[0] - m2[0];
end;

function htfound(leaves: mask): boolean;
var
    tmp: int64;
    hash, hi: longint;
    found: boolean;
    i: shortint;
begin
    tmp := leaves[1] xor leaves[0];
    for i := 1 to 50 div hte do
        tmp := tmp shr hte xor tmp;
    hash := tmp and htm;
    hi := ht[hash].first;
    while (hi <> -1) and (cmpleaves(leaves, ht[hi].leaves) <> 0) do
        hi := ht[hi].next;
    found := (hi <> -1);
    if not found then begin
        {assert(htlen <= maxht);}
        ht[htlen].leaves := leaves;
        ht[htlen].next := ht[hash].first;
        ht[hash].first := htlen;
        inc(htlen);
    end;
    htfound := found;
end;

function btfound(bi: longint): boolean;
var
    cmp: int64;
    node: tnode;
    dir: boolean;
begin
    {assert(bi <= maxbt);}
    if bi > bt.len then begin
        inc(bt.len);
        {if bt.len >= length(bt.a) - 2 then
            setlength(bt.a, 2 * length(bt.a));}
        node.leaves := cr.leaves;
        node.ch[false] := 0;
        node.ch[true] := 0;
        bt.a[bi] := node;
        btfound := false;
    end else begin
        node := bt.a[bi];
        cmp := cmpleaves(cr.leaves, node.leaves);
        {if cr.leaves[1] <> node.leaves[1] then
            cmp := cr.leaves[1] - node.leaves[1]
        else
            cmp := cr.leaves[0] - node.leaves[0];}
        if cmp = 0 then
            btfound := true
        else begin
            dir := cmp > 0;
            if node.ch[dir] = 0 then
                bt.a[bi].ch[dir] := bt.len + 1;
            btfound := btfound(bt.a[bi].ch[dir]);
        end;
    end;
end;

{procedure dfs(i: shortint; base: crown);}
procedure dfs(i: shortint);
var
    u, uv, v, c, di, mo: shortint;
    x: int64;
    m: mask;
begin
    {assert(i >= 0);}
    if {(i >= 0) and} not {btfound(1)} htfound(cr.leaves) then begin
        colset[i, cr.j] := '1';
        m := cr.leaves;
        for di := 0 to 1 do begin
            while m[di] > 0 do begin

                x := m[di] and -m[di];
                dec(m[di], x);
                mo := lgf(x);
                u := 1 + mo + 50 * di;

                dec(cr.leaves[di], x);
                cr.active[u] := false;
                uv := t.v[u].uv;
                {writeln('u = ', u, '  uv = ', uv);
                assert(uv <> 0);}
                repeat
                    v := t.uv[uv].v;
                    c := t.uv[uv].c;
                    {assert((1 <= c) and (c <= maxk));}
                    if cr.active[v] then begin
                        inc(cr.freq[c]);
                        if cr.freq[c] = 1 then
                            inc(cr.j, pow2cm1[c]);
                        dec(cr.deg[v]);
                        if cr.deg[v] = 1 then switchleaf(v);
                    end else begin
                        dec(cr.freq[c]);
                        if cr.freq[c] = 0 then
                            dec(cr.j, pow2cm1[c]);
                    end;
                    uv := t.uv[uv].uv;
                until uv = 0;
{
                dfs(i-1, cr);
                cr := base;
}
                dfs(i-1);
                inc(cr.leaves[di], x);
                cr.active[u] := true;
                uv := t.v[u].uv;
                repeat
                    v := t.uv[uv].v;
                    c := t.uv[uv].c;
                    if cr.active[v] then begin
                        dec(cr.freq[c]);
                        if cr.freq[c] = 0 then
                            dec(cr.j, pow2cm1[c]);
                        if cr.deg[v] = 1 then switchleaf(v);
                        inc(cr.deg[v]);
                    end else begin
                        inc(cr.freq[c]);
                        if cr.freq[c] = 1 then
                            inc(cr.j, pow2cm1[c]);
                    end;
                    uv := t.uv[uv].uv;
                until uv = 0;

            end;
        end;
    end;
end;

begin
    {setlength(bt.a, maxbt);}
    lgt[0] := -1;
    for i := 0 to maxlge do begin
        assert(integer(1) shl i <= maxlgn);
        lgt[integer(1) shl i] := i;
        {write(1 shl i, ' ', lgt[1 shl i], '  ');}
    end;
    {writeln;}
    for c := 1 to maxk do pow2cm1[c] := integer(1) shl (c-1);

    readln(testcase);
    repeat
        readln(n, k);

        htx := log2(1 + 10*n/100) + log2(1 + 10*k/12);
        hte := 6 + round(2 * htx);
        htm := longint(1) shl hte - 1;
        for htlen := 0 to htm do ht[htlen].first := -1;
        htlen := 0;

        for u := 1 to n do begin
            t.v[u].uv := 0;
            cr.deg[u] := 0;
            cr.active[u] := true;
        end;
        for c := 1 to k do cr.freq[c] := 0;
        for uv := 1 to n-1 do begin
            readln(u, v, c);
            appendarrow(u, uv, v, c);
            appendarrow(v, -uv, u, c);
        end;

        cr.leaves[0] := 0;
        cr.leaves[1] := 0;
        for u := 1 to n do
            if cr.deg[u] <= 1 then
                switchleaf(u);
        for i := 0 to n do
            for j1 := 0 to 1 shl k - 1 do
                colset[i, j1] := '0';

        bt.len := 0;
        cr.j := 0;

        {dfs(n, cr);}
        dfs(n);

        for i := 1 to n do begin
            for j1 := 0 to 1 shl k - 1 do
                write(colset[i, j1]);
            writeln;
        end;
        dec(testcase);
    until testcase = 0;
end.
