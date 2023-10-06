program E_Jellyfish_and_Math;
const
    maxq = 16 * 1024 * 1024;
var
    ntc, tci, a, b, c, d, m, l, r, n, w: int32;
    ran: int64;
    found: boolean;
    que: array [1 .. maxq] of record
        x, y, w: int32;
    end;
    t: array [0 .. maxq] of record
        x: int64;
        l, r: int32;
    end;

procedure enqueue(a, b, w: int32);
var
    u, v: int32;
    x: int64;
begin

    v := 0;
    x := ((int64(a) shl 30) + b) xor ran;

    while (v > -1) and (x <> t[v].x) do begin
        u := v;
        if x < t[u].x then
            v := t[u].l
        else
            v := t[u].r;
    end;

    {if tci = 1 then writeln(' a=', a, ' b=', b, ' u=', u, ' v=', v, ' w=', w);}

    if v = -1 then begin

        inc(n);
        if x < t[u].x then
            t[u].l := n
        else
            t[u].r := n;
        t[n].x := x;
        t[n].l := -1;
        t[n].r := -1;

        inc(r);
        que[r].x := a;
        que[r].y := b;
        que[r].w := w;
        found := found or (a = c) and (b = d);

    end;

end;

begin
    randomize;
    ran := random(int64(1) shl 60);

    readln(ntc);
    for tci := 1 to ntc do begin

        readln(a, b, c, d, m);

        l := 1;
        r := 0;
        n := 0;
        t[0].x := -1;
        t[0].l := -1;
        t[0].r := -1;
        w := 0;
        found := false;
        enqueue(a, b, w);

        while (l <= r) and not found do begin

            a := que[l].x;
            b := que[l].y;
            w := que[l].w + 1;
            inc(l);

            enqueue(a and b, b, w);
            enqueue(a or b, b, w);
            enqueue(a, a xor b, w);
            enqueue(a, b xor m, w);

        end;

        if found then
            writeln(w)
        else
            writeln(-1);

    end;
end.
