from bisect import bisect

def shadow(x, d):
    result, m, yi = 0, 0, 0
    for xi in x:
        mi = xi + yi
        if m < mi:
            result += min(xi, mi - m)
            m = mi
        yi += d
    return result

for tci in range(int(input())):
    #n, l, u = map(int, input().split())
    #x = list(map(int, input().split()))

    n, maxx = 6, 9
    l, u = [randint(1, maxx), randint(1, maxx)]
    l, u = min(l, u), max(l, u)
    x = [randint(1, maxx) for i in range(n)]

    smin, smax = sum(x) * l, 0
    for p in permutations(x):
        s = shadow(p, l)
        if s < smin:
            smin = s
            pl = [p[i] for i in range(n)]
        s = shadow(p, u)
        if s > smax:
            smax = s
            pu = [p[i] for i in range(n)]

    print(l, smin, pl)
    print(u, smax, pu)
