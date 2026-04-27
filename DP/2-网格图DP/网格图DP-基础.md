# [64. 最小路径和](https://leetcode.cn/problems/minimum-path-sum/)
```python
class Solution:
    def minPathSum(self, grid: List[List[int]]) -> int:
        m,n = len(grid),len(grid[0])
        @cache
        def dfs(i:int,j:int)->int:
            if i==0 and j==0:
                return grid[0][0]
            return min(
                dfs(i-1,j) if i>0 else float('inf'),
                dfs(i,j-1) if j>0 else float('inf')
            )+grid[i][j]
        return dfs(m-1,n-1)
```
# [63. 不同路径 II](https://leetcode.cn/problems/unique-paths-ii/)
```python
class Solution:
    def uniquePathsWithObstacles(self, obstacleGrid: List[List[int]]) -> int:
        grid = obstacleGrid
        m,n = len(grid),len(grid[0])
        # 检查起点是否是障碍物
        if grid[0][0] == 1:
            return 0
        @cache
        def dfs(i:int,j:int)->None:
            if i==m-1 and j==n-1:
                return 1
            res = 0
            for dx,dy in [(1,0),(0,1)]:
                x,y = i+dx,j+dy
                if 0<=x<m and 0<=y<n and grid[x][y]==0:
                    res += dfs(x,y)
            return res
        return dfs(0,0)
```
# [2435. 矩阵中和能被 K 整除的路径](https://leetcode.cn/problems/paths-in-matrix-whose-sum-is-divisible-by-k/)
给你一个下标从 **0** 开始的 `m x n` 整数矩阵 `grid` 和一个整数 `k` 。你从起点 `(0, 0)` 出发，每一步只能往 **下** 或者往 **右** ，你想要到达终点 `(m - 1, n - 1)` 。

请你返回路径和能被 `k` 整除的路径数目，由于答案可能很大，返回答案对 `109 + 7` **取余** 的结果。
```python
class Solution:
    def numberOfPaths(self, grid: List[List[int]], k: int) -> int:
        m,n = len(grid), len(grid[0])
        MOD = 10**9+7

        @cache
        def dfs(i, j, s):
            if i<0 or j<0:
                return 0
            pre_s = (s - grid[i][j]) % k
            if i == 0 and j == 0:
                return 1 if pre_s == 0 else 0
            return (dfs(i-1, j, pre_s) + dfs(i, j-1, pre_s)) % MOD
        
        ans = dfs(m-1, n-1, 0)
        dfs.cache_clear()  # 避免超出内存限制
        return ans
```
# [120. 三角形最小路径和](https://leetcode.cn/problems/triangle/)
```python
class Solution:
    def minimumTotal(self, triangle: List[List[int]]) -> int:
        n = len(triangle)
        @cache
        def dfs(i:int, j:int)->int:
            # 返回上溯到第i层的收益
            if i==0:
                return triangle[0][0]
            return min(
                dfs(i-1, min(j,i-1)),
                dfs(i-1, max(j-1,0))
            )+triangle[i][j]
        return min(dfs(n-1,j) for j in range(n))
```
# [718. 最长重复子数组](https://leetcode.cn/problems/maximum-length-of-repeated-subarray/)
```python
class Solution:
    def findLength(self, nums1: List[int], nums2: List[int]) -> int:
        m,n = len(nums1), len(nums2)
        dp = [[0]*(n+1) for _ in range(m+1)]
        ans = 0
        for i in range(1,m+1):
            for j in range(1,n+1):
                if nums1[i-1]==nums2[j-1]:
                    dp[i][j] = dp[i-1][j-1]+1
                    ans = max(ans, dp[i][j])
        return ans
```

# [1594. 矩阵的最大非负积](https://leetcode.cn/problems/maximum-non-negative-product-in-a-matrix/)
给你一个大小为 `m x n` 的矩阵 `grid` 。最初，你位于左上角 `(0, 0)` ，每一步，你可以在矩阵中 **向右** 或 **向下** 移动。

在从左上角 `(0, 0)` 开始到右下角 `(m - 1, n - 1)` 结束的所有路径中，找出具有 **最大非负积** 的路径。路径的积是沿路径访问的单元格中所有整数的乘积。

返回 **最大非负积** 对 **`109 + 7`** **取余** 的结果。如果最大积为 **负数** ，则返回 `-1` 。

**注意，**取余是在得到最大积之后执行的。

```python
class Solution:
    def maxProductPath(self, grid: List[List[int]]) -> int:
        mod = 10**9 + 7
        m,n = len(grid), len(grid[0])
        @cache
        def dfs(i, j, product):
            if i == m-1 and j == n-1:
                return product
            if i == m-1:
                return dfs(i, j+1, product * grid[i][j+1])
            if j == n-1:
                return dfs(i+1, j, product * grid[i+1][j])
            return max(dfs(i+1, j, product * grid[i+1][j]), dfs(i, j+1, product * grid[i][j+1]))
        mx = dfs(0, 0, grid[0][0])
        return mx % mod if mx >= 0 else -1
```

更快一点的做法
```python
class Solution:
    def maxProductPath(self, grid: List[List[int]]) -> int:
        mod = 10**9 + 7
        m,n = len(grid), len(grid[0])
        @cache
        def dfs(i, j):
            if i == 0 and j == 0:
                return grid[i][j], grid[i][j]
            mx = float('-inf')
            mn = float('inf')
            x = grid[i][j]
            if i > 0:
                mx1, mn1 = dfs(i-1, j)
                mx = max(mx, mx1 * x, mn1 * x)
                mn = min(mn, mx1 * x, mn1 * x)
            if j > 0:
                mx2, mn2 = dfs(i, j-1)
                mx = max(mx, mx2 * x, mn2 * x)
                mn = min(mn, mx2 * x, mn2 * x)
            return mx, mn
        mx, mn = dfs(m-1, n-1)
        return mx % mod if mx >=0 else -1
```

# [3418. 机器人可以获得的最大金币数](https://leetcode.cn/problems/maximum-amount-of-money-robot-can-earn/)
给你一个 `m x n` 的网格。一个机器人从网格的左上角 `(0, 0)` 出发，目标是到达网格的右下角 `(m - 1, n - 1)`。在任意时刻，机器人只能向右或向下移动。

网格中的每个单元格包含一个值 `coins[i][j]`：

- 如果 `coins[i][j] >= 0`，机器人可以获得该单元格的金币。
- 如果 `coins[i][j] < 0`，机器人会遇到一个强盗，强盗会抢走该单元格数值的 **绝对值** 的金币。

机器人有一项特殊能力，可以在行程中 **最多感化** 2个单元格的强盗，从而防止这些单元格的金币被抢走。

**注意：**机器人的总金币数可以是负数。

返回机器人在路径上可以获得的 **最大金币数** 。

```python
class Solution:
    def maximumAmount(self, coins: List[List[int]]) -> int:
        m,n = len(coins), len(coins[0])
        # 最多可以感化两个海盗
        @cache
        def dfs(i:int, j:int, k:int) -> int:
            if i<0 or j<0:
                return -inf
            x = coins[i][j]
            if i == 0 and j == 0:
                if k>0:
                    return max(x, 0)
                else:
                    return x
            res = max(dfs(i-1, j, k), dfs(i, j-1, k)) + x
            if k>0 and x<0:
                res = max(res, dfs(i-1, j, k-1), dfs(i, j-1, k-1))
            return res
        ans = dfs(m-1, n-1, 2)
        dfs.cache_clear()
        return ans
```