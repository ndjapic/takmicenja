program sort;
{$mode objfpc}{$h+}{$j-}{$inline on}
uses
    math;

type
    generic tcomparer<_t> = class
    public
        function LessOrEqual(constref lhs, rhs: _t): boolean; inline;
    end;
    generic tlist<_t, _c> = class
    private
        fitems, items2: array of _t;
        count: sizeint;
        function getItem(index: SizeInt): _t;
        procedure setItem(index: SizeInt; item: _t);
    public
        constructor create();
        destructor destroy(); override; // allows the use of a parent class destroyer
        function isNonIncreasing(lend, rend: sizeint; cmp: _c): boolean; inline;
        procedure MergeSort(lend, rend: sizeint; cmp: _c; stable: boolean);
        procedure sort(cmp: _c; stable: boolean);
        function bisectr(x: _t; cmp: _c): sizeint;
        property items[index: sizeint]: _t read getItem write setItem;
    end;

type
    icomparer = specialize tcomparer<int32>;
    ilist = specialize tlist<int32, icomparer>;

var
    n, i, x: int32;
    cmp: icomparer;
    a, p: ilist;

function tcomparer.LessOrEqual(constref lhs, rhs: _t): boolean; inline;
begin
    result := a.items[lhs] <= a.items[rhs];
end;

function tlist.getItem(index: SizeInt): _t;
begin
    result := fitems[index];
end;

procedure tlist.setItem(index: SizeInt; item: _t);
begin
    if length(fitems) <= index then setlength(fitems, 2 * index);
    fitems[index] := item;
    count := max(count, index + 1);
end;

constructor tlist.create();
begin
    setlength(fitems, 1);
    count := 0;
end;

destructor tlist.destroy();
begin
    setlength(fitems, 0);
    setlength(items2, 0);
    count := 0;
    inherited; // Also called parent class destroyer
end;

function tlist.isNonIncreasing(lend, rend: sizeint; cmp: _c): boolean; inline;
var
    j: sizeInt;
begin
    j := lend + 1;
    while (j < rend) and cmp.LessOrEqual(items[j], items[j-1]) do inc(j);
    result := j >= rend;
end;

procedure tlist.MergeSort(lend, rend: sizeint; cmp: _c; stable: boolean);
var
    i, l, r, m: sizeint;

begin
    i := lend + 1;
    while (i < rend) and cmp.LessOrEqual(items[i-1], items[i]) do inc(i);

    if i < rend then begin

        if not stable and isNonIncreasing(lend, rend, cmp) then begin

            l := lend;
            r := rend - 1;
            while l < r do begin
                items2[l] := items[l];
                items[l] := items[r];
                items[r] := items2[l];
                inc(l);
                dec(r);
            end;

        end else begin

            m := (lend + rend) div 2;
            if i < m then MergeSort(lend, m, cmp, stable);
            MergeSort(m, rend, cmp, stable);

            l := lend;
            r := m;
            for i := lend to rend - 1 do
                if (r = rend) or (l < m) and cmp.LessOrEqual(items[l], items[r]) then begin
                    items2[i] := items[l];
                    inc(l);
                end else begin
                    items2[i] := items[r];
                    inc(r);
                end;

            for i := lend to rend - 1 do items[i] := items2[i];
        end;
    end;
end;

procedure tlist.sort(cmp: _c; stable: boolean);
begin
    if length(items2) < length(fitems) then setlength(items2, length(fitems));
    MergeSort(0, count, cmp, stable);
end;

function tlist.bisectr(x: _t; cmp: _c): sizeint;
var
    l, r, m: sizeint;
begin
    l := -1;
    r := count;
    while r-l > 1 do begin
        m := (l+r) div 2;
        if cmp.LessOrEqual(items[m], x) then
            l := m
        else
            r := m;
    end;
    bisectr := r;
end;

begin
    readln(n);
    cmp := icomparer.create(); // Initialize the object by calling the class builder
    a := ilist.create();
    p := ilist.create();

    for i := 0 to n-1 do begin
        read(x);
        a.items[i] := x;
        p.items[i] := i;
    end;
    readln;
    p.sort(cmp, false);

    writeln(p.items[n-2] + 1);

    a.free(); // Free invites your own class Destroy discharger
    p.free();
    cmp.free();
end.
