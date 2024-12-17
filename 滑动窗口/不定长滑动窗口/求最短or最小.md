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