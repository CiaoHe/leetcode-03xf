# [2275. 按位与结果大于零的最长组合](https://leetcode.cn/problems/largest-combination-with-bitwise-and-greater-than-zero/)
- 统计每一位上有多少个1，取最大
```python
class Solution:
    def largestCombination(self, candidates: List[int]) -> int:
        bits = [0] * 32
        for x in candidates:
            for i in range(32):
                bits[i] += (x >> i) & 1
        return max(bits)
```
# [3871. 统计范围内的逗号 II](https://leetcode.cn/problems/count-commas-in-range-ii/)
给你一个整数 `n`。

返回将所有从 `[1, n]`（包含两端）范围内的整数以 **标准** 数字格式书写时所用到的 **逗号总数**。

在 **标准** 格式中：
- 从右边开始，每 **三位** 数字后插入一个逗号。
- 位数 **少于四位** 的数字不包含逗号。

```python
class Solution:
    def countCommas(self, n: int) -> int:
        if n < 1000:
            return 0
        count = 0
        low = 1000
        while low <= n:
            # [low, n]每个数字在当前位置都搞一个逗号
            # 那么一共n-low+1个逗号
            count += n - low + 1
            low *= 1000
        return count
```