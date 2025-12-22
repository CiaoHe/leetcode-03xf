做法有很多：  
1. 枚举选哪个（见讲解）
2. 贪心+二分（见讲解）  
3. 计算 $a$ 和把 $a$ 排序后的数组 $\textit{sortedA}$ 的最长公共子序列。  
4. 数据结构优化（见 2407 题）。
# [300. 最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/)
- 记忆化搜索
```python
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

# [960. 删列造序 III](https://leetcode.cn/problems/delete-columns-to-make-sorted-iii/)
给定由 `n` 个小写字母字符串组成的数组 `strs` ，其中每个字符串长度相等。

选取一个删除索引序列，对于 `strs` 中的每个字符串，删除对应每个索引处的字符。

比如，有 `strs = ["abcdef","uvwxyz"]` ，删除索引序列 `{0, 2, 3}` ，删除后为 `["bef", "vyz"]` 。

假设，我们选择了一组删除索引 `answer` ，那么在执行删除操作之后，最终得到的数组的行中的 **每个元素** 都是按**字典序**排列的（即 `(strs[0][0] <= strs[0][1] <= ... <= strs[0][strs[0].length - 1])` 和 `(strs[1][0] <= strs[1][1] <= ... <= strs[1][strs[1].length - 1])` ，依此类推）。

请返回 _`answer.length` 的最小可能值_ 。


```python
class Solution:
    def minDeletionSize(self, strs: List[str]) -> int:
        n = len(strs)
        m = len(strs[0])
        dp = [1] * m # dp[i]表示以第i列为结尾的最长子序列长度

        # 最长子序列上升问题
        for i in range(m):
            for j in range(i):
	            # 如果对于所有str 都能够保证 str[j] <= str[i] for all j<i, 那么这一列的i可以保留, 更新dp[i]
                if all(strs[k][j] <= strs[k][i] for k in range(n)):
                    dp[i] = max(dp[i], dp[j] + 1)
        return m - max(dp)
```