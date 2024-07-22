{$mode objfpc}{$H+}{$J-}
uses
    Generics.Defaults, Generics.Collections;
type
    iList = specialize TList<int32>;
    iComparer = specialize TComparer<int32>;
var
    a: iList;

function iCompare(constref Left, Right: int32): int32;
begin
    Result := Left - Right;
end;

begin
    a := iList.Create();
    a.Add(11);
    a.Add(33);
    a.Add(22);
    a.Sort(iComparer.Construct(@iCompare));

    Writeln('Count: ', a.Count);
    Writeln(a[0]);
    Writeln(a[1]);
    Writeln(a[2]);
end.
