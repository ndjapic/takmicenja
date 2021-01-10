program tsort;
const
    maxt = 1000 * 1000;
type
    tdata = int32;
    tavltree = record
        root, size: int32;
        nodes: array [0 .. maxt] of record
            data: tdata;
            freq: int32;
            childs: array [0 .. 1] of int32;
            height: int8;
        end;
    end;
var
    t, i: int32;
    a: array [1 .. maxt] of tdata;
    tree: tavltree;

procedure createtree;
begin
    tree.size := 0;
    tree.nodes[tree.size].height := 0;
end;

procedure appendnode(data: tdata);
begin
    inc(tree.size);
    tree.nodes[tree.size].data := data;
    tree.nodes[tree.size].freq := 1;
    tree.nodes[tree.size].childs[0] := 0;
    tree.nodes[tree.size].childs[1] := 0;
    tree.nodes[tree.size].height := 1;
end;

function rotate(root: int32; direction: int8): int32;
var
    pivot: int32;
begin
    pivot := tree.nodes[root].childs[1 - direction];
    tree.nodes[root].childs[1 - direction] :=
        tree.nodes[pivot].childs[direction];
    tree.nodes[pivot].childs[direction] := root;
    rotate := pivot;
end;

procedure searchappend(data: tdata; root, parent: int32; direction: int8);
var
    dif: int32;
begin
    if root = 0 then begin
        appendnode(data);
        if parent = 0 then
            tree.root := tree.size
        else
            tree.nodes[parent].childs[direction] := tree.size;
    end else begin
        dif := data - tree.nodes[root].data;
        if dif = 0 then
            inc(tree.nodes[root].freq)
        else begin
            direction := ord(dif > 0);
            searchappend(data, tree.nodes[root].childs[direction], root, direction);
        end;
    end;
end;

begin
    readln(t);
    for i := 1 to t do readln(a[i]);
    for i := 1 to t do writeln(a[i]);
end.
