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
