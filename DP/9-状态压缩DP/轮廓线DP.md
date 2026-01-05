# [1411. 给 N x 3 网格图涂色的方案数](https://leetcode.cn/problems/number-of-ways-to-paint-n-3-grid/)
你有一个 `n x 3` 的网格图 `grid` ，你需要用 **红，黄，绿** 三种颜色之一给每一个格子上色，且确保相邻格子颜色不同（也就是有相同水平边或者垂直边的格子颜色不同）。

给你网格图的行数 `n` 。

请你返回给 `grid` 涂色的方案数。由于答案可能会非常大，请你返回答案对 `10^9 + 7` 取余的结果。

```python
class Solution:
    def numOfWays(self, n: int) -> int:
        MOD = 10**9 + 7

        @cache
        def dfs(idx, prev1, prev2, prev3):
            # 表示 在idx-1 row 是prev1, prev2, prev3的排列方式 下 idx to n-1 row 的排列方式
            if idx == n:
                return 1
            count = 0
            
            # tryall the colors (0,1,2) for the first cell of the current row
            for c1 in range(3):
                if c1 == prev1:
                    continue
                # tryall the colors (0,1,2) for the second cell of the current row
                for c2 in range(3):
                    if c2 == prev2 or c2 == c1:
                        continue
                    # tryall the colors (0,1,2) for the third cell of the current row
                    for c3 in range(3):
                        if c3 == prev3 or c3 == c2:
                            continue
                        
                        count = (count + dfs(idx+1, c1, c2, c3)) % MOD
            return count
        return dfs(0, -1, -1, -1)
```