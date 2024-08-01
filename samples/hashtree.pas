program hashtree;
uses
    math;
const
    maxhtn = 200 * 1000;
    hte = high(int32);
var
    n, i, a, c: int32;
    htn, v, hash0: int32;
    ht: array [1 .. maxhtn] of record
        x, y, l, r: int32;
    end;

procedure ht_init();
begin
    randomize;
    hash0 := random(high(int32));
    htn := 0;
end;

function ht_append(x, y: int32): int32;
begin
    inc(htn);
    ht[htn].x := x xor hash0;
    ht[htn].y := y;
    ht[htn].l := 0;
    ht[htn].r := 0;
    ht_append := htn;
end;

procedure ht_update(x, y: int32);
var
    u, v, h: int32;
begin
    h := x xor hash0;
    v := 1;

    while (v > 0) and (h <> ht[v].x) do begin
        u := v;
        if h < ht[u].x then
            v := ht[v].l
        else
            v := ht[v].r;
    end;

    if v > 0 then
        ht[v].y := min(ht[v].y, y)
    else if h < ht[u].x then
        ht[u].l := ht_append(x, y)
    else
        ht[u].r := ht_append(x, y);
end;

function ht_query(x: int32): int32;
var
    v, h: int32;
begin
    h := x xor hash0;
    v := 1;

    while (v > 0) and (h <> ht[v].x) do
        if h < ht[v].x then
            v := ht[v].l
        else
            v := ht[v].r;

    if v > 0 then
        ht_query := ht[v].y
    else
        ht_query := hte;
end;

begin
    readln(n);

    readln(a, c);
    ht_init();
    htn := ht_append(c, a);

    for i := 2 to n do begin
        readln(a, c);
        ht_update(c, a);
    end;

    a := ht[1].y;
    for v := 1 to htn do a := max(a, ht[v].y);
    writeln(a);

end.
