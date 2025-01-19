# [312. 戳气球](https://leetcode.cn/problems/burst-balloons/)
- `dfs(l,r)`: 现在要戳爆的气球的范围在 `[l,r]` 闭区间范围内
```python
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        n=len(nums)
        nums=[1]+nums+[1]
        @lru_cache(None)
        def dfs(l,r):
            # l,r: 可以确定选择的点
            if l>r:
                return 0
            return max(
                nums[l-1]*nums[i]*nums[r+1]+dfs(l,i-1)+dfs(i+1,r)
                for i in range(l,r+1)
            )
        return dfs(1,n)
```