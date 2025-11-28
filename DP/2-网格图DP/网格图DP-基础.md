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
