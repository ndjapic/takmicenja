program tsort;
const
    ten6 = 1000 * 1000;
type
    integer = longint;
var
    t, i, hlen: integer;
    a: array [1 .. ten6] of integer;

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

function siftdown(pa, val: integer): integer;
var
    ch: integer;
begin
    ch := prioch(pa);
    while (ch <= hlen) and (a[ch] > val) do begin
        a[pa] := a[ch];
        pa := ch;
        ch := prioch(pa);
    end;
    siftdown := pa;
end;

procedure heapify();
var
    pa: integer;
    val: integer;
begin
    for pa := hlen div 2 downto 1 do begin
        val := a[pa];
        a[ siftdown(pa, val) ] := val;
    end;
end;

procedure heapop();
var
    val: integer;
begin
    val := a[hlen];
    a[hlen] := a[1];
    dec(hlen);
    a[ siftdown(1, val) ] := val;
end;

begin
    readln(t);
    for i := 1 to t do readln(a[i]);
    hlen := t;
    heapify();
    while hlen > 0 do heapop();
    for i := 1 to t do writeln(a[i]);
end.
