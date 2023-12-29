from collections import deque

prime = 7 * 17 * 8192 * 1024 + 1
root, invr = [1] * 24, [1] * 24
root[23] = pow(3, 7 * 17, prime)
invr[23] = pow((prime + 1) // 3, 7 * 17, prime)
for e in reversed(range(23)):
    root[e] = pow(root[e+1], 2, prime)
    invr[e] = pow(invr[e+1], 2, prime)

def ntt(a, e, invert = False):
    if(e > 0):
        a0, a1 = a[0::2], a[1::2]
        ntt(a0, e-1, invert)
        ntt(a1, e-1, invert)

        wn, w, h = invr[e] if invert else root[e], 1, len(a) // 2
        for i in range(h):
            t0, t1 = a0[i], a1[i] * w % prime
            a[i], a[i+h] = (t0 + t1) % prime, (t0 - t1) % prime
            w = w * wn % prime

        if(invert):
            for i in range(len(a)):
                if( a[i] % 2 > 0 ):
                    a[i] += prime
                a[i] //= 2

def mul(p1, p2):
    n1, n2, n, e = len(p1), len(p2), 1, 0
    while(n < n1+n2):
        n *= 2
        e += 1
    p3 = p1 + [0] * (n-n1)
    p4 = p2 + [0] * (n-n2)
    ntt(p3, e)
    ntt(p4, e)
    for i in range(n):
        p4[i] = p3[i] * p4[i] % prime
    ntt(p4, e, True)
    while(p4[-1] == 0): z = p4.pop()
    return p4

r1 = int(input())
k = int(input())
a = list(map(int, input().split()))
p = list(map(int, input().split()))

q = deque( [prime - i, 1] for i in range(r1) )
while(len(q) > 1):
    p1 = q.popleft()
    p2 = q.popleft()
    q.append( mul(p1, p2) )

t = [ [] for i in range(4*k) ]

def dfs1(v, l, r):
    if(r-l > 1):
        m = (l+r+1) // 2
        p1 = dfs1(2*v, l, m)
        p2 = dfs1(2*v+1, m, r)
        t[v] = mul(p1, p2)
    else:
        t[v] = [prime - a[l], 1]
    return t[v]

t[1] = dfs1(1, 0, k)

def mod(p0, p2):
    p1 = p0[:]
    while(len(p1) >= len(p2)):
        c = prime - p1.pop()
        for i2 in range(len(p2)-1):
            i1 = i2 + len(p1) + 1 - len(p2)
            p1[i1] += p2[i2] * c
            p1[i1] %= prime
    return p1

irf = 1
for i in range(1, r1+1):
    irf *= i
    irf %= prime
irf = pow(irf, prime-2, prime)

i, result = 0, 1

def dfs2(v, l, r, p0):
    global i, result
    p1 = mod(p0, t[v])
    t[v] = p1
    if(r-l > 1):
        m = (l+r+1) // 2
        dfs2(2*v, l, m, p1)
        dfs2(2*v+1, m, r, p1)
    else:
        result *= p[i] * p1[0] * irf + 1 + prime - p[i]
        result %= prime
        i += 1

dfs2(1, 0, k, q[0])
print(result)
