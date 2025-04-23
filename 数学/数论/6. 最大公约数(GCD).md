## Euclidian method:
```python
def gcd(a, b):
	# assume a > b
	while b:
		a, b = b, a % b
	return a
# 也叫：辗转相除法
# gcd(a,b) = gcd(b,a%b)
```
证明
1. 设$c = a \% b$ , 那么有$c = a-bk$, 这里$k$ 是某个int
3. 假设$d|a$ 以及 $d|b$, 那么有$\frac{c}{d} = \frac{a}{d} - \frac{b}{d}k$ , 所以可以得到$\frac{c}{d}$是整数，也就意味着$d$ 也是 ($b$ 和 $a\ \text{mod}\ b$) 的公约数
4. 同理，我们假设

pre:
1. $m = a\ \mathcal{mod}\ b$ , $d_1 = gcd(a, b)$ , $d_2 = gcd(b, m)$
2. $q = a // b$ ，而且有 $a = qb+m$
4. 大致证明思路：先证$d_1$ 是$d_2$的因子，再反过来证明$d_2$ 是$d_1$的因子, 最后证明$d_1=d_2$

先证$d_1$ 是$d_2$的因子
1. $a$ 和 $b$ 都是$d_1$ 的倍数
2. 那么$m=a-qb \rightarrow \frac{m}{d_1} = \frac{a}{d_1} - q \frac{b}{d_1}$ , 可以知道 $m$ 是$d_1$ 的倍数
3. 所以$d_1$ 是 $m$ 和 $b$ 的公因数，进一步$d_1$ 是 $d_2$ 的因数

再反过来证明$d_2$ 是$d_1$的因子
1. $b$和$m$ 都是 $d_2$ 的倍数
2. 那么$a=qb+m \rightarrow \frac{a}{d_2} = q\frac{b}{d_2} + \frac{m}{d_2}$, 以知道 $m$ 是$d_2$ 的倍数
3. 所以$d_2$ 是 $a$ 和 $b$ 的公因数，进一步$d_2$ 是 $d_1$ 的因数
QED

>[!裴蜀定理]
>如果a,b是正整数，则关于$x$,$y$的方程$ax+by=c$有整数解 当且仅当 $c$ 是 $gcd(a,b)$的倍数

# [1979. 找出数组的最大公约数](https://leetcode.cn/problems/find-greatest-common-divisor-of-array/)
- 给你一个整数数组 `nums` ，返回数组中最大数和最小数的 **最大公约数** 。
```python
class Solution:
    def findGCD(self, nums: List[int]) -> int:
        mn,mx = min(nums),max(nums)
        def gcd(a,b):
            # assume a>b
            while b:
                a, b = b, a%b
            return a
        return gcd(mn, mx)
```
# [365. 水壶问题](https://leetcode.cn/problems/water-and-jug-problem/)
当然可以先用dfs来搜索
```python
class Solution:
    def canMeasureWater(self, x: int, y: int, target: int) -> bool:
        visited = set()
        @cache
        def dfs(i,j):
            if (i,j) in visited:
                return False
            visited.add((i,j))
            if i==target or j==target or i+j==target:
                return True
            if dfs(x,j) or dfs(i,y) or dfs(0,j) or dfs(i,0):
                return True
            # 尝试从i倒到j
            a = min(i, y-j)
            if dfs(i-a, j+a):
                return True
            # 尝试从j倒到i
            b = min(j, x-i)
            if dfs(i+b, j-b):
                return True
            
            return False
        return dfs(0,0)
```

那么应用 裴蜀定理，我们可以拓展 $a$ (or $b$) < 0, 那么对应的操作
1. 往 `y` 壶倒水；
2. 把 `y` 壶的水倒入 `x` 壶； 
3. 如果 `y` 壶不为空，那么 `x` 壶肯定是满的，把 `x` 壶倒空，然后再把 `y` 壶的水倒入 `x` 壶。
> 总共往外面倒了一壶水，可以看作a取负数

```python
class Solution:
    def canMeasureWater(self, x: int, y: int, z: int) -> bool:
        if x + y < z:
            return False
        if x == 0 or y == 0:
            return z == 0 or x + y == z
        return z % math.gcd(x, y) == 0
```