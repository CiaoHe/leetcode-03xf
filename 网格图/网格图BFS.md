# [2812. 找出最安全路径](https://leetcode.cn/problems/find-the-safest-path-in-a-grid/)
给你一个下标从 **0** 开始、大小为 `n x n` 的二维矩阵 `grid` ，其中 `(r, c)` 表示：

- 如果 `grid[r][c] = 1` ，则表示一个存在小偷的单元格
- 如果 `grid[r][c] = 0` ，则表示一个空单元格

你最开始位于单元格 `(0, 0)` 。在一步移动中，你可以移动到矩阵中的任一相邻单元格，包括存在小偷的单元格。

矩阵中路径的 **安全系数** 定义为：从路径中任一单元格到矩阵中任一小偷所在单元格的 **最小** 曼哈顿距离。

返回所有通向单元格 `(n - 1, n - 1)` 的路径中的 **最大安全系数** 。

单元格 `(r, c)` 的某个 **相邻** 单元格，是指在矩阵中存在的 `(r, c + 1)`、`(r, c - 1)`、`(r + 1, c)` 和 `(r - 1, c)` 之一。

两个单元格 `(a, b)` 和 `(x, y)` 之间的 **曼哈顿距离** 等于 `| a - x | + | b - y |` ，其中 `|val|` 表示 `val` 的绝对值。

> 从大到小枚举安全距离 （最大化最小值）
> 初始化dis, 可以从全1的位置出发跑一个多源的bfs (queue -> bfs)
> 更新dis, **增量地**把恰好等于d的`dis[i][j]`与四周>=d的格子用并查集连起来 -> 最后判断是不是首尾相连 `find(0) == find(-1)`
```python
class Solution:
    def maximumSafenessFactor(self, grid: List[List[int]]) -> int:
        n = len(grid)
        q = deque()
        for i in range(n):
            for j in range(n):
                if grid[i][j] == 1:
                    q.append((i, j))
        # 尽可能绕着 1走, bfs求每个点到1的最短距离
        dist = [[-1] * n for _ in range(n)]
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                if v == 1:
                    dist[i][j] = 0
        
        groups = [q]
        # groups是一个列表，它的第 d个元素存放所有距离恰好为 d的格子。
        # 初始时 groups[0]就是所有 1的坐标列表

        # 多源bfs
        while q:
            tmp = q
            q = []
            for i, j in tmp:
                for x, y in [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]:
                    if 0<=x<n and 0<=y<n and dist[x][y]==-1:
                        dist[x][y] = len(groups)
                        q.append((x, y))
            if q:
                groups.append(q)
        
        # 并查集模版
        fa = list(range(n*n))
        def find(x):
            if fa[x] != x:
                fa[x] = find(fa[x])
            return fa[x]

        # 按照安全距离从大到小枚举答案
        # 最大的应该是 len(groups)-1, 最小的应该是1
        for d in range(len(groups)-1, 0, -1):
            for i, j in groups[d]:
                for x, y in [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]:
                    if 0<=x<n and 0<=y<n and dist[x][y]>=d:
                        fa[find(x*n+y)] = find(i*n+j)
            if find(0) == find(n*n-1):
                return d
        return 0
```