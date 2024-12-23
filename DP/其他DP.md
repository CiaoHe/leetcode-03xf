# [1387. 将整数按权重排序](https://leetcode.cn/problems/sort-integers-by-the-power-value/)
```python fold
class Solution:
    def getKth(self, lo: int, hi: int, k: int) -> int:
        @lru_cache(None)
        def get_power(x):
            if x == 1:
                return 0
            if x % 2 == 0:
                return 1 + get_power(x // 2)
            else:
                return 1 + get_power(3 * x + 1)
        return sorted(range(lo, hi + 1), key=get_power)[k - 1]
```