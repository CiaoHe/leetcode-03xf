# [3314. 构造最小位运算数组 I](https://leetcode.cn/problems/construct-the-minimum-bitwise-array-i/)
给你一个长度为 `n` 的质数数组 `nums` 。你的任务是返回一个长度为 `n` 的数组 `ans` ，对于每个下标 `i` ，以下 **条件** 均成立：

- `ans[i] OR (ans[i] + 1) == nums[i]`

除此以外，你需要 **最小化** 结果数组里每一个 `ans[i]` 。

如果没法找到符合 **条件** 的 `ans[i]` ，那么 `ans[i] = -1` 。

**质数** 指的是一个大于 1 的自然数，且它只有 1 和自己两个因数。

```python
class Solution:
    def minBitwiseArray(self, nums: List[int]) -> List[int]:
        ans = []
        for x in nums:
            if x % 2 == 0: # a ^ (a+1) 永远是奇数
                ans.append(-1)
            else:
                for i in range(1,32):
                    if (x >> i) & 1 ^ 1: # 检查第i位是否是0
	                    # 如果i-th是0 那么我们找到了从右到左最近的一个0
	                    # 那么从右到左 (i-1)th位就是1，那么我们这个位置就是需要翻转的位置
                        ans.append(x ^ 1 << (i-1)) # 翻转第 i-1 位
                        break
        return ans
```

# [2657. 找到两个数组的前缀公共数组](https://leetcode.cn/problems/find-the-prefix-common-array-of-two-arrays/)
给你两个下标从 **0** 开始长度为 `n` 的整数排列 `A` 和 `B` 。

`A` 和 `B` 的 **前缀公共数组** 定义为数组 `C` ，其中 `C[i]` 是数组 `A` 和 `B` 到下标为 `i` 之前公共元素的数目。

请你返回 `A` 和 `B` 的 **前缀公共数组** 。

如果一个长度为 `n` 的数组包含 `1` 到 `n` 的元素恰好一次，我们称这个数组是一个长度为 `n` 的 **排列** 。

> 用二进制数表示集合，两个二进制数的 AND 就是集合的交集，二进制数中 1 的个数就是交集的大小。
```python
class Solution:
    def findThePrefixCommonArray(self, A: List[int], B: List[int]) -> List[int]:
        ans = []
        p = q = 0
        for a, b in zip(A, B):
            p |= 1 << a
            q |= 1 << b
            ans.append(
                (p & q).bit_count()
            )
        return ans
```