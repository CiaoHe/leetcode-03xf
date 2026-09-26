计算合法子序列的最长长度、个数、元素和等。

一般定义 f[x] 表示以元素 x 结尾的合法子序列的最长长度/个数/元素和，从子序列的倒数第二个数转移过来。

注意这里的 x 不是下标，是元素值。如果 x 不是整数，或者值域范围很大，可以用哈希表代替数组。

# [2900. 最长相邻不相等子序列 I](https://leetcode.cn/problems/longest-unequal-adjacent-groups-subsequence-i/)
先看2901
```python
class Solution:
    def getLongestSubsequence(self, words: List[str], groups: List[int]) -> List[str]:
        n = len(words)
        f = [1] * n
        g = [-1] * n

        for i in range(1, n):
            for j in range(i):
                if groups[i] != groups[j] and f[i] < f[j] + 1:
                    f[i] = f[j] + 1
                    g[i] = j
        
        mi = max(range(n), key=lambda i: f[i])
        res = []
        while mi != -1:
            res.append(words[mi])
            mi = g[mi]
        return res[::-1]
```
# [2901. 最长相邻不相等子序列 II](https://leetcode.cn/problems/longest-unequal-adjacent-groups-subsequence-ii/)
```python
# f[i]: 表示第i个单词结尾的 最长相邻 不相等子序列的长度
# g[i]: 表示以第i个单词结尾的 最长相邻 不相等子序列 中i的前一个单词的下标

# 初始化：
# 对于每一个单词i, 初始的时候都是单独的子序列，所以有f[i]=1, g[i]=-1

# 状态转移
# 我们需要考虑所有在i之前的j (j<i), 看是否能把words[i] 添加到 words[j] 的后面，形成一个更长的 不相等子序列
# 这需要满足以下3个条件
# 1. groups[i] != groups[j], 因为必须不相等
# 2. words[i] 和 words[j]要相邻，这意味着 words[i] 和 words[j] 只有一个字符不同 (hamming=1)
# 3. f[i] < f[j] + 1, 因为我们要形成更长的子序列, 如果f[i] >= f[j] + 1, 那么我们就不需要考虑把words[i] 添加到 words[j] 的后面了

# 如果满足以上三个条件，如何更新?
# 1. f[i] = f[j] + 1
# 2. g[i] = j

# 最后，我们需要找到最长的子序列，并返回这个子序列中的单词 (类似于回溯构建出完整的轨迹)
# 1. 从f中找到最大值对应的下标mi
# 2. 从mi开始，用g来一步步找到前驱 知道g[mi] = -1
# 3. 最后把找到的单词逆序返回
    def getWordsInLongestSubsequence(self, words: List[str], groups: List[int]) -> List[str]:
        def hamming(a, b):
            if len(a)!=len(b):
                return  float('inf') 
            return sum(1 for x,y in zip(a,b) if x!=y)

        n = len(words)
        f = [1] * n
        g = [-1] * n

        for i in range(n):
            for j in range(i):
                if groups[i] != groups[j] and hamming(words[i], words[j]) == 1 and f[i] < f[j] + 1:
                    f[i] = f[j] + 1
                    g[i] = j

        # 找到最大值对应的下标mi
        mi = max(range(n), key=lambda i: f[i]) if n > 0 else -1

        res = []
        while mi != -1:
            res.append(words[mi])
            mi = g[mi]
        return res[::-1]
```

# [940. 不同的子序列 II](https://leetcode.cn/problems/distinct-subsequences-ii/)
给定一个字符串 `s`，计算 `s` 的 **不同非空子序列** 的个数。因为结果可能很大，所以返回答案需要对 **`10^9 + 7` 取余** 。

字符串的 **子序列** 是经由原字符串删除一些（也可能不删除）字符但不改变剩余字符相对位置的一个新字符串。

- 例如，`"ace"` 是 `"_**a**_b_**c**_d_**e**_"` 的一个子序列，但 `"aec"` 不是。
```python
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        n = len(s)
        MOD = 10**9 + 7
        # 计算不同子序列，我们可以用dp的方式
        @cache
        def dp(i, last_char):
            if i == n:
                return 1
            res = dp(i + 1, last_char)  # 不选s[i]
            if s[i] != last_char:
                res += dp(i + 1, s[i])  # 选s[i]
            return res % MOD
        return (dp(0, '') - 1) % MOD  # 减去空子序列
```