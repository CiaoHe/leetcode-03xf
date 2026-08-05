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

# [2654. 使数组所有元素变成 1 的最少操作次数](https://leetcode.cn/problems/minimum-number-of-operations-to-make-all-array-elements-equal-to-1/)
给你一个下标从 **0** 开始的 **正** 整数数组 `nums` 。你可以对数组执行以下操作 **任意** 次：

- 选择一个满足 `0 <= i < n - 1` 的下标 `i` ，将 `nums[i]` 或者 `nums[i+1]` 两者之一替换成它们的最大公约数。

请你返回使数组 `nums` 中所有元素都等于 `1` 的 **最少** 操作次数。如果无法让数组全部变成 `1` ，请你返回 `-1` 。

两个正整数的最大公约数指的是能整除这两个数的最大正整数。

```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        n = len(nums)
        if nums.count(1) > 0:
            return n - nums.count(1)
        
        for length in range(1, n+1):
            # 遍历左端点
            for i in range(n-length+1):
                if gcd(*nums[i:i+length]) == 1:
                    # 需要在这个length长度内进行length-1次操作才能得到一个1
                    # 然后从这个subarray向周围扩散，需要再进行n-1次操作
                    return n-1+length-1
        return -1
```

# [3312. 查询排序后的最大公约数](https://leetcode.cn/problems/sorted-gcd-pair-queries/)
给你一个长度为 `n` 的整数数组 `nums` 和一个整数数组 `queries` 。

`gcdPairs` 表示数组 `nums` 中所有满足 `0 <= i < j < n` 的数对 `(nums[i], nums[j])` 的 最大公约数 **升序** 排列构成的数组。

对于每个查询 `queries[i]` ，你需要找到 `gcdPairs` 中下标为 `queries[i]` 的元素。

请你返回一个整数数组 `answer` ，其中 `answer[i]` 是 `gcdPairs[queries[i]]` 的值。

`gcd(a, b)` 表示 `a` 和 `b` 的 **最大公约数** 。

```python
class Solution:
    def gcdValues(self, nums: List[int], queries: List[int]) -> List[int]:
        mx = max(nums)
        cnt = Counter(nums)

        cnt_gcd = [0] * (mx + 1)
        for i in range(mx, 0, -1):
            c = 0
            for j in range(i, mx + 1, i):
                c += cnt[j]
                # 根据容斥原理：由于这些数对的实际gcd可能是i的倍数的其他数
                # 所以我们需要减去这些数对的个数, 扣除2g, 3g, 4g, ...的情况
                cnt_gcd[i] -= cnt_gcd[j] # gcd 是 2i,3i,4i,... 的数对不能统计进来
            cnt_gcd[i] += c * (c - 1) // 2 # c 个数选 2 个，组成 c*(c-1)/2 个数对
        
        # 计算前缀和，方便后续查询 
        s = list(accumulate(cnt_gcd))
        return [bisect_right(s, q) for q in queries]
```