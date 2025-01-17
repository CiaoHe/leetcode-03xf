# [329. 矩阵中的最长递增路径](https://leetcode.cn/problems/longest-increasing-path-in-a-matrix/)
- 走过的点对于其他方案来说仍然可以走，所以不需要设计 `visited`来标记已经遍历过的点
```python
class Solution:
    def longestIncreasingPath(self, matrix: List[List[int]]) -> int:
        m,n = len(matrix),len(matrix[0])
        @lru_cache(None)
        def dfs(x,y)->int:
            res = 1
            for dx,dy in [(-1,0),(1,0),(0,-1),(0,1)]:
                nx,ny = x+dx,y+dy
                if 0<=nx<m and 0<=ny<n and matrix[nx][ny]>matrix[x][y]:
                    res = max(res, dfs(nx,ny)+1)
            return res
        ans = 0
        for i in range(m):
            for j in range(n):
                ans = max(ans, dfs(i,j))
        return ans
```
