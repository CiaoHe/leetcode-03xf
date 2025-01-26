# [2944. 购买水果需要的最少金币数](https://leetcode.cn/problems/minimum-number-of-coins-for-fruits/)
- 本题所有下标都是从1开始，所以我们实际获得的value应该是`prices[i-1]`
```python
class Solution:
    def minimumCoins(self, prices: List[int]) -> int:
        n = len(prices)
        @lru_cache(None)
        def dfs(i):
            if i*2 >= n:
                return prices[i-1]
            return min(dfs(j) for j in range(i+1, i+i+2)) + prices[i-1]
        return dfs(1) # 从1开始

```