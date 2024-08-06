program treap;
{$mode delphi}
uses
    math;
const
    th_size = 1000 * 1000;
type
    TComparer<_T> = class
    public
        function Compare(constref lhs, rhs: _T): SizeInt; inline;
    end;
    PTreapNode = SizeInt;
    TTreapNode<_T> = class
        x: _T;
        y, c: SizeInt;
        l, r: PTreapNode;
    end;
    TSortedArray<_T> = class
    private
        const
            SENTINEL = 0;
        Nodes: array of TNode;
        function GetItem(Index: SizeInt): PTreapNode;
        function GetRoot();
        procedure SetRoot(Root: PTreapNode);
    public
        constructor Create();
        destructor Destroy(); override;
        function NewNode(x: _T): PTreapNode;
        procedure RotateRight(var Root, l: PTreapNode); inline;
        procedure RotateLeft(var Root, r: PTreapNode); inline;
        procedure FixHeap(var Root: PTreapNode);
        procedure Insert(var Root: PTreapNode; x: _T);
        function GetItem(Root: PTreapNode; Index: SizeInt): PTreapNode;
        procedure Meld(var Root: PTreapNode);
        procedure DeleteAt(var Root: PTreapNode; Index: SizeInt);
        function BisectRight(x: _T): PTreapNode;
        property Item[Index: SizeInt]: PTreapNode read GetItem;
        property RootNode: PTreapNode read GetRoot write SetRoot;
    end;

var
    n, i: int32;
    randtime, a: array [1 .. th_size] of int32;
    th: record
        a: array [0 .. th_size] of record
            x, y, l, r, n: int32;
        end;
        n, root: int32;
    end;

function TComparer.Compare(constref lhs, rhs: _T): SizeInt; inline;
begin
    Result := lhs - rhs;
end;

function TSortedArray.GetItem(Root: PTreapNode; Index: SizeInt): PTreapNode;
var
    l: PTreapNode;
begin
    if Root = SENTINEL then
        Result := SENTINEL
    else begin
        l := Nodes[Root].l;
        if Index = Nodes[l].c then
            Result := Root;
        else if Index < Nodes[l].c then
            Result := GetItem(l, Index)
        else
            Result := GetItem(Nodes[Root].r, Index - 1 - Nodes[l].c);
    end;
end;

function TSortedArray.GetRoot(): PTteapNode;
begin
    Result := Nodes[SENTINEL].r;
end;

procedure TSortedArray.SetRoot(Root: PTreapNode);
begin
    Nodes[SENTINEL].r := Root;
end;

constructor TSortedArray.Create();
begin
    Randomize;
    SetLength(Nodes, max(0, SENTINEL) + 1);
    Nodes[SENTINEL].x := Low(_T);
    Nodes[SENTINEL].y := High(SizeInt);
    Nodes[SENTINEL].c := 0;
    Nodes[SENTINEL].r := SENTINEL;
end;

destructor TSortedArray.Destroy();
begin
    SetLength(Nodes, 0);
    inherited;
end;

function TSortedArray.NewNode(x: _T): PTreapNode;
var
    c, root: PTreapNode;
begin
    Result := Nodes[SENTINEL].c + 1;
    if Length(Nodes) <= Result then SetLength(Nodes, Result * 2);
    Nodes[Result].x := x;
    Nodes[Result].y := Random(High(SizeInt)); // Generate random priority
    Nodes[Result].c := 1;
    Nodes[Result].l := SENTINEL;
    Nodes[Result].r := SENTINEL;
    Nodes[SENTINEL].c := Result;
end;

procedure TSortedArray.RotateRight(var Root, l: PTreapNode);
{var
    l: PTreapNode;}
begin
    {l := Nodes[Root].l;}
    Nodes[Root].l := Nodes[l].r;
    Nodes[l].r := Root;
    Nodes[l].c := Nodes[Root].c;
    dec(Nodes[Root].c, Nodes[Nodes[l].l].c);
    Root := l;
end;

procedure TSortedArray.RotateLeft(var Root, r: PTreapNode);
{var
    r: PTreapNode;}
begin
    {r := Nodes[Root].r;}
    Nodes[Root].r := Nodes[r].l;
    Nodes[r].l := Root;
    Nodes[r].c := Nodes[Root].c;
    dec(Nodes[Root].c, Nodes[Nodes[r].r].c);
    Root := r;
end;

procedure TSortedArray.FixHeap(var Root: PTreapNode);
var
    l, r: PTreapNode;
    y: SizeInt;
begin
    l := Nodes[Root].l;
    r := Nodes[Root].r;
    y := Nodes[Root].y;
    if (l <> SENTINEL) and (Nodes[l].y > y) then RotateRight(Root, l);
    if (r <> SENTINEL) and (Nodes[r].y > y) then RotateLeft(Root, r);
    FixHeap(l);
    FixHeap(r);
end;

procedure TSortedArray.Insert(var Root: PTreapNode; x: _T);
var
    l, r: PTreapNode;
    y: SizeInt;
begin
    if Root = SENTINEL then
        Root := NewNode(x)
    else begin
        Inc(Nodes[Root].c);
        y := Nodes[Root].y;
        if x < Nodes[Root].x then begin
            l := Nodes[Root].l;
            Insert(l, x);
            if Nodes[l].y > y then RotateRight(Root, l);
        end else begin
            r := Nodes[Root].r;
            Insert(r, x);
            if Nodes[r].y > y then RotateLeft(Root, r);
        end;
    end;
    {FixHeap(Root);}
end;

procedure TSortedArray.Meld(var Root: PTreapNode);
var
    l, r: PTreapNode;
begin
    if Root = SENTINEL then
    else begin
        l := Nodes[Root].l;
        r := Nodes[Root].r;
        if (r = SENTINEL) or (l <> SENTINEL) and (Nodes[l].y > Nodes[r].y) then begin
            Meld(l);
            Nodes[l].r := r;
            Root := l;
        end else begin
            Meld(r);
            Nodes[v].l := l;
            Root := r;
        end;
    end;
end;

procedure TSortedArray.DeleteAt(var Root: PTreapNode; Index: SizeInt);
var
    l, r: PTreapNode;
begin
    if Root <> SENTINEL then begin
        l := Nodes[Root].l;
        r := Nodes[Root].r;
        if Index = Nodes[l].c then
            Meld(Root);
        else if Index < Nodes[l].c then
            DeleteAt(l, Index)
        else
            DeleteAt(r, Index - 1 - Nodes[l].c);
        Nodes[Root].c := Nodes[l].c + 1 + Nodes[r].c;
    end;
end;

function TSortedArray.BisectRight(Root: PTreapNode; x: _T): SizeInt;
var
    l, r: PTreapNode;
    y: SizeInt;
begin
    if Root = SENTINEL then
        Result := 0
    else if x < Nodes[Root].x then
        Result := BisectRight(Nodes[Root].l, x)
    else
        Result := Nodes[l].c + 1 + BisectRight(Nodes[Root].r, x);
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
    th.root := 0;
    th.n := 0;
    th.a[0].x := 0;
    th.a[0].y := high(int32);
    th.a[0].l := 0;
    th.a[0].r := 0;
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

procedure th_update(u: int32);
begin
    th.a[u].n := th.a[th.a[u].l].n + th.a[th.a[u].r].n + 1;
end;

function th_rotate(u, v: int32): int32;
begin
    {if v > 0 then} begin
        if th.a[u].l = v then begin
            th.a[u].l := th.a[v].r;
            th.a[v].r := u;
        end else begin
            th.a[u].r := th.a[v].l;
            th.a[v].l := u;
        end;
        th_update(u);
        th_update(v);
        u := v;
    end;
    th_rotate := u;
end;

function th_insert(u, x, y: int32): int32;
begin
    if u = 0 then begin
        u := th_append(x, y);
    end else if x <= th.a[u].x then begin
        th.a[u].l := th_insert(th.a[u].l, x, y);
        if y > th.a[u].y then u := th_rotate(u, th.a[u].l);
    end else begin
        th.a[u].r := th_insert(th.a[u].r, x, y);
        if y > th.a[u].y then u := th_rotate(u, th.a[u].r);
    end;
    th_update(u);
    th_insert := u;
end;

function th_delete(u, x: int32): int32;
var
    vl, vr: int32;
begin
    if u > 0 then begin
        if th.a[u].n > 1 then begin
            vl := th.a[u].l;
            vr := th.a[u].r;
            if x < th.a[u].x then begin
                th.a[u].l := th_delete(vl, x);
            end else if x > th.a[u].x then begin
                th.a[u].r := th_delete(vr, x);
            end else if (vr = 0) or (vl > 0) and (th.a[vl].y >= th.a[vr].y) then begin
                vl := th_rotate(u, vl);
                th.a[vl].r := th_delete(u, x);
                u := vl;
            end else begin
                vr := th_rotate(u, vr);
                th.a[vr].l := th_delete(u, x);
                u := vr;
            end;
            th_update(u);
        end else if th.a[u].x = x then
            u := 0; (* THIS DELETES NODE *)
    end;
    th_delete := u;
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
        write(' [');
        dfs(th.a[u].l);
        inc(n);
        a[n] := th.a[u].x;
        write(a[n]);
        dfs(th.a[u].r);
        write('] ');
    end;
end;

begin
    readln(n);

    th_init();

    for i := 1 to n do begin
        read(a[i]);
        th.root := th_insert(th.root, a[i], randtime[i]);
    end;
    readln;

    writeln(' root=',th.root);
    for i := 1 to th.a[th.root].n do writeln(' i=',i, ' a[i]=',a[i], ' ord(a[i])=',th_ord(th.root, a[i]), ' get(i)=',th_get(th.root, i));

    th.root := th_delete(th.root, 5);

    n := 0;
    dfs(th.root);
    writeln;

    writeln(' root=',th.root);
    for i := 1 to th.a[th.root].n do writeln(' i=',i, ' a[i]=',a[i], ' ord(a[i])=',th_ord(th.root, a[i]), ' get(i)=',th_get(th.root, i));

    for i := 1 to n-1 do write(a[i], ' ');
    writeln(a[n]);
end.

(*
9
4 6 8 9 5 6 4 5 4
 root=8
 i=1 a[i]=4 ord(a[i])=3 get(i)=4
 i=2 a[i]=6 ord(a[i])=7 get(i)=4
 i=3 a[i]=8 ord(a[i])=8 get(i)=4
 i=4 a[i]=9 ord(a[i])=9 get(i)=5
 i=5 a[i]=5 ord(a[i])=5 get(i)=5
 i=6 a[i]=6 ord(a[i])=7 get(i)=6
 i=7 a[i]=4 ord(a[i])=3 get(i)=6
 i=8 a[i]=5 ord(a[i])=5 get(i)=8
 i=9 a[i]=4 ord(a[i])=3 get(i)=9
 [ [4 [ [4] 4 [ [5 [6] ] 6 [8] ] ] ] 9] 
 root=4
 i=1 a[i]=4 ord(a[i])=3 get(i)=4
 i=2 a[i]=4 ord(a[i])=3 get(i)=4
 i=3 a[i]=4 ord(a[i])=3 get(i)=4
 i=4 a[i]=5 ord(a[i])=4 get(i)=5
 i=5 a[i]=6 ord(a[i])=6 get(i)=6
 i=6 a[i]=6 ord(a[i])=6 get(i)=6
 i=7 a[i]=8 ord(a[i])=7 get(i)=8
 i=8 a[i]=9 ord(a[i])=8 get(i)=9
4 4 4 5 6 6 8 9


------------------
(program exited with code: 0)
Press return to continue
*)
