program fastio; {$H+}
uses
    math;
const
    maxn = 200 * 1000;
var
    notc: int32;
    n, i, ioi: int32;
    istr, ostr: string;
    a, ans: array [1 .. maxn] of int32;

function readdword(): dword;
var
    ans: dword;
begin
    ans := 0;
    while (istr[ioi] < '0') or (istr[ioi] > '9') do inc(ioi);
    while (istr[ioi] >= '0') and (istr[ioi] <= '9') do begin
        ans := ans * 10 + ord(istr[ioi]) - ord('0');
        inc(ioi);
    end;
    readdword := ans;
end;

procedure writedword(x: dword);
begin
    if x >= 10 then writedword(x div 10);
    inc(ioi);
    ostr[ioi] := chr(x mod 10 + ord('0'));
end;

begin
    pq.n := 0;
    readln(notc);
    repeat

        readln(n, k);

        readln(istr);
        istr := istr + ' ';
        ioi := 1;

        for i := 1 to n do a[i] := readdword();


        setlength(ostr, n*11);
        ioi := 0;

        for i := 1 to n do begin
            writedword(ans[i]);
            inc(ioi);
            ostr[ioi] := ' ';
        end;

        setlength(ostr, ioi-1);
        writeln(ostr);

        dec(notc);
    until notc = 0;
end.
