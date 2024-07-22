program Comparer;
{$mode objfpc}{$H+}{$J-}
uses
    Generics.Defaults, Generics.Collections;
type
    intList = specialize TList<int32>;
    intComparer = specialize TComparer<int32>;
var
    a: intList;

function intCompare(constref Left, Right: int32): int32;
begin
    Result := Left - Right;
end;

begin
    a := intList.Create();
    a.Add(11);
    a.Add(33);
    a.Add(22);
    a.Sort(intComparer.Construct(@intCompare));

    Writeln('Count: ', a.Count);
    Writeln(a[0]);
    Writeln(a[1]);
    Writeln(a[2]);
end.
