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