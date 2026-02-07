# [209. 长度最小的子数组l](https://leetcode.cn/problems/minimum-size-subarray-sum/description/)
```python
class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        n=len(nums)
        l=0
        # 确保最差的条件也可以满足
        if sum(nums)<target:
            return 0
        res=n
        tmp=0
        # 滑动right
        for r,x in enumerate(nums):
            tmp+=x
            # 尝试收缩l
            while tmp>=target: # 条件破坏，需要收缩
                res = min(r-l+1, res)
                tmp -= nums[l]
                l+=1
        return res

# 或者可写成 只更新一遍
for r,x in enumerate(nums):
	tmp+=x
	while tmp>=target:
		tmp -= nums[l]
		l+=1
	# regret
	if tmp < target:
		l -= 1
		tmp += nums[l]
	res = min(r-l+1, mi)            
```
# [76. 最小覆盖子串](https://leetcode.cn/problems/minimum-window-substring/)
能用hash还是老老实实用hash
```python
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        t_count = Counter(t)
        left, right = 0, len(s)
        s_count = Counter()

        i = 0
        for j, char in enumerate(s):
            s_count[char] += 1
            while s_count >= t_count:
                if j-i < right - left: # 可以收缩
                    left, right = i, j
                s_count[s[i]] -= 1
                i += 1
        if left == 0 and right == len(s):
            return ""
        return s[left:right+1]
```
# [632. 最小区间](https://leetcode.cn/problems/smallest-range-covering-elements-from-k-lists/)
堆的解法
- 维护一个最小堆，记录`(value, arr-id, inner-arr-id)`
- 每次弹走堆顶(`i`-th arr的第`j`个数字)，然后尝试把(`i`-th arr的第`j+1`个数字)加进来
	- 趁这个机会更新l and r
```python fold
class Solution:
    def smallestRange(self, nums: List[List[int]]) -> List[int]:
        k = len(nums)
        # 维护一个最小堆，每次pop掉一个元素，然后push进去一个元素
        h = []
        for i in range(k):
            heappush(h, (nums[i][0], i, 0)) # 代表第i个数组的第0个元素
        ans_l = h[0][0]
        ans_r = max(arr[0] for arr in nums)
        r = ans_r

        while True:
            _, i, j = h[0] 
            if j==len(nums[i])-1:
                break
            x = nums[i][j+1] # 下一个元素
            heapreplace(h, (x, i, j+1)) # 替换掉堆顶
            r = max(r, x)
            l = h[0][0]
            # 如果可以更新
            if r-l < ans_r-ans_l:
                ans_r = r
                ans_l = l
            
        return [ans_l, ans_r]
```

# [3634. 使数组平衡的最少移除数目](https://leetcode.cn/problems/minimum-removals-to-balance-array/)
给你一个整数数组 `nums` 和一个整数 `k`。

如果一个数组的 **最大** 元素的值 **至多** 是其 **最小** 元素的 `k` 倍，则该数组被称为是 **平衡** 的。

你可以从 `nums` 中移除 **任意** 数量的元素，但不能使其变为 **空** 数组。

返回为了使剩余数组平衡，需要移除的元素的 **最小** 数量。

**注意：**大小为 1 的数组被认为是平衡的，因为其最大值和最小值相等，且条件总是成立。

```python
class Solution:
    def minRemoval(self, nums: List[int], k: int) -> int:
        nums.sort()
        # 每一次删除需考虑究竟删除头还是尾巴
        # 终止条件是 nums[0] * k >= nums[-1]
        n = len(nums)
        cnt = 0
        for i,x in enumerate(nums):
            j = bisect_right(nums, x * k)
            cnt = max(cnt, j - i)
        return n - cnt
```