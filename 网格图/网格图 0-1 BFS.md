0-1 BFS 本质是对 Dijkstra 算法的优化。因为边权只有 0 和 1，我们可以把最小堆换成双端队列，遇到 0 边权就加入队首，遇到 1 边权就加入队尾，这样可以保证队首总是最小的，就不需要最小堆了。

# [3286. 穿越网格图的安全路径](https://leetcode.cn/problems/find-a-safe-walk-through-a-grid/)
给你一个 `m x n` 的二进制矩形 `grid` 和一个整数 `health` 表示你的健康值。
你开始于矩形的左上角 `(0, 0)` ，你的目标是矩形的右下角 `(m - 1, n - 1)` 。
你可以在矩形中往上下左右相邻格子移动，但前提是你的健康值始终是 **正数** 。
对于格子 `(i, j)` ，如果 `grid[i][j] = 1` ，那么这个格子视为 **不安全** 的，会使你的健康值减少 1 。
如果你可以到达最终的格子，请你返回 `true` ，否则返回 `false` 。
**注意** ，当你在最终格子的时候，你的健康值也必须为 **正数** 。
```python
class Solution:
    def findSafeWalk(self, grid: List[List[int]], health: int) -> bool:
        m,n = len(grid), len(grid[0])
        # Dijkstra's algo
        dis = [[inf]*n for _ in range(m)]
        dis[0][0] = grid[0][0]
        q = deque([(0,0)])
        while q:
            x,y = q.popleft()
            for dx,dy in [(0,1),(1,0),(-1,0),(0,-1)]:
                nx,ny = x+dx,y+dy
                if 0<=nx<m and 0<=ny<n:
                    cost = grid[nx][ny]
                    if dis[nx][ny] > dis[x][y] + cost:
                        dis[nx][ny] = dis[x][y] + cost
                        if cost == 0:
                            q.appendleft((nx,ny))
                        else:
                            q.append((nx,ny))
        return dis[m-1][n-1] < health
```

# [2290. 到达角落需要移除障碍物的最小数目](https://leetcode.cn/problems/minimum-obstacle-removal-to-reach-corner/)
给你一个下标从 **0** 开始的二维整数数组 `grid` ，数组大小为 `m x n` 。每个单元格都是两个值之一：
- `0` 表示一个 **空** 单元格，
- `1` 表示一个可以移除的 **障碍物** 。
你可以向上、下、左、右移动，从一个空单元格移动到另一个空单元格。
现在你需要从左上角 `(0, 0)` 移动到右下角 `(m - 1, n - 1)` ，返回需要移除的障碍物的 **最小** 数目。

```python
class Solution:
    def minimumObstacles(self, grid: List[List[int]]) -> int:
        m,n = len(grid), len(grid[0])
        q = deque([(0,0)])
        dist = [[inf]*n for _ in range(m)]
        dist[0][0] = 0
        while q:
            i,j = q.popleft()
            for x,y in [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]:
                if 0<=x<m and 0<=y<n:
                    d = dist[i][j] + grid[x][y]
                    if d < dist[x][y]:
                        dist[x][y] = d
                        if grid[x][y]==0:
                            q.appendleft((x,y))
                        else:
                            q.append((x,y))
        return dist[m-1][n-1]
```