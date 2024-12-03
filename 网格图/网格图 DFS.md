适用于需要计算连通块个数、大小的题目。
部分题目也可以用 BFS 或并查集解决。
# - [200. 岛屿数量](https://leetcode.cn/problems/number-of-islands/)
```python fold
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

# - [130. 被围绕的区域](https://leetcode.cn/problems/surrounded-regions/)
```python fold
class Solution:
    def solve(self, board: List[List[str]]) -> None:
        """
        Do not return anything, modify board in-place instead.
        """
        m, n = len(board), len(board[0])
        def dfs(x:int, y:int):
            if x < 0 or x >= m or y < 0 or y >= n or board[x][y] != 'O':
                return
            board[x][y] = '2'
            dfs(x+1,y)
            dfs(x-1,y)
            dfs(x,y+1)
            dfs(x,y-1)
        
        # 处理边界：标记所有与边界相连的O
        for i in range(m):
            dfs(i,0)
            dfs(i,n-1)
        for j in range(n):
            dfs(0,j)
            dfs(m-1,j)
        
        # post process：将所有标记的O恢复为O，将所有未标记的O恢复为X
        for i in range(m):
            for j in range(n):
                if board[i][j] == '2':
                    board[i][j] = 'O'
                elif board[i][j] == 'O':
                    board[i][j] = 'X'
```
