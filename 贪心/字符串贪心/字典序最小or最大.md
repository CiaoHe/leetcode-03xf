# [3474. 字典序最小的生成字符串](https://leetcode.cn/problems/lexicographically-smallest-generated-string/)
给你两个字符串，`str1` 和 `str2`，其长度分别为 `n` 和 `m` 。

如果一个长度为 `n + m - 1` 的字符串 `word` 的每个下标 `0 <= i <= n - 1` 都满足以下条件，则称其由 `str1` 和 `str2` **生成**：

- 如果 `str1[i] == 'T'`，则长度为 `m` 的 **子字符串**（从下标 `i` 开始）与 `str2` 相等，即 `word[i..(i + m - 1)] == str2`。
- 如果 `str1[i] == 'F'`，则长度为 `m` 的 **子字符串**（从下标 `i` 开始）与 `str2` 不相等，即 `word[i..(i + m - 1)] != str2`。

返回可以由 `str1` 和 `str2` **生成** 的 **字典序最小** 的字符串。如果不存在满足条件的字符串，返回空字符串 `""`。

如果字符串 `a` 在第一个不同字符的位置上比字符串 `b` 的对应字符在字母表中更靠前，则称字符串 `a` 的 **字典序 小于** 字符串 `b`。  
如果前 `min(a.length, b.length)` 个字符都相同，则较短的字符串字典序更小。

**子字符串** 是字符串中的一个连续、**非空** 的字符序列。


```python
class Solution:
    def generateString(self, str1: str, str2: str) -> str:
        n,m = len(str1), len(str2)
        s, t = str1, str2

        ans = ['?'] * (n+m-1)

        # 先处理T的情况
        for i,x in enumerate(s):
            if x == 'T':
                # 子串[i:i+m-1]等于t
                for j,c in enumerate(t):
                    v = ans[i+j]
                    if v!='?' and v!=c:
                        return ""
                    ans[i+j] = c
        
        old_ans = ans
        ans = ['a' if c == '?' else c for c in ans]

        # 再处理F
        for i,x in enumerate(s):
            if x != 'F':
                continue
            # 子串[i:i+m-1]必然不等于t
            if ''.join(ans[i:i+m]) != t:
                continue
            # 找到最后一个待定的位置(?)
            for j in range(i+m-1, i-1, -1):
                if old_ans[j] == '?':
                    ans[j] = 'b'
                    break
            else:
                return ""
        
        return ''.join(ans)
```