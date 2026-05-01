# [3218. 切蛋糕的最小总开销 I](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-i/)
```python
class Solution:
    def minimumCost(self, m: int, n: int, horizontalCut: List[int], verticalCut: List[int]) -> int:
        # 用dp来解决
        # 子问题：dp(row1, col1, row2, col2) 表示从(row1, col1)到(row2, col2)的最小代价
        # 状态转移：dp(row1, col1, row2, col2) = min(dp(row1, col1, i, col2)+dp(i+1, col1, row2, col2), dp(row1, col1, row2, j)+dp(row1, j+1, row2, col2))
        
        @lru_cache(None)
        def dp(row1, col1, row2, col2):
            if row1 == row2 and col1 == col2:
                return 0
            res = float('inf')
            for i in range(row1, row2):
                res = min(res, dp(row1, col1, i, col2) + dp(i+1, col1, row2, col2) + horizontalCut[i])
            for j in range(col1, col2):
                res = min(res, dp(row1, col1, row2, j) + dp(row1, j+1, row2, col2) + verticalCut[j])
            return res
        
        return dp(0, 0, m-1, n-1)
```
# [3219. 切蛋糕的最小总开销 II](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-ii/)
在3218的基础上对于时间开销有更严格的限制，此时直接用3218方法会G
思考：
1. 代价越大的边 越早切割会越好：否则累积到后面每一大刀都得切多次
2. 使用双指针来代表当前下刀的位置
	1. 如果当前 horizon比vertical更大，那么从horizon走
```python
class Solution:
    def minimumCost(self, m: int, n: int, horizontalCut: List[int], verticalCut: List[int]) -> int:
        # 代价大的越早切越好
        horizontalCut.sort(reverse=True)
        verticalCut.sort(reverse=True)
        # 双指针i,j分别代表horizontalCut和verticalCut的切点
        i, j = 0, 0
        res = 0
        h, v = 1, 1 # 代表此前列数和行数（代表当前如果切割需要乘上的multiplier)
        while i < m-1 or j < n-1: # 边界
            if j==n-1 or (i<m-1 and horizontalCut[i] > verticalCut[j]):
                res += horizontalCut[i] * v
                i += 1
                h += 1
            else:
                res += verticalCut[j] * h
                j += 1
                v += 1
        return res
```
# [403. 青蛙过河](https://leetcode.cn/problems/frog-jump/)
设计子状态 `f(i,k)`: 当前在第`i` 块石头，上一次跳跃的距离为`k`
```python
class Solution:
    def canCross(self, stones: List[int]) -> bool:
        n = len(stones)
        @lru_cache(None)
        def dfs(i,k)->bool:
            """
            i: 当前石头索引
            k: 上一次跳跃的距离
            """
            if i == n-1:
                return True
            for step in [k-1,k,k+1]:
                if step > 0:
                    next_stone = stones[i] + step
                    if next_stone in stones:
                        if dfs(stones.index(next_stone), step):
                            return True
            return False
        return dfs(0,0)
```
# [2209. 用地毯覆盖后的最少白色砖块](https://leetcode.cn/problems/minimum-white-tiles-after-covering-with-carpets/)
- Let `DP[i][j] `denote the minimum number of white tiles still visible from indices `i` to `floor.length-1` after covering with at most `j `carpets. (从左往右思考)
```python
class Solution:
    def minimumWhiteTiles(self, floor: str, numCarpets: int, carpetLen: int) -> int:
        n = len(floor)
        dp = [[0] * (numCarpets + 1) for _ in range(n+1)]

        # transition: dp[i][j] = min(dp[i + 1][j] + (floor[i] == '1'), dp[i + carpetLen][j - 1])
        for i in range(n - 1, -1, -1):
            for j in range(numCarpets + 1):
                # not to cover, so the left white number equals to dp[i+1][j], if i-th is white, we need add one:
                if floor[i] == '1':
                    dp[i][j] = dp[i + 1][j] + 1
                else:
                    dp[i][j] = dp[i + 1][j]
                    
                # if we have carpets left, we can cover the current tile with a carpet
                if j > 0:
                    dp[i][j] = min(dp[i][j], dp[min(i + carpetLen, n)][j - 1])
        return dp[0][numCarpets]

```

# [1320. 二指输入的的最小距离](https://leetcode.cn/problems/minimum-distance-to-type-a-word-using-two-fingers/)

二指输入法定制键盘在 **X-Y** 平面上的布局如上图所示，其中每个大写英文字母都位于某个坐标处。

- 例如字母 **A** 位于坐标 **(0,0)**，字母 **B** 位于坐标 **(0,1)**，字母 **P** 位于坐标 **(2,3)** 且字母 **Z** 位于坐标 **(4,1)**。

给你一个待输入字符串 `word`，请你计算并返回在仅使用两根手指的情况下，键入该字符串需要的最小移动总距离。

坐标 `**(x1,y1)**` 和 `**(x2,y2)**` 之间的 **距离** 是 `**|x1 - x2| + |y1 - y2|**`。 

**注意**，两根手指的起始位置是零代价的，不计入移动总距离。你的两根手指的起始位置也不必从首字母或者前两个字母开始。
```python
from functools import cache

class Solution:
    def minimumDistance(self, word: str) -> int:
        # 坐标位置
        pos = {
            'A': (0, 0), 'B': (0, 1), 'C': (0, 2), 'D': (0, 3), 'E': (0, 4), 'F': (0, 5),
            'G': (1, 0), 'H': (1, 1), 'I': (1, 2), 'J': (1, 3), 'K': (1, 4), 'L': (1, 5),
            'M': (2, 0), 'N': (2, 1), 'O': (2, 2), 'P': (2, 3), 'Q': (2, 4), 'R': (2, 5),
            'S': (3, 0), 'T': (3, 1), 'U': (3, 2), 'V': (3, 3), 'W': (3, 4), 'X': (3, 5),
            'Y': (4, 0), 'Z': (4, 1),
        }
        
        def distance(p1, p2):
            return abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])
        
        @cache
        def dfs(i, f1, f2):
            # i: 当前需要输入的字符索引
            # f1: 手指1所在的字符 (如果未放置则为 None)
            # f2: 手指2所在的字符 (如果未放置则为 None)
            
            # 已经输入完所有字符，后续移动距离为 0
            if i == len(word):
                return 0
            
            target = word[i]
            
            # 方案一：用手指 1 去按 target
            # 如果 f1 是 None，说明手指1是第一次放上去，代价为0
            cost1 = 0 if f1 is None else distance(pos[f1], pos[target])
            res1 = cost1 + dfs(i + 1, target, f2)
            
            # 方案二：用手指 2 去按 target
            # 如果 f2 是 None，说明手指2是第一次放上去，代价为0
            cost2 = 0 if f2 is None else distance(pos[f2], pos[target])
            res2 = cost2 + dfs(i + 1, f1, target)
            
            # 返回两种方案中的较小值
            return min(res1, res2)
        
        # 初始状态：要输入第 0 个字符，两根手指都还没放在键盘上 (None)
        return dfs(0, None, None)
```
# [3225. 网格图操作后的最大分数](https://leetcode.cn/problems/maximum-score-from-grid-operations/)
难度分 3027[第135场双周赛Q4](https://leetcode.cn/contest/biweekly-contest-135 "访问LeetCode竞赛链接")等级 10 困难 IOI2022

给你一个大小为 `n x n` 的二维矩阵 `grid` ，一开始所有格子都是白色的。一次操作中，你可以选择任意下标为 `(i, j)` 的格子，并将第 `j` 列中从最上面到第 `i` 行所有格子改成黑色。

如果格子 `(i, j)` 为白色，且左边或者右边的格子至少一个格子为黑色，那么我们将 `grid[i][j]` 加到最后网格图的总分中去。

请你返回执行任意次操作以后，最终网格图的 **最大** 总分数。

```python
class Solution:
    def maximumScore(self, grid: List[List[int]]) -> int:
        n = len(grid)
        # 每一列的前缀和
        col_sum = [list(accumulate(col, initial=0)) for col in zip(*grid)]

        # pre: 第j+1列的黑格的个数
        # dec = True: 第j+1列的黑格个数(pre) < 第j+2列的黑格个数
        @cache
        def dfs(j: int, pre: int, dec: bool) -> int:
            # j: 当前列
            # pre: 第j+1列的黑格的个数
            # dec: 是否已经递减过了
            if j < 0:
                return 0
            res = 0
            # 枚举第j列的黑格个数，记为cur
            for cur in range(n+1):
                # 情况一：第j列的黑格个数 = 第j+1列的黑格个数
                if cur == pre:
                    # 没有可以计入总分的格子
                    res = max(res, dfs(j-1, cur, dec=False))
                # 情况二：第j列的黑格个数 < 第j+1列的黑格个数
                elif cur < pre:
                    # 可以计入总分的格子个数 = pre - cur
                    res = max(res, dfs(j-1, cur, dec=True) + col_sum[j][pre] - col_sum[j][cur])
                # 情况三：第j列的黑格个数 > 第j+1列的黑格个数 >= 第j+2列的黑格个数
                elif not dec:
                    # 第j+1列的[pre, cur)区间内的黑格个数可以计入总分
                    res = max(res, dfs(j-1, cur, dec=False) + col_sum[j+1][cur] - col_sum[j+1][pre])
                # 情况四（凹形）：cur > pre < 第 j+2 列的黑格个数
                elif pre == 0:
                    # 此时第 j+2 列全黑最优（递归过程中一定可以枚举到这种情况）
                    # 第 j+1 列全白是最优的，所以只需考虑 pre=0 的情况
                    res = max(res, dfs(j-1, cur, dec=False))
            return res
        return max(dfs(n-2, pre, dec=False) for pre in range(n+1))
```