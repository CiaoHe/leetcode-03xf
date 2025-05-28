# [1931. 用三种不同颜色为网格涂色](https://leetcode.cn/problems/painting-a-grid-with-three-different-colors/)
给你两个整数 `m` 和 `n` 。构造一个 `m x n` 的网格，其中每个单元格最开始是白色。请你用 **红、绿、蓝** 三种颜色为每个单元格涂色。所有单元格都需要被涂色。
涂色方案需要满足：**不存在相邻两个单元格颜色相同的情况** 。返回网格涂色的方法数。因为答案可能非常大， 返回 **对** `10**9 + 7` **取余** 的结果。

valid[i] 表示一个合法的m x 1 的网格的涂色方案
解决这个问题的思路是：
1. ​**​预处理所有合法的列状态​**​：每一列有 `m` 个格子，每个格子可以是三种颜色之一，但同一列中相邻的格子颜色不能相同。这些列状态可以用三进制数表示，`valid` 列表存储所有合法的列状态。
2. ​**​预处理相邻列的兼容性​**​：对于每一个合法的列状态 `valid[i]`，预处理哪些其他列状态 `valid[j]` 可以放在它的右边，即 `valid[i]` 和 `valid[j]` 对应位置的格子颜色不能相同。这些兼容的列状态的索引存储在 `next_valid` 中。
3. ​**​动态规划（记忆化搜索）​**​：使用 `dfs(i, j)` 表示前 `i+1` 列（从第 0 列到第 `i` 列）的涂色方案数，其中第 `i` 列的涂色状态是 `valid[j]`。通过递归和记忆化来计算总方案数。
```python
class Solution:
    def colorTheGrid(self, m: int, n: int) -> int:
        MOD = 10**9 + 7

        # 1. 预处理所有合法的三进制状态，记录在valid中
        pow3 = [3**i for i in range(m)]
        
        valid = []
        for color in range(3**m):
            for i in range(1,m):
                if color // pow3[i] % 3 == color // pow3[i-1] % 3:
                    break
            else:
                valid.append(color)
        
        # 2. 对于每一个valid[i], 预处理它的下一列颜色，要求左右颜色不同，把valid的下标记录在数组next_valid中
        next_valid = [[] for _ in range(len(valid))]
        for i in range(len(valid)):
            for j in range(len(valid)):
                for p3 in pow3:
                    if valid[i] // p3 % 3 == valid[j] // p3 % 3: # 相邻的颜色相同
                        break
                else:
                    next_valid[i].append(j)
        
        @lru_cache(None)
        def dfs(i:int, j:int) -> int:
            # dfs(i,j): 对于m x i 的网格，右边第i+1 col填入的是valid[j]情况下的涂色方案数目
            # final: dfs(n-1, j) 的累加和
            # initial: dfs(0, j) = 1
            if i == 0:
                return 1
            return sum(dfs(i-1, jj) for jj in next_valid[j]) % MOD
        
        return sum(dfs(n-1, j) for j in range(len(valid))) % MOD
```