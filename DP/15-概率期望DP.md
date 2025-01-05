# [688. 骑士在棋盘上的概率](https://leetcode.cn/problems/knight-probability-in-chessboard/)
主要是一个类似MC的思路
```python fold
class Solution:
    def knightProbability(self, n: int, k: int, row: int, column: int) -> float:
        dirs = [(1, 2), (1, -2), (-1, 2), (-1, -2), (2, 1), (2, -1), (-2, 1), (-2, -1)]
        @lru_cache(None)
        def dfs(k, x, y):
            if k == 0:
                return 1
            res = 0
            for dx, dy in dirs:
                nx, ny = x + dx, y + dy
                if 0 <= nx < n and 0 <= ny < n:
                    res += dfs(k-1, nx, ny)
            return res
        return dfs(k, row, column) / 8**k
```
# [576. 出界的路径数](https://leetcode.cn/problems/out-of-boundary-paths/)
```python fold
class Solution:
    def findPaths(self, m: int, n: int, maxMove: int, startRow: int, startColumn: int) -> int:
        MOD = 10**9 + 7
        dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        @lru_cache(None)
        def dfs(k, x, y):
	        # 边界条件
            if x < 0 or x >= m or y < 0 or y >= n:
                return 1
            if k == 0:
                return 0
            res = 0
            for dx, dy in dirs:
                nx, ny = x + dx, y + dy
                res += dfs(k-1, nx, ny)
            return res % MOD
        return dfs(maxMove, startRow, startColumn)
```
# [minimax] 用mcmc模拟到角落的概率

一个16x16棋盘上走马，就是说只能横着走2步，竖着走1步，或者竖着走2步横着走1步。假设你的初始位置是左上角(坐标0,0)，请估算从左上角达到任意顶点（包含0,0）要走步数的期望。 
注意点： 1. 棋盘外的点是不合法的。 2. 用蒙特卡罗的思路来做。 3. 向每一个合法的点走的概率是一样的。
```python fold
import random
import numpy as np
def mc_knight_expectation(n:int, trials:int):
    dirs = [(1, 2), (1, -2), (-1, 2), (-1, -2), (2, 1), (2, -1), (-2, 1), (-2, -1)]
    moves = []

    for _ in range(trials):
        x, y = 0, 0
        steps = 0

        while True:
            possible_moves = [(x + dx, y + dy) for dx, dy in dirs if 0 <= x + dx < n and 0 <= y + dy < n]
            if not possible_moves:
                break
            nx, ny = random.choice(possible_moves)
            steps += 1
            x, y = nx, ny
            if (x, y) in [(0, 0), (0, n-1), (n-1, 0), (n-1, n-1)]:
                moves.append(steps)
                break

    return np.mean(moves)

print(mc_knight_expectation(15, 50000))
```