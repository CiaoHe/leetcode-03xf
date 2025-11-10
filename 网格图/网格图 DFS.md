适用于需要计算连通块个数、大小的题目。
部分题目也可以用 BFS 或并查集解决。
# [200. 岛屿数量](https://leetcode.cn/problems/number-of-islands/)
```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        m,n = len(grid),len(grid[0])
        ans = 0
        
        def dfs(x:int, y:int):
            # 如果出界或者走出陆地， 返回
            if x < 0 or x >= m or y < 0 or y >= n or grid[x][y] != '1':
                return
            # 插旗
            grid[x][y] = '2'
            dfs(x+1,y)
            dfs(x-1,y)
            dfs(x,y+1)
            dfs(x,y-1)
        
        for i in range(m):
            for j in range(n):
                if grid[i][j] == '1':
                    dfs(i,j)
                    ans += 1
        return ans
```

# [130. 被围绕的区域](https://leetcode.cn/problems/surrounded-regions/)
思考：沿着boarder溜一圈来找到可以被拯救的内部的‘O'
```python
class Solution:
    def solve(self, board: List[List[str]]) -> None:
        """
        Do not return anything, modify board in-place instead.
        """
        m, n = len(board), len(board[0])

        def dfs(x, y):
            if x<0 or x>=m or y<0 or y>=n or board[x][y] != 'O':
                return
            board[x][y] = 'A' # mark as visited
            for dx, dy in [(0,1), (0,-1), (1,0), (-1,0)]:
                dfs(x+dx, y+dy)
        
        # mark all 'O' on the border
        for i in range(m):
            dfs(i, 0)
            dfs(i, n-1)
        for j in range(n):
            dfs(0, j)
            dfs(m-1, j)
        
        for i in range(m):
            for j in range(n):
                if board[i][j] == 'O': # 所有剩下的'O'都是被包围的
                    board[i][j] = 'X'
                elif board[i][j] == 'A': # 所有被标记的'O'都是未被包围的
                    board[i][j] = 'O'
```

# [695. 岛屿的最大面积](https://leetcode.cn/problems/max-area-of-island/)
使用BFS去做+visit数组
```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        # 思考：
        # 1. 使用bfs向四周拓展，记得使用visited数组
        visited = [[False]*n for _ in range(m)]
        q = deque()
        for i in range(m):
            for j in range(n):
                if grid[i][j]==1 and not visited[i][j]:
                    q.append((i, j))
                    visited[i][j] = True
                    area = 0
                    while q:
                        x, y = q.popleft()
                        area += 1
                        for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                            nx, ny = x+dx, y+dy
                            if 0<=nx<m and 0<=ny<n and grid[nx][ny] == 1 and not visited[nx][ny]:
                                q.append((nx, ny))
                                visited[nx][ny] = True
                    res = max(res, area)
        return res
```
用DFS
- 这里我们想用`lru_cache`但是会出错，因为我们在操作过程中会改变`grid`, `@lru_cache` 无法正确检测到对象的变化，从而导致缓存结果错误
```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        def dfs(x:int, y:int) -> int:
            # function: 返回以(x,y)为起点的岛屿面积
            if not (0<=x<m and 0<=y<n and grid[x][y]==1):
                return 0
            grid[x][y] = -1
            return 1 + dfs(x+1, y) + dfs(x-1, y) + dfs(x, y+1) + dfs(x, y-1)
        
        res = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    res = max(res, dfs(i, j))
        return res
```

# [463. 岛屿的周长](https://leetcode.cn/problems/island-perimeter/)
每个1周围有1个1就会减去1条边
```python
class Solution:
    def islandPerimeter(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        res = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    res += 4
                    # 检查上方有没有连着的
                    if i and grid[i-1][j] == 1:
                        res -= 1
                    # 检查左边有没有连着的
                    if j and grid[i][j-1] == 1:
                        res -= 1
                    # 检查下方有没有连着的
                    if i<m-1 and grid[i+1][j] == 1:
                        res -= 1
                    # 检查右边有没有连着的
                    if j<n-1 and grid[i][j+1] == 1:
                        res -= 1
        return res
```

# [529. 扫雷游戏](https://leetcode.cn/problems/minesweeper/)
- 如果有雷，直接插旗返回
- 对于空地
	- 先检查周围八个方向是不是有雷
		- 如果有雷，那么插成 雷数，直接返回
	- 否则，证明没有雷，继续dfs
- 加个visited及时prune
```python
class Solution:
    def updateBoard(self, board: List[List[str]], click: List[int]) -> List[List[str]]:
        m, n = len(board), len(board[0])
        x, y = click
        visited = set()

        def dfs(x, y):
            if (x, y) in visited:
                return
            visited.add((x, y))
            board[x][y] = 'B'
            # 检查周围8个方向, 看是否有地雷
            cnt = 0
            for dx, dy in [(0,1), (0,-1), (1,0), (-1,0), (1,1), (1,-1), (-1,1), (-1,-1)]:
                nx, ny = x+dx, y+dy
                if 0<=nx<m and 0<=ny<n and board[nx][ny] == 'M':
                    cnt += 1
            if cnt > 0:
                board[x][y] = str(cnt)
                return
            else:
                for dx, dy in [(0,1), (0,-1), (1,0), (-1,0), (1,1), (1,-1), (-1,1), (-1,-1)]:
                    nx, ny = x+dx, y+dy
                    if 0<=nx<m and 0<=ny<n and (nx, ny) not in visited:
                        dfs(nx, ny)

        # 如果点击的是地雷，直接返回
        if board[x][y] == 'M':
            board[x][y] = 'X'
            return board
        dfs(x, y)
        return board
```
# [417. 太平洋大西洋水流问题](https://leetcode.cn/problems/pacific-atlantic-water-flow/)
有一个 `m × n` 的矩形岛屿，与 **太平洋** 和 **大西洋** 相邻。 **“太平洋”** 处于大陆的左边界和上边界，而 **“大西洋”** 处于大陆的右边界和下边界。

这个岛被分割成一个由若干方形单元格组成的网格。给定一个 `m x n` 的整数矩阵 `heights` ， `heights[r][c]` 表示坐标 `(r, c)` 上单元格 **高于海平面的高度** 。

岛上雨水较多，如果相邻单元格的高度 **小于或等于** 当前单元格的高度，雨水可以直接向北、南、东、西流向相邻单元格。水可以从海洋附近的任何单元格流入海洋。

返回网格坐标 `result` 的 **2D 列表** ，其中 `result[i] = [ri, ci]` 表示雨水从单元格 `(ri, ci)` 流动 **既可流向太平洋也可流向大西洋** 。

```python
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        m, n = len(heights), len(heights[0])

        def dfs(x, y, vis):
            vis.add((x, y))
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = x + dx, y + dy
                if 0 <= nx < m and 0 <= ny < n and (nx, ny) not in vis and heights[nx][ny] >= heights[x][y]:
                    dfs(nx, ny, vis)
        
        pacific = set()
        atlantic = set()
        for i in range(m):
            dfs(i, 0, pacific)
            dfs(i, n-1, atlantic)
        for j in range(n):
            dfs(0, j, pacific)
            dfs(m-1, j, atlantic)
        return list(pacific & atlantic)
```
