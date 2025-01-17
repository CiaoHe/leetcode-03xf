> [!LogTrick]
> 怎么计算连续子数组的 OR？
> 
> 首先，我们有如下 O(n^2) 的暴力算法：
> 外层循环，从 i=0 开始，从左到右遍历 nums。内层循环，从` j=i−1 `开始，从右到左遍历 nums，更新 `nums[j]=nums[j] ∣ nums[i]`。
>-  i=1 时，我们会把 nums[0] 到 nums[1] 的 OR 记录在 nums[0] 中。
>- i=2 时，我们会把 nums[1] 到 nums[2] 的 OR 记录在 nums[1] 中，nums[0] 到 nums[2] 的 OR 记录在 nums[0] 中。
>- i=3 时，我们会把 nums[2] 到 nums[3] 的 OR 记录在 nums[2] 中；nums[1] 到 nums[3] 的 OR 记录在 nums[1] 中；nums[0] 到 nums[3] 的 OR 记录在 nums[0] 中。

把二进制数看成集合，两个数的 OR 就是两个集合的**并集**。
- 把 `nums[i]` 对应的集合记作 $A_i​$。
- i=1时，我们把 $A_0$ 到 $A_1$ 的并集 记录在 $A_0$ 中，也就是把$A_1$ 并入 $A_0$, 所以$A_1$是 $A_0$ 的子集，即 A0​⊇A1​。
- i=2 时，我们会把 A2​ 并入 A1​ 和 A0​，所以有 A0​⊇A1​⊇A2​。
- 一般地，上述代码的内层循环结束时，有 A0​⊇A1​⊇A2​⊇⋯⊇Ai​。
思考：如果 $A_j ​⊇ A_i$ 那么$A_i$ 肯定是左边 $A_0, A_1, ... A_{j-1}$的子集， 所以当我们发现 Ai​ 是 Aj​ 的子集时，就可以退出内层循环了。
> 也就是说当 a 和 b 我们发现 a | b = a, 那么b对应的集合 是 a对应集合的子集

# [898. 子数组按位或操作](https://leetcode.cn/problems/bitwise-ors-of-subarrays/)
- 非常典型的模版题目
```python
class Solution:
    def subarrayBitwiseORs(self, arr: List[int]) -> int:
        ans = set()
        for i,x in enumerate(arr):
            ans.add(x)
            for j in range(i-1, -1, -1):
                if arr[j] | x == arr[j]:
                    break
                arr[j] |= x
                ans.add(arr[j])
        return len(ans)
```
# [3171. 找到按位或最接近 K 的子数组](https://leetcode.cn/problems/find-subarray-with-bitwise-or-closest-to-k/)
- 如果我们发现 `nums[j] | x == nums[j]`, 那就证明再往左收缩 j 也没有意义，所以选择结束
```python
class Solution:
    def minimumDifference(self, nums: List[int], k: int) -> int:
        ans = float('inf')
        for i,x in enumerate(nums):
            ans = min(ans, abs(x - k))
            j = i - 1
            while j >= 0 and nums[j] | x != nums[j]:
                nums[j] |= x
                ans = min(ans, abs(nums[j] - k))
                j -= 1
        return ans
```

# [3097. 或值至少为 K 的最短子数组 II](https://leetcode.cn/problems/shortest-subarray-with-or-at-least-k-ii/)
注意：
- 如果 nums[i] 本身就 `>=k`, 直接返回最小长度 1
```python
class Solution:
    def minimumSubarrayLength(self, nums: List[int], k: int) -> int:
        res = float('inf')
        for i, x in enumerate(nums):
            tmp = x
            if x >= k:
                return 1
            j = i - 1 
            while j >= 0 and nums[j] | x != nums[j]:
                nums[j] |= x
                if nums[j] >= k:
                    res = min(res, i - j + 1)
                j -= 1
        return res if res != float('inf') else -1
```

# [2411. 按位或最大的最小子数组长度](https://leetcode.cn/problems/smallest-subarrays-with-maximum-bitwise-or/)
给你一个长度为 `n` 下标从 **0** 开始的数组 `nums` ，数组中所有数字均为非负整数。对于 `0` 到 `n - 1` 之间的每一个下标 `i` ，你需要找出 `nums` 中一个 **最小** 非空子数组，它的起始位置为 `i` （包含这个位置），同时有 **最大** 的 **按位或**运算值。

- 换言之，令 `Bij` 表示子数组 `nums[i...j]` 的按位或运算的结果，你需要找到一个起始位置为 `i` 的最小子数组，这个子数组的按位或运算的结果等于 `max(Bik)` ，其中 `i <= k <= n - 1` 。
- 一个数组的按位或运算值是这个数组里所有数字按位或运算的结果。

请你返回一个大小为 `n` 的整数数组 `answer`，其中 `answer[i]`是开始位置为 `i` ，按位或运算结果最大，且 **最短** 子数组的长度。

思考：
- 采用通用模版
- 当从 `i-1` 归并到`j` 时，当前的 按位或 结果已经是 目前最大的了，而且此时 从 i 到 j 的距离是最短 -> 毫不犹豫，直接记下
```python
class Solution:
    def smallestSubarrays(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [0] * n
        for i,x in enumerate(nums):
            res[i] = 1
            j = i - 1
            while j >= 0 and nums[j] | x != nums[j]:
                nums[j] |= x
                res[j] = i - j + 1 # 当reduce到j-th时的最大数组 的最小长度
                j -= 1
        return res
```

# [1521. 找到最接近目标值的函数值](https://leetcode.cn/problems/find-a-value-of-a-mysterious-function-closest-to-target/)
- 按位&, 类似[[3171. 找到按位或最接近 K 的子数组](https://leetcode.cn/problems/find-subarray-with-bitwise-or-closest-to-k/)](#[3171.%20找到按位或最接近%20K%20的子数组](https%20//leetcode.cn/problems/find-subarray-with-bitwise-or-closest-to-k/))
```python
class Solution:
    def closestToTarget(self, arr: List[int], target: int) -> int:
        ans = float('inf')
        for i,x in enumerate(arr):
            if x == target:
                return 0
            ans = min(ans, abs(x-target))
            for j in range(i-1, -1, -1):
                if arr[j] & x == arr[j]:
                    break
                arr[j] &= x
                ans = min(ans, abs(arr[j]-target))
        return ans
```
# [3209. 子数组按位与值为 K 的数目](https://leetcode.cn/problems/number-of-subarrays-with-and-value-of-k/)
仍然是从左到右正向遍历 `nums`，对于 `x=nums[i]`，从 `i−1 `开始倒着遍历 `nums[j]`：
- 如果 `nums[j]& != nums[j]`，说明 `nums[j]` 可以变小（求交集后，集合元素只会减少不会变多），更新`nums[j]=nums[j]&x`。
- 否则 `nums[j]&x == nums[j]`，从集合的角度看，此时 `x` 不仅是`nums[j]`的超集，同时也是 `nums[k] (k<j)` 的超集（因为前面的循环保证了每个集合都是其左侧相邻集合的超集），在 `A⊆B` 的前提下，`A∩B=A`，所以后续的循环都不会改变元素值，退出内层循环。

- 按位与的时候: 越往左reduce越小
```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        ans = 0
        for i,x in enumerate(nums):
            for j in range(i-1, -1, -1):
                if nums[j] & x == nums[j]:
                    break
                nums[j] &= x
            # 本质上是这种写法    
            # left=right=0
            # while left<=i and nums[left]<k:
            #    left+=1
            # while right<=i and nums[right]<=k:
            #    right+=1
            # ans += (right-left)
            ans += bisect_right(nums, k, 0, i+1) - bisect_left(nums, k, 0, i+1)
        return ans
```