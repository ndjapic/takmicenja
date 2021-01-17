program tsort;
const
    maxt = 1000 * 1000;
type
    tdata = int32;
    tavltree = record
        root, size: int32;
        nodes: array [0 .. maxt] of record
            data: tdata;
            freq, parent: int32;
            childs: array [0 .. 1] of int32;
            balance, direction: int8;
        end;
    end;
var
    t, i, u, l, r: int32;
    a: array [1 .. maxt] of tdata;
    tree: tavltree;

procedure createtree;
begin
    tree.root := 0;
    tree.size := 0;
    tree.nodes[0].balance := 0;
end;

procedure connect(parent, child: int32; direction: int8);
begin
    if parent = 0 then
        tree.root := child
    else
        tree.nodes[parent].childs[direction] := child;
    tree.nodes[child].parent := parent;
    tree.nodes[child].direction := direction;
end;
{
procedure updateheight(root: int32);
var
    child: int32;
    h0, h1: int8;
begin
    child := tree.nodes[root].childs[0];
    h0 := tree.nodes[child].height;
    child := tree.nodes[root].childs[1];
    h1 := tree.nodes[child].height;
    if h0 > h1 then
        tree.nodes[root].height := 1 + h0
    else
        tree.nodes[root].height := 1 + h1;
end;
}
procedure appendnode(data: tdata; parent: int32; direction: int8);
begin
    inc(tree.size);
    tree.nodes[tree.size].data := data;
    tree.nodes[tree.size].freq := 1;
    tree.nodes[tree.size].childs[0] := 0;
    tree.nodes[tree.size].childs[1] := 0;
    tree.nodes[tree.size].balance := 0;
    connect(parent, tree.size, direction);
end;

procedure rotate(pivot: int32);
var
    root, child, parent: int32;
    direction: int8;
begin
    assert((pivot <> 0) and (pivot <> tree.root));
    root := tree.nodes[pivot].parent;
    parent := tree.nodes[root].parent;
    direction := 1 - tree.nodes[pivot].direction;
    child := tree.nodes[pivot].childs[direction];
    connect(root, child, 1 - direction);
    connect(parent, pivot, tree.nodes[root].direction);
    connect(pivot, root, direction);{
    updateheight(root);
    updateheight(pivot);}
end;

procedure searchappend(data: tdata; root: int32);
var
    dif, child, parent, sibling: int32;
    dir1, dir2, h0, h1: int8;
begin
    if root = 0 then
        appendnode(data, 0, 0)
    else begin
        dif := data - tree.nodes[root].data;
        dir1 := ord(dif > 0);
        child := tree.nodes[root].childs[dir1];
        while (dif <> 0) and (child <> 0) do begin
            root := child;
            dif := data - tree.nodes[root].data;
            dir1 := ord(dif > 0);
            child := tree.nodes[root].childs[dir1];
        end;
        
        if dif = 0 then
            inc(tree.nodes[root].freq)
        else begin
            appendnode(data, root, dir1);
            child := tree.size;
            if root <> 0 then begin
                parent := tree.nodes[root].parent;
                while (parent <> 0) and (tree.nodes[parent].balance = 0) do begin
                    inc(tree.nodes[root].balance, 2 * dir1 - 1);
                    dir1 := tree.nodes[root].direction;
                    child := root;
                    root := parent;
                    parent := tree.nodes[root].parent;
                end;
                if parent <> 0 then begin

                    dir2 := tree.nodes[root].direction;
                    if (tree.nodes[parent].balance) * (2 * dir2 - 1) < 0 then
                        inc(tree.nodes[parent].balance, 2 * dir2 - 1)
                    else begin
                        if dir2 <> dir1 then begin
                            rotate(child);
                            rotate(child);
                            tree.nodes[child].balance := 0;
                        end else
                            rotate(root);
                        tree.nodes[root].balance := 0;
                        tree.nodes[parent].balance := 0;
                    end;

                end;
            end;
        end;
    end;
end;

function firstnode(u: int32): int32;
var
    v: int32;
begin
    v := tree.nodes[u].childs[0];
    while v <> 0 do begin
        u := v;
        v := tree.nodes[u].childs[0];
    end;
    firstnode := u;
end;

function nextnode(u: int32): int32;
var
    v: int32;
begin
    v := tree.nodes[u].childs[1];
    if v <> 0 then
        u := firstnode(v)
    else begin
        while (u <> 0) and (tree.nodes[u].direction = 1) do
            u := tree.nodes[u].parent;
        if u <> 0 then
            u := tree.nodes[u].parent;
    end;
    nextnode := u;
end;

begin
    readln(t);
    for i := 1 to t do readln(a[i]);

    createtree;
    for i := 1 to t do searchappend(a[i], tree.root);

    u := firstnode(tree.root);
    l := 0;
    while u <> 0 do begin

        r := l + tree.nodes[u].freq;
        for i := l + 1 to r do
            a[i] := tree.nodes[u].data;
        l := r;
        u := nextnode(u);

    end;

    for i := 1 to t do writeln(a[i]);
end.
