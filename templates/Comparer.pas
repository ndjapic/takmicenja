program Comparer;
{$mode objfpc}{$H+}{$J-}
uses
    Generics.Defaults, Generics.Collections;
const
    nn = 100 * 1000;
type
    intList = specialize TList<int32>;
var
    n, i: int32;
    a: intList;

function intCompare(constref Left, Right: int32): int32;
begin
    Result := Left - Right;
end;

begin
    n := nn div 10;
    a := intList.Create();

    for i := 0 to nn do a.Add(random(nn));
    for i := 0 to 10 do write(' ', a[i*n]); writeln;

    a.Sort(specialize TComparer<int32>.Construct(@intCompare));
    for i := 0 to 10 do write(' ', a[i*n]); writeln;
    writeln(a.Count);
end.
(*
 54881 36678 74826 38613 39217 88120 75812 79091 36925 50366 30764
 0 9857 19828 29869 39999 49890 59703 69823 79858 89858 99999
100001

=====
Used: 78 ms, 44 KB
*)
