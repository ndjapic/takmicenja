program segtree;
const
    maxn = 100 * 1000;
    maxt = 256 * 1024;
var
    n, q, i, k, l, r, d: int32;
    tp: int8;
    a: array [1 .. maxn] of int32;
    st, lz: array [1 .. maxt] of int32;

procedure combine(v: int32);
begin
    st[v] := max(st[2*v], st[2*v+1]);
end;

procedure push(v: int32);
begin
    inc(st[2*v], lz[v]);
    inc(st[2*v+1], lz[v]);
    inc(lz[2*v], lz[v]);
    inc(lz[2*v+1], lz[v]);
    lz[v] := 0;
end;

procedure build(v, l, r: int32);
var
    m: int32;
begin
    lz[v] := 0;
    if l < r then begin
        m := (l+r) div 2;
        build(2*v, l, m);
        build(2*v+1, m+1, r);
        combine(v);
    end else
        st[v] := a[l];
end;

procedure update(v, vl, vr, l, r, d: int32);
var
    m: int32;
begin
    if (r < vl) or (vr < l) then
    else if (l <= vl) and (vr <= r) then begin
        inc(st[v], d);
        inc(lz[v], d);
    end else {if l < r then} begin
        push(v);
        m := (vl+vr) div 2;
        update(2*v, vl, m, l, r, d);
        update(2*v+1, m+1, vr, l, r, d);
        combine(v);
    end;
end;

procedure query(v, vl, vr, l, r: int32): query;
var
    m: int32;
begin
    if (r < vl) or (vr < l) then
        query := low(int32)
    else if (l <= vl) and (vr <= r) then
        query := t[v]
    else {if l < r then} begin
        push(v);
        m := (vl+vr) div 2;
        query := max(
            query(2*v, vl, m, l, r),
            query(2*v+1, m+1, vr, l, r)
        );
    end;
end;

begin
    readln(n, q);

    for i := 1 to n do read(a[i]); readln;

    build(1, 1, n);

    for k := 1 to q do begin
        read(tp);
        case tp of

            1: begin
                readln(l, r, d);
                update(1, 1, v, l, r, d);
            end;

            2: begin
                readln(l, r);
                writeln(query(1, 1, v, l, r));
            end;
        
        end;
    end;
end;
