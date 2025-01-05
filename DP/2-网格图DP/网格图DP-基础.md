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
