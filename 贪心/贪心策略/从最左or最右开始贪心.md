# [3228. 将 1 移动到末尾的最大操作次数](https://leetcode.cn/problems/maximum-number-of-operations-to-move-ones-to-the-end/)
给你一个 二进制字符串 `s`。

你可以对这个字符串执行 **任意次** 下述操作：

- 选择字符串中的任一下标 `i`（ `i + 1 < s.length` ），该下标满足 `s[i] == '1'` 且 `s[i + 1] == '0'`。
- 将字符 `s[i]` 向 **右移** 直到它到达字符串的末端或另一个 `'1'`。例如，对于 `s = "010010"`，如果我们选择 `i = 1`，结果字符串将会是 `s = "0**001**10"`。

返回你能执行的 **最大** 操作次数。

> 最大op：一定是从左侧开始，这样的话堵车堵的最严重
```python
class Solution:
    def maxOperations(self, s: str) -> int:
        n = len(s)
        # 从最左侧开始，看每个1后面连续0序列的个数
        ans = 0
        i = 0

        # 堵着的1的个数
        k = 0

        while i < n:
            if s[i] == '1':
                k += 1
                i += 1
            else:
                # 遇到了0，可以让前面堵着的k个车往前挪动
                ans += k
                i += 1
                while i<n and s[i] == '0':
                    i += 1
        return ans
```