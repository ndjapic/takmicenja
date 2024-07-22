{$mode objfpc}{$H+}{$J-}
uses
    Generics.Defaults, Generics.Collections;
type
    iList = specialize TList<int32>;
    iComparer = specialize TComparer<int32>;
var
    L: iList;

function Compare(constref Left, Right: int32): int32;
begin
    Result := Left - Right;
end;

begin
    L := iList.Create();
    L.Add(11);
    L.Add(33);
    L.Add(22);
    L.Sort(iComparer.Construct(@Compare));

    Writeln('Count: ', L.Count);
    Writeln(L[0]);
    Writeln(L[1]);
    Writeln(L[2]);
end.
