program C_Colorful_Beans;
uses
    math;
const
    maxhtn = 200 * 1000;
var
    n, i, a, c: int32;
    htn, v, ran: int32;
    ht: array [1 .. maxhtn] of record
        x, y, l, r: int32;
    end;

procedure ht_init();
begin
    randomize;
    ran := random(high(int32));
    htn := 0;
end;

procedure ht_append(x, y: int32);
begin
    inc(htn);
    ht[htn].x := x xor ran;
    ht[htn].y := y;
    ht[htn].l := 0;
    ht[htn].r := 0;
end;

procedure ht_update(x, y: int32);
var
    u, v: int32;
begin
    x := x xor ran;
    v := 1;

    while (v > 0) and (x <> ht[v].x) do begin
        u := v;
        if x < ht[u].x then
            v := ht[v].l
        else
            v := ht[v].r;
    end;

    if v = 0 then begin
        ht_append(x xor ran, y);
        if x < ht[u].x then
            ht[u].l := htn
        else
            ht[u].r := htn;
    end else {if d[v].x = c then}
        ht[v].y := min(ht[v].y, y);
end;

begin
    readln(n);

    readln(a, c);
    ht_init();
    ht_append(c, a);

    for i := 2 to n do begin
        readln(a, c);
        ht_update(c, a);
    end;

    a := ht[1].y;
    for v := 1 to htn do
        a := max(a, ht[v].y);
    writeln(a);

end.
