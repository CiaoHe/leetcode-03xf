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

# [2897. 对数组执行操作使平方和最大](https://leetcode.cn/problems/apply-operations-on-array-to-maximize-sum-of-squares/)
给你一个下标从 **0** 开始的整数数组 `nums` 和一个 **正** 整数 `k` 。

你可以对数组执行以下操作 **任意次** ：
- 选择两个互不相同的下标 `i` 和 `j` ，**同时** 将 `nums[i]` 更新为 `(nums[i] AND nums[j])` 且将 `nums[j]` 更新为 `(nums[i] OR nums[j])` ，`OR` 表示按位 **或** 运算，`AND` 表示按位 **与** 运算。

你需要从最终的数组里选择 `k` 个元素，并计算它们的 **平方** 之和。

请你返回你可以得到的 **最大** 平方和。由于答案可能会很大，将答案对 `10^9 + 7` **取余** 后返回。


- 认识到
	- `nums[i] = nums[i] & nums[j]` `nums[j] = nums[i] | nums[j]`
	- 这两个操作有一个非常重要的数学性质：**它们不会凭空创造或消灭任何一个二进制位上的 `1`**，它们只是把两个数在某个二进制位上的 `1` 进行了“转移”或“保留”。 也就是说，**整个数组中，每一个二进制位（第 0 位、第 1 位……）上 `1` 的总个数是恒定不变的。**
	- 我们可以操作无数次，所以我们可以把这些 `1` 任意组合，拼成我们想要的数字。
- 我们循环k次
	- 从最高位 `mx-1` 开始往下看。
	- 如果当前位还有剩余的 `1`（即 `cnt[i] > 0`），我们就把它拿过来，拼到当前的数字 `x` 上（`x |= (1 << i)`），并把可用库存减 1（`cnt[i] -= 1`）。
	- 这样循环 $x$ 次后，我们就得到了当前能拼出来的**第 1 大、第 2 大……第 $k$ 大**的数字。
- 每次循环里面
	- `x` 是我们刚刚贪心拼出来的那个**尽可能大的数字**

```python
class Solution:
    def maxSum(self, nums: List[int], k: int) -> int:
        # 可以选择两个不同index i,j, 更新nums[i] = nums[i] & nums[j], nums[j] = nums[i] | nums[j]
        # 可以操作无数次
        # 最后选择k个元素计算平方之和 要最大的
        MOD = 10**9 + 7
        n = len(nums)
        # 我们希望贪心的让每个数字都尽可能变大

        mx = max(nums).bit_length() # 我们拿到最大数字有多少位
        cnt = [0] * mx # 统计每一位上有多少个1
        for num in nums:
            for i in range(mx):
                if num & (1 << i):
                    cnt[i] += 1
        
        ans = 0
        for _ in range(k):
            # 每次选择一个数字, 让它尽可能大
            x = 0
            for i in range(mx-1, -1, -1):
                if cnt[i] > 0:
                    x |= (1 << i)
                    cnt[i] -= 1
            ans = (ans + x * x) % MOD
        return ans
```