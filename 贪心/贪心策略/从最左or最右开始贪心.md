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
# [955. 删列造序 II](https://leetcode.cn/problems/delete-columns-to-make-sorted-ii/)
给定由 `n` 个字符串组成的数组 `strs`，其中每个字符串长度相等。

选取一个删除索引序列，对于 `strs` 中的每个字符串，删除对应每个索引处的字符。

比如，有 `strs = ["abcdef", "uvwxyz"]`，删除索引序列 `{0, 2, 3}`，删除后 `strs` 为`["bef", "vyz"]`。

假设，我们选择了一组删除索引 `answer`，那么在执行删除操作之后，最终得到的数组的元素是按 **字典序**（`strs[0] <= strs[1] <= strs[2] ... <= strs[n - 1]`）排列的，然后请你返回 `answer.length` 的最小可能值。

```python
class Solution:
    def minDeletionSize(self, strs: List[str]) -> int:
        n = len(strs)
        m = len(strs[0])
        ans = 0
        a = [''] * n #维护每个str删除列后剩下的chars

        for j in range(m):
            for i in range(n-1):
	            # 如果当前这一列保留 会导致s[i]>s[i+1]那么需要舍去
                if a[i] + strs[i][j] > a[i+1] + strs[i+1][j]:
                    ans += 1
                    break
            else:
                for i in range(n):
                    a[i] += strs[i][j]
        return ans
```