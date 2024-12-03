做法有很多：  
1. 枚举选哪个（见讲解）
2. 贪心+二分（见讲解）  
3. 计算 $a$ 和把 $a$ 排序后的数组 $\textit{sortedA}$ 的最长公共子序列。  
4. 数据结构优化（见 2407 题）。
# [300. 最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/)
- 记忆化搜索
```python fold
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        n = len(nums)
        @cache
        def dfs(i: int) -> int:
            # 以i为结尾的最长递增子序列
            if i == 0:
                return 1
            res = 1
            for j in range(i):
                if nums[i] > nums[j]:
                    res = max(res, dfs(j)+1)
            return res
        return max(dfs(i) for i in range(n))

```