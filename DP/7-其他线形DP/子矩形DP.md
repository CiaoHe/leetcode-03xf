#  [1277. 统计全为 1 的正方形子矩阵](https://leetcode.cn/problems/count-square-submatrices-with-all-ones/)
给你一个 `m * n` 的矩阵，矩阵中的元素不是 `0` 就是 `1`，请你统计并返回其中完全由 `1` 组成的 **正方形** 子矩阵的个数。

```python
class Solution:
    def countSquares(self, matrix: List[List[int]]) -> int:
        m, n = len(matrix), len(matrix[0])
        dp = [[0] * n for _ in range(m)] # dp[i][j] 表示以(i, j)为右下角的正方形的边长
        ans = 0
        for i in range(m):
            for j in range(n):
                if matrix[i][j] == 0:
                    continue
                if i*j == 0:
                    # 边界
                    dp[i][j] = 1
                else:
	                # 木桶原理
                    dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1
                ans += dp[i][j]
        return ans
```
# [221. 最大正方形](https://leetcode.cn/problems/maximal-square/)
在一个由 `'0'` 和 `'1'` 组成的二维矩阵内，找到只包含 `'1'` 的最大正方形，并返回其面积。

和 @1277很像
```python
class Solution:
    def maximalSquare(self, matrix: List[List[str]]) -> int:
        m,n=len(matrix),len(matrix[0])
        maxside=0
        dp = [[0]*n for _ in range(m)]
        for i,row in enumerate(matrix):
            for j,x in enumerate(row):
                if matrix[i][j]=='1':
                    if i*j==0:
                        dp[i][j]=1
                    else:
                        dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1
                    maxside = max(dp[i][j], maxside)
        return maxside**2
```


# [3148. 矩阵中的最大得分](https://leetcode.cn/problems/maximum-difference-score-in-a-grid/)
给你一个由 **正整数** 组成、大小为 `m x n` 的矩阵 `grid`。你可以从矩阵中的任一单元格移动到另一个位于正下方或正右侧的任意单元格（不必相邻）。从值为 `c1` 的单元格移动到值为 `c2` 的单元格的得分为 `c2 - c1` 。

你可以从 **任一** 单元格开始，并且必须至少移动一次。

返回你能得到的 **最大** 总得分。

```python
class Solution:
    def maxScore(self, grid: List[List[int]]) -> int:
        # f[i+1][j+1]: (0,0) -> (i,j) sub-matrix的最小值
        # f[i+1][j+1] = min(f[i][j+1], f[i+1][j], grid[i][j])
        # 注意题目要求至少移动一次，也就是起点与终点不能重合
        # 问题其实是找到max(终点和起点的落差)

        ans = -inf
        m, n = len(grid), len(grid[0])
        # 暴力4-loop
        for i, row in enumerate(grid):
            for j,x in enumerate(row):
                # i,j锁定终点
                for k in range(i,m):
                    for l in range(j,n):
                        # k,l锁定起点
                        if k==i and l==j: continue # 不能起点和终点重合
                        ans = max(grid[k][l]-x, ans)
        return ans

```