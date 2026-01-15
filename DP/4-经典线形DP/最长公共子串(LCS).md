# [72. 编辑距离](https://leetcode.cn/problems/edit-distance/)
```python fold
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m,n = len(word1), len(word2)
        @cache
        def dfs(i,j):
            if i==m: return n-j
            if j==n: return m-i
            x, y = word1[i], word2[j]
            if x==y:
                return dfs(i+1,j+1)
            return 1 + min(dfs(i+1,j), dfs(i,j+1), dfs(i+1,j+1))
        return dfs(0,0)
```
# [97. 交错字符串](https://leetcode.cn/problems/interleaving-string/)
思考：
- dfs(i,j) 表示 s1 的前 i 个字符和 s2 的前 j 个字符是否能交错组成 s3 的前 i+j 个字符
- 边界：if `i ==0 and j == 0`: return True
- 转移：`dfs(i,j) = (dfs(i-1,j) and s1[i-1] == s3[i+j-1]) or (dfs(i,j-1) and s2[j-1] == s3[i+j-1])`
```python fold
class Solution:
    def isInterleave(self, s1: str, s2: str, s3: str) -> bool:
        m,n = len(s1), len(s2)
        if m + n != len(s3): return False
        @cache
        def dfs(i,j):
            if i<=0 and j<=0: return True
            return (
                (i>0 and s1[i-1]==s3[i+j-1] and dfs(i-1,j)) or
                (j>0 and s2[j-1]==s3[i+j-1] and dfs(i,j-1))
            )
        return dfs(m,n)
```
# [1458. 两个子序列的最大点积](https://leetcode.cn/problems/max-dot-product-of-two-subsequences/)
给你两个数组 nums1 和 nums2 。

请你返回 nums1 和 nums2 中两个长度相同的 非空 子序列的最大点积。

数组的非空子序列是通过删除原数组中某些元素（可能一个也不删除）后剩余数字组成的序列，但不能改变数字间相对顺序。比方说，[2,3,5] 是 [1,2,3,4,5] 的一个子序列而 [1,5,3] 不是。

```python
class Solution:
    def maxDotProduct(self, nums1: List[int], nums2: List[int]) -> int:
        n = len(nums1)
        m = len(nums2)
        dp = [[-inf] * (m+1) for _ in range(n+1)]
        for i in range(1, n+1):
            for j in range(1, m+1):
                dp[i][j] = max(
                    dp[i-1][j], 
                    dp[i][j-1], 
                    max(dp[i-1][j-1], 0) + nums1[i-1] * nums2[j-1],
                )
        return dp[n][m]
```