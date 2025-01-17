# [3218. 切蛋糕的最小总开销 I](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-i/)
```python
class Solution:
    def minimumCost(self, m: int, n: int, horizontalCut: List[int], verticalCut: List[int]) -> int:
        # 用dp来解决
        # 子问题：dp(row1, col1, row2, col2) 表示从(row1, col1)到(row2, col2)的最小代价
        # 状态转移：dp(row1, col1, row2, col2) = min(dp(row1, col1, i, col2)+dp(i+1, col1, row2, col2), dp(row1, col1, row2, j)+dp(row1, j+1, row2, col2))
        
        @lru_cache(None)
        def dp(row1, col1, row2, col2):
            if row1 == row2 and col1 == col2:
                return 0
            res = float('inf')
            for i in range(row1, row2):
                res = min(res, dp(row1, col1, i, col2) + dp(i+1, col1, row2, col2) + horizontalCut[i])
            for j in range(col1, col2):
                res = min(res, dp(row1, col1, row2, j) + dp(row1, j+1, row2, col2) + verticalCut[j])
            return res
        
        return dp(0, 0, m-1, n-1)
```
# [3219. 切蛋糕的最小总开销 II](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-ii/)
在3218的基础上对于时间开销有更严格的限制，此时直接用3218方法会G
思考：
1. 代价越大的边 越早切割会越好：否则累积到后面每一大刀都得切多次
2. 使用双指针来代表当前下刀的位置
	1. 如果当前 horizon比vertical更大，那么从horizon走
```python
class Solution:
    def minimumCost(self, m: int, n: int, horizontalCut: List[int], verticalCut: List[int]) -> int:
        # 代价大的越早切越好
        horizontalCut.sort(reverse=True)
        verticalCut.sort(reverse=True)
        # 双指针i,j分别代表horizontalCut和verticalCut的切点
        i, j = 0, 0
        res = 0
        h, v = 1, 1 # 代表此前列数和行数（代表当前如果切割需要乘上的multiplier)
        while i < m-1 or j < n-1: # 边界
            if j==n-1 or (i<m-1 and horizontalCut[i] > verticalCut[j]):
                res += horizontalCut[i] * v
                i += 1
                h += 1
            else:
                res += verticalCut[j] * h
                j += 1
                v += 1
        return res
```
# [403. 青蛙过河](https://leetcode.cn/problems/frog-jump/)
设计子状态 `f(i,k)`: 当前在第`i` 块石头，上一次跳跃的距离为`k`
```python
class Solution:
    def canCross(self, stones: List[int]) -> bool:
        n = len(stones)
        @lru_cache(None)
        def dfs(i,k)->bool:
            """
            i: 当前石头索引
            k: 上一次跳跃的距离
            """
            if i == n-1:
                return True
            for step in [k-1,k,k+1]:
                if step > 0:
                    next_stone = stones[i] + step
                    if next_stone in stones:
                        if dfs(stones.index(next_stone), step):
                            return True
            return False
        return dfs(0,0)
```