# [3138. 同位字符串连接的最小长度](https://leetcode.cn/problems/minimum-length-of-anagram-concatenation/)
思考：枚举所有可能的前缀（从小到大）
```python fold
class Solution:
    def minAnagramLength(self, s: str) -> int:
        n = len(s)
        # enumerate all possible subarray
        for length in range(1, n//2+1):
            if n % length != 0:
                continue
            t = sorted(s[:length])
            if all(sorted(s[i:i+length]) == t for i in range(length, n, length)):
                return length
        return n
```