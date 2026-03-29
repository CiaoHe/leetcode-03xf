# [2573. 找出对应 LCP 矩阵的字符串](https://leetcode.cn/problems/find-the-string-with-lcp/)

对任一由 `n` 个小写英文字母组成的字符串 `word` ，我们可以定义一个 `n x n` 的矩阵，并满足：

- `lcp[i][j]` 等于子字符串 `word[i,...,n-1]` 和 `word[j,...,n-1]` 之间的最长公共前缀的长度。

给你一个 `n x n` 的矩阵 `lcp` 。返回与 `lcp` 对应的、按字典序最小的字符串 `word` 。如果不存在这样的字符串，则返回空字符串。

对于长度相同的两个字符串 `a` 和 `b` ，如果在 `a` 和 `b` 不同的第一个位置，字符串 `a` 的字母在字母表中出现的顺序先于 `b` 中的对应字母，则认为字符串 `a` 按字典序比字符串 `b` 小。例如，`"aabd"` 在字典上小于 `"aaca"` ，因为二者不同的第一位置是第三个字母，而 `'b'` 先于 `'c'` 出现。

```python
ascii_lowercase = "abcdefghijklmnopqrstuvwxyz"
class Solution:
    def findTheString(self, lcp: List[List[int]]) -> str:
        n = len(lcp)
        s = [""] * n
        i = 0 # s的指针
        # 易得：在有解的情况下 s[0]=a
        # 如果lcp[0][j]>0, 则s[j]=s[0]=a
        # 如果lcp[0][j]==0, 则s[j]需要是其他字符
        # 所以当且仅当lcp[0][j]>0时，s[j]=a

        # 一次类推 找到第一个没有填入字母的位置i 然后尽可能填当前最小的字母
        # 如果26个字母都填完了 s里面还有空位则无解
        for c in ascii_lowercase:
            for j in range(i, n):
                if lcp[i][j] > 0:
                    s[j] = c
            while i < n and s[i] != "":
                i += 1
            if i == n:
                break
        
        if i < n: # 证明还有空位没有填入字母
            return ""
        
        # 这里还要验证现在的s是否符合lcp
        # lcp[i][j] 实际上求的是“两个后缀的最长公共前缀”。
        for i in range(n-1, -1, -1):
            for j in range(n-1, -1, -1):
                if s[i] != s[j]:
                    actual_lcp = 0
                else:
                    if i == n-1 or j == n-1:
                        actual_lcp = 1
                    else:
                        actual_lcp = lcp[i+1][j+1] + 1
                if actual_lcp != lcp[i][j]:
                    return ""
        return "".join(s)
```