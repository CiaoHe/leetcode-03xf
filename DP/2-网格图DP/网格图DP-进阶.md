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
# [3363. 最多可收集的水果数目](https://leetcode.cn/problems/find-the-maximum-number-of-fruits-collected/
有一个游戏，游戏由 `n x n` 个房间网格状排布组成。

给你一个大小为 `n x n` 的二维整数数组 `fruits` ，其中 `fruits[i][j]` 表示房间 `(i, j)` 中的水果数目。有三个小朋友 **一开始** 分别从角落房间 `(0, 0)` ，`(0, n - 1)` 和 `(n - 1, 0)` 出发。

每一位小朋友都会 **恰好** 移动 `n - 1` 次，并到达房间 `(n - 1, n - 1)` ：

- 从 `(0, 0)` 出发的小朋友每次移动从房间 `(i, j)` 出发，可以到达 `(i + 1, j + 1)` ，`(i + 1, j)` 和 `(i, j + 1)` 房间之一（如果存在）。
- 从 `(0, n - 1)` 出发的小朋友每次移动从房间 `(i, j)` 出发，可以到达房间 `(i + 1, j - 1)` ，`(i + 1, j)` 和 `(i + 1, j + 1)` 房间之一（如果存在）。
- 从 `(n - 1, 0)` 出发的小朋友每次移动从房间 `(i, j)` 出发，可以到达房间 `(i - 1, j + 1)` ，`(i, j + 1)` 和 `(i + 1, j + 1)` 房间之一（如果存在）。

当一个小朋友到达一个房间时，会把这个房间里所有的水果都收集起来。如果有两个或者更多小朋友进入同一个房间，只有一个小朋友能收集这个房间的水果。当小朋友离开一个房间时，这个房间里不会再有水果。

请你返回三个小朋友总共 **最多** 可以收集多少个水果。

```python
class Solution:
    def maxCollectedFruits(self, fruits: List[List[int]]) -> int:
        # 从(0,0)出发的小朋友只有一条路径 对角线走
        ans = sum(row[i] for i, row in enumerate(fruits))
        # The other two children won’t intersect its path.
        n = len(fruits)

        # 代码实现的话用dfs(i,j) 逆着顺序走: 从(n-1,n-1)走到原来的出发点位置
        # dfs(i,j) 表示从(i,j)走到(0,0)的最大收集量
        @cache
        def dfs(i, j):
            # 我们希望走的过程不要越过对角线, 即不要越过i+j=n-1这条线, 即需要满足i+j>=n-1
            if not (i+j>=n-1 and j<n):
                return -float('inf')
            if i == 0:
                return fruits[i][j]
            return fruits[i][j] + max(dfs(i-1, j), dfs(i-1, j+1), dfs(i-1, j-1))
        
        # 先计算(0,n-1)哥
        # 最后(n-1,n-1)的收益给了(0,0)哥, 所以从(n-2,n-1)开始走
        ans += dfs(n-2, n-1)

        dfs.cache_clear()

        # 再来考虑(n-1,0)哥
        fruits = list(zip(*fruits))
        ans += dfs(n-2, n-1)

        return ans
```
# [3459. 最长 V 形对角线段的长度](https://leetcode.cn/problems/length-of-longest-v-shaped-diagonal-segment/)
给你一个大小为 `n x m` 的二维整数矩阵 `grid`，其中每个元素的值为 `0`、`1` 或 `2`。

**V 形对角线段** 定义如下：

- 线段从 `1` 开始。
- 后续元素按照以下无限序列的模式排列：`2, 0, 2, 0, ...`。
- 该线段：
    - 起始于某个对角方向（左上到右下、右下到左上、右上到左下或左下到右上）。
    - 沿着相同的对角方向继续，保持 **序列模式** 。
    - 在保持 **序列模式** 的前提下，最多允许 **一次顺时针 90 度转向** 另一个对角方向。

![](https://pic.leetcode.cn/1739609732-jHpPma-length_of_longest3.jpg)

返回最长的 **V 形对角线段** 的 **长度** 。如果不存在有效的线段，则返回 0。

```python

# 用动态规划来确定在斜对角线上移动的最佳位置，同时保持所需的序列。
# 用(row, col, dir, canTurn, target)表示动态规划状态，跟踪当前位置、方向、是否可以转弯以及当前位置的目标值必须等于target。
# 转移：
# 1. 先尝试按照当前位置直行
# 2. 如果可以转弯，尝试转弯
# 3. 返回最大长度

class Solution:
    def lenOfVDiagonal(self, grid: List[List[int]]) -> int:
        n,m = len(grid), len(grid[0])
        DIRS = (1, 1), (1, -1), (-1, -1), (-1, 1)

        @cache
        def dfs(i,j,k,can_turn:bool, target:int) -> int:
            i += DIRS[k][0]
            j += DIRS[k][1]
            if i<0 or i>=n or j<0 or j>=m:
                return 0
            if grid[i][j] != target:
                return 0
            # 先尝试按照当前位置直行
            res = dfs(i,j,k,can_turn,2-target) + 1
            if can_turn:
                res = max(res, dfs(i, j, (k+1)%4, False, 2-target) + 1)
            return res
        
        ans = 0
        for i in range(n):
            for j in range(m):
                if grid[i][j] != 1:
                    continue
                for k in range(4):
                    ans = max(ans, dfs(i,j,k,True, 2)+1)
        return ans
```