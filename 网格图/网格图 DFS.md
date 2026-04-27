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

# [3551. 数位和排序需要的最小交换次数](https://leetcode.cn/problems/minimum-swaps-to-sort-by-digit-sum/)
给你一个由 **互不相同** 的正整数组成的数组 `nums`，需要根据每个数字的数位和（即每一位数字相加求和）按 **升序** 对数组进行排序。如果两个数字的数位和相等，则较小的数字排在前面。

返回将 `nums` 排列为上述排序顺序所需的 **最小** 交换次数。

一次 **交换** 定义为交换数组中两个不同位置的值。

 #置换环
```python
class Solution:
    def minSwaps(self, nums: List[int]) -> int:
        # 按照数位和从小到大排序，找到需要交换的次数
        nums = [(sum(int(c) for c in str(num)), num, i) for i, num in enumerate(nums)]
        nums.sort(key=lambda x: (x[0], x[1]))
        
        n = len(nums)
        pos = [0] * n 
        for new_idx, (_, _, old_idx) in enumerate(nums):
            pos[old_idx] = new_idx
        
        # 使用visited数组找到置换环
        visited = [False] * n
        swaps = 0

        for i in range(n):
            if not visited[i] and pos[i] != i:
                cycle_len = 0
                j = i
                while not visited[j]:
                    visited[j] = True
                    j = pos[j]
                    cycle_len += 1
                swaps += cycle_len - 1
        return swaps
```

# [1970. 你能穿过矩阵的最后一天](https://leetcode.cn/problems/last-day-where-you-can-still-cross/)

难度分 2123[第254场周赛Q4](https://leetcode.cn/contest/weekly-contest-254 "访问LeetCode竞赛链接")等级 6 困难

给你一个下标从 **1** 开始的二进制矩阵，其中 `0` 表示陆地，`1` 表示水域。同时给你 `row` 和 `col` 分别表示矩阵中行和列的数目。

一开始在第 `0` 天，**整个** 矩阵都是 **陆地** 。但每一天都会有一块新陆地被 **水** 淹没变成水域。给你一个下标从 **1** 开始的二维数组 `cells` ，其中 `cells[i] = [ri, ci]` 表示在第 `i` 天，第 `ri` 行 `ci` 列（下标都是从 **1** 开始）的陆地会变成 **水域** （也就是 `0` 变成 `1` ）。

你想知道从矩阵最 **上面** 一行走到最 **下面** 一行，且只经过陆地格子的 **最后一天** 是哪一天。你可以从最上面一行的 **任意** 格子出发，到达最下面一行的 **任意** 格子。你只能沿着 **四个** 基本方向移动（也就是上下左右）。

请返回只经过陆地格子能从最 **上面** 一行走到最 **下面** 一行的 **最后一天** 。

```python
class Solution:
    def latestDayToCross(self, row: int, col: int, cells: List[List[int]]) -> int:
        def can_cross(day: int) -> bool:
            # 不做grid, 只记录water
            water = set()
            for i in range(day):
                water.add((cells[i][0]-1, cells[i][1]-1))

            visited = set()
            stack = deque()

            for j in range(col):
                if (0, j) not in water:
                    stack.appendleft((0, j))
                    visited.add((0, j))

            while stack:
                i, j = stack.popleft()
                if i == row-1:
                    return True
                for di, dj in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    ni, nj = i+di, j+dj
                    if 0 <= ni < row and 0 <= nj < col and (ni, nj) not in water and (ni, nj) not in visited:
                        stack.appendleft((ni, nj))
                        visited.add((ni, nj))
            return False

        # 二分法
        left, right = 0, len(cells)
        ans = 0
        while left < right:
            mid = (left + right + 1) // 2
            if can_cross(mid):
                left = mid
            else:
                right = mid - 1
        return left
```

# [1559. 二维网格图中探测环](https://leetcode.cn/problems/detect-cycles-in-2d-grid/)
难度分 1837[第33场双周赛Q4](https://leetcode.cn/contest/biweekly-contest-33 "访问LeetCode竞赛链接")等级 7

给你一个二维字符网格数组 `grid` ，大小为 `m x n` ，你需要检查 `grid` 中是否存在 **相同值** 形成的环。

一个环是一条开始和结束于同一个格子的长度 **大于等于 4** 的路径。对于一个给定的格子，你可以移动到它上、下、左、右四个方向相邻的格子之一，可以移动的前提是这两个格子有 **相同的值** 。

同时，你也不能回到上一次移动时所在的格子。比方说，环  `(1, 1) -> (1, 2) -> (1, 1)` 是不合法的，因为从 `(1, 2)` 移动到 `(1, 1)` 回到了上一次移动时的格子。

如果 `grid` 中有相同值形成的环，请你返回 `true` ，否则返回 `false` 。

```python
class Solution:
    def containsCycle(self, grid: List[List[str]]) -> bool:
        m, n = len(grid), len(grid[0])
        # dfs探索
        visited = [[False] * n for _ in range(m)]
        def dfs(x, y, px, py):
            if visited[x][y]:
                return True
            visited[x][y] = True
            for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                nx, ny = x + dx, y + dy
                if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] == grid[x][y] and (nx != px or ny != py):
                    if dfs(nx, ny, x, y):
                        return True
            return False
        for i in range(m):
            for j in range(n):
                if not visited[i][j] and dfs(i, j, -1, -1):
                    return True
        return False
```

# [1391. 检查网格中是否存在有效路径](https://leetcode.cn/problems/check-if-there-is-a-valid-path-in-a-grid/)
给你一个 _m_ x _n_ 的网格 `grid`。网格里的每个单元都代表一条街道。`grid[i][j]` 的街道可以是：

- **1** 表示连接左单元格和右单元格的街道。
- **2** 表示连接上单元格和下单元格的街道。
- **3** 表示连接左单元格和下单元格的街道。
- **4** 表示连接右单元格和下单元格的街道。
- **5** 表示连接左单元格和上单元格的街道。
- **6** 表示连接右单元格和上单元格的街道。

![](https://assets.leetcode.cn/aliyun-lc-upload/uploads/2020/03/21/main.png)

你最开始从左上角的单元格 `(0,0)` 开始出发，网格中的「有效路径」是指从左上方的单元格 `(0,0)` 开始、一直到右下方的 `(m-1,n-1)` 结束的路径。**该路径必须只沿着街道走**。

**注意：**你 **不能** 变更街道。

如果网格中存在有效的路径，则返回 `true`，否则返回 `false` 。

```python
class Solution:
    def hasValidPath(self, grid: List[List[int]]) -> bool:
        m,n = len(grid), len(grid[0])
        choice = {
            1: [(0,1),(0,-1)],
            2: [(1,0),(-1,0)],
            3: [(0,-1),(1,0)],
            4: [(0,1),(1,0)],
            5: [(0,-1),(-1,0)],
            6: [(0,1),(-1,0)],
        }
        visited = [[False]*n for _ in range(m)]
        def dfs(i,j):
            if i==m-1 and j==n-1:
                return True
            visited[i][j] = True
            for di,dj in choice[grid[i][j]]:
                x,y = i+di, j+dj
                if 0<=x<m and 0<=y<n and not visited[x][y] and (-di,-dj) in choice[grid[x][y]]:
                    if dfs(x,y):
                        return True
            visited[i][j] = False
            return False
        return dfs(0,0)
```