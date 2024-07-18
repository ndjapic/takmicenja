program stl_OrdUtils;
uses
    gvector, garrayutils, gutil;
type
    iLess = specialize TLess<int32>;
    iVector = specialize TVector<int32>;
    iOrdUtils = specialize TOrderingArrayUtils<iVector, int32, iLess>;
    iUtils = specialize TArrayUtils<iVector, int32>;
var
    V : iVector;
    n, i : int32;

begin
    read(n);
    V := iVector.Create;
    for i := 0 to n-1 do V.PushBack(i);
    iUtils.RandomShuffle(V, n);
    iOrdUtils.Sort(V, n);
end.
