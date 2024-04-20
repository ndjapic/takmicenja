program treap;
{$mode delphi}
uses
    math;
const
    th_size = 1000 * 1000;
var
    n, i: int32;
    randtime, a: array [1 .. th_size] of int32;
    th: record
        a: array [0 .. th_size] of record
            x, y, l, r, n: int32;
        end;
        n, root: int32;
    end;

procedure th_init();
var
    i, j: int32;
begin
    randomize;
    for i := 1 to th_size do begin
        j := 1 + random(i);
        randtime[i] := randtime[j];
        randtime[j] := i;
    end;
    th.n := 0;
    th.a[0].n := 0;
end;

function th_append(x, y: int32): int32;
begin
    inc(th.n);
    th.a[th.n].x := x;
    th.a[th.n].y := y;
    th.a[th.n].l := 0;
    th.a[th.n].r := 0;
    th.a[th.n].n := 1;
    th_append := th.n;
end;

function th_insert(u, x, y: int32): int32;
var
    v, w: int32;
begin
    if x <= th.a[u].x then begin

        v := th.a[u].l;
        if v = 0 then
            v := th_append(x, y)
        else
            v := th_insert(v, x, y);
        w := th.a[v].r;

        if y > th.a[u].y then begin
            th.a[u].l := w;
            th.a[v].r := u;
            dec(th.a[u].n, th.a[v].n - th.a[w].n - 1);
            inc(th.a[v].n, th.a[u].n - th.a[w].n);
            th_insert := v;
        end else begin
            th.a[u].l := v;
            inc(th.a[u].n);
            th_insert := u;
        end;

    end else begin

        v := th.a[u].r;
        if v = 0 then
            v := th_append(x, y)
        else
            v := th_insert(v, x, y);
        w := th.a[v].l;

        if y > th.a[u].y then begin
            th.a[u].r := w;
            th.a[v].l := u;
            dec(th.a[u].n, th.a[v].n - th.a[w].n - 1);
            inc(th.a[v].n, th.a[u].n - th.a[w].n);
            th_insert := v;
        end else begin
            th.a[u].r := v;
            inc(th.a[u].n);
            th_insert := u;
        end;

    end;
end;

function th_get(u, i: int32): int32;
var
    v, j: int32;
begin
    v := th.a[u].l;
    j := i - th.a[v].n - 1;
    if j < 0 then
        th_get := th_get(v, i)
    else if j > 0 then
        th_get := th_get(th.a[u].r, j)
    else
        th_get := th.a[u].x;
end;

function th_ord(u, x: int32): int32;
var
    v: int32;
begin
    if u = 0 then
        th_ord := 0
    else if x < th.a[u].x then begin
        v := th.a[u].l;
        th_ord := th_ord(v, x);
    end else begin
        v := th.a[u].r;
        th_ord := th.a[u].n - th.a[v].n + th_ord(v, x);
    end;
end;

procedure dfs(u: int32);
begin
    if u > 0 then begin
        dfs(th.a[u].l);
        inc(i);
        a[i] := th.a[u].x;
        dfs(th.a[u].r);
    end;
end;

begin
    readln(n);

    read(a[1]);
    th_init();
    th.root := th_append(a[1], randtime[1]);

    for i := 2 to n do begin
        read(a[i]);
        th.root := th_insert(th.root, a[i], randtime[i]);
    end;
    readln;

    for i := 1 to n do writeln(' i=',i, ' a[i]=',a[i], ' ord(a[i])=',th_ord(th.root, a[i]), ' get(i)=',th_get(th.root, i));

    i := 0;
    dfs(th.root);

    for i := 1 to n-1 do write(a[i], ' ');
    writeln(a[n]);
end.

(*
9
4 6 8 9 5 6 4 5 4
 i=1 a[i]=4 ord(a[i])=3 get(i)=4
 i=2 a[i]=6 ord(a[i])=7 get(i)=4
 i=3 a[i]=8 ord(a[i])=8 get(i)=4
 i=4 a[i]=9 ord(a[i])=9 get(i)=5
 i=5 a[i]=5 ord(a[i])=5 get(i)=5
 i=6 a[i]=6 ord(a[i])=7 get(i)=6
 i=7 a[i]=4 ord(a[i])=3 get(i)=6
 i=8 a[i]=5 ord(a[i])=5 get(i)=8
 i=9 a[i]=4 ord(a[i])=3 get(i)=9
4 4 4 5 5 6 6 8 9


------------------
(program exited with code: 0)
Press return to continue
*)
